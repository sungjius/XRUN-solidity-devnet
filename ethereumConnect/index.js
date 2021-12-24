import { readFile } from "fs/promises";
import Web3 from "web3";

async function deployContract() {
  let web3 = new Web3(Web3.givenProvider || "http://localhost:5006");
  web3.setProvider(new web3.providers.HttpProvider("http://localhost:5006"));
  const source = await readFile("./solFolder/contract.json");
  const { abi, bytecode } = JSON.parse(source)["contract"];
  const XRUNContract = new web3.eth.Contract(abi);
  try {
    web3.eth.personal.unlockAccount(
      "0x2497da05bef0500b999054c4da8a27d9f0ec97d1",
      "1234"
    );
  } catch (error) {
    console.log("Error unLock Error");
  }
  //eth.sendTransaction({from:eth.accounts[1],to: eth.accounts[0],value:web3.toWei(100,`ether`)})
  XRUNContract.deploy({
    data: bytecode,
    arguments: [123123123, "Hello01", "Hello01"],
  })
    .send(
      {
        from: "0x2497da05bef0500b999054c4da8a27d9f0ec97d1",
        gas: 1500000,
        gasPrice: "3000000",
        //Returned error: tx fee (45.00 ether) exceeds the configured cap (1.00 ether) >> 가스값 에러
      },
      function (error, transactionHash) {
        if (error) throw console.log(error);
        console.log(transactionHash);
      }
    )
    .on("error", function (error) {
      console.log(error);
    })
    .on("transactionHash", function (transactionHash) {
      console.log(transactionHash);
    })
    .on("receipt", function (receipt) {
      console.log(receipt.contractAddress); // contains the new contract address
    })
    .on("confirmation", function (confirmationNumber, receipt) {
      console.log(confirmationNumber, receipt);
    })
    .then(function (newContractInstance) {
      console.log("deploy contract");
      console.log(newContractInstance.options.address); // instance with the new contract address
    });
}

let web3 = new Web3(Web3.givenProvider || "http://localhost:5006");
web3.setProvider(new web3.providers.HttpProvider("http://localhost:5006"));

web3.eth.getTransaction(
  "0xbafc12a35e9e9d7956d2a86bbfdd907f6162eb1f743582593c7b5beb424c1c29",
  params => {
    console.log(params);
  }
);

web3.eth
  .getTransactionReceipt(
    "0xbafc12a35e9e9d7956d2a86bbfdd907f6162eb1f743582593c7b5beb424c1c29"
  )
  .then(params => {
    console.log("getTransactionReceipt");
    console.log(params);
  })
  .catch(params => {
    console.log("Not Found");
  });
