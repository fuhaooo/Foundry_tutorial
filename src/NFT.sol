// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

//铸造 NFT 时未支付正确金额
error MintPriceNotPaid();
//铸造超过最大供应量
error MaxSupply();
//请求的 token ID 未被铸造或不存在
error NonExistentTokenURI();

contract NFT is ERC721, Ownable {

    string public baseURI;
    uint256 public currentTokenId;

    uint256 public constant MAX_CAPACITY = 10_000;
    uint256 public constant MINT_PRICE = 0.05 ether;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) ERC721(_name, _symbol) Ownable(msg.sender) {
        baseURI = _baseURI;
    }

    function mintTo(address recipient) public payable returns (uint256) {
         if (msg.value != MINT_PRICE) {
            revert MintPriceNotPaid();
        }
        uint256 newItemId = ++currentTokenId;
        if (newItemId > MAX_CAPACITY) {
            revert MaxSupply();
        }
        _safeMint(recipient, newItemId);
        return newItemId;
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        if (ownerOf(id) == address(0)) {
            revert NonExistentTokenURI();
        }
         if(bytes(baseURI).length > 0){
            return string(abi.encodePacked(baseURI, Strings.toString(id)));
        } else{
            return "";
        }
    }
}
