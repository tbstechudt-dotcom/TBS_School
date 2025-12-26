import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/notification_model.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ref.read(notificationActionsProvider.notifier).markAllAsRead();
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(notificationsProvider),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSizes.s4),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.s2),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationCard(
                notification: notification,
                onTap: () {
                  if (!notification.isRead) {
                    ref.read(notificationActionsProvider.notifier).markAsRead(notification.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.gray100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_rounded,
                size: 48,
                color: AppColors.gray400,
              ),
            ),
            const SizedBox(height: AppSizes.s6),
            const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: AppSizes.textLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.s2),
            const Text(
              'You\'re all caught up! Check back later for updates.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSizes.textSm,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: notification.isRead ? AppColors.bgPrimary : AppColors.primary50,
      borderRadius: BorderRadius.circular(AppSizes.roundedXl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.roundedXl),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.s4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.roundedXl),
            border: Border.all(
              color: notification.isRead ? AppColors.border : AppColors.primary200,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getTypeColor(notification.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.roundedLg),
                ),
                child: Icon(
                  _getTypeIcon(notification.type),
                  color: _getTypeColor(notification.type),
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSizes.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: AppSizes.textSm,
                        fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s1),
                    Text(
                      notification.body,
                      style: const TextStyle(
                        fontSize: AppSizes.textXs,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.s2),
                    Text(
                      Formatters.relativeTime(notification.createdAt),
                      style: const TextStyle(
                        fontSize: AppSizes.textXs,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.feeReminder:
        return AppColors.warning;
      case NotificationType.paymentSuccess:
        return AppColors.success;
      case NotificationType.paymentFailed:
        return AppColors.error;
      case NotificationType.dueDateApproaching:
        return AppColors.warning;
      case NotificationType.newFeeAdded:
        return AppColors.info;
      case NotificationType.general:
        return AppColors.primary;
      case NotificationType.announcement:
        return AppColors.info;
      case NotificationType.alert:
        return AppColors.error;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.feeReminder:
        return Icons.notification_important_rounded;
      case NotificationType.paymentSuccess:
        return Icons.check_circle_rounded;
      case NotificationType.paymentFailed:
        return Icons.error_rounded;
      case NotificationType.dueDateApproaching:
        return Icons.schedule_rounded;
      case NotificationType.newFeeAdded:
        return Icons.add_circle_rounded;
      case NotificationType.general:
        return Icons.notifications_rounded;
      case NotificationType.announcement:
        return Icons.campaign_rounded;
      case NotificationType.alert:
        return Icons.warning_rounded;
    }
  }
}
