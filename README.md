## ChatGPT Application with flutter

ChatGPT has released version 4.0, but it is not fully open. Currently, AI Chat uses the `gpt-3.5-turbo` model.

Chinese document: [Chinese](./README-CN.md)

### Software Screenshot

#### Pure version (no ads)

<div align=left>
<img src="./docs/1.jpeg" width="33%" /><img src="./docs/2.jpeg" width="33%" /><img src="./docs/2_1.jpeg" width="33%" />
</div>

<div align=left>
<img src="./docs/3.jpeg" width="33%" /><img src="./docs/3_1.jpeg" width="33%" /><img src="./docs/3_2.jpeg" width="33%" />
</div>

<div align=left>
<img src="./docs/4.jpeg" width="33%" /><img src="./docs/5.jpeg" width="33%" /><img src="./docs/6.jpeg" width="33%" />
</div>

#### Advertisement Version

<div align=left>
<img src="./docs/ad_1.jpeg" width="33%" /><img src="./docs/ad_2.jpeg" width="33%" /><img src="./docs/ad_3.jpeg" width="33%" />
</div>

<div align=left>
<img src="./docs/ad_4.jpeg" width="33%" />
</div>

#### IOS simulator running

<div align=left>
<img src="./docs/ios_1.png" width="33%" />
</div>

### Software version

- Whether to configure infinite number of versions through `isInfiniteNumberVersion` in `lib/utils/Config.dart`

- main branch: Unlimited version, including `chatgpt`, need to configure openaiKey.

- admob branch: the version with the number of times you watched ads, including `firebase`, `admob`, `chatgpt`, need the corresponding ad configuration and openaiKey.

At present, Android supports running on a real machine, and IOS has only been run on an emulator. IOS packaging requires a developer account.

### Install

#### `flutter`

- `3.*` version, AI Chat uses version 3.7.7 when compiling.

#### `ChatGPT Token` (required)

- Configure the token obtained from the openai background to the `chatGptToken` variable of the `lib/utils/Chatgpt.dart` file.

#### `admob` (ad version)

- The admob ad is docked, the main branch contains admob, you need to apply for the corresponding ad ID in the admob background, and fill it in the `lib/utils/AdCommon.dart` file. These include splash ads, interstitial ads, interstitial rewarded ads, and banner ads.
- Configure admob's `APPLICATION_ID` to `android/app/src/main/AndroidManifest.xml`

```
<meta-data android:name="com.google.android.gms.ads.APPLICATION_ID" android:value="****" />
```

- Also configure admob's `APPLICATION_ID` to `ios/Runner/Info.plist`

```
<key>GADApplicationIdentifier</key>
<string>****</string>
```

#### `firebase` (ads version)

- Configure Android and IOS in the firebase background [https://console.firebase.google.com/](https://console.firebase.google.com/), Android needs to download `google-services.json`, IOS needs Download `GoogleService-Info.plist`
- `google-services.json`: `android/app/google-services.json`
- `GoogleService-Info.plist`: `ios/Runner/GoogleService-Info.plist`

#### Android packaging and compilation configuration

- To package and compile, you need to generate the corresponding key first. Here you can go to Google to see the packaging steps.

- Replace generated jks file to `android/app/build_config/build.jks`

> Edit the packaging configuration `signingConfigs` in the `android/app/build.gradle` file, and replace the corresponding file path and password.

```
signingConfigs {
     release {
         storeFile file("./build_config/build.jks")
         storePassword "123456"
         keyAlias "appKey"
         keyPassword "123456"
     }
}
```