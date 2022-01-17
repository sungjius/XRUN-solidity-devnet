// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.11;
// import "https://github.com/binodnp/openzeppelin-solidity/blob/master/contracts/introspection/ERC165.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "./IXRUN.sol";
/**
 * @dev Implementation of the basic standard multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by Enjin: https://github.com/enjin/erc-1155
 *
 * _Available since v3.1._
 */
contract XRUN_ERC1155_Stake is Context, ERC165, IERC1155, IERC1155MetadataURI {
    using Address for address;
    

    // Mapping from token ID to account balances
    mapping(uint256 => mapping(address => uint256)) private _balances;

    // Mapping from account to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
    string private _uri; 
    
    uint256 public constant StakingNumber = 1; 

    address public StakingChainID;
    address public StakingAddress;
    //최대 상한가격
    uint256 public StakingLimitAmount;
    
    int8 public StakingDecimal;
    int8 public StakingExpectation;
    uint256 public PoolLunched;
    uint256 public ExpireDate;
    bool public HasClosed;
    /*
        @01.14
    */
    struct Voter{
        uint256 voterId;
        address voterAddress;
    }
    uint256[] public voterList;
    uint256 public StakingLimitPrice;
    IXRUN  public ixrun;
	mapping (address => mapping (address => uint256)) public AmoutAllowance;

    mapping(uint256 => Voter) private voterStructs;
    modifier onlySaleDate {
		require(ExpireDate  > block.timestamp,"Over sale data...");
		_;
	}

    constructor(
            string memory uri_,  
            address stakingaddress_,
            int8 stakingexpectation_,
            uint stakinglimitprice_,
            uint256 stakinglimitamount_,
            uint256 expiredatebydate_,
            address contractAddress_) {
        _setURI(uri_); 
        StakingAddress = stakingaddress_;
        StakingLimitAmount = stakinglimitamount_;
        StakingDecimal = 16;
        StakingExpectation = stakingexpectation_;
        PoolLunched = block.timestamp;
        ExpireDate = block.timestamp + expiredatebydate_ * 1 days;
        StakingLimitPrice = stakinglimitprice_; 
        
        // _mint(msg.sender , StakingNumber, StakingLimitAmount, "");
        ixrun = IXRUN(contractAddress_);
        Test_mint(msg.sender , StakingNumber, StakingLimitAmount , PoolLunched , ExpireDate ,"" );
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
    function uri(uint256) public view virtual override returns (string memory) {
        return _uri;
    }

    /**
     * @dev See {IERC1155-balanceOf}.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
        require(account != address(0), "ERC1155: balance query for the zero address");
        return _balances[id][account];
    }

    /**
     * @dev See {IERC1155-balanceOfBatch}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
        public
        view
        virtual
        override
        returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }

    /**
     * @dev See {IERC1155-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC1155-isApprovedForAll}.
     */
    function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[account][operator];
    }
 

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );
        _safeTransferFrom(from, to, id, amount, data);
    }

  

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: transfer caller is not owner nor approved"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function _safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();
        _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }
        _balances[id][to] += amount;

        emit TransferSingle(operator, from, to, id, amount);

        // IXRUN ixrun = IXRUN(); 
        // ixrun.TransferByNFT(from , from , to , id , 20000000);        
        _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
    }

    function _safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
            _balances[id][to] += amount;
        }

        emit TransferBatch(operator, from, to, ids, amounts);

        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
    }

    function _setURI(string memory newuri) internal virtual {
        _uri = newuri;
    }

    function _mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);

        _balances[id][to] += amount;
        emit TransferSingle(operator, address(0), to, id, amount);

        _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
    }

    function _mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; i++) {
            _balances[ids[i]][to] += amounts[i];
        }

        emit TransferBatch(operator, address(0), to, ids, amounts);

        _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
    }

    function _burn(
        address from,
        uint256 id,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }

        emit TransferSingle(operator, from, address(0), id, amount);
    }

    function _burnBatch(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");

        for (uint256 i = 0; i < ids.length; i++) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
        }

        emit TransferBatch(operator, from, address(0), ids, amounts);
    }

    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC1155: setting approval status for self");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    mapping(uint256 => uint256) private _totalSupply;

    function totalSupply(uint256 id) public view virtual returns (uint256) {
        return _totalSupply[id];
    }
     
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {

        if (from == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                _totalSupply[ids[i]] += amounts[i];
            }
        }

        if (to == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                _totalSupply[ids[i]] -= amounts[i];
            }
        }
    }

    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
                if (response != IERC1155Receiver.onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
                bytes4 response
            ) {
                if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }

    /*
    @ 2022 01 14
    */

      function Test_ERC20Transfer(
        address _creatorAddress,
        address _customerAddress,
        uint256 _id,
        uint256 _amount,
        uint256 _price,
        bytes memory _data
    ) onlySaleDate public  {
     require(
            _creatorAddress == _msgSender() || isApprovedForAll(_creatorAddress, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );
        _ERC20Transfer(_creatorAddress, _customerAddress, _id, _amount,_price,_data);
    }
    


     function _ERC20Transfer(
        address _creatorAddress,
        address _customerAddress,
        uint256 _id,
        uint256 _amount,
        uint256 _price,
        bytes memory _data
    ) onlySaleDate internal virtual {
        require(_customerAddress != address(0), "ERC1155: transfer _customerAddress the zero address");
        address operator = _msgSender();
        
        _beforeTokenTransfer(operator, _creatorAddress, _customerAddress, _asSingletonArray(_id), _asSingletonArray(_amount), _data);

        uint256 fromBalance = _balances[_id][_creatorAddress];
        require(fromBalance >= _amount, "ERC1155: insufficient balance for transfer");
        unchecked {
            _balances[_id][_creatorAddress] = fromBalance - _amount;
        }
      

        emit TransferSingle(operator, _creatorAddress, _customerAddress, _id, _amount);

        ixrun.TransferByNFT(_creatorAddress , _customerAddress, _price);
        _balances[_id][_customerAddress] += _amount;
        Test_setVoterList(_id,_customerAddress);

        _doSafeTransferAcceptanceCheck(operator, _creatorAddress, _customerAddress, _id, _amount, _data);
    }

    function Test_ERC20Approve(
    address _spender, 
    uint256 _amount , 
    uint256 _value) 
    onlySaleDate public {
        address msgSender = _msgSender();
        require(msgSender != _spender, "ERC1155: setting approval status for self");

        ixrun.ApproveByNFT(msgSender,_spender, _value);
        AmoutAllowance[msgSender][_spender] = _amount;
        _setApprovalForAll(msgSender, _spender, true);
        _operatorApprovals[msgSender][_spender] = true;

        emit ApprovalForAll(msgSender, _spender, true);
    }
    function Test_ERC20transferFrom(
        address _from , 
        address _to ,
        uint256 _id, 
        uint256 _amount, 
        uint256 _value,
        bytes memory _data) onlySaleDate public  {
        address msgSender = _msgSender();
        require(
            _from == msgSender || isApprovedForAll(_from, msgSender),
            "ERC1155: caller is not owner nor approved"
        );
        require(_to != address(0), "ERC1155: transfer to the zero address");
        require(_amount <= AmoutAllowance[_to][msgSender],"ERC1155 : enter arg  more value than AmountAllowance input value ");

        ixrun.TransferFromByNFT(_from,_from ,_to , _value);
		AmoutAllowance[_to][msgSender] -= _amount;
        _safeTransferFrom(_from, _to, _id, _amount, _data);
    }

    function Test_mint( 
        address _to,
        uint256 _id,
        uint256 _amount,
        uint256 _lunched,
        uint256 _expireDate,
        bytes memory _data
     ) internal virtual {
        require(_to != address(0), "ERC1155: mint to the zero address");
        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), _to, _asSingletonArray(_id), _asSingletonArray(_amount), _data);

        _balances[_id][_to] += _amount;
        emit TransferSingle(operator, address(0), _to, _id, _amount);

        _doSafeTransferAcceptanceCheck(operator, address(0), _to, _id, _amount, _data);
    }

    function Test_BalanceOfERC20Token(address _to) view public returns (uint256) {
        return ixrun.BalanceOfERC20Token(_to);
    }

    function Test_setVoterList(uint256 _id,address _to) internal virtual {
        if(Test_verifyVoterList(_to) || voterList.length == 0){
            voterStructs[voterList.length].voterId = _id;
            voterStructs[voterList.length].voterAddress = _to;
            voterList.push(voterList.length);
        }
    }

    function Test_getVoter(uint256 _voterKey) view public 
    returns(address voterAddress , uint256 voterId ){
        return ( voterStructs[_voterKey].voterAddress,voterStructs[_voterKey].voterId );
    }
    //수정
    function Test_verifyVoterList(address _to) internal virtual returns (bool){
        if( voterList.length != 0 ){
            for (uint256 i = 0 ; i < voterList.length ; i++){
                if(voterStructs[i].voterAddress == _to){
                    return false;
                }else{
                    return true;
                }
            }
        }
    }

    function De_Test_getDate() view public returns(uint ,uint,uint){
        return (ExpireDate , PoolLunched,block.timestamp);
    }
    
}