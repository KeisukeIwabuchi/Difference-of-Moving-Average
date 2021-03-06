//+------------------------------------------------------------------+
//|                                Difference of Moving Averages.mq4 |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Keisuke Iwabuchi"
#property link      "https://order-button.com/"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 clrOrange
#property indicator_width1 1
#property indicator_style1 0


enum price_method {
   CLOSE   = 0, // 終値
   OPEN    = 1, // 始値
   HIGH    = 2, // 高値
   LOW     = 3, // 安値
   MEDIAN  = 4, // 中央値(高値+安値)÷2
   TYPICAL = 5, // 代表値(高値+安値+終値)÷3
   WEGHTED = 6  // 加重終値(高値+安値+終値+終値)÷4
};


enum ma_method {
   SimpleMA        = 0, // 単純移動平均
   ExponentialMA   = 1, // 指数移動平均
   SmoothedMA      = 2, // 平滑移動平均
   LinerWeightedMA = 3  // 線形加重移動平均
};


input int          sma_period = 20;       // 短期移動平均線期間
input int          lma_period = 100;      // 長期移動平均線期間
input price_method price      = CLOSE;    // price(適用価格)
input ma_method    method     = SimpleMA; // method(計算方式)


double value[];


int OnInit()
{
   IndicatorBuffers(1);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, value);
   IndicatorDigits(Digits);
   
   return(INIT_SUCCEEDED);
}


int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   double sma, lma;
   int mt = method;
   int pt = price;
   int limit = Bars - IndicatorCounted();
   
   for(int i = limit - 1; i >= 0; i--){
      sma = iMA(_Symbol, 0, sma_period, 0, mt, pt, i);
      lma = iMA(_Symbol, 0, lma_period, 0, mt, pt, i);
      value[i] = sma - lma;
   }

   return(rates_total);
}

