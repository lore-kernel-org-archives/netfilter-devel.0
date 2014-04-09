From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH] xml: json: Delete an immediatedate label in xml and json file.
Date: Wed,  9 Apr 2014 11:16:54 +0200
Message-ID: <8a18f44c02d37f6035ea2d14c6aeea28ebfa7a6e.1397033348.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:37964 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481AbaDIJRM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:17:12 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so2148966wes.18
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 02:17:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It deletes the immediatedata label in the structure of json and xml file.

Example of the old structure of xmlfile:
<nftables>
	<rule>
		<family>ip</family>
		<table>filter</table>
		<chain>input</chain>
		<handle>32</handle>
		<expr type="immediate">
			<dreg>0</dreg>
			<immediatedata>
				<data_reg type="verdict">
					<verdict>accept</verdict>
				</data_reg>
			</immediatedata>
		</expr>
	</rule>
</nftables>

Example of the new structure of xmlfile:
<nftables>
	<rule>
		<family>ip</family>
		<table>filter</table>
		<chain>input</chain>
		<handle>32</handle>
		<expr type="immediate">
			<dreg>0</dreg>
			<data_reg type="verdict">
				<verdict>accept</verdict>
			</data_reg>
		</expr>
	</rule>
</nftables>

To generate the new testfiles, It use the option -u of nft-parsing-test
script.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/immediate.c                   | 12 ++----------
 tests/jsonfiles/26-rule-immediate.json |  2 +-
 tests/jsonfiles/34-rule-payload.json   |  2 +-
 tests/jsonfiles/41-rule-real.json      |  2 +-
 tests/jsonfiles/64-ruleset.json        |  2 +-
 tests/xmlfiles/26-rule-immediate.xml   |  2 +-
 tests/xmlfiles/38-rule-real.xml        |  2 +-
 tests/xmlfiles/39-rule-real.xml        |  2 +-
 tests/xmlfiles/43-rule-real.xml        |  2 +-
 tests/xmlfiles/75-ruleset.xml          |  2 +-
 10 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index b3c52b8..2ea4636 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -263,8 +263,7 @@ nft_rule_expr_immediate_snprintf_json(char *buf, size_t len,
 	int size = len, offset = 0, ret;
 	struct nft_expr_immediate *imm = nft_expr_data(e);
 
-	ret = snprintf(buf, len, "\"dreg\":%u,"
-				 "\"immediatedata\":{", imm->dreg);
+	ret = snprintf(buf, len, "\"dreg\":%u,", imm->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 
@@ -284,9 +283,6 @@ nft_rule_expr_immediate_snprintf_json(char *buf, size_t len,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, len, "}");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
 	return offset;
 }
 
@@ -297,8 +293,7 @@ nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
 	int size = len, offset = 0, ret;
 	struct nft_expr_immediate *imm = nft_expr_data(e);
 
-	ret = snprintf(buf, len, "<dreg>%u</dreg>"
-				"<immediatedata>", imm->dreg);
+	ret = snprintf(buf, len, "<dreg>%u</dreg>", imm->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 
@@ -318,9 +313,6 @@ nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, len, "</immediatedata>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
 	return offset;
 }
 
diff --git a/tests/jsonfiles/26-rule-immediate.json b/tests/jsonfiles/26-rule-immediate.json
index 3582a39..d416928 100644
--- a/tests/jsonfiles/26-rule-immediate.json
+++ b/tests/jsonfiles/26-rule-immediate.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"immediate","dreg":0,"data_reg":{"type":"verdict","verdict":"accept"}}]}}]}
diff --git a/tests/jsonfiles/34-rule-payload.json b/tests/jsonfiles/34-rule-payload.json
index b9e9336..5cb566d 100644
--- a/tests/jsonfiles/34-rule-payload.json
+++ b/tests/jsonfiles/34-rule-payload.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00001600"}},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00001600"}},{"type":"immediate","dreg":0,"data_reg":{"type":"verdict","verdict":"accept"}}]}}]}
diff --git a/tests/jsonfiles/41-rule-real.json b/tests/jsonfiles/41-rule-real.json
index a796b58..8e15a45 100644
--- a/tests/jsonfiles/41-rule-real.json
+++ b/tests/jsonfiles/41-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data_reg":{"type":"verdict","verdict":"drop"}}]}}]}
diff --git a/tests/jsonfiles/64-ruleset.json b/tests/jsonfiles/64-ruleset.json
index 575f5ac..5755cff 100644
--- a/tests/jsonfiles/64-ruleset.json
+++ b/tests/jsonfiles/64-ruleset.json
@@ -1 +1 @@
-{"nftables":[{"table":{"name":"filter","family":"ip","flags":0,"use":0}},{"table":{"name":"filter2","family":"ip6","flags":0,"use":0}},{"chain":{"name":"input","handle":1,"bytes":10681449,"packets":16216,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"bytes":2375830,"packets":15184,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0}},{"set":{"name":"set0","table":"filter","flags":3,"family"
 :"ip","key_type":12,"key_len":2}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":6,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":9,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00001600"}},{"type":"counter","
 pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":10,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":11,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}]}
