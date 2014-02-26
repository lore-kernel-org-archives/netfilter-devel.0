From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/7] rule: add NFT_RULE_ATTR_USERDATA support
Date: Wed, 26 Feb 2014 02:51:59 +0100
Message-ID: <1393379519-16189-8-git-send-email-pablo@netfilter.org>
References: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40473 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaBZBwP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:52:15 -0500
In-Reply-To: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows us to manipulate the user data area of the rule.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/rule.h             |    1 +
 include/linux/netfilter/nf_tables.h |    5 ++-
 src/rule.c                          |   58 ++++++++++++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index 9e6efaf..62dba59 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -26,6 +26,7 @@ enum {
 	NFT_RULE_ATTR_COMPAT_PROTO,
 	NFT_RULE_ATTR_COMPAT_FLAGS,
 	NFT_RULE_ATTR_POSITION,
+	NFT_RULE_ATTR_USERDATA,
 	__NFT_RULE_ATTR_MAX
 };
 #define NFT_RULE_ATTR_MAX (__NFT_RULE_ATTR_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 83c985a..d22c7c1 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1,7 +1,8 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
-#define NFT_CHAIN_MAXNAMELEN 32
+#define NFT_CHAIN_MAXNAMELEN	32
+#define NFT_USERDATA_MAXLEN	128
 
 enum nft_registers {
 	NFT_REG_VERDICT,
@@ -156,6 +157,7 @@ enum nft_chain_attributes {
  * @NFTA_RULE_EXPRESSIONS: list of expressions (NLA_NESTED: nft_expr_attributes)
  * @NFTA_RULE_COMPAT: compatibility specifications of the rule (NLA_NESTED: nft_rule_compat_attributes)
  * @NFTA_RULE_POSITION: numeric handle of the previous rule (NLA_U64)
+ * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN long)
  */
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
@@ -165,6 +167,7 @@ enum nft_rule_attributes {
 	NFTA_RULE_EXPRESSIONS,
 	NFTA_RULE_COMPAT,
 	NFTA_RULE_POSITION,
+	NFTA_RULE_USERDATA,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
diff --git a/src/rule.c b/src/rule.c
index adb7426..30ae71c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -19,6 +19,7 @@
 #include <netinet/in.h>
 #include <errno.h>
 #include <inttypes.h>
+#include <ctype.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -40,6 +41,10 @@ struct nft_rule {
 	uint64_t	handle;
 	uint64_t	position;
 	struct {
+			void		*data;
+			uint32_t	len;
+	} user;
+	struct {
 			uint32_t	flags;
 			uint32_t	proto;
 	} compat;
@@ -106,6 +111,7 @@ void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr)
 	case NFT_RULE_ATTR_COMPAT_FLAGS:
 	case NFT_RULE_ATTR_POSITION:
 	case NFT_RULE_ATTR_FAMILY:
+	case NFT_RULE_ATTR_USERDATA:
 		break;
 	}
 
@@ -157,6 +163,10 @@ void nft_rule_attr_set_data(struct nft_rule *r, uint16_t attr,
 	case NFT_RULE_ATTR_POSITION:
 		r->position = *((uint64_t *)data);
 		break;
+	case NFT_RULE_ATTR_USERDATA:
+		r->user.data = (void *)data;
+		r->user.len = data_len;
+		break;
 	}
 	r->flags |= (1 << attr);
 }
@@ -212,6 +222,9 @@ const void *nft_rule_attr_get_data(const struct nft_rule *r, uint16_t attr,
 	case NFT_RULE_ATTR_POSITION:
 		*data_len = sizeof(uint64_t);
 		return &r->position;
+	case NFT_RULE_ATTR_USERDATA:
+		*data_len = r->user.len;
+		return r->user.data;
 	}
 	return NULL;
 }
@@ -276,6 +289,10 @@ void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *r)
 		mnl_attr_put_u64(nlh, NFTA_RULE_HANDLE, htobe64(r->handle));
 	if (r->flags & (1 << NFT_RULE_ATTR_POSITION))
 		mnl_attr_put_u64(nlh, NFTA_RULE_POSITION, htobe64(r->position));
+	if (r->flags & (1 << NFT_RULE_ATTR_USERDATA)) {
+		mnl_attr_put(nlh, NFTA_RULE_USERDATA, r->user.len,
+			     r->user.data);
+	}
 
 	if (!list_empty(&r->expr_list)) {
 		nest = mnl_attr_nest_start(nlh, NFTA_RULE_EXPRESSIONS);
@@ -338,6 +355,12 @@ static int nft_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 			return MNL_CB_ERROR;
 		}
 		break;
+	case NFTA_RULE_USERDATA:
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
 	}
 
 	tb[type] = attr;
@@ -476,6 +499,22 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *r)
 		r->position = be64toh(mnl_attr_get_u64(tb[NFTA_RULE_POSITION]));
 		r->flags |= (1 << NFT_RULE_ATTR_POSITION);
 	}
+	if (tb[NFTA_RULE_USERDATA]) {
+		const void *udata =
+			mnl_attr_get_payload(tb[NFTA_RULE_USERDATA]);
+
+		if (r->user.data)
+			xfree(r->user.data);
+
+		r->user.len = mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
+
+		r->user.data = malloc(r->user.len);
+		if (r->user.data == NULL)
+			return -1;
+
+		memcpy(r->user.data, udata, r->user.len);
+		r->flags |= (1 << NFT_RULE_ATTR_USERDATA);
+	}
 
 	r->family = nfg->nfgen_family;
 	r->flags |= (1 << NFT_RULE_ATTR_FAMILY);
@@ -828,7 +867,7 @@ static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r,
 				     uint32_t type, uint32_t flags)
 {
 	struct nft_rule_expr *expr;
-	int ret, len = size, offset = 0;
+	int ret, len = size, offset = 0, i;
 
 	ret = snprintf(buf, len, "%s %s %s %"PRIu64" %"PRIu64"\n",
 			nft_family2str(r->family), r->table, r->chain,
@@ -847,6 +886,23 @@ static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (r->user.len) {
+		ret = snprintf(buf+offset, len, "  userdata = { ");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		for (i = 0; i < r->user.len; i++) {
+			char *c = r->user.data;
+
+			ret = snprintf(buf+offset, len, "%c",
+				       isalnum(c[i]) ? c[i] : 0);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+
+		ret = snprintf(buf+offset, len, " }\n");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	}
+
 	return offset;
 }
 
-- 
1.7.10.4

