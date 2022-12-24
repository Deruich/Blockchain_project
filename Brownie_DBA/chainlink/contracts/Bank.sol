// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Bank {
    address private owner;
    struct Client{
        string id;
        string nom;
        string prenom;
        uint256 balance;
        uint256 created_at;
    }
    mapping(address => Client) public listClients;
    event addClientLog(address,uint256);
    event depositLog(address , uint256,uint256);
    event witdhrawLog(address,uint256,uint256);
    event deleteClientLog(address, uint256);

    struct Account {
        uint256  amount;
        address owner;
    }
    mapping(address=>uint) public clientAccount;
    mapping(address=>bool) public clientExists;

    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    function addClient(string memory _id, string memory _nom , string memory _prenom)
    external{
        require(listClients[msg.sender].created_at == 0,"Client exists");
        listClients[msg.sender].id = _id;
        listClients[msg.sender].nom = _nom;
        listClients[msg.sender].prenom = _prenom;
        listClients[msg.sender].balance = 0 ether;
        listClients[msg.sender].created_at = block.timestamp;
        emit addClientLog(msg.sender,block.timestamp);    
    }

    function getClient(string memory _id) external view returns (Client memory){
        require(listClients[msg.sender].created_at != 0,"Client does not exist");
        return listClients[msg.sender]; 
    }

    function deleteClient(address _Client) external onlyOwner{
        require(listClients[_Client].created_at !=0, "Client does not Client");
        delete listClients[_Client];
        payable(msg.sender).transfer(listClients[_Client].balance);
        emit deleteClientLog(_Client,block.timestamp);
    }

    function createAcc() public payable returns(string memory){
      require(clientExists[msg.sender]==false,'Account Already Created');
      if(msg.value==0){
          clientAccount[msg.sender]=0;
          clientExists[msg.sender]=true;
          return 'account created';
      }
      require(clientExists[msg.sender]==false,'account already created');
      clientAccount[msg.sender] = msg.value;
      clientExists[msg.sender] = true;
      return 'account created';
    }

    function deposit() public payable returns(string memory){
      require(clientExists[msg.sender]==true, "Account is not created");
      // 50 usd = 0.04101638604622546 eth
      require(msg.value>4.1*10*15 wei, "Please deposit at least 50 $");
      clientAccount[msg.sender]=clientAccount[msg.sender]+msg.value;
      return "Deposited Succesfully";
    }
   function witdhraw(uint256 _amount)external payable returns(string memory){
       require(listClients[msg.sender].created_at != 0, "client does not exist");
       require(listClients[msg.sender].balance > _amount,"not enough balance");
       payable(msg.sender).transfer(_amount);
       return 'withdrawal Succesful';
   }
    
   //Here TransferAmount function transfers amount from one account to other account in the bank only 
   //and both cliens must have created account on the bank to use this function 
    function TransferAmount(address payable clientAddress, uint amount) public returns(string memory){
      require(clientAccount[msg.sender]>amount, 'insufficeint balance in Bank account');
      require(clientExists[msg.sender]==true, 'Account is not created');
      require(clientExists[clientAddress]==true, 'to Transfer account does not exists in bank accounts ');
      require(amount>0, 'Enter non-zero value for sending');
      clientAccount[msg.sender]=clientAccount[msg.sender]-amount;
      clientAccount[clientAddress]=clientAccount[clientAddress]+amount;
      return 'transfer succesfully';
    }

    //Here sender's amount will be transfered from account in the bank to othe receiver's wallet 
    function sendPolygone(address payable toAddress , uint256 amount) public payable returns(string memory){
      require(amount>0, 'Enter non-zero value for withdrawal');
      require(clientExists[msg.sender]==true, 'Account is not created');
      require(clientAccount[msg.sender]>amount, 'insufficeint balance in Bank account');
      clientAccount[msg.sender]=clientAccount[msg.sender]-amount;
      toAddress.transfer(amount);
      return 'transfer success';
    }

    function clientAccountBalance() public view returns(uint){
      return clientAccount[msg.sender];
    }
  
    function accountExist() public view returns(bool){
      return clientExists[msg.sender];
    }
  
}