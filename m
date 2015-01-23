From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 5/5] test: update json/xml tests to the new syntax
Date: Fri, 23 Jan 2015 15:49:56 +0100
Message-ID: <1422024596-8839-6-git-send-email-alvaroneay@gmail.com>
References: <1422024596-8839-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44946 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbbAWOtu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:49:50 -0500
Received: by mail-wg0-f48.google.com with SMTP id x12so7884688wgg.7
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2015 06:49:48 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id ev7sm2462989wjb.47.2015.01.23.06.49.46
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Jan 2015 06:49:47 -0800 (PST)
In-Reply-To: <1422024596-8839-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 tests/jsonfiles/01-table.json            |    2 +-
 tests/jsonfiles/02-table.json            |    2 +-
 tests/jsonfiles/11-chain.json            |    2 +-
 tests/jsonfiles/12-chain.json            |    2 +-
 tests/jsonfiles/13-chain.json            |    2 +-
 tests/jsonfiles/14-chain.json            |    2 +-
 tests/jsonfiles/20-rule-bitwise.json     |    2 +-
 tests/jsonfiles/21-rule-byteorder.json   |    2 +-
 tests/jsonfiles/22-rule-cmp.json         |    2 +-
 tests/jsonfiles/23-rule-counter.json     |    2 +-
 tests/jsonfiles/24-rule-ct.json          |    2 +-
 tests/jsonfiles/25-rule-exthdr.json      |    2 +-
 tests/jsonfiles/26-rule-immediate.json   |    2 +-
 tests/jsonfiles/27-rule-limit.json       |    2 +-
 tests/jsonfiles/28-rule-log.json         |    2 +-
 tests/jsonfiles/29-rule-match.json       |    2 +-
 tests/jsonfiles/30-rule-lookup.json      |    2 +-
 tests/jsonfiles/31-rule-meta.json        |    2 +-
 tests/jsonfiles/32-rule-nat4.json        |    2 +-
 tests/jsonfiles/33-rule-nat6.json        |    2 +-
 tests/jsonfiles/34-rule-payload.json     |    2 +-
 tests/jsonfiles/35-rule-target.json      |    2 +-
 tests/jsonfiles/36-rule-real.json        |    2 +-
 tests/jsonfiles/37-rule-real.json        |    2 +-
 tests/jsonfiles/38-rule-real.json        |    2 +-
 tests/jsonfiles/39-rule-real.json        |    2 +-
 tests/jsonfiles/40-rule-real.json        |    2 +-
 tests/jsonfiles/41-rule-real.json        |    2 +-
 tests/jsonfiles/42-rule-real.json        |    2 +-
 tests/jsonfiles/43-rule-real.json        |    2 +-
 tests/jsonfiles/44-rule-real.json        |    2 +-
 tests/jsonfiles/45-rule-real.json        |    2 +-
 tests/jsonfiles/46-rule-real.json        |    2 +-
 tests/jsonfiles/47-rule-real.json        |    2 +-
 tests/jsonfiles/48-rule-real.json        |    2 +-
 tests/jsonfiles/49-rule-real.json        |    2 +-
 tests/jsonfiles/50-rule-real.json        |    2 +-
 tests/jsonfiles/51-rule-real.json        |    2 +-
 tests/jsonfiles/52-rule-real.json        |    2 +-
 tests/jsonfiles/53-rule-real.json        |    2 +-
 tests/jsonfiles/54-rule-real.json        |    2 +-
 tests/jsonfiles/55-rule-real.json        |    2 +-
 tests/jsonfiles/56-rule-real.json        |    2 +-
 tests/jsonfiles/57-rule-real.json        |    2 +-
 tests/jsonfiles/58-rule-real.json        |    2 +-
 tests/jsonfiles/59-rule-real.json        |    2 +-
 tests/jsonfiles/60-rule-real.json        |    2 +-
 tests/jsonfiles/61-rule-real.json        |    2 +-
 tests/jsonfiles/62-set.json              |    2 +-
 tests/jsonfiles/63-set.json              |    2 +-
 tests/jsonfiles/64-ruleset.json          |    2 +-
 tests/jsonfiles/65-rule-meta-target.json |    2 +-
 tests/jsonfiles/66-rule-queue.json       |    2 +-
 tests/jsonfiles/67-rule-queue.json       |    2 +-
 tests/jsonfiles/68-rule-masq.json        |    2 +-
 tests/jsonfiles/69-rule-redir.json       |    2 +-
 tests/jsonfiles/70-rule-real.json        |    1 +
 tests/nft-parsing-test.c                 |    4 ++--
 tests/xmlfiles/01-table.xml              |    2 +-
 tests/xmlfiles/02-table.xml              |    2 +-
 tests/xmlfiles/10-chain.xml              |    2 +-
 tests/xmlfiles/11-chain.xml              |    2 +-
 tests/xmlfiles/12-chain.xml              |    2 +-
 tests/xmlfiles/20-rule-bitwise.xml       |    2 +-
 tests/xmlfiles/21-rule-byteorder.xml     |    2 +-
 tests/xmlfiles/22-rule-cmp.xml           |    2 +-
 tests/xmlfiles/23-rule-counter.xml       |    2 +-
 tests/xmlfiles/24-rule-ct.xml            |    2 +-
 tests/xmlfiles/25-rule-exthdr.xml        |    2 +-
 tests/xmlfiles/26-rule-immediate.xml     |    2 +-
 tests/xmlfiles/27-rule-limit.xml         |    2 +-
 tests/xmlfiles/28-rule-log.xml           |    2 +-
 tests/xmlfiles/29-rule-lookup.xml        |    2 +-
 tests/xmlfiles/30-rule-match.xml         |    2 +-
 tests/xmlfiles/31-rule-meta.xml          |    2 +-
 tests/xmlfiles/32-rule-nat6.xml          |    2 +-
 tests/xmlfiles/33-rule-nat4.xml          |    2 +-
 tests/xmlfiles/34-rule-payload.xml       |    2 +-
 tests/xmlfiles/35-rule-target.xml        |    2 +-
 tests/xmlfiles/36-rule-real.xml          |    2 +-
 tests/xmlfiles/37-rule-real.xml          |    2 +-
 tests/xmlfiles/38-rule-real.xml          |    2 +-
 tests/xmlfiles/39-rule-real.xml          |    2 +-
 tests/xmlfiles/40-rule-real.xml          |    2 +-
 tests/xmlfiles/41-rule-real.xml          |    2 +-
 tests/xmlfiles/42-rule-real.xml          |    2 +-
 tests/xmlfiles/43-rule-real.xml          |    2 +-
 tests/xmlfiles/44-rule-real.xml          |    2 +-
 tests/xmlfiles/45-rule-real.xml          |    2 +-
 tests/xmlfiles/46-rule-real.xml          |    2 +-
 tests/xmlfiles/47-rule-real.xml          |    2 +-
 tests/xmlfiles/48-rule-real.xml          |    2 +-
 tests/xmlfiles/49-rule-real.xml          |    2 +-
 tests/xmlfiles/50-rule-real.xml          |    2 +-
 tests/xmlfiles/51-rule-real.xml          |    2 +-
 tests/xmlfiles/52-rule-real.xml          |    2 +-
 tests/xmlfiles/53-rule-real.xml          |    2 +-
 tests/xmlfiles/54-rule-real.xml          |    2 +-
 tests/xmlfiles/55-rule-real.xml          |    2 +-
 tests/xmlfiles/56-rule-real.xml          |    2 +-
 tests/xmlfiles/57-rule-real.xml          |    2 +-
 tests/xmlfiles/58-rule-real.xml          |    2 +-
 tests/xmlfiles/59-rule-real.xml          |    2 +-
 tests/xmlfiles/60-rule-real.xml          |    2 +-
 tests/xmlfiles/61-rule-real.xml          |    2 +-
 tests/xmlfiles/62-rule-real.xml          |    2 +-
 tests/xmlfiles/63-rule-real.xml          |    2 +-
 tests/xmlfiles/64-rule-real.xml          |    2 +-
 tests/xmlfiles/65-rule-real.xml          |    2 +-
 tests/xmlfiles/66-rule-real.xml          |    2 +-
 tests/xmlfiles/67-rule-real.xml          |    2 +-
 tests/xmlfiles/68-rule-real.xml          |    2 +-
 tests/xmlfiles/69-rule-real.xml          |    2 +-
 tests/xmlfiles/70-rule-real.xml          |    2 +-
 tests/xmlfiles/71-rule-real.xml          |    2 +-
 tests/xmlfiles/72-rule-real.xml          |    2 +-
 tests/xmlfiles/73-set.xml                |    2 +-
 tests/xmlfiles/74-set.xml                |    2 +-
 tests/xmlfiles/75-ruleset.xml            |    2 +-
 tests/xmlfiles/76-rule-meta_target.xml   |    2 +-
 tests/xmlfiles/77-rule-queue.xml         |    2 +-
 tests/xmlfiles/78-rule-queue.xml         |    2 +-
 tests/xmlfiles/79-rule-masq.xml          |    2 +-
 tests/xmlfiles/80-rule-redir.xml         |    2 +-
 tests/xmlfiles/81-rule-real.xml          |    1 +
 125 files changed, 126 insertions(+), 124 deletions(-)
 create mode 100644 tests/jsonfiles/70-rule-real.json
 create mode 100644 tests/xmlfiles/81-rule-real.xml

