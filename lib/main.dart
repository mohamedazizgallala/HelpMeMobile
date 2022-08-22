import 'package:flutter/material.dart';
//import 'dart:ui' as ui;
import 'dart:async';
//import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'; //to pick image and save to cache either from cam or gallery
import 'dart:io';
import 'package:path_provider/path_provider.dart'; // to get application paths
import 'package:email_validator/email_validator.dart';
import 'dart:math';
//import 'package:auto_size_text/auto_size_text.dart';

//import 'package: path/path.dart';
//optionnal arguments : [] : ordered
// or they can be {arg1:,arg2:} called with arg1: , arg2:

//FIX WINDOW WITH COLUMN SCROLL
//INTEGRATE WITH STEPS
//FIX THE UI ONCE FOR ALL
//VALIDATORS FOR FORMS

//                  GLOBAL VARIABLES
final List<UserProfile> userList = <UserProfile>[];

//
//
//                 CLASSES

class LoginCreds {
  final String login;
  final String password;

  const LoginCreds(this.login, this.password);
}

class UserProfile {
  final String email, name, secondName, password;
  String? imagePath;
  UserProfile(this.email, this.name, this.secondName, this.password,
      [this.imagePath]);

  @override
  String toString() {
    return 'User mail:$email,$name,$secondName,$imagePath';
  }
}
//            CLASSES

//        FUNCTIONS

Size displaySize(BuildContext context) {
  //debugPrint('Size = '+ MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  //debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  //debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}

bool verifymail(String mailtoverify) {
  ///Used to verify mail
  //String mailtoverify='mohamedaziz.gallalaesprit.tn';
  debugPrint('verifying mail $mailtoverify');
  debugPrint('varifymail::${EmailValidator.validate(mailtoverify)}');
  return (EmailValidator.validate(mailtoverify));
}

bool validateStructure(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

UserProfile manageLogin(List<UserProfile> people, String personName,
    [String? password]) {
  bool found = people.any((element) => element.email == personName);
  if (found != true) {
    //didn't even find the person
    debugPrint('managelogin::didntfind::returning emptyprofile');
    return UserProfile('emptyProfile', '', '', '', '');
  } else {
    final person = people.firstWhere(
        (element) =>
            element.email == personName && element.password == password,
        orElse: () => UserProfile('wrongpassword', '', '', '', ''));
    debugPrint('managelogin::::${person.toString()}');
    return person;
  }
}

UserProfile findPersonUsingFirstWhere(
    List<UserProfile> people, String personName, String password) {
  final person = people.firstWhere(
      (element) => element.email == personName && element.password == password,
      orElse: () => UserProfile('emptyProfile', '', '', '', ''));
  return (person);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //static var userList = <UserProfile>[];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //fontFamily: 'Alegreya_Sans',
        primarySwatch: Colors.lightBlue,
      ),
      home: const BackgroundColorPage(),
    );
  }
}

class BackgroundColorPage extends StatefulWidget {
  const BackgroundColorPage({Key? key}) : super(key: key);

  @override
  State<BackgroundColorPage> createState() => _BackgroundColorPageState();
}

