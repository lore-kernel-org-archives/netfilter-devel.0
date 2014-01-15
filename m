From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH v2] ct: fix key and dir requirements
Date: Wed, 15 Jan 2014 19:20:22 +0100
Message-ID: <20140115181939.25239.19905.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:58573 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752127AbaAOSUd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:20:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Follow linux/net/netfilter/nft_ct.c to adjust key and dir attributes.

The dir attribute is needed only when using certaing keys, and prohibited with
others.

Key is always mandatory.

Previous to this patch, using XML/JSON to manage this expr led to some
undefined and erroneous behaviours.

While at it, update tests files in order to pass nft-parsing-test.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: fixed wrong logic in the XML parser. Added support for NFT_CT_L3PROTOCOL

 src/expr/ct.c                   |   97 +++++++++++++++++++++++++++------------
 tests/xmlfiles/24-rule-ct.xml   |    2 -
 tests/xmlfiles/37-rule-real.xml |    2 -
 tests/xmlfiles/39-rule-real.xml |    2 -
 tests/xmlfiles/50-rule-real.xml |    2 -
 tests/xmlfiles/51-rule-real.xml |    2 -
 tests/xmlfiles/52-rule-real.xml |    2 -
 tests/xmlfiles/53-rule-real.xml |    2 -
 tests/xmlfiles/54-rule-real.xml |    2 -
 tests/xmlfiles/55-rule-real.xml |    2 -
 tests/xmlfiles/56-rule-real.xml |    2 -
 tests/xmlfiles/57-rule-real.xml |    2 -
 12 files changed, 78 insertions(+), 41 deletions(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index e960134..e74c36c 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -179,6 +179,28 @@ static inline int str2ctkey(const char *ctkey)
 	return -1;
 }
 
