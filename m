From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 3/3] tests: update tests with nft_*_parse_file()
Date: Thu, 09 Jan 2014 12:19:17 +0100
Message-ID: <20140109111917.32565.22160.stgit@nfdev.cica.es>
References: <20140109111906.32565.65222.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42318 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbaAILTX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:19:23 -0500
In-Reply-To: <20140109111906.32565.65222.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Lets do testing with nft_ruleset_parse_file() functions.

For this to work, all testfiles are enclosed in the corresponding
format top element:
 * XML: <nftables>*</nftables>
 * JSON: {"nftables":[*]}

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/jsonfiles/01-table.json          |    2 
 tests/jsonfiles/02-table.json          |    2 
 tests/jsonfiles/11-chain.json          |    2 
 tests/jsonfiles/12-chain.json          |    2 
 tests/jsonfiles/13-chain.json          |    2 
 tests/jsonfiles/14-chain.json          |    2 
 tests/jsonfiles/20-rule-bitwise.json   |    2 
 tests/jsonfiles/21-rule-byteorder.json |    2 
 tests/jsonfiles/22-rule-cmp.json       |    2 
 tests/jsonfiles/23-rule-counter.json   |    2 
 tests/jsonfiles/24-rule-ct.json        |    2 
 tests/jsonfiles/25-rule-exthdr.json    |    2 
 tests/jsonfiles/26-rule-immediate.json |    2 
 tests/jsonfiles/27-rule-limit.json     |    2 
 tests/jsonfiles/28-rule-log.json       |    2 
 tests/jsonfiles/29-rule-match.json     |    2 
 tests/jsonfiles/30-rule-lookup.json    |    2 
 tests/jsonfiles/31-rule-meta.json      |    2 
 tests/jsonfiles/32-rule-nat4.json      |    2 
 tests/jsonfiles/33-rule-nat6.json      |    2 
 tests/jsonfiles/34-rule-payload.json   |    2 
 tests/jsonfiles/35-rule-target.json    |    2 
 tests/jsonfiles/36-rule-real.json      |    2 
 tests/jsonfiles/37-rule-real.json      |    2 
 tests/jsonfiles/38-rule-real.json      |    2 
 tests/jsonfiles/39-rule-real.json      |    2 
 tests/jsonfiles/40-rule-real.json      |    2 
 tests/jsonfiles/41-rule-real.json      |    2 
 tests/jsonfiles/42-rule-real.json      |    2 
 tests/jsonfiles/43-rule-real.json      |    2 
 tests/jsonfiles/44-rule-real.json      |    2 
 tests/jsonfiles/45-rule-real.json      |    2 
 tests/jsonfiles/46-rule-real.json      |    2 
 tests/jsonfiles/47-rule-real.json      |    2 
 tests/jsonfiles/48-rule-real.json      |    2 
 tests/jsonfiles/49-rule-real.json      |    2 
 tests/jsonfiles/50-rule-real.json      |    2 
 tests/jsonfiles/51-rule-real.json      |    2 
 tests/jsonfiles/52-rule-real.json      |    2 
 tests/jsonfiles/53-rule-real.json      |    2 
 tests/jsonfiles/54-rule-real.json      |    2 
 tests/jsonfiles/55-rule-real.json      |    2 
 tests/jsonfiles/56-rule-real.json      |    2 
 tests/jsonfiles/57-rule-real.json      |    2 
 tests/jsonfiles/58-rule-real.json      |    2 
 tests/jsonfiles/59-rule-real.json      |    2 
 tests/jsonfiles/60-rule-real.json      |    2 
 tests/jsonfiles/61-rule-real.json      |    2 
 tests/jsonfiles/62-set.json            |    2 
 tests/jsonfiles/63-set.json            |    2 
 tests/jsonfiles/64-ruleset.json        |    1 
 tests/nft-parsing-test.c               |  200 +++++---------------------------
 tests/xmlfiles/01-table.xml            |    2 
 tests/xmlfiles/02-table.xml            |    2 
 tests/xmlfiles/10-chain.xml            |    2 
 tests/xmlfiles/11-chain.xml            |    2 
 tests/xmlfiles/12-chain.xml            |    2 
 tests/xmlfiles/20-rule-bitwise.xml     |    2 
 tests/xmlfiles/21-rule-byteorder.xml   |    2 
 tests/xmlfiles/22-rule-cmp.xml         |    2 
 tests/xmlfiles/23-rule-counter.xml     |    2 
 tests/xmlfiles/24-rule-ct.xml          |    2 
 tests/xmlfiles/25-rule-exthdr.xml      |    2 
 tests/xmlfiles/26-rule-immediate.xml   |    2 
 tests/xmlfiles/27-rule-limit.xml       |    2 
 tests/xmlfiles/28-rule-log.xml         |    2 
 tests/xmlfiles/29-rule-lookup.xml      |    2 
 tests/xmlfiles/30-rule-match.xml       |    2 
 tests/xmlfiles/31-rule-meta.xml        |    2 
 tests/xmlfiles/32-rule-nat6.xml        |    2 
 tests/xmlfiles/33-rule-nat4.xml        |    2 
 tests/xmlfiles/34-rule-payload.xml     |    2 
 tests/xmlfiles/35-rule-target.xml      |    2 
 tests/xmlfiles/36-rule-real.xml        |    2 
 tests/xmlfiles/37-rule-real.xml        |    2 
 tests/xmlfiles/38-rule-real.xml        |    2 
 tests/xmlfiles/39-rule-real.xml        |    2 
 tests/xmlfiles/40-rule-real.xml        |    2 
 tests/xmlfiles/41-rule-real.xml        |    2 
 tests/xmlfiles/42-rule-real.xml        |    2 
 tests/xmlfiles/43-rule-real.xml        |    2 
 tests/xmlfiles/44-rule-real.xml        |    2 
 tests/xmlfiles/45-rule-real.xml        |    2 
 tests/xmlfiles/46-rule-real.xml        |    2 
 tests/xmlfiles/47-rule-real.xml        |    2 
 tests/xmlfiles/48-rule-real.xml        |    2 
 tests/xmlfiles/49-rule-real.xml        |    2 
 tests/xmlfiles/50-rule-real.xml        |    2 
 tests/xmlfiles/51-rule-real.xml        |    2 
 tests/xmlfiles/52-rule-real.xml        |    2 
 tests/xmlfiles/53-rule-real.xml        |    2 
 tests/xmlfiles/54-rule-real.xml        |    2 
 tests/xmlfiles/55-rule-real.xml        |    2 
 tests/xmlfiles/56-rule-real.xml        |    2 
 tests/xmlfiles/57-rule-real.xml        |    2 
 tests/xmlfiles/58-rule-real.xml        |    2 
 tests/xmlfiles/59-rule-real.xml        |    2 
 tests/xmlfiles/60-rule-real.xml        |    2 
 tests/xmlfiles/61-rule-real.xml        |    2 
 tests/xmlfiles/62-rule-real.xml        |    2 
 tests/xmlfiles/63-rule-real.xml        |    2 
 tests/xmlfiles/64-rule-real.xml        |    2 
 tests/xmlfiles/65-rule-real.xml        |    2 
 tests/xmlfiles/66-rule-real.xml        |    2 
 tests/xmlfiles/67-rule-real.xml        |    2 
 tests/xmlfiles/68-rule-real.xml        |    2 
 tests/xmlfiles/69-rule-real.xml        |    2 
 tests/xmlfiles/70-rule-real.xml        |    2 
 tests/xmlfiles/71-rule-real.xml        |    2 
 tests/xmlfiles/72-rule-real.xml        |    2 
 tests/xmlfiles/73-set.xml              |    2 
 tests/xmlfiles/74-set.xml              |    2 
 112 files changed, 144 insertions(+), 277 deletions(-)

