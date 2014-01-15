From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] tests: xml: delete comments
Date: Wed, 15 Jan 2014 12:12:18 +0100
Message-ID: <20140115111218.25584.60794.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60880 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750998AbaAOLMa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:12:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In libmxml > 2.6, comments are not ignored when building the XML tree,
so these comments produce errors and test fail.

Delete the comment lines, so parsing test pass with libmxml 2.7 and 2.8.

By now, this is the only issue I found when working with libmxml > 2.6.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/xmlfiles/20-rule-bitwise.xml   |    1 -
 tests/xmlfiles/22-rule-cmp.xml       |    1 -
 tests/xmlfiles/23-rule-counter.xml   |    1 -
 tests/xmlfiles/24-rule-ct.xml        |    1 -
 tests/xmlfiles/26-rule-immediate.xml |    1 -
 tests/xmlfiles/28-rule-log.xml       |    1 -
 tests/xmlfiles/29-rule-lookup.xml    |    1 -
 tests/xmlfiles/31-rule-meta.xml      |    1 -
 tests/xmlfiles/34-rule-payload.xml   |    1 -
 tests/xmlfiles/36-rule-real.xml      |    1 -
 tests/xmlfiles/37-rule-real.xml      |    1 -
 tests/xmlfiles/38-rule-real.xml      |    1 -
 tests/xmlfiles/39-rule-real.xml      |    1 -
 tests/xmlfiles/40-rule-real.xml      |    1 -
 tests/xmlfiles/41-rule-real.xml      |    1 -
 tests/xmlfiles/42-rule-real.xml      |    1 -
 tests/xmlfiles/43-rule-real.xml      |    1 -
 tests/xmlfiles/44-rule-real.xml      |    1 -
 tests/xmlfiles/45-rule-real.xml      |    1 -
 tests/xmlfiles/46-rule-real.xml      |    1 -
 tests/xmlfiles/47-rule-real.xml      |    1 -
 tests/xmlfiles/48-rule-real.xml      |    1 -
 tests/xmlfiles/49-rule-real.xml      |    1 -
 tests/xmlfiles/50-rule-real.xml      |    1 -
 tests/xmlfiles/51-rule-real.xml      |    1 -
 tests/xmlfiles/52-rule-real.xml      |    1 -
 tests/xmlfiles/53-rule-real.xml      |    1 -
 tests/xmlfiles/54-rule-real.xml      |    1 -
 tests/xmlfiles/55-rule-real.xml      |    1 -
 tests/xmlfiles/56-rule-real.xml      |    1 -
 tests/xmlfiles/57-rule-real.xml      |    1 -
 tests/xmlfiles/58-rule-real.xml      |    1 -
 tests/xmlfiles/59-rule-real.xml      |    1 -
 tests/xmlfiles/60-rule-real.xml      |    1 -
 tests/xmlfiles/61-rule-real.xml      |    1 -
 tests/xmlfiles/62-rule-real.xml      |    1 -
 tests/xmlfiles/63-rule-real.xml      |    1 -
 tests/xmlfiles/64-rule-real.xml      |    1 -
 tests/xmlfiles/65-rule-real.xml      |    1 -
 tests/xmlfiles/66-rule-real.xml      |    1 -
 tests/xmlfiles/67-rule-real.xml      |    1 -
 tests/xmlfiles/68-rule-real.xml      |    1 -
 tests/xmlfiles/69-rule-real.xml      |    1 -
 tests/xmlfiles/70-rule-real.xml      |    1 -
 tests/xmlfiles/71-rule-real.xml      |    1 -
 tests/xmlfiles/72-rule-real.xml      |    1 -
 tests/xmlfiles/73-set.xml            |    1 -
 tests/xmlfiles/74-set.xml            |    1 -
 48 files changed, 48 deletions(-)

