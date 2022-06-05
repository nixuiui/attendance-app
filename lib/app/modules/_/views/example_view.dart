import 'package:attendance_app/app/modules/_/controllers/example_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExampleView extends GetView<ExampleController> {
  const ExampleView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Example Screen'),
        ),
        body: Text('Example Screen'),
      ),
    );
  }
}