class _BackgroundColorPageState extends State<BackgroundColorPage> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>(); //to validate the form values
  final myController = TextEditingController(); // to check for values
  final secondcontroller = TextEditingController();
  void _printLatestValue() {
    debugPrint('Second text field: ${myController.text}');
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  showSnackBar(BuildContext context, String text) {
    final snackbar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Center(
            child: Stack(
              children: <Widget>[
                Container(),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          controller: myController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ('Cannot be empty');
                            }
                            if (!verifymail(value)) {
                              return ('must be valid mail');
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              hintText: 'Insert login here',
                              labelText: 'Email'),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                            obscureText: _obscureText,
                            enableSuggestions: false,
                            controller: secondcontroller,
                            keyboardType: TextInputType.visiblePassword,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              suffixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: IconButton(
                                  onPressed: () {
                                    debugPrint('clickedbutton');
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ('password cant be empty');
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          child: const Text('Login'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              UserProfile result = manageLogin(userList,
                                  myController.text, secondcontroller.text);
                              // debugPrint(result.runtimeType.toString());
                              // debugPrint(result.toString());
                              //ImagePicker.pickImage

                              if (result.email ==
                                  'emptyProfile') //wrongpassword
                              {
                                ScaffoldMessenger.of(context)
                                    .showMaterialBanner(
                                  MaterialBanner(
                                    backgroundColor: const Color.fromARGB(
                                        127, 255, 255, 255),
                                    elevation: 0.5,
                                    onVisible: () async {
                                      await Future.delayed(
                                          const Duration(seconds: 2), () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentMaterialBanner();
                                      });
                                    },
                                    overflowAlignment:
                                        OverflowBarAlignment.center,
                                    content: const Text(
                                        'Couldn\'t find a profile with this email\nWanna create an account?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentMaterialBanner();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const TestPage(),
                                            ),
                                          );
                                        },
                                        child: const Text('SignUp'),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (result.email == 'wrongpassword') {
                                showSnackBar(context, 'wrong password');
                              } else {
                                showSnackBar(context, 'singing in');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Testpage2(
                                        userProfile: result,
                                      ),
                                    ));
                              }
                              //aaaS@!333
                              // showSnackBar(context);

                              /*showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Result'),
                                  content: Text(myController.text
                                              .toString()
                                              .isEmpty &&
                                          secondcontroller.text
                                              .toString()
                                              .isEmpty
                                      ? 'Empty Fields! \n'
                                      : myController.text.toString().isEmpty &&
                                              secondcontroller.text
                                                  .toString()
                                                  .isNotEmpty
                                          ? 'empty login'
                                          : myController.text
                                                      .toString()
                                                      .isNotEmpty &&
                                                  secondcontroller.text
                                                      .toString()
                                                      .isEmpty
                                              ? 'password field is empty \nplease fill'
                                              : 'Login: ${myController.text} \nPassword: ${secondcontroller.text}'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (myController.text
                                                .toString()
                                                .isEmpty ||
                                            secondcontroller.text
                                                .toString()
                                                .isEmpty) {
                                          Navigator.pop(context);
                                        } else {
                                          myController.clear();
                                          secondcontroller.clear();
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SignedInPage(
                                                  userProfile: result,
                                                ),
                                                //ResizeContainerPage(textTest:myController.text.toString())
                                              ));
                                        }
                                      },
                                      child: myController.text
                                                  .toString()
                                                  .isEmpty ||
                                              secondcontroller.text
                                                  .toString()
                                                  .isEmpty
                                          ? const Text('Dismiss')
                                          : const Text('ContinueToProfilePage'),
                                    ),
                                  ],
                                ),
                              );*/

                            }
                          },
                        ),
                        ElevatedButton(
                          child: const Text('clear fields'),
                          onPressed: () {
                            myController.clear();
                            secondcontroller.clear();
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Testpage2(),
                              ),
                            );*/
                          },
                        ),
                        ElevatedButton(
                          child: const Text('check users'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilesPage(),
                              ),
                            );
                          },
                        ),
                        /*ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                            child: const Text('seo')),
                       */
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResizeContainerPage(
                                    textTest: 'kapaaaaa'),
                              ),
                            );
                          },
                          child: const Text('ResizeContainerPage'),
                        ),
                        ElevatedButton(
                          /* onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResizeContainerPage(
                                    textTest: 'kapaaaaa'),
                              ),
                            );
                          },*/
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const WelcomePage()));
                          },
                          child: const Text('testscrollpage'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TestPage(),
                              ),
                            );
                          },
                          child: const Text('register'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    //);
  }
}

class ResizeContainerPage extends StatefulWidget {
  final String textTest;
  const ResizeContainerPage({Key? key, required this.textTest})
      : super(key: key);

  @override
  State<ResizeContainerPage> createState() => _ResizeContainerPageState();
}

