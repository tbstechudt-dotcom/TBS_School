import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const { Pool } = pg;

// Local PostgreSQL connection
const localPool = new Pool({
  host: process.env.LOCAL_DB_HOST,
  port: parseInt(process.env.LOCAL_DB_PORT),
  database: process.env.LOCAL_DB_NAME,
  user: process.env.LOCAL_DB_USER,
  password: process.env.LOCAL_DB_PASSWORD,
});

// Supabase PostgreSQL connection (via Transaction Pooler)
const supabasePool = new Pool({
  host: process.env.SUPABASE_DB_HOST,
  port: parseInt(process.env.SUPABASE_DB_PORT),
  database: process.env.SUPABASE_DB_NAME,
  user: process.env.SUPABASE_DB_USER,
  password: process.env.SUPABASE_DB_PASSWORD,
  ssl: { rejectUnauthorized: false },
});

// Tables in order of dependencies (tables with no FK first)
const TABLES_ORDER = [
  'currency',
  'institutiontype',
  'year',
  'concessioncategory',
  'paymentgateway',
  'payment',
  'shoppingcart',
  'modules',
  'institutionyear',
  'parentdetail',
  'country',
  'state',
  'city',
  'institution',
  'custuserroles',
  'staffdesignation',
  'institutionusers',
  'activitytype',
  'sequence',
  'parents',
  'students',
  'feedemand',
  'shoppingcartdetails',
];

const isDryRun = process.argv.includes('--dry-run');

async function getTableData(tableName) {
  try {
    const result = await localPool.query(`SELECT * FROM public.${tableName}`);
    return result.rows;
  } catch (error) {
    console.error(`  [ERROR] Reading ${tableName}: ${error.message}`);
    return [];
  }
}

async function clearTable(tableName) {
  try {
    await supabasePool.query(`DELETE FROM public.${tableName}`);
    return true;
  } catch (error) {
    console.warn(`  [WARN] Could not clear ${tableName}: ${error.message}`);
    return false;
  }
}

async function syncTable(tableName, data) {
  if (data.length === 0) {
    console.log(`  [SKIP] ${tableName}: No data to sync`);
    return { success: true, count: 0 };
  }

  if (isDryRun) {
    console.log(`  [DRY-RUN] ${tableName}: Would sync ${data.length} rows`);
    return { success: true, count: data.length };
  }

  try {
    // Clear existing data first
    await clearTable(tableName);

    // Get column names from the first row
    const columns = Object.keys(data[0]);
    const columnList = columns.map(c => `"${c}"`).join(', ');

    let insertedCount = 0;

    // Insert data row by row with OVERRIDING SYSTEM VALUE for identity columns
    for (const row of data) {
      const values = columns.map((_, i) => `$${i + 1}`).join(', ');
      const rowValues = columns.map(col => row[col]);

      try {
        await supabasePool.query(
          `INSERT INTO public.${tableName} (${columnList}) OVERRIDING SYSTEM VALUE VALUES (${values})`,
          rowValues
        );
        insertedCount++;
      } catch (insertError) {
        // Try without OVERRIDING SYSTEM VALUE
        try {
          await supabasePool.query(
            `INSERT INTO public.${tableName} (${columnList}) VALUES (${values})`,
            rowValues
          );
          insertedCount++;
        } catch (retryError) {
          console.error(`    [ROW ERROR] ${retryError.message}`);
        }
      }
    }

    console.log(`  [OK] ${tableName}: Synced ${insertedCount}/${data.length} rows`);
    return { success: true, count: insertedCount };
  } catch (error) {
    console.error(`  [ERROR] ${tableName}: ${error.message}`);
    return { success: false, count: 0, error: error.message };
  }
}

async function resetSequence(tableName, idColumn) {
  try {
    const result = await supabasePool.query(
      `SELECT COALESCE(MAX("${idColumn}"), 0) + 1 as next_val FROM public.${tableName}`
    );
    const nextVal = result.rows[0].next_val;

    // Find and reset the sequence
    const seqResult = await supabasePool.query(`
      SELECT pg_get_serial_sequence('public.${tableName}', '${idColumn}') as seq_name
    `);

    if (seqResult.rows[0]?.seq_name) {
      await supabasePool.query(`SELECT setval('${seqResult.rows[0].seq_name}', ${nextVal}, false)`);
      console.log(`  ${tableName}: Sequence reset to ${nextVal}`);
    }
  } catch (error) {
    // Ignore sequence reset errors
  }
}

