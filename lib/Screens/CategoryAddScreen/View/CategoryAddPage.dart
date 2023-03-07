import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quotes/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:quotes/Utils/DBHelper/CategoryDatabase.dart';
import 'package:sizer/sizer.dart';

class CategoryAddPage extends StatefulWidget {
  const CategoryAddPage({Key? key}) : super(key: key);

  @override
  State<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    // homeController.Tabindex.value = 0;
    homeController.GetData();
    homeController.GetData2();

    if(homeController.CategoryList.isNotEmpty)
    {
      homeController.DropdownValue.value = homeController.CategoryList[0].Category!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
            () => Form(
          key: homeController.key.value,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: Get.height / 18,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.only(left: Get.width / 21, right: Get.width / 21, top:  Get.height / 90),
                  padding: EdgeInsets.only(left: Get.width/21),
                  child: TextFormField(
                    controller: homeController.txtAddCategory.value,
                    style: GoogleFonts.lobster(),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Quotes Category Required*",
                      // prefix: Container(),
                      // prefixIconColor: Colors.black,
                      hintStyle: GoogleFonts.lobster(),
                    ),
                    validator: (value) {
                      if(value!.isEmpty)
                      {
                        return "Required* Please Add This Value";
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  height: Get.height/4.3,
                  width: Get.height/4.3,
                  // color: Colors.yellow,
                  margin: EdgeInsets.only(top: Get.height/60),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: Get.height/5,
                          width: Get.height/5,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                          ),
                          alignment: Alignment.center,
                          child: Obx(() => homeController.imagePath.isEmpty
                              ? Text("Required*",style: GoogleFonts.lobster(color: Colors.black,fontSize: 15.sp),)
                              : CircleAvatar(
                            radius: Get.height/5,
                            backgroundImage: FileImage(File("${homeController.imagePath}"),
                            ),
                          )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: (){
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: Get.height/6,
                                  padding: EdgeInsets.only(left: Get.width/30,),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: Get.height/60),
                                        child: Text(
                                          "Choose Any One",
                                          style: GoogleFonts.lobster(
                                              color: Colors.black,
                                              fontSize: 15.sp
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: Get.height/40),
                                        child: Row(
                                          children: [
                                            IconButton(onPressed: () async {
                                              ImagePicker imagePicker = ImagePicker();
                                              XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
                                              homeController.imagePath.value = image!.path;
                                            }, icon: Icon(Icons.camera_enhance_outlined,color: Colors.black,)),
                                            SizedBox(width: Get.width/21,),
                                            IconButton(onPressed: () async {
                                              ImagePicker imagePicker = ImagePicker();
                                              XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
                                              homeController.imagePath.value = image!.path;
                                            }, icon: Icon(Icons.image_outlined,color: Colors.black,)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: Get.height/18,
                            width: Get.height/18,
                            margin: EdgeInsets.only(right: Get.width/18,bottom: Get.height/60),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0,0),
                                      blurRadius: 6
                                  )
                                ],
                                shape: BoxShape.circle,
                                color: Colors.black
                            ),
                            alignment: Alignment.center,
                            child: Icon(Icons.camera_alt_outlined,color: Colors.white,size: 21.sp,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if(homeController.key.value.currentState!.validate() && (homeController.imagePath.value.isNotEmpty))
                    {
                      // if(homeController.CategoryList.isEmpty)
                      // {
                      //   homeController.DropdownValue.value = homeController.txtAddCategory.value.text;
                      // }
                      // print("=========== ${homeController.txtAddCategory.value.text} ${homeController.imagePath}");
                      // homeController.CategoryList.clear();
                      // for(int i=0; i<homeController.CategoryList.length; i++)
                      //   {
                      //     if(homeController.CategoryList[i].Category == homeController.txtAddCategory.value.text)
                      //     {
                      //       Get.snackbar("Alert", "This Category Is Available");
                      //       break;
                      //     }
                      //     else
                      //       {
                      //         CategoryDatabse.categoryDatabse.InsertDatabase(Category: homeController.txtAddCategory.value.text,image: homeController.imagePath.value);
                      //       }
                      //   }
                      CategoryDatabse.categoryDatabse.InsertDatabase(Category: homeController.txtAddCategory.value.text,image: homeController.imagePath.value);
                      homeController.CategoryList.value = await CategoryDatabse.categoryDatabse.ReadDatabase();
                      homeController.GetData();
                      homeController.key.value.currentState!.reset();
                      homeController.imagePath.value = "";
                      Get.back();
                    }
                    else
                    {
                      Get.snackbar('Alert', "Please Add Your Data");
                    }
                  },
                  child: Container(
                      height: Get.height / 18,
                      width: Get.width / 2.1,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(30)),
                      margin: EdgeInsets.only(left: Get.width / 21, right: Get.width / 21, top:  Get.height / 30),
                      alignment: Alignment.center,
                      child: Text(
                        "Add Category",
                        style: GoogleFonts.lobster(
                            fontSize: 15.sp,
                            color: Colors.black
                        ),
                      )
                  ),
                ),
                //  GestureDetector(
                //    onTap: () {
                //      homeController.GetData();
                //    },
                //    child: Container(
                //      height: Get.height / 18,
                //      width: Get.width / 2.1,
                //      decoration: BoxDecoration(
                //          color: Colors.grey.shade300,
                //          borderRadius: BorderRadius.circular(30)),
                //      margin: EdgeInsets.only(left: Get.width / 21, right: Get.width / 21, top:  Get.height / 30),
                //      alignment: Alignment.center,
                //      child: Text(
                //        "Add Category",
                //        style: GoogleFonts.lobster(
                //          fontSize: 15.sp,
                //          color: Colors.black
                //        ),
                //      )
                //    ),
                //  ),
                //  Container(
                //    height: Get.height/4.3,
                //    width: Get.height/4.3,
                //    // color: Colors.yellow,
                //    margin: EdgeInsets.only(top: Get.height/60),
                //    child: Stack(
                //      children: [
                //        Align(
                //          alignment: Alignment.center,
                //          child: Container(
                //            height: Get.height/5,
                //            width: Get.height/5,
                //            decoration: BoxDecoration(
                //                color: Colors.red,
                //                shape: BoxShape.circle
                //            ),
                //            alignment: Alignment.center,
                //            child: Obx(() => homeController.CategoryList.isEmpty
                //                ? Text("Not Required",style: GoogleFonts.lobster(color: Colors.black,fontSize: 15.sp),)
                //                : CircleAvatar(
                //              radius: Get.height/5,
                //              backgroundImage: MemoryImage(homeController.CategoryList[0].image!),
                //            ),),
                //          ),
                //        ),
                //        Align(
                //          alignment: Alignment.bottomRight,
                //          child: GestureDetector(
                //            onTap: (){
                //              showModalBottomSheet(
                //                context: context,
                //                builder: (context) {
                //                  return Container(
                //                    height: Get.height/6,
                //                    padding: EdgeInsets.only(left: Get.width/30,),
                //                    child: Column(
                //                      crossAxisAlignment: CrossAxisAlignment.start,
                //                      children: [
                //                        Padding(
                //                          padding: EdgeInsets.only(top: Get.height/60),
                //                          child: Text(
                //                            "Choose Any One",
                //                            style: GoogleFonts.lobster(
                //                                color: Colors.black,
                //                                fontSize: 15.sp
                //                            ),
                //                          ),
                //                        ),
                //                        Padding(
                //                          padding: EdgeInsets.only(top: Get.height/40),
                //                          child: Row(
                //                            children: [
                //                              IconButton(onPressed: () async {
                //                                ImagePicker imagePicker = ImagePicker();
                //                                XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
                //                                homeController.imagePath.value = image!.path;
                //                              }, icon: Icon(Icons.camera_enhance_outlined,color: Colors.black,)),
                //                              SizedBox(width: Get.width/21,),
                //                              IconButton(onPressed: () async {
                //                                ImagePicker imagePicker = ImagePicker();
                //                                XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
                //                                homeController.imagePath.value = image!.path;
                //                              }, icon: Icon(Icons.image_outlined,color: Colors.black,)),
                //                            ],
                //                          ),
                //                        )
                //                      ],
                //                    ),
                //                  );
                //                },
                //              );
                //            },
                //            child: Container(
                //              height: Get.height/18,
                //              width: Get.height/18,
                //              margin: EdgeInsets.only(right: Get.width/18,bottom: Get.height/60),
                //              decoration: BoxDecoration(
                //                  boxShadow: [
                //                    BoxShadow(
                //                        color: Colors.grey,
                //                        offset: Offset(0,0),
                //                        blurRadius: 6
                //                    )
                //                  ],
                //                  shape: BoxShape.circle,
                //                  color: Colors.black
                //              ),
                //              alignment: Alignment.center,
                //              child: Icon(Icons.camera_alt_outlined,color: Colors.white,size: 21.sp,),
                //            ),
                //          ),
                //        )
                //      ],
                //    ),
                //  ),
                //  Obx(() =>  Text(
                //   "${homeController.CategoryList.isEmpty ? "Not Allow" : homeController.CategoryList[0].Category!}",
                //   style: GoogleFonts.lobster(
                //       color: Colors.black,
                //       fontSize: 15.sp
                //   ),
                // ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
