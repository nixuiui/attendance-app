import 'package:attendance_app/app/modules/location_master/controllers/location_master_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nx_flutter_ui_starter_pack/nx_flutter_ui_starter_pack.dart';

class LocationMasterView extends GetView<LocationMasterController> {
  const LocationMasterView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    controller.init();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Location Master'),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                padding: EdgeInsets.all(16),
                separatorBuilder: (_, __) => SizedBox(height: 16), 
                itemBuilder: (_, __) => NxBox(
                  padding: EdgeInsets.all(16),
                  borderRadius: 8,
                  borderColor: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NxText.lead1('Kantor Google'),
                      NxText.body1('Jl. Imam Bonjo, Bandar Lampung'),
                      NxText.small1('-123213.343, 1.2321312'),
                    ],
                  ),
                ), 
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NxButton.primary(
                onPressed: () {},
                child: NxText('Add Location', color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}