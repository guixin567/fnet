import 'package:flutter_test/flutter_test.dart';
import 'package:fnet/fnet.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('FNet Optimization Tests', () {
    test('Multi-instance support with different base URLs', () async {
      final options1 = NetOptions().setBaseUrl('https://api1.com');
      final options2 = NetOptions().setBaseUrl('https://api2.com');
      
      options1.create();
      options2.create();

      final client1 = NetClient(options: options1);
      final client2 = NetClient(options: options2);

      expect(client1.options.dio.options.baseUrl, 'https://api1.com');
      expect(client2.options.dio.options.baseUrl, 'https://api2.com');
      
      final dioAdapter1 = DioAdapter(dio: options1.dio);
      final dioAdapter2 = DioAdapter(dio: options2.dio);

      dioAdapter1.onGet('/test', (server) => server.reply(200, {'code': 200, 'data': 'data1', 'msg': 'ok'}));
      dioAdapter2.onGet('/test', (server) => server.reply(200, {'code': 200, 'data': 'data2', 'msg': 'ok'}));

      final res1 = await client1.get<String, String>('/test');
      final res2 = await client2.get<String, String>('/test');

      expect(res1.data, 'data1');
      expect(res2.data, 'data2');
    });

    test('Success status code range (200-299)', () async {
      final options = NetOptions().setBaseUrl('https://api.com').enableLogger(false);
      options.create();
      final client = NetClient(options: options);
      final adapter = DioAdapter(dio: options.dio);
      
      adapter.onGet('/201', (server) => server.reply(201, {'code': 201, 'data': 'created', 'msg': 'ok'}));
      adapter.onGet('/204', (server) => server.reply(204, {'code': 204, 'data': null, 'msg': 'no content'}));
      adapter.onGet('/400', (server) => server.reply(400, {'code': 400, 'data': null, 'msg': 'bad request'}));

      final res201 = await client.get<String, String>('/201');
      print('201 result: isSuccess=${res201.isSuccess}, code=${res201.code}');
      
      final res204 = await client.get<dynamic, dynamic>('/204');
      print('204 result: isSuccess=${res204.isSuccess}, code=${res204.code}');
      
      final res400 = await client.get<dynamic, dynamic>('/400');
      print('400 result: isSuccess=${res400.isSuccess}, code=${res400.code}');

      expect(res201.isSuccess, true, reason: '201 should be success');
      expect(res204.isSuccess, true, reason: '204 should be success');
      expect(res400.isSuccess, false, reason: '400 should be failure');
    });

    test('Concurrent LoadingInterceptor reference counting', () async {
      int showCount = 0;
      int dismissCount = 0;

      final options = NetOptions()
          .setBaseUrl('https://api.com')
          .enableLogger(false)
          .setShowLoadingFunc(() {
            print('showLoadingFunc called');
            showCount++;
          })
          .setDismissLoadingFunc(() {
            print('dismissLoadingFunc called');
            dismissCount++;
          });
      
      options.addInterceptor(LoadingInterceptor(options: options));
      options.create();

      final client = NetClient(options: options);
      final adapter = DioAdapter(dio: options.dio);

      adapter.onGet('/long1', (server) => server.reply(200, {'code': 200, 'data': '1'}));
      adapter.onGet('/long2', (server) => server.reply(200, {'code': 200, 'data': '2'}));

      final f1 = client.get('/long1', isShowLoading: true);
      final f2 = client.get('/long2', isShowLoading: true);

      await Future.wait([f1, f2]);
      
      print('Final showCount: $showCount, dismissCount: $dismissCount');
      expect(showCount, 1, reason: 'Show should be called exactly once');
      expect(dismissCount, 1, reason: 'Dismiss should be called exactly once');
    });
  });
}
