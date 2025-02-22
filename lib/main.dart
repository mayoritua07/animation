// import 'dart:convert';

import 'package:animation/my_button.dart';
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
  double theta1 = 0;
  double phi1 = 80;
  double radius1 = 500;
  double theta2 = 0;
  double phi2 = 80;
  double radius2 = 800;
  String model1 = './assets/prelimFemale.glb';
  String model2 = './assets/prelimModel.glb';
  String animationType = '';
  Map<String, String> maleAnimation = {
    "idle": "idle",
    "expression":
        "Armature.005|M_Standing_Expressions_006|M_Standing_Expressions_",
    "dance": "Armature.006|M_Dances_003|M_Dances_003:BaseAnimation Retarget",
    "locomotion": "run.001"
  };
  Map<String, String> femaleAnimation = {
    "idle": "Armature.003|F_Standing_Idle_Variations_004|F_Standing_Idle_Var",
    "expression": "expression",
    "dance": "dance",
    "locomotion": "run"
  };

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

  // male :[Armature.006|M_Dances_003|M_Dances_003:BaseAnimation Retarget, Armature.005|M_Standing_Expressions_006|M_Standing_Expressions_, idle, run.001]
// [dance, expression, Armature.003|F_Standing_Idle_Variations_004|F_Standing_Idle_Var, run,]

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
        title: Center(child: Text("Animation")),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment:
                isController1 ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 15),
                child: isModel1Loaded && isModel2Loaded
                    ? Column(
                        children: [
                          Icon(Icons.arrow_drop_down, size: 40),
                          SizedBox(
                            width: width / 3,
                            child: Divider(
                              indent: 5,
                              endIndent: 5,
                              thickness: 3,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        ],
                      )
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Model 1",
                style: TextStyle(
                    fontWeight:
                        isController1 ? FontWeight.bold : FontWeight.w300,
                    fontSize: isController1 ? 20 : 18),
              ),
              Switch(
                  value: !isController1,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: maleAnimation.keys.map((item) {
              return InkWell(
                child: MyButton(
                  isSelected: animationType == item,
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (animationType == item) {
                      controller1.stopAnimation();
                      controller2.stopAnimation();
                      animationType = '';
                    } else {
                      setState(() {
                        controller1.playAnimation(
                            animationName: femaleAnimation[item]);
                        controller2.playAnimation(
                            animationName: maleAnimation[item]);
                        animationType = item;
                      });
                    }
                  });
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
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
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
                onPressed: () {
                  move("up");
                },
                child: Icon(
                  Icons.arrow_upward,
                  size: 45,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
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
          SizedBox(height: 8)
        ],
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