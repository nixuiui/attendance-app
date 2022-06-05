import 'package:flutter/material.dart';
import 'package:nx_flutter_ui_starter_pack/nx_flutter_ui_starter_pack.dart';

import '../../../../helpers/debouncer.dart';
import '../../../models/auto_complete_prediction.dart';
import '../../../models/place_detail.dart';

class BottomSheetLocationPicker extends StatefulWidget {
  final double? height;
  final bool isLoading;
  final bool isPlaceDetailLoading;
  final bool isBottomSheetFullScreen;
  final List<PlaceDetail>? placeHistories;
  final List<AutoCompletePrediction>? placeList;
  final PlaceDetail? placeDetail;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String)? onSearch;
  final Function(String)? onPlaceSelected;
  final Function(String)? deleteHistory;
  final VoidCallback? onLocationSelected;
  final VoidCallback? closeSheet;

  const BottomSheetLocationPicker({
    Key? key,
    this.height,
    this.controller,
    this.focusNode,
    this.onSearch,
    this.onLocationSelected,
    this.placeHistories,
    this.placeList,
    this.placeDetail,
    this.onPlaceSelected,
    this.deleteHistory,
    this.closeSheet,
    this.isBottomSheetFullScreen = false,
    this.isPlaceDetailLoading = false,
    this.isLoading = false
  }) : super(key: key);

  @override
  _BottomSheetLocationPickerState createState() =>
      _BottomSheetLocationPickerState();
}

class _BottomSheetLocationPickerState extends State<BottomSheetLocationPicker> with TickerProviderStateMixin {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        alignment: Alignment.bottomCenter,
        vsync: this,
        child: Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _biuldSearchBar(),
              Divider(height: 0, color: Colors.grey[300]),
              Expanded(
                child: Builder(builder: (context) {
                  if (widget.placeDetail != null) return _buildConfirmation();
                  if (widget.isLoading || widget.isPlaceDetailLoading) {
                    return Center(child: NxLoadingSpinner());
                  }
                  if (
                    !widget.isLoading &&
                    widget.controller?.text == '' &&
                    (widget.placeList?.isEmpty ?? true)
                  ) {
                    if (widget.placeHistories?.isNotEmpty ?? false) {
                      return _buildPlaceHistories(widget.placeHistories!, true);
                    } else {
                      return Center(
                        child: NxText('You can search any place', color: Colors.grey[300])
                      );
                    }
                  }
                  return _buildPlaceSugestion(widget.placeList!, false);
                }),
              )
            ],
          )
        ),
      ),
    );
  }

  Widget _buildConfirmation() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: widget.isPlaceDetailLoading ? Center(child: NxLoadingSpinner()) : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.placeDetail?.name != null) NxText.headline6(
                  widget.placeDetail!.name!,
                  maxLines: 4,
                ),
                if(widget.placeDetail?.formattedAddress != null) NxText.body1(
                  widget.placeDetail!.formattedAddress!,
                  maxLines: 4,
                ),
              ],
            ),
          ),
          widget.isPlaceDetailLoading ? SizedBox.shrink() : NxButton.primary(
            child: NxText(
              "Select Here",
              color: Colors.white,
            ),
            onPressed: widget.onLocationSelected?.call
          )
        ],
      ),
    );
  }

  Widget _buildPlaceSugestion(
    List<AutoCompletePrediction> list,
    bool isHistory,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: list.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) => _buildPlaceListItem(
        title: list[index].structuredFormatting?.mainText,
        address: list[index].structuredFormatting?.secondaryText,
        placeId: list[index].placeId,
        isHistory: false,
      ),
    );
  }

  Widget _buildPlaceHistories(
    List<PlaceDetail> list,
    bool isHistory,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) => _buildPlaceListItem(
        title: list[index].name ?? list[index].addressComponents?[0].longName,
        address: list[index].formattedAddress,
        placeId: list[index].placeId,
        isHistory: true,
      ),
    );
  }

  Widget _buildPlaceListItem({
    String? title,
    String? address,
    String? placeId,
    bool isHistory = false,
  }) {
    return NxBox(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onPressed: widget.onPlaceSelected != null 
          ? () => widget.onPlaceSelected?.call(placeId ?? '') 
          : null,
      child: Row(
        children: [
          Icon(
            isHistory ? Icons.alarm : Icons.location_pin,
            size: 24, 
            color: Colors.grey[400]
          ),
          SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NxText.title(title ?? ''),
                  NxText.small1(address ?? ''),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.cancel, size: 18, color: Colors.grey[400]),
            onPressed: widget.deleteHistory != null 
                ? () => widget.deleteHistory?.call(placeId ?? '')
                : null,
          )
        ],
      ),
    );
  }

  Container _biuldSearchBar() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          widget.isBottomSheetFullScreen ? GestureDetector(
            onTap: widget.closeSheet?.call,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.expand_more,
                    size: 20,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 8),
                  Expanded(child: NxText.subtitle(
                    "Select location",
                    color: Colors.black54,
                  )),
                ],
              ),
            ),
          ) : Container(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFEEEEEE)),
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(50)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        onFieldSubmitted: widget.onSearch,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Search here',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500]
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          _debouncer.run(() {
                            widget.onSearch?.call(value);
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => widget.onSearch?.call(widget.controller?.text ?? ''),
                      child: Icon(
                        Icons.search,
                        color: Colors.black54,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
