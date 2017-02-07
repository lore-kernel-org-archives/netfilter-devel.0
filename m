From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nf-next 1/1] src: add TCP option matching requirements
Date: Tue,  7 Feb 2017 03:15:18 +0100
Message-ID: <20170207021518.22622-2-mm@skelett.io>
References: <20170207021518.22622-1-mm@skelett.io>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:51641 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751728AbdBGCTx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:53 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id 69A24B02BB
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:15:29 -0500 (EST)
In-Reply-To: <20170207021518.22622-1-mm@skelett.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is a requirement of the TCP option patch.

Signed-off-by: Manuel Messner <mm@skelett.io>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h | 17 ++++++++++++-
 src/expr/exthdr.c                   | 49 ++++++++++++++++++++++++++++++++++---
 3 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 38a4b83..f5e9cc1 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -156,6 +156,7 @@ enum {
 	NFTNL_EXPR_EXTHDR_TYPE,
 	NFTNL_EXPR_EXTHDR_OFFSET,
 	NFTNL_EXPR_EXTHDR_LEN,
+	NFTNL_EXPR_EXTHDR_OP,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b00a05d..6c0c9ef 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -705,12 +705,13 @@ enum nft_payload_attributes {
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
 
 /**
- * enum nft_exthdr_attributes - nf_tables IPv6 extension header expression netlink attributes
+ * enum nft_exthdr_attributes - nf_tables extension header expression netlink attributes
  *
  * @NFTA_EXTHDR_DREG: destination register (NLA_U32: nft_registers)
  * @NFTA_EXTHDR_TYPE: extension header type (NLA_U8)
  * @NFTA_EXTHDR_OFFSET: extension header offset (NLA_U32)
  * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
+ * @NFTA_EXTHDR_OP: option match type (NLA_U8)
  */
 enum nft_exthdr_attributes {
 	NFTA_EXTHDR_UNSPEC,
@@ -718,11 +719,25 @@ enum nft_exthdr_attributes {
 	NFTA_EXTHDR_TYPE,
 	NFTA_EXTHDR_OFFSET,
 	NFTA_EXTHDR_LEN,
+	NFTA_EXTHDR_OP,
 	__NFTA_EXTHDR_MAX
 };
 #define NFTA_EXTHDR_MAX		(__NFTA_EXTHDR_MAX - 1)
 
 /**
+ * enum nft_exthdr_op - nf_tables match options
+ *
+ * @NFT_EXTHDR_OP_IPV6: match against ipv6 extension headers
+ * @NFT_EXTHDR_OP_TCP: match against tcp options
+ */
+enum nft_exthdr_op {
+	NFT_EXTHDR_OP_IPV6,
+	NFT_EXTHDR_OP_TCPOPT,
+	__NFT_EXTHDR_OP_MAX
+};
+#define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
+
+/**
  * enum nft_meta_keys - nf_tables meta expression keys
  *
  * @NFT_META_LEN: packet length (skb->len)
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index b164e3f..a64c1bb 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -33,6 +33,7 @@ struct nftnl_expr_exthdr {
 	uint32_t		offset;
 	uint32_t		len;
 	uint8_t			type;
+	uint32_t		op;
 };
 
 static int
@@ -54,6 +55,9 @@ nftnl_expr_exthdr_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_EXTHDR_LEN:
 		exthdr->len = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_EXTHDR_OP:
+		exthdr->op = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -79,6 +83,9 @@ nftnl_expr_exthdr_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_EXTHDR_LEN:
 		*data_len = sizeof(exthdr->len);
 		return &exthdr->len;
+	case NFTNL_EXPR_EXTHDR_OP:
+		*data_len = sizeof(exthdr->op);
+		return &exthdr->op;
 	}
 	return NULL;
 }
@@ -99,6 +106,7 @@ static int nftnl_expr_exthdr_cb(const struct nlattr *attr, void *data)
 	case NFTA_EXTHDR_DREG:
 	case NFTA_EXTHDR_OFFSET:
 	case NFTA_EXTHDR_LEN:
+	case NFTA_EXTHDR_OP:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -121,6 +129,8 @@ nftnl_expr_exthdr_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_EXTHDR_OFFSET, htonl(exthdr->offset));
 	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_LEN))
 		mnl_attr_put_u32(nlh, NFTA_EXTHDR_LEN, htonl(exthdr->len));
+	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_OP))
+		mnl_attr_put_u32(nlh, NFTA_EXTHDR_OP, htonl(exthdr->op));
 }
 
 static int
@@ -148,10 +158,25 @@ nftnl_expr_exthdr_parse(struct nftnl_expr *e, struct nlattr *attr)
 		exthdr->len = ntohl(mnl_attr_get_u32(tb[NFTA_EXTHDR_LEN]));
 		e->flags |= (1 << NFTNL_EXPR_EXTHDR_LEN);
 	}
+	if (tb[NFTA_EXTHDR_OP]) {
+		exthdr->op = ntohl(mnl_attr_get_u32(tb[NFTA_EXTHDR_OP]));
+		e->flags |= (1 << NFTNL_EXPR_EXTHDR_OP);
+	}
 
 	return 0;
 }
 
+static const char *op2str(uint8_t op)
+{
+	switch (op) {
+	case NFT_EXTHDR_OP_TCPOPT:
+		return " tcpopt";
+	case NFT_EXTHDR_OP_IPV6:
+	default:
+		return "";
+	}
+}
+
 static const char *type2str(uint32_t type)
 {
 	switch (type) {
@@ -170,6 +195,15 @@ static const char *type2str(uint32_t type)
 	}
 }
 
+static inline int str2exthdr_op(const char* str)
+{
+	if (!strcmp(str, "tcpopt"))
+		return NFT_EXTHDR_OP_TCPOPT;
+
+	/* if str == "ipv6" or anything else */
+	return NFT_EXTHDR_OP_IPV6;
+}
+
 static inline int str2exthdr_type(const char *str)
 {
 	if (strcmp(str, "hopopts") == 0)
@@ -193,6 +227,7 @@ nftnl_expr_exthdr_json_parse(struct nftnl_expr *e, json_t *root,
 #ifdef JSON_PARSING
 	const char *exthdr_type;
 	uint32_t uval32;
+	uint8_t uval8;
 	int type;
 
 	if (nftnl_jansson_parse_reg(root, "dreg", NFTNL_TYPE_U32, &uval32,
@@ -214,6 +249,9 @@ nftnl_expr_exthdr_json_parse(struct nftnl_expr *e, json_t *root,
 	if (nftnl_jansson_parse_val(root, "len", NFTNL_TYPE_U32, &uval32, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_EXTHDR_LEN, uval32);
 
+	if (nftnl_jansson_parse_val(root, "op", NFTNL_TYPE_U32, &uval32, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_EXTHDR_OP, uval32);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -235,6 +273,8 @@ static int nftnl_expr_exthdr_export(char *buf, size_t len,
 		nftnl_buf_u32(&b, type, exthdr->offset, OFFSET);
 	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_LEN))
 		nftnl_buf_u32(&b, type, exthdr->len, LEN);
+	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_OP))
+		nftnl_buf_u32(&b, type, exthdr->op, OP);
 
 	return nftnl_buf_done(&b);
 }
@@ -243,10 +283,9 @@ static int nftnl_expr_exthdr_snprintf_default(char *buf, size_t len,
 					      const struct nftnl_expr *e)
 {
 	struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
-
-	return snprintf(buf, len, "load %ub @ %u + %u => reg %u ",
-			exthdr->len, exthdr->type, exthdr->offset,
-			exthdr->dreg);
+	return snprintf(buf, len, "load%s %ub @ %u + %u => reg %u ",
+			op2str(exthdr->op), exthdr->len, exthdr->type,
+			exthdr->offset, exthdr->dreg);
 }
 
 static int
@@ -280,6 +319,8 @@ static bool nftnl_expr_exthdr_cmp(const struct nftnl_expr *e1,
 		eq &= (h1->len == h2->len);
 	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_TYPE))
 		eq &= (h1->type == h2->type);
+	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_OP))
+		eq &= (h1->op == h2->op);
 
 	return eq;
 }
-- 
2.11.1

