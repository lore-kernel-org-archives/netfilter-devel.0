From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftables] rule: remove NFT_RULE_ATTR_FLAGS
Date: Fri, 25 Oct 2013 00:17:05 +0200
Message-ID: <20131024221705.GA10617@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50803 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab3JXWRO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 18:17:14 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a leftover from the time we had per rule flags, obsoleted
by the new rule batching approach. Kill it as it is unused.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftables/rule.h             |    1 -
 src/rule.c                             |   26 ++------------------------
 tests/jsonfiles/20-rule-bitwise.json   |    2 +-
 tests/jsonfiles/21-rule-byteorder.json |    2 +-
 tests/jsonfiles/22-rule-cmp.json       |    2 +-
 tests/jsonfiles/23-rule-counter.json   |    2 +-
 tests/jsonfiles/24-rule-ct.json        |    2 +-
 tests/jsonfiles/25-rule-exthdr.json    |    2 +-
 tests/jsonfiles/26-rule-immediate.json |    2 +-
 tests/jsonfiles/27-rule-limit.json     |    2 +-
 tests/jsonfiles/28-rule-log.json       |    2 +-
 tests/jsonfiles/29-rule-match.json     |    2 +-
 tests/jsonfiles/30-rule-lookup.json    |    2 +-
 tests/jsonfiles/31-rule-meta.json      |    2 +-
 tests/jsonfiles/32-rule-nat4.json      |    2 +-
 tests/jsonfiles/33-rule-nat6.json      |    2 +-
 tests/jsonfiles/34-rule-payload.json   |    2 +-
 tests/jsonfiles/35-rule-target.json    |    2 +-
 tests/jsonfiles/36-rule-real.json      |    2 +-
 tests/jsonfiles/37-rule-real.json      |    2 +-
 tests/jsonfiles/38-rule-real.json      |    2 +-
 tests/jsonfiles/39-rule-real.json      |    2 +-
 tests/jsonfiles/40-rule-real.json      |    2 +-
 tests/jsonfiles/41-rule-real.json      |    2 +-
 tests/jsonfiles/42-rule-real.json      |    2 +-
 tests/jsonfiles/43-rule-real.json      |    2 +-
 tests/jsonfiles/44-rule-real.json      |    2 +-
 tests/jsonfiles/45-rule-real.json      |    2 +-
 tests/jsonfiles/46-rule-real.json      |    2 +-
 tests/jsonfiles/47-rule-real.json      |    2 +-
 tests/jsonfiles/48-rule-real.json      |    2 +-
 tests/jsonfiles/49-rule-real.json      |    2 +-
 tests/jsonfiles/50-rule-real.json      |    2 +-
 tests/jsonfiles/51-rule-real.json      |    2 +-
 tests/jsonfiles/52-rule-real.json      |    2 +-
 tests/jsonfiles/53-rule-real.json      |    2 +-
 tests/jsonfiles/54-rule-real.json      |    2 +-
 tests/jsonfiles/55-rule-real.json      |    2 +-
 tests/jsonfiles/56-rule-real.json      |    2 +-
 tests/jsonfiles/57-rule-real.json      |    2 +-
 tests/jsonfiles/58-rule-real.json      |    2 +-
 tests/jsonfiles/59-rule-real.json      |    2 +-
 tests/jsonfiles/60-rule-real.json      |    2 +-
 tests/jsonfiles/61-rule-real.json      |    2 +-
 tests/xmlfiles/20-rule-bitwise.xml     |    2 +-
 tests/xmlfiles/21-rule-byteorder.xml   |    2 +-
 tests/xmlfiles/22-rule-cmp.xml         |    2 +-
 tests/xmlfiles/23-rule-counter.xml     |    2 +-
 tests/xmlfiles/24-rule-ct.xml          |    2 +-
 tests/xmlfiles/25-rule-exthdr.xml      |    2 +-
 tests/xmlfiles/26-rule-immediate.xml   |    2 +-
 tests/xmlfiles/27-rule-limit.xml       |    2 +-
 tests/xmlfiles/28-rule-log.xml         |    2 +-
 tests/xmlfiles/29-rule-lookup.xml      |    2 +-
 tests/xmlfiles/30-rule-match.xml       |    2 +-
 tests/xmlfiles/31-rule-meta.xml        |    2 +-
 tests/xmlfiles/32-rule-nat6.xml        |    2 +-
 tests/xmlfiles/33-rule-nat4.xml        |    2 +-
 tests/xmlfiles/34-rule-payload.xml     |    2 +-
 tests/xmlfiles/35-rule-target.xml      |    2 +-
 tests/xmlfiles/36-rule-real.xml        |    2 +-
 tests/xmlfiles/37-rule-real.xml        |    2 +-
 tests/xmlfiles/38-rule-real.xml        |    2 +-
 tests/xmlfiles/39-rule-real.xml        |    2 +-
 tests/xmlfiles/40-rule-real.xml        |    2 +-
 tests/xmlfiles/41-rule-real.xml        |    2 +-
 tests/xmlfiles/42-rule-real.xml        |    2 +-
 tests/xmlfiles/43-rule-real.xml        |    2 +-
 tests/xmlfiles/44-rule-real.xml        |    2 +-
 tests/xmlfiles/45-rule-real.xml        |    2 +-
 tests/xmlfiles/46-rule-real.xml        |    2 +-
 tests/xmlfiles/47-rule-real.xml        |    2 +-
 tests/xmlfiles/48-rule-real.xml        |    2 +-
 tests/xmlfiles/49-rule-real.xml        |    2 +-
 tests/xmlfiles/50-rule-real.xml        |    2 +-
 tests/xmlfiles/51-rule-real.xml        |    2 +-
 tests/xmlfiles/52-rule-real.xml        |    2 +-
 tests/xmlfiles/53-rule-real.xml        |    2 +-
 tests/xmlfiles/54-rule-real.xml        |    2 +-
 tests/xmlfiles/55-rule-real.xml        |    2 +-
 tests/xmlfiles/56-rule-real.xml        |    2 +-
 tests/xmlfiles/57-rule-real.xml        |    2 +-
 tests/xmlfiles/58-rule-real.xml        |    2 +-
 tests/xmlfiles/59-rule-real.xml        |    2 +-
 tests/xmlfiles/60-rule-real.xml        |    2 +-
 tests/xmlfiles/61-rule-real.xml        |    2 +-
 tests/xmlfiles/62-rule-real.xml        |    2 +-
 tests/xmlfiles/63-rule-real.xml        |    2 +-
 tests/xmlfiles/64-rule-real.xml        |    2 +-
 tests/xmlfiles/65-rule-real.xml        |    2 +-
 tests/xmlfiles/66-rule-real.xml        |    2 +-
 tests/xmlfiles/67-rule-real.xml        |    2 +-
 tests/xmlfiles/68-rule-real.xml        |    2 +-
 tests/xmlfiles/69-rule-real.xml        |    2 +-
 tests/xmlfiles/70-rule-real.xml        |    2 +-
 tests/xmlfiles/71-rule-real.xml        |    2 +-
 tests/xmlfiles/72-rule-real.xml        |    2 +-
 97 files changed, 97 insertions(+), 120 deletions(-)

diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 9fba9c8..09d4637 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -19,7 +19,6 @@ enum {
 	NFT_RULE_ATTR_TABLE,
 	NFT_RULE_ATTR_CHAIN,
 	NFT_RULE_ATTR_HANDLE,
-	NFT_RULE_ATTR_FLAGS,
 	NFT_RULE_ATTR_COMPAT_PROTO,
 	NFT_RULE_ATTR_COMPAT_FLAGS,
 	NFT_RULE_ATTR_POSITION,
diff --git a/src/rule.c b/src/rule.c
index 50f4486..62e3307 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -37,7 +37,6 @@ struct nft_rule {
 	const char	*table;
 	const char	*chain;
 	uint8_t		family;
-	uint32_t	rule_flags;
 	uint64_t	handle;
 	uint64_t	position;
 	struct {
@@ -103,7 +102,6 @@ void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr)
 		}
 		break;
 	case NFT_RULE_ATTR_HANDLE:
-	case NFT_RULE_ATTR_FLAGS:
 	case NFT_RULE_ATTR_COMPAT_PROTO:
 	case NFT_RULE_ATTR_COMPAT_FLAGS:
 	case NFT_RULE_ATTR_POSITION:
@@ -133,9 +131,6 @@ void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data)
 	case NFT_RULE_ATTR_HANDLE:
 		r->handle = *((uint64_t *)data);
 		break;
-	case NFT_RULE_ATTR_FLAGS:
-		r->rule_flags = *((uint32_t *)data);
-		break;
 	case NFT_RULE_ATTR_COMPAT_PROTO:
 		r->compat.proto = *((uint32_t *)data);
 		break;
@@ -187,8 +182,6 @@ const void *nft_rule_attr_get(const struct nft_rule *r, uint16_t attr)
 		return r->chain;
 	case NFT_RULE_ATTR_HANDLE:
 		return &r->handle;
-	case NFT_RULE_ATTR_FLAGS:
-		return &r->rule_flags;
 	case NFT_RULE_ATTR_COMPAT_PROTO:
 		return &r->compat.proto;
 	case NFT_RULE_ATTR_COMPAT_FLAGS:
@@ -505,11 +498,6 @@ int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree)
 
 	nft_rule_attr_set_u64(r, NFT_RULE_ATTR_HANDLE, uval64);
 
-	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &uval32) < 0)
-		goto err;
-
-	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FLAGS, uval32);
-
 	if (nft_jansson_node_exist(root, "compat_proto") ||
 	    nft_jansson_node_exist(root, "compat_flags")) {
 		if (nft_jansson_parse_val(root, "compat_proto", NFT_TYPE_U32,
@@ -615,13 +603,6 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r)
 
 	r->flags |= (1 << NFT_RULE_ATTR_HANDLE);
 
-	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST,
-			       BASE_DEC, &r->rule_flags, NFT_TYPE_U32,
-			       NFT_XML_MAND) != 0)
-		return -1;
-
-	r->flags |= (1 << NFT_RULE_ATTR_FLAGS);
-
 	if (nft_mxml_num_parse(tree, "compat_proto", MXML_DESCEND_FIRST,
 			       BASE_DEC, &r->compat.proto, NFT_TYPE_U32,
 			       NFT_XML_OPT) >= 0)
