// Substitution syntax module definition
module SUBST-SYNTAX
   // Import the INT-SYNTAX module, providing the K built-in integer sort (Int).
   imports INT-SYNTAX   // Int is the K built-in integer sort

   // Import the BOOL-SYNTAX module, providing the K built-in Boolean sort (Bool).
   imports BOOL-SYNTAX  // Bool is the K built-in Boolean sort

   // Import the ID module, providing the K built-in sort for identifiers (Id), which are used for variables.
   imports ID           // Id is the K built-in sort for identifiers (variables)

   // Define expressions (Exp) as either integer expressions (IExp) or Boolean expressions (BExp).
   syntax Exp ::= IExp | BExp

   // Integer expressions (IExp) can be either:
   // - An integer value (Int) or 
   // - A variable identifier (Id).
   syntax IExp ::= Int | Id

   // Arithmetic operations are defined for integer expressions (IExp).
   // These include exponentiation (^), multiplication (*), division (/), addition (+), and subtraction (-).
   syntax IExp ::=  IExp "^" IExp  // Exponentiation
                  | IExp "*" IExp  // Multiplication
                  | IExp "/" IExp  // Division
                  > IExp "+" IExp  // Addition (lower precedence than *, /, and ^)
                  | IExp "-" IExp  // Subtraction (same precedence as addition)

   // Brackets are used for grouping integer expressions.
   syntax IExp ::= "(" IExp ")" [bracket]
                  
   // Boolean expressions (BExp) are defined as:
   // - A Boolean value (Bool).
   syntax BExp ::= Bool

   // Boolean expressions (BExp) can include integer comparison operators:
   // - Less than or equal (<=), less than (<), greater than or equal (>=), greater than (>), equal to (==), and not equal to (!=).
   syntax BExp ::=  IExp "<=" IExp  // Less than or equal to
                  | IExp "<"  IExp  // Less than
                  | IExp ">=" IExp  // Greater than or equal to
                  | IExp ">"  IExp  // Greater than
                  | IExp "==" IExp  // Equal to
                  | IExp "!=" IExp  // Not equal to

   // Boolean expressions can also include logical operators (&& for AND, || for OR).
   syntax BExp ::=  BExp "&&" BExp  // Logical AND
                  | BExp "||" BExp  // Logical OR

   // Brackets are used for grouping Boolean expressions.
   syntax BExp ::= "(" BExp ")" [bracket]

endmodule  // End of syntax module definition

// syntax Exp ::= IExp | BExp
// I => Int + IDs
// Substitution and evaluation module definition
module SUBST
   // Import necessary modules:
   // - INT for integer operations, 
   // BOOL for Boolean operations, 
   // MAP for the map store functionality, 
   // and SUBST-SYNTAX for the syntax defined above.

   imports INT
   imports BOOL
   imports MAP
   imports SUBST-SYNTAX

   // Configuration defines the initial context for the execution.
   configuration
      // The <k> cell contains the program (expression) to be evaluated.
      <k> $PGM:Exp </k>

      // The <store> cell contains the variable store (as a map), 
      // associating variable identifiers (Id) with their integer values.
      <store> 
         #token("a", "Id") |-> 16  // Variable a is mapped to the value 16
         #token("b", "Id") |-> 8   // Variable b is mapped to the value 8
         #token("c", "Id") |-> 4   // Variable c is mapped to the value 4
         #token("d", "Id") |-> 2   // Variable d is mapped to the value 2
      </store>

   // Rule for evaluating an integer expression via explicit substitution.
   rule 
      <k> IE:IExp => substI(IE, STORE) ... </k>  // Substitute IE (integer expression) using substI function
      <store> STORE </store>                     // The STORE contains the variable-to-value mappings
      requires notBool isInt(IE)                 // Only apply this rule if IE is not already an integer

   // Rule for evaluating a Boolean expression via explicit substitution.
   rule 
      <k> BE:BExp => substB(BE, STORE) ... </k>  // Substitute BE (Boolean expression) using substB function
      <store> STORE </store>                     // The STORE contains the variable-to-value mappings
      requires notBool isBool(BE)                // Only apply this rule if BE is not already a Boolean value

   // Integer expression substitution function (substI) definition.
   syntax Int ::= substI ( IExp , Map ) [function]

   // Base case: If the integer expression is a concrete integer value, it evaluates to itself.
   rule substI(I:Int, _SUBST) => I

   // Base case: If the integer expression is a variable (Id), look up its value in the STORE map.
   rule substI(I:Id, SUBST) => {SUBST [ I ]}:>Int  // Retrieve the value of I from the map and convert to Int

   // Inductive cases for integer operations:
   // - These rules recursively evaluate both sides of the expression and apply the appropriate integer operation.

   rule substI(I1 + I2, SUBST) => substI(I1, SUBST) +Int substI(I2, SUBST)  // Addition
   rule substI(I1 - I2, SUBST) => substI(I1, SUBST) -Int substI(I2, SUBST)  // Subtraction
   rule substI(I1 * I2, SUBST) => substI(I1, SUBST) *Int substI(I2, SUBST)  // Multiplication
   rule substI(I1 / I2, SUBST) => substI(I1, SUBST) /Int substI(I2, SUBST)  // Division
   rule substI(I1 ^ I2, SUBST) => substI(I1, SUBST) ^Int substI(I2, SUBST)  // Exponentiation

   // Boolean expression substitution function (substB) definition.
   syntax Bool ::= substB ( BExp , Map ) [function]

   // Base case: If the Boolean expression is a concrete Boolean value, it evaluates to itself.
   rule substB(B:Bool , _SUBST) => B

   // Inductive cases for Boolean operations:
   // - These rules recursively evaluate integer comparisons and Boolean operations, using previously defined substI for integer expressions.

   rule substB(I1 <= I2, SUBST) => substI(I1, SUBST)  <=Int substI(I2, SUBST)  // Less than or equal
   rule substB(I1  < I2, SUBST) => substI(I1, SUBST)   <Int substI(I2, SUBST)  // Less than
   rule substB(I1 >= I2, SUBST) => substI(I1, SUBST)  >=Int substI(I2, SUBST)  // Greater than or equal
   rule substB(I1  > I2, SUBST) => substI(I1, SUBST)   >Int substI(I2, SUBST)  // Greater than
   rule substB(I1 == I2, SUBST) => substI(I1, SUBST)  ==Int substI(I2, SUBST)  // Equal to
   rule substB(I1 != I2, SUBST) => substI(I1, SUBST) =/=Int substI(I2, SUBST)  // Not equal to

   // Inductive cases for Boolean logical operations:
   rule substB(B1 && B2, SUBST) => substB(B1, SUBST) andBool substB(B2, SUBST)  // Logical AND
   rule substB(B1 || B2, SUBST) => substB(B1, SUBST)  orBool substB(B2, SUBST)  // Logical OR

endmodule  // End of substitution module definition
