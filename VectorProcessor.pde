class VectorProcessor {

  String[] functionNames;                     //stored functions
  ArrayList<Expression> xEs, yEs, zEs;        //x,y, and z expression list
  ArrayList<String> xComps, yComps, zComps;   //x,y, and z plain text expression
  
  public VectorProcessor(int functionCount) {
    
    // define default functions
    functionNames = new String[functionCount+1];
    functionNames[0] = "<y, z, x>";
    functionNames[1] = "<y, -1, x>";
    functionNames[2] = "<y/z, -x/z, z/4>";
    functionNames[3] = "<1, 2, 3>";
    functionNames[4] = "<1, 2, z>";
    functionNames[5] = "<x, y, 2>";
    functionNames[6] = "<x, y, z>";
    functionNames[7] = "<x, -y, 0>";
    functionNames[8] = "<3+(x*y), x^2-y^2, 0>";
    functionNames[9] = "<3cos(y), -2*x, x+y>";
    functionNames[10] = "<y-(x/2), x+sqrt(y^2),sqrt(x^2+y^2)>";
    functionNames[11] = "<log(1+y^2), log(1+x^2),0>";
    functionNames[12] = "<-y, x, 0>";
    functionNames[13] = "<-y, (abs(x))/3, 0>";
    functionNames[14] = "<y*z, x*z, x*y>";
    functionNames[15] = "<3*sin(y*z), 3*sin(z*x), 3*sin(x*y)>";
    
    // generate x components from function storage
    xComps = new ArrayList<String>();
    yComps = new ArrayList<String>();
    zComps = new ArrayList<String>();
    for (int i = 0; i < functionNames.length; i++) {
      String[] comps = breakFunctionIntoComponents(i);
      xComps.add(comps[0]);
      yComps.add(comps[1]);
      zComps.add(comps[2]);
    }
    
    // generate expression objects from function components
    xEs = new ArrayList<Expression>();
    yEs = new ArrayList<Expression>();
    zEs = new ArrayList<Expression>();
    for (int i = 0; i < functionNames.length; i++) {
      Expression[] expression = generateExpressions(xComps.get(i), yComps.get(i), zComps.get(i)); 
      xEs.add(expression[0]);
      yEs.add(expression[1]);
      zEs.add(expression[2]);
    }
  }
  
  public void editFunction(int function, String expression) {
    String errName = functionNames[function];
    String[] errComps = {xComps.get(function), yComps.get(function), zComps.get(function)};
    Expression[] errExpressions = {xEs.get(function), yEs.get(function), zEs.get(function)};
    
    try {
      functionNames[function] = expression;
    
      String[] comps = breakFunctionIntoComponents(function);
      xComps.set(function, comps[0]);
      yComps.set(function, comps[1]);
      zComps.set(function, comps[2]);
    
      Expression[] expressions = generateExpressions(xComps.get(function), yComps.get(function), zComps.get(function));
      xEs.set(function, expressions[0]);
      yEs.set(function, expressions[1]);
      zEs.set(function, expressions[2]);
      
      editorError = false;
    }
    catch(Exception e) {
      functionNames[function] = errName;
      
      xComps.set(function, errComps[0]);
      yComps.set(function, errComps[1]);
      zComps.set(function, errComps[2]);
      
      xEs.set(function, errExpressions[0]);
      yEs.set(function, errExpressions[1]);
      zEs.set(function, errExpressions[2]);
      
      editorError = true;
    }
  }
  
  String functionName(int input) {
    return functionNames[input];
  }
  
  // this method is responsible for calculating the end vector produced by
  // a given function that is currently being stored. it is called is the second
  // version of this method so we called it calculateEnd2
  PVector calculateEnd2(PVector input, int function) {
    PVector result = new PVector();
    
    float[] param = new float[3];
    
    //HANDLE X
    String xComp = xComps.get(function);
    int[] charPos = new int[3];
    charPos[0] = xComp.indexOf('x');
    charPos[1] = xComp.indexOf('y');
    charPos[2] = xComp.indexOf('z');
    charPos = sort(charPos);
    int count = 0;
    for (int i = 0; i < 3; i++) {
      if (charPos[i] != -1) {
        if (xComp.charAt(charPos[i]) == 'x') {
          param[count] = input.x;
          count++;
        }
        if (xComp.charAt(charPos[i]) == 'y') {
          param[count] = input.y; 
          count++;
        }
        if (xComp.charAt(charPos[i]) == 'z') {
          param[count] = input.z; 
          count++;
        }
      }
    }
    
    result.x = input.x + xEs.get(function).eval(param[0],param[1],param[2]).answer().toFloat();
    
    
    //HANDLE Y
    String yComp = yComps.get(function);
    charPos[0] = yComp.indexOf('x');
    charPos[1] = yComp.indexOf('y');
    charPos[2] = yComp.indexOf('z');
    charPos = sort(charPos);
    count = 0;
    for (int i = 0; i < 3; i++) {
      if (charPos[i] != -1) {
        if (yComp.charAt(charPos[i]) == 'x') {
          param[count] = input.x;
          count++;
        }
        if (yComp.charAt(charPos[i]) == 'y') {
          param[count] = input.y; 
          count++;
        }
        if (yComp.charAt(charPos[i]) == 'z') {
          param[count] = input.z; 
          count++;
        }
      }
    }
    
    result.y = input.y + yEs.get(function).eval(param[0],param[1],param[2]).answer().toFloat();
    
    
    //HANDLE Z
    String zComp = zComps.get(function);
    charPos[0] = zComp.indexOf('x');
    charPos[1] = zComp.indexOf('y');
    charPos[2] = zComp.indexOf('z');
    charPos = sort(charPos);
    count = 0;
    for (int i = 0; i < 3; i++) {
      if (charPos[i] != -1) {
        if (zComp.charAt(charPos[i]) == 'x') {
          param[count] = input.x;
          count++;
        }
        if (zComp.charAt(charPos[i]) == 'y') {
          param[count] = input.y; 
          count++;
        }
        if (zComp.charAt(charPos[i]) == 'z') {
          param[count] = input.z; 
          count++;
        }
      }
    }

    result.z = input.z + zEs.get(function).eval(param[0],param[1],param[2]).answer().toFloat();
    
    
    return result;
  }
  
  // this method does exactly what the title suggests, it breaks
  // a full vector valued function into its x, y, z components and returns
  // them in a string array
  private String[] breakFunctionIntoComponents(int function) {
    String thisFunction = this.functionName(function);
    String[] comps = new String[3];
    
    
    boolean foundAll = false;
    int countFound = 0;
    int countString = 0;
    int[] endStrings = new int[2];
    while (!foundAll) {
      if (countString > thisFunction.length()) {
        break;
      }
      if (thisFunction.charAt(countString) == '>' && countFound == 2) {
        comps[2] = thisFunction.substring(endStrings[1], countString);
        foundAll = true;
      }
      if (thisFunction.charAt(countString) == ',' && countFound == 1) {
        comps[1] = thisFunction.substring(endStrings[0], countString);
        endStrings[1] = countString+1;
        countFound++;
      }
      if (thisFunction.charAt(countString) == ',' && countFound == 0 && thisFunction.charAt(0) == '<') {
        comps[0] =  thisFunction.substring(1,countString);
        endStrings[0] = countString+1;
        countFound++;
      }
      countString++;
    }
    comps[0] = comps[0].replaceAll("\\s", "");
    comps[1] = comps[1].replaceAll("\\s", "");
    comps[2] = comps[2].replaceAll("\\s", "");
    
    return comps;
  }
  
  // this method takes plain text component expressions and build indiviudal
  // expreession objects to do calculations with, they are returned in an
  // array of Expression objects
  private Expression[] generateExpressions(String xComp, String yComp, String zComp) {
    Expression[] expression = new Expression[3];
    
    expression[0] = Compile.expression(xComp, true);
    expression[1] = Compile.expression(yComp, true);
    expression[2] = Compile.expression(zComp, true);
    
    return expression;
  }
  
  //LEGACY CODE :D
  
  //update, think i fixed it xd
  //PVector calculateEnd(PVector input, int function, int vectorOrForce) {
  //  PVector result = new PVector();
    
  //  if (function == 0) {
  //    result.x = input.x + input.y;
  //    result.y = input.y + input.z;
  //    result.z = input.z + (input.x);
  //  }
  //  if (function == 1) {
  //    if (vectorOrForce == 0) {
  //      result.x = input.x + input.y;
  //      result.y = input.y -1;
  //      result.z = input.z + input.x;
  //    }
  //    else {
  //      result.x = input.x + input.y;
  //      result.y = input.y -100;
  //      result.z = input.z + input.x;
  //    }
  //  }
  //  if (function == 2) {
  //    if (vectorOrForce == 0) {
  //      result.x = input.x + (input.y/input.z);
  //      result.y = input.y -(input.x/input.z);
  //      result.z = input.z + input.z/4;
  //    }
  //    else {
  //      result.x = input.x + (input.y/input.z);
  //      result.y = input.y -(input.x/input.z);
  //      result.z = input.z + input.z/400;
  //    }
  //  }
  //  if (function == 3) {
  //    if (vectorOrForce == 0) {
  //      result.x = input.x + 1;
  //      result.y = input.y + 2;
  //      result.z = input.z + 3;
  //    }
  //    else {
  //      result.x = input.x + 100;
  //      result.y = input.y + 200;
  //      result.z = input.z + 300;
  //    }
  //  }
  //  if (function == 4) {
  //    if (vectorOrForce == 0) {
  //      result.x = input.x + 1;
  //      result.y = input.y + 2;
  //      result.z = input.z + input.z;
  //    }
  //    else {
  //      result.x = input.x + 100;
  //      result.y = input.y + 200;
  //      result.z = input.z + input.z;
  //    }
  //  }
  //  if (function == 5) {
  //    if (vectorOrForce == 0) {
  //      result.x = input.x + input.x;
  //      result.y = input.y + input.y;
  //      result.z = input.z + 2;
  //    }
  //    else {
  //      result.x = input.x + input.x;
  //      result.y = input.y + input.y;
  //      result.z = input.z + 200;
  //    }
  //  }
  //  if (function == 6) {
  //    result.x = input.x + input.x;
  //    result.y = input.y + input.y;
  //    result.z = input.z + input.z;
  //  }
  //  if (function == 7) {
  //    result.x = input.x + 3*cos(input.x);
  //    result.y = input.y + 3*cos(input.y);
  //    result.z = input.z + 3*sin(input.z);
  //  }
  //  if(function == 8) {
  //    if (vectorOrForce == 0) {
  //      result.x = input.x + (3 + (input.x*input.y));
  //      result.y = input.y + (pow(input.x,2) - pow(input.y,2));
  //      result.z = result.z + 0;
  //    }
  //    else {
  //      result.x = input.x + (300 + (input.x*input.y));
  //      result.y = input.y + (pow(input.x,2) - pow(input.y,2));
  //      result.z = result.z + 0;
  //    }
  //  }
  //  if(function == 9) {
  //    result.x = input.x + 3*cos(input.y);
  //    result.y = input.y + -2*input.x;
  //    result.z = input.z + (input.x+input.y);
  //  }
  //  if(function == 10) {
  //    if (vectorOrForce == 0) {
  //      result.x = input.x + (input.y - input.x/2);
  //      result.y = input.y + (input.x + pow(input.y, 1/2));
  //      result.z = input.z + (sqrt(pow(input.x,2) + pow(input.y,2)));
  //    }
  //    else {
  //      result.x = input.x + (input.y - input.x/200);
  //      result.y = input.y + (input.x + pow(input.y, 1/2));
  //      result.z = input.z + (sqrt(pow(input.x,2) + pow(input.y,2)));
  //    }
  //  }
  //  if (function == 11) {
  //    if (vectorOrForce == 0) {
  //      result.x = input.x + 1.5*log(1 + pow(input.y, 2));
  //      result.y = input.y + 1.5*log(1 + pow(input.x, 2));
  //      result.z = input.z + 0;
  //    }
  //    else {
  //      result.x = input.x + 1.5*log(100 + pow(input.y, 2));
  //      result.y = input.y + 1.5*log(100 + pow(input.x, 2));
  //      result.z = input.z + 0;
  //    }
  //  }
  //  if (function == 12) {
  //    result.x = input.x - input.y;
  //    result.y = input.y + input.x;
  //    result.z = input.z + 0;
  //  }
  //  if (function == 13) {
  //    result.x = input.x + input.y/3;
  //    result.y = input.y - pow(input.x, 3/2);
  //    result.z = input.z + 0;
  //  }
  //  if (function == 14) {
  //    result.x = input.x + (input.x + (input.y * input.z));
  //    result.y = input.y + (input.y + (input.x * input.z));
  //    result.z = input.z + (input.z + (input.x * input.y));
  //  }
  //  if (function == 15) {
  //    result.x = input.x + 3*(sin(input.y*input.z));
  //    result.y = input.y + 3*(sin(input.z*input.x));
  //    result.z = input.z + 3*(sin(input.x*input.y));
  //  }
  //  return result;
  //}
  
  
  
}
