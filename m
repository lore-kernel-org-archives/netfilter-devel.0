From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 3/3] expr: limit: add per-byte limiting support
Date: Mon, 17 Aug 2015 04:24:18 +0200
Message-ID: <1439778258-7546-3-git-send-email-pablo@netfilter.org>
References: <1439778258-7546-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55926 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbbHQCTu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 22:19:50 -0400
In-Reply-To: <1439778258-7546-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |    1 +
 include/linux/netfilter/nf_tables.h |    7 ++++++
 src/expr/limit.c                    |   40 ++++++++++++++++++++++++++++++++---
 tests/nft-expr_limit-test.c         |    4 ++++
 4 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 730c9b9..0d01c29 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -151,6 +151,7 @@ enum {
 	NFT_EXPR_LIMIT_RATE	= NFT_RULE_EXPR_ATTR_BASE,
 	NFT_EXPR_LIMIT_UNIT,
 	NFT_EXPR_LIMIT_BURST,
+	NFT_EXPR_LIMIT_TYPE,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e188ad2..b977192 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -756,18 +756,25 @@ enum nft_ct_attributes {
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
 
+enum nft_limit_type {
+	NFT_LIMIT_PKTS,
+	NFT_LIMIT_BYTES
+};
+
 /**
  * enum nft_limit_attributes - nf_tables limit expression netlink attributes
  *
  * @NFTA_LIMIT_RATE: refill rate (NLA_U64)
  * @NFTA_LIMIT_UNIT: refill unit (NLA_U64)
  * @NFTA_LIMIT_BURST: burst (NLA_U32)
+ * @NFTA_LIMIT_TYPE: type of limit (NLA_U32: enum nft_limit_type)
  */
 enum nft_limit_attributes {
 	NFTA_LIMIT_UNSPEC,
 	NFTA_LIMIT_RATE,
 	NFTA_LIMIT_UNIT,
 	NFTA_LIMIT_BURST,
+	NFTA_LIMIT_TYPE,
 	__NFTA_LIMIT_MAX
 };
 #define NFTA_LIMIT_MAX		(__NFTA_LIMIT_MAX - 1)
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 5ac70c5..087041e 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -26,6 +26,7 @@ struct nft_expr_limit {
 	uint64_t		rate;
 	uint64_t		unit;
 	uint32_t		burst;
+	enum nft_limit_type	type;
 };
 
 static int
@@ -44,6 +45,9 @@ nft_rule_expr_limit_set(struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_LIMIT_BURST:
 		limit->burst = *((uint32_t *)data);
 		break;
+	case NFT_EXPR_LIMIT_TYPE:
+		limit->type = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -66,6 +70,9 @@ nft_rule_expr_limit_get(const struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_LIMIT_BURST:
 		*data_len = sizeof(uint32_t);
 		return &limit->burst;
+	case NFT_EXPR_LIMIT_TYPE:
+		*data_len = sizeof(uint32_t);
+		return &limit->type;
 	}
 	return NULL;
 }
@@ -85,6 +92,7 @@ static int nft_rule_expr_limit_cb(const struct nlattr *attr, void *data)
 			abi_breakage();
 		break;
 	case NFTA_LIMIT_BURST:
+	case NFTA_LIMIT_TYPE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -105,6 +113,8 @@ nft_rule_expr_limit_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 		mnl_attr_put_u64(nlh, NFTA_LIMIT_UNIT, htobe64(limit->unit));
 	if (e->flags & (1 << NFT_EXPR_LIMIT_BURST))
 		mnl_attr_put_u32(nlh, NFTA_LIMIT_BURST, htonl(limit->burst));
+	if (e->flags & (1 << NFT_EXPR_LIMIT_TYPE))
+		mnl_attr_put_u32(nlh, NFTA_LIMIT_TYPE, htonl(limit->type));
 }
 
 static int
@@ -128,6 +138,10 @@ nft_rule_expr_limit_parse(struct nft_rule_expr *e, struct nlattr *attr)
 		limit->burst = ntohl(mnl_attr_get_u32(tb[NFTA_LIMIT_BURST]));
 		e->flags |= (1 << NFT_EXPR_LIMIT_BURST);
 	}