diff --git a/tests/jsonfiles/01-table.json b/tests/jsonfiles/01-table.json
index 9be7b40..20754f1 100644
--- a/tests/jsonfiles/01-table.json
+++ b/tests/jsonfiles/01-table.json
@@ -1 +1 @@
-{"nftables":[{"table":{"name":"filter","family":"ip","flags":0,"use":0}}]}
+{"nftables":[{"add":[{"table":{"name":"filter","family":"ip","flags":0,"use":0}}]}]}
diff --git a/tests/jsonfiles/02-table.json b/tests/jsonfiles/02-table.json
index 4ff5674..797a00d 100644
--- a/tests/jsonfiles/02-table.json
+++ b/tests/jsonfiles/02-table.json
@@ -1 +1 @@
-{"nftables":[{"table":{"name":"filter2","family":"ip6","flags":0,"use":0}}]}
+{"nftables":[{"add":[{"table":{"name":"filter2","family":"ip6","flags":0,"use":0}}]}]}
diff --git a/tests/jsonfiles/11-chain.json b/tests/jsonfiles/11-chain.json
index 731ed1f..5808819 100644
--- a/tests/jsonfiles/11-chain.json
+++ b/tests/jsonfiles/11-chain.json
@@ -1 +1 @@
-{"nftables":[{"chain":{"name":"input","handle":1,"bytes":1375696,"packets":4136,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}}]}
+{"nftables":[{"add":[{"chain":{"name":"input","handle":1,"bytes":1375696,"packets":4136,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}}]}]}
diff --git a/tests/jsonfiles/12-chain.json b/tests/jsonfiles/12-chain.json
index 2d344eb..c1c823c 100644
--- a/tests/jsonfiles/12-chain.json
+++ b/tests/jsonfiles/12-chain.json
@@ -1 +1 @@
-{"nftables":[{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}}]}
+{"nftables":[{"add":[{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}}]}]}
diff --git a/tests/jsonfiles/13-chain.json b/tests/jsonfiles/13-chain.json
index 5a6ddd1..22940f9 100644
--- a/tests/jsonfiles/13-chain.json
+++ b/tests/jsonfiles/13-chain.json
@@ -1 +1 @@
-{"nftables":[{"chain":{"name":"output","handle":3,"bytes":454786,"packets":2681,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}}]}
+{"nftables":[{"add":[{"chain":{"name":"output","handle":3,"bytes":454786,"packets":2681,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}}]}]}
diff --git a/tests/jsonfiles/14-chain.json b/tests/jsonfiles/14-chain.json
index 6642615..0fb1948 100644
--- a/tests/jsonfiles/14-chain.json
+++ b/tests/jsonfiles/14-chain.json
@@ -1 +1 @@
-{"nftables":[{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0}}]}
+{"nftables":[{"add":[{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0}}]}]}
diff --git a/tests/jsonfiles/20-rule-bitwise.json b/tests/jsonfiles/20-rule-bitwise.json
index af53851..0e2e5c6 100644
--- a/tests/jsonfiles/20-rule-bitwise.json
+++ b/tests/jsonfiles/20-rule-bitwise.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":20,"expr":[{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"reg":{"type":"value","len":4,"data0":"0x0000000a"}},"xor":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":20,"expr":[{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"reg":{"type":"value","len":4,"data0":"0x0000000a"}},"xor":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}}]}}]}]}
diff --git a/tests/jsonfiles/21-rule-byteorder.json b/tests/jsonfiles/21-rule-byteorder.json
index ae6fb32..18a33f2 100644
--- a/tests/jsonfiles/21-rule-byteorder.json
+++ b/tests/jsonfiles/21-rule-byteorder.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":21,"expr":[{"type":"byteorder","sreg":3,"dreg":4,"op":"hton","len":4,"size":4}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":21,"expr":[{"type":"byteorder","sreg":3,"dreg":4,"op":"hton","len":4,"size":4}]}}]}]}
diff --git a/tests/jsonfiles/22-rule-cmp.json b/tests/jsonfiles/22-rule-cmp.json
index 2a6565a..c8f91ec 100644
--- a/tests/jsonfiles/22-rule-cmp.json
+++ b/tests/jsonfiles/22-rule-cmp.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"forward","handle":22,"expr":[{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x6e6f6200","data2":"0x2e303164","data3":"0x00393331"}}}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"forward","handle":22,"expr":[{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x6e6f6200","data2":"0x2e303164","data3":"0x00393331"}}}]}}]}]}
diff --git a/tests/jsonfiles/23-rule-counter.json b/tests/jsonfiles/23-rule-counter.json
index 95d5072..30d7a06 100644
--- a/tests/jsonfiles/23-rule-counter.json
+++ b/tests/jsonfiles/23-rule-counter.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":23,"expr":[{"type":"counter","pkts":135,"bytes":21655}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":23,"expr":[{"type":"counter","pkts":135,"bytes":21655}]}}]}]}
diff --git a/tests/jsonfiles/24-rule-ct.json b/tests/jsonfiles/24-rule-ct.json
index 091d885..71783e8 100644
--- a/tests/jsonfiles/24-rule-ct.json
+++ b/tests/jsonfiles/24-rule-ct.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":24,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000008"}}}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":24,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000008"}}}]}}]}]}
diff --git a/tests/jsonfiles/25-rule-exthdr.json b/tests/jsonfiles/25-rule-exthdr.json
index c40a074..0f6988c 100644
--- a/tests/jsonfiles/25-rule-exthdr.json
+++ b/tests/jsonfiles/25-rule-exthdr.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":25,"expr":[{"type":"exthdr","dreg":1,"exthdr_type":"mh","offset":2,"len":16}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":25,"expr":[{"type":"exthdr","dreg":1,"exthdr_type":"mh","offset":2,"len":16}]}}]}]}
diff --git a/tests/jsonfiles/26-rule-immediate.json b/tests/jsonfiles/26-rule-immediate.json
index 767052e..89cd360 100644
--- a/tests/jsonfiles/26-rule-immediate.json
+++ b/tests/jsonfiles/26-rule-immediate.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}]}
diff --git a/tests/jsonfiles/27-rule-limit.json b/tests/jsonfiles/27-rule-limit.json
index c268357..fdd5358 100644
--- a/tests/jsonfiles/27-rule-limit.json
+++ b/tests/jsonfiles/27-rule-limit.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":27,"expr":[{"type":"limit","rate":321321,"unit":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":27,"expr":[{"type":"limit","rate":321321,"unit":0}]}}]}]}
diff --git a/tests/jsonfiles/28-rule-log.json b/tests/jsonfiles/28-rule-log.json
index 1e739f1..320bf29 100644
--- a/tests/jsonfiles/28-rule-log.json
+++ b/tests/jsonfiles/28-rule-log.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":28,"expr":[{"type":"log","prefix":"test_chain","group":1,"snaplen":0,"qthreshold":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":28,"expr":[{"type":"log","prefix":"test_chain","group":1,"snaplen":0,"qthreshold":0}]}}]}]}
diff --git a/tests/jsonfiles/29-rule-match.json b/tests/jsonfiles/29-rule-match.json
index b533e77..577c63a 100644
--- a/tests/jsonfiles/29-rule-match.json
+++ b/tests/jsonfiles/29-rule-match.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":9,"expr":[{"type":"match","name":"state"},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":9,"expr":[{"type":"match","name":"state"},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/30-rule-lookup.json b/tests/jsonfiles/30-rule-lookup.json
index 05576b0..3eed063 100644
--- a/tests/jsonfiles/30-rule-lookup.json
+++ b/tests/jsonfiles/30-rule-lookup.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":8,"expr":[{"type":"payload","dreg":1,"offset":12,"len":4,"base":"network"},{"type":"lookup","set":"set0","sreg":1,"dreg":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":8,"expr":[{"type":"payload","dreg":1,"offset":12,"len":4,"base":"network"},{"type":"lookup","set":"set0","sreg":1,"dreg":0}]}}]}]}
diff --git a/tests/jsonfiles/31-rule-meta.json b/tests/jsonfiles/31-rule-meta.json
index d39a6ed..2c2d681 100644
--- a/tests/jsonfiles/31-rule-meta.json
+++ b/tests/jsonfiles/31-rule-meta.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":8,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":8,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/32-rule-nat4.json b/tests/jsonfiles/32-rule-nat4.json
index aa2b50d..4ac8c87 100644
--- a/tests/jsonfiles/32-rule-nat4.json
+++ b/tests/jsonfiles/32-rule-nat4.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":10,"expr":[{"type":"nat","nat_type":"dnat","family":"ip","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":10,"expr":[{"type":"nat","nat_type":"dnat","family":"ip","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}]}]}
diff --git a/tests/jsonfiles/33-rule-nat6.json b/tests/jsonfiles/33-rule-nat6.json
index a76eb71..3e4b2e5 100644
--- a/tests/jsonfiles/33-rule-nat6.json
+++ b/tests/jsonfiles/33-rule-nat6.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip6","table":"nat","chain":"output","handle":33,"expr":[{"type":"nat","nat_type":"snat","family":"ip6","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4,"flags":12}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip6","table":"nat","chain":"output","handle":33,"expr":[{"type":"nat","nat_type":"snat","family":"ip6","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4,"flags":12}]}}]}]}
diff --git a/tests/jsonfiles/34-rule-payload.json b/tests/jsonfiles/34-rule-payload.json
index eec5dc9..127eb0c 100644
--- a/tests/jsonfiles/34-rule-payload.json
+++ b/tests/jsonfiles/34-rule-payload.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}]}
diff --git a/tests/jsonfiles/35-rule-target.json b/tests/jsonfiles/35-rule-target.json
index da02921..4ac72a8 100644
--- a/tests/jsonfiles/35-rule-target.json
+++ b/tests/jsonfiles/35-rule-target.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"INPUT","handle":20,"expr":[{"type":"counter","pkts":17,"bytes":4436},{"type":"target","name":"LOG"}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"INPUT","handle":20,"expr":[{"type":"counter","pkts":17,"bytes":4436},{"type":"target","name":"LOG"}]}}]}]}
diff --git a/tests/jsonfiles/36-rule-real.json b/tests/jsonfiles/36-rule-real.json
index 56d6794..65a0d62 100644
--- a/tests/jsonfiles/36-rule-real.json
+++ b/tests/jsonfiles/36-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":36,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":36,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/37-rule-real.json b/tests/jsonfiles/37-rule-real.json
index 6eb8c7d..cfd1c13 100644
--- a/tests/jsonfiles/37-rule-real.json
+++ b/tests/jsonfiles/37-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":37,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":37,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}]}]}
diff --git a/tests/jsonfiles/38-rule-real.json b/tests/jsonfiles/38-rule-real.json
index e0da26f..71123aa 100644
--- a/tests/jsonfiles/38-rule-real.json
+++ b/tests/jsonfiles/38-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":38,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":38,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}]}]}
diff --git a/tests/jsonfiles/39-rule-real.json b/tests/jsonfiles/39-rule-real.json
index b80bf42..7b05158 100644
--- a/tests/jsonfiles/39-rule-real.json
+++ b/tests/jsonfiles/39-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":39,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"gte","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"cmp","sreg":1,"op":"lte","data":{"reg":{"type":"value","len":4,"data0":"0xfa00a8c0"}}}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":39,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"gte","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"cmp","sreg":1,"op":"lte","data":{"reg":{"type":"value","len":4,"data0":"0xfa00a8c0"}}}]}}]}]}
diff --git a/tests/jsonfiles/40-rule-real.json b/tests/jsonfiles/40-rule-real.json
index 38a8497..8b1259b 100644
--- a/tests/jsonfiles/40-rule-real.json
+++ b/tests/jsonfiles/40-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":40,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":40,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/41-rule-real.json b/tests/jsonfiles/41-rule-real.json
index 58bc9c0..675a95c 100644
--- a/tests/jsonfiles/41-rule-real.json
+++ b/tests/jsonfiles/41-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}}]}]}
diff --git a/tests/jsonfiles/42-rule-real.json b/tests/jsonfiles/42-rule-real.json
index 025d351..b3d28d4 100644
--- a/tests/jsonfiles/42-rule-real.json
+++ b/tests/jsonfiles/42-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":42,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":42,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]}}]}]}
diff --git a/tests/jsonfiles/43-rule-real.json b/tests/jsonfiles/43-rule-real.json
index ff4fedb..e0da9a8 100644
--- a/tests/jsonfiles/43-rule-real.json
+++ b/tests/jsonfiles/43-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":43,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":43,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/44-rule-real.json b/tests/jsonfiles/44-rule-real.json
index 14c6e34..50dd524 100644
--- a/tests/jsonfiles/44-rule-real.json
+++ b/tests/jsonfiles/44-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":44,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x16000004"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":44,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x16000004"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/45-rule-real.json b/tests/jsonfiles/45-rule-real.json
index 81841a7..be08598 100644
--- a/tests/jsonfiles/45-rule-real.json
+++ b/tests/jsonfiles/45-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":45,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":45,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/46-rule-real.json b/tests/jsonfiles/46-rule-real.json
index 3cfb290..5ea3ca9 100644
--- a/tests/jsonfiles/46-rule-real.json
+++ b/tests/jsonfiles/46-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":46,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":46,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}]}]}
diff --git a/tests/jsonfiles/47-rule-real.json b/tests/jsonfiles/47-rule-real.json
index e4160dd..6e9d084 100644
--- a/tests/jsonfiles/47-rule-real.json
+++ b/tests/jsonfiles/47-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":47,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":47,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}]}]}
diff --git a/tests/jsonfiles/48-rule-real.json b/tests/jsonfiles/48-rule-real.json
index 95e2b38..6387e94 100644
--- a/tests/jsonfiles/48-rule-real.json
+++ b/tests/jsonfiles/48-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":48,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":48,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/49-rule-real.json b/tests/jsonfiles/49-rule-real.json
index da0c0c5..e1c84d2 100644
--- a/tests/jsonfiles/49-rule-real.json
+++ b/tests/jsonfiles/49-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":49,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":49,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}]}
diff --git a/tests/jsonfiles/50-rule-real.json b/tests/jsonfiles/50-rule-real.json
index 4dbc553..21de049 100644
--- a/tests/jsonfiles/50-rule-real.json
+++ b/tests/jsonfiles/50-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":50,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":50,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/51-rule-real.json b/tests/jsonfiles/51-rule-real.json
index 7d510ab..46afd76 100644
--- a/tests/jsonfiles/51-rule-real.json
+++ b/tests/jsonfiles/51-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":51,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":51,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/52-rule-real.json b/tests/jsonfiles/52-rule-real.json
index 2809478..e64fe80 100644
--- a/tests/jsonfiles/52-rule-real.json
+++ b/tests/jsonfiles/52-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":52,"expr":[{"type":"meta","dreg":1,"key":"oif"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":52,"expr":[{"type":"meta","dreg":1,"key":"oif"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/53-rule-real.json b/tests/jsonfiles/53-rule-real.json
index 329945c..910a467 100644
--- a/tests/jsonfiles/53-rule-real.json
+++ b/tests/jsonfiles/53-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":53,"expr":[{"type":"meta","dreg":1,"key":"oifname"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":53,"expr":[{"type":"meta","dreg":1,"key":"oifname"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/54-rule-real.json b/tests/jsonfiles/54-rule-real.json
index b9b2383..f271d83 100644
--- a/tests/jsonfiles/54-rule-real.json
+++ b/tests/jsonfiles/54-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":54,"expr":[{"type":"meta","dreg":1,"key":"skuid"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":54,"expr":[{"type":"meta","dreg":1,"key":"skuid"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/55-rule-real.json b/tests/jsonfiles/55-rule-real.json
index e79552d..f36ebe5 100644
--- a/tests/jsonfiles/55-rule-real.json
+++ b/tests/jsonfiles/55-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":55,"expr":[{"type":"meta","dreg":1,"key":"skgid"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":55,"expr":[{"type":"meta","dreg":1,"key":"skgid"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/56-rule-real.json b/tests/jsonfiles/56-rule-real.json
index a2c4b9c..408b653 100644
--- a/tests/jsonfiles/56-rule-real.json
+++ b/tests/jsonfiles/56-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":56,"expr":[{"type":"meta","dreg":1,"key":"secmark"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":56,"expr":[{"type":"meta","dreg":1,"key":"secmark"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}]}
diff --git a/tests/jsonfiles/57-rule-real.json b/tests/jsonfiles/57-rule-real.json
index b233f59..fc8a67a 100644
--- a/tests/jsonfiles/57-rule-real.json
+++ b/tests/jsonfiles/57-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":57,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":57,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/58-rule-real.json b/tests/jsonfiles/58-rule-real.json
index f98efd3..abb90d5 100644
--- a/tests/jsonfiles/58-rule-real.json
+++ b/tests/jsonfiles/58-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":58,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00000008"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":58,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00000008"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}]}
diff --git a/tests/jsonfiles/59-rule-real.json b/tests/jsonfiles/59-rule-real.json
index 0f92ade..ffe2288 100644
--- a/tests/jsonfiles/59-rule-real.json
+++ b/tests/jsonfiles/59-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":59,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":59,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}]}
diff --git a/tests/jsonfiles/60-rule-real.json b/tests/jsonfiles/60-rule-real.json
index 0a98726..9ec79cf 100644
--- a/tests/jsonfiles/60-rule-real.json
+++ b/tests/jsonfiles/60-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":60,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":60,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/61-rule-real.json b/tests/jsonfiles/61-rule-real.json
index 8b57338..fd35d2c 100644
--- a/tests/jsonfiles/61-rule-real.json
+++ b/tests/jsonfiles/61-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":61,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":61,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/62-set.json b/tests/jsonfiles/62-set.json
index 58db88b..616eabe 100644
--- a/tests/jsonfiles/62-set.json
+++ b/tests/jsonfiles/62-set.json
@@ -1 +1 @@
-{"nftables":[{"set":{"name":"set0","table":"filter","flags":3,"family":"ip","key_type":12,"key_len":2,"set_elem":[{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001700"}}},{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}}]}}]}
+{"nftables":[{"add":[{"set":{"name":"set0","table":"filter","flags":3,"family":"ip","key_type":12,"key_len":2,"set_elem":[{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001700"}}},{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}}]}}]}]}
diff --git a/tests/jsonfiles/63-set.json b/tests/jsonfiles/63-set.json
index d63c1cf..02aa5fb 100644
--- a/tests/jsonfiles/63-set.json
+++ b/tests/jsonfiles/63-set.json
@@ -1 +1 @@
-{"nftables":[{"set":{"name":"map0","table":"f","flags":11,"family":"ip","key_type":12,"key_len":2,"data_type":4294967040,"data_len":16,"set_elem":[{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001700"}},"data":{"reg":{"type":"verdict","verdict":"goto","chain":"o"}}},{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001600"}},"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}
+{"nftables":[{"add":[{"set":{"name":"map0","table":"f","flags":11,"family":"ip","key_type":12,"key_len":2,"data_type":4294967040,"data_len":16,"set_elem":[{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001700"}},"data":{"reg":{"type":"verdict","verdict":"goto","chain":"o"}}},{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001600"}},"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}]}
diff --git a/tests/jsonfiles/64-ruleset.json b/tests/jsonfiles/64-ruleset.json
index 9b6e611..54e27c0 100644
--- a/tests/jsonfiles/64-ruleset.json
+++ b/tests/jsonfiles/64-ruleset.json
@@ -1 +1 @@
-{"nftables":[{"table":{"name":"filter","family":"ip","flags":0,"use":0}},{"table":{"name":"filter2","family":"ip6","flags":0,"use":0}},{"chain":{"name":"input","handle":1,"bytes":10681449,"packets":16216,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"bytes":2375830,"packets":15184,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0}},{"set":{"name":"set0","table":"filter","flags":3,"family"
 :"ip","key_type":12,"key_len":2}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":6,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":9,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pk
 ts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":10,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":11,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}}]}
+{"nftables":[{"add":[{"table":{"name":"filter","family":"ip","flags":0,"use":0}},{"table":{"name":"filter2","family":"ip6","flags":0,"use":0}},{"chain":{"name":"input","handle":1,"bytes":10681449,"packets":16216,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"bytes":2375830,"packets":15184,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0}},{"set":{"name":"set0","table":"filter","flags":3,
 "family":"ip","key_type":12,"key_len":2}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":6,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":9,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"coun
 ter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":10,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":11,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}}]}]}
diff --git a/tests/jsonfiles/65-rule-meta-target.json b/tests/jsonfiles/65-rule-meta-target.json
index e6180d6..ab4e40c 100644
--- a/tests/jsonfiles/65-rule-meta-target.json
+++ b/tests/jsonfiles/65-rule-meta-target.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":1,"expr":[{"type":"meta","key":"mark","sreg":1},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":1,"expr":[{"type":"meta","key":"mark","sreg":1},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/jsonfiles/66-rule-queue.json b/tests/jsonfiles/66-rule-queue.json
index 016110e..69a2eee 100644
--- a/tests/jsonfiles/66-rule-queue.json
+++ b/tests/jsonfiles/66-rule-queue.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":43,"expr":[{"type":"queue","num":4,"total":2,"flags":0}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":43,"expr":[{"type":"queue","num":4,"total":2,"flags":0}]}}]}]}
diff --git a/tests/jsonfiles/67-rule-queue.json b/tests/jsonfiles/67-rule-queue.json
index 0fefd68..0471a98 100644
--- a/tests/jsonfiles/67-rule-queue.json
+++ b/tests/jsonfiles/67-rule-queue.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":44,"position":43,"expr":[{"type":"queue","num":4,"total":2,"flags":3}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":44,"position":43,"expr":[{"type":"queue","num":4,"total":2,"flags":3}]}}]}]}
diff --git a/tests/jsonfiles/68-rule-masq.json b/tests/jsonfiles/68-rule-masq.json
index 758f5ca..e8f2a58 100644
--- a/tests/jsonfiles/68-rule-masq.json
+++ b/tests/jsonfiles/68-rule-masq.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip6","table":"nat","chain":"postrouting","handle":4,"expr":[{"type":"masq","flags":12}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip6","table":"nat","chain":"postrouting","handle":4,"expr":[{"type":"masq","flags":12}]}}]}]}
diff --git a/tests/jsonfiles/69-rule-redir.json b/tests/jsonfiles/69-rule-redir.json
index 043fff2..d0318f0 100644
--- a/tests/jsonfiles/69-rule-redir.json
+++ b/tests/jsonfiles/69-rule-redir.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip6","table":"nat","chain":"prerouting","handle":4,"expr":[{"type":"redir"}]}}]}
+{"nftables":[{"add":[{"rule":{"family":"ip6","table":"nat","chain":"prerouting","handle":4,"expr":[{"type":"redir"}]}}]}]}
diff --git a/tests/jsonfiles/70-rule-real.json b/tests/jsonfiles/70-rule-real.json
new file mode 100644
index 0000000..b38947f
--- /dev/null
+++ b/tests/jsonfiles/70-rule-real.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":2,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 57a5730..76e89ac 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -68,11 +68,11 @@ static int compare_test(uint32_t type, struct nft_ruleset *rs,
 	switch (type) {
 	case TEST_XML_RULESET:
 		nft_ruleset_snprintf(out, sizeof(out), rs,
-				     NFT_OUTPUT_XML, 0);
+				     NFT_OUTPUT_XML, NFT_OF_EVENT_NEW);
 		break;
 	case TEST_JSON_RULESET:
 		nft_ruleset_snprintf(out, sizeof(out), rs,
-				     NFT_OUTPUT_JSON, 0);
+				     NFT_OUTPUT_JSON, NFT_OF_EVENT_NEW);
 		break;
 	default:
 		errno = EINVAL;
diff --git a/tests/xmlfiles/01-table.xml b/tests/xmlfiles/01-table.xml
index 655b544..c83c4e2 100644
--- a/tests/xmlfiles/01-table.xml
+++ b/tests/xmlfiles/01-table.xml
@@ -1 +1 @@
-<nftables><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table></nftables>
+<nftables><add><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table></add></nftables>
diff --git a/tests/xmlfiles/02-table.xml b/tests/xmlfiles/02-table.xml
index 5de924f..99dc6df 100644
--- a/tests/xmlfiles/02-table.xml
+++ b/tests/xmlfiles/02-table.xml
@@ -1 +1 @@
-<nftables><table><name>nat</name><family>ip6</family><flags>0</flags><use>0</use></table></nftables>
+<nftables><add><table><name>nat</name><family>ip6</family><flags>0</flags><use>0</use></table></add></nftables>
diff --git a/tests/xmlfiles/10-chain.xml b/tests/xmlfiles/10-chain.xml
index 6ac54ab..8ae807b 100644
--- a/tests/xmlfiles/10-chain.xml
+++ b/tests/xmlfiles/10-chain.xml
@@ -1 +1 @@
-<nftables><chain><name>test</name><handle>0</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family><type>filter</type><hooknum>input</hooknum><prio>0</prio><policy>accept</policy></chain></nftables>
+<nftables><add><chain><name>test</name><handle>0</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family><type>filter</type><hooknum>input</hooknum><prio>0</prio><policy>accept</policy></chain></add></nftables>
diff --git a/tests/xmlfiles/11-chain.xml b/tests/xmlfiles/11-chain.xml
index 34d99dd..d48fa40 100644
--- a/tests/xmlfiles/11-chain.xml
+++ b/tests/xmlfiles/11-chain.xml
@@ -1 +1 @@
-<nftables><chain><name>test</name><handle>0</handle><bytes>59</bytes><packets>1</packets><table>filter</table><family>ip6</family><type>filter</type><hooknum>forward</hooknum><prio>0</prio><policy>drop</policy></chain></nftables>
+<nftables><add><chain><name>test</name><handle>0</handle><bytes>59</bytes><packets>1</packets><table>filter</table><family>ip6</family><type>filter</type><hooknum>forward</hooknum><prio>0</prio><policy>drop</policy></chain></add></nftables>
diff --git a/tests/xmlfiles/12-chain.xml b/tests/xmlfiles/12-chain.xml
index f53f252..448feb2 100644
--- a/tests/xmlfiles/12-chain.xml
+++ b/tests/xmlfiles/12-chain.xml
@@ -1 +1 @@
-<nftables><chain><name>foo</name><handle>100</handle><bytes>59264154979</bytes><packets>2548796325</packets><table>nat</table><family>ip</family><type>nat</type><hooknum>postrouting</hooknum><prio>0</prio><policy>accept</policy></chain></nftables>
+<nftables><add><chain><name>foo</name><handle>100</handle><bytes>59264154979</bytes><packets>2548796325</packets><table>nat</table><family>ip</family><type>nat</type><hooknum>postrouting</hooknum><prio>0</prio><policy>accept</policy></chain></add></nftables>
diff --git a/tests/xmlfiles/20-rule-bitwise.xml b/tests/xmlfiles/20-rule-bitwise.xml
index 9b38437..69ff702 100644
--- a/tests/xmlfiles/20-rule-bitwise.xml
+++ b/tests/xmlfiles/20-rule-bitwise.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg></mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg></mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/21-rule-byteorder.xml b/tests/xmlfiles/21-rule-byteorder.xml
index fce4ed1..2c30ad7 100644
--- a/tests/xmlfiles/21-rule-byteorder.xml
+++ b/tests/xmlfiles/21-rule-byteorder.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>test</table><chain>test</chain><handle>1000</handle><expr type="byteorder"><sreg>3</sreg><dreg>4</dreg><op>hton</op><len>4</len><size>4</size></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>test</table><chain>test</chain><handle>1000</handle><expr type="byteorder"><sreg>3</sreg><dreg>4</dreg><op>hton</op><len>4</len><size>4</size></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/22-rule-cmp.xml b/tests/xmlfiles/22-rule-cmp.xml
index 4e66993..103b7da 100644
--- a/tests/xmlfiles/22-rule-cmp.xml
+++ b/tests/xmlfiles/22-rule-cmp.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></reg></data></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/23-rule-counter.xml b/tests/xmlfiles/23-rule-counter.xml
index 6299e84..c6708c6 100644
--- a/tests/xmlfiles/23-rule-counter.xml
+++ b/tests/xmlfiles/23-rule-counter.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>39</handle><expr type="counter"><pkts>3</pkts><bytes>177</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>39</handle><expr type="counter"><pkts>3</pkts><bytes>177</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/24-rule-ct.xml b/tests/xmlfiles/24-rule-ct.xml
index 1939e43..832ae2f 100644
--- a/tests/xmlfiles/24-rule-ct.xml
+++ b/tests/xmlfiles/24-rule-ct.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/25-rule-exthdr.xml b/tests/xmlfiles/25-rule-exthdr.xml
index 9e10a88..483d269 100644
--- a/tests/xmlfiles/25-rule-exthdr.xml
+++ b/tests/xmlfiles/25-rule-exthdr.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="exthdr"><dreg>1</dreg><exthdr_type>mh</exthdr_type><offset>2</offset><len>16</len></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="exthdr"><dreg>1</dreg><exthdr_type>mh</exthdr_type><offset>2</offset><len>16</len></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/26-rule-immediate.xml b/tests/xmlfiles/26-rule-immediate.xml
index 3eed652..fa5b3e7 100644
--- a/tests/xmlfiles/26-rule-immediate.xml
+++ b/tests/xmlfiles/26-rule-immediate.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>accept</verdict></reg></data></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>accept</verdict></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/27-rule-limit.xml b/tests/xmlfiles/27-rule-limit.xml
index a4398e8..e186204 100644
--- a/tests/xmlfiles/27-rule-limit.xml
+++ b/tests/xmlfiles/27-rule-limit.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="limit"><rate>123123</rate><unit>321321</unit></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="limit"><rate>123123</rate><unit>321321</unit></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/28-rule-log.xml b/tests/xmlfiles/28-rule-log.xml
index c3e3b11..9a11bbb 100644
--- a/tests/xmlfiles/28-rule-log.xml
+++ b/tests/xmlfiles/28-rule-log.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>96</handle><expr type="log"><prefix>test_chain</prefix><group>1</group></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>96</handle><expr type="log"><prefix>test_chain</prefix><group>1</group></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/29-rule-lookup.xml b/tests/xmlfiles/29-rule-lookup.xml
index 052b008..2074908 100644
--- a/tests/xmlfiles/29-rule-lookup.xml
+++ b/tests/xmlfiles/29-rule-lookup.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>37</handle><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>37</handle><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/30-rule-match.xml b/tests/xmlfiles/30-rule-match.xml
index 4cfe33b..094f913 100644
--- a/tests/xmlfiles/30-rule-match.xml
+++ b/tests/xmlfiles/30-rule-match.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="match"><name>state</name></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="match"><name>state</name></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/31-rule-meta.xml b/tests/xmlfiles/31-rule-meta.xml
index a1c9e8c..1b9e1fa 100644
--- a/tests/xmlfiles/31-rule-meta.xml
+++ b/tests/xmlfiles/31-rule-meta.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/32-rule-nat6.xml b/tests/xmlfiles/32-rule-nat6.xml
index 8fc52e8..5a71148 100644
--- a/tests/xmlfiles/32-rule-nat6.xml
+++ b/tests/xmlfiles/32-rule-nat6.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>nat</table><chain>OUTPUT</chain><handle>100</handle><expr type="nat"><nat_type>snat</nat_type><family>ip6</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>nat</table><chain>OUTPUT</chain><handle>100</handle><expr type="nat"><nat_type>snat</nat_type><family>ip6</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/33-rule-nat4.xml b/tests/xmlfiles/33-rule-nat4.xml
index b7b6cb6..c55618b 100644
--- a/tests/xmlfiles/33-rule-nat4.xml
+++ b/tests/xmlfiles/33-rule-nat4.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="nat"><nat_type>dnat</nat_type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max><flags>12</flags></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="nat"><nat_type>dnat</nat_type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max><flags>12</flags></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/34-rule-payload.xml b/tests/xmlfiles/34-rule-payload.xml
index a6faca9..34084d0 100644
--- a/tests/xmlfiles/34-rule-payload.xml
+++ b/tests/xmlfiles/34-rule-payload.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/35-rule-target.xml b/tests/xmlfiles/35-rule-target.xml
index 5b46350..8bcfeb0 100644
--- a/tests/xmlfiles/35-rule-target.xml
+++ b/tests/xmlfiles/35-rule-target.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="target"><name>LOG</name></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="target"><name>LOG</name></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/36-rule-real.xml b/tests/xmlfiles/36-rule-real.xml
index 6ebc8ea..54db02b 100644
--- a/tests/xmlfiles/36-rule-real.xml
+++ b/tests/xmlfiles/36-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/37-rule-real.xml b/tests/xmlfiles/37-rule-real.xml
index 8506f19..97882b9 100644
--- a/tests/xmlfiles/37-rule-real.xml
+++ b/tests/xmlfiles/37-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00001600</data0></reg></data></expr><expr type="ct">
 <dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg></mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00001600</data0></reg></data></expr><expr type=
 "ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg></mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/38-rule-real.xml b/tests/xmlfiles/38-rule-real.xml
index 51b1130..49ab7b5 100644
--- a/tests/xmlfiles/38-rule-real.xml
+++ b/tests/xmlfiles/38-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x0000bb01</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><reg typ
 e="verdict"><verdict>accept</verdict></reg></data></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x0000bb01</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><re
 g type="verdict"><verdict>accept</verdict></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/39-rule-real.xml b/tests/xmlfiles/39-rule-real.xml
index 35b6004..fa63b28 100644
--- a/tests/xmlfiles/39-rule-real.xml
+++ b/tests/xmlfiles/39-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></reg></data></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0xc09a002a</d
 ata0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000011</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00003500</data0></reg></data></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="
 log"><prefix>dns_drop</prefix><group>2</group></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>drop</verdict></reg></data></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></reg></data></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0xc09a00
 2a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000011</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00003500</data0></reg></data></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr t
 ype="log"><prefix>dns_drop</prefix><group>2</group></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>drop</verdict></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/40-rule-real.xml b/tests/xmlfiles/40-rule-real.xml
index d516164..55f195b 100644
--- a/tests/xmlfiles/40-rule-real.xml
+++ b/tests/xmlfiles/40-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/41-rule-real.xml b/tests/xmlfiles/41-rule-real.xml
index 3736404..87dc713 100644
--- a/tests/xmlfiles/41-rule-real.xml
+++ b/tests/xmlfiles/41-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><data><reg type="value"><len>4</len><data0>0xfa00a8c0</data0></reg></data></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><data><reg type="value"><len>4</len><data0>0xfa00a8c0</data0></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/42-rule-real.xml b/tests/xmlfiles/42-rule-real.xml
index e88d695..7f66ab8 100644
--- a/tests/xmlfiles/42-rule-real.xml
+++ b/tests/xmlfiles/42-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/43-rule-real.xml b/tests/xmlfiles/43-rule-real.xml
index 4f6219f..fd9ac33 100644
--- a/tests/xmlfiles/43-rule-real.xml
+++ b/tests/xmlfiles/43-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>drop</verdict></reg></data></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>drop</verdict></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/44-rule-real.xml b/tests/xmlfiles/44-rule-real.xml
index 4f12c01..ce026d0 100644
--- a/tests/xmlfiles/44-rule-real.xml
+++ b/tests/xmlfiles/44-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/45-rule-real.xml b/tests/xmlfiles/45-rule-real.xml
index fd2fda2..0448be6 100644
--- a/tests/xmlfiles/45-rule-real.xml
+++ b/tests/xmlfiles/45-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00001600</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00001600</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/46-rule-real.xml b/tests/xmlfiles/46-rule-real.xml
index 58ebedc..973df55 100644
--- a/tests/xmlfiles/46-rule-real.xml
+++ b/tests/xmlfiles/46-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x16000004</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x16000004</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/47-rule-real.xml b/tests/xmlfiles/47-rule-real.xml
index 44f2a68..0d35fd9 100644
--- a/tests/xmlfiles/47-rule-real.xml
+++ b/tests/xmlfiles/47-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/48-rule-real.xml b/tests/xmlfiles/48-rule-real.xml
index 7f8562f..ebcd219 100644
--- a/tests/xmlfiles/48-rule-real.xml
+++ b/tests/xmlfiles/48-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></reg></data></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/49-rule-real.xml b/tests/xmlfiles/49-rule-real.xml
index ce73edc..5fdf0d8 100644
--- a/tests/xmlfiles/49-rule-real.xml
+++ b/tests/xmlfiles/49-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></reg></data></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/50-rule-real.xml b/tests/xmlfiles/50-rule-real.xml
index 0df5270..0ac1ac0 100644
--- a/tests/xmlfiles/50-rule-real.xml
+++ b/tests/xmlfiles/50-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg></mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg></mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/51-rule-real.xml b/tests/xmlfiles/51-rule-real.xml
index f00ee71..3976636 100644
--- a/tests/xmlfiles/51-rule-real.xml
+++ b/tests/xmlfiles/51-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/52-rule-real.xml b/tests/xmlfiles/52-rule-real.xml
index 0205214..889415a 100644
--- a/tests/xmlfiles/52-rule-real.xml
+++ b/tests/xmlfiles/52-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/53-rule-real.xml b/tests/xmlfiles/53-rule-real.xml
index cfdac8f..a484270 100644
--- a/tests/xmlfiles/53-rule-real.xml
+++ b/tests/xmlfiles/53-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/54-rule-real.xml b/tests/xmlfiles/54-rule-real.xml
index 7451d5f..6859ac2 100644
--- a/tests/xmlfiles/54-rule-real.xml
+++ b/tests/xmlfiles/54-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000064</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000064</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/55-rule-real.xml b/tests/xmlfiles/55-rule-real.xml
index c35eef0..8ee83e4 100644
--- a/tests/xmlfiles/55-rule-real.xml
+++ b/tests/xmlfiles/55-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/56-rule-real.xml b/tests/xmlfiles/56-rule-real.xml
index 3f30f5e..be0b868 100644
--- a/tests/xmlfiles/56-rule-real.xml
+++ b/tests/xmlfiles/56-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0000001e</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0000001e</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/57-rule-real.xml b/tests/xmlfiles/57-rule-real.xml
index 1c5f4c0..7a1d68f 100644
--- a/tests/xmlfiles/57-rule-real.xml
+++ b/tests/xmlfiles/57-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00707466</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00707466</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/58-rule-real.xml b/tests/xmlfiles/58-rule-real.xml
index 14787f6..d32ed8f 100644
--- a/tests/xmlfiles/58-rule-real.xml
+++ b/tests/xmlfiles/58-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/59-rule-real.xml b/tests/xmlfiles/59-rule-real.xml
index 92ad83f..dc86dfb 100644
--- a/tests/xmlfiles/59-rule-real.xml
+++ b/tests/xmlfiles/59-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00000008</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00000008</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/60-rule-real.xml b/tests/xmlfiles/60-rule-real.xml
index 70234a6..e5938e3 100644
--- a/tests/xmlfiles/60-rule-real.xml
+++ b/tests/xmlfiles/60-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/61-rule-real.xml b/tests/xmlfiles/61-rule-real.xml
index 786e84a..0c097b9 100644
--- a/tests/xmlfiles/61-rule-real.xml
+++ b/tests/xmlfiles/61-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/62-rule-real.xml b/tests/xmlfiles/62-rule-real.xml
index 86d3499..387a4f1 100644
--- a/tests/xmlfiles/62-rule-real.xml
+++ b/tests/xmlfiles/62-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/63-rule-real.xml b/tests/xmlfiles/63-rule-real.xml
index af0b87d..1f6aa92 100644
--- a/tests/xmlfiles/63-rule-real.xml
+++ b/tests/xmlfiles/63-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/64-rule-real.xml b/tests/xmlfiles/64-rule-real.xml
index f14c95c..68f9d8a 100644
--- a/tests/xmlfiles/64-rule-real.xml
+++ b/tests/xmlfiles/64-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/65-rule-real.xml b/tests/xmlfiles/65-rule-real.xml
index b3d37b1..6eeb3d0 100644
--- a/tests/xmlfiles/65-rule-real.xml
+++ b/tests/xmlfiles/65-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/66-rule-real.xml b/tests/xmlfiles/66-rule-real.xml
index 95ea4cd..1294a85 100644
--- a/tests/xmlfiles/66-rule-real.xml
+++ b/tests/xmlfiles/66-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/67-rule-real.xml b/tests/xmlfiles/67-rule-real.xml
index 197be85..162d084 100644
--- a/tests/xmlfiles/67-rule-real.xml
+++ b/tests/xmlfiles/67-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/68-rule-real.xml b/tests/xmlfiles/68-rule-real.xml
index a09698d..08371f9 100644
--- a/tests/xmlfiles/68-rule-real.xml
+++ b/tests/xmlfiles/68-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/69-rule-real.xml b/tests/xmlfiles/69-rule-real.xml
index e39e2cb..62119cd 100644
--- a/tests/xmlfiles/69-rule-real.xml
+++ b/tests/xmlfiles/69-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>33</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>33</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/70-rule-real.xml b/tests/xmlfiles/70-rule-real.xml
index d35a252..436c517 100644
--- a/tests/xmlfiles/70-rule-real.xml
+++ b/tests/xmlfiles/70-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/71-rule-real.xml b/tests/xmlfiles/71-rule-real.xml
index c838a60..bb50afd 100644
--- a/tests/xmlfiles/71-rule-real.xml
+++ b/tests/xmlfiles/71-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/72-rule-real.xml b/tests/xmlfiles/72-rule-real.xml
index aac8b85..85ce226 100644
--- a/tests/xmlfiles/72-rule-real.xml
+++ b/tests/xmlfiles/72-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>36</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>map2</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>36</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>map2</set><sreg>1</sreg><dreg>0</dreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/73-set.xml b/tests/xmlfiles/73-set.xml
index 856e1f9..17b5995 100644
--- a/tests/xmlfiles/73-set.xml
+++ b/tests/xmlfiles/73-set.xml
@@ -1 +1 @@
-<nftables><set><family>ip</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>4</len><data0>0x0300a8c0</data0></reg></key></set_elem><set_elem><key><reg type="value"><len>4</len><data0>0x0200a8c0</data0></reg></key></set_elem><set_elem><key><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></key></set_elem></set></nftables>
+<nftables><add><set><family>ip</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>4</len><data0>0x0300a8c0</data0></reg></key></set_elem><set_elem><key><reg type="value"><len>4</len><data0>0x0200a8c0</data0></reg></key></set_elem><set_elem><key><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></key></set_elem></set></add></nftables>
diff --git a/tests/xmlfiles/74-set.xml b/tests/xmlfiles/74-set.xml
index c5be4e5..bf39c46 100644
--- a/tests/xmlfiles/74-set.xml
+++ b/tests/xmlfiles/74-set.xml
@@ -1 +1 @@
-<nftables><set><family>ip6</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></reg></key></set_elem><set_elem><key><reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></reg></key></set_elem></set></nftables>
+<nftables><add><set><family>ip6</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></reg></key></set_elem><set_elem><key><reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></reg></key></set_elem></set></add></nftables>
diff --git a/tests/xmlfiles/75-ruleset.xml b/tests/xmlfiles/75-ruleset.xml
index 363a567..9c63686 100644
--- a/tests/xmlfiles/75-ruleset.xml
+++ b/tests/xmlfiles/75-ruleset.xml
@@ -1 +1 @@
-<nftables><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table><table><name>filter</name><family>ip6</family><flags>0</flags><use>0</use></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>2</len><data0>0x00004300</data0></r
 eg></key></set_elem><set_elem><key><reg type="value"><len>2</len><data0>0x00003500</data0></reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>map0</name><flags>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><key><reg type="value"><len>2</len><data0>0x00005000</data0></reg></key><data><reg type="verdict"><verdict>drop</verdict></reg></data></set_elem><set_elem><key><reg type="value"><len>2</len><data0>0x00001600</data0></reg></key><data><reg type="verdict"><verdict>accept</verdict></reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input</chain><handle>8</handle><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><dat
 a><reg type="verdict"><verdict>accept</verdict></reg></data></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</
 len><data0>0x00000011</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>accept</verdict></reg></data></expr></rule></nftables>
+<nftables><add><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table><table><name>filter</name><family>ip6</family><flags>0</flags><use>0</use></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>2</len><data0>0x00004300</data
 0></reg></key></set_elem><set_elem><key><reg type="value"><len>2</len><data0>0x00003500</data0></reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>map0</name><flags>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><key><reg type="value"><len>2</len><data0>0x00005000</data0></reg></key><data><reg type="verdict"><verdict>drop</verdict></reg></data></set_elem><set_elem><key><reg type="value"><len>2</len><data0>0x00001600</data0></reg></key><data><reg type="verdict"><verdict>accept</verdict></reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input</chain><handle>8</handle><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg
 ><data><reg type="verdict"><verdict>accept</verdict></reg></data></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><le
 n>1</len><data0>0x00000011</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>accept</verdict></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/76-rule-meta_target.xml b/tests/xmlfiles/76-rule-meta_target.xml
index 970de61..beac9f3 100644
--- a/tests/xmlfiles/76-rule-meta_target.xml
+++ b/tests/xmlfiles/76-rule-meta_target.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>129</handle><expr type="meta"><key>mark</key><sreg>1</sreg></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>129</handle><expr type="meta"><key>mark</key><sreg>1</sreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/77-rule-queue.xml b/tests/xmlfiles/77-rule-queue.xml
index 3073b47..b9e9628 100644
--- a/tests/xmlfiles/77-rule-queue.xml
+++ b/tests/xmlfiles/77-rule-queue.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>input</chain><handle>43</handle><expr type="queue"><num>4</num><total>2</total><flags>0</flags></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>input</chain><handle>43</handle><expr type="queue"><num>4</num><total>2</total><flags>0</flags></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/78-rule-queue.xml b/tests/xmlfiles/78-rule-queue.xml
index 1876af7..d192d7d 100644
--- a/tests/xmlfiles/78-rule-queue.xml
+++ b/tests/xmlfiles/78-rule-queue.xml
@@ -1,2 +1,2 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>input</chain><handle>44</handle><position>43</position><expr type="queue"><num>4</num><total>2</total><flags>3</flags></expr></rule></nftables>
+<nftables><add><rule><family>ip</family><table>filter</table><chain>input</chain><handle>44</handle><position>43</position><expr type="queue"><num>4</num><total>2</total><flags>3</flags></expr></rule></add></nftables>
 
diff --git a/tests/xmlfiles/79-rule-masq.xml b/tests/xmlfiles/79-rule-masq.xml
index 303f2f2..59f9c53 100644
--- a/tests/xmlfiles/79-rule-masq.xml
+++ b/tests/xmlfiles/79-rule-masq.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>nat</table><chain>postrouting</chain><handle>4</handle><expr type="masq"><flags>12</flags></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>nat</table><chain>postrouting</chain><handle>4</handle><expr type="masq"><flags>12</flags></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/80-rule-redir.xml b/tests/xmlfiles/80-rule-redir.xml
index f7dd453..00abc58 100644
--- a/tests/xmlfiles/80-rule-redir.xml
+++ b/tests/xmlfiles/80-rule-redir.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>nat</table><chain>prerouting</chain><handle>4</handle><expr type="redir"></expr></rule></nftables>
+<nftables><add><rule><family>ip6</family><table>nat</table><chain>prerouting</chain><handle>4</handle><expr type="redir"></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/81-rule-real.xml b/tests/xmlfiles/81-rule-real.xml
new file mode 100644
index 0000000..11a860e
--- /dev/null
+++ b/tests/xmlfiles/81-rule-real.xml
@@ -0,0 +1 @@
+<nftables><add><rule><family>ip</family><table>filter</table><chain>input</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00001700</data0></reg></data></expr></rule></add></nftables>
-- 
1.7.10.4

