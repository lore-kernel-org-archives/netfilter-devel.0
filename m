From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] expr: limit: add support for flags
Date: Mon, 11 Jan 2016 19:38:24 +0100
Message-ID: <1452537504-7826-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48927 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933187AbcAKSie (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jan 2016 13:38:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D29D8E3A07
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:38:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B7542DA808
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:38:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 700AADA8E8
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:38:28 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  6 ++++++
 src/expr/limit.c                    | 28 ++++++++++++++++++++++++----
 tests/nft-expr_limit-test.c         |  4 ++++
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 7093759..9487b02 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -155,6 +155,7 @@ enum {
 	NFTNL_EXPR_LIMIT_UNIT,
 	NFTNL_EXPR_LIMIT_BURST,
 	NFTNL_EXPR_LIMIT_TYPE,
+	NFTNL_EXPR_LIMIT_FLAGS,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 1002530..2259ea9 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -778,6 +778,10 @@ enum nft_limit_type {
 	NFT_LIMIT_PKT_BYTES
 };
 
+enum nft_limit_flags {
+	NFT_LIMIT_F_INV = (1 << 0),
+};
+
 /**
  * enum nft_limit_attributes - nf_tables limit expression netlink attributes
  *
@@ -785,6 +789,7 @@ enum nft_limit_type {
  * @NFTA_LIMIT_UNIT: refill unit (NLA_U64)
  * @NFTA_LIMIT_BURST: burst (NLA_U32)
  * @NFTA_LIMIT_TYPE: type of limit (NLA_U32: enum nft_limit_type)
+ * @NFTA_LIMIT_FLAGS: flags (NLA_U32: enum nft_limit_flags)
  */
 enum nft_limit_attributes {
 	NFTA_LIMIT_UNSPEC,
@@ -792,6 +797,7 @@ enum nft_limit_attributes {
 	NFTA_LIMIT_UNIT,
 	NFTA_LIMIT_BURST,
 	NFTA_LIMIT_TYPE,
+	NFTA_LIMIT_FLAGS,
 	__NFTA_LIMIT_MAX
 };
 #define NFTA_LIMIT_MAX		(__NFTA_LIMIT_MAX - 1)
diff --git a/src/expr/limit.c b/src/expr/limit.c
index ab9ceff..e9cdbb7 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -27,6 +27,7 @@ struct nftnl_expr_limit {
 	uint64_t		unit;
 	uint32_t		burst;
 	enum nft_limit_type	type;
+	uint32_t		flags;
 };
 
 static int
@@ -48,6 +49,9 @@ nftnl_expr_limit_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_LIMIT_TYPE:
 		limit->type = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_LIMIT_FLAGS:
+		limit->flags = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -73,6 +77,9 @@ nftnl_expr_limit_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_LIMIT_TYPE:
 		*data_len = sizeof(uint32_t);
 		return &limit->type;
+	case NFTNL_EXPR_LIMIT_FLAGS:
+		*data_len = sizeof(uint32_t);
+		return &limit->flags;
 	}
 	return NULL;
 }
@@ -93,6 +100,7 @@ static int nftnl_expr_limit_cb(const struct nlattr *attr, void *data)
 		break;
 	case NFTA_LIMIT_BURST:
 	case NFTA_LIMIT_TYPE:
+	case NFTA_LIMIT_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -115,6 +123,8 @@ nftnl_expr_limit_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_LIMIT_BURST, htonl(limit->burst));
 	if (e->flags & (1 << NFTNL_EXPR_LIMIT_TYPE))
 		mnl_attr_put_u32(nlh, NFTA_LIMIT_TYPE, htonl(limit->type));
+	if (e->flags & (1 << NFTNL_EXPR_LIMIT_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_LIMIT_FLAGS, htonl(limit->flags));
 }
 
 static int
@@ -142,6 +152,10 @@ nftnl_expr_limit_parse(struct nftnl_expr *e, struct nlattr *attr)
 		limit->type = ntohl(mnl_attr_get_u32(tb[NFTA_LIMIT_TYPE]));
 		e->flags |= (1 << NFTNL_EXPR_LIMIT_TYPE);
 	}
