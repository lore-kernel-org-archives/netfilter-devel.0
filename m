From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH - v2] expr: Add support for NAT expressions
Date: Thu, 15 Nov 2012 16:40:25 +0200
Message-ID: <1352990425-909-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768075Ab2KOOka (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:40:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/libnftables/expr.h          |   9 ++
 include/linux/netfilter/nf_tables.h |   9 +-
 src/Makefile.am                     |   1 +
 src/expr/nat.c                      | 250 ++++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 5 files changed, 267 insertions(+), 4 deletions(-)
 create mode 100644 src/expr/nat.c

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index cddfbcf..a39cb48 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -81,6 +81,15 @@ enum {
 	NFT_EXPR_MT_INFO,
 };
 
+enum {
+	NFT_EXPR_NAT_TYPE		= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_NAT_FAMILY,
+	NFT_EXPR_NAT_REG_ADDR_MIN,
+	NFT_EXPR_NAT_REG_ADDR_MAX,
+	NFT_EXPR_NAT_REG_PROTO_MIN,
+	NFT_EXPR_NAT_REG_PROTO_MAX,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 9255dbe..81ae1c4 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -396,10 +396,11 @@ enum nft_nat_types {
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
 	NFTA_NAT_TYPE,
-	NFTA_NAT_ADDR_MIN,
-	NFTA_NAT_ADDR_MAX,
-	NFTA_NAT_PROTO_MIN,
-	NFTA_NAT_PROTO_MAX,
+	NFTA_NAT_FAMILY,
+	NFTA_NAT_REG_ADDR_MIN,
+	NFTA_NAT_REG_ADDR_MAX,
+	NFTA_NAT_REG_PROTO_MIN,
+	NFTA_NAT_REG_PROTO_MAX,
 	__NFTA_NAT_MAX
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
diff --git a/src/Makefile.am b/src/Makefile.am
index 4cca790..18d2c22 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -16,6 +16,7 @@ libnftables_la_SOURCES = table.c		\
 			 expr/immediate.c	\
 			 expr/match.c		\
 			 expr/meta.c		\
+			 expr/nat.c		\
 			 expr/payload.c		\
 			 expr/target.c		\
 			 libnftables.map	\
diff --git a/src/expr/nat.c b/src/expr/nat.c
new file mode 100644
index 0000000..acd9839
--- /dev/null
+++ b/src/expr/nat.c
@@ -0,0 +1,250 @@
+/*
+ * (C) 2012 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Authors:
+ * 	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ */
+
+#include "internal.h"
+
+#include <stdio.h>
+#include <stdint.h>
+#include <arpa/inet.h>
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libnftables/expr.h>
+#include "expr_ops.h"
+
+struct nft_expr_nat {
+	enum nft_registers sreg_addr_min;
+	enum nft_registers sreg_addr_max;
+	enum nft_registers sreg_proto_min;
+	enum nft_registers sreg_proto_max;
+	int                family;
+	enum nft_nat_types type;
+};
+
+static int
+nft_rule_expr_nat_set(struct nft_rule_expr *e, uint16_t type,
+		      const void *data, size_t data_len)
+{
+	struct nft_expr_nat *nat = (struct nft_expr_nat *)e->data;
+
+	switch(type) {
+	case NFT_EXPR_NAT_TYPE:
+		nat->type = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_NAT_FAMILY:
+		nat->family = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_NAT_REG_ADDR_MIN:
+		nat->sreg_addr_min = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_NAT_REG_ADDR_MAX:
+		nat->sreg_addr_max = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_NAT_REG_PROTO_MIN:
+		nat->sreg_proto_min = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_NAT_REG_PROTO_MAX:
+		nat->sreg_proto_max = *((uint32_t *)data);
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static const void *
+nft_rule_expr_nat_get(struct nft_rule_expr *e, uint16_t type, size_t *data_len)
+{
+	struct nft_expr_nat *nat = (struct nft_expr_nat *)e->data;
+
+	switch(type) {
+	case NFT_EXPR_NAT_TYPE:
+		if (e->flags & (1 << NFT_EXPR_NAT_TYPE)) {
+			*data_len = sizeof(nat->type);
+			return &nat->type;
+		}
+		break;
+	case NFT_EXPR_NAT_FAMILY:
+		if (e->flags & (1 << NFT_EXPR_NAT_FAMILY)) {
+			*data_len = sizeof(nat->family);
+			return &nat->family;
+		}
+		break;
+	case NFT_EXPR_NAT_REG_ADDR_MIN:
+		if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
+			*data_len = sizeof(nat->sreg_addr_min);
+			return &nat->sreg_addr_min;
+		}
+		break;
+	case NFT_EXPR_NAT_REG_ADDR_MAX:
+		if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MAX)) {
+			*data_len = sizeof(nat->sreg_addr_max);
+			return &nat->sreg_addr_max;
+		}
+		break;
+	case NFT_EXPR_NAT_REG_PROTO_MIN:
+		if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
+			*data_len = sizeof(nat->sreg_proto_min);
+			return &nat->sreg_proto_min;
+		}
+		break;
+	case NFT_EXPR_NAT_REG_PROTO_MAX:
+		if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MAX)) {
+			*data_len = sizeof(nat->sreg_proto_max);
+			return &nat->sreg_proto_max;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
+static int nft_rule_expr_nat_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_NAT_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_NAT_TYPE:
+	case NFTA_NAT_FAMILY:
+	case NFTA_NAT_REG_ADDR_MIN:
+	case NFTA_NAT_REG_ADDR_MAX:
+	case NFTA_NAT_REG_PROTO_MIN:
+	case NFTA_NAT_REG_PROTO_MAX:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int
+nft_rule_expr_nat_parse(struct nft_rule_expr *e, struct nlattr *attr)
+{
+	struct nft_expr_nat *nat = (struct nft_expr_nat *)e->data;
+	struct nlattr *tb[NFTA_NAT_MAX+1] = {};
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_nat_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_NAT_TYPE]) {
+		nat->type = ntohl(mnl_attr_get_u32(tb[NFTA_NAT_TYPE]));
+		e->flags |= (1 << NFT_EXPR_NAT_TYPE);
+	}
+	if (tb[NFTA_NAT_FAMILY]) {
+		nat->family = ntohl(mnl_attr_get_u32(tb[NFTA_NAT_FAMILY]));
+		e->flags |= (1 << NFT_EXPR_NAT_FAMILY);
+	}
+	if (tb[NFTA_NAT_REG_ADDR_MIN]) {
+		nat->sreg_addr_min =
+			ntohl(mnl_attr_get_u32(tb[NFTA_NAT_REG_ADDR_MIN]));
+		e->flags |= (1 << NFT_EXPR_NAT_REG_ADDR_MIN);
+	}
+	if (tb[NFTA_NAT_REG_ADDR_MAX]) {
+		nat->sreg_addr_max =
+			ntohl(mnl_attr_get_u32(tb[NFTA_NAT_REG_ADDR_MAX]));
+		e->flags |= (1 << NFT_EXPR_NAT_REG_ADDR_MAX);
+	}
+	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
+		nat->sreg_proto_min =
+			ntohl(mnl_attr_get_u32(tb[NFTA_NAT_REG_PROTO_MIN]));
+		e->flags |= (1 << NFT_EXPR_NAT_REG_PROTO_MIN);
+	}
+	if (tb[NFTA_NAT_REG_PROTO_MAX]) {
+		nat->sreg_proto_max =
+			ntohl(mnl_attr_get_u32(tb[NFTA_NAT_REG_PROTO_MAX]));
+		e->flags |= (1 << NFT_EXPR_NAT_REG_PROTO_MAX);
+	}
+
+	return 0;
+}
+
+static void
+nft_rule_expr_nat_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
+{
+	struct nft_expr_nat *nat = (struct nft_expr_nat *)e->data;
+
+	if (e->flags & (1 << NFT_EXPR_NAT_TYPE))
+		mnl_attr_put_u32(nlh, NFTA_NAT_TYPE, htonl(nat->type));
+	if (e->flags & (1 << NFT_EXPR_NAT_FAMILY))
+		mnl_attr_put_u32(nlh, NFTA_NAT_FAMILY, htonl(nat->family));
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN))
+		mnl_attr_put_u32(nlh, NFTA_NAT_REG_ADDR_MIN,
+				 htonl(nat->sreg_addr_min));
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MAX))
+		mnl_attr_put_u32(nlh, NFTA_NAT_REG_ADDR_MAX,
+				 htonl(nat->sreg_addr_max));
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN))
+		mnl_attr_put_u32(nlh, NFTA_NAT_REG_PROTO_MIN,
+				 htonl(nat->sreg_proto_min));
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MAX))
+		mnl_attr_put_u32(nlh, NFTA_NAT_REG_PROTO_MAX,
+				 htonl(nat->sreg_proto_max));
+}
+
+static int
+nft_rule_expr_nat_snprintf(char *buf, size_t size, struct nft_rule_expr *e)
+{
+	struct nft_expr_nat *nat = (struct nft_expr_nat *)e->data;
+	int len = size, offset = 0, ret = 0;
+
+	switch (nat->type) {
+	case NFT_NAT_SNAT:
+		ret = snprintf(buf, len, "type=NFT_NAT_SNAT ");
+		break;
+	case NFT_NAT_DNAT:
+		ret = snprintf(buf, len, "type=NFT_NAT_DNAT ");
+		break;
+	}
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf, len, "family=%s ",
+		       nat->family == AF_INET ? "AF_INET" : "AF_INET6");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
+		ret = snprintf(buf, len,
+			       "sreg_addr_min_v4=%u sreg_addr_max_v4=%u ",
+			       nat->sreg_addr_min, nat->sreg_addr_max);
+	}
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
+		ret = snprintf(buf, len,
+			       "sreg_proto_min=%u sreg_proto_max=%u ",
+			       nat->sreg_proto_min, nat->sreg_proto_max);
+	}
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+struct expr_ops expr_ops_nat = {
+	.name		= "nat",
+	.alloc_len	= sizeof(struct nft_expr_nat),
+	.max_attr	= NFTA_NAT_MAX,
+	.set		= nft_rule_expr_nat_set,
+	.get		= nft_rule_expr_nat_get,
+	.parse		= nft_rule_expr_nat_parse,
+	.build		= nft_rule_expr_nat_build,
+	.snprintf	= nft_rule_expr_nat_snprintf,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 9d121a0..6a5a697 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -8,6 +8,7 @@ extern struct expr_ops expr_ops_counter;
 extern struct expr_ops expr_ops_immediate;
 extern struct expr_ops expr_ops_match;
 extern struct expr_ops expr_ops_meta;
+extern struct expr_ops expr_ops_nat;
 extern struct expr_ops expr_ops_payload;
 extern struct expr_ops expr_ops_target;
 
@@ -18,6 +19,7 @@ struct expr_ops *expr_ops[] = {
 	&expr_ops_immediate,
 	&expr_ops_match,
 	&expr_ops_meta,
+	&expr_ops_nat,
 	&expr_ops_payload,
 	&expr_ops_target,
 	NULL,
-- 
1.8.0

