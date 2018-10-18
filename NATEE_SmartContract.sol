pragma solidity ^0.4.24;

/**
 * @title NATEE ERC20 token
 *
 * @dev NATEE SMART Contract support All Standard Token 
 * Other Standard will link to libary later and can set
 */
contract utility{

		uint i;

		modifier onlyNumber8(bytes8 _number){
			for(i=0; i< _number.length; i++){
				require(_number[i] >='0' && _number[i] <= '9',"มีตัวอักษรปนมาด้วย");
			}
			_;
		}

		modifier onlyCapEng(bytes32 _str){
			for(i-0;i< _str.length;i++){
				require(_str[i] == ' ' || (_str[i] >='A' && _str[i] <='Z'),"มีอักษรอื่นปนมาด้วย");
			}
			_;
		}

		modifier onlyNumberACapEng(bytes32 _str){
			for(i-0;i< _str.length;i++){
				require(_str[i] == ' ' || 
						(_str[i] >='A' && _str[i] <='Z') || 
						(_str[i] >='0' && _str[i] <='9'),"มีอักษรอื่นปนมาด้วย");
			}
			_;

		}


}

// SaftMath to protect Overflow and Underflow happen only for uint256
 library SafeMath256 {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if(a==0 || b==0)
        return 0;  
    uint256 c = a * b;
    require(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b>0);
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
   require( b<= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }
  
}

contract ERC20 {
	   event Transfer(address indexed from, address indexed to, uint256 tokens);
       event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);

   	   function totalSupply() public view returns (uint256);
       function balanceOf(address tokenOwner) public view returns (uint256 balance);
       function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);

       function transfer(address to, uint256 tokens) public returns (bool success);
       
       function approve(address spender, uint256 tokens) public returns (bool success);
       function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
  

}


// Only Owner modifier it support a lot owner but finally should have 1 owner
contract Ownable {

  mapping (address=>bool) owners;
  address owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  event AddOwner(address newOwner);
  event RemoveOwner(address owner);
  /**
   * @dev Ownable constructor ตั้งค่าบัญชีของ sender ให้เป็น `owner` ดั้งเดิมของ contract 
   *
   */
   constructor() public {
    owner = msg.sender;
    owners[msg.sender] = true;
  }

  function isContract(address _addr) internal view returns(bool){
     uint256 length;
     assembly{
      length := extcodesize(_addr)
     }
     if(length > 0){
       return true;
    }
    else {
      return false;
    }

  }

 // For Single Owner
  modifier onlyOwner(){
    require(msg.sender == owner);
    _;
  }


  function transferOwnership(address newOwner) public onlyOwner{
    require(isContract(newOwner) == false); // ตรวจสอบว่าไม่ได้เผลอเอา contract address มาใส่
    emit OwnershipTransferred(owner,newOwner);
    owner = newOwner;

  }

  //For multiple Owner
  modifier onlyOwners(){
    require(owners[msg.sender] == true);
    _;
  }

  function addOwner(address newOwner) public onlyOwners{
    require(owners[newOwner] == false);
    require(newOwner != msg.sender);

    owners[newOwner] = true;
    emit AddOwner(newOwner);
  }

  function removeOwner(address _owner) public onlyOwners{
    require(_owner != msg.sender);  // can't remove your self
    owners[_owner] = false;
    emit RemoveOwner(_owner);
  }

  function isOwner(address _owner) public view returns(bool){
    return owners[_owner];
  }
}

// contract Adminable {
// 	struct AdminData{
// 		string name;
// 		string surname;
// 		string docNo; // Passport or ID Card
// 		string email;
// 		uint32 docType;//  0 Unknow, 1 Passport ,2 ID Card
// 		uint32 dateCreate;  // unix time stamp;
// 	}

// 	AdminData[] private admins;
// 	mapping (address => uint8) private adminAddr;

// 	event AdminTransfer(address indexed prevAdmin,address indexed newAdmin,uint adminID);
// 	event AdminAdd(address indexed newAdmin,uint adminID);

// 	constructor() public {
// 		uint8 id = uint8(admins.push(AdminData("Seitee","Company","","",0,uint32(now))));
// 		adminAddr[msg.sender] = id;  //Contract Creator will start to be admin 
// 	}

// 	function maxAdmin() view public returns(uint256) {
// 		return  admins.length;
// 	}

// 	// Transfer Admin Address to new Admin Address

// 	function transferAdmin(address prevAdmin_, address newAdmin_) public returns(bool) {
// 		require(adminAddr[prevAdmin_] > 0,"ERROR:transferAdmin"); // 0 mean not admin
		
// 		uint8  curID = adminAddr[prevAdmin_];
// 		adminAddr[prevAdmin_] = 0;
// 		adminAddr[newAdmin_] = curID;

// 		emit AdminTransfer(prevAdmin_, newAdmin_, curID);

// 		return true;
// 	}
	
//   	modifier onlyAdmins(){
//     	require(adminAddr[msg.sender] > 0);
//     	_;
//   	}

// // Add Admin and only Admin can add it;
// 	function addAdmin(address adminAddr_, string name_, string surname_, string docNo_, string email_, uint32 docType_) public onlyAdmins returns(bool){
// 		require(adminAddr[adminAddr_] == 0,"ERROR:Add admin this address already ADMIN");

// 		uint8 id = uint8(admins.push(AdminData(name_, surname_, docNo_, email_, docType_, uint32(now))));
// 		adminAddr[adminAddr_] = id;

// 		emit AdminAdd(adminAddr_, id);
// 		return true;
// 	}

// 	function getAdminData(uint8 adminID_) view public onlyAdmins returns(string name_,
// 																	string surName_,
// 																	string docNo_,
// 																	string email_,
// 																	uint32 docType_) {
// 		require(adminID_ < admins.length,"ERROR: Get Admin Error");
// 		AdminData memory admin;
// 		admin = admins[adminID_];

// 		name_ = admin.name;
// 		surName_ = admin.surname;
// 		docNo_ = admin.docNo;
// 		email_ = admin.email;
// 		docType_ = admin.docType;

// 	}
// }

