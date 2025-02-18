// Expression calculator syntax module definition
module CALC-BOOL-SYNTAX
    // Import the INT-SYNTAX module, which provides the K built-in integer sort (Int).
    imports INT-SYNTAX  // Int is the K built-in integer sort

    // Import the BOOL-SYNTAX module, which provides the K built-in Boolean sort (Bool).
    imports BOOL-SYNTAX // Bool is the K built-in Boolean sort

    // Expressions can be either integers or Booleans, defining the general expression syntax.
    syntax Exp ::= Int | Bool

    // Integer arithmetic syntax, defining precedence and associativity.
    syntax Int ::= 
        // Parentheses around an integer expression (E.g., (a)).
        // The [bracket] attribute indicates it is syntactic grouping.
        "(" Int ")" [bracket]   

      // Exponentiation has the highest precedence and left associativity.
      > left:                   
        Int "^" Int [function]  // Int "^" Int represents exponentiation (e.g., a ^ b)

      // Multiplication and division, lower precedence than exponentiation, both left associative.
      > left:                   
        Int "*" Int [function]  // Int "*" Int represents multiplication (e.g., a * b)
      | Int "/" Int [function]  // Int "/" Int represents division (e.g., a / b)

      // Addition and subtraction, lowest precedence in arithmetic, also left associative.
      > left:
        Int "+" Int [function]  // Int "+" Int represents addition (e.g., a + b)
      | Int "-" Int [function]  // Int "-" Int represents subtraction (e.g., a - b)

    // Integer comparison syntax, defines Boolean expressions for integer comparisons.
    syntax Bool ::= 
        // Parentheses around a Boolean expression (E.g., (true)).
        "(" Bool ")" [bracket]

      // Boolean comparison operations for integers.
      | Int "<=" Int [function] // Int "<=" Int represents 'less than or equal to' comparison (e.g., a <= b)
      | Int "<"  Int [function] // Int "<" Int represents 'less than' comparison (e.g., a < b)
      | Int ">=" Int [function] // Int ">=" Int represents 'greater than or equal to' comparison (e.g., a >= b)
      | Int ">"  Int [function] // Int ">" Int represents 'greater than' comparison (e.g., a > b)
      | Int "==" Int [function] // Int "==" Int represents equality comparison (e.g., a == b)
      | Int "!=" Int [function] // Int "!=" Int represents inequality comparison (e.g., a != b)

    // Propositional logic syntax for Boolean expressions.
    syntax Bool ::= 
      left: 
        // Boolean 'AND' operation between two Boolean expressions.
        Bool "&&" Bool [function] // Bool "&&" Bool represents logical 'AND' (e.g., b1 && b2)

      // Boolean 'OR' operation between two Boolean expressions.
      | Bool "||" Bool [function] // Bool "||" Bool represents logical 'OR' (e.g., b1 || b2)

endmodule // End of syntax module definition

// Expression calculator semantics module definition
module CALC-BOOL
    // Import the INT module, which provides built-in integer semantics.
    imports INT
    // Import the BOOL module, which provides built-in Boolean semantics.
    imports BOOL
    // Import the previously defined CALC-BOOL-SYNTAX module to use the syntax rules.
    imports CALC-BOOL-SYNTAX

    // Integer arithmetic semantics, defining how arithmetic expressions are evaluated.

    // Addition rule: rewriting an expression I1 + I2 into I1 +Int I2 using K's built-in integer addition.
    rule I1 + I2 => I1 +Int I2

    // Subtraction rule: rewriting an expression I1 - I2 into I1 -Int I2 using K's built-in integer subtraction.
    rule I1 - I2 => I1 -Int I2

    // Multiplication rule: rewriting an expression I1 * I2 into I1 *Int I2 using K's built-in integer multiplication.
    rule I1 * I2 => I1 *Int I2

    // Division rule: rewriting an expression I1 / I2 into I1 /Int I2 using K's built-in integer division.
    rule I1 / I2 => I1 /Int I2

    // Exponentiation rule: rewriting an expression I1 ^ I2 into I1 ^Int I2 using K's built-in integer exponentiation.
    rule I1 ^ I2 => I1 ^Int I2

    // Integer comparison semantics, defining how comparisons between integers are evaluated.

    // Less-than-or-equal-to rule: rewriting an expression I1 <= I2 into I1 <=Int I2 using K's built-in comparison.
    rule I1 <= I2 => I1 <=Int I2

    // Less-than rule: rewriting an expression I1 < I2 into I1 <Int I2 using K's built-in comparison.
    rule I1  < I2 => I1  <Int I2

    // Greater-than-or-equal-to rule: rewriting an expression I1 >= I2 into I1 >=Int I2 using K's built-in comparison.
    rule I1 >= I2 => I1 >=Int I2

    // Greater-than rule: rewriting an expression I1 > I2 into I1 >Int I2 using K's built-in comparison.
    rule I1  > I2 => I1  >Int I2

    // Equality rule: rewriting an expression I1 == I2 into I1 ==Int I2 using K's built-in equality.
    rule I1 == I2 => I1 ==Int I2

    // Inequality rule: rewriting an expression I1 != I2 into I1 =/=Int I2 using K's built-in inequality.
    rule I1 != I2 => I1 =/=Int I2

    // Propositional logic semantics, defining how Boolean expressions are evaluated.

    // Logical AND rule: rewriting an expression B1 && B2 into B1 andBool B2 using K's built-in Boolean AND.
    rule B1 && B2 => B1 andBool B2

    // Logical OR rule: rewriting an expression B1 || B2 into B1 orBool B2 using K's built-in Boolean OR.
    rule B1 || B2 => B1 orBool B2

endmodule // End of semantics module definition
