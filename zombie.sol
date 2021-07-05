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

    /*Function Declarations
        arrays, structs, mappings, and strings should be stored- in memory
        There are two ways in which you can pass an argument to a Solidity function:
        By value, which means that the Solidity compiler creates a new copy of the parameter's value and passes it to your function.
        This allows your function to modify the value without worrying that the value of the initial parameter gets changed.

        By reference, which means that your function is called with a... reference to the original variable. 
        Thus, if your function changes the value of the variable it receives, the value of the original variable gets changed.*/

    fuction _createZombie( string memory _name, uint _dna) private {  //quy ước đặt tên hàm,biến trong private '_'  
        // zombies.push(Zombie(_name,_dna));   //Dựa vào struct để tạo new Zombie và thêm vào mảng zombies

        //kich hoat event để cho app biết func đã đc gọi
        uint id = zombies.push(Zombie(_name, _dna)) - 1 //zombie vừa mới đẩy vào arr
        emit NewZombie(id, _name, _dna);
    }

    //function as view (chỉ xem dữ liệu mà ko thay đổi nó)
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));  //uint = uint  đây là Typecasting
        return rand % dnaModulus;       //vì 1 số chia 10^16 lấy phần dư sẽ là 1 số có 16 số
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name,randDna);
    }
}