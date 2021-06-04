# GitHub Actionsで遊ぶ
## 概要
- 以下の環境を用意する
  - GitHubActions内にてMySQLを用意する
  - MySQLのIPアドレスを`localhost`以外に設定する
  - 作成したMySQLに対してSQLを発行する

## 目標
- ローカル環境にてDockerを使用し、ネットワークまで指定してしまっている際に、設定を変更せず、GithubActions内でも実行できる環境を用意する
