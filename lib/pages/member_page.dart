import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_barrage/flutter_barrage.dart';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChewieDemo extends StatefulWidget {
  ChewieDemo({this.title = 'Chewie Demo'});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network('https://yj.yongjiu6.com/20180123/hGBmobcu/index.m3u8');
    _videoPlayerController2 = VideoPlayerController.network('https://yj.yongjiu6.com/20180123/hGBmobcu/index.m3u8');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barrageWallController = BarrageWallController();
    List<Bullet> bullets = List<Bullet>.generate(100, (i) {
      Random random = new Random();
      final showTime = random.nextInt(60000); // in 60s
      return Bullet(child: Text('$i-$showTime}'), showTime: showTime);
    });
    return MaterialApp(
      title: widget.title,
      theme: ThemeData.light().copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                  Container(
                    child: BarrageWall(
                      debug: false, // show debug panel
                      speed: 4, // speed of bullet show in screen (seconds)
                      /*
                timelineNotifier: timelineNotifier, // send a BarrageValue notifier let bullet fires using your own timeline*/
                      bullets: bullets,
                      child: new Container(
                        height: ScreenUtil().setHeight(350),
                      ),
                      controller: barrageWallController,
                    ),
                  )
                ],
              ),
            ),
            FlatButton(
              onPressed: () {
                _chewieController.enterFullScreen();
              },
              child: Text('Fullscreen'),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _chewieController.dispose();
                        _videoPlayerController2.pause();
                        _videoPlayerController2.seekTo(Duration(seconds: 0));
                        _chewieController = ChewieController(
                          videoPlayerController: _videoPlayerController1,
                          aspectRatio: 3 / 2,
                          autoPlay: true,
                          looping: true,
                        );
                      });
                    },
                    child: Padding(
                      child: Text("Video 1"),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
//                    controller: textEditingController,
                          maxLength: 20,
                          onSubmitted: (text) {
//                      textEditingController.clear();
                            barrageWallController.send([
                              new Bullet(
                                  child: Container(
                                      child: Row(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(border: Border.all(color: Colors.lightBlue, width: 1), color: Color.fromARGB(180, 240, 255, 255), borderRadius: BorderRadius.all(Radius.circular(20))),
                                      padding: EdgeInsets.fromLTRB(10, 5, 5, 10),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 40,
                                            height: 40,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage('https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558260782128&di=e5fdc0ff5a4c3efa3923f885865bf061&imgtype=0&src=http%3A%2F%2Fn1.itc.cn%2Fimg8%2Fwb%2Frecom%2F2016%2F04%2F22%2F146131935847875919.JPEG'),
                                            ),
                                          ),
                                          Text(
                                            text,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ))
                                ],
                              )))
                            ]);
                          })),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _chewieController.dispose();
                        _videoPlayerController1.pause();
                        _videoPlayerController1.seekTo(Duration(seconds: 0));
                        _chewieController = ChewieController(
                          videoPlayerController: _videoPlayerController2,
                          aspectRatio: 3 / 2,
                          autoPlay: true,
                          looping: true,
                        );
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Error Video"),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.android;
                      });
                    },
                    child: Padding(
                      child: Text("Android controls"),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.iOS;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("iOS controls"),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
