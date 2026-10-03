// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

contract RafflePrac{

error raffle_Insuffbalance();

    uint256 private immutable i_entranceFee;
    address payable[] private s_RafflePlayer;

    constructor(uint256 entranceFee){
        i_entranceFee = entranceFee;
    }

event enterRaff(address indexed player);
function enterRaffle() public payable{
if(msg.sender<i_entranceFee){
    revert raffle_Insuffbalance();
}

s_RafflePlayer.push(msg.sender);
emit enterRaff(msg.sender);
}

}