//+------------------------------------------------------------------+
//|                                                    AutoClose.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//---
input double Proft=0.01; // Profit
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Price();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Price();
   CloseWinner();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   CloseWinner();
  }
//+------------------------------------------------------------------+

void Price()
  {
   double price=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double EUR=SymbolInfoDouble("EURUSDmicro",SYMBOL_ASK);
   double Converted=AccountBalance()/EUR;
   double Converted2=AccountEquity()/EUR;
   double Converted3=AccountProfit()/EUR;

   ObjectCreate("EURB",OBJ_LABEL,0,0,0);
   ObjectSetText("EURB","Balance in Eur: "+DoubleToStr(Converted,2),10,"Verdana",White);
   ObjectSet("EURB",OBJPROP_CORNER,1);
   ObjectSet("EURB",OBJPROP_XDISTANCE,20);
   ObjectSet("EURB",OBJPROP_YDISTANCE,20);

   ObjectCreate("EUREq",OBJ_LABEL,0,0,0);
   ObjectSetText("EUREq","Equity in Eur: "+DoubleToStr(Converted2,2),10,"Verdana",White);
   ObjectSet("EUREq",OBJPROP_CORNER,1);
   ObjectSet("EUREq",OBJPROP_XDISTANCE,20);
   ObjectSet("EUREq",OBJPROP_YDISTANCE,40);

   ObjectCreate("EURPr",OBJ_LABEL,0,0,0);
   ObjectSetText("EURPr","Profit in Eur: "+DoubleToStr(Converted3,2),10,"Verdana",White);
   ObjectSet("EURPr",OBJPROP_CORNER,1);
   ObjectSet("EURPr",OBJPROP_XDISTANCE,20);
   ObjectSet("EURPr",OBJPROP_YDISTANCE,60);

  }
//+------------------------------------------------------------------+

int CloseWinner()
  {
   int ticket;

   if(OrdersTotal()==0)
      return(0);

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderProfit()<Proft)
            continue;
         if(OrderType()==0)
           {
            ticket=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,clrNONE);
           }
         if(OrderType()==1)
           {
            ticket=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,clrNONE);
           }
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
