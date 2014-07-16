SimpleChatServer
================

WebSocketとJSONをベースとした単純なチャットシステム

WebSocket上でJSONをやりとりして通信します。

サーバー側がなるべくユーザーの状態を保持しないようにすることで、単純なシステムになりました。

IRCのようなチャンネルベースのチャットではなく、tagと呼ばれる識別用の文字列を用いて話題ごとの会話をすることができます。tagは複数用いることができ、より細かい話題の識別が可能です。

現状ではセキュリティ上の問題があるため、セキュリティが必要な場面には使用しないでください。

## Protocol

クライアントは指定されたURIにアクセスし、必要に応じてJSONを送信してください。
接続した瞬間からブロードキャストメッセージが送信されてきます。

サーバーが送信する・受信するすべてのJSONは次の形式でなければなりません。

    {"type":"typename",...}

typenameにはメッセージの種類に応じてbroadcast, make\_new\_account, get\_user\_data, ...などがあります。

### ユーザー登録

発言するためにはユーザー登録が必要です。(発言しない場合はユーザー登録は不要です)
ユーザー登録をするには次のようなJSONをサーバーに送信してください。

    {"type":"make_new_account","name":"yourname"}

同じユーザー名が既に使われていなければ、新しくアカウントが作成され、サーバーからのようなJSONが送信されてきます。

    {"type":"self_user_data","user":{"id":"92ee48b55dccff4fbd55c272cf45783cbbf7acbfda61d0822bd7e5663be09da50e45e13f171cddc65348d1c8919aaa383bf116fb4c42cf3864f11895ba07fde8","name":"yourname"}}

送信されてくるIDはユーザーごとに一意に割り当てられます。ユーザー認証をする場面ではこのIDが必ず必要となるので、失わないように保存してください。
現状、IDを忘れると再発行することが出来ないので注意してください。

同じユーザー名が既に使われている場合、次のようなJSONが送信されてきます。

    {"type":"error","message":"The Username is already exist"}

### ユーザー情報確認

自分のIDから自分のユーザー情報を得ることができます。

    {"type":"get_user_data","id":"92ee48b55dccff4fbd55c272cf45783cbbf7acbfda61d0822bd7e5663be09da50e45e13f171cddc65348d1c8919aaa383bf116fb4c42cf3864f11895ba07fde8"}

送信されてくる内容はユーザー登録をした時と同じ内容です。

### 発言

全員に向けて同一内容のメッセージを送信できます。

    {"type":"broadcast","message":"test message","tags":["main","test"],"id":"92ee48b55dccff4fbd55c272cf45783cbbf7acbfda61d0822bd7e5663be09da50e45e13f171cddc65348d1c8919aaa383bf116fb4c42cf3864f11895ba07fde8"}

## TODO

- セキュアな設計にする
- ユーザー名の変更を可能にする

## LICENSE

GPL v3

## Author

- primenumber (prime@kmc.gr.jp)
