import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/shop_info_provider.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/screens/shop/shop_update_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/shop/widget/shop_banner_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/shop/widget/shop_information_widget.dart';

class ShopScreen extends StatefulWidget {
  ShopScreen({Key key});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String sellerId = '0';


  @override
  Widget build(BuildContext context) {
    Provider.of<ShopProvider>(context, listen: false).selectedIndex;
    sellerId = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id.toString();
    Provider.of<ShopProvider>(context, listen: false).getShopInfo(context);
    return Scaffold(
        appBar: CustomAppBar(title : getTranslated('my_shop', context)),
        body: Consumer<ShopProvider>(
            builder: (context, resProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: ThemeShadow.getShadow(context),
                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)
                  ),
                  child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min,children: [
                      ShopBannerWidget(resProvider: resProvider),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                      ShopInformationWidget(resProvider: resProvider),


                    ],),
                  ),
                ),
              );
            }),
      
      bottomNavigationBar: Container(height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: ThemeShadow.getShadow(context)
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: CustomButton(btnTxt: getTranslated('edit_shop_info', context),
            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShopUpdateScreen()))),
        ),
      ),

    );
  }
}

