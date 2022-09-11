// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MultiSend{

    address owner;

    event SendAll (address to, uint amt);
    error SendFailed (address addr, uint amount);

    constructor () payable {
        owner = msg.sender;
    }

    /**
    * @dev returns the balance of the smart contract
    */
    function getContractBal() public view returns (uint bal){
        bal = address(this).balance;
    }

    function checkSendersBalance () public view returns (uint bal){
        bal = msg.sender.balance;
    }


    function sendAll (address[] calldata recievers, uint amt) external payable{
        uint arrLength = recievers.length;
        uint totalToSend = amt * arrLength;
        uint bal = checkSendersBalance ();
        require(bal > totalToSend, "Insufficient balance");

        for (uint i = 0; i < arrLength; i++) {
            if(recievers[i] != address(0)) {
                address _to = payable(recievers[i]);
                (bool sent, ) = _to.call{value: amt}("");

                require(sent, "Failed to send Ether");
                emit SendAll(recievers[i], amt);

            }else{
                revert SendFailed(recievers[0], amt);
            }
        }

    }

    function withdraw() external {
        require(msg.sender == owner, "only owner can withdraw");
        require(msg.sender != address(0), "can't withdraw to zero address");

        (bool sent,) = payable(owner).call{value: address(this).balance}("");
        require(sent, "withdrawal failed");
    }
    
}