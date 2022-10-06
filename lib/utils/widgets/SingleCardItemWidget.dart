import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';

class SingleItemCardWidget extends StatelessWidget {
  final bool showPricing;
  final String image;
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final dynamic price;
  final dynamic discountPrice;
  SingleItemCardWidget({
    this.showPricing,
    this.image,
    this.title,
    this.subTitle,
    this.onTap,
    this.price,
    @required this.discountPrice,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius:BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Get.theme.shadowColor,
              blurRadius: 10.0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 20),
        width: 172,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                        width: Get.width,
                        height: 120,
                        child: ClipRRect(
                           borderRadius: BorderRadius.circular(22.0),

                          child: FadeInImage(
                            image: NetworkImage(image),
                            placeholder: AssetImage('images/fcimg.png'),
                            fit: BoxFit.fitWidth,
                            imageErrorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Image.asset('images/fcimg.png');
                            },
                          ),
                        )),
                  ),
                  // showPricing
                  //     ? discountPrice != 0
                  //         ? Positioned(
                  //             bottom: 0,
                  //             right: 0,
                  //             child: Align(
                  //                 alignment: Alignment.topRight,
                  //                 child: ClipRRect(
                  //                   borderRadius: BorderRadius.only(
                  //                     topRight: Radius.circular(5),
                  //                   ),
                  //                   child: Container(
                  //                     color: Color(0xFFfb4611),
                  //                     padding: EdgeInsets.all(4),
                  //                     alignment: Alignment.center,
                  //                     child: Row(
                  //                       children: [
                  //                         Text(
                  //                           "$appCurrency${discountPrice.toString()}",
                  //                           style: Get.textTheme.subtitle2
                  //                               .copyWith(
                  //                             color: Colors.white,
                  //                             fontFamily: "DynaPuff"
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           width: 5,
                  //                         ),
                  //                         Text(
                  //                           "$appCurrency${price.toString()}",
                  //                           style: Get.textTheme.subtitle2
                  //                               .copyWith(
                  //                             color: Colors.white,
                  //                             decoration:
                  //                                 TextDecoration.lineThrough,
                  //                             decorationThickness: 2,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 )),
                  //           )
                  //         : Positioned(
                  //             bottom: 0,
                  //             right: 0,
                  //             child: Align(
                  //                 alignment: Alignment.bottomRight,
                  //                 child: ClipRRect(
                  //                   borderRadius: BorderRadius.only(
                  //                     topRight: Radius.circular(5),
                  //                   ),
                  //                   child: Container(
                  //                     color: Color(0xFFfb4611),
                  //                     padding: EdgeInsets.all(1),
                  //                     alignment: Alignment.center,
                  //                     margin: EdgeInsets.only(top: 50),
                  //                     child: double.parse(price.toString()) > 0
                  //                         ? Text(
                  //                             "$appCurrency ${price.toString()}",
                  //                             style: Get.textTheme.subtitle2
                  //                                 .copyWith(
                  //                                     color: Colors.white),
                  //                           )
                  //                         : Text(
                  //                            "فری",
                  //                             style: Get.textTheme.subtitle2
                  //                                 .copyWith(
                  //                                     color: Colors.white),
                  //                           ),
                  //                   ),
                  //                 )),
                  //           )
                  //     : Container(),
                ],
              ),
            ),
            Container(
              width: 900,
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                       title.length>10 ?
                        courseTitle(title):
                        courseTitle(title),
                        

                        Container(
                          // margin: EdgeInsets.only(left: 1),
                           color: Color(0xFFfb4611),
                           padding: title.length>10 ? EdgeInsets.all(1) : EdgeInsets.all(2),
                          child:
                          price==0?
                           Text('Free',style: TextStyle(color: Colors.white),)
                           :
                           Text('$appCurrency${price.toString()}',style: TextStyle(color: Colors.white,fontSize: 13),)

                        )

                        
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    courseTPublisher(subTitle),
                  ],
                )),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
