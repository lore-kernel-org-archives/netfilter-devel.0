From: Eric Leblond <eric@regit.org>
Subject: [libnftables PATCH 1/2] expr: add support for nfnetlink queue
Date: Sat, 30 Nov 2013 11:57:21 +0100
Message-ID: <1385809042-20049-1-git-send-email-eric@regit.org>
References: <1385808722.4321.19.camel@ice-age2.regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:38773 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3K3K5h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 05:57:37 -0500
In-Reply-To: <1385808722.4321.19.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a support of the queue target.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/libnftables/expr.h          |   5 +
 include/linux/netfilter/nf_tables.h |  20 +++
 src/Makefile.am                     |   1 +
 src/expr/queue.c                    | 254 ++++++++++++++++++++++++++++++++++++
 4 files changed, 280 insertions(+)
 create mode 100644 src/expr/queue.c

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 54de186..d292773 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -143,6 +143,11 @@ enum {
 	NFT_EXPR_REJECT_CODE,
 };
 
+enum {
+	NFT_EXPR_QUEUE_NUM	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_QUEUE_TOTAL,
+	NFT_EXPR_QUEUE_FLAGS,
+};
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 4ec8187..b58990e 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -580,6 +580,26 @@ enum nft_log_attributes {
 #define NFTA_LOG_MAX		(__NFTA_LOG_MAX - 1)
 
 /**
+ * enum nft_queue_attributes - nf_tables queue expression netlink attributes
+ *
+ * @NFTA_QUEUE_NUM: netlink queue to send messages to (NLA_U16)
+ * @NFTA_QUEUE_TOTAL: number of queues to load balance packets on (NLA_U16)
+ * @NFTA_QUEUE_FLAGS: various flags (NLA_U16)
+ */
+enum nft_queue_attributes {
+	NFTA_QUEUE_UNSPEC,
+	NFTA_QUEUE_NUM,
+	NFTA_QUEUE_TOTAL,
+	NFTA_QUEUE_FLAGS,
+	__NFTA_QUEUE_MAX
+};
+#define NFTA_QUEUE_MAX		(__NFTA_QUEUE_MAX - 1)
+
+#define NFT_QUEUE_FLAG_BYPASS		0x01 /* for compatibility with v2 */
+#define NFT_QUEUE_FLAG_CPU_FANOUT	0x02 /* use current CPU (no hashing) */
+#define NFT_QUEUE_FLAG_MASK		0x03
+
+/**
  * enum nft_reject_types - nf_tables reject expression reject types
  *
  * @NFT_REJECT_ICMP_UNREACH: reject using ICMP unreachable
diff --git a/src/Makefile.am b/src/Makefile.am
index 83ab658..441e96e 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -31,6 +31,7 @@ libnftables_la_SOURCES = utils.c		\
 			 expr/meta.c		\
 			 expr/nat.c		\
 			 expr/payload.c		\
+			 expr/queue.c		\
 			 expr/reject.c		\
 			 expr/target.c		\
 			 expr/data_reg.h	\
diff --git a/src/expr/queue.c b/src/expr/queue.c
new file mode 100644
index 0000000..4c1c8a7
--- /dev/null
+++ b/src/expr/queue.c
@@ -0,0 +1,254 @@
+/*
+ * (C) 2013 by Eric Leblond <eric@regit.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftables/expr.h>
+#include <libnftables/rule.h>
+#include "expr_ops.h"
+
+struct nft_expr_queue {
+	uint16_t		queuenum;
+	uint16_t		queues_total;
+	uint16_t		flags;
+};
+
+static int nft_rule_expr_queue_set(struct nft_rule_expr *e, uint16_t type,
+				    const void *data, uint32_t data_len)
+{
+	struct nft_expr_queue *queue = nft_expr_data(e);
+
+	switch(type) {
+	case NFT_EXPR_QUEUE_NUM:
+		queue->queuenum = *((uint16_t *)data);
+		break;
+	case NFT_EXPR_QUEUE_TOTAL:
+		queue->queues_total = *((uint16_t *)data);
+		break;
+	case NFT_EXPR_QUEUE_FLAGS:
+		queue->flags = *((uint16_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nft_rule_expr_queue_get(const struct nft_rule_expr *e, uint16_t type,
+			 uint32_t *data_len)
+{
+	struct nft_expr_queue *queue = nft_expr_data(e);
+
+	switch(type) {
+	case NFT_EXPR_QUEUE_NUM:
+		*data_len = sizeof(queue->queuenum);
+		return &queue->queuenum;
+	case NFT_EXPR_QUEUE_TOTAL:
+		*data_len = sizeof(queue->queues_total);
+		return &queue->queues_total;
+	case NFT_EXPR_QUEUE_FLAGS:
+		*data_len = sizeof(queue->flags);
+		return &queue->flags;
+	}
+	return NULL;
+}
+
+static int nft_rule_expr_queue_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_QUEUE_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_QUEUE_NUM:
+	case NFTA_QUEUE_TOTAL:
+	case NFTA_QUEUE_FLAGS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0) {
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
+static void
+nft_rule_expr_queue_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
+{
+	struct nft_expr_queue *queue = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_QUEUE_NUM))
+		mnl_attr_put_u16(nlh, NFTA_QUEUE_NUM, htons(queue->queuenum));
+	if (e->flags & (1 << NFT_EXPR_QUEUE_TOTAL))
+		mnl_attr_put_u16(nlh, NFTA_QUEUE_TOTAL, htons(queue->queues_total));
+	if (e->flags & (1 << NFT_EXPR_QUEUE_FLAGS))
+		mnl_attr_put_u16(nlh, NFTA_QUEUE_FLAGS, htons(queue->flags));
+}
+
+static int
+nft_rule_expr_queue_parse(struct nft_rule_expr *e, struct nlattr *attr)
+{
+	struct nft_expr_queue *queue = nft_expr_data(e);
+	struct nlattr *tb[NFTA_QUEUE_MAX+1] = {};
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_queue_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_QUEUE_NUM]) {
+		queue->queuenum = ntohs(mnl_attr_get_u16(tb[NFTA_QUEUE_NUM]));
+		e->flags |= (1 << NFT_EXPR_QUEUE_NUM);
+	}
+	if (tb[NFTA_QUEUE_TOTAL]) {
+		queue->queues_total = ntohs(mnl_attr_get_u16(tb[NFTA_QUEUE_TOTAL]));
+		e->flags |= (1 << NFT_EXPR_QUEUE_TOTAL);
+	}
+	if (tb[NFTA_QUEUE_FLAGS]) {
+		queue->flags = ntohs(mnl_attr_get_u16(tb[NFTA_QUEUE_FLAGS]));
+		e->flags |= (1 << NFT_EXPR_QUEUE_FLAGS);
+	}
+
+	return 0;
+}
+
+static int
+nft_rule_expr_queue_json_parse(struct nft_rule_expr *e, json_t *root)
+{
+#ifdef JSON_PARSING
+	uint32_t type;
+	uint16_t code;
+
+	if (nft_jansson_parse_val(root, "num", NFT_TYPE_U16, &type) < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_QUEUE_NUM, type);
+
+	if (nft_jansson_parse_val(root, "total", NFT_TYPE_U16, &code) < 0)
+		return -1;
+
+	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_TOTAL, code);
+
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U16, &code) < 0)
+		return -1;
+
+	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_FLAGS, code);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_queue_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
+{
+#ifdef XML_PARSING
+	struct nft_expr_queue *queue = nft_expr_data(e);
+
+	if (nft_mxml_num_parse(tree, "num", MXML_DESCEND_FIRST, BASE_DEC,
+			       &queue->queuenum, NFT_TYPE_U16, NFT_XML_MAND) != 0)
+		return -1;
+
+	e->flags |= (1 << NFT_EXPR_QUEUE_NUM);
+
+	if (nft_mxml_num_parse(tree, "total", MXML_DESCEND_FIRST, BASE_DEC,
+			       &queue->queues_total, NFT_TYPE_U8, NFT_XML_MAND) != 0)
+		return -1;
+
+	e->flags |= (1 << NFT_EXPR_QUEUE_TOTAL);
+
+	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
+			       &queue->flags, NFT_TYPE_U8, NFT_XML_MAND) != 0)
+		return -1;
+
+	e->flags |= (1 << NFT_EXPR_QUEUE_FLAGS);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_queue_snprintf(char *buf, size_t len, uint32_t type,
+			      uint32_t flags, struct nft_rule_expr *e)
+{
+	struct nft_expr_queue *queue = nft_expr_data(e);
+	int ret;
+	int one = 0;
+
+	switch(type) {
+	case NFT_OUTPUT_DEFAULT:
+		ret = snprintf(buf, len, "num %u total %u",
+				queue->queuenum, queue->queues_total);
+		if (queue->flags) {
+			ret += snprintf(buf + ret , len - ret, " options ");
+			if (queue->flags & NFT_QUEUE_FLAG_BYPASS) {
+				ret += snprintf(buf + ret ,
+						len - ret, "bypass");
+				one = 1;
+			}
+			if (queue->flags & NFT_QUEUE_FLAG_CPU_FANOUT) {
+				if (one)
+					ret += snprintf(buf + ret ,
+							len - ret, ",");
+				ret += snprintf(buf + ret ,
+						len - ret, "fanout");
+			}
+		}
+		return ret;
+	case NFT_OUTPUT_XML:
+		return snprintf(buf, len, "<num>%u</num>"
+					  "<total>%u</total>"
+					  "<flags>%u</flags>",
+				queue->queuenum, queue->queues_total,
+				queue->flags);
+	case NFT_OUTPUT_JSON:
+		return snprintf(buf, len, "\"num\":%u,"
+					  "\"total\":%u,"
+					  "\"flags\":%u,",
+				queue->queuenum, queue->queues_total,
+				queue->flags);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_queue = {
+	.name		= "queue",
+	.alloc_len	= sizeof(struct nft_expr_queue),
+	.max_attr	= NFTA_QUEUE_MAX,
+	.set		= nft_rule_expr_queue_set,
+	.get		= nft_rule_expr_queue_get,
+	.parse		= nft_rule_expr_queue_parse,
+	.build		= nft_rule_expr_queue_build,
+	.snprintf	= nft_rule_expr_queue_snprintf,
+	.xml_parse	= nft_rule_expr_queue_xml_parse,
+	.json_parse	= nft_rule_expr_queue_json_parse,
+};
+
+static void __init expr_queue_init(void)
+{
+	nft_expr_ops_register(&expr_ops_queue);
+}
-- 
1.8.4.4

