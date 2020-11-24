# Biomedical Image Investigation 課程學習資料  授課老師：中山大學電機系吳珮歆老師
## 目錄
* HW1
  - Digital image foundamental 數位影像原理
  - 實作內容
    - 撰寫腳本以調整影像灰階強度於0~255間
      Gray-256
      ![image](https://github.com/autotntfan/BIP/blob/master/HW1/HW1_img/HW1_1.jpg)
      Gray-2
      ![image](https://github.com/autotntfan/BIP/blob/master/HW1/HW1_img/HW1_2.jpg)
    - 顯示MSB(最大位元區域)，即影像強度255~128之區域，再設定MSB=0顯示之
      ![image](https://github.com/autotntfan/BIP/blob/master/HW1/HW1_img/HW1_4.jpg)
    - 設定LSB(最小位元區域)為0
* HW2
  - Histogram and intensity transformation and filtering in space domain
  - 實作內容
    - 獲得圖片直方圖
    - histogram equalization
* HW3
  - filtering in space domain
  - 實作內容
    - 自行拍攝圖片，獲取垂直與水平方向梯度，偵測邊緣
    - 嘗試prewitt、sobel、Frei-Chen、Roberts
    - 將MRI影像作邊緣偵測，若經histogram equalization後再處理有何不同
    - 嘗試猜測圖片經過何種濾鏡處理
* HW4
  - filtering in frequency domain 
  - 實作內容
    - 影像經FFT轉換後之強度、實部與虛部
    - 影像經IFFT轉換
    - 頻域之濾鏡處理
    - 高斯濾波器閥值影響
    - sobel filter in the frequency domain
* HW5
  - Image restoration
  - 實作內容
    - 選定區域之雜訊直方分布圖
    - 嘗試抑制雜訊
    - 設計wiener filter嘗試還原圖片
* HW6
  - color image processing、image segmentation
  - 實作內容
    - 獲取canny filter資訊：梯度、非最大值抑制、邊緣偵測
    - 嘗試修改閥值使邊緣偵測更清楚
    - 藉由霍夫轉換(Hough Transform)尋找鉛直線
* HW7
  - image segmentation
  - 實作內容
    - canny edge detector
    - 使用內建函數'''graythresh'''分割灰白質
    - 如何改善灰白質分割精準度
    
    - 