+{"nftables":[{"table":{"name":"filter","family":"ip","flags":0,"use":0}},{"table":{"name":"filter2","family":"ip6","flags":0,"use":0}},{"chain":{"name":"input","handle":1,"bytes":10681449,"packets":16216,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"bytes":2375830,"packets":15184,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0}},{"set":{"name":"set0","table":"filter","flags":3,"family"
 :"ip","key_type":12,"key_len":2}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":6,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data_reg":{"type":"verdict","verdict":"drop"}}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":9,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00001600"}},{"type":"counter","pkts":0,"bytes":0}
 ]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":10,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":11,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data_reg":{"type":"verdict","verdict":"drop"}}]}}]}
diff --git a/tests/xmlfiles/26-rule-immediate.xml b/tests/xmlfiles/26-rule-immediate.xml
index 1258c8b..0079504 100644
--- a/tests/xmlfiles/26-rule-immediate.xml
+++ b/tests/xmlfiles/26-rule-immediate.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>accept</verdict></data_reg></expr></rule></nftables>
diff --git a/tests/xmlfiles/38-rule-real.xml b/tests/xmlfiles/38-rule-real.xml
index 32b3a9e..612383f 100644
--- a/tests/xmlfiles/38-rule-real.xml
+++ b/tests/xmlfiles/38-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x0000bb01</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data
 _reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x0000bb01</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verd
 ict"><verdict>accept</verdict></data_reg></expr></rule></nftables>
diff --git a/tests/xmlfiles/39-rule-real.xml b/tests/xmlfiles/39-rule-real.xml
index da65fd4..2a22ef8 100644
--- a/tests/xmlfiles/39-rule-real.xml
+++ b/tests/xmlfiles/39-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><d
 ata1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_d
 rop</prefix><group>2</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><d
 ata1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_d
 rop</prefix><group>2</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>drop</verdict></data_reg></expr></rule></nftables>
diff --git a/tests/xmlfiles/43-rule-real.xml b/tests/xmlfiles/43-rule-real.xml
index 96f5530..907bfa5 100644
--- a/tests/xmlfiles/43-rule-real.xml
+++ b/tests/xmlfiles/43-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>drop</verdict></data_reg></expr></rule></nftables>
diff --git a/tests/xmlfiles/75-ruleset.xml b/tests/xmlfiles/75-ruleset.xml
index d1c34a1..e4c8389 100644
--- a/tests/xmlfiles/75-ruleset.xml
+++ b/tests/xmlfiles/75-ruleset.xml
@@ -1 +1 @@
-<nftables><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table><table><name>filter</name><family>ip6</family><flags>0</flags><use>0</use></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>
 0x00004300</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>map0</name><flags>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00005000</data0></data_reg></key><data><data_reg type="verdict"><verdict>drop</verdict></data_reg></data></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></key><data><data_reg type="verdict"><verdict>accept</verdict></data_reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input<
 /chain><handle>8</handle><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handle><expr type="paylo
 ad"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule></nftables>
+<nftables><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table><table><name>filter</name><family>ip6</family><flags>0</flags><use>0</use></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>
 0x00004300</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>map0</name><flags>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00005000</data0></data_reg></key><data><data_reg type="verdict"><verdict>drop</verdict></data_reg></data></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></key><data><data_reg type="verdict"><verdict>accept</verdict></data_reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input<
 /chain><handle>8</handle><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>accept</verdict></data_reg></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>6</of
 fset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>accept</verdict></data_reg></expr></rule></nftables>
-- 
1.9.0

