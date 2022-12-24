// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Matik is ERC20 {
    constructor() ERC20("MATIK", "MATIC") {
    }   
    function reward(address _wallet, unit256 amount)external{
        _mint(_wallet, amount *1 ether);
    }
}