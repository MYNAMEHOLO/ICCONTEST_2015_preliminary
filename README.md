### 本題講述一個圓形頂點集合偵測電路，簡單來說題目指定有4個MODE分別找出三個不同圓的集合所產生的條件，詳細的演算法請見參賽題目說明的PDF檔案。
### 本題要求面積低於9000為 CLASS A, 且要求時間必須低於 10ns .
 

---
                                             
### 本題成績為 **CLASS A**   


* ### Cell Area: 7064
* ### Timing : 8.09 ns

| Cell Area | Timing | CLASS |
| -------- | -------- | -------- |
| 7064     | 8.09 ns    | A    |


---

### 自己寫完後的感覺覺得這題並不困難，只要把FSM確定好後，接下來針對集合電路的條件來進行判斷即可，比較需要注意的是原本想要使用$signed這樣可以合成的語法來進行撰寫，但後來發現如果要這麼作勢必得增加一些位元數導致面積增加，因此最後採用先利用多工器判斷正負再來進行圓心到掃描點的距離計算。
### 如此便可以達到比較小的面積，另外本題壓的timing及area標準其實比較寬鬆，算是難度偏易，自己感覺應該是拚繳交速度的類型的這種題目。

---

#### 由於尊重主辦方，所有的設計及製程文件請到`https://www.iccontest2023.com.tw/` 當中下載。
#### 本文僅提供 Source Code 及 Timing/Area log 做為參考 歡迎大家一起交流分享。
