// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MysteryBoxBase is ERC721, Ownable {
    IERC20 public immutable usdc;

    uint256 public constant REQUIRED_USDC = 1_000 * 1e6;
    uint256 public tokenIdCounter;

    mapping(address => bool) public hasClaimed;
    bool public mintActive = true;

    constructor(address _usdc) ERC721("Base Mystery Box", "BMBX") {
        usdc = IERC20(_usdc);
    }

    function claimBox() external {
        require(mintActive, "Mint is paused");
        require(!hasClaimed[msg.sender], "Already claimed");
        require(
            usdc.balanceOf(msg.sender) >= REQUIRED_USDC,
            "Not enough USDC"
        );

        hasClaimed[msg.sender] = true;

        tokenIdCounter++;
        _safeMint(msg.sender, tokenIdCounter);
    }

    function setMintActive(bool _active) external onlyOwner {
        mintActive = _active;
    }

    function emergencyMint(address to) external onlyOwner {
        tokenIdCounter++;
        _safeMint(to, tokenIdCounter);
    }
}
