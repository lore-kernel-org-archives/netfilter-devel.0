From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 1/7] exthdr: tcp option set support
Date: Sun, 20 Aug 2017 01:14:07 +0200
Message-ID: <20170819231413.15164-2-fw@strlen.de>
References: <20170819231413.15164-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39290 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752021AbdHSXN7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 19:13:59 -0400
In-Reply-To: <20170819231413.15164-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  4 +++-
 src/expr/exthdr.c                   | 39 ++++++++++++++++++++++++++++++++-----
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index b06d1b176578..76f28fee7b5f 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -158,6 +158,7 @@ enum {
 	NFTNL_EXPR_EXTHDR_LEN,
 	NFTNL_EXPR_EXTHDR_FLAGS,
 	NFTNL_EXPR_EXTHDR_OP,
+	NFTNL_EXPR_EXTHDR_SREG,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 683f6f88fcac..4766f5091b5f 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -731,7 +731,8 @@ enum nft_exthdr_op {
  * @NFTA_EXTHDR_OFFSET: extension header offset (NLA_U32)
  * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
  * @NFTA_EXTHDR_FLAGS: extension header flags (NLA_U32)
- * @NFTA_EXTHDR_OP: option match type (NLA_U8)
+ * @NFTA_EXTHDR_OP: option match type (NLA_U32)
+ * @NFTA_EXTHDR_SREG: option match type (NLA_U32)
  */
 enum nft_exthdr_attributes {
 	NFTA_EXTHDR_UNSPEC,
@@ -741,6 +742,7 @@ enum nft_exthdr_attributes {
 	NFTA_EXTHDR_LEN,
 	NFTA_EXTHDR_FLAGS,
 	NFTA_EXTHDR_OP,
+	NFTA_EXTHDR_SREG,
 	__NFTA_EXTHDR_MAX
 };
 #define NFTA_EXTHDR_MAX		(__NFTA_EXTHDR_MAX - 1)
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index d4f166525dc9..75cafbc113f7 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -30,6 +30,7 @@
 
 struct nftnl_expr_exthdr {
 	enum nft_registers	dreg;
+	enum nft_registers	sreg;
 	uint32_t		offset;
 	uint32_t		len;
 	uint8_t			type;
@@ -62,6 +63,9 @@ nftnl_expr_exthdr_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_EXTHDR_FLAGS:
 		exthdr->flags = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_EXTHDR_SREG:
+		exthdr->sreg = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -93,6 +97,9 @@ nftnl_expr_exthdr_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_EXTHDR_FLAGS:
 		*data_len = sizeof(exthdr->flags);
 		return &exthdr->flags;
+	case NFTNL_EXPR_EXTHDR_SREG:
+		*data_len = sizeof(exthdr->sreg);
+		return &exthdr->sreg;
 	}
 	return NULL;
 }
@@ -111,6 +118,7 @@ static int nftnl_expr_exthdr_cb(const struct nlattr *attr, void *data)
 			abi_breakage();
 		break;
 	case NFTA_EXTHDR_DREG:
+	case NFTA_EXTHDR_SREG:
 	case NFTA_EXTHDR_OFFSET:
 	case NFTA_EXTHDR_LEN:
 	case NFTA_EXTHDR_OP:
@@ -131,6 +139,8 @@ nftnl_expr_exthdr_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 
 	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_DREG))
 		mnl_attr_put_u32(nlh, NFTA_EXTHDR_DREG, htonl(exthdr->dreg));
+	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_SREG))
+		mnl_attr_put_u32(nlh, NFTA_EXTHDR_SREG, htonl(exthdr->sreg));
 	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_TYPE))
 		mnl_attr_put_u8(nlh, NFTA_EXTHDR_TYPE, exthdr->type);
 	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_OFFSET))
@@ -156,6 +166,10 @@ nftnl_expr_exthdr_parse(struct nftnl_expr *e, struct nlattr *attr)
 		exthdr->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_EXTHDR_DREG]));
 		e->flags |= (1 << NFTNL_EXPR_EXTHDR_DREG);
 	}
+	if (tb[NFTA_EXTHDR_SREG]) {
+		exthdr->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_EXTHDR_SREG]));
+		e->flags |= (1 << NFTNL_EXPR_EXTHDR_SREG);
+	}
 	if (tb[NFTA_EXTHDR_TYPE]) {
 		exthdr->type = mnl_attr_get_u8(tb[NFTA_EXTHDR_TYPE]);
 		e->flags |= (1 << NFTNL_EXPR_EXTHDR_TYPE);
@@ -247,6 +261,10 @@ nftnl_expr_exthdr_json_parse(struct nftnl_expr *e, json_t *root,
 				  err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_EXTHDR_DREG, uval32);
 
+	if (nftnl_jansson_parse_reg(root, "sreg", NFTNL_TYPE_U32, &uval32,
+				  err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_EXTHDR_SREG, uval32);
+
 	exthdr_type = nftnl_jansson_parse_str(root, "exthdr_type", err);
 	if (exthdr_type != NULL) {
 		type = str2exthdr_type(exthdr_type);
@@ -283,6 +301,8 @@ static int nftnl_expr_exthdr_export(char *buf, size_t len,
 
 	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_DREG))
 		nftnl_buf_u32(&b, type, exthdr->dreg, DREG);
+	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_SREG))
+		nftnl_buf_u32(&b, type, exthdr->dreg, SREG);
 	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_TYPE))
 		nftnl_buf_str(&b, type, type2str(exthdr->type), EXTHDR_TYPE);
 	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_OFFSET))
@@ -301,11 +321,18 @@ static int nftnl_expr_exthdr_snprintf_default(char *buf, size_t len,
 					      const struct nftnl_expr *e)
 {
 	struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
-	return snprintf(buf, len, "load%s %ub @ %u + %u%s => reg %u ",
-			op2str(exthdr->op), exthdr->len, exthdr->type,
-			exthdr->offset,
-			exthdr->flags & NFT_EXTHDR_F_PRESENT ? " present" : "",
-			exthdr->dreg);
+
+	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_DREG))
+		return snprintf(buf, len, "load%s %ub @ %u + %u%s => reg %u ",
+				op2str(exthdr->op), exthdr->len, exthdr->type,
+				exthdr->offset,
+				exthdr->flags & NFT_EXTHDR_F_PRESENT ? " present" : "",
+				exthdr->dreg);
+	else
+		return snprintf(buf, len, "write%s reg %u => %ub @ %u + %u ",
+				op2str(exthdr->op), exthdr->sreg, exthdr->len, exthdr->type,
+				exthdr->offset);
+
 }
 
 static int
@@ -333,6 +360,8 @@ static bool nftnl_expr_exthdr_cmp(const struct nftnl_expr *e1,
 
 	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_DREG))
 		eq &= (h1->dreg == h2->dreg);
+	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_SREG))
+		eq &= (h1->sreg == h2->sreg);
 	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_OFFSET))
 		eq &= (h1->offset == h2->offset);
 	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_LEN))
-- 
2.13.0

