import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenView extends StatefulWidget {
  final List<dynamic> imagesList;
  const FullScreenView({
    super.key,
    required this.imagesList,
  });

  @override
  _FullScreenViewState createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  final PageController _controller = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.lightBlue,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: Text(
          ('${index + 1}') + ('/') + (widget.imagesList.length.toString()),
          style: const TextStyle(fontSize: 25, letterSpacing: 8),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: size.height * 0.5,
                child: PageView(
                  onPageChanged: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  controller: _controller,
                  children: images(),
                ),
              ),
              SizedBox(
                height: size.height * 0.2,
                child: imageView(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget imageView() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imagesList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _controller.jumpToPage(index);
            },
            child: Container(
                margin: const EdgeInsets.all(8),
                width: 120,
                decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.lightBlueAccent),
                    borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imagesList[index],
                    fit: BoxFit.cover,
                  ),
                )),
          );
        });
  }

  List<Widget> images() {
    return List.generate(widget.imagesList.length, (index) {
      return InteractiveViewer(
          transformationController: TransformationController(),
          child: Image.network(widget.imagesList[index].toString()));
    });
  }
}
