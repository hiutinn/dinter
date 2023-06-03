import 'package:dinter/constants/colors.dart';
import 'package:dinter/models/user_model.dart';
import 'package:dinter/screens/register/add_pic_screen.dart';
import 'package:dinter/services/auth_service.dart';
import 'package:flutter/material.dart';

class SetProfileScreen extends StatefulWidget {
  const SetProfileScreen({super.key});

  @override
  State<SetProfileScreen> createState() => _SetProfileScreenState();
}

class _SetProfileScreenState extends State<SetProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? selectedGender;
  String errorMessage = "";
  void _validate() {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _bioController.text.isEmpty ||
        selectedGender == null) {
      setState(() {
        errorMessage = "Bạn chưa điền đủ dữ liệu";
      });
    } else {
      _setProfile();
    }
  }

  void _setProfile() {
    User newUser = User.empty();
    newUser.id = AuthService().currentUser!.uid;
    newUser.name = _nameController.text;
    newUser.age = int.parse(_ageController.text);
    newUser.bio = _bioController.text;
    newUser.gender = selectedGender!;

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddPicScreen(user: newUser)));
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Text(
              'Nhập thông tin của bạn',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            Text(
              errorMessage,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.perm_identity,
                    color: MyColor.primaryColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Colors.grey)),
                  label: const Text('Tên bạn')),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.assignment_ind_outlined,
                    color: MyColor.primaryColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Colors.grey)),
                  label: const Text('Tuổi bạn')),
            ),
            const SizedBox(
              height: 16,
            ),
            _buildGenderRadio(),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.assignment_late_outlined,
                    color: MyColor.primaryColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Colors.grey)),
                  label: const Text('Vài điều về bạn')),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    backgroundColor:
                        const MaterialStatePropertyAll(MyColor.primaryColor)),
                onPressed: () {
                  _validate();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: const Text(
                    'Tiếp theo',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )),
          ]),
        ),
      ),
    );
  }

  Container _buildGenderRadio() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey)),
      child: Column(
        children: [
          const ListTile(
            title: Text('Giới tính'),
            leading: Icon(
              Icons.transgender,
              color: MyColor.primaryColor,
            ),
          ),
          RadioListTile<String>(
            title: const Text('Nam'),
            value: 'Nam',
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Nữ'),
            value: 'Nữ',
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Khác'),
            value: 'Khác',
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
