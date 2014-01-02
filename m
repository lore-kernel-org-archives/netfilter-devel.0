From: Eric Leblond <eric@regit.org>
Subject: [libnftables PATCH] expr: add ct_set expression
Date: Thu,  2 Jan 2014 10:14:39 +0100
Message-ID: <1388654079-31459-1-git-send-email-eric@regit.org>
References: <1388653976-30802-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:54827 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaABJPC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:15:02 -0500
In-Reply-To: <1388653976-30802-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for 'ct_set' expression which is a port
of iptables CT target.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/libnftables/expr.h          |  11 ++
 include/linux/netfilter/nf_tables.h |  35 ++++
 src/Makefile.am                     |   1 +
 src/expr/ct_set.c                   | 373 ++++++++++++++++++++++++++++++++++++
 4 files changed, 420 insertions(+)
 create mode 100644 src/expr/ct_set.c

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 25455e4..71c66ae 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -149,6 +149,17 @@ enum {
 	NFT_EXPR_QUEUE_TOTAL,
 	NFT_EXPR_QUEUE_FLAGS,
 };
+
+enum {
+	NFT_EXPR_CT_SET_FLAGS	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_CT_SET_PROTO,
+	NFT_EXPR_CT_SET_ZONEID,
+	NFT_EXPR_CT_SET_CTEVENTS,
+	NFT_EXPR_CT_SET_EXPEVENTS,
+	NFT_EXPR_CT_SET_HELPER,
+	NFT_EXPR_CT_SET_TIMEOUT,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e08f80e..7c0c15b 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -628,6 +628,41 @@ enum nft_reject_attributes {
 #define NFTA_REJECT_MAX		(__NFTA_REJECT_MAX - 1)
 
 /**
+ * enum nft_ct_set_attributes - nf_tables ct_set expression netlink attributes
+ *
+ * @NFTA_CT_SET_PROTO: layer 4 protocol
+ * @NFTA_CT_SET_FLAGS: flags for connection as NOTRACK for example
+ * @NFTA_CT_SET_HELPER: protocol helper to link with matching connections
+ * @NFTA_CT_SET_CTEVENTS: only generate the specified conntrack events
+ * @NFTA_CT_SET_EXPEVENTS: only generate the specified expectation events
+ * @NFTA_CT_SET_ZONEID: assign packet to sone id
+ * @NFTA_CT_SET_TIMEOUT: use timeout policy for the connection
+ *
+ */
+enum nft_ct_set_attributes {
+	NFTA_CT_SET_UNSPEC,
+	NFTA_CT_SET_PROTO,
+	NFTA_CT_SET_FLAGS,
+	NFTA_CT_SET_HELPER,
+	NFTA_CT_SET_CTEVENTS,
+	NFTA_CT_SET_EXPEVENTS,
+	NFTA_CT_SET_ZONEID,
+	NFTA_CT_SET_TIMEOUT,
+	__NFTA_CT_SET_MAX
+};
+#define NFTA_CT_SET_MAX		(__NFTA_CT_SET_MAX - 1)
+
+/**
+ * enum nft_ct_set_flags - nf_tables ct_set flags
+ *
+ * @NFT_CT_SET_F_NOTRACK: do not track this connection
+ */
+enum nft_ct_set_flags {
+	NFT_CT_SET_F_NOTRACK = 0x1,
+};
+
+
+/**
  * enum nft_nat_types - nf_tables nat expression NAT types
  *
  * @NFT_NAT_SNAT: source NAT
diff --git a/src/Makefile.am b/src/Makefile.am
index 441e96e..e39ba25 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -21,6 +21,7 @@ libnftables_la_SOURCES = utils.c		\
 			 expr/cmp.c		\
 			 expr/counter.c		\
 			 expr/ct.c		\
+			 expr/ct_set.c		\
 			 expr/data_reg.c	\
 			 expr/exthdr.c		\
 			 expr/limit.c		\
diff --git a/src/expr/ct_set.c b/src/expr/ct_set.c
new file mode 100644
index 0000000..8449c5a
--- /dev/null
+++ b/src/expr/ct_set.c
@@ -0,0 +1,373 @@
+/*
+ * (C) 2014 by Eric Leblond <eric@regit.or>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdint.h>
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
+struct nft_expr_ct_set {
+	uint16_t	flags;
+	uint16_t	proto;
+	uint16_t	zoneid;
+	uint32_t	ct_events;
+	uint32_t	exp_events;
+	char		*helper;
+	char		*timeout;
+};
+
+static int nft_rule_expr_ct_set_set(struct nft_rule_expr *e, uint16_t type,
+				 const void *data, uint32_t data_len)
+{
+	struct nft_expr_ct_set *ct_set = nft_expr_data(e);
+
+	switch(type) {
+	case NFT_EXPR_CT_SET_FLAGS:
+		ct_set->flags = *((uint16_t *)data);
+		break;
+	case NFT_EXPR_CT_SET_PROTO:
+		ct_set->proto = *((uint16_t *)data);
+		break;
+	case NFT_EXPR_CT_SET_ZONEID:
+		ct_set->zoneid = *((uint16_t *)data);
+		break;
+	case NFT_EXPR_CT_SET_CTEVENTS:
+		ct_set->ct_events = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_CT_SET_EXPEVENTS:
+		ct_set->exp_events = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_CT_SET_HELPER:
+		if (ct_set->helper)
+			xfree(ct_set->helper);
+
+		ct_set->helper = strdup(data);
+		break;
+	case NFT_EXPR_CT_SET_TIMEOUT:
+		if (ct_set->timeout)
+			xfree(ct_set->timeout);
+
+		ct_set->timeout = strdup(data);
+		break;
+
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nft_rule_expr_ct_set_get(const struct nft_rule_expr *e, uint16_t type,
+		      uint32_t *data_len)
+{
+	struct nft_expr_ct_set *ct_set = nft_expr_data(e);
+
+	switch(type) {
+	case NFT_EXPR_CT_SET_FLAGS:
+		*data_len = sizeof(ct_set->flags);
+		return &ct_set->flags;
+	case NFT_EXPR_CT_SET_PROTO:
+		*data_len = sizeof(ct_set->proto);
+		return &ct_set->proto;
+	case NFT_EXPR_CT_SET_ZONEID:
+		*data_len = sizeof(ct_set->zoneid);
+		return &ct_set->zoneid;
+	case NFT_EXPR_CT_SET_CTEVENTS:
+		*data_len = sizeof(ct_set->ct_events);
+		return &ct_set->ct_events;
+	case NFT_EXPR_CT_SET_EXPEVENTS:
+		*data_len = sizeof(ct_set->exp_events);
+		return &ct_set->exp_events;
+	case NFT_EXPR_CT_SET_HELPER:
+		*data_len = strlen(ct_set->helper)+1;
+		return ct_set->helper;
+	case NFT_EXPR_CT_SET_TIMEOUT:
+		*data_len = strlen(ct_set->timeout)+1;
+		return ct_set->timeout;
+	}
+	return NULL;
+}
+
+static int nft_rule_expr_ct_set_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_CT_SET_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_CT_SET_FLAGS:
+	case NFTA_CT_SET_PROTO:
+	case NFTA_CT_SET_ZONEID:
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFTA_CT_SET_CTEVENTS:
+	case NFTA_CT_SET_EXPEVENTS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFTA_CT_SET_HELPER:
+	case NFTA_CT_SET_TIMEOUT:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
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
+nft_rule_expr_ct_set_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
+{
+	struct nft_expr_ct_set *ct_set = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_CT_SET_FLAGS))
+		mnl_attr_put_u16(nlh, NFTA_CT_SET_FLAGS, htons(ct_set->flags));
+	if (e->flags & (1 << NFT_EXPR_CT_SET_PROTO))
+		mnl_attr_put_u16(nlh, NFTA_CT_SET_PROTO, htons(ct_set->proto));
+	if (e->flags & (1 << NFT_EXPR_CT_SET_ZONEID))
+		mnl_attr_put_u16(nlh, NFTA_CT_SET_ZONEID, htons(ct_set->zoneid));
+	if (e->flags & (1 << NFT_EXPR_CT_SET_CTEVENTS))
+		mnl_attr_put_u32(nlh, NFTA_CT_SET_CTEVENTS, htonl(ct_set->ct_events));
+	if (e->flags & (1 << NFT_EXPR_CT_SET_EXPEVENTS))
+		mnl_attr_put_u32(nlh, NFTA_CT_SET_EXPEVENTS, htonl(ct_set->exp_events));
+	if (e->flags & (1 << NFT_EXPR_CT_SET_HELPER))
+		mnl_attr_put_strz(nlh, NFTA_CT_SET_HELPER, ct_set->helper);
+	if (e->flags & (1 << NFT_EXPR_CT_SET_TIMEOUT))
+		mnl_attr_put_strz(nlh, NFTA_CT_SET_TIMEOUT, ct_set->timeout);
+}
+
+static int
+nft_rule_expr_ct_set_parse(struct nft_rule_expr *e, struct nlattr *attr)
+{
+	struct nft_expr_ct_set *ct_set = nft_expr_data(e);
+	struct nlattr *tb[NFTA_CT_SET_MAX+1] = {};
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_ct_set_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_CT_SET_FLAGS]) {
+		ct_set->flags = ntohs(mnl_attr_get_u16(tb[NFTA_CT_SET_FLAGS]));
+		e->flags |= (1 << NFT_EXPR_CT_SET_FLAGS);
+	}
+	if (tb[NFTA_CT_SET_PROTO]) {
+		ct_set->proto = ntohs(mnl_attr_get_u16(tb[NFTA_CT_SET_PROTO]));
+		e->flags |= (1 << NFT_EXPR_CT_SET_PROTO);
+	}
+	if (tb[NFTA_CT_SET_ZONEID]) {
+		ct_set->zoneid = ntohs(mnl_attr_get_u16(tb[NFTA_CT_SET_ZONEID]));
+		e->flags |= (1 << NFT_EXPR_CT_SET_ZONEID);
+	}
+	if (tb[NFTA_CT_SET_CTEVENTS]) {
+		ct_set->ct_events = ntohl(mnl_attr_get_u32(tb[NFTA_CT_SET_CTEVENTS]));
+		e->flags |= (1 << NFT_EXPR_CT_SET_CTEVENTS);
+	}
+	if (tb[NFTA_CT_SET_EXPEVENTS]) {
+		ct_set->exp_events = ntohl(mnl_attr_get_u32(tb[NFTA_CT_SET_EXPEVENTS]));
+		e->flags |= (1 << NFT_EXPR_CT_SET_EXPEVENTS);
+	}
+	if (tb[NFTA_CT_SET_HELPER]) {
+		if (ct_set->helper)
+			xfree(ct_set->helper);
+
+		ct_set->helper = strdup(mnl_attr_get_str(tb[NFTA_CT_SET_HELPER]));
+		e->flags |= (1 << NFT_EXPR_CT_SET_HELPER);
+	}
+	if (tb[NFTA_CT_SET_TIMEOUT]) {
+		if (ct_set->timeout)
+			xfree(ct_set->timeout);
+
+		ct_set->helper = strdup(mnl_attr_get_str(tb[NFTA_CT_SET_TIMEOUT]));
+		e->flags |= (1 << NFT_EXPR_CT_SET_TIMEOUT);
+	}
+	return 0;
+}
+
+static int nft_rule_expr_ct_set_json_parse(struct nft_rule_expr *e, json_t *root)
+{
+#ifdef JSON_PARSING
+	const char *uvalstr;
+	uint32_t uval32;
+	uint16_t uval16;
+
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U16, &uval16) < 0)
+		return -1;
+	nft_rule_expr_set_u16(e, NFT_EXPR_CT_SET_FLAGS, uval16);
+
+	if (nft_jansson_parse_val(root, "proto", NFT_TYPE_U16, &uval16) < 0)
+		return -1;
+	nft_rule_expr_set_u16(e, NFT_EXPR_CT_SET_PROTO, uval16);
+
+	if (nft_jansson_parse_val(root, "zoneid", NFT_TYPE_U16, &uval16) < 0)
+		return -1;
+	nft_rule_expr_set_u16(e, NFT_EXPR_CT_SET_ZONEID, uval16);
+
+	if (nft_jansson_parse_val(root, "ctevents", NFT_TYPE_U32, &uval32) < 0)
+		return -1;
+	nft_rule_expr_set_u32(e, NFT_EXPR_CT_SET_CTEVENTS, uval32);
+
+	if (nft_jansson_parse_val(root, "expevents", NFT_TYPE_U32, &uval32) < 0)
+		return -1;
+	nft_rule_expr_set_u32(e, NFT_EXPR_CT_SET_EXPEVENTS, uval32);
+
+	uvalstr = nft_jansson_parse_str(root, "helper");
+	if (uvalstr == NULL)
+		return -1;
+	nft_rule_expr_set_str(e, NFT_EXPR_CT_SET_HELPER, uvalstr);
+
+	uvalstr = nft_jansson_parse_str(root, "timeout");
+	if (uvalstr == NULL)
+		return -1;
+	nft_rule_expr_set_str(e, NFT_EXPR_CT_SET_TIMEOUT, uvalstr);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nft_rule_expr_ct_set_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
+{
+#ifdef XML_PARSING
+	struct nft_expr_ct_set *ct_set = nft_expr_data(e);
+	const char *uvalstr;
+
+	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
+			       &ct_set->flags, NFT_TYPE_U16, NFT_XML_MAND) != 0)
+		return -1;
+	e->flags |= (1 << NFT_EXPR_CT_SET_FLAGS);
+
+	if (nft_mxml_num_parse(tree, "proto", MXML_DESCEND_FIRST, BASE_DEC,
+			       &ct_set->proto, NFT_TYPE_U16, NFT_XML_MAND) != 0)
+		return -1;
+	e->flags |= (1 << NFT_EXPR_CT_SET_PROTO);
+
+	if (nft_mxml_num_parse(tree, "zoneid", MXML_DESCEND_FIRST, BASE_DEC,
+			       &ct_set->flags, NFT_TYPE_U16, NFT_XML_MAND) != 0)
+		return -1;
+	e->flags |= (1 << NFT_EXPR_CT_SET_ZONEID);
+
+	if (nft_mxml_num_parse(tree, "ctevents", MXML_DESCEND_FIRST, BASE_DEC,
+			       &ct_set->ct_events, NFT_TYPE_U32, NFT_XML_MAND) != 0)
+		return -1;
+	e->flags |= (1 << NFT_EXPR_CT_SET_CTEVENTS);
+
+	if (nft_mxml_num_parse(tree, "expevents", MXML_DESCEND_FIRST, BASE_DEC,
+			       &ct_set->exp_events, NFT_TYPE_U32, NFT_XML_MAND) != 0)
+		return -1;
+	e->flags |= (1 << NFT_EXPR_CT_SET_EXPEVENTS);
+
+	uvalstr = nft_mxml_str_parse(tree, "helper", MXML_DESCEND_FIRST,
+				    NFT_XML_MAND);
+	if (uvalstr == NULL)
+		return -1;
+	ct_set->helper = strdup(uvalstr);
+	e->flags |= (1 << NFT_EXPR_CT_SET_HELPER);
+
+	uvalstr = nft_mxml_str_parse(tree, "timeout", MXML_DESCEND_FIRST,
+				    NFT_XML_MAND);
+	if (uvalstr == NULL)
+		return -1;
+	ct_set->timeout = strdup(uvalstr);
+	e->flags |= (1 << NFT_EXPR_CT_SET_TIMEOUT);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_ct_set_snprintf(char *buf, size_t len, uint32_t type,
+			    uint32_t flags, struct nft_rule_expr *e)
+{
+	struct nft_expr_ct_set *ct_set = nft_expr_data(e);
+
+	switch(type) {
+	case NFT_OUTPUT_DEFAULT:
+		return snprintf(buf, len, "flags %u proto %u zoneid %u "
+					  "ctevents %u expevents %u "
+					  "helper %s timeout %s",
+				ct_set->flags, ct_set->proto, ct_set->zoneid,
+				ct_set->ct_events, ct_set->exp_events,
+				ct_set->helper, ct_set->timeout);
+	case NFT_OUTPUT_XML:
+		return snprintf(buf, len, "<flags>%u</flags>"
+					  "<proto>%u</proto>"
+					  "<zoneid>%u</zoneid>"
+					  "<ctevents>%u</ctevents>"
+					  "<expevents>%u</expevents>"
+					  "<helper>%s</helper>"
+					  "<timeout>%s</timeout>",
+				ct_set->flags, ct_set->proto, ct_set->zoneid,
+				ct_set->ct_events, ct_set->exp_events,
+				ct_set->helper, ct_set->timeout);
+	case NFT_OUTPUT_JSON:
+		return snprintf(buf, len, "\"flags\":%u,"
+					  "\"proto\":%u,"
+					  "\"zoneid\":%u,"
+					  "\"ctevents\":%u,"
+					  "\"expevents\":%u,"
+					  "\"helper\":\"%s\","
+					  "\"timeout\":\"%s\"",
+				ct_set->flags, ct_set->proto, ct_set->zoneid,
+				ct_set->ct_events, ct_set->exp_events,
+				ct_set->helper, ct_set->timeout);
+	default:
+		break;
+	}
+	return -1;
+}
+
+static void nft_rule_expr_ct_set_free(struct nft_rule_expr *e)
+{
+	struct nft_expr_ct_set *ct_set = nft_expr_data(e);
+
+	xfree(ct_set->helper);
+	xfree(ct_set->timeout);
+}
+
+struct expr_ops expr_ops_ct_set = {
+	.name		= "ct_set",
+	.alloc_len	= sizeof(struct nft_expr_ct_set),
+	.max_attr	= NFTA_LOG_MAX,
+	.free		= nft_rule_expr_ct_set_free,
+	.set		= nft_rule_expr_ct_set_set,
+	.get		= nft_rule_expr_ct_set_get,
+	.parse		= nft_rule_expr_ct_set_parse,
+	.build		= nft_rule_expr_ct_set_build,
+	.snprintf	= nft_rule_expr_ct_set_snprintf,
+	.xml_parse	= nft_rule_expr_ct_set_xml_parse,
+	.json_parse	= nft_rule_expr_ct_set_json_parse,
+};
+
+static void __init expr_ct_set_init(void)
+{
+	nft_expr_ops_register(&expr_ops_ct_set);
+}
-- 
1.8.5.2

