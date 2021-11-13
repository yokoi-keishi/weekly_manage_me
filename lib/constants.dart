import 'package:flutter/material.dart';

const double kPadding = 10.0;

const Color sundayColor = Color(0xffFFAEBC);
const Color mondayColor = Color(0xffA0E7E5);
const Color tuesdayColor = Color(0xffB4F8C8);
const Color wednesdayColor = Color(0xffFBE7C6);
const Color thursdayColor = Color(0xffFFAEBC);
const Color fridayColor = Color(0xffA0E7E5);
const Color saturdayColor = Color(0xffB4F8C8);

const TextStyle kSimpleTextStyle =
    TextStyle(fontWeight: FontWeight.bold, color: Colors.black54);

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const List<String> week = [
  '月',
  '火',
  '水',
  '木',
  '金',
  '土',
  '日',
];
