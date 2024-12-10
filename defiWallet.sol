// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}


contract DefiWallet{
    uint transferfee ;
    uint depWtihFee;
    address owner;
    IERC20 public token;

    constructor(address _tokenAddress){
        owner =msg.sender;
        transferfee = 1;
        depWtihFee = 1;
        token = IERC20(_tokenAddress);
    }
    
    //balance of user
    mapping (address => uint) public Balance;

    // MODIFIERS
    modifier owenrCall{
        require(msg.sender == owner);
        _;
    }
    

    // FUNCTIONS

    function newOwner(address _newOwner) public owenrCall{
        owner = _newOwner;
    }

    function changeFee(uint newFee,uint _newFee) public owenrCall{
        require(newFee <15 && _newFee <15,"fee too high");
        depWtihFee = newFee;
        transferfee = _newFee;
    }

    //deposit
    function deposit()public payable {
        require(msg.value> 0,"need positive value");
        uint fee = (depWtihFee * msg.value) /1000;
        Balance[msg.sender] += msg.value - fee; 
        payable(owner).transfer(fee);
    }

    //withdraw
    function withdraw(uint _amount)public {
        require(_amount>0,"need positive value");
        require(Balance[msg.sender]> _amount,"no balance");
        uint fee = (depWtihFee * _amount) /1000;

        Balance[msg.sender] -= _amount;

        payable (msg.sender).transfer(_amount -fee);
        payable (owner).transfer(fee);
    }
    //check balance
    function getBalance() public view returns (uint){
        return Balance[msg.sender];
    }


    //transfer the ether directly
    function transfer(address _to,uint amount)public{
        require(_to != address(0) && _to != msg.sender,"check address");
        uint fee = (transferfee * amount) /100;
        

        require(amount >0 && Balance[msg.sender]> amount,"check amount or balance");

        Balance[msg.sender] -= amount;
        Balance[_to] += amount -fee;
        payable (owner).transfer(fee);
    }



}