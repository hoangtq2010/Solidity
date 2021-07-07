pragma solidity >=0.5.0 <0.6.0

contract ZombieFactory{

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie{
        string name;
        uint dna;
    }

    Zombie[] public zombies;    // declare an array as public and Solidity will automatically create a getter method for it

    mapping (uint => address) public zombieToOwner;    //mapping là cách khác để lưu trữ và tra cứu dữ liệu(key=>value)
    mapping (address => uint) ownerZombieCount;

    /*truyền một đối số cho một hàm: By value(Tạo một bản sao mới value và chuyển nó đến hàm, sửa đổi mà ko làm thay đổi giá trị ban đầu)
                                     By reference(hàm của bạn được gọi với tham chiếu đến biến ban đầu, sẽ làm thay đổi biến ban đầu*/

    fuction _createZombie( string memory _name, uint _dna) internal {  //quy ước đặt tên hàm,biến trong private '_'  
        // zombies.push(Zombie(_name,_dna));   //Dựa vào struct để tạo new Zombie và thêm vào mảng zombies

        //kich hoat event để cho app biết func đã đc gọi
        uint id = zombies.push(Zombie(_name, _dna)) - 1 //số đầu trong arr là 0, nên -1 là id của zombie
        zombieToOwner[id] = msg.sender; //msg.sender: là 1 biến toàn cục có sẵn cho tất các func,đề cập đến địa chỉ của người gọi hàm hiện tại
        //cập nhật ai là người sở hữu id zombie mới này
        ownerZombieCount[msg.sender]++; //tăng số lượng cho msg.sender
        emit NewZombie(id, _name, _dna);
    }

    //function as view (chỉ xem dữ liệu mà ko thay đổi nó)
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));  //uint = uint  đây là Typecasting
        return rand % dnaModulus;       //vì 1 số chia 10^16 lấy phần dư sẽ là 1 số có 16 số
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0); //mỗi người chỉ tạo 1 zombie
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name,randDna);
    }
}

