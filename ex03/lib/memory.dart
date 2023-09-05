
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

  void _clearResultAndExpression(){
    _expression = "0";
    _result = "0";
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
      if(double.tryParse(_expression[_expression.length - 1]) != null && _expression != "0"){
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
      print("falta a função de =");
    }
  }

}