class _ResizeContainerPageState extends State<ResizeContainerPage> {
  num predefinedWidth = 0.5;
  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          /*SizedBox(height: this.size.height,*/
          /*media*/
          Transform.rotate(
            angle: 50,
            child: SizedBox(
              width: displayWidth(context) * predefinedWidth,
              height: displayHeight(context) * predefinedWidth,
              child: Container(
                color: Colors.red,
              ),
            ),
          ),
          const Text('Welcome to register page '),
          const Text(
            'Please fill in your data',
            style: TextStyle(
              color: Colors.black,
              fontSize: 50,
              fontFamily: 'Alegreya_Sans',
            ),
          ),
          Slider(
              activeColor: Colors.red,
              min: 0,
              max: 1,
              value: predefinedWidth.toDouble(),
              onChanged: (newvalue) {
                setState(() {
                  predefinedWidth = newvalue;
                });
              })
        ],
      ),
    );
  }
}

class SignedInPage extends StatefulWidget {
  final UserProfile userProfile;
  const SignedInPage({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<SignedInPage> createState() => _SignedInPageState();
}

class _SignedInPageState extends State<SignedInPage> {
  late UserProfile current;
  @override
  void initState() {
    super.initState();
    current = widget.userProfile;
  }

  //var current=super.userProfile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second screen')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Hello, ${current.name} ! How are you?This is your password ${current.secondName}',
            style: const TextStyle(fontSize: 24),
          ),
          current.imagePath != ""
              ? Image(
                  image: FileImage(
                    File(current.imagePath!),
                  ),
                )
              : Image.asset('assets/images/placeholder.png'),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('return'),
          ),
        ],
      ),
    );
  }
}

