// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockedPension {
    address public owner;
    uint public unlockTime;
    mapping(address => uint) public balances;

    event Deposit(address indexed account, uint amount);
    event Withdrawal(address indexed account, uint amount);

    constructor(uint _unlockTime) {
        owner = msg.sender;

        
        unlockTime = _unlockTime;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier afterUnlockTime() {
        require(block.timestamp >= unlockTime, "Funds are still time-locked");
        _;
    }

     function deposit(uint amount) external {
        require(amount > 0, "Deposit amount must be greater than zero");
        
        balances[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint _amount) external onlyOwner afterUnlockTime {
        
        require(_amount > 0, "Withdrawal amount must be greater than zero");
        require(_amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _amount;
        
        emit Withdrawal(owner, _amount);
        
    }

    function getBalance() external view returns (uint) {
        return balances[msg.sender];
    }

      receive() external payable {
        // Log event or perform any necessary actions
    }
}