diff --git a/tests/xmlfiles/20-rule-bitwise.xml b/tests/xmlfiles/20-rule-bitwise.xml
index 8562863..756b22c 100644
--- a/tests/xmlfiles/20-rule-bitwise.xml
+++ b/tests/xmlfiles/20-rule-bitwise.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr></rule></nftables>
-<!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/22-rule-cmp.xml b/tests/xmlfiles/22-rule-cmp.xml
index ea8ea30..308fb9f 100644
--- a/tests/xmlfiles/22-rule-cmp.xml
+++ b/tests/xmlfiles/22-rule-cmp.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></data_reg></cmpdata></expr></rule></nftables>
-<!-- nft add rule ip6 filter test meta iifname bond10.139 accept -->
diff --git a/tests/xmlfiles/23-rule-counter.xml b/tests/xmlfiles/23-rule-counter.xml
index 82700de..6299e84 100644
--- a/tests/xmlfiles/23-rule-counter.xml
+++ b/tests/xmlfiles/23-rule-counter.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>39</handle><expr type="counter"><pkts>3</pkts><bytes>177</bytes></expr></rule></nftables>
-<!-- nft add rule ip6 filter test udp dport 53 counter accept -->
diff --git a/tests/xmlfiles/24-rule-ct.xml b/tests/xmlfiles/24-rule-ct.xml
index e8e565d..b3f4ad8 100644
--- a/tests/xmlfiles/24-rule-ct.xml
+++ b/tests/xmlfiles/24-rule-ct.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr></rule></nftables>
-<!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/26-rule-immediate.xml b/tests/xmlfiles/26-rule-immediate.xml
index 4d10eb6..1258c8b 100644
--- a/tests/xmlfiles/26-rule-immediate.xml
+++ b/tests/xmlfiles/26-rule-immediate.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule></nftables>
-<!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/28-rule-log.xml b/tests/xmlfiles/28-rule-log.xml
index f24f858..5865bd4 100644
--- a/tests/xmlfiles/28-rule-log.xml
+++ b/tests/xmlfiles/28-rule-log.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>96</handle><expr type="log"><prefix>test_chain</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
-<!-- nft add rule ip6 filter test log prefix test_chain group 1 -->
diff --git a/tests/xmlfiles/29-rule-lookup.xml b/tests/xmlfiles/29-rule-lookup.xml
index c77e95c..052b008 100644
--- a/tests/xmlfiles/29-rule-lookup.xml
+++ b/tests/xmlfiles/29-rule-lookup.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>37</handle><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
-<!-- nft add rule ip6 filter test ip6 saddr { ::2 , ::3 } drop -->
diff --git a/tests/xmlfiles/31-rule-meta.xml b/tests/xmlfiles/31-rule-meta.xml
index 22498e7..a1c9e8c 100644
--- a/tests/xmlfiles/31-rule-meta.xml
+++ b/tests/xmlfiles/31-rule-meta.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr></rule></nftables>
-<!-- nft add rule ip6 filter test meta iifname bond10.139 accept -->
diff --git a/tests/xmlfiles/34-rule-payload.xml b/tests/xmlfiles/34-rule-payload.xml
index 833e640..a6faca9 100644
--- a/tests/xmlfiles/34-rule-payload.xml
+++ b/tests/xmlfiles/34-rule-payload.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr></rule></nftables>
-<!-- nft add rule ip6 filter test tcp dport 22 accept -->
diff --git a/tests/xmlfiles/36-rule-real.xml b/tests/xmlfiles/36-rule-real.xml
index 17f1e5f..5c8e075 100644
--- a/tests/xmlfiles/36-rule-real.xml
+++ b/tests/xmlfiles/36-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule filter INPUT ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter -->
diff --git a/tests/xmlfiles/37-rule-real.xml b/tests/xmlfiles/37-rule-real.xml
index dc45629..89b06b8 100644
--- a/tests/xmlfiles/37-rule-real.xml
+++ b/tests/xmlfiles/37-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</da
 ta0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><le
 n>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
-<!-- nft add rule filter INPUT meta iifname "eth0" tcp dport 22 ct state new,established counter log prefix testprefix group 1 -->
diff --git a/tests/xmlfiles/38-rule-real.xml b/tests/xmlfiles/38-rule-real.xml
index 6f41f0e..b8830b0 100644
--- a/tests/xmlfiles/38-rule-real.xml
+++ b/tests/xmlfiles/38-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x0000bb01</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immedia
 te"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule></nftables>
-<!-- nft add rule ip filter INPUT ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } tcp dport 443 counter accept -->
diff --git a/tests/xmlfiles/39-rule-real.xml b/tests/xmlfiles/39-rule-real.xml
index c823c25..a307a2e 100644
--- a/tests/xmlfiles/39-rule-real.xml
+++ b/tests/xmlfiles/39-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></cmpdata></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="
 value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset
 >6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_drop</prefix><group>2</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr><ex
 pr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
