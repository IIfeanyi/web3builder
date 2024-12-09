// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Web3Builders3 is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;

    constructor(address initialOwner)
        ERC721("Web3Builders3", "W3B")
        Ownable(initialOwner)
    {}

    bool public publicmintopen = false;
    bool public allowlistmintopen = false;

    uint availablenft = 1000;

    mapping(address => bool) public allowlist;
    
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmY5rPqGTN1rZxMQg2ApiSZc7JiBNs1ryDzXPZpQhC1ibm/";
    }

    function pause() public onlyOwner {
        _pause();
    }

   function unpause() public onlyOwner {
        _unpause();
    }

    function mintSwitch(bool _publicmintopen, 
    bool _allowlistmintopen) external onlyOwner {
    publicmintopen = _publicmintopen;
    allowlistmintopen = _allowlistmintopen;
    }

    function allowlistmint() public payable {
        require(allowlistmintopen, "Allowlist Mint Closed");
        require(allowlist[msg.sender], "You are not on the allow list");
        require(msg.value == 0.001 ether, "Not enough fund");
        internalmint();
    }

    function setAllowList(address[] calldata addresses) external onlyOwner {
        for(uint256 i = 0; i < addresses.length; i++)
            allowlist[addresses[i]] = true;}
        
    function publicMint() public payable {
        require(publicmintopen, "Public mint closed");
        require(msg.value == 0.01 ether, "Not enough fund");
        internalmint();
    }

    function internalmint() internal {
         require(totalSupply() < availablenft, "We're sold out" );
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

     function withdraw(address _addr) external onlyOwner {
        uint256 balalnce = address(this).balance;
        payable(_addr).transfer(balalnce);
     }
    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
