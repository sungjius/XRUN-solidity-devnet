// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC1155.sol";

contract XRUNnftLands is ERC1155{
    uint256 public constant Land = 100;


    mapping(address => Voter) public voters;



    constructor() ERC1155("http://game.xrun/api.item/eid.json"){
        _mint( msg.sender, Land, 100, "");
    }
    function LandSellerReserve public bool (uint256 _amount, uint256 _value) {

    }
}