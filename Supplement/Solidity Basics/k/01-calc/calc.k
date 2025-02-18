// Calculator syntax module definition
module CALC-SYNTAX
    // Import the INT-SYNTAX module, which provides the K built-in integer sort (Int).
    imports INT-SYNTAX  // Int is the K built-in integer sort

    // Defining the syntax rules for integer arithmetic expressions.
    syntax Int ::= 
        // Parentheses around an integer expression. 
        // This allows grouping of expressions like (E), 
        // with [bracket] indicating it is a syntactic wrapper.
        "(" Int ")" [bracket]   

      // Define higher precedence (>) of exponentiation and make it left associative.
      // left: means the expression associates to the left (e.g., a^b^c is parsed as (a^b)^c).
      > left:                   
        Int "^" Int [function]  // Int "^" Int is an exponentiation expression (e.g., a ^ b)
      
      // Define lower precedence for multiplication and division, both are left associative.
      > left:                   
        Int "*" Int [function]  // Int "*" Int is a multiplication expression (e.g., a * b)
      | Int "/" Int [function]  // Int "/" Int is a division expression (e.g., a / b)

      // Define even lower precedence for addition and subtraction, again left associative.
      > left:
        Int "+" Int [function]  // Int "+" Int is an addition expression (e.g., a + b)
      | Int "-" Int [function]  // Int "-" Int is a subtraction expression (e.g., a - b)

endmodule  // End of syntax module definition

// Calculator semantics module definition
module CALC
    // Import the INT module, which provides the semantic definitions for integers.
    imports INT         
    // Import the previously defined CALC-SYNTAX module to use the defined syntax.
    imports CALC-SYNTAX

    // Defining the semantic rules for each arithmetic operation.
    // The symbol => indicates a rewriting rule, transforming the left-hand side (LHS) 
    // into the right-hand side (RHS) during evaluation.

    // Addition rule: an expression of the form E1 + E2 is rewritten into E1 +Int E2.
    // +Int is the built-in K function for integer addition.
    rule E1 + E2 => E1 +Int E2

    // Subtraction rule: an expression of the form E1 - E2 is rewritten into E1 -Int E2.
    // -Int is the built-in K function for integer subtraction.
    rule E1 - E2 => E1 -Int E2

    // Multiplication rule: an expression of the form E1 * E2 is rewritten into E1 *Int E2.
    // *Int is the built-in K function for integer multiplication.
    rule E1 * E2 => E1 *Int E2

    // Division rule: an expression of the form E1 / E2 is rewritten into E1 /Int E2.
    // /Int is the built-in K function for integer division.
    rule E1 / E2 => E1 /Int E2

    // Exponentiation rule: an expression of the form E1 ^ E2 is rewritten into E1 ^Int E2.
    // ^Int is the built-in K function for integer exponentiation.
    rule E1 ^ E2 => E1 ^Int E2

endmodule  // End of semantics module definition