contract ControlToken is Ownable{
	
	mapping (address => bool) lockAddr;
	address[] lockAddrList;
	uint32  unlockDate;

     bool disableBlock;

	mapping(address=>bool) allowControl;

	constructor() public{
		unlockDate = uint32(now) + 36500 days;  // Start Lock 100 Year first
	}


	function start2YearLock() onlyOwners public{
		unlockDate = uint32(now) + 730 days;
	}

	function addLockAddress(address _addr) internal{
		lockAddr[_addr] = true;
		lockAddrList.push(_addr);
	}
// Every one can help to call unlock after 2 Year
	function unlockAllAddress() public{
		if(uint32(now) >= unlockDate)
		{
			for(uint256 i=0;i<lockAddrList.length;i++)
			{
				lockAddr[lockAddrList[i]] = false;
			}
		}
	}

//========================= ADDRESS CONTROL =======================
	function setAllowControl(address _addr) internal{
		allowControl[_addr] = true;
	}

	function userSetAllowControl(bool allow) public returns(bool){
		allowControl[msg.sender] = allow;
	}

	function checkAllowControl(address _addr) public view returns(bool){
		return allowControl[_addr];
	}

// ================================================================
// Send and Recieve Control
    function setDisableLock() onlyOwners public{
      	if(disableBlock == false)
      		disableBlock = true;
    }

}


contract KYC is ControlToken{


	struct KYCData{
		bytes8    birthday; // yymmdd  
		bytes16   phoneNumber; // เอามาวางตรงนี้ เพื่อให้รวมกันในชุดล่ะ 32 byte การวางตำแหน่งที่อื่นจะเสียค่าใช้จ่ายมากเกินไป
//		uint32   remainNextTime; //ทำการปันทึกเวลาของการใส่รหัสผิด เพื่อตั้งค่าการใส่รหัสครั้งถัดไป
//		uint16   wrongCoount; //  นับจำนวนว่าใส่รหัสผิดกี่คร้งแล้ว
		uint16    documentType; // 2 byte;
		uint32    createTime; // 4 byte;
		// --- 32 byte
		bytes32   peronalID;  // Passport หรือ idcard
		// --- 32 byte 
		bytes32    name;
		bytes32    surName;
		bytes32    email;
		bytes8	  password;
	}

	KYCData[] internal kycDatas;

	mapping (uint256=>address) kycDataForOwners;
	mapping (address=>uint256) OwnerToKycData;

	mapping (uint256=>address) internal kycSOSToOwner; //keccak256 for SOS function 

	// function getKYCData() public returns(bytes16 phoneNumber,
	// 									 bytes8  birthday,
	// 									 uint16 documentType,
	// 									 bytes32 peronalID){

	// }
	event ChangePassword(address indexed owner_,uint256 kycIdx_);
	event CreateKYCData(address indexed owner_, uint256 kycIdx_);

	function getKYCData(uint256 _idx) onlyOwners view public returns(bytes16 phoneNumber_,
										 							  bytes8  birthday_,
										 							  uint16 documentType_,
										 							  bytes32 peronalID_,
										 							  bytes32 name_,
										 							  bytes32 surname_,
										 							  bytes32 email_){
		require(_idx <= kycDatas.length && _idx > 0,"ERROR GetKYCData 01");
		KYCData memory _kyc;
		uint256  kycKey = _idx - 1; // ทดสอบถ่าไม่มี Address นี้จะเป็นยังไง
		_kyc = kycDatas[kycKey];

		phoneNumber_ = _kyc.phoneNumber;
		birthday_ = _kyc.birthday;
		documentType_ = _kyc.documentType;
		peronalID_ = _kyc.peronalID;
		name_ = _kyc.name;
		surname_ = _kyc.surName;
		email_ = _kyc.email;

		} // only Owner Smart Contract สามารถเอาออกมาดูได้

	function getKYCData(address _addr) onlyOwners view public returns(bytes16 phoneNumber_,
										 							  bytes8  birthday_,
										 							  uint16 documentType_,
										 							  bytes32 peronalID_,
										 							  bytes32 name_,
										 							  bytes32 surname_,
										 							  bytes32 email_){
		require(OwnerToKycData[_addr] > 0,"ERROR GetKYCData 02");
		KYCData memory _kyc;
		uint256  kycKey = OwnerToKycData[_addr] - 1; // ทดสอบถ่าไม่มี Address นี้จะเป็นยังไง
		_kyc = kycDatas[kycKey];

		phoneNumber_ = _kyc.phoneNumber;
		birthday_ = _kyc.birthday;
		documentType_ = _kyc.documentType;
		peronalID_ = _kyc.peronalID;
		name_ = _kyc.name;
		surname_ = _kyc.surName;
		email_ = _kyc.email;

		} // only Owner Smart Contract สามารถเอาออกมาดูได้

// เจ้าของสามารถมาขอดู KYC ได้ โดยใส่รหัสลับด้วย
	function getKYCData() view public returns(bytes16 phoneNumber_,
										 					 bytes8  birthday_,
										 					 uint16 documentType_,
										 					 bytes32 peronalID_,
										 					 bytes32 name_,
										 					 bytes32 surname_,
										 					 bytes32 email_){
		require(OwnerToKycData[msg.sender] > 0,"ERROR GetKYCData 03"); // if == 0 not have data;
		uint256 id = OwnerToKycData[msg.sender] - 1;

		KYCData memory _kyc;
		_kyc = kycDatas[id];

		phoneNumber_ = _kyc.phoneNumber;
		birthday_ = _kyc.birthday;
		documentType_ = _kyc.documentType;
		peronalID_ = _kyc.peronalID;
		name_ = _kyc.name;
		surname_ = _kyc.surName;
		email_ = _kyc.email;
	}

// hacker can try to change password but want to pay ETH everytime
	function changePassword(bytes8 oldPass_, bytes8 newPass_) public returns(bool){
		require(OwnerToKycData[msg.sender] > 0,"ERROR changePassword"); 
		uint256 id = OwnerToKycData[msg.sender] - 1;
		if(kycDatas[id].password == oldPass_)
		{
			kycDatas[id].password = newPass_;
			emit ChangePassword(msg.sender, id);
		}
		else
		{
			assert(kycDatas[id].password == oldPass_);
		}

		return true;


	}

	// For FullData
	function createKYCData(bytes32 _name, bytes32 _surname, bytes32 _email,bytes8 _password, bytes8 _birthday,bytes16 _phone,uint16 _docType,bytes32 _peronalID,address  _wallet) onlyOwners public returns(uint256){
		uint256 id = kycDatas.push(KYCData(_birthday, _phone, _docType, uint32(now) ,_peronalID, _name, _surname, _email, _password));
		uint256 sosHash = uint256(keccak256(abi.encodePacked(_name, _surname , _email, _password)));

		OwnerToKycData[_wallet] = id;
		kycDataForOwners[id] = _wallet; 
		kycSOSToOwner[sosHash] = _wallet; //  for recovery wallet if lost everything
		emit CreateKYCData(_wallet,id);

		return id;
	}

	//For testing Small Data
	function createKYCDataMini(bytes32 _name, bytes32 _surname, bytes32 _email, bytes8 _password, address _wallet) onlyOwners public returns(uint256){
		uint256 id = kycDatas.push(KYCData("", "", 0, uint32(now) ,"", _name, _surname, _email, _password));
		uint256 sosHash = uint256(keccak256(abi.encodePacked(_name, _surname , _email, _password)));

		OwnerToKycData[_wallet] = id;
		kycDataForOwners[id] = _wallet; 
		kycSOSToOwner[sosHash] = _wallet; //  for recovery wallet if lost everything
		emit CreateKYCData(_wallet,id);

		return id;
	}

}



