From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftables 2/2] src: consolidate netlink build header function
Date: Mon, 25 Nov 2013 00:01:59 +0100
Message-ID: <1385334119-3857-2-git-send-email-pablo@netfilter.org>
References: <1385334119-3857-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42160 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab3KXXCL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Nov 2013 18:02:11 -0500
In-Reply-To: <1385334119-3857-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add new function nft_nlmsg_build_hdr which consolidates all existing
functions to build headers per object. They basically look the same.
This patch still provides aliases for consistency in the naming
approach.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftables/chain.h  |    2 +-
 include/libnftables/common.h |    4 ++++
 include/libnftables/rule.h   |    2 +-
 include/libnftables/set.h    |    4 ++--
 include/libnftables/table.h  |    2 +-
 src/Makefile.am              |    1 +
 src/chain.c                  |   21 ---------------------
 src/common.c                 |   36 ++++++++++++++++++++++++++++++++++++
 src/libnftables.map          |    7 ++-----
 src/rule.c                   |   21 ---------------------
 src/set.c                    |   21 ---------------------
 src/set_elem.c               |   21 ---------------------
 src/table.c                  |   21 ---------------------
 13 files changed, 48 insertions(+), 115 deletions(-)
 create mode 100644 src/common.c

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index fff47d3..8b4eab9 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -55,7 +55,7 @@ int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type, const char *d
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, uint32_t type, uint32_t flags);
 int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type, uint32_t flags);
 
-struct nlmsghdr *nft_chain_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
+#define nft_chain_nlmsg_build_hdr	nft_nlmsg_build_hdr
 int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *t);
 
 struct nft_chain_list;
diff --git a/include/libnftables/common.h b/include/libnftables/common.h
index 2283d72..9cd92b2 100644
--- a/include/libnftables/common.h
+++ b/include/libnftables/common.h
@@ -13,4 +13,8 @@ enum nft_parse_type {
 	NFT_PARSE_JSON,
 	NFT_PARSE_MAX,
 };
+
+struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
+				     uint16_t type, uint32_t seq);
+
 #endif
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index d1d75e1..86dbc17 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -51,7 +51,7 @@ int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type, const char *dat
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint32_t type, uint32_t flags);
 int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type, uint32_t flags);
 
-struct nlmsghdr *nft_rule_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
+#define nft_rule_nlmsg_build_hdr	nft_nlmsg_build_hdr
 int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *t);
 
 int nft_rule_expr_foreach(struct nft_rule *r,
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index d91bd42..13ac857 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -36,7 +36,7 @@ uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr);
 
 struct nlmsghdr;
 
-struct nlmsghdr *nft_set_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
+#define nft_set_nlmsg_build_hdr	nft_nlmsg_build_hdr
 void nft_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s);
 int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
 int nft_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
@@ -92,7 +92,7 @@ uint32_t nft_set_elem_attr_get_u32(struct nft_set_elem *s, uint16_t attr);
 
 bool nft_set_elem_attr_is_set(const struct nft_set_elem *s, uint16_t attr);
 
-struct nlmsghdr *nft_set_elem_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
+#define nft_set_elem_nlmsg_build_hdr	nft_nlmsg_build_hdr
 void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s);
 void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set_elem *e);
 
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 87481e4..be60da9 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -43,7 +43,7 @@ int nft_table_parse(struct nft_table *t, enum nft_parse_type type, const char *d
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, uint32_t type, uint32_t flags);
 int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type, uint32_t flags);
 
-struct nlmsghdr *nft_table_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
+#define nft_table_nlmsg_build_hdr	nft_nlmsg_build_hdr
 int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t);
 
 struct nft_table_list;
diff --git a/src/Makefile.am b/src/Makefile.am
index 48d5d2d..83ab658 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -5,6 +5,7 @@ libnftables_la_LIBADD = ${LIBMNL_LIBS} ${LIBXML_LIBS} ${LIBJSON_LIBS}
 libnftables_la_LDFLAGS = -Wl,--version-script=$(srcdir)/libnftables.map \
 			 -version-info $(LIBVERSION)
 libnftables_la_SOURCES = utils.c		\
+			 common.c		\
 			 table.c		\
 			 chain.c		\
 			 rule.c			\
diff --git a/src/chain.c b/src/chain.c
index 0145d32..a0004b5 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -285,27 +285,6 @@ uint8_t nft_chain_attr_get_u8(struct nft_chain *c, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_chain_attr_get_u8);
 
