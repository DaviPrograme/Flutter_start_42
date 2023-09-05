import 'package:math_expressions/math_expressions.dart';

class Memory {
  String _expression = "0";
  String _result = "0";


  String get result {
    return _result;
  }

  String get expression {
    return _expression;
  }

  bool _isArithmeticOperation(String str){
    switch(str){
      case "+":
        return true;
      case "-":
        return true;
      case "*":
        return true;
      case "/":
        return true;
      default:
        return false;
    }
  }

  void _clearExpression(){
     _expression = "0";
  }

   void _clearResult(){
     _result = "0";
  }

  void _clearResultAndExpression(){
    _clearExpression();
    _clearResult();
  }

  void _deleteLastCharExpression(){
    if(_expression.length > 1){
      _expression = _expression.substring(0, _expression.length - 1);
    } else {
      _expression = "0";
    }
  }

  bool _canInsertPoint(String expr){
    int index = expr.length - 1;

    while(true){
      if(index == 0 && double.tryParse(expr[0]) != null){
        return true;
      } else if (expr[index] == ".") {
        return false;
      } else if (_isArithmeticOperation(expr[index])){
        if(index + 1 < expr.length && double.tryParse(expr[index + 1]) != null){
          return true;
        }else{
          return false;
        }
      }
      --index;
    }
  }

  void buttonPressedAction(String btnText){
    if(double.tryParse(btnText) != null){
      if(_expression == "0" || _expression == "*" || _expression == "/"){
        _expression = btnText;
      }else{
        _expression = expression + btnText;
      }
    }
    else if(_isArithmeticOperation(btnText)){
      if((double.tryParse(_expression[_expression.length - 1]) != null && _expression != "0") ||
        (_expression == "0" && (btnText == "*" || btnText == "/"))){
        _expression = _expression + btnText;
      } else {
        _expression = _expression.substring(0, _expression.length - 1) + btnText;
      }
    }
    else if (btnText == "AC"){
      _clearResultAndExpression();
    }
    else if(btnText == "C"){
      _deleteLastCharExpression();
    }
    else if (btnText == "." && _canInsertPoint(_expression)) {
      _expression = _expression + btnText;
    }
    else if(btnText == "="){
      _calculateExpression(_expression);
      _clearExpression();
    }
  }

  void _calculateExpression(String expr){
    Parser parser = Parser();
    Expression expressao = parser.parse(expr);

    // Avaliar a expressão
    _result = expressao.evaluate(EvaluationType.REAL, ContextModel()).toString() ;
    if(_result.length > 2 && _result[_result.length - 1] == "0" && _result[_result.length - 2] == "."){
      _result = _result.substring(0, _result.length - 2);
    }
  }
}