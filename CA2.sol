// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract CA2 {
    mapping(address => uint256) private bal;

    // Events for deposit and withdrawal actions
    event Dep(address indexed user, uint256 amt);
    event Wd(address indexed user, uint256 amt);

    // Errors
    error NoVal();
    error LowBal(uint256 bal);
    error FailedTransfer();

    // Deposit Ether into the contract
    function dep() external payable {
        if (msg.value <= 0) revert NoVal();      
        bal[msg.sender] += msg.value;
        emit Dep(msg.sender, msg.value);
    }

    // Withdraw Ether following checks-effects-interactions pattern
    function wd(uint256 amt) external {
        if (bal[msg.sender] < amt) revert LowBal(bal[msg.sender]);

        // Deduct balance before transferring to prevent reentrancy
        bal[msg.sender] -= amt;

        // Transfer Ether after state change
        (bool sent, ) = msg.sender.call{value: amt}("");
        if (!sent) revert FailedTransfer();

        emit Wd(msg.sender, amt);
    }

    // View balance for a specific address
    function balOf(address user) external view returns (uint256) {
        return bal[user];
    }
}
