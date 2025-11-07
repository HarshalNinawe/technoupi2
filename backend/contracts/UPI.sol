// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UPI {
    string public name = "UPI Blockchain Token";
    string public symbol = "UPI";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * 10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        require(_to != address(0), "Invalid recipient");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        require(_to != address(0), "Invalid recipient");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    // UPI specific functions
    function mint(address _to, uint256 _value) public onlyOwner {
        require(_to != address(0), "Invalid recipient");

        uint256 amount = _value * 10**uint256(decimals);
        totalSupply += amount;
        balanceOf[_to] += amount;

        emit Mint(_to, amount);
        emit Transfer(address(0), _to, amount);
    }

    function burn(uint256 _value) public {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;

        emit Burn(msg.sender, _value);
        emit Transfer(msg.sender, address(0), _value);
    }

    // Get balance in ether units (for easier frontend handling)
    function getBalance(address _owner) public view returns (uint256) {
        return balanceOf[_owner] / 10**uint256(decimals);
    }

    // Transfer with ether units
    function transferEther(address _to, uint256 _etherAmount) public returns (bool success) {
        uint256 tokenAmount = _etherAmount * 10**uint256(decimals);
        return transfer(_to, tokenAmount);
    }
}