diff --git a/tests/jsonfiles/01-table.json b/tests/jsonfiles/01-table.json
index cfe7e9d..8668fb7 100644
--- a/tests/jsonfiles/01-table.json
+++ b/tests/jsonfiles/01-table.json
@@ -1 +1 @@
-{"table":{"name":"filter","family":"ip","flags":0}}
+{"nftables":[{"table":{"name":"filter","family":"ip","flags":0}}]}
diff --git a/tests/jsonfiles/02-table.json b/tests/jsonfiles/02-table.json
index ddd119c..f8f5a1d 100644
--- a/tests/jsonfiles/02-table.json
+++ b/tests/jsonfiles/02-table.json
@@ -1 +1 @@
-{"table":{"name":"filter2","family":"ip6","flags":0}}
+{"nftables":[{"table":{"name":"filter2","family":"ip6","flags":0}}]}
diff --git a/tests/jsonfiles/11-chain.json b/tests/jsonfiles/11-chain.json
index e1ed07f..2610b79 100644
--- a/tests/jsonfiles/11-chain.json
+++ b/tests/jsonfiles/11-chain.json
@@ -1 +1 @@
-{"chain":{"name":"input","handle":1,"bytes":1375696,"packets":4136,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}}
+{"nftables":[{"chain":{"name":"input","handle":1,"bytes":1375696,"packets":4136,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}}]}
diff --git a/tests/jsonfiles/12-chain.json b/tests/jsonfiles/12-chain.json
index b3fa541..3d15982 100644
--- a/tests/jsonfiles/12-chain.json
+++ b/tests/jsonfiles/12-chain.json
@@ -1 +1 @@
-{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}}
+{"nftables":[{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}}]}
diff --git a/tests/jsonfiles/13-chain.json b/tests/jsonfiles/13-chain.json
index 6d8230d..e3a17f0 100644
--- a/tests/jsonfiles/13-chain.json
+++ b/tests/jsonfiles/13-chain.json
@@ -1 +1 @@
-{"chain":{"name":"output","handle":3,"bytes":454786,"packets":2681,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}}
+{"nftables":[{"chain":{"name":"output","handle":3,"bytes":454786,"packets":2681,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}}]}
diff --git a/tests/jsonfiles/14-chain.json b/tests/jsonfiles/14-chain.json
index 44bc106..d98dc94 100644
--- a/tests/jsonfiles/14-chain.json
+++ b/tests/jsonfiles/14-chain.json
@@ -1 +1 @@
-{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0}}
+{"nftables":[{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0}}]}
diff --git a/tests/jsonfiles/20-rule-bitwise.json b/tests/jsonfiles/20-rule-bitwise.json
index 511ad88..de3d9ec 100644
--- a/tests/jsonfiles/20-rule-bitwise.json
+++ b/tests/jsonfiles/20-rule-bitwise.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":20,"expr":[{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"data_reg":{"type":"value","len":4,"data0":"0x0000000a"}},"xor":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":20,"expr":[{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"data_reg":{"type":"value","len":4,"data0":"0x0000000a"}},"xor":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}}]}}]}
diff --git a/tests/jsonfiles/21-rule-byteorder.json b/tests/jsonfiles/21-rule-byteorder.json
index 9c5498e..ae6fb32 100644
--- a/tests/jsonfiles/21-rule-byteorder.json
+++ b/tests/jsonfiles/21-rule-byteorder.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":21,"expr":[{"type":"byteorder","sreg":3,"dreg":4,"op":"hton","len":4,"size":4}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":21,"expr":[{"type":"byteorder","sreg":3,"dreg":4,"op":"hton","len":4,"size":4}]}}]}
diff --git a/tests/jsonfiles/22-rule-cmp.json b/tests/jsonfiles/22-rule-cmp.json
index ad1c71a..c32d7ad 100644
--- a/tests/jsonfiles/22-rule-cmp.json
+++ b/tests/jsonfiles/22-rule-cmp.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"forward","handle":22,"expr":[{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x6e6f6200","data2":"0x2e303164","data3":"0x00393331"}}}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"forward","handle":22,"expr":[{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x6e6f6200","data2":"0x2e303164","data3":"0x00393331"}}}]}}]}
diff --git a/tests/jsonfiles/23-rule-counter.json b/tests/jsonfiles/23-rule-counter.json
index 331ab2c..95d5072 100644
--- a/tests/jsonfiles/23-rule-counter.json
+++ b/tests/jsonfiles/23-rule-counter.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":23,"expr":[{"type":"counter","pkts":135,"bytes":21655}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":23,"expr":[{"type":"counter","pkts":135,"bytes":21655}]}}]}
diff --git a/tests/jsonfiles/24-rule-ct.json b/tests/jsonfiles/24-rule-ct.json
index 3b161f3..1aa3dd2 100644
--- a/tests/jsonfiles/24-rule-ct.json
+++ b/tests/jsonfiles/24-rule-ct.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":24,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000008"}}}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":24,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000008"}}}]}}]}
diff --git a/tests/jsonfiles/25-rule-exthdr.json b/tests/jsonfiles/25-rule-exthdr.json
index 32667a3..c40a074 100644
--- a/tests/jsonfiles/25-rule-exthdr.json
+++ b/tests/jsonfiles/25-rule-exthdr.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":25,"expr":[{"type":"exthdr","dreg":1,"exthdr_type":"mh","offset":2,"len":16}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":25,"expr":[{"type":"exthdr","dreg":1,"exthdr_type":"mh","offset":2,"len":16}]}}]}
diff --git a/tests/jsonfiles/26-rule-immediate.json b/tests/jsonfiles/26-rule-immediate.json
index fbe7f8b..3582a39 100644
--- a/tests/jsonfiles/26-rule-immediate.json
+++ b/tests/jsonfiles/26-rule-immediate.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}]}
diff --git a/tests/jsonfiles/27-rule-limit.json b/tests/jsonfiles/27-rule-limit.json
index 3ac5118..c268357 100644
--- a/tests/jsonfiles/27-rule-limit.json
+++ b/tests/jsonfiles/27-rule-limit.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":27,"expr":[{"type":"limit","rate":321321,"unit":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":27,"expr":[{"type":"limit","rate":321321,"unit":0}]}}]}
diff --git a/tests/jsonfiles/28-rule-log.json b/tests/jsonfiles/28-rule-log.json
index ad0ca8f..1e739f1 100644
--- a/tests/jsonfiles/28-rule-log.json
+++ b/tests/jsonfiles/28-rule-log.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":28,"expr":[{"type":"log","prefix":"test_chain","group":1,"snaplen":0,"qthreshold":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":28,"expr":[{"type":"log","prefix":"test_chain","group":1,"snaplen":0,"qthreshold":0}]}}]}
diff --git a/tests/jsonfiles/29-rule-match.json b/tests/jsonfiles/29-rule-match.json
index 78f087d..b533e77 100644
--- a/tests/jsonfiles/29-rule-match.json
+++ b/tests/jsonfiles/29-rule-match.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":9,"expr":[{"type":"match","name":"state"},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":9,"expr":[{"type":"match","name":"state"},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/30-rule-lookup.json b/tests/jsonfiles/30-rule-lookup.json
index 5dbf823..05576b0 100644
--- a/tests/jsonfiles/30-rule-lookup.json
+++ b/tests/jsonfiles/30-rule-lookup.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":8,"expr":[{"type":"payload","dreg":1,"offset":12,"len":4,"base":"network"},{"type":"lookup","set":"set0","sreg":1,"dreg":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":8,"expr":[{"type":"payload","dreg":1,"offset":12,"len":4,"base":"network"},{"type":"lookup","set":"set0","sreg":1,"dreg":0}]}}]}
diff --git a/tests/jsonfiles/31-rule-meta.json b/tests/jsonfiles/31-rule-meta.json
index b52d29e..96e02e5 100644
--- a/tests/jsonfiles/31-rule-meta.json
+++ b/tests/jsonfiles/31-rule-meta.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":8,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":8,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/32-rule-nat4.json b/tests/jsonfiles/32-rule-nat4.json
index eb3ae5b..aa2b50d 100644
--- a/tests/jsonfiles/32-rule-nat4.json
+++ b/tests/jsonfiles/32-rule-nat4.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":10,"expr":[{"type":"nat","nat_type":"dnat","family":"ip","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":10,"expr":[{"type":"nat","nat_type":"dnat","family":"ip","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}]}
diff --git a/tests/jsonfiles/33-rule-nat6.json b/tests/jsonfiles/33-rule-nat6.json
index fae48d0..e5d8c8f 100644
--- a/tests/jsonfiles/33-rule-nat6.json
+++ b/tests/jsonfiles/33-rule-nat6.json
@@ -1 +1 @@
-{"rule":{"family":"ip6","table":"nat","chain":"output","handle":33,"expr":[{"type":"nat","nat_type":"snat","family":"ip6","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}
+{"nftables":[{"rule":{"family":"ip6","table":"nat","chain":"output","handle":33,"expr":[{"type":"nat","nat_type":"snat","family":"ip6","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}]}
diff --git a/tests/jsonfiles/34-rule-payload.json b/tests/jsonfiles/34-rule-payload.json
index 3559ca6..7eaff41 100644
--- a/tests/jsonfiles/34-rule-payload.json
+++ b/tests/jsonfiles/34-rule-payload.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}]}
diff --git a/tests/jsonfiles/35-rule-target.json b/tests/jsonfiles/35-rule-target.json
index c8ff656..da02921 100644
--- a/tests/jsonfiles/35-rule-target.json
+++ b/tests/jsonfiles/35-rule-target.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"INPUT","handle":20,"expr":[{"type":"counter","pkts":17,"bytes":4436},{"type":"target","name":"LOG"}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"INPUT","handle":20,"expr":[{"type":"counter","pkts":17,"bytes":4436},{"type":"target","name":"LOG"}]}}]}
diff --git a/tests/jsonfiles/36-rule-real.json b/tests/jsonfiles/36-rule-real.json
index c8bfc26..4c5e331 100644
--- a/tests/jsonfiles/36-rule-real.json
+++ b/tests/jsonfiles/36-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":36,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":36,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/37-rule-real.json b/tests/jsonfiles/37-rule-real.json
index d9b4580..2645328 100644
--- a/tests/jsonfiles/37-rule-real.json
+++ b/tests/jsonfiles/37-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":37,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":37,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}]}
diff --git a/tests/jsonfiles/38-rule-real.json b/tests/jsonfiles/38-rule-real.json
index ce37407..2a7640b 100644
--- a/tests/jsonfiles/38-rule-real.json
+++ b/tests/jsonfiles/38-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":38,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":38,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}]}
diff --git a/tests/jsonfiles/39-rule-real.json b/tests/jsonfiles/39-rule-real.json
index 8529d06..5ab4fae 100644
--- a/tests/jsonfiles/39-rule-real.json
+++ b/tests/jsonfiles/39-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":39,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"gte","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"cmp","sreg":1,"op":"lte","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0xfa00a8c0"}}}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":39,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"gte","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"cmp","sreg":1,"op":"lte","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0xfa00a8c0"}}}]}}]}
diff --git a/tests/jsonfiles/40-rule-real.json b/tests/jsonfiles/40-rule-real.json
index f13c99e..483a1a5 100644
--- a/tests/jsonfiles/40-rule-real.json
+++ b/tests/jsonfiles/40-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":40,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":40,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/41-rule-real.json b/tests/jsonfiles/41-rule-real.json
index ed23fc2..d8ed85c 100644
--- a/tests/jsonfiles/41-rule-real.json
+++ b/tests/jsonfiles/41-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}]}
diff --git a/tests/jsonfiles/42-rule-real.json b/tests/jsonfiles/42-rule-real.json
index 6c305e1..49f9b56 100644
--- a/tests/jsonfiles/42-rule-real.json
+++ b/tests/jsonfiles/42-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":42,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":42,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]}}]}
diff --git a/tests/jsonfiles/43-rule-real.json b/tests/jsonfiles/43-rule-real.json
index 95d0333..be2c6fb 100644
--- a/tests/jsonfiles/43-rule-real.json
+++ b/tests/jsonfiles/43-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":43,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":43,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/44-rule-real.json b/tests/jsonfiles/44-rule-real.json
index a838dbb..890e529 100644
--- a/tests/jsonfiles/44-rule-real.json
+++ b/tests/jsonfiles/44-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":44,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x16000004"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":44,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x16000004"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/45-rule-real.json b/tests/jsonfiles/45-rule-real.json
index 8b143d6..ed61093 100644
--- a/tests/jsonfiles/45-rule-real.json
+++ b/tests/jsonfiles/45-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":45,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":45,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/46-rule-real.json b/tests/jsonfiles/46-rule-real.json
index 28643c8..ed2431e 100644
--- a/tests/jsonfiles/46-rule-real.json
+++ b/tests/jsonfiles/46-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":46,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":46,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}]}
diff --git a/tests/jsonfiles/47-rule-real.json b/tests/jsonfiles/47-rule-real.json
index 8f68634..828e3ef 100644
--- a/tests/jsonfiles/47-rule-real.json
+++ b/tests/jsonfiles/47-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":47,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":47,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}]}
diff --git a/tests/jsonfiles/48-rule-real.json b/tests/jsonfiles/48-rule-real.json
index 0cd835e..7f08637 100644
--- a/tests/jsonfiles/48-rule-real.json
+++ b/tests/jsonfiles/48-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":48,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":48,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/49-rule-real.json b/tests/jsonfiles/49-rule-real.json
index 445f46a..26f2672 100644
--- a/tests/jsonfiles/49-rule-real.json
+++ b/tests/jsonfiles/49-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":49,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":49,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/50-rule-real.json b/tests/jsonfiles/50-rule-real.json
index 2722236..b63d722 100644
--- a/tests/jsonfiles/50-rule-real.json
+++ b/tests/jsonfiles/50-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":50,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":50,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/51-rule-real.json b/tests/jsonfiles/51-rule-real.json
index 3161fa4..441716e 100644
--- a/tests/jsonfiles/51-rule-real.json
+++ b/tests/jsonfiles/51-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":51,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":51,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/52-rule-real.json b/tests/jsonfiles/52-rule-real.json
index d4092c6..baec217 100644
--- a/tests/jsonfiles/52-rule-real.json
+++ b/tests/jsonfiles/52-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":52,"expr":[{"type":"meta","dreg":1,"key":"oif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":52,"expr":[{"type":"meta","dreg":1,"key":"oif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/53-rule-real.json b/tests/jsonfiles/53-rule-real.json
index 526c9d3..bb28dea 100644
--- a/tests/jsonfiles/53-rule-real.json
+++ b/tests/jsonfiles/53-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":53,"expr":[{"type":"meta","dreg":1,"key":"oifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":53,"expr":[{"type":"meta","dreg":1,"key":"oifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/54-rule-real.json b/tests/jsonfiles/54-rule-real.json
index edb8c18..ae3b6e8 100644
--- a/tests/jsonfiles/54-rule-real.json
+++ b/tests/jsonfiles/54-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":54,"expr":[{"type":"meta","dreg":1,"key":"skuid"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":54,"expr":[{"type":"meta","dreg":1,"key":"skuid"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/55-rule-real.json b/tests/jsonfiles/55-rule-real.json
index a10fc0f..69febc0 100644
--- a/tests/jsonfiles/55-rule-real.json
+++ b/tests/jsonfiles/55-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":55,"expr":[{"type":"meta","dreg":1,"key":"skgid"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":55,"expr":[{"type":"meta","dreg":1,"key":"skgid"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/56-rule-real.json b/tests/jsonfiles/56-rule-real.json
index 137e146..6f5f4c5 100644
--- a/tests/jsonfiles/56-rule-real.json
+++ b/tests/jsonfiles/56-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":56,"expr":[{"type":"meta","dreg":1,"key":"secmark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":56,"expr":[{"type":"meta","dreg":1,"key":"secmark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/57-rule-real.json b/tests/jsonfiles/57-rule-real.json
index 8694ea1..da17f64 100644
--- a/tests/jsonfiles/57-rule-real.json
+++ b/tests/jsonfiles/57-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":57,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":57,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/58-rule-real.json b/tests/jsonfiles/58-rule-real.json
index 59237b6..52532f1 100644
--- a/tests/jsonfiles/58-rule-real.json
+++ b/tests/jsonfiles/58-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":58,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00000008"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":58,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00000008"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/59-rule-real.json b/tests/jsonfiles/59-rule-real.json
index d6245b2..aa632d3 100644
--- a/tests/jsonfiles/59-rule-real.json
+++ b/tests/jsonfiles/59-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":59,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":59,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/60-rule-real.json b/tests/jsonfiles/60-rule-real.json
index 54d5288..4b58efd 100644
--- a/tests/jsonfiles/60-rule-real.json
+++ b/tests/jsonfiles/60-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":60,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":60,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/61-rule-real.json b/tests/jsonfiles/61-rule-real.json
index 3942c3f..c6acf03 100644
--- a/tests/jsonfiles/61-rule-real.json
+++ b/tests/jsonfiles/61-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":61,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":61,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/62-set.json b/tests/jsonfiles/62-set.json
index 0e52f70..8a8d99c 100644
--- a/tests/jsonfiles/62-set.json
+++ b/tests/jsonfiles/62-set.json
@@ -1 +1 @@
-{"set":{"name":"set0","table":"filter","flags":3,"family":"ip","key_type":12,"key_len":2,"set_elem":[{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001700"}}},{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}}]}}
+{"nftables":[{"set":{"name":"set0","table":"filter","flags":3,"family":"ip","key_type":12,"key_len":2,"set_elem":[{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001700"}}},{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}}]}}]}
diff --git a/tests/jsonfiles/63-set.json b/tests/jsonfiles/63-set.json
index 90afec3..ea2fe3d 100644
--- a/tests/jsonfiles/63-set.json
+++ b/tests/jsonfiles/63-set.json
@@ -1 +1 @@
-{"set":{"name":"map0","table":"filter","flags":11,"family":"ip","key_type":12,"key_len":2,"data_type":4294967040,"data_len":16,"set_elem":[{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001700"}},"data":{"data_reg":{"type":"chain","chain":"forward"}}},{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}},"data":{"data_reg":{"type":"chain","chain":"chain1"}}}]}}
+{"nftables":[{"set":{"name":"map0","table":"filter","flags":11,"family":"ip","key_type":12,"key_len":2,"data_type":4294967040,"data_len":16,"set_elem":[{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001700"}},"data":{"data_reg":{"type":"chain","chain":"forward"}}},{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}},"data":{"data_reg":{"type":"chain","chain":"chain1"}}}]}}]}
diff --git a/tests/jsonfiles/64-ruleset.json b/tests/jsonfiles/64-ruleset.json
index 533d7fa..54eb1ff 100644
--- a/tests/jsonfiles/64-ruleset.json
+++ b/tests/jsonfiles/64-ruleset.json
@@ -1,2 +1 @@
 {"nftables":[{"table":{"name":"filter","family":"ip","flags":0}},{"table":{"name":"filter2","family":"ip6","flags":0}},{"chain":{"name":"input","handle":1,"bytes":10681449,"packets":16216,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"bytes":2375830,"packets":15184,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0}},{"set":{"name":"set0","table":"filter","flags":3,"family":"ip","key_type"
 :12,"key_len":2}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":6,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","
 cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":9,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":10,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"c
 mp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output"
 ,"handle":11,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}]}
-
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 558c849..2f9ffd9 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -12,14 +12,6 @@
 #include <libnftables/rule.h>
 #include <libnftables/set.h>
 
-#ifdef XML_PARSING
-#include <mxml.h>
-#endif
-
-#ifdef JSON_PARSING
-#include <jansson.h>
-#endif
-
 enum {
 	TEST_XML_TABLE = 0,
 	TEST_XML_CHAIN,
@@ -33,7 +25,6 @@ enum {
 	TEST_JSON_RULESET,
 };
 
-#if defined(XML_PARSING) || defined(JSON_PARSING)
 static void print_detail_error(char *a, char *b)
 {
 	int i;
@@ -73,7 +64,8 @@ static void print_detail_error(char *a, char *b)
 	}
 }
 
-static int compare_test(uint32_t type, void *input, const char *filename)
+static int compare_test(uint32_t type, void *input, const char *filename,
+			FILE *fp)
 {
 	struct nft_table *t = NULL;
 	struct nft_chain *c = NULL;
@@ -82,7 +74,6 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 	struct nft_ruleset *rs = NULL;
 	char orig[4096];
 	char out[4096];
-	FILE *fp;
 
 	switch (type) {
 	case TEST_XML_TABLE:
@@ -148,14 +139,8 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 		return -1;
 	}
 
-	fp = fopen(filename, "r");
-	if (fp == NULL) {
-		perror("open");
-		exit(EXIT_FAILURE);
-	}
-
+	rewind(fp);
 	fgets(orig, sizeof(orig), fp);
-	fclose(fp);
 
 	if (strncmp(orig, out, strlen(out)) == 0)
 		return 0;
@@ -165,192 +150,75 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 	print_detail_error(orig, out);
 	return -1;
 }
-#endif
 
 static int test_json(const char *filename, struct nft_parse_err *err)
 {
-#ifdef JSON_PARSING
 	int ret = -1;
-	struct nft_table *t;
-	struct nft_chain *c;
-	struct nft_rule *r;
-	struct nft_set *s;
 	struct nft_ruleset *rs;
-	json_t *root;
-	json_error_t error;
-	char *json;
+	FILE *fp;
 
-	root = json_load_file(filename, 0, &error);
-	if (!root)
+	fp = fopen(filename, "r");
+	if (fp == NULL) {
+		printf("unable to open file %s: %s\n", filename,
+		       strerror(errno));
 		return -1;
+	}
 
-	json = json_dumps(root, JSON_INDENT(0));
-
-	if (json_object_get(root, "table") != NULL) {
-		t = nft_table_alloc();
-		if (t != NULL) {
-			if (nft_table_parse(t, NFT_PARSE_JSON, json, err) == 0)
-				ret = compare_test(TEST_JSON_TABLE, t, filename);
-			else
-				goto failparsing;
-
-			nft_table_free(t);
-		}
-	} else if (json_object_get(root, "chain") != NULL) {
-		c = nft_chain_alloc();
-		if (c != NULL) {
-			if (nft_chain_parse(c, NFT_PARSE_JSON, json, err) == 0)
-				ret = compare_test(TEST_JSON_CHAIN, c, filename);
-			else
-				goto failparsing;
-
-			nft_chain_free(c);
-		}
-	} else if (json_object_get(root, "rule") != NULL) {
-		r = nft_rule_alloc();
-		if (r != NULL) {
-			if (nft_rule_parse(r, NFT_PARSE_JSON, json, err) == 0)
-				ret = compare_test(TEST_JSON_RULE, r, filename);
-			else
-				goto failparsing;
+	rs = nft_ruleset_alloc();
+	if (rs != NULL) {
+		if (nft_ruleset_parse_file(rs, NFT_PARSE_JSON,
+					   fp, err) == 0)
+			ret = compare_test(TEST_JSON_RULESET, rs,
+					   filename, fp);
+		else
+			goto failparsing;
 
-			nft_rule_free(r);
+		nft_ruleset_free(rs);
 		}
-	} else if (json_object_get(root, "set") != NULL) {
-		s = nft_set_alloc();
-		if (s != NULL) {
-			if (nft_set_parse(s, NFT_PARSE_JSON, json, err) == 0)
-				ret = compare_test(TEST_JSON_SET, s, filename);
-			else
-				goto failparsing;
-
-			nft_set_free(s);
-			}
-	} else if (json_object_get(root, "nftables") != NULL) {
-		rs = nft_ruleset_alloc();
-		if (rs != NULL) {
-			if (nft_ruleset_parse(rs, NFT_PARSE_JSON, json, err) == 0)
-				ret = compare_test(TEST_JSON_RULESET, rs, filename);
-			else
-				goto failparsing;
-
-			nft_ruleset_free(rs);
-			}
-	}
 
-	free(json);
-	json_decref(root);
+	fclose(fp);
 	return ret;
 
 failparsing:
+	fclose(fp);
 	printf("parsing %s: ", filename);
 	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
-	free(json);
-	json_decref(root);
-	return -1;
-#else
-	printf("Compiled without support for JSON.\n");
 	return -1;
-#endif
 }
 
 static int test_xml(const char *filename, struct nft_parse_err *err)
 {
-#ifdef XML_PARSING
 	int ret = -1;
-	struct nft_table *t;
-	struct nft_chain *c;
-	struct nft_rule *r;
-	struct nft_set *s;
 	struct nft_ruleset *rs;
 	FILE *fp;
-	mxml_node_t *tree;
-	char *xml;
 
 	fp = fopen(filename, "r");
-	tree = mxmlLoadFile(NULL, fp, MXML_NO_CALLBACK);
-	fclose(fp);
-
-	if (tree == NULL) {
-		printf("unable to build XML tree from file "
-		       "%s \033[31mFAILED\e[0m\n", filename);
-		return -1;
-	}
-
-	xml = mxmlSaveAllocString(tree, MXML_NO_CALLBACK);
-	if (xml == NULL) {
-		printf("unable to alloc string from XML tree from %s "
-		       "\033[31mFAILED\e[0m\n", filename);
+	if (fp == NULL) {
+		printf("unable to open file %s: %s\n", filename,
+		       strerror(errno));
 		return -1;
 	}
 
-	/* Check what parsing should be done */
-	if (strcmp(tree->value.opaque, "table") == 0) {
-		t = nft_table_alloc();
-		if (t != NULL) {
-			if (nft_table_parse(t, NFT_PARSE_XML, xml, err) == 0)
-				ret = compare_test(TEST_XML_TABLE, t, filename);
-			else
-				goto failparsing;
-
-			nft_table_free(t);
-		}
-	} else if (strcmp(tree->value.opaque, "chain") == 0) {
-		c = nft_chain_alloc();
-		if (c != NULL) {
-			if (nft_chain_parse(c, NFT_PARSE_XML, xml, err) == 0)
-				ret = compare_test(TEST_XML_CHAIN, c, filename);
-			else
-				goto failparsing;
+	rs = nft_ruleset_alloc();
+	if (rs != NULL) {
+		if (nft_ruleset_parse_file(rs, NFT_PARSE_XML,
+					   fp, err) == 0)
+			ret = compare_test(TEST_XML_RULESET, rs,
+					   filename, fp);
+		else
+			goto failparsing;
 
-			nft_chain_free(c);
-		}
-	} else if (strcmp(tree->value.opaque, "rule") == 0) {
-		r = nft_rule_alloc();
-		if (r != NULL) {
-			if (nft_rule_parse(r, NFT_PARSE_XML, xml, err) == 0)
-				ret = compare_test(TEST_XML_RULE, r, filename);
-			else
-				goto failparsing;
-
-			nft_rule_free(r);
-		}
-	} else if (strcmp(tree->value.opaque, "set") == 0) {
-		s = nft_set_alloc();
-		if (s != NULL) {
-			if (nft_set_parse(s, NFT_PARSE_XML, xml, err) == 0)
-				ret = compare_test(TEST_XML_SET, s, filename);
-			else
-				goto failparsing;
-
-			nft_set_free(s);
-		}
-	} else if (strcmp(tree->value.opaque, "nftables") == 0) {
-		rs = nft_ruleset_alloc();
-		if (rs != NULL) {
-			if (nft_ruleset_parse(rs, NFT_PARSE_XML,
-					      xml, err) == 0)
-				ret = compare_test(TEST_XML_RULESET, rs,
-						   filename);
-			else
-				goto failparsing;
-
-			nft_ruleset_free(rs);
-		}
+		nft_ruleset_free(rs);
 	}
 
-	mxmlDelete(tree);
+	fclose(fp);
 	return ret;
 
 failparsing:
-	mxmlDelete(tree);
+	fclose(fp);
 	printf("parsing %s: ", filename);
 	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
 	return -1;
-#else
-	printf("Compiled without support for XML.\n");
-	return -1;
-#endif
 }
 
 int main(int argc, char *argv[])
diff --git a/tests/xmlfiles/01-table.xml b/tests/xmlfiles/01-table.xml
index fefcf67..f806334 100644
--- a/tests/xmlfiles/01-table.xml
+++ b/tests/xmlfiles/01-table.xml
@@ -1 +1 @@
-<table><name>filter</name><family>ip</family><flags>0</flags></table>
+<nftables><table><name>filter</name><family>ip</family><flags>0</flags></table></nftables>
diff --git a/tests/xmlfiles/02-table.xml b/tests/xmlfiles/02-table.xml
index d0873ca..ea4e154 100644
--- a/tests/xmlfiles/02-table.xml
+++ b/tests/xmlfiles/02-table.xml
@@ -1 +1 @@
-<table><name>nat</name><family>ip6</family><flags>0</flags></table>
+<nftables><table><name>nat</name><family>ip6</family><flags>0</flags></table></nftables>
diff --git a/tests/xmlfiles/10-chain.xml b/tests/xmlfiles/10-chain.xml
index c6aa156..9c00eda 100644
--- a/tests/xmlfiles/10-chain.xml
+++ b/tests/xmlfiles/10-chain.xml
@@ -1 +1 @@
-<chain><name>test</name><handle>0</handle><bytes>0</bytes><packets>0</packets><table>filter</table><type>filter</type><hooknum>input</hooknum><prio>0</prio><policy>accept</policy><family>ip</family></chain>
+<nftables><chain><name>test</name><handle>0</handle><bytes>0</bytes><packets>0</packets><table>filter</table><type>filter</type><hooknum>input</hooknum><prio>0</prio><policy>accept</policy><family>ip</family></chain></nftables>
diff --git a/tests/xmlfiles/11-chain.xml b/tests/xmlfiles/11-chain.xml
index 3423078..3d9978e 100644
--- a/tests/xmlfiles/11-chain.xml
+++ b/tests/xmlfiles/11-chain.xml
@@ -1 +1 @@
-<chain><name>test</name><handle>0</handle><bytes>59</bytes><packets>1</packets><table>filter</table><type>filter</type><hooknum>forward</hooknum><prio>0</prio><policy>drop</policy><family>ip6</family></chain>
+<nftables><chain><name>test</name><handle>0</handle><bytes>59</bytes><packets>1</packets><table>filter</table><type>filter</type><hooknum>forward</hooknum><prio>0</prio><policy>drop</policy><family>ip6</family></chain></nftables>
diff --git a/tests/xmlfiles/12-chain.xml b/tests/xmlfiles/12-chain.xml
index 6afcd00..db0f56c 100644
--- a/tests/xmlfiles/12-chain.xml
+++ b/tests/xmlfiles/12-chain.xml
@@ -1 +1 @@
-<chain><name>foo</name><handle>100</handle><bytes>59264154979</bytes><packets>2548796325</packets><table>nat</table><type>nat</type><hooknum>postrouting</hooknum><prio>0</prio><policy>accept</policy><family>ip</family></chain>
+<nftables><chain><name>foo</name><handle>100</handle><bytes>59264154979</bytes><packets>2548796325</packets><table>nat</table><type>nat</type><hooknum>postrouting</hooknum><prio>0</prio><policy>accept</policy><family>ip</family></chain></nftables>
diff --git a/tests/xmlfiles/20-rule-bitwise.xml b/tests/xmlfiles/20-rule-bitwise.xml
index 9517db9..8562863 100644
--- a/tests/xmlfiles/20-rule-bitwise.xml
+++ b/tests/xmlfiles/20-rule-bitwise.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr></rule></nftables>
 <!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/21-rule-byteorder.xml b/tests/xmlfiles/21-rule-byteorder.xml
index f8f13b6..fce4ed1 100644
--- a/tests/xmlfiles/21-rule-byteorder.xml
+++ b/tests/xmlfiles/21-rule-byteorder.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>test</table><chain>test</chain><handle>1000</handle><expr type="byteorder"><sreg>3</sreg><dreg>4</dreg><op>hton</op><len>4</len><size>4</size></expr></rule>
+<nftables><rule><family>ip</family><table>test</table><chain>test</chain><handle>1000</handle><expr type="byteorder"><sreg>3</sreg><dreg>4</dreg><op>hton</op><len>4</len><size>4</size></expr></rule></nftables>
diff --git a/tests/xmlfiles/22-rule-cmp.xml b/tests/xmlfiles/22-rule-cmp.xml
index 837d0de..ea8ea30 100644
--- a/tests/xmlfiles/22-rule-cmp.xml
+++ b/tests/xmlfiles/22-rule-cmp.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></data_reg></cmpdata></expr></rule>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></data_reg></cmpdata></expr></rule></nftables>
 <!-- nft add rule ip6 filter test meta iifname bond10.139 accept -->
diff --git a/tests/xmlfiles/23-rule-counter.xml b/tests/xmlfiles/23-rule-counter.xml
index 77aba7a..82700de 100644
--- a/tests/xmlfiles/23-rule-counter.xml
+++ b/tests/xmlfiles/23-rule-counter.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>39</handle><expr type="counter"><pkts>3</pkts><bytes>177</bytes></expr></rule>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>39</handle><expr type="counter"><pkts>3</pkts><bytes>177</bytes></expr></rule></nftables>
 <!-- nft add rule ip6 filter test udp dport 53 counter accept -->
diff --git a/tests/xmlfiles/24-rule-ct.xml b/tests/xmlfiles/24-rule-ct.xml
index 814ab52..e8e565d 100644
--- a/tests/xmlfiles/24-rule-ct.xml
+++ b/tests/xmlfiles/24-rule-ct.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr></rule></nftables>
 <!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/25-rule-exthdr.xml b/tests/xmlfiles/25-rule-exthdr.xml
index 6bf139c..9e10a88 100644
--- a/tests/xmlfiles/25-rule-exthdr.xml
+++ b/tests/xmlfiles/25-rule-exthdr.xml
@@ -1 +1 @@
-<rule><family>ip6</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="exthdr"><dreg>1</dreg><exthdr_type>mh</exthdr_type><offset>2</offset><len>16</len></expr></rule>
+<nftables><rule><family>ip6</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="exthdr"><dreg>1</dreg><exthdr_type>mh</exthdr_type><offset>2</offset><len>16</len></expr></rule></nftables>
diff --git a/tests/xmlfiles/26-rule-immediate.xml b/tests/xmlfiles/26-rule-immediate.xml
index 2928142..4d10eb6 100644
--- a/tests/xmlfiles/26-rule-immediate.xml
+++ b/tests/xmlfiles/26-rule-immediate.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule></nftables>
 <!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/27-rule-limit.xml b/tests/xmlfiles/27-rule-limit.xml
index 6761c9e..a4398e8 100644
--- a/tests/xmlfiles/27-rule-limit.xml
+++ b/tests/xmlfiles/27-rule-limit.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="limit"><rate>123123</rate><unit>321321</unit></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="limit"><rate>123123</rate><unit>321321</unit></expr></rule></nftables>
diff --git a/tests/xmlfiles/28-rule-log.xml b/tests/xmlfiles/28-rule-log.xml
index d30e5fb..f24f858 100644
--- a/tests/xmlfiles/28-rule-log.xml
+++ b/tests/xmlfiles/28-rule-log.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>96</handle><expr type="log"><prefix>test_chain</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>96</handle><expr type="log"><prefix>test_chain</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
 <!-- nft add rule ip6 filter test log prefix test_chain group 1 -->
diff --git a/tests/xmlfiles/29-rule-lookup.xml b/tests/xmlfiles/29-rule-lookup.xml
index b08ccd3..c77e95c 100644
--- a/tests/xmlfiles/29-rule-lookup.xml
+++ b/tests/xmlfiles/29-rule-lookup.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>37</handle><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>37</handle><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
 <!-- nft add rule ip6 filter test ip6 saddr { ::2 , ::3 } drop -->
diff --git a/tests/xmlfiles/30-rule-match.xml b/tests/xmlfiles/30-rule-match.xml
index b4cf72b..4cfe33b 100644
--- a/tests/xmlfiles/30-rule-match.xml
+++ b/tests/xmlfiles/30-rule-match.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="match"><name>state</name></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="match"><name>state</name></expr></rule></nftables>
diff --git a/tests/xmlfiles/31-rule-meta.xml b/tests/xmlfiles/31-rule-meta.xml
index b38e430..22498e7 100644
--- a/tests/xmlfiles/31-rule-meta.xml
+++ b/tests/xmlfiles/31-rule-meta.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr></rule>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr></rule></nftables>
 <!-- nft add rule ip6 filter test meta iifname bond10.139 accept -->
diff --git a/tests/xmlfiles/32-rule-nat6.xml b/tests/xmlfiles/32-rule-nat6.xml
index 81566ce..f96b7d8 100644
--- a/tests/xmlfiles/32-rule-nat6.xml
+++ b/tests/xmlfiles/32-rule-nat6.xml
@@ -1 +1 @@
-<rule><family>ip6</family><table>nat</table><chain>OUTPUT</chain><handle>100</handle><expr type="nat"><type>snat</type><family>ip6</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule>
+<nftables><rule><family>ip6</family><table>nat</table><chain>OUTPUT</chain><handle>100</handle><expr type="nat"><type>snat</type><family>ip6</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule></nftables>
diff --git a/tests/xmlfiles/33-rule-nat4.xml b/tests/xmlfiles/33-rule-nat4.xml
index 0e495a8..73c5b56 100644
--- a/tests/xmlfiles/33-rule-nat4.xml
+++ b/tests/xmlfiles/33-rule-nat4.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="nat"><type>dnat</type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="nat"><type>dnat</type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule></nftables>
diff --git a/tests/xmlfiles/34-rule-payload.xml b/tests/xmlfiles/34-rule-payload.xml
index 6c2da6a..833e640 100644
--- a/tests/xmlfiles/34-rule-payload.xml
+++ b/tests/xmlfiles/34-rule-payload.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr></rule>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr></rule></nftables>
 <!-- nft add rule ip6 filter test tcp dport 22 accept -->
diff --git a/tests/xmlfiles/35-rule-target.xml b/tests/xmlfiles/35-rule-target.xml
index 6925d96..5b46350 100644
--- a/tests/xmlfiles/35-rule-target.xml
+++ b/tests/xmlfiles/35-rule-target.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="target"><name>LOG</name></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="target"><name>LOG</name></expr></rule></nftables>
diff --git a/tests/xmlfiles/36-rule-real.xml b/tests/xmlfiles/36-rule-real.xml
index 1c953e7..17f1e5f 100644
--- a/tests/xmlfiles/36-rule-real.xml
+++ b/tests/xmlfiles/36-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule filter INPUT ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter -->
diff --git a/tests/xmlfiles/37-rule-real.xml b/tests/xmlfiles/37-rule-real.xml
index 3c8ba13..dc45629 100644
--- a/tests/xmlfiles/37-rule-real.xml
+++ b/tests/xmlfiles/37-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</data0></data
 _reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><
 data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</da
 ta0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><le
 n>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
 <!-- nft add rule filter INPUT meta iifname "eth0" tcp dport 22 ct state new,established counter log prefix testprefix group 1 -->
diff --git a/tests/xmlfiles/38-rule-real.xml b/tests/xmlfiles/38-rule-real.xml
index 6161425..6f41f0e 100644
--- a/tests/xmlfiles/38-rule-real.xml
+++ b/tests/xmlfiles/38-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x0000bb01</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>
 0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x0000bb01</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immedia
 te"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule></nftables>
 <!-- nft add rule ip filter INPUT ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } tcp dport 443 counter accept -->
diff --git a/tests/xmlfiles/39-rule-real.xml b/tests/xmlfiles/39-rule-real.xml
index fbf3d61..c823c25 100644
--- a/tests/xmlfiles/39-rule-real.xml
+++ b/tests/xmlfiles/39-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></cmpdata></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><le
 n>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>6</offset
 ><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_drop</prefix><group>2</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr><expr type="i
 mmediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></cmpdata></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="
 value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset
 >6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_drop</prefix><group>2</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr><ex
 pr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
 <!-- nft add rule ip6 filter test meta iifname "bond0" meta oifname "bond1.27" ip6 saddr 2a00:9ac0:c1ca:27::150 udp dport 53 ct status expected counter log prefix dns_drop group 2 drop -->
diff --git a/tests/xmlfiles/40-rule-real.xml b/tests/xmlfiles/40-rule-real.xml
index 8e1d565..835dcec 100644
--- a/tests/xmlfiles/40-rule-real.xml
+++ b/tests/xmlfiles/40-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr></rule></nftables>
 <!-- nft add rule filter output ip daddr 192.168.0.1 -->
diff --git a/tests/xmlfiles/41-rule-real.xml b/tests/xmlfiles/41-rule-real.xml
index 810267d..001a20e 100644
--- a/tests/xmlfiles/41-rule-real.xml
+++ b/tests/xmlfiles/41-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><cmpdata><data_reg type="value"><len>4</len><data0>0xfa00a8c0</data0></data_reg></cmpdata></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><cmpdata><data_reg type="value"><len>4</len><data0>0xfa00a8c0</data0></data_reg></cmpdata></expr></rule></nftables>
 <!-- nft add rule filter output ip daddr 192.168.0.1-192.168.0.250 -->
diff --git a/tests/xmlfiles/42-rule-real.xml b/tests/xmlfiles/42-rule-real.xml
index 6aba9eb..6398c48 100644
--- a/tests/xmlfiles/42-rule-real.xml
+++ b/tests/xmlfiles/42-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule filter output ip daddr 192.168.0.1 counter -->
diff --git a/tests/xmlfiles/43-rule-real.xml b/tests/xmlfiles/43-rule-real.xml
index 7a2fe6b..38be43e 100644
--- a/tests/xmlfiles/43-rule-real.xml
+++ b/tests/xmlfiles/43-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
 <!-- nft add rule filter output ip daddr 192.168.0.1 counter drop -->
diff --git a/tests/xmlfiles/44-rule-real.xml b/tests/xmlfiles/44-rule-real.xml
index 69bdca8..8ab5db9 100644
--- a/tests/xmlfiles/44-rule-real.xml
+++ b/tests/xmlfiles/44-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>(null)</prefix><group>0</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>(null)</prefix><group>0</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
 <!-- nft add rule filter output ip daddr 192.168.0.1 counter log -->
diff --git a/tests/xmlfiles/45-rule-real.xml b/tests/xmlfiles/45-rule-real.xml
index 36837de..165d581 100644
--- a/tests/xmlfiles/45-rule-real.xml
+++ b/tests/xmlfiles/45-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule filter output tcp dport 22 counter -->
diff --git a/tests/xmlfiles/46-rule-real.xml b/tests/xmlfiles/46-rule-real.xml
index 8465d0f..d6f7376 100644
--- a/tests/xmlfiles/46-rule-real.xml
+++ b/tests/xmlfiles/46-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x16000004</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x16000004</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule filter output tcp sport 1024 tcp dport 22 counter -->
diff --git a/tests/xmlfiles/47-rule-real.xml b/tests/xmlfiles/47-rule-real.xml
index 39a09a5..815bd61 100644
--- a/tests/xmlfiles/47-rule-real.xml
+++ b/tests/xmlfiles/47-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule filter output ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter -->
diff --git a/tests/xmlfiles/48-rule-real.xml b/tests/xmlfiles/48-rule-real.xml
index 89c5088..4b31948 100644
--- a/tests/xmlfiles/48-rule-real.xml
+++ b/tests/xmlfiles/48-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule></nftables>
 <!-- nft add rule filter output tcp sequence 0 tcp sport 1024 tcp dport 22 -->
diff --git a/tests/xmlfiles/49-rule-real.xml b/tests/xmlfiles/49-rule-real.xml
index 0896823..a4db57f 100644
--- a/tests/xmlfiles/49-rule-real.xml
+++ b/tests/xmlfiles/49-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule></nftables>
 <!-- nft add rule filter output tcp sport 1024 tcp dport 22 tcp sequence 0 -->
diff --git a/tests/xmlfiles/50-rule-real.xml b/tests/xmlfiles/50-rule-real.xml
index 1195131..72bddc7 100644
--- a/tests/xmlfiles/50-rule-real.xml
+++ b/tests/xmlfiles/50-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
 <!-- nft add rule filter output ct state new,established counter -->
diff --git a/tests/xmlfiles/51-rule-real.xml b/tests/xmlfiles/51-rule-real.xml
index 4064ffb..72cac29 100644
--- a/tests/xmlfiles/51-rule-real.xml
+++ b/tests/xmlfiles/51-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule></nftables>
 <!-- nft add rule filter output ct direction original counter -->
diff --git a/tests/xmlfiles/52-rule-real.xml b/tests/xmlfiles/52-rule-real.xml
index 6ee7459..ca14eb8 100644
--- a/tests/xmlfiles/52-rule-real.xml
+++ b/tests/xmlfiles/52-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule></nftables>
 <!-- nft add rule filter output ct direction reply counter -->
diff --git a/tests/xmlfiles/53-rule-real.xml b/tests/xmlfiles/53-rule-real.xml
index ec4ea21..304732b 100644
--- a/tests/xmlfiles/53-rule-real.xml
+++ b/tests/xmlfiles/53-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule filter output ct status expected counter -->
diff --git a/tests/xmlfiles/54-rule-real.xml b/tests/xmlfiles/54-rule-real.xml
index c80d43a..5312eca 100644
--- a/tests/xmlfiles/54-rule-real.xml
+++ b/tests/xmlfiles/54-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000064</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000064</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft rule add filter output ct mark 100 counter -->
diff --git a/tests/xmlfiles/55-rule-real.xml b/tests/xmlfiles/55-rule-real.xml
index 47f2e01..757a7a2 100644
--- a/tests/xmlfiles/55-rule-real.xml
+++ b/tests/xmlfiles/55-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
 <!-- nft add rule filter output ct secmark 0 counter -->
diff --git a/tests/xmlfiles/56-rule-real.xml b/tests/xmlfiles/56-rule-real.xml
index e4965e1..242ddbb 100644
--- a/tests/xmlfiles/56-rule-real.xml
+++ b/tests/xmlfiles/56-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0000001e</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0000001e</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule filter output ct expiration 30 counter -->
diff --git a/tests/xmlfiles/57-rule-real.xml b/tests/xmlfiles/57-rule-real.xml
index 985b274..136e5f1 100644
--- a/tests/xmlfiles/57-rule-real.xml
+++ b/tests/xmlfiles/57-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00707466</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00707466</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule filter output ct helper "ftp" counter -->
diff --git a/tests/xmlfiles/58-rule-real.xml b/tests/xmlfiles/58-rule-real.xml
index 4b456c1..4474eb2 100644
--- a/tests/xmlfiles/58-rule-real.xml
+++ b/tests/xmlfiles/58-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule ip filter output meta length 1000 counter -->
diff --git a/tests/xmlfiles/59-rule-real.xml b/tests/xmlfiles/59-rule-real.xml
index 603fe19..4e231a2 100644
--- a/tests/xmlfiles/59-rule-real.xml
+++ b/tests/xmlfiles/59-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00000008</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00000008</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
 <!-- nft add rule ip filter output meta protocol 0x0800 counter -->
diff --git a/tests/xmlfiles/60-rule-real.xml b/tests/xmlfiles/60-rule-real.xml
index 66a96fe..535ab54 100644
--- a/tests/xmlfiles/60-rule-real.xml
+++ b/tests/xmlfiles/60-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
 <!-- nft add rule ip filter output meta mark 0 counter -->
diff --git a/tests/xmlfiles/61-rule-real.xml b/tests/xmlfiles/61-rule-real.xml
index 5c1340c..2a5d411 100644
--- a/tests/xmlfiles/61-rule-real.xml
+++ b/tests/xmlfiles/61-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule ip filter output meta iif lo counter -->
diff --git a/tests/xmlfiles/62-rule-real.xml b/tests/xmlfiles/62-rule-real.xml
index 6a6d381..dfb6e44 100644
--- a/tests/xmlfiles/62-rule-real.xml
+++ b/tests/xmlfiles/62-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule ip filter output meta iifname "eth0" counter -->
diff --git a/tests/xmlfiles/63-rule-real.xml b/tests/xmlfiles/63-rule-real.xml
index baa13a7..b144889 100644
--- a/tests/xmlfiles/63-rule-real.xml
+++ b/tests/xmlfiles/63-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule ip filter output meta oif lo counter -->
diff --git a/tests/xmlfiles/64-rule-real.xml b/tests/xmlfiles/64-rule-real.xml
index 157773f..a83efb9 100644
--- a/tests/xmlfiles/64-rule-real.xml
+++ b/tests/xmlfiles/64-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule ip filter output meta oifname "eth0" counter -->
diff --git a/tests/xmlfiles/65-rule-real.xml b/tests/xmlfiles/65-rule-real.xml
index 06c560b..cfec802 100644
--- a/tests/xmlfiles/65-rule-real.xml
+++ b/tests/xmlfiles/65-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule ip filter output meta skuid 1000 counter -->
diff --git a/tests/xmlfiles/66-rule-real.xml b/tests/xmlfiles/66-rule-real.xml
index 9a5b721..57b0d45 100644
--- a/tests/xmlfiles/66-rule-real.xml
+++ b/tests/xmlfiles/66-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule ip filter output meta skgid 1000 counter -->
diff --git a/tests/xmlfiles/67-rule-real.xml b/tests/xmlfiles/67-rule-real.xml
index a3cbc2d..1ee49fc 100644
--- a/tests/xmlfiles/67-rule-real.xml
+++ b/tests/xmlfiles/67-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
 <!-- nft add rule ip filter output meta secmark 0 counter -->
diff --git a/tests/xmlfiles/68-rule-real.xml b/tests/xmlfiles/68-rule-real.xml
index 7023e59..70bccd9 100644
--- a/tests/xmlfiles/68-rule-real.xml
+++ b/tests/xmlfiles/68-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
 <!-- nft add rule filter output tcp dport { 22, 23 } counter -->
diff --git a/tests/xmlfiles/69-rule-real.xml b/tests/xmlfiles/69-rule-real.xml
index dc2728e..2c61706 100644
--- a/tests/xmlfiles/69-rule-real.xml
+++ b/tests/xmlfiles/69-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>33</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set1</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>33</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
 <!-- nft add rule ip filter output ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } -->
diff --git a/tests/xmlfiles/70-rule-real.xml b/tests/xmlfiles/70-rule-real.xml
index 64834d4..0a876e9 100644
--- a/tests/xmlfiles/70-rule-real.xml
+++ b/tests/xmlfiles/70-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
 <!-- nft add rule ip filter output tcp dport vmap { 22 => jump chain1, 23 => jump chain2, } -->
diff --git a/tests/xmlfiles/71-rule-real.xml b/tests/xmlfiles/71-rule-real.xml
index e10437a..143de72 100644
--- a/tests/xmlfiles/71-rule-real.xml
+++ b/tests/xmlfiles/71-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
 <!-- nft add rule ip filter output tcp dport vmap { 22 => accept, 23 => drop, } -->
diff --git a/tests/xmlfiles/72-rule-real.xml b/tests/xmlfiles/72-rule-real.xml
index ccda1fe..fb35523 100644
--- a/tests/xmlfiles/72-rule-real.xml
+++ b/tests/xmlfiles/72-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>36</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>map2</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>36</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>map2</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
 <!-- nft add rule ip filter output ip daddr vmap { 192.168.1.1 => accept, 192.168.1.2 => drop, } -->
diff --git a/tests/xmlfiles/73-set.xml b/tests/xmlfiles/73-set.xml
index 88bf402..37fb2ee 100644
--- a/tests/xmlfiles/73-set.xml
+++ b/tests/xmlfiles/73-set.xml
@@ -1,2 +1,2 @@
-<set><family>ip</family><table>filter</table><name>set0</name><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0300a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0200a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></key></set_elem></set>
+<nftables><set><family>ip</family><table>filter</table><name>set0</name><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0300a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0200a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></key></set_elem></set></nftables>
 <!-- nft add rule ip filter test ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } tcp dport 443 counter accept -->
diff --git a/tests/xmlfiles/74-set.xml b/tests/xmlfiles/74-set.xml
index 5b6e8f1..679ee30 100644
--- a/tests/xmlfiles/74-set.xml
+++ b/tests/xmlfiles/74-set.xml
@@ -1,2 +1,2 @@
-<set><family>ip6</family><table>filter</table><name>set0</name><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></key></set_elem></set>
+<nftables><set><family>ip6</family><table>filter</table><name>set0</name><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></key></set_elem></set></nftables>
 <!-- nft add rule ip6 filter test ip6 daddr { 2a00:9ac0:c1ca:27::150, 2a00:9ac0:c1ca:27::170, } counter accept -->

