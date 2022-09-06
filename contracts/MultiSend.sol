// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

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
        for (uint i = 0; i < arrLength; i++) {
            uint bal = checkSendersBalance ();
            require(bal > totalToSend, "Insufficient balance");
            if(recievers[i] != address(0)) {
                address _to = payable(recievers[i]);
                // payable(recievers[i]).transfer(amt);
                (bool sent, ) = _to.call{value: msg.value}("");
                require(sent, "Failed to send Ether");
                emit SendAll(recievers[i], msg.value);
            }else{
                revert SendFailed(recievers[0], amt);
            }
        }
    }
    
}

// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB","0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372","0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678","0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7","0x1aE0EA34a72D944a8C7603FfB3eC30a6669E454C","0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC","0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c","0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C","0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB","0xdD870fA1b7C4700F2BD7f44238821C26f7392148"]

// [0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db, 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB,0x617F2E2fD72FD9D5503197092aC168c91465E7f2,0x17F6AD8Ef982297579C203069C1DbfFE4348c372,0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678,0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7,0x1aE0EA34a72D944a8C7603FfB3eC30a6669E454C,0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC,0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c,0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB,0xdD870fA1b7C4700F2BD7f44238821C26f7392148]