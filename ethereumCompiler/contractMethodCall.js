import { readFile } from "fs/promises";
import Web3 from "web3";
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
  const { web3 } = await createConnectionGethConsole("http://localhost:5006");
  const getContract = await web3.eth.getTransaction(
    "0xbafc12a35e9e9d7956d2a86bbfdd907f6162eb1f743582593c7b5beb424c1c29"
  );
  // 0x2497da05bef0500b999054c4da8a27d9f0ec97d1;
  console.log(getContract.methods);
  //   console.log(getContract.defaultCommon);
  //   console.log(web3.eth.Contract.defaultAccount);
})();
