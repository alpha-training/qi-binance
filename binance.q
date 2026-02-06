/import tp
.qi.import`ipc

/ 1. The Connection Logic
host:":wss://stream.binance.com:443";
tickers:`btcusdt`ethusdt`solusdt; / tickers here? 
bars:"@kline_1m"  / choose data type here
tickers:"/"sv string[tickers],\:bars
path:"/stream?streams=",tickers;

/ Construct the header with the specific resource path
header:"GET ",path," HTTP/1.1\r\nHost: stream.binance.com\r\nConnection: Upgrade\r\nUpgrade: websocket\r\n\r\n";

/ The Binance Data Handler
.binance.start:{[tickerplant]
    .z.ws:{[msg]
        raw:.j.k msg;
        / UNWRAP: If 'data' is a key, the real message is inside it
        data:$[`data in key raw;raw`data;raw];
        if[data[`e]~"kline";
            k:data`k;
            neg[.ipc.conn tickerplant](`.u.upd;`$data`e;(
                12h$1970.01.01D+1000000*7h$k`t;
                `$k`s;
                "F"$k`o;
                "F"$k`h;
                "F"$k`l;
                "F"$k`c;
                ("F"$k`q)%"F"$k`v;
                "F"$k`v
            ));
            / Updated print statement to show WHICH symbol closed
            if[k`x;-1 "qi.binance: [CLOSED] ",k[`s]," at ",k`c];
        ];
    };
    / 4. Open the Handle
    w:hsym[`$host]header;
    $[first w>0;-1 "AlphaKDB: Connection Success with . Handle: ",first string w 0;-1 "AlphaKDB: Connection Failed"];
 }