-<!-- nft add rule ip6 filter test meta iifname "bond0" meta oifname "bond1.27" ip6 saddr 2a00:9ac0:c1ca:27::150 udp dport 53 ct status expected counter log prefix dns_drop group 2 drop -->
diff --git a/tests/xmlfiles/40-rule-real.xml b/tests/xmlfiles/40-rule-real.xml
index 835dcec..0041ebf 100644
--- a/tests/xmlfiles/40-rule-real.xml
+++ b/tests/xmlfiles/40-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr></rule></nftables>
-<!-- nft add rule filter output ip daddr 192.168.0.1 -->
diff --git a/tests/xmlfiles/41-rule-real.xml b/tests/xmlfiles/41-rule-real.xml
index 001a20e..bd213b0 100644
--- a/tests/xmlfiles/41-rule-real.xml
+++ b/tests/xmlfiles/41-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><cmpdata><data_reg type="value"><len>4</len><data0>0xfa00a8c0</data0></data_reg></cmpdata></expr></rule></nftables>
-<!-- nft add rule filter output ip daddr 192.168.0.1-192.168.0.250 -->
diff --git a/tests/xmlfiles/42-rule-real.xml b/tests/xmlfiles/42-rule-real.xml
index 6398c48..b5cc1bd 100644
--- a/tests/xmlfiles/42-rule-real.xml
+++ b/tests/xmlfiles/42-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule filter output ip daddr 192.168.0.1 counter -->
diff --git a/tests/xmlfiles/43-rule-real.xml b/tests/xmlfiles/43-rule-real.xml
index 38be43e..a84f513 100644
--- a/tests/xmlfiles/43-rule-real.xml
+++ b/tests/xmlfiles/43-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
-<!-- nft add rule filter output ip daddr 192.168.0.1 counter drop -->
diff --git a/tests/xmlfiles/44-rule-real.xml b/tests/xmlfiles/44-rule-real.xml
index 8ab5db9..5a99e6f 100644
--- a/tests/xmlfiles/44-rule-real.xml
+++ b/tests/xmlfiles/44-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>(null)</prefix><group>0</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
-<!-- nft add rule filter output ip daddr 192.168.0.1 counter log -->
diff --git a/tests/xmlfiles/45-rule-real.xml b/tests/xmlfiles/45-rule-real.xml
index 165d581..53fa009 100644
--- a/tests/xmlfiles/45-rule-real.xml
+++ b/tests/xmlfiles/45-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule filter output tcp dport 22 counter -->
diff --git a/tests/xmlfiles/46-rule-real.xml b/tests/xmlfiles/46-rule-real.xml
index d6f7376..0ddf6c8 100644
--- a/tests/xmlfiles/46-rule-real.xml
+++ b/tests/xmlfiles/46-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x16000004</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule filter output tcp sport 1024 tcp dport 22 counter -->
diff --git a/tests/xmlfiles/47-rule-real.xml b/tests/xmlfiles/47-rule-real.xml
index 815bd61..fde6d26 100644
--- a/tests/xmlfiles/47-rule-real.xml
+++ b/tests/xmlfiles/47-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule filter output ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter -->
diff --git a/tests/xmlfiles/48-rule-real.xml b/tests/xmlfiles/48-rule-real.xml
index 4b31948..547a0f6 100644
--- a/tests/xmlfiles/48-rule-real.xml
+++ b/tests/xmlfiles/48-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule></nftables>
-<!-- nft add rule filter output tcp sequence 0 tcp sport 1024 tcp dport 22 -->
diff --git a/tests/xmlfiles/49-rule-real.xml b/tests/xmlfiles/49-rule-real.xml
index a4db57f..dc662a3 100644
--- a/tests/xmlfiles/49-rule-real.xml
+++ b/tests/xmlfiles/49-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule></nftables>
-<!-- nft add rule filter output tcp sport 1024 tcp dport 22 tcp sequence 0 -->
diff --git a/tests/xmlfiles/50-rule-real.xml b/tests/xmlfiles/50-rule-real.xml
index 72bddc7..d15eff4 100644
--- a/tests/xmlfiles/50-rule-real.xml
+++ b/tests/xmlfiles/50-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
-<!-- nft add rule filter output ct state new,established counter -->
diff --git a/tests/xmlfiles/51-rule-real.xml b/tests/xmlfiles/51-rule-real.xml
index 72cac29..471cd2b 100644
--- a/tests/xmlfiles/51-rule-real.xml
+++ b/tests/xmlfiles/51-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule></nftables>
-<!-- nft add rule filter output ct direction original counter -->
diff --git a/tests/xmlfiles/52-rule-real.xml b/tests/xmlfiles/52-rule-real.xml
index ca14eb8..61a1269 100644
--- a/tests/xmlfiles/52-rule-real.xml
+++ b/tests/xmlfiles/52-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule></nftables>
-<!-- nft add rule filter output ct direction reply counter -->
diff --git a/tests/xmlfiles/53-rule-real.xml b/tests/xmlfiles/53-rule-real.xml
index 304732b..d835639 100644
--- a/tests/xmlfiles/53-rule-real.xml
+++ b/tests/xmlfiles/53-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule filter output ct status expected counter -->
diff --git a/tests/xmlfiles/54-rule-real.xml b/tests/xmlfiles/54-rule-real.xml
index 5312eca..ed27e56 100644
--- a/tests/xmlfiles/54-rule-real.xml
+++ b/tests/xmlfiles/54-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000064</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft rule add filter output ct mark 100 counter -->
diff --git a/tests/xmlfiles/55-rule-real.xml b/tests/xmlfiles/55-rule-real.xml
index 757a7a2..2d2bf7f 100644
--- a/tests/xmlfiles/55-rule-real.xml
+++ b/tests/xmlfiles/55-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
-<!-- nft add rule filter output ct secmark 0 counter -->
diff --git a/tests/xmlfiles/56-rule-real.xml b/tests/xmlfiles/56-rule-real.xml
index 242ddbb..4596689 100644
--- a/tests/xmlfiles/56-rule-real.xml
+++ b/tests/xmlfiles/56-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0000001e</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule filter output ct expiration 30 counter -->
diff --git a/tests/xmlfiles/57-rule-real.xml b/tests/xmlfiles/57-rule-real.xml
index 136e5f1..6a2ad52 100644
--- a/tests/xmlfiles/57-rule-real.xml
+++ b/tests/xmlfiles/57-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00707466</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule filter output ct helper "ftp" counter -->
diff --git a/tests/xmlfiles/58-rule-real.xml b/tests/xmlfiles/58-rule-real.xml
index 4474eb2..d9bfe3a 100644
--- a/tests/xmlfiles/58-rule-real.xml
+++ b/tests/xmlfiles/58-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule ip filter output meta length 1000 counter -->
diff --git a/tests/xmlfiles/59-rule-real.xml b/tests/xmlfiles/59-rule-real.xml
index 4e231a2..6af8aa6 100644
--- a/tests/xmlfiles/59-rule-real.xml
+++ b/tests/xmlfiles/59-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00000008</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
-<!-- nft add rule ip filter output meta protocol 0x0800 counter -->
diff --git a/tests/xmlfiles/60-rule-real.xml b/tests/xmlfiles/60-rule-real.xml
index 535ab54..24cf057 100644
--- a/tests/xmlfiles/60-rule-real.xml
+++ b/tests/xmlfiles/60-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
-<!-- nft add rule ip filter output meta mark 0 counter -->
diff --git a/tests/xmlfiles/61-rule-real.xml b/tests/xmlfiles/61-rule-real.xml
index 2a5d411..3aaad57 100644
--- a/tests/xmlfiles/61-rule-real.xml
+++ b/tests/xmlfiles/61-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule ip filter output meta iif lo counter -->
diff --git a/tests/xmlfiles/62-rule-real.xml b/tests/xmlfiles/62-rule-real.xml
index dfb6e44..d7935d1 100644
--- a/tests/xmlfiles/62-rule-real.xml
+++ b/tests/xmlfiles/62-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule ip filter output meta iifname "eth0" counter -->
diff --git a/tests/xmlfiles/63-rule-real.xml b/tests/xmlfiles/63-rule-real.xml
index b144889..f2a36f4 100644
--- a/tests/xmlfiles/63-rule-real.xml
+++ b/tests/xmlfiles/63-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule ip filter output meta oif lo counter -->
diff --git a/tests/xmlfiles/64-rule-real.xml b/tests/xmlfiles/64-rule-real.xml
index a83efb9..01a8708 100644
--- a/tests/xmlfiles/64-rule-real.xml
+++ b/tests/xmlfiles/64-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule ip filter output meta oifname "eth0" counter -->
diff --git a/tests/xmlfiles/65-rule-real.xml b/tests/xmlfiles/65-rule-real.xml
index cfec802..2d59190 100644
--- a/tests/xmlfiles/65-rule-real.xml
+++ b/tests/xmlfiles/65-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule ip filter output meta skuid 1000 counter -->
diff --git a/tests/xmlfiles/66-rule-real.xml b/tests/xmlfiles/66-rule-real.xml
index 57b0d45..f9d9c5e 100644
--- a/tests/xmlfiles/66-rule-real.xml
+++ b/tests/xmlfiles/66-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule ip filter output meta skgid 1000 counter -->
diff --git a/tests/xmlfiles/67-rule-real.xml b/tests/xmlfiles/67-rule-real.xml
index 1ee49fc..555139c 100644
--- a/tests/xmlfiles/67-rule-real.xml
+++ b/tests/xmlfiles/67-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
-<!-- nft add rule ip filter output meta secmark 0 counter -->
diff --git a/tests/xmlfiles/68-rule-real.xml b/tests/xmlfiles/68-rule-real.xml
index 70bccd9..a0ff9ce 100644
--- a/tests/xmlfiles/68-rule-real.xml
+++ b/tests/xmlfiles/68-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
-<!-- nft add rule filter output tcp dport { 22, 23 } counter -->
diff --git a/tests/xmlfiles/69-rule-real.xml b/tests/xmlfiles/69-rule-real.xml
index 2c61706..e39e2cb 100644
--- a/tests/xmlfiles/69-rule-real.xml
+++ b/tests/xmlfiles/69-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>33</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
-<!-- nft add rule ip filter output ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } -->
diff --git a/tests/xmlfiles/70-rule-real.xml b/tests/xmlfiles/70-rule-real.xml
index 0a876e9..6edd166 100644
--- a/tests/xmlfiles/70-rule-real.xml
+++ b/tests/xmlfiles/70-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
-<!-- nft add rule ip filter output tcp dport vmap { 22 => jump chain1, 23 => jump chain2, } -->
diff --git a/tests/xmlfiles/71-rule-real.xml b/tests/xmlfiles/71-rule-real.xml
index 143de72..fba3af9 100644
--- a/tests/xmlfiles/71-rule-real.xml
+++ b/tests/xmlfiles/71-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
-<!-- nft add rule ip filter output tcp dport vmap { 22 => accept, 23 => drop, } -->
diff --git a/tests/xmlfiles/72-rule-real.xml b/tests/xmlfiles/72-rule-real.xml
index fb35523..aac8b85 100644
--- a/tests/xmlfiles/72-rule-real.xml
+++ b/tests/xmlfiles/72-rule-real.xml
@@ -1,2 +1 @@
 <nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>36</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>map2</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
-<!-- nft add rule ip filter output ip daddr vmap { 192.168.1.1 => accept, 192.168.1.2 => drop, } -->
diff --git a/tests/xmlfiles/73-set.xml b/tests/xmlfiles/73-set.xml
index 37fb2ee..6a9323a 100644
--- a/tests/xmlfiles/73-set.xml
+++ b/tests/xmlfiles/73-set.xml
@@ -1,2 +1 @@
 <nftables><set><family>ip</family><table>filter</table><name>set0</name><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0300a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0200a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></key></set_elem></set></nftables>
-<!-- nft add rule ip filter test ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } tcp dport 443 counter accept -->
diff --git a/tests/xmlfiles/74-set.xml b/tests/xmlfiles/74-set.xml
index 679ee30..5f0e7ae 100644
--- a/tests/xmlfiles/74-set.xml
+++ b/tests/xmlfiles/74-set.xml
@@ -1,2 +1 @@
 <nftables><set><family>ip6</family><table>filter</table><name>set0</name><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></key></set_elem></set></nftables>
-<!-- nft add rule ip6 filter test ip6 daddr { 2a00:9ac0:c1ca:27::150, 2a00:9ac0:c1ca:27::170, } counter accept -->

