From: Yuxuan Shui <yshuiv7@gmail.com>
Subject: [libnftnl PATCH] lookup: Add support for the flag attribute
Date: Fri,  1 Aug 2014 00:40:20 +0800
Message-ID: <1406824821-16111-2-git-send-email-yshuiv7@gmail.com>
References: <1406824821-16111-1-git-send-email-yshuiv7@gmail.com>
Cc: tomasz.bursztyka@linux.intel.com, netfilter-devel@vger.kernel.org,
	Yuxuan Shui <yshuiv7@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63486 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaGaQkh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:40:37 -0400
Received: by mail-pd0-f180.google.com with SMTP id y13so3801446pdi.11
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2014 09:40:37 -0700 (PDT)
In-Reply-To: <1406824821-16111-1-git-send-email-yshuiv7@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

v2: Fix macro naming.

Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h | 10 +++++++++
 src/expr/lookup.c                   | 44 +++++++++++++++++++++++++++++++++++--
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index cfa5c66..e3c045b 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -107,6 +107,7 @@ enum {
 	NFT_EXPR_LOOKUP_DREG,
 	NFT_EXPR_LOOKUP_SET,
 	NFT_EXPR_LOOKUP_SET_ID,
+	NFT_EXPR_LOOKUP_FLAGS,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index cea17d4..008022c 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -483,6 +483,15 @@ enum nft_cmp_attributes {
 #define NFTA_CMP_MAX		(__NFTA_CMP_MAX - 1)
 
 /**
+ * enum nft_lookup_flags - flags for nft_lookup operator
+ *
+ * @NFT_LOOKUP_F_NEG: negate the result
+ */
+enum nft_lookup_flags {
+	NFT_LOOKUP_F_NEG = 1,
+};
+
+/**
  * enum nft_lookup_attributes - nf_tables set lookup expression netlink attributes
  *
  * @NFTA_LOOKUP_SET: name of the set where to look for (NLA_STRING)
@@ -496,6 +505,7 @@ enum nft_lookup_attributes {
 	NFTA_LOOKUP_SREG,
 	NFTA_LOOKUP_DREG,
 	NFTA_LOOKUP_SET_ID,
+	NFTA_LOOKUP_FLAGS,
 	__NFTA_LOOKUP_MAX
 };
 #define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 3f77228..ba0df64 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -32,6 +32,7 @@ struct nft_expr_lookup {
 	enum nft_registers	dreg;
 	char			set_name[IFNAMSIZ];
 	uint32_t		set_id;
+	uint32_t		flags;
 };
 
 static int
@@ -54,6 +55,9 @@ nft_rule_expr_lookup_set(struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_LOOKUP_SET_ID:
 		lookup->set_id = *((uint32_t *)data);
 		break;
+	case NFT_EXPR_LOOKUP_FLAGS:
+		lookup->flags = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -77,6 +81,8 @@ nft_rule_expr_lookup_get(const struct nft_rule_expr *e, uint16_t type,
 		return lookup->set_name;
 	case NFT_EXPR_LOOKUP_SET_ID:
 		return &lookup->set_id;
+	case NFT_EXPR_LOOKUP_FLAGS:
+		return &lookup->flags;
 	}
 	return NULL;
 }
@@ -104,6 +110,12 @@ static int nft_rule_expr_lookup_cb(const struct nlattr *attr, void *data)
 			return MNL_CB_ERROR;
 		}
 		break;
+	case NFTA_LOOKUP_FLAGS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
 	}
 
 	tb[type] = attr;
@@ -121,6 +133,8 @@ nft_rule_expr_lookup_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_LOOKUP_DREG, htonl(lookup->dreg));
 	if (e->flags & (1 << NFT_EXPR_LOOKUP_SET))
 		mnl_attr_put_strz(nlh, NFTA_LOOKUP_SET, lookup->set_name);
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_LOOKUP_FLAGS, htonl(lookup->flags));
 	if (e->flags & (1 << NFT_EXPR_LOOKUP_SET_ID)) {
 		mnl_attr_put_u32(nlh, NFTA_LOOKUP_SET_ID,
 				 htonl(lookup->set_id));
@@ -154,6 +168,11 @@ nft_rule_expr_lookup_parse(struct nft_rule_expr *e, struct nlattr *attr)
 			ntohl(mnl_attr_get_u32(tb[NFTA_LOOKUP_SET_ID]));
 		e->flags |= (1 << NFT_EXPR_LOOKUP_SET_ID);
 	}
+	if (tb[NFTA_LOOKUP_FLAGS]) {
+		lookup->flags =
+			ntohl(mnl_attr_get_u32(tb[NFTA_LOOKUP_FLAGS]));
+		e->flags |= (1 << NFT_EXPR_LOOKUP_FLAGS);
+	}
 
 	return ret;
 }
@@ -164,7 +183,7 @@ nft_rule_expr_lookup_json_parse(struct nft_rule_expr *e, json_t *root,
 {
 #ifdef JSON_PARSING
 	const char *set_name;
-	uint32_t sreg, dreg;
+	uint32_t sreg, dreg, flags;
 
 	set_name = nft_jansson_parse_str(root, "set", err);
 	if (set_name != NULL)
@@ -176,6 +195,9 @@ nft_rule_expr_lookup_json_parse(struct nft_rule_expr *e, json_t *root,
 	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &dreg, err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_DREG, dreg);
 
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &flags, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_FLAGS, flags);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -189,7 +211,7 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 {
 #ifdef XML_PARSING
 	const char *set_name;
-	uint32_t sreg, dreg;
+	uint32_t sreg, dreg, flags;
 
 	set_name = nft_mxml_str_parse(tree, "set", MXML_DESCEND_FIRST,
 				      NFT_XML_MAND, err);
@@ -204,6 +226,10 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 			       err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_DREG, dreg);
 
+	if (nft_mxml_num_parse(root, "flags", MXML_DESCEND, 10, &flags,
+			       NFT_TYPE_U32, NFT_XML_OPT, err) == 0) {
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_FLAGS, flags);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -230,6 +256,10 @@ nft_rule_expr_lookup_snprintf_json(char *buf, size_t size,
 		ret = snprintf(buf + offset, len, "\"dreg\":%u,", l->dreg);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_FLAGS)) {
+		ret = snprintf(buf + offset, len, "\"flags\":%u,", l->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 	/* Remove the last comma characther */
 	if (offset > 0)
 		offset--;
@@ -257,6 +287,11 @@ nft_rule_expr_lookup_snprintf_xml(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_FLAGS)) {
+		ret = snprintf(buf + offset, len, "<flags>%u</flags>", l->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 
@@ -276,6 +311,11 @@ nft_rule_expr_lookup_snprintf_default(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_FLAGS)) {
+		ret = snprintf(buf+offset, len, "flags %u", l->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 
-- 
2.0.1

