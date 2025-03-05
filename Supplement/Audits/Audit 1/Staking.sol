// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld {
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    address public owner;
    uint256 public maxSupply = 2**256 - 1; // Maximum possible supply
    uint256 public rewardRate = 1; // Reward rate for staking

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Staked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 reward);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Stake) public stakes;

    constructor() {
        owner = msg.sender;
        totalSupply = 1000000; // Initial total supply
        balances[owner] = totalSupply;
    }

    // Deposit ether into the contract
    function deposit() public payable {
        require(msg.value > 0, "Deposit value must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw ether from the contract
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        if (_amount > 0) {
            (bool success, ) = msg.sender.call{value: _amount}("");
            require(success, "Withdrawal failed");

            balances[msg.sender] -= _amount;
            emit Withdraw(msg.sender, _amount);
        }
    }

    // Transfer tokens to another address
    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(_to != address(0), "Invalid address");

        balances[_to] += _amount;
        balances[msg.sender] -= _amount;

        emit Transfer(msg.sender, _to, _amount);
    }

    // Mint new tokens (with hidden overflow)
    function mint(uint256 _amount) public {
        require(msg.sender == owner, "Only the owner can mint tokens");
        require(totalSupply + _amount <= maxSupply, "Exceeds maximum supply");
        totalSupply += _amount;
        balances[owner] += _amount;
    }

    // Stake tokens to earn rewards
    function stake(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(_amount > 0, "Cannot stake zero tokens");

        if (stakes[msg.sender].amount > 0) {
            claimReward();
        }

        balances[msg.sender] -= _amount;
        stakes[msg.sender] = Stake(_amount, block.timestamp);
        emit Staked(msg.sender, _amount);
    }

    // Claim staking rewards
    function claimReward() public {
        require(stakes[msg.sender].amount > 0, "No tokens staked");

        uint256 stakingDuration = block.timestamp - stakes[msg.sender].timestamp;
        uint256 reward = stakingDuration * rewardRate * stakes[msg.sender].amount;

        require(reward + balances[msg.sender] >= balances[msg.sender], "Reward calculation overflow");

        balances[msg.sender] += reward;
        stakes[msg.sender].timestamp = block.timestamp;
        emit RewardClaimed(msg.sender, reward);
    }

    // Transfer ownership of the contract
    function transferOwnership(address _newOwner) public {
        require(msg.sender == owner, "Only the owner can transfer ownership");
        require(_newOwner != address(0), "New owner cannot be zero address");

        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    // Fallback function to receive ether
    receive() external payable {
        deposit();
    }

    // Additional function to make code analysis more complex
    function complexOperation(uint256 _input) public view returns (uint256) {
        require(_input > 0, "Input must be greater than 0");

        uint256 temp = _input * 2;
        uint256 result = temp;

        if (_input % 2 == 0) {
            result += temp / 2;
        } else {
            result -= temp / 3;
        }

        return result;
    }

    // Batch transfer function with a hidden vulnerability
    function batchTransfer(address[] memory _recipients, uint256[] memory _amounts) public {
        require(_recipients.length == _amounts.length, "Recipients and amounts arrays must be the same length");

        for (uint256 i = 0; i < _recipients.length; i++) {
            transfer(_recipients[i], _amounts[i]);
        }
    }
}