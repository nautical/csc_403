contract Vulnerable {
    mapping(address => uint256) public balances;

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount);
        
        balances[msg.sender] -= _amount;

        msg.sender.call.value(_amount)("");
    }
}
