// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

abstract contract BEP20Interface {
    function totalSupply() public virtual view returns (uint256);
    function balanceOf(address owner) public virtual view returns (uint256 balance);
    function allowance(address owner, address spender) public virtual view returns (uint256 remaining);
    function transfer(address to, uint256 value) public virtual returns (bool success);
    function approve(address spender, uint256 value) public virtual returns (bool success);
    function transferFrom(address from, address to, uint256 value) public virtual returns (bool success);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "Addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "Subtraction overflow");
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "Multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "Division by zero");
        uint256 c = a / b;
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "Modulo by zero");
        return a % b;
    }
}

contract Vebbo is BEP20Interface, SafeMath{
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;
    uint256 public supply = 50000000000000;
    string public name = "Vebbo";
    string public symbol = "VBO";
    uint256 public decimals = 8;

    constructor(){
        balances[msg.sender] = supply;
    }

    function totalSupply() public override view returns (uint256) {
        return supply;
    }

    function balanceOf(address owner) public override view returns(uint256 balance){
        return balances[owner];
    }

    function allowance(address owner, address spender) public override view returns (uint256 remaining) {
        return allowed[owner][spender];
    }

    function transfer(address to, uint256 value) public override returns(bool success){
        require(balanceOf(msg.sender) >= value, "balance too low");
        balances[to] = add(balances[to], value);
        balances[msg.sender] = sub(balances[msg.sender], value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public override returns(bool success){
        require(balanceOf(from) >= value, "balance too low");
        require(allowed[from][msg.sender] >= value, "allowance too low");
        balances[to] = add(balances[to], value);
        balances[from] = sub(balances[from], value);
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public override returns(bool success){
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
}