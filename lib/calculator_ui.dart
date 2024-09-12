import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  String _expression = "";
  String _result = "0";
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        _expression = "";
        _result = "0";
      } else if (value == "=") {
        _result = _calculateResult(_expression);
      } else {
        _expression += value;
      }
    });
  }

  String _calculateResult(String expression) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression.replaceAll('×', '*').replaceAll('÷', '/'));
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return "Error";
    }
  }

  Widget _buildButton(String value, {Color? color}) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTap: () => _onButtonPressed(value),
        child: Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color ?? Colors.grey[850],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Text(
              value,
              style: GoogleFonts.rubik(
                textStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _expression,
                style: GoogleFonts.rubik(
                  textStyle: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white70),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _result,
                style: GoogleFonts.rubik(
                  textStyle: TextStyle(fontSize: 64.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Divider(color: Colors.white54),
          SizedBox(height: 20.0),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8.0),
            children: [
              _buildButton("7"),
              _buildButton("8"),
              _buildButton("9"),
              _buildButton("÷", color: Colors.orange),
              _buildButton("4"),
              _buildButton("5"),
              _buildButton("6"),
              _buildButton("×", color: Colors.orange),
              _buildButton("1"),
              _buildButton("2"),
              _buildButton("3"),
              _buildButton("-", color: Colors.orange),
              _buildButton("C", color: Colors.red),
              _buildButton("0"),
              _buildButton("=", color: Colors.green),
              _buildButton("+", color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}
