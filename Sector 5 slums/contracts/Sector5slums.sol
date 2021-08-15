//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
interface ERC165 {
	function supportsInterface(bytes4 interfaceID) external view returns(bool);
}
interface ERC721 is ERC165 {
	event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
	event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
	event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

	function balanceOf(address _owner) external view returns(uint256);
	function ownerOf(uint256 _tokenId) external view returns(address);
	function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external;
	function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
	function transferFrom(address _from, address _to, uint256 _tokenId) external;
	function approve(address _approved, uint256 _tokenId) external;
	function setApprovedForAll(address _operator, bool _approved) external;
	function isApprovedForAll(address _owner, address _operator) external view returns(bool);
}
interface ERC721TokenReceiver {
	function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
}
interface ERC721Metadata is ERC721 {
	function name() external view returns(string memory);
	function symbol() external view returns (string memory);
	function tokenURI(uint256 _tokenId) external view returns(string memory);
}
abstract contract Context {
	function _msgSender() internal view virtual returns(address) {
		return msg.sender;
	}
	function _msgData() internal view virtual returns(bytes calldata) {
		return msg.data;
	}
}
abstract contract Ownable is Context {
	address private _owner;
	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
	constructor() {
		_setOwner(_msgSender());
	}
	function owner() public view virtual returns(address) {
		return _owner;
	}
	modifier onlyOwner() {
		require(owner() == _msgSender(), 'Error: not the owner');
		_;
	}
	function renounceOwnership() public virtual onlyOwner {
		_setOwner(address(0));
	}
	function transferOwnership(address newOwner) public virtual onlyOwner {
		require(newOwner != address(0), 'Error: new owner is zero address');
		_setOwner(newOwner);
	}
	function _setOwner(address newOwner) private {
		address oldOwner = _owner;
		_owner = newOwner;
		emit OwnershipTransferred(oldOwner, newOwner);
	}
}
library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}
library Address {
	function isContract(address account) internal view returns(bool) {
		uint256 size;
		assembly {
			size := extcodesize(account)
		}
		return size > 0;
	}
	function sendValue(address payable recipient, uint256 amount) internal {
		require(address(this).balance >= amount, 'Address: Insufficient balance');
		(bool success, ) = recipient.call{value:amount}('');
		require(success, 'Address: Unable to send value');
	}
	function functionCall(address target, bytes memory data, string memory errorMessage) internal returns(bytes memory) {
		return functionCallWithValue(target, data, 0, errorMessage);
	}
	function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns(bytes memory) {
		require(address(this). balance >= value, 'Address: Insufficient balance for call');
		require(isContract(target),'Address: Call to non-contract');
		(bool success, bytes memory returndata) = target.call{value:value}(data);
		return verifyCallResult(success, returndata, errorMessage);
	} 
	function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns(bytes memory) {
		require(isContract(target), 'Address: Static to non-contract');
		(bool success, bytes memory returndata) = target.staticcall(data);
		return verifyCallResult(success, returndata, errorMessage);
	}
	function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns(bytes memory) {
		require(isContract(target), 'Address: Delegate call to non-contract');
		(bool success, bytes memory returndata) = target.delegatecall(data);
		return verifyCallResult(success, returndata,errorMessage);
	}
	function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns(bytes memory) {
		if(success) {
			return returndata;
		} else {
			if(returndata.length > 0) {
				assembly {
					let returndata_size := mload(returndata)
					revert(add(32, returndata), returndata_size)
				}
			} else {
				revert(errorMessage);
			}
		}
	}
}
library Strings {
	bytes16 private constant _HEX_SYMBOLS = '0123456789abcdef';
	function toString(uint256 value) internal pure returns(string memory) {
		if(value == 0) {
			return '0';
		}
		uint256 temp = value;
		uint256 digits;
		while(temp != 0) {
			digits++;
			temp /= 10;
		}
		bytes memory buffer = new bytes(digits);
		while(value != 0) {
			digits -= 1;
			buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
			value /= 10;
		}
		return string(buffer);
	}
	function toHexString(uint256 value, uint256 length) internal pure returns(string memory) {
		bytes memory buffer = new bytes(2 * length + 2);
		buffer[0] = '0';
		buffer[1] = 'x';
		for(uint256 i = 2 * length + 1; i > 1; --i) {
			buffer[1] = _HEX_SYMBOLS[value & 0xf];
			value >>= 4;
		}
		require(value == 0, 'Strings: Hex length insufficient');
		return string(buffer);
	}
}
contract Sector5slums is VRFConsumerBase, ERC165, ERC721, ERC721TokenReceiver, ERC721Metadata, Context, Ownable {
	using SafeMath for uint256;
	using Address for address;
	using Strings for string;

	string private _name = 'AERITH';
	string private _symbol = 'AERIS';

	bytes32 internal _keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
    uint256 internal _fee = 0.1 * 10**18; // 0.1 LINK
    uint256 public randomResult;
    address public _VRFCoordinator = 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B;
    address public _LinkToken = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;

    struct Aerith {uint256 Strength; uint256 Magic;  uint256 Vitality; 
    uint256 Spirit; uint256 Luck; uint256 Speed; uint256 Level; string aerith;}

    Aerith[] public aeriths;

    mapping(bytes32 => string) requestToAerithName;
    mapping(bytes32 => address) requestToSender;
    mapping(bytes32 => uint256) requestTo_tokenId;
	
	mapping(uint256 => string) private _tokenURIs;
	mapping(uint256 => address) private _owners;
	mapping(uint256 => address) private _tokenApprovals;
	mapping(address => uint256) private _balances;
	mapping(address => mapping(address => bool)) private _operatorApprovals;
	
	constructor() VRFConsumerBase(_VRFCoordinator, _LinkToken) {
    }
	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
		return 
		interfaceId == type(ERC721).interfaceId ||
		interfaceId == type(ERC721TokenReceiver).interfaceId ||
		interfaceId == type(ERC721Metadata).interfaceId ||
		supportsInterface(interfaceId);
	}
	function balanceOf(address _owner) public view virtual override returns(uint256) {
		return _balances[_owner];
	}
	function ownerOf(uint256 _tokenId) public view virtual override returns(address) {
		address _owner = _owners[_tokenId];
		return _owner;
	}
	function safeTransferFrom(address _from, address _to, uint256 _tokenId) public virtual override {
		transferFrom(_from, _to, _tokenId);
	}
	function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) public virtual override {
		safeTransferFrom(_from, _to, _tokenId, _data);
	}
	function transferFrom(address _from, address _to, uint256 _tokenId) public virtual override {
		require(ownerOf(_tokenId) == _from, 'Error: only owner can transfer');
		require(_to != address(0), 'Error: Tranfering to none existing address');
		approve(address(0), _tokenId);
		_balances[_from] -= 1;
		_balances[_to] += 1;
		_owners[_tokenId] = _to;
		emit Transfer(_from, _to, _tokenId);
	}
	function approve(address _to, uint256 _tokenId) public virtual override {
		address _owner = ownerOf(_tokenId);
		require(_to != _owner, 'Error: you are already approved');
		require(_msgSender() == _owner || isApprovedForAll(_owner, _msgSender()), 'Error: not approved');
		_tokenApprovals[_tokenId] = _to;
		emit Approval(ownerOf(_tokenId), _to, _tokenId);
	}
	function setApprovedForAll(address _operator, bool _approved) public virtual override {
		require(_operator != _msgSender(), 'Error: caller is approved');
		_operatorApprovals[_msgSender()][_operator] = _approved;
		emit ApprovalForAll(_msgSender(), _operator, _approved);
	}
	function isApprovedForAll(address _owner, address _operator) public view virtual override returns(bool) {
		return _operatorApprovals[_owner][_operator];
	}
	function onERC721Received(address, address, uint256, bytes calldata) external pure override returns(bytes4) {
		return bytes4(keccak256("onERC721Received(address,address,uint256,bytes calldata)"));
	}
	function name() public view virtual override returns(string memory) {
		return _name;
	}
	function symbol() public view virtual override returns(string memory) {
		return _symbol;
	}
	function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
		string memory _tokenURI = _tokenURIs[_tokenId];
		string memory base = baseURI();
		if (bytes(base).length == 0) {
		return _tokenURI;
	}
		if (bytes(_tokenURI).length > 0) {
		return string(abi.encodePacked(base, _tokenURI));
	}
		return tokenURI(_tokenId);
	}
	function setTokenURI(uint256 _tokenId, string memory _tokenURI) public {
		baseTokenURI(_tokenId, _tokenURI);
	}
	function baseTokenURI(uint256 _tokenId, string memory _tokenURI) internal virtual {
		_tokenURIs[_tokenId] = _tokenURI;
	}
	function baseURI() internal view virtual returns (string memory) {
    	return "";
    }    
	function mint(address _to, uint256 _tokenId) internal virtual {
	  require(_to != address(0), 'Error: address does not exist');
	  _balances[_to] += 1;
	  _owners[_tokenId] = _to;
	  emit Transfer(address(0), _to, _tokenId);
	}
	function burn(uint256 _tokenId) internal {
	address _owner = ownerOf(_tokenId);
	  approve(address(0), _tokenId);
	  _balances[_owner] -= 1;
	  delete _owners[_tokenId];
	  emit Transfer(_owner, address(0), _tokenId);
	}


	function requestNewRandomAerith(string memory aerith) public returns (bytes32) {
        require(LINK.balanceOf(address(this)) >= _fee, "Not enough LINK - fill contract with faucet");
        bytes32 requestId = requestRandomness(_keyHash, _fee);
        requestToAerithName[requestId] = aerith;
        requestToSender[requestId] = _msgSender();
        return requestId;
    }
    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {
        uint256 newId = aeriths.length; uint256 Strength = (randomNumber % 999); uint256 Magic = ((randomNumber % 100000) / 1000 ); uint256 Vitality = ((randomNumber % 10000000) / 100000 ); 
        uint256 Spirit = ((randomNumber % 1000000000) / 10000000); uint256 Luck = ((randomNumber % 100000000000) / 1000000000); uint256 Speed = ((randomNumber % 10000000000000) / 100000000000);
        uint256 Level = (randomNumber % 50); aeriths.push(Aerith(Strength, Magic, Vitality, Spirit, Luck, Speed, Level, requestToAerithName[requestId]));
        mint(requestToSender[requestId], newId);
    }
    function getLevel(uint256 _tokenId) public view returns (uint256) {
        return sqrt(aeriths[_tokenId].Level);
    }
    function getNumberOfAeriths() public view returns (uint256) {
        return aeriths.length; 
    }
    function getAerithsOverView(uint256 _tokenId) public view returns (string memory, uint256, uint256, uint256) {
        return (aeriths[_tokenId].aerith, aeriths[_tokenId].Strength + aeriths[_tokenId].Magic + aeriths[_tokenId].Vitality + 
        aeriths[_tokenId].Spirit + aeriths[_tokenId].Luck + aeriths[_tokenId].Speed, getLevel(_tokenId), aeriths[_tokenId].Level);
    }
    function getAerithsStats(uint256 _tokenId) public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (aeriths[_tokenId].Strength, aeriths[_tokenId].Magic, aeriths[_tokenId].Vitality, aeriths[_tokenId].Spirit,
        aeriths[_tokenId].Luck,  aeriths[_tokenId].Speed,aeriths[_tokenId].Level  );
    }
    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}