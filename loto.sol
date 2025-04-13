// SPDX-License-Identifier: MIT
pragma solidity >=0.0.7 <= 0.9.0;

contract Lottery{
uint public minFee;
address public owner;
address[] public players;
mapping (address=> uint) public playerBalance;

constructor(uint _minFee){
  minFee = _minFee;
  owner = msg.sender;
}

function play() public payable minFeepay {
  require(msg.value >= minFee, "por favor pagar el minimo");
  players.push(msg.sender);
  playerBalance[msg.sender] += msg.value;
}

function getBalance() public view returns(uint){
 return address(this).balance;
}
function getRandomNumber() public view returns(uint){
  return uint(keccak256(abi.encodePacked(owner,block.timestamp)));
}

function pickWinner() public {
  uint index = getRandomNumber() % players.length;
  for(uint i=0; i<players.length;i++){
    address playerAddress = players[i];
    (bool success,) = payable(playerAddress).call{value:playerBalance[playerAddress]}("");
    require(success,"pago fallido, por favor reintentar");
  }
  delete players;
}

modifier onlyOwner(){
 require(msg.sender == owner);
_;
}
modifier minFeepay(){
 require(msg.value >= minFee,"Por favor pague mas");
_;}
}