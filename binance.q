<<<<<<< HEAD
.qi.import`ipc;
.qi.import`log;
=======
\e 1

.qi.import`ipc
>>>>>>> 2f3076e7b176af29b20e0445b2baa0a169afb8c0
.qi.frompkg[`binance;`norm]

\d .binance

tickers:"/"sv("," vs .conf.tickers),\:.conf.data
path:"/stream?streams=",tickers;
header:"GET ",path," HTTP/1.1\r\nHost: stream.binance.com\r\nConnection: Upgrade\r\nUpgrade: websocket\r\n\r\n";

insertlocal:{
    (t:$[x`x;`BinanceKline1m;`BinanceKline2s])insert norm.kline x;
    if[not`g=attr get[t]`sym;update`g#sym from t]
 }

sendtotp:{neg[`. `H](`.u.upd;$[x`x;`BinanceKline1m;`BinanceKline2s];norm.kline x)}

.z.ws:{
    data:$[`data in key d:.j.k[x]`data;d`data;d];
    if[data[`e]~"kline";
        $[.qi.isproc;sendtotp;insertlocal]data`k]
 }

\d .

start:{
    if[.qi.isproc;
        if[null H::.ipc.conn target:.proc.self`depends_on;
            if[null H::first c:.ipc.tryconnect .ipc.conns[`tp1]`port;
            .log.fatal"Could not connect to ",.qi.tostr[target]," '",last[c],"'. Exiting"]];] 
    .log.info "Connection sequence initiated...";
    if[not h:first c:.qi.try[.conf.url;.binance.header;0Ni];
        .log.error err:c 2;
        if[err like"*Protocol*";
            if[.z.o in`l64`m64;
                .log.info"Try setting the env variable:\nexport SSL_VERIFY_SERVER=NO"]]];
    if[h;.log.info"Connection success"];
 }