-struct nlmsghdr *
-nft_chain_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
-			  uint16_t type, uint32_t seq)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfh;
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | cmd;
-	nlh->nlmsg_flags = NLM_F_REQUEST | type;
-	nlh->nlmsg_seq = seq;
-
-	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
-	nfh->nfgen_family = family;
-	nfh->version = NFNETLINK_V0;
-	nfh->res_id = 0;
-
-	return nlh;
-}
-EXPORT_SYMBOL(nft_chain_nlmsg_build_hdr);
-
 void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain *c)
 {
 	if (c->flags & (1 << NFT_CHAIN_ATTR_TABLE))
diff --git a/src/common.c b/src/common.c
new file mode 100644
index 0000000..f03e730
--- /dev/null
+++ b/src/common.c
@@ -0,0 +1,36 @@
+/*
+ * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/netlink.h>
+#include <linux/netfilter/nfnetlink.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftables/common.h>
+
+#include "internal.h"
+
+struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
+				     uint16_t type, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | cmd;
+	nlh->nlmsg_flags = NLM_F_REQUEST | type;
+	nlh->nlmsg_seq = seq;
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = family;
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = 0;
+
+	return nlh;
+}
+EXPORT_SYMBOL(nft_nlmsg_build_hdr);
diff --git a/src/libnftables.map b/src/libnftables.map
index 3bdfeda..7dc9aee 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -15,7 +15,6 @@ global:
   nft_table_parse;
   nft_table_snprintf;
   nft_table_fprintf;
-  nft_table_nlmsg_build_hdr;
   nft_table_nlmsg_build_payload;
   nft_table_nlmsg_parse;
   nft_table_list_alloc;
@@ -48,7 +47,6 @@ global:
   nft_chain_parse;
   nft_chain_snprintf;
   nft_chain_fprintf;
-  nft_chain_nlmsg_build_hdr;
   nft_chain_nlmsg_build_payload;
   nft_chain_nlmsg_parse;
   nft_chain_list_alloc;
@@ -78,7 +76,6 @@ global:
   nft_rule_parse;
   nft_rule_snprintf;
   nft_rule_fprintf;
-  nft_rule_nlmsg_build_hdr;
   nft_rule_nlmsg_build_payload;
   nft_rule_nlmsg_parse;
   nft_rule_add_expr;
@@ -128,7 +125,6 @@ global:
   nft_set_attr_get;
   nft_set_attr_get_str;
   nft_set_attr_get_u32;
-  nft_set_nlmsg_build_hdr;
   nft_set_nlmsg_build_payload;
   nft_set_nlmsg_parse;
   nft_set_parse;
@@ -160,7 +156,6 @@ global:
   nft_set_elem_attr_get;
   nft_set_elem_attr_get_str;
   nft_set_elem_attr_get_u32;
-  nft_set_elem_nlmsg_build_hdr;
   nft_set_elem_nlmsg_build_payload;
   nft_set_elem_nlmsg_parse;
   nft_set_elem_parse;
@@ -187,5 +182,7 @@ global:
   nft_ruleset_snprintf;
   nft_ruleset_fprintf;
 
+  nft_nlmsg_build_hdr;
+
 local: *;
 };
diff --git a/src/rule.c b/src/rule.c
index 4f70dab..280350a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -220,27 +220,6 @@ uint8_t nft_rule_attr_get_u8(const struct nft_rule *r, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_rule_attr_get_u8);
 
-struct nlmsghdr *
-nft_rule_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
-			  uint16_t type, uint32_t seq)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfh;
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | cmd;
-	nlh->nlmsg_flags = NLM_F_REQUEST | type;
-	nlh->nlmsg_seq = seq;
-
-	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
-	nfh->nfgen_family = family;
-	nfh->version = NFNETLINK_V0;
-	nfh->res_id = 0;
-
-	return nlh;
-}
-EXPORT_SYMBOL(nft_rule_nlmsg_build_hdr);
-
 void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *r)
 {
 	struct nft_rule_expr *expr;
diff --git a/src/set.c b/src/set.c
index ba39c43..c5204cc 100644
--- a/src/set.c
+++ b/src/set.c
@@ -188,27 +188,6 @@ uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_set_attr_get_u32);
 
-struct nlmsghdr *
-nft_set_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
-			uint16_t type, uint32_t seq)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfh;
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | cmd;
-	nlh->nlmsg_flags = NLM_F_REQUEST | type;
-	nlh->nlmsg_seq = seq;
-
-	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
-	nfh->nfgen_family = family;
-	nfh->version = NFNETLINK_V0;
-	nfh->res_id = 0;
-
-	return nlh;
-}
-EXPORT_SYMBOL(nft_set_nlmsg_build_hdr);
-
 void nft_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 {
 	if (s->flags & (1 << NFT_SET_ATTR_TABLE))
diff --git a/src/set_elem.c b/src/set_elem.c
index 297328f..fce9c1d 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -158,27 +158,6 @@ uint32_t nft_set_elem_attr_get_u32(struct nft_set_elem *s, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_set_elem_attr_get_u32);
 
-struct nlmsghdr *
-nft_set_elem_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
-			     uint16_t type, uint32_t seq)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfh;
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | cmd;
-	nlh->nlmsg_flags = NLM_F_REQUEST | type;
-	nlh->nlmsg_seq = seq;
-
-	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
-	nfh->nfgen_family = family;
-	nfh->version = NFNETLINK_V0;
-	nfh->res_id = 0;
-
-	return nlh;
-}
-EXPORT_SYMBOL(nft_set_elem_nlmsg_build_hdr);
-
 void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 				      struct nft_set_elem *e)
 {
diff --git a/src/table.c b/src/table.c
index cf24cae..9e20768 100644
--- a/src/table.c
+++ b/src/table.c
@@ -152,27 +152,6 @@ const char *nft_table_attr_get_str(struct nft_table *t, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_table_attr_get_str);
 
-struct nlmsghdr *
-nft_table_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
-			  uint16_t type, uint32_t seq)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfh;
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | cmd;
-	nlh->nlmsg_flags = NLM_F_REQUEST | type;
-	nlh->nlmsg_seq = seq;
-
-	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
-	nfh->nfgen_family = family;
-	nfh->version = NFNETLINK_V0;
-	nfh->res_id = 0;
-
-	return nlh;
-}
-EXPORT_SYMBOL(nft_table_nlmsg_build_hdr);
-
 void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table *t)
 {
 	if (t->flags & (1 << NFT_TABLE_ATTR_NAME))
-- 
1.7.10.4

