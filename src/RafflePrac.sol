// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

contract RafflePrac{

error raffle_Insuffbalance();
error raffle_Closed();
error raffle_checkUpKeepFailed(uint256 balance , uint256 length, uint256 raffleState);

enum raffleState{
    open;
    close;
}

    uint256 private immutable i_entranceFee;
    address payable[] private s_RafflePlayer;
    raffleState private s_raffleState;
    uint256 private immutable i_interval;
    uint256 private s_selectingWinnerTimeStamp;

    constructor(uint256 entranceFee, uint256 interval){
        i_entranceFee = entranceFee;
        s_raffleState = raffleState.open;
        s_selectingWinnerTimeStamp = block.timestamp;
        i_interval = interval;
    }

event enterRaff(address indexed player);
event reqId(uint256 indexed Id);



function enterRaffle() public payable{
if(msg.sender<i_entranceFee){
    revert raffle_Insuffbalance();
}

if(s_raffleState != raffleState.open){
    revert raffle_Closed();
}

s_RafflePlayer.push(msg.sender);
emit enterRaff(msg.sender);

}


 function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded,bytes memory /* performData */){

bool time = ((block.timestamp - s_selectingWinnerTimeStamp)>i_interval);
bool balance = (address(this).balance > 0);
bool length = s_RafflePlayer.length > 0;
bool state = (s_raffleState > raffleState.open);

upkeepNeeded = time && balance && length && state;
return ((upkeepNeeded,""));



 }

function performUpkeep( bytes calldata /* performData */) external override {

(bool upKeep,) = checkUpkeep("");
if(!upKeep){
    revert raffle_checkUpKeepFailed(address(this).balance , s_RafflePlayer.length , uint256(s_raffleState));

}

s_raffleState = raffleState.close;

uint256 requestID = s_vrfCoordinator.requestRandomWords(VRFV2PlusClient.RandomWordsRequest({
    keyHash: keyHash,
    subId: subId,
    requestConfirmations: requestConfirmations,
    callbackGasLimit: callbackGasLimit,
    numWords: numWords,
    extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: true})) // new parameter
  }));

emit reqId(requestID);



}

}