contract StandarERC20 is ERC20{
	using SafeMath256 for uint256;  // คำสั่งนี้จะทำให้ ตัวแปลชนิด uint256 นั้นสามารถใส่ . ได้โดยเรียกฟังชั่นจาก safemath อีกที
     
     mapping (address => uint256) balance;
     mapping (address => mapping (address=>uint256)) allowed;


     uint256 public totalSupply_;  // ถ้าไม่กำหนดเป็น private จะสามารถเปลีย่นแปลงค่าได้     
     

     address[] public  holders;
     mapping (address => uint256) holderToId;

     event Transfer(address indexed from,address indexed to,uint256 value);
     event Approval(address indexed owner,address indexed spender,uint256 value);



    function totalSupply() public view returns (uint256){
     	return totalSupply_;
    }

     function balanceOf(address _walletAddress) public view returns (uint256){
        return balance[_walletAddress]; //ส่งค่าของอะไรบางอย่างที่เก็บในที่อยู่นี้ ออกไป แต่มันดันเอามาเป็นว่ามีเหรียญนี้เท่าไหร่
     }

//  spender คือคนที่เราจะโอนให้ ตรวจสอบยอดว่ามีการกัดเงินไว้ให้เท่าไหร่
     function allowance(address _owner, address _spender) public view returns (uint256){
          return allowed[_owner][_spender];
        }

     function transfer(address _to, uint256 _value) public returns (bool){
        require(_value <= balance[msg.sender]);
        require(_to != address(0));
        
        balance[msg.sender] = balance[msg.sender].sub(_value);
        balance[_to] = balance[_to].add(_value);

        emit Transfer(msg.sender,_to,_value); 
        return true;

     }

     function approve(address _spender, uint256 _value)
            public returns (bool){
            allowed[msg.sender][_spender] = _value;

            emit Approval(msg.sender, _spender, _value);
            return true;
            }

      function transferFrom(address _from, address _to, uint256 _value)
            public returns (bool){
               require(_value <= balance[_from]);
               require(_value <= allowed[_from][msg.sender]); // ตรวจว่วยอดที่ต้องการได้มีการกันไว้หรือไม่ กับคนที่จะมาเอา
               require(_to != address(0));

              balance[_from] = balance[_from].sub(_value);
              balance[_to] = balance[_to].add(_value);
              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

              emit Transfer(_from, _to, _value);
              return true;
      }

// FOR All Aridrop in Future for warrant or other token
     function addHolder(address _addr) internal{
     	uint256 idx = holders.push(_addr);
     	holderToId[_addr] = idx;
     }

     function getMaxHolder() external view returns(uint256){
     	return holders.length;
     }

     function getHolder(uint256 idx) external view returns(address){
     	return holders[idx];
     }
     
}


// Free Token for advisor developer and Other
contract FounderAdvisor is StandarERC20,Ownable,KYC {

	uint256 public FOUNDER_SUPPLY = 5000000 ether;
	uint256 public ADVISOR_SUPPLY = 4000000 ether;

	address[] advisors;
	address[] founders;

	mapping (address => uint256) advisorToID;
	mapping (address => uint256) founderToID;
	// will have true if already redeem.
	// Advusir and founder can't be same people

	bool  public closeICO;

	// Will have this value after close ICO

	uint256 public TOKEN_PER_FOUNDER = 0 ether; 
	uint256 public TOKEN_PER_ADVISOR = 0 ether;

	event AddFounder(address indexed newFounder,string nane,uint256  curFoounder);
	event AddAdvisor(address indexed newAdvisor,string name,uint256  curAdvisor);
	event CloseICO();

	event RedeemAdvisor(address indexed addr_, uint256 value);
	event RedeemFounder(address indexed addr_, uint256 value);

	event ChangeAdvisorAddr(address indexed oldAddr_, address indexed newAddr_);
	event ChangeFounderAddr(address indexed oldAddr_, address indexed newAddr_);

	function addFounder(address newAddr, string _name) onlyOwners external returns (bool){
		require(closeICO == false);
		require(founderToID[newAddr] == 0);

		uint256 idx = founders.push(newAddr);
		founderToID[newAddr] = idx;
		emit AddFounder(newAddr, _name, idx);
		return true;
	}

	function addAdvisor(address newAdvis, string _name) onlyOwners external returns (bool){
		require(closeICO == false);
		require(advisorToID[newAdvis] == 0);

		uint256 idx = advisors.push(newAdvis);
		advisorToID[newAdvis] = idx;
		emit AddAdvisor(newAdvis, _name, idx);
		return true;
	}

// CHANGE TO ADDRESS 0x0000 mean remove advisor
	function changeAdvisorAddr(address oldAddr, address newAddr) onlyOwners external returns(bool){
		require(closeICO == false);
		require(advisorToID[oldAddr] > 0); // it should be true if already have advisor

		uint256 idx = advisorToID[oldAddr];

		advisorToID[newAddr] = idx;
		advisorToID[oldAddr] = 0;

		advisors[idx - 1] = newAddr;

		emit ChangeAdvisorAddr(oldAddr,newAddr);
		return true;
	}

	function changeFounderAddr(address oldAddr, address newAddr) onlyOwners external returns(bool){
		require(closeICO == false);
		require(founderToID[oldAddr] > 0);

		uint256 idx = founderToID[oldAddr];

		founderToID[newAddr] = idx;
		founderToID[oldAddr] = 0;
		founders[idx - 1] = newAddr;

		emit ChangeFounderAddr(oldAddr, newAddr);
		return true;
	}



	function setCloseICO() public onlyOwners{
		require(closeICO == false);
		uint256 lessAdvisor;
		uint256 maxAdvisor;
		uint256 maxFounder;
		uint256 i;
		closeICO = true;

		// Count Max Advisor
		maxAdvisor = 0;
		for(i=0;i<advisors.length;i++)
		{
			if(advisors[i] != address(0)) 
				maxAdvisor++;
		}

		maxFounder = 0;
		for(i=0;i<founders.length;i++)
		{
			if(founders[i] != address(0))
				maxFounder++;
		}

		TOKEN_PER_ADVISOR = ADVISOR_SUPPLY / maxAdvisor;

		// Maximum 200,000 Per Advisor or less
		if(TOKEN_PER_ADVISOR > 200000 ether) { 
			TOKEN_PER_ADVISOR = 200000 ether;
		}

		lessAdvisor = ADVISOR_SUPPLY - (TOKEN_PER_ADVISOR * maxAdvisor);
		// less from Advisor will pay to Founder

		TOKEN_PER_FOUNDER = (FOUNDER_SUPPLY + lessAdvisor) / maxFounder;
		emit CloseICO();

		// Start Send Token to Found and Advisor 
		for(i=0;i<advisors.length;i++)
		{
			if(advisors[i] != address(0))
			{
				balance[advisors[i]] += TOKEN_PER_ADVISOR;
				totalSupply_ += TOKEN_PER_ADVISOR;

				addLockAddress(advisors[i]); // THIS ADDRESS WILL LOCK FOR 2 YEAR CAN'T TRANSFER
				
				emit Transfer(address(this), msg.sender, TOKEN_PER_ADVISOR);
				emit RedeemAdvisor(msg.sender,TOKEN_PER_ADVISOR);

			}
		}

		for(i=0;i<founders.length;i++)
		{
			if(founders[i] != address(0))
			{
				balance[founders[i]] += TOKEN_PER_FOUNDER;
				totalSupply_ += TOKEN_PER_FOUNDER;

				addLockAddress(founders[i]);
				emit Transfer(address(this),msg.sender,TOKEN_PER_FOUNDER);
				emit RedeemFounder(msg.sender,TOKEN_PER_FOUNDER);

			}
		}

	}


}

