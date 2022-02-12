# pull_request_creator

## 設定ファイル

### 認証情報

- `config/credential.tml`

|大項目|中項目|概要|備考|
|:--|:--|:--|:--|
|github|personal_access_token|パーソナルアクセストークン||
|||||

#### Personal access token

- [必要な権限](https://docs.github.com/ja/developers/apps/building-oauth-apps/scopes-for-oauth-apps)を以下にに示す
  - `repo`
    - `repo:status`
    - `repo_deployment`
    - `public_repo`
    - `repo:invite`
    - `security_events`

### 固有設定

- `config/pull_request_creator/settings.yml`
  - ファイル名は指定可能

|大項目|中項目|小項目|概要|備考|
|:--|:--|:--|:--|:--|
|pull_request_creator|base_branch||||
||merge_branch||||
||repositories||対象リポジトリの配列|`koba-masa/play_with_github`|
||release|type|リリース種別|`normal`:通常<br>`emergency`:緊急<br>`monthly`:月次|
|||date|リリース日(YYYY/MM/DD)|`2022/02/12`|
|||time|リリース時間(HH:MM)|`'15:00'`|
||template||PRのテンプレートファイル|`template/pull_request/pull_request_creator.erb`|
||incremented_version_pattern||タグパターンマッチャー※1|`d[0-9]{1,}\.([0-9]{1,})\.[0-9]{1,}`|
||tag_format||タグフォーマット。※2|`d1.%d.0`|
||||||

※1、2・・・タグパターンマッチャーにて抜き出した値をインクリメントし、タグフォーマットに設定する

## 実行コマンド

- `src/scripts/pull_request_creator.rb <固有設定ファイル>`
  - `<固有設定ファイル>`・・・省略可。
    - 例)`config/pull_request_creator/release_branch.yml`
    - デフォルト値：`config/pull_request_creator/settings.yml`
