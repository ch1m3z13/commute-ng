import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../../widgets/shared_widgets.dart';

enum TransactionType { credit, debit }

class RiderWalletScreen extends StatelessWidget {
  const RiderWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 200,
            backgroundColor: AppColors.slate900,
            foregroundColor: AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.slate900,
                      AppColors.slate800,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.slate400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₦${NumberFormat('#,##0', 'en_US').format(provider.walletBalance)}',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                text: 'Top Up',
                                variant: ButtonVariant.accent,
                                onPressed: () {
                                  provider.topUpWallet(5000);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Wallet topped up successfully!',
                                      ),
                                      backgroundColor: AppColors.emerald600,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AppButton(
                                text: 'Withdraw',
                                variant: ButtonVariant.glass,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate800,
                  ),
                ),
                const SizedBox(height: 16),
                ...provider.transactions.map((transaction) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.slate100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: transaction.type == TransactionType.credit
                                ? AppColors.emerald100
                                : AppColors.red50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            transaction.type == TransactionType.credit
                                ? Icons.add
                                : Icons.trending_down,
                            color: transaction.type == TransactionType.credit
                                ? AppColors.emerald600
                                : AppColors.red500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                transaction.date,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.slate500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${transaction.type == TransactionType.credit ? '+' : ''}₦${NumberFormat('#,##0', 'en_US').format(transaction.amount.abs())}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: transaction.type == TransactionType.credit
                                ? AppColors.emerald600
                                : AppColors.slate900,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}