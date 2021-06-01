// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_viruses/helper/session.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_viruses/pages/added/gallery.dart';
import 'package:video_player/video_player.dart';
import 'package:easy_localization/easy_localization.dart';

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  //через что воспроизводит
  VideoPlayerController _videoPlayerController;
  //видеоплеер для флаттера
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }
  
  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(Session.shared.detailVirus.videoLink);
    await Future.wait([
      _videoPlayerController.initialize()
    ]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                Container(
                  width: 165,
                  height: 165, 
                  child: GestureDetector(
                    child: 
                    Container(
                        width: 160,
                        height: 160,
                        decoration: new BoxDecoration (
                          image: new DecorationImage(
                            image: new NetworkImage(
                              Session.shared.detailVirus.photoLink,
                            ),
                            fit: BoxFit.cover
                          ),
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(80)
                          ),
                          border: new Border.all(
                            color: Theme.of(context).hintColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: Session.shared.detailVirus.fullName + " : " + Session.shared.detailVirus.domain,                
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: new BorderSide(color: Colors.grey),
                    )
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: Session.shared.detailVirus.country + ", " + Session.shared.detailVirus.continent,                
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: new BorderSide(color: Colors.grey),
                    )
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: Session.shared.detailVirus.year + ", " + Session.shared.detailVirus.mortality,                
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: new BorderSide(color: Colors.grey),
                    )
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 230,
                  width: size.width * 0.9,
                  child: Expanded(
                    child: Center(
                      child: _chewieController != null &&
                          _chewieController
                              .videoPlayerController.value.isInitialized
                          ? Chewie(
                        controller: _chewieController,
                      )
                          : Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                MaterialButton(
                  onPressed: () { 
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Gallery()));
                  },
                  height: 55,
                  minWidth: double.infinity,
                  color: Color(0xFF34972E),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(),
                  ),
                  child: Text(
                    "detailShowGallary".tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),  
                ),
              ]),
            )
          ),
        ),
      );
  }
}