+	if (tb[NFTA_LIMIT_TYPE]) {
+		limit->type = ntohl(mnl_attr_get_u32(tb[NFTA_LIMIT_TYPE]));
+		e->flags |= (1 << NFT_EXPR_LIMIT_TYPE);
+	}
 
 	return 0;
 }
@@ -145,6 +159,8 @@ static int nft_rule_expr_limit_json_parse(struct nft_rule_expr *e, json_t *root,
 		nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_UNIT, uval64);
 	if (nft_jansson_parse_val(root, "burst", NFT_TYPE_U32, &uval32, err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_LIMIT_BURST, uval32);
+	if (nft_jansson_parse_val(root, "type", NFT_TYPE_U32, &uval32, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LIMIT_TYPE, uval32);
 
 	return 0;
 #else
@@ -159,7 +175,7 @@ static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e,
 {
 #ifdef XML_PARSING
 	uint64_t rate, unit;
-	uint32_t burst;
+	uint32_t burst, type;
 
 	if (nft_mxml_num_parse(tree, "rate", MXML_DESCEND_FIRST, BASE_DEC,
 			       &rate, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
@@ -170,6 +186,9 @@ static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e,
 	if (nft_mxml_num_parse(tree, "burst", MXML_DESCEND_FIRST, BASE_DEC,
 			       &burst, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_LIMIT_BURST, burst);
+	if (nft_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
+			       &burst, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LIMIT_TYPE, type);
 
 	return 0;
 #else
@@ -202,17 +221,32 @@ static int nft_rule_expr_limit_export(char *buf, size_t size,
 		nft_buf_u64(&b, type, limit->unit, UNIT);
 	if (e->flags & (1 << NFT_EXPR_LIMIT_BURST))
 		nft_buf_u32(&b, type, limit->burst, BURST);
+	if (e->flags & (1 << NFT_EXPR_LIMIT_TYPE))
+		nft_buf_u32(&b, type, limit->type, TYPE);
 
 	return nft_buf_done(&b);
 }
 
+static const char *limit_to_type(enum nft_limit_type type)
+{
+	switch (type) {
+	default:
+	case NFT_LIMIT_PKTS:
+		return "packets";
+	case NFT_LIMIT_BYTES:
+		return "bytes";
+	}
+	return "unknown";
+}
+
 static int nft_rule_expr_limit_snprintf_default(char *buf, size_t len,
 						struct nft_rule_expr *e)
 {
 	struct nft_expr_limit *limit = nft_expr_data(e);
 
-	return snprintf(buf, len, "rate %"PRIu64"/%s burst %u ",
-			limit->rate, get_unit(limit->unit), limit->burst);
+	return snprintf(buf, len, "rate %"PRIu64"/%s burst %u type %s ",
+			limit->rate, get_unit(limit->unit), limit->burst,
+			limit_to_type(limit->type));
 }
 
 static int
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
index f86a78d..1c272ba 100644
--- a/tests/nft-expr_limit-test.c
+++ b/tests/nft-expr_limit-test.c
@@ -40,6 +40,9 @@ static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
 	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_LIMIT_BURST) !=
 	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_LIMIT_BURST))
 		print_err("Expr CTR_PACKET mismatches");
+	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_LIMIT_TYPE) !=
+	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_LIMIT_TYPE))
+		print_err("Expr TYPE mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -62,6 +65,7 @@ int main(int argc, char *argv[])
 	nft_rule_expr_set_u64(ex, NFT_EXPR_LIMIT_RATE, 0x123456789abcdef0);
 	nft_rule_expr_set_u64(ex, NFT_EXPR_LIMIT_UNIT, 0x123456789abcdef0);
 	nft_rule_expr_set_u32(ex, NFT_EXPR_LIMIT_BURST, 0x89123456);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_LIMIT_TYPE, 0xdef01234);
 
 	nft_rule_add_expr(a, ex);
 
-- 
1.7.10.4

