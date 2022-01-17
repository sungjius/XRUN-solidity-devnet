# RNsol

### Solidity UML

- https://github.com/naddison36/sol2uml 라이브러리 참고

  ```
  nvm install 12
  nvm use 12
  npm link sol2uml --only=production1
  npm ls sol2uml -g


  // EtherScan 배포시
  npx sol2uml {contract Address}
  // 원하는 sol 파일만 UML 변경
  npx sol2uml ./SolFolder/{원하는 sol 파일} -f png -o ./someFile.png
  // 원하는 sol이 첨부 되어 있는 파일 전부 UML 변경
  npx sol2uml ./SolFolder -f png -o ./someFile.png
  ```
