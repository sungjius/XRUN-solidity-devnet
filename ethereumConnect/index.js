import { readFile } from "fs/promises";
import Web3 from "web3";
deployContract();
async function deployContract() {
  let web3 = new Web3(Web3.givenProvider || "http://172.31.28.83:5006");
  web3.setProvider(new web3.providers.HttpProvider("http://172.31.28.83:5006"));
  const source = await readFile("./solFolder/contract.json");
  const { abi, bytecode } = JSON.parse(source)["contract"];
  const XRUNContract = new web3.eth.Contract(abi);
  try {
    await web3.eth.personal.unlockAccount(
      "0x95783eb7D8A379D3515469b1F1963c45Aa06b1B7",
      "1234"
    );
    var block = await web3.eth.getBlock("latest");
    console.log("gasLimit: " + block.gasLimit);
    XRUNContract.deploy({
      data: bytecode,
      arguments: [99999999999, "HelloWorld3", "HelloWorld3"],
    })

      .send(
        {
          from: "0x95783eb7D8A379D3515469b1F1963c45Aa06b1B7",
          gas: 12812421,
          gasPrice: "20000000",
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
        console.log("transactionHash");
        console.log(transactionHash);
      })
      .on("receipt", function (receipt) {
        console.log("receipt");
        console.log(receipt.contractAddress); // contains the new contract address
      })
      .on("confirmation", function (confirmationNumber, receipt) {
        console.log("confirmation");
        console.log(confirmationNumber, receipt);
      })
      .then(function (newContractInstance) {
        console.log("deploy contract");
        console.log(newContractInstance.options.address); // instance with the new contract address
      });
  } catch (error) {
    console.log("Error unLock Error");
  }
  //eth.sendTransaction({from:eth.accounts[1],to: eth.accounts[0],value:web3.toWei(100,`ether`)})
}
