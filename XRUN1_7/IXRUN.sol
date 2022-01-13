 /*Submitted for verification at Etherscan.io on 2019-05-13*/
pragma solidity ^0.8.11;

interface IXRUN{
      function TransferByNFT(
        address  operator,
        address  from,
        address  to,
        uint256 id,
        uint256 value) external ;
}