
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [

          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.red,
            child: Stack(
              children:[
                ClipOval(
                  child:image !=null? Image.file(image!,
                    fit: BoxFit.cover,
                    width: 200,height: 200,):CircleAvatar(
                    radius: 50,
                  ),
                ),
                Positioned(right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.red,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: CupertinoColors.white,
                     child:GestureDetector(
                       onTap: (){
                         showImageSource();
                       },
                         child: Icon(CupertinoIcons.camera)),
                    ),
                  ),
                ),]
            ),

          ),
          const Text("Images Picker",style: TextStyle(color: Colors.black,fontSize: 40,fontWeight: FontWeight.bold),)
         , const SizedBox(
            height: 40,
          ),
          InkWell(
            onTap: (){
              pickImage(ImageSource.gallery);
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: ListTile(
                tileColor: CupertinoColors.white,
                leading: CircleAvatar(
                  child: Icon(Icons.image),
                ),
                title: Text("Pick Gallery",style: TextStyle(color: Colors.black,fontSize: 25),),
              ),
            ),
          ),
          SizedBox(height: 30,),
          InkWell(
            onTap: (){
              pickImage(ImageSource.camera);
            },
            child: const Padding(
              padding:  EdgeInsets.only(left: 20,right: 20),
              child: ListTile(
                tileColor: CupertinoColors.white,
                leading: CircleAvatar(
                  child: Icon(Icons.camera_alt),
                ),
                title: Text("Pick camera",style: TextStyle(color: Colors.black,fontSize: 25),),
              ),
            ),
          ),


        ],
      ),
    );
  }

  Future pickImage(ImageSource source)async{
    final  image =await ImagePicker().pickImage(source:source);
    if(image == null)
      return ;
    // final imageTemporary = File(image!.path);
    final imageTemporary = await  saveImagePermanently(image.path);
    setState(() {
      this.image=imageTemporary;
    });
  }
 Future<File>saveImagePermanently(String imagePath)async{
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    print("==================================================================");
    print(name);
    final image = File("${directory.path}/$name");
    return File(imagePath).copy(image.path);
 }

  Future<ImageSource?>showImageSource()async{
    if(Platform.isAndroid){
      return showCupertinoModalPopup(context: this.context, builder:(context){
        return
      CupertinoActionSheet(

        actions: [
          CupertinoActionSheetAction(
      child: Text("Camera"),
        onPressed: (){
          pickImage(ImageSource.camera);
        Navigator.of(context).pop(ImageSource.camera);
        },
        ),
          CupertinoActionSheetAction(
            child: Text("Gallery"),
            onPressed: (){
              pickImage(ImageSource.gallery);
              Navigator.of(context).pop(ImageSource.gallery);
            },
          )
        ],
      );
      } );
    }
    return showModalBottomSheet(context:this.context, builder:(context)=>
    Container(
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Camera"),
            onTap: (){
              Navigator.of(context).pop(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Gallery"),
            onTap: (){
              Navigator.of(context).pop(ImageSource.gallery);
            },
          ),
        ],
      ),
    )
    );
  }
}
