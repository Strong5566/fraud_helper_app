import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportWebViewScreen extends StatefulWidget {
  const ReportWebViewScreen({super.key});

  @override
  State<ReportWebViewScreen> createState() => _ReportWebViewScreenState();
}

class _ReportWebViewScreenState extends State<ReportWebViewScreen> {
  late WebViewController controller;
  bool _isLoading = true;
  bool _isAutoFilling = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'uploadImage',
        onMessageReceived: (JavaScriptMessage message) {
          _autoUploadImage();
        },
      )
      ..addJavaScriptChannel(
        'debugLog',
        onMessageReceived: (JavaScriptMessage message) {
          print('[WebView Debug] ${message.message}');
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            _autoFillForm();
          },
        ),
      )
      ..loadRequest(Uri.parse('https://165.npa.gov.tw/#/report/call/02'));
  }

  void _autoUploadImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        print('[Flutter] 選擇了圖片: ${image.path}');
        
        controller.runJavaScript('''
          debugLog.postMessage('=== 開始自動上傳圖片流程 ===');
          
          // 等待對話框出現後點擊上傳區域
          setTimeout(function() {
            debugLog.postMessage('步驟1: 尋找上傳區域');
            var uploadLabel = document.querySelector('label.upload-input');
            debugLog.postMessage('上傳區域元素: ' + (uploadLabel ? 'Found' : 'Not found'));
            
            if (uploadLabel) {
              debugLog.postMessage('步驟2: 找到上傳區域，準備點擊');
              uploadLabel.click();
              
              // 等待檔案選擇器觸發後模擬檔案上傳
              setTimeout(function() {
                debugLog.postMessage('步驟3: 尋找檔案輸入欄位');
                var fileInput = document.querySelector('input.files-input') || 
                               document.querySelector('input[type="file"][accept*="jpg"]');
                debugLog.postMessage('檔案輸入元素: ' + (fileInput ? 'Found' : 'Not found'));
                
                if (fileInput) {
                  debugLog.postMessage('步驟4: 找到檔案輸入欄位');
                  debugLog.postMessage('原始files數量: ' + fileInput.files.length);
                  
                  // 創建簡單的模擬檔案
                  var blob = new Blob([new ArrayBuffer(1024)], {type: 'image/jpeg'});
                  var file = new File([blob], 'fraud_evidence.jpg', {
                    type: 'image/jpeg',
                    lastModified: Date.now()
                  });
                  
                  debugLog.postMessage('步驟5: 創建檔案物件');
                  debugLog.postMessage('檔案名稱: ' + file.name);
                  debugLog.postMessage('檔案大小: ' + file.size);
                  
                  // 創建 DataTransfer 並設定檔案
                  var dataTransfer = new DataTransfer();
                  dataTransfer.items.add(file);
                  fileInput.files = dataTransfer.files;
                  
                  debugLog.postMessage('步驟6: 檔案已設定到input');
                  debugLog.postMessage('設定後files數量: ' + fileInput.files.length);
                  
                  // 觸發所有相關事件
                  debugLog.postMessage('步驟7: 觸發change和input事件');
                  fileInput.dispatchEvent(new Event('change', {bubbles: true}));
                  fileInput.dispatchEvent(new Event('input', {bubbles: true}));
                  
                  // 監聽網頁的反應
                  setTimeout(function() {
                    debugLog.postMessage('步驟8: 檢查網頁反應');
                    debugLog.postMessage('當前files數量: ' + fileInput.files.length);
                  }, 200);
                  
                  // 等待處理完成後點擊儲存按鈕
                  setTimeout(function() {
                    debugLog.postMessage('步驟9: 尋找儲存按鈕');
                    var saveBtn = document.querySelector('button.btn-outline-secondary');
                    debugLog.postMessage('儲存按鈕元素: ' + (saveBtn ? 'Found' : 'Not found'));
                    
                    if (saveBtn && saveBtn.textContent.includes('儲存')) {
                      debugLog.postMessage('步驟10: 點擊儲存按鈕');
                      saveBtn.click();
                    } else {
                      debugLog.postMessage('步驟10: 使用備用方案尋找儲存按鈕');
                      var allBtns = document.querySelectorAll('button');
                      debugLog.postMessage('所有按鈕數量: ' + allBtns.length);
                      for (var i = 0; i < allBtns.length; i++) {
                        if (allBtns[i].textContent.includes('儲存')) {
                          debugLog.postMessage('找到儲存按鈕並點擊，索引: ' + i);
                          allBtns[i].click();
                          break;
                        }
                      }
                    }
                  }, 1000);
                } else {
                  debugLog.postMessage('錯誤: 未找到檔案輸入欄位');
                }
              }, 500);
            } else {
              debugLog.postMessage('錯誤: 未找到上傳區域');
            }
          }, 1500);
        ''');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已自動上傳圖片')),
        );
      }
    } catch (e) {
      print('[Flutter] 上傳失敗: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('上傳失敗: $e')),
      );
    }
  }

  void _autoFillForm() {
    setState(() {
      _isAutoFilling = true;
    });
    
    Future.delayed(const Duration(seconds: 3), () {
      controller.runJavaScript('''
        setTimeout(function() {
          // 填寫姓名
          var nameInput = document.querySelector('input[formcontrolname="name"]') || 
                         document.querySelector('input[id="name"]') ||
                         document.querySelector('input[placeholder*="姓名"]');
          if (nameInput) {
            nameInput.value = '黃壯壯';
            nameInput.dispatchEvent(new Event('input', {bubbles: true}));
            nameInput.dispatchEvent(new Event('change', {bubbles: true}));
            nameInput.dispatchEvent(new Event('blur', {bubbles: true}));
          }
          
          // 填寫電話
          var telInput = document.querySelector('input[formcontrolname="tel"]') || 
                        document.querySelector('input[id="tel"]') ||
                        document.querySelector('input[placeholder*="電話"]');
          if (telInput) {
            telInput.value = '0911222333';
            telInput.dispatchEvent(new Event('input', {bubbles: true}));
            telInput.dispatchEvent(new Event('change', {bubbles: true}));
            telInput.dispatchEvent(new Event('blur', {bubbles: true}));
          }
          
          // 選擇是否受騙：否
          var allRadios = document.querySelectorAll('input[type="radio"]');
          for (var k = 0; k < allRadios.length; k++) {
            var label = allRadios[k].parentElement || allRadios[k].nextElementSibling;
            if (label && (label.textContent.includes('否') || allRadios[k].value === '否')) {
              allRadios[k].checked = true;
              allRadios[k].click();
            }
          }
          
          // 選擇詐騙管道：網路詐騙
          var channelRadios = document.querySelectorAll('input[type="radio"]');
          for (var l = 0; l < channelRadios.length; l++) {
            var channelLabel = channelRadios[l].parentElement || channelRadios[l].nextElementSibling;
            if (channelLabel && channelLabel.textContent.includes('網路詐騙')) {
              channelRadios[l].checked = true;
              channelRadios[l].click();
            }
          }
          
          // 選擇詐騙手法：假投資
          var methodRadios = document.querySelectorAll('input[type="radio"]');
          for (var m = 0; m < methodRadios.length; m++) {
            var methodLabel = methodRadios[m].parentElement || methodRadios[m].nextElementSibling;
            if (methodLabel && (methodLabel.textContent.includes('假投資') || methodLabel.textContent.includes('投資詐騙'))) {
              methodRadios[m].checked = true;
              methodRadios[m].click();
            }
          }
          
          // 填寫案情資料
          var textareas = document.querySelectorAll('textarea');
          for (var j = 0; j < textareas.length; j++) {
            textareas[j].value = '這個女生先加我幾天，然後聊天聊得很開心，後來叫我投資虛擬貨幣。她說有內線消息可以賺大錢，要我下載某個投資APP並轉帳投資。我懷疑這是詐騙，所以來報案。';
            textareas[j].dispatchEvent(new Event('input'));
          }
          
          // 尋找並點擊第五個 "+ 新增" 按鈕
          setTimeout(function() {
            var addBtns = document.querySelectorAll('button.deletBtn');
            if (addBtns.length >= 5) {
              debugLog.postMessage('=== 找到第五個新增按鈕，準備點擊 ===');
              debugLog.postMessage('按鈕HTML: ' + addBtns[4].outerHTML.substring(0, 100));
              addBtns[4].click(); // 第五個按鈕（索引為4）
              
              // 通知 Flutter 自動上傳圖片
              setTimeout(function() {
                uploadImage.postMessage('');
              }, 2000);
            } else {
              // 備用方案：尋找所有包含新增文字的按鈕並選擇第五個
              var allBtns = document.querySelectorAll('button');
              var addBtnCount = 0;
              for (var i = 0; i < allBtns.length; i++) {
                if (allBtns[i].textContent.includes('新增')) {
                  addBtnCount++;
                  if (addBtnCount === 5) {
                    debugLog.postMessage('=== 找到第五個新增按鈕（備用方案） ===');
                    debugLog.postMessage('按鈕HTML: ' + allBtns[i].outerHTML.substring(0, 100));
                    allBtns[i].click();
                    setTimeout(function() {
                      uploadImage.postMessage('');
                    }, 2000);
                    break;
                  }
                }
              }
            }
          }, 3000);
          
        }, 2000);
      ''');
      
      // 結束自動填表
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isAutoFilling = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('協助報案'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading || _isAutoFilling)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      '正在自動填寫表單...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}