
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/screens/delivery/widget/delivery_man_earning_list_view.dart';



class DeliveryManEarningViewAllScreen extends StatelessWidget {
  final DeliveryMan deliveryMan;
  const DeliveryManEarningViewAllScreen({Key key, this.deliveryMan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('earning_statement', context), isBackButtonExist: true),
        body: DeliverymanEarningListView(deliveryMan: deliveryMan));
  }
}
