// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./IERC721.sol";

  contract ERC721 is IERC721{
    
   //total nfts minted by the contract
    uint public totalNfts;

   //mapping total no of nfts owned by the address
   mapping(address=>uint256) private _balances;

   //mapping owner's all nfts to operator
   mapping(address=>mapping(address=>bool)) private _operatorApprovals;

   mapping(uint256=>address) private _tokenApprovals;

   //mapping nft ids to owners
   mapping(uint256=>address) private _owners;

   //mapping ids exists or not
   mapping(uint256=>bool) private _tokenExists;

    address _owner;

    constructor(){
        _owner=msg.sender;
    } 

    modifier onlyOwner{
        require(msg.sender==_owner,"only owner can mint new tokens");
        _;
    }

   //checking if token id already exists or not if exists same id can't be 
   //used for 2 nfts
   //token id shouldn't be already minted
   modifier tokenAlreadyExists(uint256 tokenId){
    require(_tokenExists[tokenId]==false,"TokenId has already been minted");
       _;
   }

   modifier isTokenIdValid(uint256 tokenId){
        //checking if tokenId exists or 
        address owner = _owners[tokenId];
        require(owner!=address(0),"invalid token id");
        _;
   } 

    function mint(address to,uint256 tokenId) external tokenAlreadyExists(tokenId) onlyOwner override{
        require(to!=address(0),"can't mint to zero address");
        totalNfts++;
        _balances[to]+=1;
        _tokenExists[tokenId]=true;
        _owners[tokenId]=to;
       //emit event transfer 
       //after transfer check if receiver implements IERC721 check
    }

    function ownerOf(uint256 tokenId) public isTokenIdValid(tokenId) view override returns (address){
        return _owners[tokenId];
    }

    function balanceOf(address owner) public view override returns (uint256){
        require(owner!=address(0),"zero address is invalid address");
        return _balances[owner];
    }


    function _approve(address operator,uint256 tokenId) private {
       _tokenApprovals[tokenId]=operator;
    }


    function approve(address operator,uint256 tokenId) public isTokenIdValid(tokenId) override {
        require(operator!=address(0),"can't approve for zero address");
        require(_owners[tokenId]==msg.sender || isApprovedForAll(msg.sender,operator),"nft is not owned by the caller nor is approved");
        _approve(operator,tokenId);
    }

    function setApprovalForAll(address operator,bool _approved) public override {
        require(operator!=address(0),"can't approve for zero address");
        require(operator!=msg.sender,"can't approve for the caller");
        _operatorApprovals[msg.sender][operator]=_approved;
    }

    function isApprovedForAll(address owner, address spender) public view override returns(bool){
        return _operatorApprovals[owner][spender];
    }


    //returns approved address for the token id
    function getApproved(uint256 tokenId) public view isTokenIdValid(tokenId) override returns(address operator){
        return _tokenApprovals[tokenId];
    }


    function _isApprovedForOrOwner(address spender,uint256 tokenId) private view returns (bool){
       address owner = _owners[tokenId];
       //spender is owner or approved for the token
       //may be spender is owner
       //spender is allowed to spend only that specific token
       //spender is allowed to spend all tokens of the owner
    (getApproved(tokenId)==spender || isApprovedForAll(owner,spender) || owner==spender) ? true : false;
    }

    function _transfer(address from, address to, uint256 tokenId) private{
        _balances[from]-=1;
        _balances[to]+=1;
        _owners[tokenId]=to;
        //remove the approval now as the token is being transfered
        delete _tokenApprovals[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId) public isTokenIdValid(tokenId) override{
        require(from!=address(0),"transfer form zero address");
        require(to!=address(0),"transfer to zero address");
        //checking if spender is owner or approved for the token
        require(_isApprovedForOrOwner(msg.sender,tokenId),"nor owner nor approved for the token");
        _transfer(from,to,tokenId);
        //emit event transfer 
        emit Transfer(from,to,tokenId);
    }
}