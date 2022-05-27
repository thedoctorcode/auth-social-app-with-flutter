import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_appl/blocs/image_picker/bloc/image_picker_bloc.dart';
import 'package:social_appl/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:social_appl/services/image_picker_service.dart';
import 'package:social_appl/widgets/bottom_sheet_action.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  bool _formValid = false;

  final _focusNodeName = FocusNode();
  final _focusNodeEmail = FocusNode();
  final _focusNodePassword = FocusNode();
  final _focusNodeConfirmPassword = FocusNode();

  final _signUpEmailController = TextEditingController();
  final _signUpNameController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _focusNodeName.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ImagePickerBloc(
              imagePickerService: context.read<ImagePickerService>(),
            ),
          ),
          BlocProvider(
            create: (context) => SignUpBloc(
              userRepository: context.read(),
            ),
          ),
        ],
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            _shouldShowSuccessSignUpDialog(context, state: state);
            _shouldShowErrorSignUpDialog(context, state: state);
          },
          builder: (context, state) => Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: () {
                      final isValid =
                          _formKey.currentState?.validate() ?? false;
                      setState(() {
                        _formValid = isValid;
                      });
                    },
                    child: Stack(
                      children: [
                        _formWidget(context, enabled: state is! SigningUpState),
                        _avatarWidget(context,
                            enabled: state is! SigningUpState),
                        _signUpButton(context,
                            loading: state is SigningUpState),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      );

  Widget _formWidget(
    BuildContext context, {
    bool enabled = true,
  }) =>
      Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 48.0, bottom: 16.0),
          child: Card(
            elevation: 2.0,
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Container(
              padding: EdgeInsets.only(
                top: 48,
                bottom: 24,
              ),
              width: 300.0,
              child: Column(children: [
                _nameField(enabled: enabled),
                Divider(height: 0),
                _emailField(enabled: enabled),
                Divider(height: 0),
                _passwordField(enabled: enabled),
                Divider(height: 0),
                _confirmPasswordField(context, enabled: enabled),
              ]),
            ),
          ),
        ),
      );

  _nameField({bool enabled = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: TextFormField(
          enabled: enabled,
          controller: _signUpNameController,
          focusNode: _focusNodeName,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Nome",
            hintStyle: TextStyle(fontSize: 17.0),
            errorStyle: TextStyle(
              fontSize: 10,
              height: 0.1,
            ),
            icon: Icon(
              FontAwesomeIcons.user,
              color: Colors.black,
              size: 22.0,
            ),
          ),
          validator: (value) {
            if (value == null || value.length < 8) {
              return 'Nome troppo corto';
            }
          },
          onFieldSubmitted: (_) {
            _focusNodeEmail.requestFocus();
          },
        ),
      );

  _emailField({bool enabled = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: TextFormField(
          enabled: enabled,
          controller: _signUpEmailController,
          focusNode: _focusNodeEmail,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Indirizzo email",
            hintStyle: TextStyle(fontSize: 17.0),
            errorStyle: TextStyle(
              fontSize: 10,
              height: 0.1,
            ),
            icon: Icon(
              FontAwesomeIcons.envelope,
              color: Colors.black,
              size: 22.0,
            ),
          ),
          validator: (value) {
            final regex = r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$";
            if (!RegExp(regex).hasMatch(value ?? '')) {
              return 'Email non valida';
            }
          },
          onFieldSubmitted: (_) {
            _focusNodePassword.requestFocus();
          },
        ),
      );

  _passwordField({bool enabled = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: TextFormField(
          enabled: enabled,
          controller: _signUpPasswordController,
          focusNode: _focusNodePassword,
          obscureText: _obscureTextPassword,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Password",
            hintStyle: TextStyle(fontSize: 17.0),
            errorStyle: TextStyle(
              fontSize: 10,
              height: 0.1,
            ),
            icon: Icon(
              FontAwesomeIcons.lock,
              color: Colors.black,
              size: 22.0,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureTextPassword = !_obscureTextPassword;
                });
              },
              child: Icon(
                _obscureTextPassword == true
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                size: 15.0,
                color: Colors.black,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.length < 8) {
              return 'Password troppo corta';
            }
          },
          onFieldSubmitted: (_) {
            _focusNodeConfirmPassword.requestFocus();
          },
        ),
      );

  _confirmPasswordField(BuildContext context, {bool enabled = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: TextFormField(
          enabled: enabled,
          controller: _signUpConfirmPasswordController,
          focusNode: _focusNodeConfirmPassword,
          obscureText: _obscureTextConfirmPassword,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Conferma password",
            hintStyle: TextStyle(fontSize: 17.0),
            errorStyle: TextStyle(
              fontSize: 10,
              height: 0.1,
            ),
            icon: Icon(
              FontAwesomeIcons.lock,
              color: Colors.black,
              size: 22.0,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                });
              },
              child: Icon(
                _obscureTextConfirmPassword == true
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                size: 15.0,
                color: Colors.black,
              ),
            ),
          ),
          validator: (value) {
            if (_signUpPasswordController.text != value) {
              return 'Le password non corrispondono';
            }
          },
          onFieldSubmitted: (_) => context.read<SignUpBloc>().signUp(
              name: _signUpNameController.text,
              email: _signUpEmailController.text,
              password: _signUpPasswordController.text),
          textInputAction: TextInputAction.go,
        ),
      );

  Widget _avatarWidget(
    BuildContext context, {
    bool enabled = true,
  }) =>
      Positioned.fill(
        child: Align(
          alignment: Alignment.topCenter,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48.0)),
            elevation: 8.0,
            child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
              builder: (context, state) => InkWell(
                customBorder: const CircleBorder(),
                onTap: enabled
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => _bottomSheetPicker(context,
                              picked: state is PickedImageState),
                        );
                      }
                    : null,
                child: CircleAvatar(
                    backgroundImage: state is PickedImageState
                        ? FileImage(state.imageFile)
                        : null,
                    radius: 48.0,
                    child: () {
                      if (state is NoImagePickedState) {
                        return const Icon(
                          FontAwesomeIcons.camera,
                          size: 24.0,
                        );
                      } else if (state is LoadingImageState) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Container();
                    }()),
              ),
            ),
          ),
        ),
      );

  Widget _bottomSheetPicker(
    BuildContext context, {
    bool picked = false,
  }) {
    final actions = [
      if (picked)
        BottomSheetAction(
          'Rimuovi',
          icon: FontAwesomeIcons.trash,
          backgroundColor: Colors.red,
          onTap: () {
            context.read<ImagePickerBloc>().reset();
            Navigator.of(context).pop();
          },
        ),
      BottomSheetAction(
        'Galleria',
        icon: FontAwesomeIcons.fileImage,
        backgroundColor: Colors.blue,
        onTap: () {
          context.read<ImagePickerBloc>().pickGalleryImage();
          Navigator.of(context).pop();
        },
      ),
      BottomSheetAction(
        'Fotocamera',
        icon: FontAwesomeIcons.camera,
        backgroundColor: Colors.orange,
        onTap: () {
          context.read<ImagePickerBloc>().pickCameraImage();
          Navigator.of(context).pop();
        },
      ),
    ];
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(16.0),
        height: 180.0,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Immagine del profilo",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            Expanded(
                child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              scrollDirection: Axis.horizontal,
              itemCount: actions.length,
              itemBuilder: (context, index) => actions[index],
              separatorBuilder: (_, __) => Container(width: 16.0),
            ))
          ],
        ),
      ),
    );
  }

  Widget _signUpButton(
    BuildContext context, {
    bool loading = false,
  }) =>
      Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: !loading && _formValid
                ? () => context.read<SignUpBloc>().signUp(
                    name: _signUpNameController.text,
                    email: _signUpEmailController.text,
                    password: _signUpPasswordController.text)
                : null,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 48.0),
              child: !loading
                  ? const Text(
                      "Registrati",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    )
                  : const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      );

  void _shouldShowErrorSignUpDialog(
    BuildContext context, {
    required SignUpState state,
  }) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (state is SignUpErrorState) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Problemi durante la registrazione'),
            content: const Text('I dati forniti non sono corretti.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    });
  }

  void _shouldShowSuccessSignUpDialog(
    BuildContext context, {
    required SignUpState state,
  }) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (state is SignedUpState) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registrazione effettuata!'),
            content: const Text(
                'La registrazione del tuo account è stata completata.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    });
  }
}