+static bool ctkey_req_dir(int ctkey)
+{
+	switch (ctkey) {
+	case NFT_CT_STATE:
+	case NFT_CT_DIRECTION:
+	case NFT_CT_STATUS:
+	case NFT_CT_MARK:
+	case NFT_CT_SECMARK:
+	case NFT_CT_EXPIRATION:
+	case NFT_CT_HELPER:
+		return false;
+	case NFT_CT_L3PROTOCOL:
+	case NFT_CT_SRC:
+	case NFT_CT_DST:
+	case NFT_CT_PROTOCOL:
+	case NFT_CT_PROTO_SRC:
+	case NFT_CT_PROTO_DST:
+	default:
+		return true;
+	}
+}
+
 static int nft_rule_expr_ct_json_parse(struct nft_rule_expr *e, json_t *root,
 				       struct nft_parse_err *err)
 {
@@ -193,22 +215,19 @@ static int nft_rule_expr_ct_json_parse(struct nft_rule_expr *e, json_t *root,
 
 	nft_rule_expr_set_u32(e, NFT_EXPR_CT_DREG, reg);
 
-	if (nft_jansson_node_exist(root, "key")) {
-		key_str = nft_jansson_parse_str(root, "key", err);
-		if (key_str == NULL)
-			return -1;
-
-		key = str2ctkey(key_str);
-		if (key < 0)
-			goto err;
+	key_str = nft_jansson_parse_str(root, "key", err);
+	if (key_str == NULL)
+		return -1;
 
-		nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
+	key = str2ctkey(key_str);
+	if (key < 0)
+		goto err;
 
-	}
+	nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
 
-	if (nft_jansson_node_exist(root, "dir")) {
-		if (nft_jansson_parse_val(root, "dir", NFT_TYPE_U8, &dir,
-					  err) < 0)
+	if (ctkey_req_dir(key)) {
+		if (nft_jansson_parse_val(root, "dir", NFT_TYPE_U8,
+					  &dir, err) < 0)
 			return -1;
 
 		if (dir != IP_CT_DIR_ORIGINAL && dir != IP_CT_DIR_REPLY)
@@ -257,15 +276,18 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 	ct->key = key;
 	e->flags |= (1 << NFT_EXPR_CT_KEY);
 
-	if (nft_mxml_num_parse(tree, "dir", MXML_DESCEND_FIRST, BASE_DEC,
-			       &dir, NFT_TYPE_U8, NFT_XML_MAND, err) != 0)
-		return -1;
+	if (ctkey_req_dir(key)) {
+		if (nft_mxml_num_parse(tree, "dir", MXML_DESCEND_FIRST,
+				       BASE_DEC, &dir, NFT_TYPE_U8,
+				       NFT_XML_MAND, err) != 0)
+				return -1;
 
-	if (dir != IP_CT_DIR_ORIGINAL && dir != IP_CT_DIR_REPLY)
-		goto err;
+		if (dir != IP_CT_DIR_ORIGINAL && dir != IP_CT_DIR_REPLY)
+			goto err;
 
-	ct->dir = dir;
-	e->flags |= (1 << NFT_EXPR_CT_DIR);
+		ct->dir = dir;
+		e->flags |= (1 << NFT_EXPR_CT_DIR);
+	}
 
 	return 0;
 err:
@@ -286,19 +308,37 @@ nft_expr_ct_snprintf_json(char *buf, size_t size, struct nft_rule_expr *e)
 	ret = snprintf(buf, len, "\"dreg\":%u", ct->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	if (e->flags & (1 << NFT_EXPR_CT_KEY)) {
-		ret = snprintf(buf+offset, len, ",\"key\":\"%s\"",
-						ctkey2str(ct->key));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	ret = snprintf(buf+offset, len, ",\"key\":\"%s\"",
+		       ctkey2str(ct->key));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	if (e->flags & (1 << NFT_EXPR_CT_DIR)) {
+	if (ctkey_req_dir(ct->key) && (e->flags & (1 << NFT_EXPR_CT_DIR))) {
 		ret = snprintf(buf+offset, len, ",\"dir\":%u", ct->dir);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	return offset;
+}
+
+static int
+nft_expr_ct_snprintf_xml(char *buf, size_t size, struct nft_rule_expr *e)
+{
+	int ret, len = size, offset = 0;
+	struct nft_expr_ct *ct = nft_expr_data(e);
+
+	ret = snprintf(buf, len, "<dreg>%u</dreg>", ct->dreg);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, len, "<key>%s</key>",
+		       ctkey2str(ct->key));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if (ctkey_req_dir(ct->key) && (e->flags & (1 << NFT_EXPR_CT_DIR))) {
+		ret = snprintf(buf+offset, len, "<dir>%u</dir>", ct->dir);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 
 static int
@@ -312,10 +352,7 @@ nft_rule_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
 		return snprintf(buf, len, "load %s => reg %u dir %u ",
 				ctkey2str(ct->key), ct->dreg, ct->dir);
 	case NFT_OUTPUT_XML:
-		return snprintf(buf, len, "<dreg>%u</dreg>"
-					  "<key>%s</key>"
-					  "<dir>%u</dir>",
-				ct->dreg, ctkey2str(ct->key), ct->dir);
+		return nft_expr_ct_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
 		return nft_expr_ct_snprintf_json(buf, len, e);
 	default:
diff --git a/tests/xmlfiles/24-rule-ct.xml b/tests/xmlfiles/24-rule-ct.xml
index b3f4ad8..7890da0 100644
--- a/tests/xmlfiles/24-rule-ct.xml
+++ b/tests/xmlfiles/24-rule-ct.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="ct"><dreg>1</dreg><key>state</key></expr></rule></nftables>
diff --git a/tests/xmlfiles/37-rule-real.xml b/tests/xmlfiles/37-rule-real.xml
index 89b06b8..8eca025 100644
--- a/tests/xmlfiles/37-rule-real.xml
+++ b/tests/xmlfiles/37-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</da
 ta0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><le
 n>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</da
 ta0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>state</key></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><da
 ta0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
diff --git a/tests/xmlfiles/39-rule-real.xml b/tests/xmlfiles/39-rule-real.xml
index a307a2e..07e9a84 100644
--- a/tests/xmlfiles/39-rule-real.xml
+++ b/tests/xmlfiles/39-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></cmpdata></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="
 value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset
 >6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_drop</prefix><group>2</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr><ex
 pr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></cmpdata></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="
 value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset
 >6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>status</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_drop</prefix><group>2</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr><expr type="imm
 ediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
diff --git a/tests/xmlfiles/50-rule-real.xml b/tests/xmlfiles/50-rule-real.xml
index d15eff4..8977c5d 100644
--- a/tests/xmlfiles/50-rule-real.xml
+++ b/tests/xmlfiles/50-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/51-rule-real.xml b/tests/xmlfiles/51-rule-real.xml
index 471cd2b..9cc5dae 100644
--- a/tests/xmlfiles/51-rule-real.xml
+++ b/tests/xmlfiles/51-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/52-rule-real.xml b/tests/xmlfiles/52-rule-real.xml
index 61a1269..55ff00b 100644
--- a/tests/xmlfiles/52-rule-real.xml
+++ b/tests/xmlfiles/52-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/53-rule-real.xml b/tests/xmlfiles/53-rule-real.xml
index d835639..c0c10e9 100644
--- a/tests/xmlfiles/53-rule-real.xml
+++ b/tests/xmlfiles/53-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/54-rule-real.xml b/tests/xmlfiles/54-rule-real.xml
index ed27e56..ecb596f 100644
--- a/tests/xmlfiles/54-rule-real.xml
+++ b/tests/xmlfiles/54-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000064</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>l3protocol</key><dir>1</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000064</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/55-rule-real.xml b/tests/xmlfiles/55-rule-real.xml
index 2d2bf7f..b7e6606 100644
--- a/tests/xmlfiles/55-rule-real.xml
+++ b/tests/xmlfiles/55-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/56-rule-real.xml b/tests/xmlfiles/56-rule-real.xml
index 4596689..0fc23cc 100644
--- a/tests/xmlfiles/56-rule-real.xml
+++ b/tests/xmlfiles/56-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0000001e</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0000001e</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/57-rule-real.xml b/tests/xmlfiles/57-rule-real.xml
index 6a2ad52..971dfb5 100644
--- a/tests/xmlfiles/57-rule-real.xml
+++ b/tests/xmlfiles/57-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00707466</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00707466</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>