//FINALREGISTER
class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Timer timer;
  bool showhint = false;
  final _firstPassword = TextEditingController();
  final _secondPassword = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _registerFormKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  XFile? imageGallery;
  XFile? imageCamera;
  final ImagePicker picker = ImagePicker();

  double containerWidth = 100;
  double containerHeight = 100;

  bool _obscureText = true;
  bool savedImage = false;
  String tempPath = "";
  String appDocPath = "";
  String last = "";

  //ValueNotifier<bool> boolchange=ValueNotifier(_value)
  getPaths() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
    debugPrint('getpathsssssssssssss$appDocPath');
    //output: /data/user/0/com.example.test/app_flutter

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPaths();
    debugPrint('iniiiiiiiiiiiiiiiiiiiiiit');
    if (imageGallery == null) {
      debugPrint('image gallery is null');
    }
    debugPrint(imageGallery.toString());
    debugPrint(_firstPassword.text);
    // Start listening to changes.
    _firstPassword.addListener(() {
      setState(() {
        _firstPassword.text.isEmpty
            ? debugPrint('firstemptyfield')
            : debugPrint('not empty the value is ${_firstPassword.text}');
      });
      debugPrint('first listener');
    });
    _secondPassword.addListener(() {
      setState(() {
        _secondPassword.text.isEmpty
            ? debugPrint('emptyfield')
            : debugPrint('not empty the value is $_secondPassword');
      });
      debugPrint('second listener');
    });
  }

  @override
  void dispose() {
    debugPrint('dispoooooooooooooose');
    // Clean up the controller when the widget is disposed.
    _firstPassword.dispose();
    _secondPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool passwordContainsNumber =
        _firstPassword.text.contains(RegExp(r'[0-9]'));
    final bool passwordContainsUppercase =
        _firstPassword.text.contains(RegExp(r'[A-Z]'));
    final bool passwordContainsLowercase =
        _firstPassword.text.contains(RegExp(r'[a-z]'));
    final bool passwordContainsSpecialCaracter =
        _firstPassword.text.contains(RegExp(r'[!@#\$&*~]'));
    final bool passwordLength = _firstPassword.text.length >= 8;
    bool pwtest =
        _firstPassword.text.isEmpty || !validateStructure(_firstPassword.text);

    return Scaffold(
      //resizeToAvoidBottomInset: true, //false hides elements when
      // keyboard there sinon true (default value) tkhalik

      body: SingleChildScrollView(
        /*child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),*/
        child: Center(
          child: Stack(
            children: [
              Form(
                autovalidateMode:
                    _autoValidate, //can update error message with changes on the field realtime
                key: _registerFormKey,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ('must be filled');
                                }
                                if (!verifymail(value)) {
                                  return ('valid mail please');
                                }

                                return (null);
                              },
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromARGB(59, 173, 77, 202),
                                  hintText: 'Insert login here',
                                  labelText: 'Email'),
                            ),
                            TextFormField(
                              controller: _firstNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ('must be filled');
                                }
                                return (null);
                              },
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 211, 188, 139),
                                  hintText: 'Insert name here',
                                  labelText: 'Name'),
                            ),
                            TextFormField(
                              controller: _secondNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ('must be filled');
                                }
                                return (null);
                              },
                              decoration: const InputDecoration(
                                focusedErrorBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.black26,
                                hintText: 'Insert your second name ',
                                labelText: 'Second name',
                              ),
                            ),
                            TextFormField(
                              toolbarOptions: const ToolbarOptions(
                                paste: true,
                                selectAll: true,
                                copy: false,
                                cut: false,
                              ),
                              obscureText: _obscureText,
                              enableSuggestions: false,
                              controller: _firstPassword,
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ('must be filled');
                                }
                                return (null);
                              },
                              decoration: InputDecoration(
                                hintText: 'Password',
                                suffixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: IconButton(
                                    iconSize: 24,
                                    onPressed: () {
                                      setState(() {
                                        showhint = !showhint;
                                      });
                                      void timerDown() {
                                        timer = Timer(
                                            const Duration(seconds: 5), () {
                                          setState(() {
                                            showhint = false;
                                          });
                                        });
                                      }

                                      if (showhint == true) {
                                        timerDown();
                                      } else {
                                        timer.cancel();
                                      }
                                    },
                                    icon: const Icon(Icons.question_mark_sharp),
                                  ),
                                ),
                                filled: true,
                                fillColor: _secondPassword.text.isEmpty
                                    ? Colors.indigo.shade100
                                    : _secondPassword.text ==
                                            _firstPassword.text
                                        ? Colors.green
                                        : Colors.red,

                                /* suffixIcon: Align(
                   widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: IconButton(
                                      onPressed: () {
                                        debugPrint('clickedbutton');
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      icon: Icon(_obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                  ), */
                              ),
                              onChanged: ((value) => value.isEmpty
                                  ? _secondPassword.clear()
                                  : null),
                            ),
                            Container(
                              transform: Matrix4.translationValues(0, -18, 0),
                              child: Column(
                                children: [
                                  Container(
                                    transform:
                                        Matrix4.translationValues(0, 9, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AnimatedOpacity(
                                          opacity: pwtest ? 0.0 : 1.0,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: _secondPassword.text.isEmpty
                                              ? const Text(
                                                  'Please confirm your password')
                                              : _secondPassword.text ==
                                                      _firstPassword.text
                                                  ? const Text(
                                                      'The passwords match',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  : const Text(
                                                      'No match, please verify',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            debugPrint('clickedbutton');
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                          icon: Icon(_obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    opacity: pwtest ? 0.0 : 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: TextFormField(
                                      toolbarOptions: const ToolbarOptions(
                                        paste: false,
                                        selectAll: false,
                                        copy: false,
                                        cut: false,
                                      ),
                                      onChanged: ((value) => value.isEmpty
                                          ? debugPrint('field is empty')
                                          : debugPrint('new value is $value')),
                                      controller: _secondPassword,
                                      obscureText: _obscureText,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        enabled: !pwtest,
                                        filled: true,
                                        fillColor: _secondPassword.text.isEmpty
                                            ? Colors.indigo.shade100
                                            : _secondPassword.text ==
                                                    _firstPassword.text
                                                ? Colors.green
                                                : Colors.red,
                                        hintText: 'Password confirmation',
                                        /* enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.red, width: 5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.green, width: 5),
                                          ), */
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                child: savedImage
                                    ? last == "gallery"
                                        ? ClipOval(
                                            child: Image(
                                              image: FileImage(
                                                  File(imageGallery!.path),
                                                  scale: 4),
                                            ),
                                          )
                                        : ClipOval(
                                            child: Image(
                                              image: FileImage(
                                                File(imageCamera!.path),
                                              ),
                                            ),
                                          )
                                    : Image.asset(
                                        'assets/images/placeholder.png')),
                            ElevatedButton(
                              child: const Text('from gallery'),
                              onPressed: () async {
                                // Pick an image

                                imageGallery = await picker.pickImage(
                                    source: ImageSource.gallery);
                                debugPrint('image gallery$imageGallery');
                                debugPrint(
                                    'imagegallerypath${imageGallery!.path}');
                                savedImage = true;
                                last = "gallery";
                                debugPrint('saveed image:$savedImage');
                                setState(() {});
                                debugPrint('lasttttttttt::::$last');
                                //debugPrint('taken image current path${image!.path}');
                                // debugPrint('taken image current name${image.name}');
                                //Directory directory =await getApplicationDocumentsDirectory();

                                //getca
                                //debugPrint('directory2:${directoy2.toString()}');
                                // debugPrint('directory${directory.path}');

                                //String path = '${directory.path}/my_image.png';
                                //File f = File(path)

                                //image.saveTo('${directory.path}/ameeeeeeboreeed.jpg');
                                //  debugPrint('saved to ${directory.path}/ameeeeeeboreeed.jpg');
                              },
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Pick an image
                                //imageCamera =

                                imageCamera = await picker.pickImage(
                                    source: ImageSource.camera);
                                debugPrint(
                                    'taken image current path${imageCamera!.path}');
                                savedImage = true;
                                last = "camera";
                                setState(() {});
                                debugPrint('lasttttttttt::::$last');

                                //String path = '${directory.path}/my_image.png';
                                //File f = File(path)
                                /*String savingPath ='${directory.path}/usrimg_${_emailController.text}_${_firstNameController.text}${_secondNameController.text}.jpg';
                                  imageCamera!.saveTo(savingPath);
                                  */
                              },
                              child: const Text('from camera'),
                            ),
                            Center(
                              child: ElevatedButton(
                                child: const Text('Register'),
                                onPressed: () {
                                  //SI FORM VALIDE ---> VOIR SI LUTILISATEUR EXISTE ALORS PAS DAJOUT SINON AJOUT //SI FORM NON VALIDE SET AUTO VALIDATE
                                  if (_registerFormKey.currentState!
                                      .validate()) {
                                    if (manageLogin(userList,
                                                    _emailController.text)
                                                .email ==
                                            'emptyProfile' ||
                                        manageLogin(userList,
                                                    _emailController.text)
                                                .email ==
                                            'wrongpassword') {
                                      debugPrint('usermail already in user');
                                    } else {
                                      debugPrint(
                                          'appDocpath::::::::::$appDocPath');
                                      var path =
                                          '$appDocPath/usrimg_${_emailController.text}_${_firstNameController.text}${_secondNameController.text}.jpg';
                                      savedImage
                                          ? {
                                              last == "camera"
                                                  ? imageCamera!.saveTo(path)
                                                  : imageGallery!.saveTo(path)
                                            }
                                          : {
                                              debugPrint(
                                                  'didnt pick a picture'),
                                              path = ""
                                            };
                                      userList.add(UserProfile(
                                          _emailController.text,
                                          _firstNameController.text,
                                          _secondNameController.text,
                                          _firstPassword.text,
                                          path));
                                      debugPrint(userList.toString());

                                      //Navigator.pop(context);
                                      /* Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const TestPage(),
                                            ),
                                          );
                                        }, */
                                    } //validator if
                                  } else {
                                    setState(() {
                                      _autoValidate =
                                          AutovalidateMode.onUserInteraction;
                                    });
                                  }
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  savedImage = false;
                                });
                              },
                              child: const Text('clearimage'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 500,
                right: 50,
                child: AnimatedOpacity(
                  opacity: showhint == false ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: Stack(
                    children: [
                      Container(
                        //width: 100,
                        //height: 50,
                        // ignore: sort_child_properties_last
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          // ignore: sort_child_properties_last
                          child: CustomText(
                            t1: passwordContainsUppercase,
                            t2: passwordContainsLowercase,
                            t3: passwordContainsNumber,
                            t4: passwordContainsSpecialCaracter,
                            t5: passwordLength,
                          ),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(218, 208, 113, 106),
                        ),
                        // color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({Key? key}) : super(key: key);

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  @override
  Widget build(BuildContext context) {
    debugPrint("userlist::::$userList");
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
              child: const Text('clear users'),
              onPressed: () {
                setState(() {
                  userList.clear();
                });
              },
            ),
            ListView.builder(
              itemCount: userList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          child: userList[index].imagePath == ""
                              ? Text(
                                  '${userList[index].name[0]}${userList[index].secondName[0]}'
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 50, color: Colors.white),
                                )
                              : ClipOval(
                                  child: Image(
                                    image: FileImage(
                                      File(userList[index].imagePath!),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: Expanded(
                            child: Text(
                                'user n*$index:\nmail:${userList[index].email.toString()}\nfirst name: ${userList[index].name.toString()}\nsecond name: ${userList[index].secondName.toString()}')),
                      ),
                    ],
                  ),
                );
              },
            ), //
          ],
        ),
      ),
    );
  }
  /* class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            const Text(
              'Welcome to register page',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(10, 10),
                  topRight: Radius.circular(20),
                ),
                color: Color.fromARGB(206, 156, 241, 216),
              ),
              //height: 20,
              child: Column(
                children: [
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          //controller: myController,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              hintText: 'Insert login here',
                              labelText: 'Email'),
                        ),
                        TextFormField(
                          //controller: myController,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 198, 221, 199),
                              hintText: 'Insert name here',
                              labelText: 'Name'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
 */

}

class CustomText extends StatelessWidget {
  final bool t1, t2, t3, t4, t5;

  const CustomText(
      {Key? key,
      required this.t1,
      required this.t2,
      required this.t3,
      required this.t4,
      required this.t5})
      : super(key: key);

  final TextStyle customText = const TextStyle(fontWeight: FontWeight.w800);
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: [
          //WidgetSpan(child: Icon(Icons.check, size: 14)),
          //TextSpan(text: 'Strong password:'),
          const TextSpan(
              text: 'Must contain at least :\n',
              style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  height: 1.5,
                  color: Color.fromARGB(255, 227, 223, 223))),
          const WidgetSpan(child: Icon(Icons.check, size: 20)),
          TextSpan(
              text: '\t\t\t1 uppercase caracter\n',
              style: t1 ? customText : null),
          const WidgetSpan(child: Icon(Icons.check, size: 20)),
          TextSpan(
              text: '\t\t\t1 lowercase caracter\n',
              style: t2 ? customText : null),
          const WidgetSpan(child: Icon(Icons.check, size: 20)),
          TextSpan(
              text: '\t\t\t1 numeric caracter\n',
              style: t3 ? customText : null),
          const WidgetSpan(child: Icon(Icons.check, size: 20)),
          TextSpan(
              text: '\t\t\t1 special caracter\n',
              style: t4 ? customText : null),
          const WidgetSpan(
              child: Icon(
            Icons.check,
            size: 20,
            color: Colors.green,
          )),
          TextSpan(
              text: ' Must be of 8+ caracters', style: t5 ? customText : null),
        ],
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
          colors: [Color(0xFFd9a7c7), Color(0xFFfffcdc)],
        ),
      ),
      child: Stack(children: [
        Scaffold(
          body: SafeArea(
              child: Column(
            children: const [
              Text(
                'Hello',
                style: TextStyle(
                  fontSize: 70,
                  fontFamily: 'Metropolis',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  //  color: Colors.black,
                ),
              ),
            ],
          )),
          backgroundColor: Colors.transparent,
        ),
      ]),
    );
  }
}

