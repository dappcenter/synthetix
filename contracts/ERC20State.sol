/*
-----------------------------------------------------------------
FILE INFORMATION
-----------------------------------------------------------------
file:       ERC20State.sol
version:    0.3
author:     Dominic Romanowski

date:       2018-2-24

checked:    Anton Jurisevic
approved:   Samuel Brooks

-----------------------------------------------------------------
MODULE DESCRIPTION
-----------------------------------------------------------------

A contract that holds the state of an ERC20 compliant token.

This contract is used side by side with the ERC20Token that is implemented for Havven. It provides
an easy way to upgrade the logic of a contract while maintaining all user balances and allowances,
to make the changeover as easy as possible.

The way this would work, is the first deployed contract would create this state contract, and use it
as the store of balances. When a new contract is deployed, it would link to the existing state contract,
then the Owner of the state contract would change the associated contract to be the new one.

-----------------------------------------------------------------
*/

pragma solidity ^0.4.20;


import "contracts/Owned.sol";


contract ERC20State is Owned {

    // the address of the contract that can modify balances and allowances
    // this can only be changed by the owner of this contract
    address public associatedContract;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping (address => uint256)) public allowance;

    function ERC20State(
        address _owner, uint initialSupply,
        address initialBeneficiary, address _associatedContract
    )
        Owned(_owner)
        public
    {
        totalSupply = initialSupply;
        balanceOf[initialBeneficiary] = initialSupply;
        associatedContract = _associatedContract;
    }

    /* ========== SETTERS ========== */

    // Change the associated contract to a new address
    function setAssociatedContract(address _associatedContract)
        onlyOwner
        public
    {
        associatedContract = _associatedContract;
    }

    function setAllowance(address _from, address _to, uint _value)
        onlyAssociatedContract
        public
    {
        allowance[_from][_to] = _value;
    }

    function setBalance(address account, uint _value)
        onlyAssociatedContract
        public
    {
        balanceOf[account] = _value;
    }

    function setTotalSupply(uint _value)
        onlyAssociatedContract
        public
    {
        totalSupply = _value;
    }

    /* ========== MODIFIERS ========== */

    modifier onlyAssociatedContract
    {
        require(msg.sender == associatedContract);
        _;
    }
}
