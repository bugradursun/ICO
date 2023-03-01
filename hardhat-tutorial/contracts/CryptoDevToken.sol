// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {
    uint256 public constant tokenPrice = 0.001 ether;
    //each nft will give 10 tokens to user
    //10 tokens per user will be represented as 10 * (10**18)

    uint256 public constant tokensPerNFT = 10 * 10 ** 18; //10 NFT will be given
    uint256 public constant maxTotalSupply = 10000 * 10 ** 18; // total 1000 token

    ICryptoDevs CryptoDevsNFT; //CryptodevsNFT contract instance
    mapping(uint256 => bool) public tokenIdsClaimed; //mapping to keep track of which tokenıds have been claimed

    constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CRD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    /**
     * @dev Mints 'amount' # of CryptoDevTokens
     * Requirements: msg.value >= requiredprice and not surpassing max total supply w
     * which is 10.000 = 10 * 10 ** 18
     */

    function mint(uint256 amount) public payable {
        //dogru ether gonderildi mi ve toplam supply gecildi mi sartları
        uint256 _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "Ether sent is incorrect");
        uint256 amountWithDecimals = amount * 10 ** 18;
        require(
            (totalSupply() + amountWithDecimals <= maxTotalSupply),
            "Exceeds the max total supply available!"
        ); //totalSupply fnc is from ERC20.sol !!

        _mint(msg.sender, amountWithDecimals);
    }

    /**
     * @dev Mints tokens based on the number of NFT's held by the sender
     *
     */

    function claim() public {
        address sender = msg.sender;
        uint256 balance = CryptoDevsNFT.balanceOf(sender); //number of CryptoDev NFT's held by a sender adress
        require(balance > 0, "You don't own any Crypto Dev NFT");
        uint256 amount = 0; // UNCLAIMED TOKENIDS
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
            if (!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }
        require(amount > 0, "You have claimed all the tokens"); // that means if unclaimed tokens > 0 == false ise hepsi claimed olmus demek
        _mint(msg.sender, amount * tokensPerNFT);
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "Not enough amount to withdraw");

        address _owner = owner();
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send ether");
    }

    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