+	if (tb[NFTA_LIMIT_FLAGS]) {
+		limit->flags = ntohl(mnl_attr_get_u32(tb[NFTA_LIMIT_FLAGS]));
+		e->flags |= (1 << NFTNL_EXPR_LIMIT_FLAGS);
+	}
 
 	return 0;
 }
@@ -162,6 +176,8 @@ static int nftnl_expr_limit_json_parse(struct nftnl_expr *e, json_t *root,
 		nftnl_expr_set_u32(e, NFTNL_EXPR_LIMIT_BURST, uval32);
 	if (nftnl_jansson_parse_val(root, "type", NFTNL_TYPE_U32, &uval32, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_LIMIT_TYPE, uval32);
+	if (nftnl_jansson_parse_val(root, "flags", NFTNL_TYPE_U32, &uval32, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_LIMIT_FLAGS, uval32);
 
 	return 0;
 #else
@@ -176,7 +192,7 @@ static int nftnl_expr_limit_xml_parse(struct nftnl_expr *e,
 {
 #ifdef XML_PARSING
 	uint64_t rate, unit;
-	uint32_t burst, type;
+	uint32_t burst, type, flags;
 
 	if (nftnl_mxml_num_parse(tree, "rate", MXML_DESCEND_FIRST, BASE_DEC,
 			       &rate, NFTNL_TYPE_U64, NFTNL_XML_MAND, err) == 0)
@@ -191,6 +207,9 @@ static int nftnl_expr_limit_xml_parse(struct nftnl_expr *e,
 	if (nftnl_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
 			       &type, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_LIMIT_TYPE, type);
+	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
+			       &flags, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_LIMIT_FLAGS, flags);
 
 	return 0;
 #else
@@ -225,6 +244,8 @@ static int nftnl_expr_limit_export(char *buf, size_t size,
 		nftnl_buf_u32(&b, type, limit->burst, BURST);
 	if (e->flags & (1 << NFTNL_EXPR_LIMIT_TYPE))
 		nftnl_buf_u32(&b, type, limit->type, TYPE);
+	if (e->flags & (1 << NFTNL_EXPR_LIMIT_FLAGS))
+		nftnl_buf_u32(&b, type, limit->flags, FLAGS);
 
 	return nftnl_buf_done(&b);
 }
@@ -246,16 +267,15 @@ static int nftnl_expr_limit_snprintf_default(char *buf, size_t len,
 {
 	struct nftnl_expr_limit *limit = nftnl_expr_data(e);
 
-	return snprintf(buf, len, "rate %"PRIu64"/%s burst %u type %s ",
+	return snprintf(buf, len, "rate %"PRIu64"/%s burst %u type %s flags %x ",
 			limit->rate, get_unit(limit->unit), limit->burst,
-			limit_to_type(limit->type));
+			limit_to_type(limit->type), limit->flags);
 }
 
 static int
 nftnl_expr_limit_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, struct nftnl_expr *e)
 {
-
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_limit_snprintf_default(buf, len, e);
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
index bbc82c1..29fb489 100644
--- a/tests/nft-expr_limit-test.c
+++ b/tests/nft-expr_limit-test.c
@@ -43,6 +43,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u64(rule_a, NFTNL_EXPR_LIMIT_TYPE) !=
 	    nftnl_expr_get_u64(rule_b, NFTNL_EXPR_LIMIT_TYPE))
 		print_err("Expr TYPE mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LIMIT_FLAGS) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LIMIT_FLAGS))
+		print_err("Expr FLAGS mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -66,6 +69,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set_u64(ex, NFTNL_EXPR_LIMIT_UNIT, 0x123456789abcdef0);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LIMIT_BURST, 0x89123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LIMIT_TYPE, 0xdef01234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_LIMIT_FLAGS, 0xdef01234);
 
 	nftnl_rule_add_expr(a, ex);
 
-- 
2.1.4