contract MyToken is FounderAdvisor {
	 using SafeMath256 for uint256;  // คำสั่งนี้จะทำให้ ตัวแปลชนิด uint256 นั้นสามารถใส่ . ได้โดยเรียกฟังชั่นจาก safemath อีกที
    


     event SOSTranfer(address indexed oldAddr_, address indexed newAddr_);

     function transfer(address _to, uint256 _value) public returns (bool){
     	require(lockAddr[msg.sender] == false); // 2 Year Lock can't Transfer

     	if(disableBlock == false)
     	{
        	require(OwnerToKycData[msg.sender] > 0,"You Not have permission to Send");
        	require(OwnerToKycData[_to] > 0,"You not have permission to Recieve");
        }
        if(holderToId[_to] == 0)
              	addHolder(_to);
        
        return super.transfer(_to, _value);

     }

     function approve(address _spender, uint256 _value) public returns (bool){
            allowed[msg.sender][_spender] = _value;

            emit Approval(msg.sender, _spender, _value);
            return true;
            }

      function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
            require(lockAddr[_from] == false); //2 Year Lock Can't Transfer

            if(disableBlock == false)
            {	
         	    require(OwnerToKycData[msg.sender] > 0, "You Not Have permission to Send");
            	require(OwnerToKycData[_to] > 0,"You not have permission to recieve");
        	}
            if(holderToId[_to] == 0)
              	addHolder(_to);

            return super.transferFrom(_from, _to, _value);

      }

      // This function only for user that lost PrivateKey but they remember keyData and password
      function sosTransfer(bytes32 _name, bytes32 _surname, bytes32 _email,bytes8 _password,address _newAddr) onlyOwners public returns(bool){

      	uint256 sosHash = uint256(keccak256(abi.encodePacked(_name, _surname , _email, _password)));
      	address oldAddr = kycSOSToOwner[sosHash];
      	uint256 idx = OwnerToKycData[oldAddr];

      	require(allowControl[oldAddr] == false);
      	if(idx > 0)
      	{
      		idx = idx - 1;
      		if(kycDatas[idx].name == _name &&
      		   kycDatas[idx].surName == _surname &&
      		   kycDatas[idx].email == _email &&
      		   kycDatas[idx].password == _password)
      		{

      			kycSOSToOwner[sosHash] = _newAddr;
      			OwnerToKycData[oldAddr] = 0; // resetit
      			OwnerToKycData[_newAddr] = idx;
      			kycDataForOwners[idx] = _newAddr;

      			emit SOSTranfer(oldAddr, _newAddr);

      			lockAddr[_newAddr] = lockAddr[oldAddr];

      			//Transfer All Token to new address
      			uint256  curBalance = balance[oldAddr];
      			balance[_newAddr] = curBalance;
      			balance[oldAddr] = 0;

      			emit Transfer(oldAddr, _newAddr, curBalance);
      		}
      	}


      	return true;
      }
     
     // This function can call only Allow address  
      function inTransfer(address _from, address _to,uint256 value) onlyOwners public{
      	require(allowControl[_from] == true); //default = false
      	require(balance[_from] >= value);

      	balance[_from] -= value;
        balance[_to] += balance[_to].add(value);

        emit Transfer(_from,_to,value); 
      }



}





