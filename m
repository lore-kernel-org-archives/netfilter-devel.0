From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] dynset: support expression templates
Date: Sun, 12 Apr 2015 20:35:10 +0100
Message-ID: <1428867310-18327-4-git-send-email-kaber@trash.net>
References: <1428867310-18327-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61770 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbbDLTf0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 15:35:26 -0400
In-Reply-To: <1428867310-18327-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support expression templates for the dynset expression for dynamic
expression instantiation.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  1 +
 src/expr/dynset.c                   | 38 +++++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 14daa83..59ae2d7 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -113,6 +113,7 @@ enum {
 	NFT_EXPR_DYNSET_TIMEOUT,
 	NFT_EXPR_DYNSET_SET_NAME,
 	NFT_EXPR_DYNSET_SET_ID,
+	NFT_EXPR_DYNSET_EXPR,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 9321152..248d9f0 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -540,6 +540,7 @@ enum nft_dynset_attributes {
 	NFTA_DYNSET_SREG_KEY,
 	NFTA_DYNSET_SREG_DATA,
 	NFTA_DYNSET_TIMEOUT,
+	NFTA_DYNSET_EXPR,
 	__NFTA_DYNSET_MAX,
 };
 #define NFTA_DYNSET_MAX		(__NFTA_DYNSET_MAX - 1)
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index a2c1946..9289e4a 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -31,6 +31,7 @@ struct nft_expr_dynset {
 	enum nft_registers	sreg_data;
 	enum nft_dynset_ops	op;
 	uint64_t		timeout;
+	struct nft_rule_expr	*expr;
 	char			set_name[IFNAMSIZ];
 	uint32_t		set_id;
 };
@@ -61,6 +62,9 @@ nft_rule_expr_dynset_set(struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_DYNSET_SET_ID:
 		dynset->set_id = *((uint32_t *)data);
 		break;
+	case NFT_EXPR_DYNSET_EXPR:
+		dynset->expr = (void *)data;
+		break;
 	default:
 		return -1;
 	}
@@ -90,6 +94,8 @@ nft_rule_expr_dynset_get(const struct nft_rule_expr *e, uint16_t type,
 		return dynset->set_name;
 	case NFT_EXPR_DYNSET_SET_ID:
 		return &dynset->set_id;
+	case NFT_EXPR_DYNSET_EXPR:
+		return dynset->expr;
 	}
 	return NULL;
 }
@@ -118,6 +124,10 @@ static int nft_rule_expr_dynset_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
+	case NFTA_DYNSET_EXPR:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -128,6 +138,7 @@ static void
 nft_rule_expr_dynset_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 {
 	struct nft_expr_dynset *dynset = nft_expr_data(e);
+	struct nlattr *nest;
 
 	if (e->flags & (1 << NFT_EXPR_DYNSET_SREG_KEY))
 		mnl_attr_put_u32(nlh, NFTA_DYNSET_SREG_KEY, htonl(dynset->sreg_key));
@@ -141,6 +152,11 @@ nft_rule_expr_dynset_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 		mnl_attr_put_strz(nlh, NFTA_DYNSET_SET_NAME, dynset->set_name);
 	if (e->flags & (1 << NFT_EXPR_DYNSET_SET_ID))
 		mnl_attr_put_u32(nlh, NFTA_DYNSET_SET_ID, htonl(dynset->set_id));
+	if (e->flags & (1 << NFT_EXPR_DYNSET_EXPR)) {
+		nest = mnl_attr_nest_start(nlh, NFTA_DYNSET_EXPR);
+		nft_rule_expr_build_payload(nlh, dynset->expr);
+		mnl_attr_nest_end(nlh, nest);
+	}
 }
 
 static int
@@ -177,6 +193,12 @@ nft_rule_expr_dynset_parse(struct nft_rule_expr *e, struct nlattr *attr)
 		dynset->set_id = ntohl(mnl_attr_get_u32(tb[NFTA_DYNSET_SET_ID]));
 		e->flags |= (1 << NFT_EXPR_DYNSET_SET_ID);
 	}
+	if (tb[NFTA_DYNSET_EXPR]) {
+		e->flags |= (1 << NFT_EXPR_DYNSET_EXPR);
+		dynset->expr = nft_rule_expr_parse(tb[NFTA_DYNSET_EXPR]);
+		if (dynset->expr == NULL)
+			return -1;
+	}
 
 	return ret;
 }
@@ -268,6 +290,7 @@ nft_rule_expr_dynset_snprintf_default(char *buf, size_t size,
 				      struct nft_rule_expr *e)
 {
 	struct nft_expr_dynset *dynset = nft_expr_data(e);
+	struct nft_rule_expr *expr;
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "%s reg_key %u set %s ",
@@ -283,6 +306,21 @@ nft_rule_expr_dynset_snprintf_default(char *buf, size_t size,
 			       dynset->timeout);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
+	if (e->flags & (1 << NFT_EXPR_DYNSET_EXPR)) {
+		expr = dynset->expr;
+		ret = snprintf(buf+offset, len, "expr [ %s ",
+			       expr->ops->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = nft_rule_expr_snprintf(buf+offset, len, expr,
+					     NFT_OUTPUT_DEFAULT,
+					     NFT_OF_EVENT_ANY);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = snprintf(buf+offset, len, "] ");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 
-- 
2.1.0

