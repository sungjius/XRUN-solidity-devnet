import { readFile } from "fs/promises";
import Web3 from "web3";
import Contract from "web3-eth-contract";
async function createConnectionGethConsole(
  host = "http://localhost:5006",
  compoileFileDir
) {
  let web3 = new Web3(Web3.givenProvider || host);
  web3.setProvider(new web3.providers.HttpProvider("http://localhost:5006"));
  //   const source = await readFile(compoileFileDir);
  // return { web3, source };
  return { web3 };
}

(async function main() {
  const { web3 } = await createConnectionGethConsole(
    "http://172.31.28.83:5006"
  );
  const source = await readFile("./solFolder/contract.json");
  // console.log(contract);
  ///////////////////////////////////
  const balanceOf1 = await web3.eth.getBalance(
    "0x285c534eea8af3b414fb86f3056dadef05728b8c"
  );
  const balanceOf2 = await web3.eth.getBalance(
    "0x2497da05bef0500b999054c4da8a27d9f0ec97d1"
  );
  // contract.
  // "0xa4fd874baa970e9aaa2c4375a8c3d5a17cf2bd41";
  // "0x2497da05bef0500b999054c4da8a27d9f0ec97d1";
  try {
    // web3.eth.personal.unlockAccount(
    //   "0x2497da05bef0500b999054c4da8a27d9f0ec97d1",
    //   "1234"
    // );
    web3.eth.personal.unlockAccount(
      "0xa3738ac9f9dfdb5819f677c728e708899712eac1",
      "1234"
    );
    const { abi, bytecode } = JSON.parse(source)["contract"];
    console.log(abi);
    const contract = await new Contract(
      abi,
      "0x95AFBE4702a6Ff6780076F109086040CF95AB930"
    );
    // "0x5ed1788214e2071d7eb5f42a98e9af3d1fd399d1";
    // await contract.methods
    //   .transfer("0x285c534eea8af3b414fb86f3056dadef05728b8c", 10)
    //   .send({
    //     from: "0x2497da05bef0500b999054c4da8a27d9f0ec97d1",
    //     gas: 20000,
    //     gasPrice: "123",
    //     value: 123,
    //   });
    // .then(result => {
    //   console.log(result);
    // })
    // .catch(err => {
    //   console.log(err);
    // });
    // const data = contract.methods.getMessage();
    // console.log(contract.methods);
    const data = await contract.methods.getMessage();
    // data.send({
    //   from: "0x95AFBE4702a6Ff6780076F109086040CF95AB930",
    // });
    Object.keys(data).forEach(params => {
      console.log(params);
    });
    console.log();
    // contract.methods.getMessage().call()
    //   .then(result => {
    //     console.log(result);
    //   })
    //   .catch(err => {
    //     console.log(err);
    //   });
  } catch (error) {
    console.log(error);
    console.log("Error unLock Error");
  }

  // console.log(balanceOf1);
  // console.log(balanceOf2);
  // console.log(`======================================================`);
  // const balanceOfMethod = await contract.methods
  //   .balanceOf("0x2497da05bef0500b999054c4da8a27d9f0ec97d1")
  //   .call();
  // console.log(contract.methods);
  // console.log(balanceOfMethod);
  // console.log(transfer);
  // console.log(`======================================================`);
  // console.log(balanceOf1);
  // console.log(balanceOf2);
})();