//Interface from Natee Private Token
contract NateePrivate {
	
	struct PRIVATE_DATA{
		address priAddr;
		uint256 priToken;
	}

	PRIVATE_DATA[] public priDatas;
	
	constructor() public{
		addPrivateAddress(0x523B82EC6A1ddcBc83dF85454Ed8018C8327420B,646000 ether); //1  //646,000
		addPrivateAddress(0x8AF7f48FfD233187EeCB75BC20F68ddA54182fD7,100000 ether); //2  //746,000
		addPrivateAddress(0xeA1a1c9e7c525C8Ed65DEf0D2634fEBBfC1D4cC7,40000 ether); //3  //786,000
		addPrivateAddress(0x55176F6F5cEc289823fb0d1090C4C71685AEa9ad,30000 ether); //4  //816,000
		addPrivateAddress(0xd25B928962a287B677e30e1eD86638A2ba2D7fbF,20000 ether); //5  //836,000
		addPrivateAddress(0xfCf845416c7BDD85A57b635207Bc0287D10F066c,20000 ether); //6  //856,000
		addPrivateAddress(0xc26B195f38A99cbf04AF30F628ba20013C604d2E,20000 ether); //7  //876,000
		addPrivateAddress(0x137b159F631A215513DC511901982025e32404C2,16000 ether); //8  //892,000
		addPrivateAddress(0x2dCe7d86525872AdE3C89407E27e56A6095b12bE,10000 ether); //9	//902,000
		addPrivateAddress(0x14D768309F02E9770482205Fc6eBd3C22dF4f1cf,10000 ether); //10 //912,000
		addPrivateAddress(0x7690E67Abb5C698c85B9300e27B90E6603909407,10000 ether); //11 //922,000 
		addPrivateAddress(0xAc265E4bE04FEc2cfB0A97a5255eE86c70980581,10000 ether); //12 //932,000
		addPrivateAddress(0x1F10C47A07BAc12eDe10270bCe1471bcfCEd4Baf,10000 ether); //13 //942,000
		addPrivateAddress(0xDAE37b88b489012E534367836f818B8bAC94Bc53,5000 ether); //14  //947,000
		addPrivateAddress(0x9970FF3E2e0F2b0e53c8003864036985982AB5Aa,5000 ether); //15  //952,000
		addPrivateAddress(0xa7bADCcA8F2B636dCBbD92A42d53cB175ADB7435,4000 ether); //16  //956,000
		addPrivateAddress(0xE8C70f108Afe4201FE84Be02F66581d90785805a,3000 ether); //17  //959,000
		addPrivateAddress(0xAe34B7B0eC97CfaC83861Ef1b077d1F37E6bf0Ff,3000 ether); //18  //962,000
		addPrivateAddress(0x8Cf64084b1889BccF5Ca601C50B3298ee6F73a0c,3000 ether); //19  //965,000
		addPrivateAddress(0x1292b82776CfbE93c8674f3Ba72cDe10Dff92712,3000 ether); //20  //968,000
		addPrivateAddress(0x1Fc335FEb52eA58C48D564030726aBb2AAD055aa,3000 ether); //21  //971,000
		addPrivateAddress(0xb329a69f110F6f122737949fC67bAe062C9F637e,3000 ether); //22  //974,000
		addPrivateAddress(0xDA1A8a99326800319463879B040b1038e3aa0AF9,2000 ether); //23  //976,000
		addPrivateAddress(0xE5944779eee9D7521D28d2ACcF14F881b5c34E98,2000 ether); //24  //978,000
		addPrivateAddress(0x42Cd3F1Cd749BE123a6C2e1D1d50cDC85Bd11F24,2000 ether); //25  //980,000
		addPrivateAddress(0x8e70A24B4eFF5118420657A7442a1F57eDc669D2,2000 ether); //26  //982,000
		addPrivateAddress(0xE3139e6f9369bB0b0E20CDCf058c6661238801b7,1400 ether); //27  //983,400
		addPrivateAddress(0x4f33B6a7B9b7030864639284368e85212D449f30,3000 ether); //28  //986,400 
		addPrivateAddress(0x490C7C32F46D79dfe51342AA318E0216CF830631,1000 ether); //29  //987,400
		addPrivateAddress(0x3B9d4174E971BE82de338E445F6F576B5D365caD,1000 ether); //30  //988,400
		addPrivateAddress(0x90326765a901F35a479024d14a20B0c257FE1f93,1000 ether); //31  //989,400
		addPrivateAddress(0xf902199903AB26575Aab96Eb16a091FE0A38BAf1,1000 ether); //32  //990,400
		addPrivateAddress(0xCB1A77fFeC7c458CDb5a82cCe23cef540EDFBdF2,1000 ether); //33  //991,400
		addPrivateAddress(0xfD0157027954eCEE3222CeCa24E55867Ce56E16d,1000 ether); //34  //992,400
		addPrivateAddress(0x78287128d3858564fFB2d92EDbA921fe4eea5B48,1000 ether); //35  //993,400
		addPrivateAddress(0x89eF970ae3AF91e555c3A1c06CB905b521f59E7a,1000 ether); //36  //994,400
		addPrivateAddress(0xd64A44DD63c413eBBB6Ac78A8b057b1bb6006981,1000 ether); //37  //995,400
		addPrivateAddress(0x8973dd9dAf7Dd4B3e30cfeB01Cc068FB2CE947e4,1000 ether); //38  //996,400
		addPrivateAddress(0x1c6CF4ebA24f9B779282FA90bD56A0c324df819a,1000 ether); //39  //997,400
		addPrivateAddress(0x198017e35A0ed753056D585e0544DbD2d42717cB,1000 ether); //40  //998,400
		addPrivateAddress(0x63576D3fcC5Ff5322A4FcFf578f169B7ee822d23,1000 ether); //41  //999,400
		addPrivateAddress(0x9f27bf0b5cD6540965cc3627a5bD9cfb8d5cA162,600 ether); // 42  //1,000,000
	}

	function addPrivateAddress(address pAddr,uint256 pToken) internal {
		priDatas.push(PRIVATE_DATA(pAddr,pToken));

	}

}

//Interace face from SGDT Token
contract SGDSInterface{
  function balanceOf(address tokenOwner) public view returns (uint256 balance);
  function intTransfer(address _from, address _to, uint256 _value) external;
  function transferWallet(address _from,address _to) external;
  function getUserControl(address _addr) external view returns(bool); // if true mean user can control by him. false mean Company can control
  function useSGDS(address useAddr,uint256 value) external returns(bool);
  function transfer(address _to, uint256 _value) public returns (bool);

}

contract NateeWarrantInterface {

	function balanceOf(address tokenOwner) public view returns (uint256 balance);
	function redeemWarrant(address _from, uint256 _value) external;
	function getWarrantInfo() external view returns(string name_,string symbol_,uint256 supply_ );
	function getUserControl(address _addr) external view returns(bool);
	function sendWarrant(address _to,uint256 _value) external;
}

contract MultiSign{
	mapping (address=>uint256)  signValue;  // Current sign value form that address
	mapping (address=>uint256)  signWeight; // Sigh Weight for each address
	mapping (address=>mapping(address=>bool)) signed;

	uint256 public maxSign;

	address masterSign; // master Can't remove; master can transfer to new master

	event AddSigner(address indexed signer,address indexed signer_add,uint256 signerWeight);
	event RemoveSigner(address indexed signer,address indexed signer_remove);

	constructor() public{
		signWeight[msg.sender] = 1;
		masterSign = msg.sender;
		maxSign = 1;
	}

	modifier onlySigner(){
		require(signWeight[msg.sender] > 0 || masterSign == msg.sender);
		_;
	}

	function addSigner(address signAddr,uint256 signW) onlySigner public{
		signWeight[signAddr] = signW;
		emit AddSigner(signAddr,msg.sender,signW);
		maxSign++;
	}

// Can Remove your self if most approve
	function removeSigner(address signerRemove) onlySigner public{
		require(signWeight[signerRemove] > 0);
		signWeight[signerRemove] = 0;
		emit RemoveSigner(signerRemove,msg.sender);
		maxSign--;
	}

	function transferMasterSign(address newMaster) public{
		require(msg.sender == masterSign);
		masterSign = newMaster;
	}
	
	function getCurSign(address _addr) public view returns(uint256){
		return signValue[_addr];
	}

	function signAddress(address _addr) onlySigner public returns(bool){
		if(signed[msg.sender][_addr] == false)
		{
			signed[msg.sender][_addr] = true;
			signValue[_addr] += signWeight[msg.sender];
		}
	}

// CHECK ALREADY SIGN OR Not
	function checkSigh(address signer,address conSign) public view returns(bool){
		return signed[signer][conSign];
	}

}

