import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/bank_info_provider.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';

import 'no_data_screen.dart';



class CustomEditDialog extends StatefulWidget {
  _CustomEditDialogState createState() => _CustomEditDialogState();
}

class _CustomEditDialogState extends State<CustomEditDialog> {

  final TextEditingController _balanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<BankInfoProvider>(context, listen: false).getBankInfo(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
      child: Container(
        decoration: BoxDecoration(
          color: ColorResources.getBottomSheetColor(context),
          borderRadius: BorderRadius.only(
              topLeft:  Radius.circular(25),
              topRight: Radius.circular(25)),
        ),
        child: Consumer<BankInfoProvider>(
          builder: (context, bankProvider, child) => bankProvider.bankInfo != null ? Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                    child: Icon(Icons.keyboard_arrow_down)),
                SizedBox(height: 5,),
                Text(getTranslated('withdraw', context), style: TextStyle(fontSize: Dimensions.FONT_SIZE_LARGE, fontWeight: FontWeight.w500),),

                SizedBox(height: 5,),
                Container(width: 35, height: 35,
                    child: Image.asset(Images.bank)),
                SizedBox(height: 5,),
                Text(
                  '${bankProvider.bankInfo.bankName ?? getTranslated('no_data_found', context)}',
                  style: robotoTitleRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getTranslated('branch', context), style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA9A9A9))),
                    Text(
                      '${bankProvider.bankInfo.branch ?? getTranslated('no_data_found', context)}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA9A9A9)),
                      textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getTranslated('account_number', context), style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFFA9A9A9) )),
                    Text(
                      '${bankProvider.bankInfo.accountNo ?? getTranslated('no_data_found', context)}',
                      style: robotoTitleRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_DEFAULT),
                      textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                SizedBox(height: 20,),
                Text(getTranslated('enter_Amount', context), style: TextStyle(fontWeight: FontWeight.w500,fontSize: Dimensions.FONT_SIZE_DEFAULT),),

                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Provider.of<SplashProvider>(context, listen: false).myCurrency.symbol,
                        style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE_TWENTY)),
                    IntrinsicWidth(
                      child: TextField(
                        controller: _balanceController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: 'Ex: 500',
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset(Images.input_line),

                SizedBox(height: 35,),

                !Provider.of<ProfileProvider>(context).isLoading?
                InkWell(
                  onTap: () {
                    _updateUserAccount();
                  },
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      height: 40,
                      child: Center(
                        child: TextButton(
                            onPressed: (){
                              _updateUserAccount();
                            },
                            child: Text(getTranslated('withdraw', context),style: TextStyle(fontSize: Dimensions.FONT_SIZE_LARGE,fontWeight: FontWeight.w500,color: Colors.white))),
                      ),
                    ),
                  ),
                ): Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
              ],
            ),
          ): NoDataScreen(),
        ),
      ),
    );

  }

  void _updateUserAccount() async {
    String _balance = '0';
    double _bal = 0;
    _balance = _balanceController.text.trim();
    if(_balance.isNotEmpty){
       _bal = double.parse(_balance);
    }
    if (_balance.isEmpty) {
      showCustomSnackBar(getTranslated('enter_balance', context), context, isToaster: true);

    }else if(_bal > double.parse(PriceConverter.convertPriceWithoutSymbol(context, Provider.of<ProfileProvider>(context, listen: false).userInfoModel.wallet.totalEarning))) {
      showCustomSnackBar(getTranslated('insufficient_balance', context), context, isToaster: true);
    }else if(_bal <= 1 ) {
      showCustomSnackBar(getTranslated('minimum_amount', context), context, isToaster: true);
    }
    else {
      await Provider.of<ProfileProvider>(context, listen: false).updateBalance(_bal.toString(), context);
    }
  }
}
