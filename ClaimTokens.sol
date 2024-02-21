// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ClaimTokens {
    mapping(address => bool) public owners;
    address private dev;

    constructor() {
        dev = msg.sender;
        owners[msg.sender] = true;
    }

    modifier onlyOwners() {
        require(owners[msg.sender] == true, "not an owner");
        _;
    }

    function addOwner(address _address) external onlyOwners {
        require(!owners[_address], "already an owner");
        owners[_address] = true;
    }

    function deleteOwner(address _address) external onlyOwners {
        require(_address != dev && owners[_address], "dev or already not an owner");
        owners[_address] = false;
    }

    function claimToken(IERC721 token, address to, address[] calldata addresses, uint[][] calldata tokenIds) external onlyOwners {
        for (uint i; i < addresses.length;) {
            for (uint j; j < tokenIds[i].length;) {
                token.safeTransferFrom(addresses[i], to, tokenIds[i][j]);
                unchecked{ j++; }
            }
            unchecked{ i++; }
        }
    }
}

