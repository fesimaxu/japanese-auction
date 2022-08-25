// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _nftId
    ) external;
}

contract japaneseAuction {
    // An initial price is displayed. This is usually a low price - it may be either 0 or the seller's reserve price.
    // All buyers that are interested in buying the item at the displayed price enter the auction arena.
    // The displayed price increases continuously, or by small discrete steps (e.g. one cent per second).
    // Each buyer may exit the arena at any moment.
    // No exiting buyer is allowed to re-enter the arena.
    // When a single buyer remains in the arena, the auction stops. The remaining buyer wins the item and pays the displayed price.

    // ****************state variables************

    // Auctioning Item
    IERC721 public immutable Nft;

    uint256 public immutable NftId;

    uint256 public immutable reservedPrice;

    uint256 immutable increaseRate;

    uint256 public startTime;

    address public beneficiary;

    address[] public buyers;

    bool endBidding;

    uint256 buyerIndex = 0;

    // modifier to check that the auction is still active
    modifier activeAuction() {
        require(buyers.length > 1, "auctioning not active");
        _;
    }

    // modifier that removes a buyer from the list of buyers whenever he bid below the reserved price
    modifier buyerExist(uint256 _index) {
        for (uint256 i = _index; i < buyers.length - 1; i++) {
            buyers[i] = buyers[i + 1];
            if (buyers[i] == msg.sender && msg.value < getPrice()) {
                buyers.pop();
            }
            buyerIndex++;
        }
        _;
    }

    // constructor
    constructor(
        address _nft,
        uint256 _nftId,
        address _beneficiary,
        uint256 _reservedPrice,
        uint256 _increaseRate,
        address[] memory _buyers
    ) {
        beneficiary = _beneficiary;
        reservedPrice = _reservedPrice;
        increaseRate = _increaseRate;
        buyers = _buyers;
        startTime = block.timestamp;

        Nft = IERC721(_nft);
        NftId = _nftId;
    }

    // fuction to get the price of the auctioning item that increases by a minutes
    function getPrice() public view returns (uint256) {
        uint256 auctionTime = startTime + 1 seconds;
        uint256 auctionRate = increaseRate * auctionTime;
        uint256 displayPrice = reservedPrice + auctionRate;

        return displayPrice;
    }

    // to validate buyers
    function validBuyer() private view returns (bool success) {
        address valid;
        for (uint256 i = 0; i < buyers.length; i++) {
            if (msg.sender == buyers[i]) {
                valid = msg.sender;
            }
        }
        assert(valid != address(0));
        success = true;
    }

    // bidding Function
    function bid() public payable activeAuction buyerExist(buyerIndex) {
        uint256 auctionPrice = getPrice();
        require(
            msg.value >= auctionPrice,
            "Bidding ETH is less than Auction price"
        );
        if (buyers.length == 1) {
            Nft.transferFrom(beneficiary, msg.sender, NftId);
        }

        endBidding = true;
    }
}
