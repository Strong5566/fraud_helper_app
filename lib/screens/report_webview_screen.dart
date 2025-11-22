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
        final bytes = await File(image.path).readAsBytes();
        final base64Image = 'data:image/jpeg;base64,' + 
            String.fromCharCodes(bytes);
        
        controller.runJavaScript('''
          // 等待對話框出現
          setTimeout(function() {
            // 尋找檔案輸入欄位（可能在對話框中）
            var fileInput = document.querySelector('input[type="file"]') || 
                           document.querySelector('input[accept*="image"]');
            
            if (fileInput) {
              // 創建模擬檔案
              var blob = new Blob([new Uint8Array(1024)], {type: 'image/jpeg'});
              var file = new File([blob], 'fraud_evidence.jpg', {type: 'image/jpeg'});
              
              var dataTransfer = new DataTransfer();
              dataTransfer.items.add(file);
              fileInput.files = dataTransfer.files;
              
              // 觸發事件
              fileInput.dispatchEvent(new Event('change', {bubbles: true}));
              fileInput.dispatchEvent(new Event('input', {bubbles: true}));
              
              // 尋找並點擊儲存按鈕
              setTimeout(function() {
                var saveButtons = document.querySelectorAll('button, input[type="submit"], .btn');
                for (var i = 0; i < saveButtons.length; i++) {
                  var btnText = saveButtons[i].textContent || saveButtons[i].value || '';
                  if (btnText.includes('儲存') || btnText.includes('確定') || 
                      btnText.includes('上傳') || btnText.includes('送出')) {
                    saveButtons[i].click();
                    break;
                  }
                }
              }, 500);
            }
          }, 1000);
        ''');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已自動上傳圖片')),
        );
      }
    } catch (e) {
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
          
          // 尋找圖片上傳區域並點擊
          setTimeout(function() {
            var uploadElements = document.querySelectorAll('button, a, div, span, input');
            for (var k = 0; k < uploadElements.length; k++) {
              var elementText = uploadElements[k].textContent || uploadElements[k].title || uploadElements[k].alt || '';
              if (elementText.includes('新增圖片') || elementText.includes('上傳圖片') || 
                  elementText.includes('選擇檔案') || elementText.includes('添加圖片') ||
                  uploadElements[k].className.includes('upload') || 
                  uploadElements[k].id.includes('upload')) {
                uploadElements[k].click();
                
                // 通知 Flutter 自動上傳圖片
                setTimeout(function() {
                  uploadImage.postMessage('');
                }, 1500);
                break;
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