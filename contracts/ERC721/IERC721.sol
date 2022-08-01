// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
interface IERC721{

    ///minting nfts owner specified function
    function mint(address to,uint256 tokenId) external;

    ///event Transfer is emitted when the token is tranfered
    event Transfer(address from, address to , uint256 tokenId);

    // ///event Approval is emitted when an operator is approved for a token
    // event Approval(address owner,address operator, uint256 tokenId);

    // ///event ApprovedForAll is emitted when a operator is approved
    // ///for all nfts of the owner
    // event ApprovedForAll(address owner,address operator, uint256 tokenId);

    /// returns the total no of nfts minted by this 
    /// contract holded by a specific owner
   function balanceOf(address owner) external view returns (uint256 balance);

   ////returns the address of the token owner
   function ownerOf(uint256 tokenId) external view returns (address owner);

   ///approves a address for operating owner's token
   function approve(address operator,uint256 tokenId) external;

//    ///approves the operator to spend all tokens in owners account
//    ///operator can use transferFrom and safeTransferFrom for all the approved tokens
//    ///boolean value to 
   function setApprovalForAll(address operator, bool _approved) external ;

//    ///returnsthe approved address for the token id
   function getApproved(uint256 tokenId) external view returns (address operator);

//    ///checks if the operator is allowed to use all nfts of owner
   function isApprovedForAll(address owner,address operator) external view returns(bool);

//    ///operator approved address will call transferFrom to transfer token from owner
//    ///to 
   function transferFrom(address from, address to,uint256 tokenId) external; 

//    ///checks if the receiver is a contract then it implements erc721 or not otherwise the 
//    ///sent tokens will be lost forever
//    function safeTransferFrom(address from, address to,uint256 tokenId) external;

//    ///same as safeTransferFrom with optional data parameter
//    function safeTransferFrom(address from, address to,uint256 tokenId,bytes calldata data) external;

}