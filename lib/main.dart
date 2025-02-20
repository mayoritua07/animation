// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';
// import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // loadData(WebViewController controller, String asset) async {
  //   String fileText = await rootBundle.loadString(asset);
  //   // controller.loadUrl(Uri.dataFromString(fileText,
  //   //         mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //   //     .toString());
  //   controller.loadHtmlString(asset);
  // }

  Flutter3DController controller1 = Flutter3DController();
  Flutter3DController controller2 = Flutter3DController();
  bool isController1 = true;
  bool isPlayingAnimation = false;
  bool isModel1Loaded = false;
  bool isModel2Loaded = false;
  double theta1 = 285;
  double phi1 = 80;
  double radius1 = 500;
  double theta2 = 75;
  double phi2 = 80;
  double radius2 = 800;
  String model1 = './assets/Bee.glb';
  String model2 = './assets/wolf.glb';

  void move(String direction) {
    Map<String, double> horizontalWays = {
      "left": 10,
      "right": -10,
    };

    Map<String, double> verticalWays = {"up": 10, "down": -10};
    if (isController1) {
      theta1 += horizontalWays[direction] ?? 0;
      phi1 += verticalWays[direction] ?? 0;
      controller1.setCameraOrbit(theta1, phi1, radius1);
    } else {
      theta2 += horizontalWays[direction] ?? 0;
      phi2 += verticalWays[direction] ?? 0;
      controller2.setCameraOrbit(theta2, phi2, radius2);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment:
                isController1 ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 5),
                child: isModel1Loaded && isModel2Loaded
                    ? Icon(Icons.arrow_drop_down, size: 40)
                    : null,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: height * 0.5,
                width: width / 2.1,
                child: Flutter3DViewer(
                  src: model1,
                  controller: controller1,
                  enableTouch: false,
                  onLoad: (String ii) {
                    setState(() {
                      controller1.setCameraOrbit(theta1, phi1, radius1);
                      isModel1Loaded = true;
                    });
                  },
                ),
              ),
              SizedBox(
                height: height * 0.5,
                width: width / 2.1,
                child: Flutter3DViewer(
                  src: model2,
                  controller: controller2,
                  enableTouch: false,
                  onLoad: (String ii) {
                    setState(() {
                      controller2.setCameraOrbit(theta2, phi2, radius2);
                      isModel2Loaded = true;
                    });
                  },
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20)),
                        onPressed: () {
                          move("left");
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 45,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20)),
                        onPressed: () {
                          move("up");
                        },
                        child: Icon(
                          Icons.arrow_upward,
                          size: 45,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                        ),
                        onPressed: () {
                          move("down");
                        },
                        child: Icon(
                          Icons.arrow_downward,
                          size: 45,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20)),
                        onPressed: () {
                          move("right");
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          size: 45,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Model 1",
                    style: TextStyle(
                        fontWeight:
                            isController1 ? FontWeight.bold : FontWeight.w300,
                        fontSize: isController1 ? 20 : 18),
                  ),
                  Switch(
                      value: isController1,
                      onChanged: (val) {
                        setState(() {
                          isController1 = !isController1;
                        });
                      }),
                  Text(
                    "Model 2",
                    style: TextStyle(
                        fontWeight:
                            !isController1 ? FontWeight.bold : FontWeight.w300,
                        fontSize: !isController1 ? 20 : 18),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          SizedBox(height: height * 0.1),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (isPlayingAnimation) {
              controller1.stopAnimation();
              controller2.stopAnimation();
            } else {
              controller1.playAnimation();
              controller2.playAnimation();
            }
            isPlayingAnimation = !isPlayingAnimation;
          });
        },
        child: Icon(
          isPlayingAnimation ? Icons.stop : Icons.play_arrow,
          size: 30,
        ),
      ),
    );
  }
}

//  WebView(
//         onWebViewCreated: (controller) async {
//           await loadData(controller, "assets/animation.html");
//         },
//         javascriptMode: JavascriptMode.unrestricted,
//         javascriptChannels: {
//           JavascriptChannel(
//             name: "Avatar Created",
//             onMessageReceived: (JavascriptMessage message) {
//               debugPrint(message.message);
//             },
//           )
//         },
//       ),

// WebViewWidget(
//           controller: WebViewController()
//             ..setJavaScriptMode(JavaScriptMode.unrestricted)
//             ..addJavaScriptChannel(
//               "Avatar Created",
//               onMessageReceived: (JavaScriptMessage message) {
//                 debugPrint(message.message);
//               },
//             )
//             ..loadFlutterAsset("assets/animation.html")),


//  const ModelViewer(
//         backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
//         src: './assets/itua.glb',
//         autoRotate: true,
//         debugLogging: false,
//         // ar: true,
//       ),

//  Flutter3DViewer(
//         src: './assets/Bee.glb',
//         controller: controller,
//         enableTouch: true,
//         onLoad: (String ii) {
//           getAnimation();
//         },
//       ),