From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl 4/5] set_elem: support expressions attached to set elements
Date: Tue, 14 Apr 2015 08:00:36 +0100
Message-ID: <1428994837-22120-5-git-send-email-kaber@trash.net>
References: <1428994837-22120-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44043 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbbDNHAo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Apr 2015 03:00:44 -0400
In-Reply-To: <1428994837-22120-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch supports attaching a struct nft_rule_expr to a set element
and adds netlink attribute encoding and decoding.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/libnftnl/set.h              |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 include/set_elem.h                  |  1 +
 src/set_elem.c                      | 20 ++++++++++++++++++++
 4 files changed, 24 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 9621853..4efc7d4 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -93,6 +93,7 @@ enum {
 	NFT_SET_ELEM_ATTR_TIMEOUT,
 	NFT_SET_ELEM_ATTR_EXPIRATION,
 	NFT_SET_ELEM_ATTR_USERDATA,
+	NFT_SET_ELEM_ATTR_EXPR,
 };
 
 struct nft_set_elem;
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index be8584c..f9c5af2 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -322,6 +322,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
  * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
+ * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
@@ -331,6 +332,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_TIMEOUT,
 	NFTA_SET_ELEM_EXPIRATION,
 	NFTA_SET_ELEM_USERDATA,
+	NFTA_SET_ELEM_EXPR,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
diff --git a/include/set_elem.h b/include/set_elem.h
index 5aaad20..bdefe4b 100644
--- a/include/set_elem.h
+++ b/include/set_elem.h
@@ -8,6 +8,7 @@ struct nft_set_elem {
 	uint32_t		set_elem_flags;
 	union nft_data_reg	key;
 	union nft_data_reg	data;
+	struct nft_rule_expr	*expr;
 	uint32_t		flags;
 	uint64_t		timeout;
 	uint64_t		expiration;
diff --git a/src/set_elem.c b/src/set_elem.c
index 2cf6528..3a799dc 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -25,6 +25,7 @@
 
 #include <libnftnl/set.h>
 #include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
 
 struct nft_set_elem *nft_set_elem_alloc(void)
 {
@@ -46,6 +47,10 @@ void nft_set_elem_free(struct nft_set_elem *s)
 			s->data.chain = NULL;
 		}
 	}
+
+	if (s->flags & (1 << NFT_SET_ELEM_ATTR_EXPR))
+		nft_rule_expr_free(s->expr);
+
 	xfree(s);
 }
 EXPORT_SYMBOL(nft_set_elem_free);
@@ -75,6 +80,12 @@ void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr)
 	case NFT_SET_ELEM_ATTR_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
 	case NFT_SET_ELEM_ATTR_USERDATA:	/* NFTA_SET_ELEM_USERDATA */
 		break;
+	case NFT_SET_ELEM_ATTR_EXPR:
+		if (s->flags & (1 << NFT_SET_ELEM_ATTR_EXPR)) {
+			nft_rule_expr_free(s->expr);
+			s->expr = NULL;
+		}
+		break;
 	default:
 		return;
 	}
@@ -164,6 +175,8 @@ const void *nft_set_elem_attr_get(struct nft_set_elem *s, uint16_t attr, uint32_
 	case NFT_SET_ELEM_ATTR_USERDATA:
 		*data_len = s->user.len;
 		return s->user.data;
+	case NFT_SET_ELEM_ATTR_EXPR:
+		return s->expr;
 	}
 	return NULL;
 }
@@ -305,6 +318,7 @@ static int nft_set_elem_parse_attr_cb(const struct nlattr *attr, void *data)
 		break;
 	case NFTA_SET_ELEM_KEY:
 	case NFTA_SET_ELEM_DATA:
+	case NFTA_SET_ELEM_EXPR:
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			abi_breakage();
 		break;
@@ -365,6 +379,12 @@ static int nft_set_elems_parse2(struct nft_set *s, const struct nlattr *nest)
 			break;
 		}
         }
+	if (tb[NFTA_SET_ELEM_EXPR]) {
+		e->expr = nft_rule_expr_parse(tb[NFTA_SET_ELEM_EXPR]);
+		if (e->expr == NULL)
+			goto err;
+		e->flags |= (1 << NFT_SET_ELEM_ATTR_EXPR);
+	}
 	if (tb[NFTA_SET_ELEM_USERDATA]) {
 		const void *udata =
 			mnl_attr_get_payload(tb[NFTA_SET_ELEM_USERDATA]);
-- 
2.1.0

