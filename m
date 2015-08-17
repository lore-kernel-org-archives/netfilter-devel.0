From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 2/3] expr: limit: add burst attribute
Date: Mon, 17 Aug 2015 04:24:17 +0200
Message-ID: <1439778258-7546-2-git-send-email-pablo@netfilter.org>
References: <1439778258-7546-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55921 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbbHQCTr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 22:19:47 -0400
In-Reply-To: <1439778258-7546-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/buffer.h                    |    1 +
 include/libnftnl/expr.h             |    1 +
 include/linux/netfilter/nf_tables.h |    2 ++
 src/expr/limit.c                    |   32 ++++++++++++++++++++++++++++----
 tests/nft-expr_limit-test.c         |    4 ++++
 5 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/buffer.h b/include/buffer.h
index 38b6136..08e697c 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -38,6 +38,7 @@ int nft_buf_reg(struct nft_buf *b, int type, union nft_data_reg *reg,
 
 #define BASE			"base"
 #define BYTES			"bytes"
+#define BURST			"burst"
 #define CHAIN			"chain"
 #define CODE			"code"
 #define DATA			"data"
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 91875ff..730c9b9 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -150,6 +150,7 @@ enum {
 enum {
 	NFT_EXPR_LIMIT_RATE	= NFT_RULE_EXPR_ATTR_BASE,
 	NFT_EXPR_LIMIT_UNIT,
+	NFT_EXPR_LIMIT_BURST,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index cf4a1ce..e188ad2 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -761,11 +761,13 @@ enum nft_ct_attributes {
  *
  * @NFTA_LIMIT_RATE: refill rate (NLA_U64)
  * @NFTA_LIMIT_UNIT: refill unit (NLA_U64)
+ * @NFTA_LIMIT_BURST: burst (NLA_U32)
  */
 enum nft_limit_attributes {
 	NFTA_LIMIT_UNSPEC,
 	NFTA_LIMIT_RATE,
 	NFTA_LIMIT_UNIT,
+	NFTA_LIMIT_BURST,
 	__NFTA_LIMIT_MAX
 };
 #define NFTA_LIMIT_MAX		(__NFTA_LIMIT_MAX - 1)
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 3ad246e..5ac70c5 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -25,6 +25,7 @@
 struct nft_expr_limit {
 	uint64_t		rate;
 	uint64_t		unit;
+	uint32_t		burst;
 };
 
 static int
@@ -40,6 +41,9 @@ nft_rule_expr_limit_set(struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_LIMIT_UNIT:
 		limit->unit = *((uint64_t *)data);
 		break;
+	case NFT_EXPR_LIMIT_BURST:
+		limit->burst = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -59,6 +63,9 @@ nft_rule_expr_limit_get(const struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_LIMIT_UNIT:
 		*data_len = sizeof(uint64_t);
 		return &limit->unit;
+	case NFT_EXPR_LIMIT_BURST:
+		*data_len = sizeof(uint32_t);
+		return &limit->burst;
 	}
 	return NULL;
 }
@@ -77,6 +84,10 @@ static int nft_rule_expr_limit_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
 			abi_breakage();
 		break;
+	case NFTA_LIMIT_BURST:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -92,6 +103,8 @@ nft_rule_expr_limit_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 		mnl_attr_put_u64(nlh, NFTA_LIMIT_RATE, htobe64(limit->rate));
 	if (e->flags & (1 << NFT_EXPR_LIMIT_UNIT))
 		mnl_attr_put_u64(nlh, NFTA_LIMIT_UNIT, htobe64(limit->unit));
+	if (e->flags & (1 << NFT_EXPR_LIMIT_BURST))
+		mnl_attr_put_u32(nlh, NFTA_LIMIT_BURST, htonl(limit->burst));
 }
 
 static int
@@ -111,6 +124,10 @@ nft_rule_expr_limit_parse(struct nft_rule_expr *e, struct nlattr *attr)
 		limit->unit = be64toh(mnl_attr_get_u64(tb[NFTA_LIMIT_UNIT]));
 		e->flags |= (1 << NFT_EXPR_LIMIT_UNIT);
 	}
+	if (tb[NFTA_LIMIT_BURST]) {
+		limit->burst = ntohl(mnl_attr_get_u32(tb[NFTA_LIMIT_BURST]));
+		e->flags |= (1 << NFT_EXPR_LIMIT_BURST);
+	}
 
 	return 0;
 }
@@ -120,12 +137,14 @@ static int nft_rule_expr_limit_json_parse(struct nft_rule_expr *e, json_t *root,
 {
 #ifdef JSON_PARSING
 	uint64_t uval64;
+	uint32_t uval32;
 
 	if (nft_jansson_parse_val(root, "rate", NFT_TYPE_U64, &uval64, err) == 0)
 		nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_RATE, uval64);
-
 	if (nft_jansson_parse_val(root, "unit", NFT_TYPE_U64, &uval64, err) == 0)
 		nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_UNIT, uval64);
+	if (nft_jansson_parse_val(root, "burst", NFT_TYPE_U32, &uval32, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LIMIT_BURST, uval32);
 
 	return 0;
 #else
@@ -140,14 +159,17 @@ static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e,
 {
 #ifdef XML_PARSING
 	uint64_t rate, unit;
+	uint32_t burst;
 
 	if (nft_mxml_num_parse(tree, "rate", MXML_DESCEND_FIRST, BASE_DEC,
 			       &rate, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
 		nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_RATE, rate);
-
 	if (nft_mxml_num_parse(tree, "unit", MXML_DESCEND_FIRST, BASE_DEC,
 			       &unit, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
 		nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_UNIT, unit);
+	if (nft_mxml_num_parse(tree, "burst", MXML_DESCEND_FIRST, BASE_DEC,
+			       &burst, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LIMIT_BURST, burst);
 
 	return 0;
 #else
@@ -178,6 +200,8 @@ static int nft_rule_expr_limit_export(char *buf, size_t size,
 		nft_buf_u64(&b, type, limit->rate, RATE);
 	if (e->flags & (1 << NFT_EXPR_LIMIT_UNIT))
 		nft_buf_u64(&b, type, limit->unit, UNIT);
+	if (e->flags & (1 << NFT_EXPR_LIMIT_BURST))
+		nft_buf_u32(&b, type, limit->burst, BURST);
 
 	return nft_buf_done(&b);
 }
@@ -187,8 +211,8 @@ static int nft_rule_expr_limit_snprintf_default(char *buf, size_t len,
 {
 	struct nft_expr_limit *limit = nft_expr_data(e);
 
-	return snprintf(buf, len, "rate %"PRIu64"/%s ",
-			limit->rate, get_unit(limit->unit));
+	return snprintf(buf, len, "rate %"PRIu64"/%s burst %u ",
+			limit->rate, get_unit(limit->unit), limit->burst);
 }
 
 static int
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
index 38c3e5b..f86a78d 100644
--- a/tests/nft-expr_limit-test.c
+++ b/tests/nft-expr_limit-test.c
@@ -37,6 +37,9 @@ static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
 	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_LIMIT_UNIT) !=
 	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_LIMIT_UNIT))
 		print_err("Expr CTR_PACKET mismatches");
+	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_LIMIT_BURST) !=
+	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_LIMIT_BURST))
+		print_err("Expr CTR_PACKET mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -58,6 +61,7 @@ int main(int argc, char *argv[])
 
 	nft_rule_expr_set_u64(ex, NFT_EXPR_LIMIT_RATE, 0x123456789abcdef0);
 	nft_rule_expr_set_u64(ex, NFT_EXPR_LIMIT_UNIT, 0x123456789abcdef0);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_LIMIT_BURST, 0x89123456);
 
 	nft_rule_add_expr(a, ex);
 
-- 
1.7.10.4

