
## use
```dart
  NetOptions.instance
    .addHeaders({"aaa": '111'})
.setBaseUrl("https://www.wanandroid.com/")
    .setShowToastFunc((text) {
SmartDialog.showToast(text, debounce: true);
})
    .setShowLoadingFunc(() {
SmartDialog.showLoading();
})
    .setDismissLoadingFunc(() {
SmartDialog.dismiss(status: SmartStatus.loading);
})
    .addInterceptor(CookieManager(CookieJar()))
    .addInterceptor(ExceptionInterceptor())
    .addInterceptor(LoadingInterceptor())
//  超时时间
    .setConnectTimeout(const Duration(milliseconds: 3000))
// 允许打印log，默认未 true
    .enableLogger(true)
.create();
```

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