/// Custom Shape
/*
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 6.44;
    paint0.shader = ui.Gradient.linear(
        Offset(size.width * 0.32, size.height * 0.48),
        Offset(size.width * 0.68, size.height * 0.48),
        [const Color(0xff000000), const Color(0xffffffff)],
        [0.00, 1.00]);

    Path path0 = Path();
    path0.moveTo(size.width * 0.3716667, size.height * 0.1000000);
    path0.quadraticBezierTo(size.width * 0.3216667, size.height * 0.2967857,
        size.width * 0.4358333, size.height * 0.3185714);
    path0.cubicTo(
        size.width * 0.5543750,
        size.height * 0.3239286,
        size.width * 0.5266667,
        size.height * 0.4889286,
        size.width * 0.5258333,
        size.height * 0.5171429);
    path0.quadraticBezierTo(size.width * 0.5166667, size.height * 0.5735714,
        size.width * 0.5091667, size.height * 0.7142857);
    path0.quadraticBezierTo(size.width * 0.5235417, size.height * 0.8567857,
        size.width * 0.6216667, size.height * 0.7728571);
    path0.quadraticBezierTo(size.width * 0.6460417, size.height * 0.7425000,
        size.width * 0.6825000, size.height * 0.6971429);
    path0.lineTo(size.width * 0.6825000, size.height * 0.0985714);
    path0.lineTo(size.width * 0.3716667, size.height * 0.1000000);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
*/
const darkColor = Color(0xFF49535C);

class ProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  const ProfileScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile current;
  bool _isEditingText = false;
  @override
  void initState() {
    super.initState();
    current = widget.userProfile;
  }

  @override
  Widget build(BuildContext context) {
    var montserrat = const TextStyle(
      fontSize: 12,
    );
    return Material(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 150,
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: AvatarClipper(),
                          child: Container(
                            height: 100,
                            decoration: const BoxDecoration(
                              color: darkColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 11,
                          top: 50,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)],
                                child: current.imagePath == ""
                                    ? Text(
                                        '${current.name[0]}${current.secondName[0]}'
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 50, color: Colors.white),
                                      )
                                    : ClipOval(
                                        child: Image(
                                          image: FileImage(
                                            File(current.imagePath!),
                                          ),
                                        ),
                                      ),
                              ),
                              /* const CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                    "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/22/22a4f44d8c8f1451f0eaa765e80b698bab8dd826_full.jpg"),
                              ),*/
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${current.name} ${current.secondName}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    current.email,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: darkColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8)
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Password: ",
                              style: montserrat,
                            ),
                            const SizedBox(height: 16),
                            //Text(
                            //  "Official Start: \n Occupation: ",
                            //  style: montserrat,
                            //),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("@flutter_exp", style: montserrat),
                            Text('*' * current.password.length,
                                style: montserrat),
                            const SizedBox(height: 16),
                            // Text("28.01.2020", style: montserrat),
                            // Text("Sn. Software Engineer", style: montserrat),
                          ],
                        )
                      ],
                    ),
                  ),

                  //const SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.only(left: 140),
                    child: Container(
                      transform: Matrix4.translationValues(0, -18, 0),
                      child: ElevatedButton(
                        child: _isEditingText==false
                            ? const Text('Edit info')
                            : const Text('Save Changes'),
                        onPressed: () {
                          if (_isEditingText == false) {
                            setState(() {
                              _isEditingText = true;
                            });
                          } else {
                            _isEditingText = false;
                            debugPrint('EDITED INFO');
                            setState(() {
                              
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  /*Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "6280",
                              style: buildMontserrat(
                                const Color(0xFF000000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Subscribers",
                              style: buildMontserrat(darkColor),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                          child: VerticalDivider(
                            color: Color(0xFF9A9A9A),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "1745",
                              style: buildMontserrat(
                                const Color(0xFF000000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Followers",
                              style: buildMontserrat(darkColor),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                          child: VerticalDivider(
                            color: Color(0xFF9A9A9A),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "163",
                              style: buildMontserrat(
                                const Color(0xFF000000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Videos",
                              style: buildMontserrat(darkColor),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),*/
                  // const SizedBox(height: 8)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle buildMontserrat(
    Color color, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 18,
      color: color,
      fontWeight: fontWeight,
    );
  }
}

class AvatarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height)
      ..lineTo(8, size.height)
      ..arcToPoint(Offset(114, size.height), radius: const Radius.circular(1))
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Testpage2 extends StatefulWidget {
  final UserProfile userProfile;
  const Testpage2({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<Testpage2> createState() => _Testpage2State();
}

class _Testpage2State extends State<Testpage2> {
  late UserProfile current;
  @override
  void initState() {
    super.initState();
    current = widget.userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: ProfileScreen(
          userProfile: current,
        )),
      ),
    );
  }
}