@@ -711,9 +692,6 @@ static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
 		       (unsigned long long)r->handle);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "\"flags\":%u,", r->rule_flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
 	if (r->flags & (1 << NFT_RULE_ATTR_COMPAT_PROTO) ||
 	    r->flags & (1 << NFT_RULE_ATTR_COMPAT_FLAGS)) {
 		ret = snprintf(buf+offset, len, "\"compat_flags\":%u,"
@@ -759,9 +737,9 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 
 	ret = snprintf(buf, len, "<rule><family>%s</family>"
 		       "<table>%s</table><chain>%s</chain>"
-		       "<handle>%llu</handle><flags>%u</flags>",
+		       "<handle>%llu</handle>",
 		       nft_family2str(r->family), r->table, r->chain,
-		       (unsigned long long)r->handle, r->rule_flags);
+		       (unsigned long long)r->handle);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (r->compat.flags != 0 || r->compat.proto != 0) {
diff --git a/tests/jsonfiles/20-rule-bitwise.json b/tests/jsonfiles/20-rule-bitwise.json
index e1bf9a6..511ad88 100644
--- a/tests/jsonfiles/20-rule-bitwise.json
+++ b/tests/jsonfiles/20-rule-bitwise.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":20,"flags":0,"expr":[{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"data_reg":{"type":"value","len":4,"data0":"0x0000000a"}},"xor":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":20,"expr":[{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"data_reg":{"type":"value","len":4,"data0":"0x0000000a"}},"xor":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}}]}}
diff --git a/tests/jsonfiles/21-rule-byteorder.json b/tests/jsonfiles/21-rule-byteorder.json
index 3ad991d..9c5498e 100644
--- a/tests/jsonfiles/21-rule-byteorder.json
+++ b/tests/jsonfiles/21-rule-byteorder.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":21,"flags":0,"expr":[{"type":"byteorder","sreg":3,"dreg":4,"op":"hton","len":4,"size":4}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":21,"expr":[{"type":"byteorder","sreg":3,"dreg":4,"op":"hton","len":4,"size":4}]}}
diff --git a/tests/jsonfiles/22-rule-cmp.json b/tests/jsonfiles/22-rule-cmp.json
index e0a6fb6..ad1c71a 100644
--- a/tests/jsonfiles/22-rule-cmp.json
+++ b/tests/jsonfiles/22-rule-cmp.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"forward","handle":22,"flags":0,"expr":[{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x6e6f6200","data2":"0x2e303164","data3":"0x00393331"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"forward","handle":22,"expr":[{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x6e6f6200","data2":"0x2e303164","data3":"0x00393331"}}}]}}
diff --git a/tests/jsonfiles/23-rule-counter.json b/tests/jsonfiles/23-rule-counter.json
index ec95c0f..331ab2c 100644
--- a/tests/jsonfiles/23-rule-counter.json
+++ b/tests/jsonfiles/23-rule-counter.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":23,"flags":0,"expr":[{"type":"counter","pkts":135,"bytes":21655}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":23,"expr":[{"type":"counter","pkts":135,"bytes":21655}]}}
diff --git a/tests/jsonfiles/24-rule-ct.json b/tests/jsonfiles/24-rule-ct.json
index 9e73ff9..3b161f3 100644
--- a/tests/jsonfiles/24-rule-ct.json
+++ b/tests/jsonfiles/24-rule-ct.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":24,"flags":0,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000008"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":24,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000008"}}}]}}
diff --git a/tests/jsonfiles/25-rule-exthdr.json b/tests/jsonfiles/25-rule-exthdr.json
index b229b41..32667a3 100644
--- a/tests/jsonfiles/25-rule-exthdr.json
+++ b/tests/jsonfiles/25-rule-exthdr.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":25,"flags":0,"expr":[{"type":"exthdr","dreg":1,"exthdr_type":"mh","offset":2,"len":16}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":25,"expr":[{"type":"exthdr","dreg":1,"exthdr_type":"mh","offset":2,"len":16}]}}
diff --git a/tests/jsonfiles/26-rule-immediate.json b/tests/jsonfiles/26-rule-immediate.json
index 078ee27..fbe7f8b 100644
--- a/tests/jsonfiles/26-rule-immediate.json
+++ b/tests/jsonfiles/26-rule-immediate.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"flags":0,"expr":[{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}
diff --git a/tests/jsonfiles/27-rule-limit.json b/tests/jsonfiles/27-rule-limit.json
index 1f066b4..7e9b67d 100644
--- a/tests/jsonfiles/27-rule-limit.json
+++ b/tests/jsonfiles/27-rule-limit.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":27,"flags":0,"expr":[{"type":"limit","rate":321321,"depth":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":27,"expr":[{"type":"limit","rate":321321,"depth":0}]}}
diff --git a/tests/jsonfiles/28-rule-log.json b/tests/jsonfiles/28-rule-log.json
index 26b4f77..ad0ca8f 100644
--- a/tests/jsonfiles/28-rule-log.json
+++ b/tests/jsonfiles/28-rule-log.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":28,"flags":0,"expr":[{"type":"log","prefix":"test_chain","group":1,"snaplen":0,"qthreshold":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":28,"expr":[{"type":"log","prefix":"test_chain","group":1,"snaplen":0,"qthreshold":0}]}}
diff --git a/tests/jsonfiles/29-rule-match.json b/tests/jsonfiles/29-rule-match.json
index 49f30d2..78f087d 100644
--- a/tests/jsonfiles/29-rule-match.json
+++ b/tests/jsonfiles/29-rule-match.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":9,"flags":0,"expr":[{"type":"match","name":"state"},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":9,"expr":[{"type":"match","name":"state"},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/30-rule-lookup.json b/tests/jsonfiles/30-rule-lookup.json
index e2900c2..5dbf823 100644
--- a/tests/jsonfiles/30-rule-lookup.json
+++ b/tests/jsonfiles/30-rule-lookup.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":8,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":12,"len":4,"base":"network"},{"type":"lookup","set":"set0","sreg":1,"dreg":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":8,"expr":[{"type":"payload","dreg":1,"offset":12,"len":4,"base":"network"},{"type":"lookup","set":"set0","sreg":1,"dreg":0}]}}
diff --git a/tests/jsonfiles/31-rule-meta.json b/tests/jsonfiles/31-rule-meta.json
index 867b2d4..b52d29e 100644
--- a/tests/jsonfiles/31-rule-meta.json
+++ b/tests/jsonfiles/31-rule-meta.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":8,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":8,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/32-rule-nat4.json b/tests/jsonfiles/32-rule-nat4.json
index fa93d35..eb3ae5b 100644
--- a/tests/jsonfiles/32-rule-nat4.json
+++ b/tests/jsonfiles/32-rule-nat4.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":10,"flags":0,"expr":[{"type":"nat","nat_type":"dnat","family":"ip","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":10,"expr":[{"type":"nat","nat_type":"dnat","family":"ip","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}
diff --git a/tests/jsonfiles/33-rule-nat6.json b/tests/jsonfiles/33-rule-nat6.json
index b9df998..fae48d0 100644
--- a/tests/jsonfiles/33-rule-nat6.json
+++ b/tests/jsonfiles/33-rule-nat6.json
@@ -1 +1 @@
-{"rule":{"family":"ip6","table":"nat","chain":"output","handle":33,"flags":0,"expr":[{"type":"nat","nat_type":"snat","family":"ip6","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}
+{"rule":{"family":"ip6","table":"nat","chain":"output","handle":33,"expr":[{"type":"nat","nat_type":"snat","family":"ip6","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}
diff --git a/tests/jsonfiles/34-rule-payload.json b/tests/jsonfiles/34-rule-payload.json
index 1d0f2cd..3559ca6 100644
--- a/tests/jsonfiles/34-rule-payload.json
+++ b/tests/jsonfiles/34-rule-payload.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}
diff --git a/tests/jsonfiles/35-rule-target.json b/tests/jsonfiles/35-rule-target.json
index 0c93d5e..c8ff656 100644
--- a/tests/jsonfiles/35-rule-target.json
+++ b/tests/jsonfiles/35-rule-target.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"INPUT","handle":20,"flags":0,"expr":[{"type":"counter","pkts":17,"bytes":4436},{"type":"target","name":"LOG"}]}}
+{"rule":{"family":"ip","table":"filter","chain":"INPUT","handle":20,"expr":[{"type":"counter","pkts":17,"bytes":4436},{"type":"target","name":"LOG"}]}}
diff --git a/tests/jsonfiles/36-rule-real.json b/tests/jsonfiles/36-rule-real.json
index 6a1d705..c8bfc26 100644
--- a/tests/jsonfiles/36-rule-real.json
+++ b/tests/jsonfiles/36-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":36,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":36,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/37-rule-real.json b/tests/jsonfiles/37-rule-real.json
index 4abc7fb..d9b4580 100644
--- a/tests/jsonfiles/37-rule-real.json
+++ b/tests/jsonfiles/37-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":37,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":37,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}
diff --git a/tests/jsonfiles/38-rule-real.json b/tests/jsonfiles/38-rule-real.json
index 5b0e360..ce37407 100644
--- a/tests/jsonfiles/38-rule-real.json
+++ b/tests/jsonfiles/38-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":38,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":38,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}
diff --git a/tests/jsonfiles/39-rule-real.json b/tests/jsonfiles/39-rule-real.json
index 9232196..8529d06 100644
--- a/tests/jsonfiles/39-rule-real.json
+++ b/tests/jsonfiles/39-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":39,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"gte","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"cmp","sreg":1,"op":"lte","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0xfa00a8c0"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":39,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"gte","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"cmp","sreg":1,"op":"lte","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0xfa00a8c0"}}}]}}
diff --git a/tests/jsonfiles/40-rule-real.json b/tests/jsonfiles/40-rule-real.json
index 5db129e..f13c99e 100644
--- a/tests/jsonfiles/40-rule-real.json
+++ b/tests/jsonfiles/40-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":40,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":40,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/41-rule-real.json b/tests/jsonfiles/41-rule-real.json
index 2381378..ed23fc2 100644
--- a/tests/jsonfiles/41-rule-real.json
+++ b/tests/jsonfiles/41-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}
diff --git a/tests/jsonfiles/42-rule-real.json b/tests/jsonfiles/42-rule-real.json
index b265d69..6c305e1 100644
--- a/tests/jsonfiles/42-rule-real.json
+++ b/tests/jsonfiles/42-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":42,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":42,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]}}
diff --git a/tests/jsonfiles/43-rule-real.json b/tests/jsonfiles/43-rule-real.json
index 7b937ee..95d0333 100644
--- a/tests/jsonfiles/43-rule-real.json
+++ b/tests/jsonfiles/43-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":43,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":43,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/44-rule-real.json b/tests/jsonfiles/44-rule-real.json
index dee71d5..a838dbb 100644
--- a/tests/jsonfiles/44-rule-real.json
+++ b/tests/jsonfiles/44-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":44,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x16000004"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":44,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x16000004"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/45-rule-real.json b/tests/jsonfiles/45-rule-real.json
index ecce215..8b143d6 100644
--- a/tests/jsonfiles/45-rule-real.json
+++ b/tests/jsonfiles/45-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":45,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":45,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/46-rule-real.json b/tests/jsonfiles/46-rule-real.json
index fbd222a..28643c8 100644
--- a/tests/jsonfiles/46-rule-real.json
+++ b/tests/jsonfiles/46-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":46,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":46,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}
diff --git a/tests/jsonfiles/47-rule-real.json b/tests/jsonfiles/47-rule-real.json
index 4ea2988..8f68634 100644
--- a/tests/jsonfiles/47-rule-real.json
+++ b/tests/jsonfiles/47-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":47,"flags":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":47,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}
diff --git a/tests/jsonfiles/48-rule-real.json b/tests/jsonfiles/48-rule-real.json
index af67262..0cd835e 100644
--- a/tests/jsonfiles/48-rule-real.json
+++ b/tests/jsonfiles/48-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":48,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":48,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/49-rule-real.json b/tests/jsonfiles/49-rule-real.json
index c44c12c..445f46a 100644
--- a/tests/jsonfiles/49-rule-real.json
+++ b/tests/jsonfiles/49-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":49,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":49,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
diff --git a/tests/jsonfiles/50-rule-real.json b/tests/jsonfiles/50-rule-real.json
index 6ca0004..2722236 100644
--- a/tests/jsonfiles/50-rule-real.json
+++ b/tests/jsonfiles/50-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":50,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":50,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/51-rule-real.json b/tests/jsonfiles/51-rule-real.json
index 8032664..3161fa4 100644
--- a/tests/jsonfiles/51-rule-real.json
+++ b/tests/jsonfiles/51-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":51,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":51,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/52-rule-real.json b/tests/jsonfiles/52-rule-real.json
index 40efcb9..d4092c6 100644
--- a/tests/jsonfiles/52-rule-real.json
+++ b/tests/jsonfiles/52-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":52,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"oif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":52,"expr":[{"type":"meta","dreg":1,"key":"oif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/53-rule-real.json b/tests/jsonfiles/53-rule-real.json
index 631668b..526c9d3 100644
--- a/tests/jsonfiles/53-rule-real.json
+++ b/tests/jsonfiles/53-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":53,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"oifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":53,"expr":[{"type":"meta","dreg":1,"key":"oifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/54-rule-real.json b/tests/jsonfiles/54-rule-real.json
index 4f7448f..edb8c18 100644
--- a/tests/jsonfiles/54-rule-real.json
+++ b/tests/jsonfiles/54-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":54,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"skuid"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":54,"expr":[{"type":"meta","dreg":1,"key":"skuid"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/55-rule-real.json b/tests/jsonfiles/55-rule-real.json
index 3b299cb..a10fc0f 100644
--- a/tests/jsonfiles/55-rule-real.json
+++ b/tests/jsonfiles/55-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":55,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"skgid"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":55,"expr":[{"type":"meta","dreg":1,"key":"skgid"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/56-rule-real.json b/tests/jsonfiles/56-rule-real.json
index 05892a8..137e146 100644
--- a/tests/jsonfiles/56-rule-real.json
+++ b/tests/jsonfiles/56-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":56,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"secmark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":56,"expr":[{"type":"meta","dreg":1,"key":"secmark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
diff --git a/tests/jsonfiles/57-rule-real.json b/tests/jsonfiles/57-rule-real.json
index cbab7f0..8694ea1 100644
--- a/tests/jsonfiles/57-rule-real.json
+++ b/tests/jsonfiles/57-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":57,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":57,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/58-rule-real.json b/tests/jsonfiles/58-rule-real.json
index bbdc0a1..59237b6 100644
--- a/tests/jsonfiles/58-rule-real.json
+++ b/tests/jsonfiles/58-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":58,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00000008"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":58,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00000008"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
diff --git a/tests/jsonfiles/59-rule-real.json b/tests/jsonfiles/59-rule-real.json
index 9b2476e..d6245b2 100644
--- a/tests/jsonfiles/59-rule-real.json
+++ b/tests/jsonfiles/59-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":59,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":59,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
diff --git a/tests/jsonfiles/60-rule-real.json b/tests/jsonfiles/60-rule-real.json
index afd20ca..54d5288 100644
--- a/tests/jsonfiles/60-rule-real.json
+++ b/tests/jsonfiles/60-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":60,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":60,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/61-rule-real.json b/tests/jsonfiles/61-rule-real.json
index bfe7ed5..3942c3f 100644
--- a/tests/jsonfiles/61-rule-real.json
+++ b/tests/jsonfiles/61-rule-real.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"output","handle":61,"flags":0,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":61,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/xmlfiles/20-rule-bitwise.xml b/tests/xmlfiles/20-rule-bitwise.xml
index afe9671..9517db9 100644
--- a/tests/xmlfiles/20-rule-bitwise.xml
+++ b/tests/xmlfiles/20-rule-bitwise.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><flags>0</flags><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr></rule>
 <!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/21-rule-byteorder.xml b/tests/xmlfiles/21-rule-byteorder.xml
index 6c6faff..f8f13b6 100644
--- a/tests/xmlfiles/21-rule-byteorder.xml
+++ b/tests/xmlfiles/21-rule-byteorder.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>test</table><chain>test</chain><handle>1000</handle><flags>0</flags><expr type="byteorder"><sreg>3</sreg><dreg>4</dreg><op>hton</op><len>4</len><size>4</size></expr></rule>
+<rule><family>ip</family><table>test</table><chain>test</chain><handle>1000</handle><expr type="byteorder"><sreg>3</sreg><dreg>4</dreg><op>hton</op><len>4</len><size>4</size></expr></rule>
diff --git a/tests/xmlfiles/22-rule-cmp.xml b/tests/xmlfiles/22-rule-cmp.xml
index 3fe6b27..837d0de 100644
--- a/tests/xmlfiles/22-rule-cmp.xml
+++ b/tests/xmlfiles/22-rule-cmp.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><flags>0</flags><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></data_reg></cmpdata></expr></rule>
+<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></data_reg></cmpdata></expr></rule>
 <!-- nft add rule ip6 filter test meta iifname bond10.139 accept -->
diff --git a/tests/xmlfiles/23-rule-counter.xml b/tests/xmlfiles/23-rule-counter.xml
index a8d0937..77aba7a 100644
--- a/tests/xmlfiles/23-rule-counter.xml
+++ b/tests/xmlfiles/23-rule-counter.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>39</handle><flags>0</flags><expr type="counter"><pkts>3</pkts><bytes>177</bytes></expr></rule>
+<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>39</handle><expr type="counter"><pkts>3</pkts><bytes>177</bytes></expr></rule>
 <!-- nft add rule ip6 filter test udp dport 53 counter accept -->
diff --git a/tests/xmlfiles/24-rule-ct.xml b/tests/xmlfiles/24-rule-ct.xml
index 78c963f..814ab52 100644
--- a/tests/xmlfiles/24-rule-ct.xml
+++ b/tests/xmlfiles/24-rule-ct.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><flags>0</flags><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr></rule>
 <!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/25-rule-exthdr.xml b/tests/xmlfiles/25-rule-exthdr.xml
index 2c1c5e4..6bf139c 100644
--- a/tests/xmlfiles/25-rule-exthdr.xml
+++ b/tests/xmlfiles/25-rule-exthdr.xml
@@ -1 +1 @@
-<rule><family>ip6</family><table>filter</table><chain>INPUT</chain><handle>100</handle><flags>0</flags><expr type="exthdr"><dreg>1</dreg><exthdr_type>mh</exthdr_type><offset>2</offset><len>16</len></expr></rule>
+<rule><family>ip6</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="exthdr"><dreg>1</dreg><exthdr_type>mh</exthdr_type><offset>2</offset><len>16</len></expr></rule>
diff --git a/tests/xmlfiles/26-rule-immediate.xml b/tests/xmlfiles/26-rule-immediate.xml
index 2054b9f..2928142 100644
--- a/tests/xmlfiles/26-rule-immediate.xml
+++ b/tests/xmlfiles/26-rule-immediate.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><flags>0</flags><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule>
 <!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/27-rule-limit.xml b/tests/xmlfiles/27-rule-limit.xml
index aa81b4e..dca3a7c 100644
--- a/tests/xmlfiles/27-rule-limit.xml
+++ b/tests/xmlfiles/27-rule-limit.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><flags>0</flags><expr type="limit"><rate>123123</rate><depth>321321</depth></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="limit"><rate>123123</rate><depth>321321</depth></expr></rule>
diff --git a/tests/xmlfiles/28-rule-log.xml b/tests/xmlfiles/28-rule-log.xml
index e97edc7..d30e5fb 100644
--- a/tests/xmlfiles/28-rule-log.xml
+++ b/tests/xmlfiles/28-rule-log.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>96</handle><flags>0</flags><expr type="log"><prefix>test_chain</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule>
+<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>96</handle><expr type="log"><prefix>test_chain</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule>
 <!-- nft add rule ip6 filter test log prefix test_chain group 1 -->
diff --git a/tests/xmlfiles/29-rule-lookup.xml b/tests/xmlfiles/29-rule-lookup.xml
index 1618fd8..b08ccd3 100644
--- a/tests/xmlfiles/29-rule-lookup.xml
+++ b/tests/xmlfiles/29-rule-lookup.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>37</handle><flags>0</flags><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
+<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>37</handle><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
 <!-- nft add rule ip6 filter test ip6 saddr { ::2 , ::3 } drop -->
diff --git a/tests/xmlfiles/30-rule-match.xml b/tests/xmlfiles/30-rule-match.xml
index 7ea9c73..b4cf72b 100644
--- a/tests/xmlfiles/30-rule-match.xml
+++ b/tests/xmlfiles/30-rule-match.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><flags>0</flags><expr type="match"><name>state</name></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="match"><name>state</name></expr></rule>
diff --git a/tests/xmlfiles/31-rule-meta.xml b/tests/xmlfiles/31-rule-meta.xml
index 00ebe74..b38e430 100644
--- a/tests/xmlfiles/31-rule-meta.xml
+++ b/tests/xmlfiles/31-rule-meta.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>iifname</key></expr></rule>
+<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr></rule>
 <!-- nft add rule ip6 filter test meta iifname bond10.139 accept -->
diff --git a/tests/xmlfiles/32-rule-nat6.xml b/tests/xmlfiles/32-rule-nat6.xml
index 16dcfb0..81566ce 100644
--- a/tests/xmlfiles/32-rule-nat6.xml
+++ b/tests/xmlfiles/32-rule-nat6.xml
@@ -1 +1 @@
-<rule><family>ip6</family><table>nat</table><chain>OUTPUT</chain><handle>100</handle><flags>0</flags><expr type="nat"><type>snat</type><family>ip6</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule>
+<rule><family>ip6</family><table>nat</table><chain>OUTPUT</chain><handle>100</handle><expr type="nat"><type>snat</type><family>ip6</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule>
diff --git a/tests/xmlfiles/33-rule-nat4.xml b/tests/xmlfiles/33-rule-nat4.xml
index 8ac5238..0e495a8 100644
--- a/tests/xmlfiles/33-rule-nat4.xml
+++ b/tests/xmlfiles/33-rule-nat4.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><flags>0</flags><expr type="nat"><type>dnat</type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="nat"><type>dnat</type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule>
diff --git a/tests/xmlfiles/34-rule-payload.xml b/tests/xmlfiles/34-rule-payload.xml
index 8a37e8c..6c2da6a 100644
--- a/tests/xmlfiles/34-rule-payload.xml
+++ b/tests/xmlfiles/34-rule-payload.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>34</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr></rule>
+<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr></rule>
 <!-- nft add rule ip6 filter test tcp dport 22 accept -->
diff --git a/tests/xmlfiles/35-rule-target.xml b/tests/xmlfiles/35-rule-target.xml
index d0bba15..6925d96 100644
--- a/tests/xmlfiles/35-rule-target.xml
+++ b/tests/xmlfiles/35-rule-target.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><flags>0</flags><expr type="target"><name>LOG</name></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="target"><name>LOG</name></expr></rule>
diff --git a/tests/xmlfiles/36-rule-real.xml b/tests/xmlfiles/36-rule-real.xml
index 7b43dff..1c953e7 100644
--- a/tests/xmlfiles/36-rule-real.xml
+++ b/tests/xmlfiles/36-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule filter INPUT ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter -->
diff --git a/tests/xmlfiles/37-rule-real.xml b/tests/xmlfiles/37-rule-real.xml
index 327bc09..3c8ba13 100644
--- a/tests/xmlfiles/37-rule-real.xml
+++ b/tests/xmlfiles/37-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x000016
 00</data0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</data0></data
 _reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule>
 <!-- nft add rule filter INPUT meta iifname "eth0" tcp dport 22 ct state new,established counter log prefix testprefix group 1 -->
diff --git a/tests/xmlfiles/38-rule-real.xml b/tests/xmlfiles/38-rule-real.xml
index 4b0402c..6161425 100644
--- a/tests/xmlfiles/38-rule-real.xml
+++ b/tests/xmlfiles/38-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x0000bb01</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="i
 mmediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x0000bb01</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>
 0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule>
 <!-- nft add rule ip filter INPUT ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } tcp dport 443 counter accept -->
diff --git a/tests/xmlfiles/39-rule-real.xml b/tests/xmlfiles/39-rule-real.xml
index 3f7f2ab..fbf3d61 100644
--- a/tests/xmlfiles/39-rule-real.xml
+++ b/tests/xmlfiles/39-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></cmpdata></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg 
 type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></d
 ata_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_drop</prefix><group>2</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule>
+<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></cmpdata></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><le
 n>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdat
 a></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_drop</prefix><group>2</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule>
 <!-- nft add rule ip6 filter test meta iifname "bond0" meta oifname "bond1.27" ip6 saddr 2a00:9ac0:c1ca:27::150 udp dport 53 ct status expected counter log prefix dns_drop group 2 drop -->
diff --git a/tests/xmlfiles/40-rule-real.xml b/tests/xmlfiles/40-rule-real.xml
index 253008c..8e1d565 100644
--- a/tests/xmlfiles/40-rule-real.xml
+++ b/tests/xmlfiles/40-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr></rule>
 <!-- nft add rule filter output ip daddr 192.168.0.1 -->
diff --git a/tests/xmlfiles/41-rule-real.xml b/tests/xmlfiles/41-rule-real.xml
index 4b3498e..810267d 100644
--- a/tests/xmlfiles/41-rule-real.xml
+++ b/tests/xmlfiles/41-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><cmpdata><data_reg type="value"><len>4</len><data0>0xfa00a8c0</data0></data_reg></cmpdata></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><cmpdata><data_reg type="value"><len>4</len><data0>0xfa00a8c0</data0></data_reg></cmpdata></expr></rule>
 <!-- nft add rule filter output ip daddr 192.168.0.1-192.168.0.250 -->
diff --git a/tests/xmlfiles/42-rule-real.xml b/tests/xmlfiles/42-rule-real.xml
index 29f7ad9..6aba9eb 100644
--- a/tests/xmlfiles/42-rule-real.xml
+++ b/tests/xmlfiles/42-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule filter output ip daddr 192.168.0.1 counter -->
diff --git a/tests/xmlfiles/43-rule-real.xml b/tests/xmlfiles/43-rule-real.xml
index 7dc1fdf..7a2fe6b 100644
--- a/tests/xmlfiles/43-rule-real.xml
+++ b/tests/xmlfiles/43-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule>
 <!-- nft add rule filter output ip daddr 192.168.0.1 counter drop -->
diff --git a/tests/xmlfiles/44-rule-real.xml b/tests/xmlfiles/44-rule-real.xml
index feefb47..69bdca8 100644
--- a/tests/xmlfiles/44-rule-real.xml
+++ b/tests/xmlfiles/44-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>(null)</prefix><group>0</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>(null)</prefix><group>0</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule>
 <!-- nft add rule filter output ip daddr 192.168.0.1 counter log -->
diff --git a/tests/xmlfiles/45-rule-real.xml b/tests/xmlfiles/45-rule-real.xml
index d3ef55e..36837de 100644
--- a/tests/xmlfiles/45-rule-real.xml
+++ b/tests/xmlfiles/45-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule filter output tcp dport 22 counter -->
diff --git a/tests/xmlfiles/46-rule-real.xml b/tests/xmlfiles/46-rule-real.xml
index 33a6195..8465d0f 100644
--- a/tests/xmlfiles/46-rule-real.xml
+++ b/tests/xmlfiles/46-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x16000004</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x16000004</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule filter output tcp sport 1024 tcp dport 22 counter -->
diff --git a/tests/xmlfiles/47-rule-real.xml b/tests/xmlfiles/47-rule-real.xml
index e2c9901..39a09a5 100644
--- a/tests/xmlfiles/47-rule-real.xml
+++ b/tests/xmlfiles/47-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule filter output ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter -->
diff --git a/tests/xmlfiles/48-rule-real.xml b/tests/xmlfiles/48-rule-real.xml
index 0db61a7..89c5088 100644
--- a/tests/xmlfiles/48-rule-real.xml
+++ b/tests/xmlfiles/48-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule>
 <!-- nft add rule filter output tcp sequence 0 tcp sport 1024 tcp dport 22 -->
diff --git a/tests/xmlfiles/49-rule-real.xml b/tests/xmlfiles/49-rule-real.xml
index d8c987d..0896823 100644
--- a/tests/xmlfiles/49-rule-real.xml
+++ b/tests/xmlfiles/49-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule>
 <!-- nft add rule filter output tcp sport 1024 tcp dport 22 tcp sequence 0 -->
diff --git a/tests/xmlfiles/50-rule-real.xml b/tests/xmlfiles/50-rule-real.xml
index 71df769..1195131 100644
--- a/tests/xmlfiles/50-rule-real.xml
+++ b/tests/xmlfiles/50-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><flags>0</flags><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>0</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
 <!-- nft add rule filter output ct state new,established counter -->
diff --git a/tests/xmlfiles/51-rule-real.xml b/tests/xmlfiles/51-rule-real.xml
index 4a0a067..4064ffb 100644
--- a/tests/xmlfiles/51-rule-real.xml
+++ b/tests/xmlfiles/51-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><flags>0</flags><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule>
 <!-- nft add rule filter output ct direction original counter -->
diff --git a/tests/xmlfiles/52-rule-real.xml b/tests/xmlfiles/52-rule-real.xml
index 727bae7..6ee7459 100644
--- a/tests/xmlfiles/52-rule-real.xml
+++ b/tests/xmlfiles/52-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><flags>0</flags><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule>
 <!-- nft add rule filter output ct direction reply counter -->
diff --git a/tests/xmlfiles/53-rule-real.xml b/tests/xmlfiles/53-rule-real.xml
index 04a1ef2..ec4ea21 100644
--- a/tests/xmlfiles/53-rule-real.xml
+++ b/tests/xmlfiles/53-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><flags>0</flags><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule filter output ct status expected counter -->
diff --git a/tests/xmlfiles/54-rule-real.xml b/tests/xmlfiles/54-rule-real.xml
index 3096117..c80d43a 100644
--- a/tests/xmlfiles/54-rule-real.xml
+++ b/tests/xmlfiles/54-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><flags>0</flags><expr type="ct"><dreg>1</dreg><key>mark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000064</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000064</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft rule add filter output ct mark 100 counter -->
diff --git a/tests/xmlfiles/55-rule-real.xml b/tests/xmlfiles/55-rule-real.xml
index afd0d64..47f2e01 100644
--- a/tests/xmlfiles/55-rule-real.xml
+++ b/tests/xmlfiles/55-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><flags>0</flags><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
 <!-- nft add rule filter output ct secmark 0 counter -->
diff --git a/tests/xmlfiles/56-rule-real.xml b/tests/xmlfiles/56-rule-real.xml
index a974ee7..e4965e1 100644
--- a/tests/xmlfiles/56-rule-real.xml
+++ b/tests/xmlfiles/56-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><flags>0</flags><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0000001e</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0000001e</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule filter output ct expiration 30 counter -->
diff --git a/tests/xmlfiles/57-rule-real.xml b/tests/xmlfiles/57-rule-real.xml
index 2ade569..985b274 100644
--- a/tests/xmlfiles/57-rule-real.xml
+++ b/tests/xmlfiles/57-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><flags>0</flags><expr type="ct"><dreg>1</dreg><key>helper</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00707466</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>0</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00707466</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule filter output ct helper "ftp" counter -->
diff --git a/tests/xmlfiles/58-rule-real.xml b/tests/xmlfiles/58-rule-real.xml
index a776eed..4b456c1 100644
--- a/tests/xmlfiles/58-rule-real.xml
+++ b/tests/xmlfiles/58-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule ip filter output meta length 1000 counter -->
diff --git a/tests/xmlfiles/59-rule-real.xml b/tests/xmlfiles/59-rule-real.xml
index 616acef..603fe19 100644
--- a/tests/xmlfiles/59-rule-real.xml
+++ b/tests/xmlfiles/59-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00000008</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00000008</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
 <!-- nft add rule ip filter output meta protocol 0x0800 counter -->
diff --git a/tests/xmlfiles/60-rule-real.xml b/tests/xmlfiles/60-rule-real.xml
index 3e2f0c4..66a96fe 100644
--- a/tests/xmlfiles/60-rule-real.xml
+++ b/tests/xmlfiles/60-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
 <!-- nft add rule ip filter output meta mark 0 counter -->
diff --git a/tests/xmlfiles/61-rule-real.xml b/tests/xmlfiles/61-rule-real.xml
index 489b138..5c1340c 100644
--- a/tests/xmlfiles/61-rule-real.xml
+++ b/tests/xmlfiles/61-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule ip filter output meta iif lo counter -->
diff --git a/tests/xmlfiles/62-rule-real.xml b/tests/xmlfiles/62-rule-real.xml
index 53484fe..6a6d381 100644
--- a/tests/xmlfiles/62-rule-real.xml
+++ b/tests/xmlfiles/62-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule ip filter output meta iifname "eth0" counter -->
diff --git a/tests/xmlfiles/63-rule-real.xml b/tests/xmlfiles/63-rule-real.xml
index d0158b5..baa13a7 100644
--- a/tests/xmlfiles/63-rule-real.xml
+++ b/tests/xmlfiles/63-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule ip filter output meta oif lo counter -->
diff --git a/tests/xmlfiles/64-rule-real.xml b/tests/xmlfiles/64-rule-real.xml
index d07c767..157773f 100644
--- a/tests/xmlfiles/64-rule-real.xml
+++ b/tests/xmlfiles/64-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule ip filter output meta oifname "eth0" counter -->
diff --git a/tests/xmlfiles/65-rule-real.xml b/tests/xmlfiles/65-rule-real.xml
index 3cf3059..06c560b 100644
--- a/tests/xmlfiles/65-rule-real.xml
+++ b/tests/xmlfiles/65-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule ip filter output meta skuid 1000 counter -->
diff --git a/tests/xmlfiles/66-rule-real.xml b/tests/xmlfiles/66-rule-real.xml
index 137c257..9a5b721 100644
--- a/tests/xmlfiles/66-rule-real.xml
+++ b/tests/xmlfiles/66-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule ip filter output meta skgid 1000 counter -->
diff --git a/tests/xmlfiles/67-rule-real.xml b/tests/xmlfiles/67-rule-real.xml
index ca3d790..a3cbc2d 100644
--- a/tests/xmlfiles/67-rule-real.xml
+++ b/tests/xmlfiles/67-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><flags>0</flags><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule>
 <!-- nft add rule ip filter output meta secmark 0 counter -->
diff --git a/tests/xmlfiles/68-rule-real.xml b/tests/xmlfiles/68-rule-real.xml
index 0c27fcf..7023e59 100644
--- a/tests/xmlfiles/68-rule-real.xml
+++ b/tests/xmlfiles/68-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule>
 <!-- nft add rule filter output tcp dport { 22, 23 } counter -->
diff --git a/tests/xmlfiles/69-rule-real.xml b/tests/xmlfiles/69-rule-real.xml
index a1a6467..dc2728e 100644
--- a/tests/xmlfiles/69-rule-real.xml
+++ b/tests/xmlfiles/69-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>33</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set1</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>33</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set1</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
 <!-- nft add rule ip filter output ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } -->
diff --git a/tests/xmlfiles/70-rule-real.xml b/tests/xmlfiles/70-rule-real.xml
index 3f39542..64834d4 100644
--- a/tests/xmlfiles/70-rule-real.xml
+++ b/tests/xmlfiles/70-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
 <!-- nft add rule ip filter output tcp dport vmap { 22 => jump chain1, 23 => jump chain2, } -->
diff --git a/tests/xmlfiles/71-rule-real.xml b/tests/xmlfiles/71-rule-real.xml
index f1c9fd7..e10437a 100644
--- a/tests/xmlfiles/71-rule-real.xml
+++ b/tests/xmlfiles/71-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
 <!-- nft add rule ip filter output tcp dport vmap { 22 => accept, 23 => drop, } -->
diff --git a/tests/xmlfiles/72-rule-real.xml b/tests/xmlfiles/72-rule-real.xml
index 255d567..ccda1fe 100644
--- a/tests/xmlfiles/72-rule-real.xml
+++ b/tests/xmlfiles/72-rule-real.xml
@@ -1,2 +1,2 @@
-<rule><family>ip</family><table>filter</table><chain>output</chain><handle>36</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>map2</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>output</chain><handle>36</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>map2</set><sreg>1</sreg><dreg>0</dreg></expr></rule>
 <!-- nft add rule ip filter output ip daddr vmap { 192.168.1.1 => accept, 192.168.1.2 => drop, } -->
-- 
1.7.10.4

