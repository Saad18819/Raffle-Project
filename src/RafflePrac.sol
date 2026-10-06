// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract RafflePrac is VRFConsumerBaseV2Plus{

error raffle_Insuffbalance();
error raffle_Closed();
error raffle_checkUpKeepFailed(uint256 balance , uint256 length, uint256 raffleState);
error Winner_CheckFailed();

enum raffleState{
    open;
    close;
}

    uint256 private immutable i_entranceFee;
    address payable[] private s_RafflePlayer;
    raffleState private s_raffleState;
    uint256 private immutable i_interval;
    uint256 private s_selectingWinnerTimeStamp;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callBackGasLimit;
uint32 private constant NUM_WORDS = 1;
uint16 private constant REQ_CONFIRM = 3; 
address private immutable vrf;
uint256 private immutable i_subId;





    constructor(uint256 entranceFee, uint256 interval ,bytes32 gasLane,uint32 callBackLim , address vrfCoordinator, uint256 subId)VRFConsumerBaseV2Plus(vrfCoordinator){
        i_entranceFee = entranceFee;
        s_raffleState = raffleState.open;
        s_selectingWinnerTimeStamp = block.timestamp;
        i_interval = interval;
        i_gasLane = gasLane;
        s_callBackGasLimit = callBackLim;
        vrf = vrfCoordinator;
        i_subId = subId;
    }

event enterRaff(address indexed player);
event reqId(uint256 indexed Id);
event raffWin(address indexed player);



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



 function checkUpkeep(bytes calldata /* checkData */) public view  returns (bool upkeepNeeded,bytes memory /* performData */){

bool time = ((block.timestamp - s_selectingWinnerTimeStamp)>i_interval);
bool balance = (address(this).balance > 0);
bool length = s_RafflePlayer.length > 0;
bool state = (s_raffleState > raffleState.open);

upkeepNeeded = time && balance && length && state;
return (upkeepNeeded,"");



 }


function performUpkeep( bytes calldata /* performData */) external {

(bool upKeep,) = checkUpkeep("");
if(!upKeep){
    revert raffle_checkUpKeepFailed(address(this).balance , s_RafflePlayer.length , uint256(s_raffleState));

}

s_raffleState = raffleState.close;

uint256 requestID = s_vrfCoordinator.requestRandomWords(VRFV2PlusClient.RandomWordsRequest({
    keyHash: i_gasLane,
    subId: subId,
    requestConfirmations: REQ_CONFIRM,
    callbackGasLimit: s_callBackGasLimit,
    numWords: NUM_WORDS,
    extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: true})) // new parameter
  }));

emit reqId(requestID);



}

function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override{

    uint256 indexOfWinner = randomWords[0] % s_RafflePlayer;
    address payable recentWinner = s_RafflePlayer[indexOfWinner];

    s_RafflePlayer = new address payable[](0);
    s_raffleState = RaffleState.open;
    s_lastTimeStamp = block.timestamp;
emit raffWin(msg.sender);

(bool success,) = recentWinner.call{value:address(this).balance}("");
if(!success){
    revert Winner_CheckFailed();
}

}

}