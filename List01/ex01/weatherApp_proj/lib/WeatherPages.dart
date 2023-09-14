import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';


class WeatherPages extends StatelessWidget{
  final void Function(int) _selectPage;
  final String? searchText;
  final PageController _pageController;

  WeatherPages(this._selectPage, this._pageController, this.searchText);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double size = height < width ? height : width;
    double fontTextSize = size * 0.1;
    double maxFont = 100;
    double minFont = 10;

    List<Widget> pages = [
      Center(child: 
        Column(mainAxisAlignment: 
          MainAxisAlignment.center, 
          children: [
            Text("CURRENTLY", style: TextStyle(fontSize: fontTextSize)),
            (searchText == null ?
              const Text("") :
              AutoSizeText(searchText.toString(),
                maxFontSize: maxFont,
                minFontSize: minFont,
                maxLines: 1,
                style: TextStyle(fontSize: fontTextSize),
              )
            )
          ],
        )
      ),
      Center(child: 
        Column(mainAxisAlignment: 
          MainAxisAlignment.center, 
          children: [
            Text("TODAY", style: TextStyle(fontSize: fontTextSize)),
            (searchText == null ?
              const Text("") :
              AutoSizeText(searchText.toString(),
                maxFontSize: maxFont,
                minFontSize: minFont,
                maxLines: 1,
                style: TextStyle(fontSize: fontTextSize),
              )
            )
          ],
        ) 
      ),
      Center(child: 
        Column(mainAxisAlignment: 
          MainAxisAlignment.center, 
          children: [
            Text("WEEKLY", style: TextStyle(fontSize: fontTextSize)),
            (searchText == null ?
              const Text("") :
              AutoSizeText(searchText.toString(),
                maxFontSize: maxFont,
                minFontSize: minFont,
                maxLines: 1,
                style: TextStyle(fontSize: fontTextSize),
              )
            )
          ],
        )
      ),
    ];

    return  PageView(
      controller: _pageController,
      onPageChanged: _selectPage,
      children: pages,
    );
  }
}