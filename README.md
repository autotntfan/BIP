Biomedical Image Investigation 課程學習資料授課老師：中山大學電機系吳珮歆老師
---

* HW1

  - Digital image foundamental 數位影像原理
  - 實作內容
    - 調整影像灰階強度於0~255間  
      ![image](https://github.com/autotntfan/BIP/blob/master/HW1/HW1_img/HW1_1.jpg)        ![image](https://github.com/autotntfan/BIP/blob/master/HW1/HW1_img/HW1_2.jpg)
    - 顯示MSB(最大位元區域)，即影像強度255~128之區域，再設定MSB=0顯示之  
      ![image](https://github.com/autotntfan/BIP/blob/master/HW1/HW1_img/HW1_4.jpg)  
    - 設定LSB(最小位元區域)為0

* HW2

  - Histogram and intensity transformation and filtering in space domain

  - 實作內容

    - 原始影像直方分佈圖  
          ![image](https://github.com/autotntfan/BIP/blob/master/HW2/HW2_img/HW2_1.jpg)

    - histogram equalization 處理後之影像與直方分佈圖  

      ​    ![image](https://github.com/autotntfan/BIP/blob/master/HW2/HW2_img/HW2_5.jpg)     ![image](https://github.com/autotntfan/BIP/blob/master/HW2/HW2_img/HW2_6.jpg)      

      

* HW3

  - filtering in space domain

  - 實作內容

    - 自行拍攝圖片，獲取垂直與水平方向梯度，偵測邊緣  
          ![image](https://github.com/autotntfan/BIP/blob/master/HW3/HW3_img/HW3_1.jpg)         

    - 嘗試prewitt、sobel、Frei-Chen、Roberts  
          ![image](https://github.com/autotntfan/BIP/blob/master/HW3/HW3_img/HW3_2.jpg)     ![image](https://github.com/autotntfan/BIP/blob/master/HW3/HW3_img/HW3_3.jpg)  

      ​																							prewitt 鉛直、水平、全方向之梯度  

    - 將MRI影像作邊緣偵測，若經histogram equalization後再處理有何不同  
      i. 未經histogram equalization即做邊緣偵測  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW3/HW3_img/HW3_10.jpg)  
      ii. 經histogram equalization再做邊緣偵測  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW3/HW3_img/HW3_13.jpg)  

    - 嘗試猜測圖片經過何種濾鏡處理

* HW4

  - filtering in frequency domain 
  - 實作內容
    - 影像經FFT轉換後之強度、實部與虛部  
      i. 影像頻域圖  
        ![image](https://github.com/autotntfan/BIP/blob/master/HW4/HW4_img/HW4_3.jpg)  
    - 影像經IFFT轉換  
    - 頻域之濾鏡處理  
    - 高斯濾波器閥值影響  
      i. 高斯高通濾波器 閥值20之頻譜  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW4/HW4_img/HW4_11.jpg)  
      ii. 高斯高通濾波器 閥值40之頻譜  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW4/HW4_img/HW4_12.jpg)  
      iii. 高斯高通濾波器 閥值20處理之圖  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW4/HW4_img/HW4_13.jpg)  
      iv. 高斯高通濾波器 閥值40處理之圖  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW4/HW4_img/HW4_14.jpg)  
    - sobel filter in the frequency domain  
      i.  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW4/HW4_img/HW4_15.jpg)  
      ii. 於頻域處理後再經反傅立葉轉換之偵測  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW4/HW4_img/HW4_16.jpg)  

* HW5

  - Image restoration
  - 實作內容
    - 選定區域之雜訊直方分布圖 
          ![image](https://github.com/autotntfan/BIP/blob/master/HW5/HW5_img/1.jpg)  
    - 嘗試抑制雜訊  
          ![image](https://github.com/autotntfan/BIP/blob/master/HW5/HW5_img/3.jpg)  
    - 設計wiener filter嘗試還原圖片

* HW6

  - color image processing、image segmentation
  - 實作內容
    - 獲取canny filter資訊：梯度、非最大值抑制、邊緣偵測  
      i. x方向梯度  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW6/HW6_img/2.png)  
      ii. y方向梯度  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW6/HW6_img/3.png)  
      iii. 非極大值抑制  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW6/HW6_img/5.png)
    - 嘗試修改閥值使邊緣偵測更清楚  
      i. 雙閥值  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW6/HW6_img/7.png)  
    - 藉由霍夫轉換(Hough Transform)尋找鉛直線  
      i.  
         ![image](https://github.com/autotntfan/BIP/blob/master/HW6/HW6_img/6.png)

* HW7

  - image segmentation
  - 實作內容
    - canny edge detector  
          ![image](https://github.com/autotntfan/BIP/blob/master/HW7/HW7_img/1.png)  
    - 使用內建函數'''graythresh'''分割灰白質  
          ![image](https://github.com/autotntfan/BIP/blob/master/HW7/HW7_img/2.png)  
    - 如何改善灰白質分割精準度  
    - 灰質  
          ![image](https://github.com/autotntfan/BIP/blob/master/HW7/HW7_img/3.png)    
    - 白質  
          ![image](https://github.com/autotntfan/BIP/blob/master/HW7/HW7_img/4.png)

* HW8  

  - image registration  
  - 實作內容  
    - original image  
      ![image](https://github.com/autotntfan/BIP/blob/master/HW8/image/selected.png) ![image](https://github.com/autotntfan/BIP/blob/master/HW8/image/selected1.png)  
    - rotate image  
      ![image](https://github.com/autotntfan/BIP/blob/master/HW8/image/rotate_withnear.png)  
    - shear image  
      ![image](https://github.com/autotntfan/BIP/blob/master/HW8/image/shearing.png)  
    - scale image  
      ![image](https://github.com/autotntfan/BIP/blob/master/HW8/image/scaling.png)  
    - result  
      ![image](https://github.com/autotntfan/BIP/blob/master/HW8/image/final.png)  

* HW9
