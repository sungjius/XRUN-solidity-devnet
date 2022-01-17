import { readFile } from "fs/promises";
import Web3 from "web3";
import Contract from "web3-eth-contract";
async function createConnectionGethConsole(
  host = "http://localhost:5006",
  compoileFileDir
) {
  let web3 = new Web3(Web3.givenProvider || host);
  //  web3.setProvider(new web3.providers.HttpProvider("http://localhost:5006"));
  //   const source = await readFile(compoileFileDir);
  // return { web3, source };
  return { web3 };
}

(async function main() {
  // const { web3 } = await createConnectionGethConsole("http://localhost:5006");
  const source = await readFile("./solFolder/contract.json");
  // console.log(contract);
  ///////////////////////////////////
  const { abi, bytecode } = JSON.parse(source)["contract"];

  const web3_test = new Web3("http://127.0.0.1:5006");
  const address = "0xd9145CCE52D386f254917e481eB44e9943F39138";

  const frombalanceOf2 = await web3_test.eth.getBalance(
    "0xdaa6ac628dcbae26812d78ac369db387403f79b7"
  );
  const tobalanceOf = await web3_test.eth.getBalance(
    "0x6697ac35c8a3fe614d4b8bb3d6e4b377a6fa992d"
  );
  console.log("===============Before Balncce Of================");
  console.log(`fromBalanceOf >> ${frombalanceOf2}`);
  console.log(`toBalanceOf  >> ${tobalanceOf}  `);
  const contract = new web3_test.eth.Contract(abi, address);
  // try {
  //   await web3_test.eth.personal.unlockAccount(
  //     "0xdaa6ac628dcbae26812d78ac369db387403f79b7",
  //     "1234"
  //   );
  //   const transferBalance = await contract.methods
  //     .transfer("0x6697ac35c8a3fe614d4b8bb3d6e4b377a6fa992d", 1000000000000000)
  //     .send({
  //       from: "0xa3738ac9f9dfdb5819f677c728e708899712eac1",
  //       gas: 812421,
  //     });
  //   console.log("===============After Balncce Of================");
  //   const frombalanceOf = await web3_test.eth.getBalance(
  //     "0xa3738ac9f9dfdb5819f677c728e708899712eac1"
  //   );
  //   const tobalanceOf1 = await web3_test.eth.getBalance(
  //     "0x6697ac35c8a3fe614d4b8bb3d6e4b377a6fa992d"
  //   );
  //   console.log(frombalanceOf);
  //   console.log(tobalanceOf1);
  // } catch (error) {
  //   console.log(error);
  // }

  // console.log(`fromBalanceOf1 >> ${frombalanceOf1}`);
  // console.log(`toBalanceOf1  >> ${tobalanceOf1}  `);
})();
