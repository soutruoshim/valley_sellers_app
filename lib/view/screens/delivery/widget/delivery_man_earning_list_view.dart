import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/delivery_man_earning_model.dart';
import 'package:sixvalley_vendor_app/provider/delivery_man_provider.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/base/order_shimmer.dart';
import 'package:sixvalley_vendor_app/view/screens/delivery/widget/earning_card.dart';
import 'package:sixvalley_vendor_app/data/model/response/top_delivery_man.dart';

class DeliverymanEarningListView extends StatelessWidget {
  final DeliveryMan deliveryMan;
  const DeliverymanEarningListView({Key key, this.deliveryMan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryManProvider>(
        builder: (context, earningProvider, child) {
          List<Earning> earningList = [];
          earningList = earningProvider.earningList;
          return earningList != null ? earningProvider.earningList.length > 0 ?
          RefreshIndicator(
            backgroundColor: Theme.of(context).primaryColor,
            onRefresh: () async {
              await earningProvider.getDeliveryManEarningListHistory(context, 1, deliveryMan.id );
            },
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: earningList.length,
              padding: EdgeInsets.all(0),
              itemBuilder: (context, index) =>
                  EarningCardWidget(earning: earningList[index], index: index,),
            ),
          ) : NoDataScreen(title: 'no_order_found',) : OrderShimmer(isEnabled: true);
        }
    );
  }
}