contract NateeWarrant is MultiSign,Ownable{
	uint256 public totalWarrant;


	struct NATEE_WARRANT{
		NateeWarrantInterface ntw;
		uint32  expDate; //expire date
		uint256 excRate; // in SGDS per Token  
		uint256 excRateExp;//In SGDS per Token when explie
		uint256 supplyTotal;
		uint256 totalRedeem;
		string name;
		string symbole;
		uint256 signValue; // Value Want to sign
	}

	
	NATEE_WARRANT [] warrant;
	mapping(address=>uint256) warToIdx;

	event MakeWarrant(address indexed conAddr,uint256 supply,uint32 expDate);


	// Warrant Token
	function makeNewWarrant(address _conAddr,uint32 _expDate,uint256 _excRate,uint256 _excRateExp,uint256 signWeight) onlyOwners public{
		require(_excRate > 0); // mean no warrant free;
		require(_expDate > uint32(now));
		uint256 idx;
		string memory _name;
		string memory _symbole;
		uint256 _supply;

		NateeWarrantInterface   nateeW = NateeWarrantInterface(_conAddr);
		(_name,_symbole,_supply) = nateeW.getWarrantInfo();

		idx = warrant.push(NATEE_WARRANT(NateeWarrantInterface(_conAddr),_expDate,_excRate,_excRateExp,_supply, 0 , _name,_symbole,signWeight));
		warToIdx[_conAddr] = idx;
		totalWarrant += _supply;

		emit MakeWarrant(_conAddr,_supply,_expDate);
	}


	function getWarrantData(uint256 wIdx) public view returns(address wAddr,
															 uint32  expDate,
															 uint256 excRate,
															 uint256 excRateExp,
													    	 uint256 supply,
													    	 uint256 totalRedeem,
															 string name_,
															 string symbole_,
															 uint256 signValue_){
		require(wIdx > 0 && wIdx <= warrant.length);

		NATEE_WARRANT  memory nateeW = warrant[wIdx-1]; 
		wAddr = address(nateeW.ntw);
		expDate = nateeW.expDate;
		excRate = nateeW.excRate;
		excRateExp = nateeW.excRateExp;
		supply = nateeW.supplyTotal;
		totalRedeem = nateeW.totalRedeem;
		name_ = nateeW.name;
		symbole_ = nateeW.symbole;
		signValue_ = nateeW.signValue;
	} 

	function getMaxWarrant() public view returns(uint256){
		return warrant.length;
	}
}

// HAVE 5 Type of REFERAL
// 1 Buy 8,000 NATEE Then can get referal code REDEEM AFTER PASS SOFTCAP
// 2 FIX RATE REDEEM AFTER PASS SOFTCAP NO Buy
// 3 adjust RATE REDEEM AFTER SOFTCAP NO Buy
// 4 adjust RATE REDEEM IMMEDIATLY NO Buy
// 5 FIX RATE REDEEM IMMEDIATLY NO Buy

// user contract address for referal
contract Marketing is FounderAdvisor{
	struct REFERAL{
		uint8   refType;
		uint8   fixRate; // user for type 2 and 5
		uint256 redeemCom; // summary commision that redeem
		uint256 allCommission;
		uint256 summaryInvest;
	}

	REFERAL[] public referals;
	mapping (address => uint256) referToID;

	function addReferal(address _address,uint8 referType,uint8 rate) onlyOwners public{
		require(referToID[_address] == 0);
		uint256 idx = referals.push(REFERAL(referType,rate,0,0,0));
		referToID[_address] = idx;
	}



	function addCommission(address _address,uint256 buyToken) internal{
		uint256 idx;
		if(referToID[_address] > 0)
		{
			idx = referToID[_address] - 1;
			uint256 refType = uint256(referals[idx].refType);
			uint256 fixRate = uint256(referals[idx].fixRate);

			if(refType == 1 || refType == 3 || refType == 4){
				referals[idx].summaryInvest += buyToken;
				if(referals[idx].summaryInvest <= 80000){
					referals[idx].allCommission =  referals[idx].summaryInvest / 20 / 2; // 5%
				}else if(referals[idx].summaryInvest >80000 && referals[idx].summaryInvest <=320000){
					referals[idx].allCommission = 2000 + (referals[idx].summaryInvest / 10 / 2); // 10%
				}else if(referals[idx].summaryInvest > 320000){
					referals[idx].allCommission = 2000 + 12000 + (referals[idx].summaryInvest * 15 / 100 / 2); // 10%					
				}
			}
			else if(refType == 2 || refType == 5){
				referals[idx].summaryInvest += buyToken;
				referals[idx].allCommission = (referals[idx].summaryInvest * 100) * fixRate / 100;
			}
		}
	}

	function getReferByAddr(address _address) onlyOwners view public returns(uint8 refType,
																			 uint8 fixRate,
																			 uint256 commision,
																			 uint256 allCommission,
																			 uint256 summaryInvest){
		REFERAL memory refer = referals[referToID[_address]-1];

		refType = refer.refType;
		fixRate = refer.fixRate;
		commision = refer.redeemCom;
		allCommission = refer.allCommission;
		summaryInvest = refer.summaryInvest;

	}

	function checkHaveRefer(address _address) public view returns(bool){
		return (referToID[_address] > 0);
	}

	function getCommission() public view returns(uint256){
		require(referToID[msg.sender] > 0);

		return referals[referToID[msg.sender] - 1].allCommission;
	}
}

