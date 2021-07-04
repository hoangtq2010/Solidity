const SHA256 = require('crypto-js/sha256');

class Block {
    constructor(index, timestamp, data, previousHash = ''){ //index:khoi nam dau tren chuoi
        this.index = index;
        this.timestamp = timestamp;
        this.data = data;
        this.previousHash = previousHash;
        this.hash = this.calculateHash();
    }

    calculateHash() {
        return SHA256(this.index + this.previousHash + this.timestamp + JSON.stringify(this.data)).toString();
    }
}

class Blockchain {
    constructor(){
        this.chain = [this.createGenesisBlock()];
    }

    createGenesisBlock(){
        return new Block(0, "04/07/2021", "Genesis block", "0");
    }

    getLatestBlock(){
        return this.chain[this.chain.length - 1]
    }

    addBlock(newBlock){
        newBlock.previousHash = this.getLatestBlock().hash;     //lay previousHash tu block cuoi cung
        newBlock.hash = newBlock.calculateHash();   //tinh toan lai hash
        this.chain.push(newBlock);                  //Day block vao chuoi
    }

    isChainValid(){
        for(let i = 1; i < this.chain.length; i++){
            const currentBlock = this.chain[i];
            const previousBlock = this.chain[i - 1];
            
            if(currentBlock.hash !== currentBlock.calculateHash()){   //check block hien tai co phai hash hien tai 
                return false;
            }

            if(currentBlock.previousHash !== previousBlock.hash){   //check block hien tai co tro dung den block truoc hay ko
                return false;
            }
        }
        return true;
    }
}

//test
let coin = new Blockchain();
coin.addBlock(new Block(1, "10/07/2021", {amount: 5}));
coin.addBlock(new Block(2, "12/07/2021", {amount: 9}));


console.log("Is blockchain valid?" + coin.isChainValid());

coin.chain[1].data = {amount: 100};
console.log("Is blockchain valid?" + coin.isChainValid());
//console.log(JSON.stringify(coin, null, 4));