async function main() {
  console.log('='.repeat(60));
  console.log('  TBS School Database Full Sync Tool');
  console.log('='.repeat(60));
  console.log(`Mode: ${isDryRun ? 'DRY RUN (no changes will be made)' : 'LIVE SYNC'}`);
  console.log('');
  console.log('Local DB:');
  console.log(`  Host: ${process.env.LOCAL_DB_HOST}:${process.env.LOCAL_DB_PORT}`);
  console.log(`  Database: ${process.env.LOCAL_DB_NAME}`);
  console.log('');
  console.log('Supabase DB:');
  console.log(`  Host: ${process.env.SUPABASE_DB_HOST}:${process.env.SUPABASE_DB_PORT}`);
  console.log(`  Database: ${process.env.SUPABASE_DB_NAME}`);
  console.log('='.repeat(60));

  // Test local connection
  try {
    await localPool.query('SELECT 1');
    console.log('[OK] Connected to Local PostgreSQL');
  } catch (error) {
    console.error('[ERROR] Cannot connect to Local PostgreSQL:', error.message);
    process.exit(1);
  }

  // Test Supabase connection
  try {
    await supabasePool.query('SELECT 1');
    console.log('[OK] Connected to Supabase PostgreSQL');
  } catch (error) {
    console.error('[ERROR] Cannot connect to Supabase:', error.message);
    console.log('\nPlease check your SUPABASE_DB_PASSWORD in .env file');
    process.exit(1);
  }

  console.log('\n--- Starting Full Sync ---\n');

  const results = {
    success: [],
    failed: [],
    skipped: [],
  };

  // Identity columns for sequence reset
  const identityColumns = {
    currency: 'cur_id',
    institutiontype: 'it_id',
    year: 'yr_id',
    paymentgateway: 'gw_id',
    payment: 'pay_id',
    shoppingcart: 'car_id',
    modules: 'mod_id',
    institutionyear: 'iyr_id',
    parentdetail: 'pd_id',
    country: 'cou_id',
    state: 'sta_id',
    city: 'cit_id',
    institution: 'ins_id',
    custuserroles: 'ur_id',
    staffdesignation: 'des_id',
    institutionusers: 'use_id',
    activitytype: 'act_id',
    sequence: 'seq_id',
    parents: 'par_id',
    students: 'stu_id',
    feedemand: 'dem_id',
    shoppingcartdetails: 'cd_id',
  };

  for (const tableName of TABLES_ORDER) {
    console.log(`Syncing: ${tableName}`);

    const data = await getTableData(tableName);
    const result = await syncTable(tableName, data);

    if (result.count === 0) {
      results.skipped.push(tableName);
    } else if (result.success) {
      results.success.push({ table: tableName, count: result.count });

      // Reset sequence after successful sync
      if (!isDryRun && identityColumns[tableName]) {
        await resetSequence(tableName, identityColumns[tableName]);
      }
    } else {
      results.failed.push({ table: tableName, error: result.error });
    }
  }

  // Summary
  console.log('\n' + '='.repeat(60));
  console.log('  FULL SYNC SUMMARY');
  console.log('='.repeat(60));

  console.log(`\nSuccessful: ${results.success.length} tables`);
  results.success.forEach(r => console.log(`  - ${r.table}: ${r.count} rows`));

  console.log(`\nSkipped (no data): ${results.skipped.length} tables`);
  results.skipped.forEach(t => console.log(`  - ${t}`));

  if (results.failed.length > 0) {
    console.log(`\nFailed: ${results.failed.length} tables`);
    results.failed.forEach(r => console.log(`  - ${r.table}: ${r.error}`));
  }

  const totalRows = results.success.reduce((sum, r) => sum + r.count, 0);
  console.log('\n' + '='.repeat(60));
  console.log(`  Total rows synced: ${totalRows}`);
  console.log('  Full Sync completed!');
  console.log('='.repeat(60));

  await localPool.end();
  await supabasePool.end();
  process.exit(0);
}

main().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});
