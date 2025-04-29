class Token {
  // Map storing account balances where key is account ID and value is balance
  var balances: map<int, int>

  /* Requirements:
   * 1. Transfers amount tokens from the caller's account to recipient.
   * 2. Reverts if the caller's balance is insufficient.
   * 3. Reverts if recipient is the zero address.
   */
  method Transfer(sender: int, recipient: int, amount: int)
    // Verify amount is non-negative
    requires amount >= 0                                
    // Requirement 2: Verify sender exists and has sufficient balance
    requires sender in balances                        
    requires balances[sender] >= amount                
    // Requirement 3: Prevent transfers to zero address
    requires recipient != 0                            
    modifies this
    // Ensure balances of uninvolved accounts remain unchanged
    ensures forall a :: a in old(balances) && a != sender && a != recipient ==>
      a in balances && balances[a] == old(balances[a])
  {
    // Requirement 1: Update balances in a single atomic operation:
    // 1. Deduct amount from sender
    // 2. Add amount to recipient
    balances := balances[sender := balances[sender] - amount]
                       [recipient := if recipient in balances 
                                   then balances[recipient] + amount 
                                   else amount];
  }
}