contract ICO_Token is  Marketing,NateeWarrant{

	uint256 public PRE_ICO_ROUND = 20000000 ;
	uint256 public ICO_ROUND = 40000000 ;
	uint256 public TOKEN_PRICE = 50; // 0.5 SGDS PER TOKEN

	bool    startICO;  //default = false;
	bool    icoPass;
	uint32  icoEndTime;
	uint32  icoStartTime;
	uint256 totalSell;
	uint256 MIN_PRE_ICO_ROUND = 4000 ;
	uint256 MIN_ICO_ROUND = 400 ;
	uint256 MAX_ICO_ROUND = 20000 ;
	uint256 SOFT_CAP = 10000000 ;

	uint256 _1Token = 1 ether;

	address public ANGEL_COIN_ADDR = 0xdd25648927291130CBE3f3716A7408182F28b80a; // Will got 1 % everytime
	address public _3ND_STUDIO = 0x10A12B15B879f098132324595db383e5CD178aC5;
 	uint256 angelRedeem;

	SGDSInterface public sgds;

	mapping (address => uint256) totalBuyICO;



	event StartICO(address indexed admin, uint32 startTime,uint32 endTime);
	event PassSoftCap(uint32 passTime);
	event BuyICO(address indexed addr_,uint256 value);
	event BonusWarrant(address indexed,uint256 startRank,uint256 stopRank,uint256 warrantGot);

	event RedeemCommision(address indexed, uint256 sgdsValue,uint256 curCom);
	constructor() public {
		//sgds = SGDSInterface();
		angelRedeem = 0;
	}

	function startSellICO() internal returns(bool){
		require(startICO == false); //  IF Start Already it can't call again
		icoStartTime = uint32(now);
		icoEndTime = uint32(now + 270 days); // ICO 9 month
		startICO = true;

		emit StartICO(msg.sender,icoStartTime,icoEndTime);

		return true;
	}

// This function will call automatic if pass soft cap
	function passSoftCap() internal returns(bool){
		icoPass = true;
		// after pass softcap will continue sell 90 days
		if(icoEndTime - uint32(now) > 90 days)
		{
			icoEndTime = uint32(now) + 90 days;
		}


		emit PassSoftCap(uint32(now));
	}

	
	function bonusWarrant(address _addr,uint256 buyToken) internal{
	// 1-4M GOT 50%
	// 4,000,0001 - 12M GOT 40% 	
	// 12,000,0001 - 20M GOT 30%
	// 20,000,0001 - 30M GOT 20%
	// 30,000,0001 - 40M GOT 10%
		uint256  gotWarrant;

//======= PRE ICO ROUND =============
		if(totalSell <= 4000000)
			gotWarrant = buyToken / 2;  // Got 50%
		else if(totalSell >= 4000001 && totalSell <= 12000000)
		{
			if(totalSell - buyToken < 4000000) // It mean between pre bonus and this bonus
			{
				gotWarrant = (4000000 - (totalSell - buyToken)) / 2;
				gotWarrant += (totalSell - 4000000) * 40 / 100;
			}
			else
			{
				gotWarrant = buyToken * 40 / 100; 
			}
		}
		else if(totalSell >= 12000001 && totalSell <= 20000000)
		{
			if(totalSell - buyToken < 4000000)
			{
				gotWarrant = (4000000 - (totalSell - buyToken)) / 2;
				gotWarrant += 2400000; //8000000 * 40 / 100; fix got 2.4 M Token 
				gotWarrant += (totalSell - 12000000) * 30 / 100; 
			}
			else if(totalSell - buyToken < 12000000 )
			{
				gotWarrant = (12000000 - (totalSell - buyToken)) * 40 / 100;
				gotWarrant += (totalSell - 12000000) * 30 / 100; 				
			}
			else
			{
				gotWarrant = buyToken * 30 / 100; 
			}
		}
		else if(totalSell >= 20000001 && totalSell <= 30000000) // public ROUND
		{
			gotWarrant = buyToken / 5; // 20%
		}
		else if(totalSell >= 30000001 && totalSell <= 40000000)
		{
			if(totalSell - buyToken < 30000000)
			{
				gotWarrant = (30000000 - (totalSell - buyToken)) / 5;
				gotWarrant += (totalSell - 30000000) / 10;
			}
			else
			{
				gotWarrant = buyToken / 10;  // 10%
			}
		}
		else if(totalSell >= 40000001)
		{
			if(totalSell - buyToken < 40000000)
			{
				gotWarrant = (40000000 - (totalSell - buyToken)) / 10;
			}
			else
				gotWarrant = 0;
		}

//====================================

		if(gotWarrant > 0)
		{
			gotWarrant = gotWarrant * _1Token;
			warrant[0].ntw.sendWarrant(_addr,gotWarrant);
			emit BonusWarrant(_addr,totalSell - buyToken,totalSell,gotWarrant);
		}

	}

// use SGDS To buy Natee Token Only 
// value are not have 
	function buyNateeToken(address _addr, uint256 value) onlyOwners external returns(bool){
		
		require(closeICO == false);
		require(uint32(now) <= icoEndTime);
		require(value % 2 == 0); // 

		if(startICO == false) startSellICO();
		uint256  sgdWant;
		uint256  buyToken = value;

		if(totalSell < PRE_ICO_ROUND)   // Still in PRE ICO ROUND
		{
			require(buyToken >= MIN_PRE_ICO_ROUND);

			if(buyToken > PRE_ICO_ROUND - totalSell)
			   buyToken = uint256(PRE_ICO_ROUND - totalSell);
		}
		else if(totalSell < PRE_ICO_ROUND + ICO_ROUND)
		{
			require(buyToken >= MIN_ICO_ROUND && buyToken <= MAX_ICO_ROUND);
			if(buyToken > (PRE_ICO_ROUND + ICO_ROUND) - totalSell)
				buyToken = (PRE_ICO_ROUND + ICO_ROUND) - totalSell;
		}
		
		sgdWant = buyToken * TOKEN_PRICE;

		require(sgds.balanceOf(_addr) >= sgdWant);
		sgds.intTransfer(_addr,address(this),sgdWant); // All SGSD Will Transfer to this account
		emit BuyICO(_addr, buyToken * _1Token);

		balance[_addr] = buyToken * _1Token;
		totalBuyICO[_addr] += buyToken;
		//-------------------------------------
		// Add TotalSupply HERE
		totalSupply_ += buyToken * _1Token;
		//-------------------------------------  
		totalSell += buyToken;
		if(totalBuyICO[_addr] >= 8000 && referToID[_addr] == 0)
			addReferal(_addr,1,0);

		bonusWarrant(_addr,buyToken);
		if(totalSell >= SOFT_CAP && icoPass == false) passSoftCap(); // mean just pass softcap

		if(totalSell >= PRE_ICO_ROUND + ICO_ROUND)
			setCloseICO();
		

		emit Transfer(address(this),_addr, buyToken * _1Token);


		return true;
	}

	function buyNateeTokenRefer(address buyer,uint256 value,address referAddr) onlyOwners external returns(bool){
		require(referToID[referAddr] > 0);
		require(buyer != referAddr);

		require(closeICO == false);
		require(uint32(now) <= icoEndTime);
		require(value % 2 == 0); // 

		uint256  sgdWant;
		uint256  buyToken = value;

		if(totalSell < PRE_ICO_ROUND)   // Still in PRE ICO ROUND
		{
			require(buyToken >= MIN_PRE_ICO_ROUND);

			if(buyToken > PRE_ICO_ROUND - totalSell)
			   buyToken = uint256(PRE_ICO_ROUND - totalSell);
		}
		else if(totalSell < PRE_ICO_ROUND + ICO_ROUND)
		{
			require(buyToken >= MIN_ICO_ROUND && buyToken <= MAX_ICO_ROUND);
			if(buyToken > (PRE_ICO_ROUND + ICO_ROUND) - totalSell)
				buyToken = (PRE_ICO_ROUND + ICO_ROUND) - totalSell;
		}
		
		sgdWant = buyToken * TOKEN_PRICE;

		require(sgds.balanceOf(buyer) >= sgdWant);
		sgds.intTransfer(buyer,address(this),sgdWant); // All SGSD Will Transfer to this account
		emit BuyICO(buyer, buyToken * _1Token);

		// Send Token To Referal then Referal want to send it to buyer again
		balance[referAddr] = buyToken * _1Token;

		totalBuyICO[buyer] += buyToken;
		//-------------------------------------
		// Add TotalSupply HERE
		totalSupply_ += buyToken * _1Token;
		//-------------------------------------  
		totalSell += buyToken;
		if(totalBuyICO[buyer] >= 8000 && referToID[buyer] == 0)
			addReferal(buyer,1,0);

		bonusWarrant(buyer,buyToken);
		if(totalSell >= SOFT_CAP && icoPass == false) passSoftCap(); // mean just pass softcap

		if(totalSell >= PRE_ICO_ROUND + ICO_ROUND)
			setCloseICO();
		
		addCommission(referAddr,buyToken);
		emit Transfer(address(this),referAddr, buyToken * _1Token);


		return true;

	}

// REDEEM BY YOUR SELF will got SGDS and can exchange to other 
	function redeemCommision(uint256 value) public{
		require(referToID[msg.sender] > 0);
		uint256 idx = referToID[msg.sender] - 1;
		uint256 refType = uint256(referals[idx].refType);

		if(refType == 1 || refType == 2 || refType == 3)
			require(icoPass == true);

		require(value <= referals[idx].allCommission - referals[idx].redeemCom);

		// TRANSFER SGDS TO address
		referals[idx].redeemCom += value; 
		sgds.transfer(msg.sender,value);

		emit RedeemCommision(msg.sender,value,referals[idx].allCommission - referals[idx].redeemCom);

	}





	function getTotalSell() external view returns(uint256){
		return totalSell;
	}

	function getTotalBuyICO(address _addr) external view returns(uint256){
		return totalBuyICO[_addr];
	}


// VALUE IN SGDS 
	function angelCoinRedeem(uint256 value) public {
		require(msg.sender == ANGEL_COIN_ADDR);
		require(icoPass == true);

		uint256 maxRedeem = (totalSell * TOKEN_PRICE) / 100; // 1% PAY TO ANGEL COIN
		require(angelRedeem + value <= maxRedeem);

		sgds.transfer(ANGEL_COIN_ADDR,value);
		angelRedeem += value;

	}

} 





contract NATEE_BETA02 is ICO_Token,NateePrivate {
	using SafeMath256 for uint256;
	string public name = "NATEE BETA02";
	string public symbol = "NATEE-B2"; // Real Name NATEE
	uint256 public decimals = 18;
	
	uint256 public INITIAL_SUPPLY = 100000000 ether;
	
	event RedeemNatee(address indexed _addr, uint256 _private,uint256 _gotNatee);
	event RedeemWarrat(address indexed _addr,address _warrant,string symbole,uint256 value);

	constructor() public {

		balance[_3ND_STUDIO] = 3000000 ether;
		totalSupply_ += 3000000 ether;
		emit Transfer(address(this),_3ND_STUDIO,3000000 ether);
		reddemAllPrivate();
	}

// SET SGDS Contract Address
	function setSGDSContractAddress(address _addr) external onlyOwners {
		sgds = SGDSInterface(_addr);
	}

// //User if NATEE Warrant are bug
// 	function setNateeWarrantContractAddress(address _oldAddr,address _newAddr) external onlyOwners{
// 		require(warToID[_oldAddr] > 0);
// 		uint256 idx = warToIdx[_oldAddr];
// 		idx = idx - 1;
// 		warrant[idx].ntw = NateeWarrantInterface(_newAddr);
// 		warToIdx[_oldAddr] = 0;
// 		warToIdx[_newAddr] = idx + 1;
// 	}




// Please check can use SGDS too before execute this function
	function redeemWarrant(address warrantAddr,uint256 value) public returns(bool){
		require(closeICO == true);
		require(warToIdx[warrantAddr] > 0);
		require(warrant[warToIdx[warrantAddr]-1].signValue <= getCurSign(warrantAddr) ); //All Ready Sign 
		require(sgds.getUserControl(msg.sender) == false);


		uint256 wIdx = warToIdx[warrantAddr] - 1;
		NATEE_WARRANT memory nateeW = warrant[wIdx];
		uint256 sgdsPerToken; 
		uint256 totalSGDSUse;
		uint256 wRedeem;
		uint256 nateeGot;

		require(nateeW.ntw.getUserControl(msg.sender) == false);

		if( uint32(now) <= nateeW.expDate)
			sgdsPerToken = nateeW.excRate;
		else
			sgdsPerToken = nateeW.excRateExp;

		wRedeem = value / _1Token; 
		require(wRedeem > 0); 
		totalSGDSUse = wRedeem * sgdsPerToken;

		//check enought SGDS to redeem warrant;
		require(sgds.balanceOf(msg.sender) >= totalSGDSUse);
		// Start Redeem Warrant;
		if(sgds.useSGDS(msg.sender,totalSGDSUse) == true) 
		{
			nateeGot = wRedeem * _1Token;
			nateeW.ntw.redeemWarrant(msg.sender,nateeGot); // duduct Warrant;

			balance[msg.sender] += nateeGot;
			// =================================
			// TOTAL SUPPLY INCREATE
			//==================================
			totalSupply_ += nateeGot;
			//==================================


			emit Transfer(address(this),msg.sender,nateeGot);
			emit RedeemWarrat(msg.sender,warrantAddr,nateeW.symbole,nateeGot);
		}

		return true;

	}


// Private Token // Change from this to fix Address for SEED FUND 
// 8,000,000 Token for PRIVATE ROUND 
	function reddemAllPrivate() internal returns(bool){
        uint256 maxHolder = priDatas.length;
        address tempAddr;
        uint256 priToken;
        uint256  nateeGot;
        uint256 i;
        for(i=0;i<maxHolder;i++)
        {
            tempAddr = priDatas[i].priAddr;
            priToken = priDatas[i].priToken;
            if(priToken > 0)
            {
            nateeGot = priToken * 8;
            balance[tempAddr] = nateeGot;
            totalSupply_ += nateeGot;

            allowControl[tempAddr] = true;

            emit Transfer( address(this), tempAddr, nateeGot);
            emit RedeemNatee(tempAddr,priToken,nateeGot);
            }
        }
    }

}

// RedeemWarrant





