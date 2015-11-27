From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 libnftnl 1/3] src: add trace infrastructure support
Date: Fri, 27 Nov 2015 19:43:18 +0100
Message-ID: <1448649800-26153-2-git-send-email-fw@strlen.de>
References: <1448649800-26153-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39634 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbbK0Snd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 13:43:33 -0500
In-Reply-To: <1448649800-26153-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parses trace monitor netlink messages from the kernel and builds
nftnl_trace struct that contains the dissected information.

Provides getters to access these attributes.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
Changes since v2:
 - add NFTNL_TRACE_NFPROTO, NFTNL_TRACE_POLICY, NFTNL_TRACE_OIFTYPE
 - use VERDICT without changing it
 - remove NFTNL_TRACE_QUEUE_ID

Changes since v1:
 - removed all printf support, not needed by Patricks nft patch
 - adjust for changed NFTA_TRACE* kernel attributes
 - VERDICT is now nested, so treat it accordingly
 - removed TRANSPORTPROTO, seems its not needed at this time
 - add NFTNL_TRACE_QUEUE_ID to obtain nfqueue number
 - NF_VERDICT is normalized in this case, i.e.
 if verdict from kernel is '42 << 16 | NF_QUEUE', make
 NF_QUEUE the verdict and put the queue number ->queue_id, accessible
 via NFTNL_TRACE_QUEUE_ID.

 include/libnftnl/Makefile.am        |   1 +
 include/libnftnl/trace.h            |  55 +++++
 include/linux/netfilter/nf_tables.h |  52 +++++
 src/Makefile.am                     |   1 +
 src/libnftnl.map                    |  15 ++
 src/trace.c                         | 438 ++++++++++++++++++++++++++++++++++++
 src/utils.c                         |  12 +
 7 files changed, 574 insertions(+)
 create mode 100644 include/libnftnl/trace.h
 create mode 100644 src/trace.c

diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile.am
index a20aaee..84f01b6 100644
--- a/include/libnftnl/Makefile.am
+++ b/include/libnftnl/Makefile.am
@@ -1,5 +1,6 @@
 pkginclude_HEADERS = batch.h		\
 		     table.h		\
+		     trace.h		\
 		     chain.h		\
 		     rule.h		\
 		     expr.h		\
diff --git a/include/libnftnl/trace.h b/include/libnftnl/trace.h
new file mode 100644
index 0000000..674bc16
--- /dev/null
+++ b/include/libnftnl/trace.h
@@ -0,0 +1,55 @@
+#ifndef _LIBNFTNL_TRACE_H_
+#define _LIBNFTNL_TRACE_H_
+
+#include <stdint.h>
+#include <stdbool.h>
+#include <sys/types.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+enum nftnl_trace_attr {
+	NFTNL_TRACE_CHAIN = 0,
+	NFTNL_TRACE_FAMILY,
+	NFTNL_TRACE_ID,
+	NFTNL_TRACE_IIF,
+	NFTNL_TRACE_IIFTYPE,
+	NFTNL_TRACE_JUMP_TARGET,
+	NFTNL_TRACE_OIF,
+	NFTNL_TRACE_OIFTYPE,
+	NFTNL_TRACE_MARK,
+	NFTNL_TRACE_LL_HEADER,
+	NFTNL_TRACE_NETWORK_HEADER,
+	NFTNL_TRACE_TRANSPORT_HEADER,
+	NFTNL_TRACE_TABLE,
+	NFTNL_TRACE_TYPE,
+	NFTNL_TRACE_RULE_HANDLE,
+	NFTNL_TRACE_VERDICT,
+	NFTNL_TRACE_NFPROTO,
+	NFTNL_TRACE_POLICY,
+	__NFTNL_TRACE_MAX,
+};
+#define NFTNL_TRACE_MAX (__NFTNL_TRACE_MAX - 1)
+
+struct nftnl_trace;
+
+struct nftnl_trace *nftnl_trace_alloc(void);
+void nftnl_trace_free(struct nftnl_trace *trace);
+
+bool nftnl_trace_is_set(const struct nftnl_trace *trace, uint16_t type);
+
+const void *nftnl_trace_get_data(const struct nftnl_trace *trace,
+				 uint16_t type, uint32_t *data_len);
+
+uint16_t nftnl_trace_get_u16(const struct nftnl_trace *trace, uint16_t type);
+uint32_t nftnl_trace_get_u32(const struct nftnl_trace *trace, uint16_t type);
+uint64_t nftnl_trace_get_u64(const struct nftnl_trace *trace, uint16_t type);
+const char *nftnl_trace_get_str(const struct nftnl_trace *trace, uint16_t type);
+
+int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t);
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
+#endif /* _LIBNFTNL_TRACE_H_ */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 5420c8c..f77693b 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -83,6 +83,7 @@ enum nft_verdicts {
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
  * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
+ * @NFT_MSG_TRACE: trace event (enum nft_trace_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -102,6 +103,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_DELSETELEM,
 	NFT_MSG_NEWGEN,
 	NFT_MSG_GETGEN,
+	NFT_MSG_TRACE,
 	NFT_MSG_MAX,
 };
 
@@ -987,4 +989,54 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+/**
+ * enum nft_trace_attributes - nf_tables trace netlink attributes
+ *
+ * @NFTA_TRACE_TABLE: name of the table (NLA_STRING)
+ * @NFTA_TRACE_CHAIN: name of the chain (NLA_STRING)
+ * @NFTA_TRACE_RULE_HANDLE: numeric handle of the rule (NLA_U64)
+ * @NFTA_TRACE_TYPE: type of the event (NLA_U32: nft_trace_types)
+ * @NFTA_TRACE_VERDICT: verdict returned by hook (NLA_NESTED: nft_verdicts)
+ * @NFTA_TRACE_ID: pseudo-id, same for each skb traced (NLA_U32)
+ * @NFTA_TRACE_LL_HEADER: linklayer header (NLA_BINARY)
+ * @NFTA_TRACE_NETWORK_HEADER: network header (NLA_BINARY)
+ * @NFTA_TRACE_TRANSPORT_HEADER: transport header (NLA_BINARY)
+ * @NFTA_TRACE_IIF: indev ifindex (NLA_U32)
+ * @NFTA_TRACE_IIFTYPE: netdev->type of indev (NLA_U16)
+ * @NFTA_TRACE_OIF: outdev ifindex (NLA_U32)
+ * @NFTA_TRACE_OIFTYPE: netdev->type of outdev (NLA_U16)
+ * @NFTA_TRACE_MARK: nfmark (NLA_U32)
+ * @NFTA_TRACE_NFPROTO: nf protocol processed (NLA_U32)
+ * @NFTA_TRACE_POLICY: policy that decided fate of packet (NLA_U32)
+ */
+enum nft_trace_attibutes {
+	NFTA_TRACE_UNSPEC,
+	NFTA_TRACE_TABLE,
+	NFTA_TRACE_CHAIN,
+	NFTA_TRACE_RULE_HANDLE,
+	NFTA_TRACE_TYPE,
+	NFTA_TRACE_VERDICT,
+	NFTA_TRACE_ID,
+	NFTA_TRACE_LL_HEADER,
+	NFTA_TRACE_NETWORK_HEADER,
+	NFTA_TRACE_TRANSPORT_HEADER,
+	NFTA_TRACE_IIF,
+	NFTA_TRACE_IIFTYPE,
+	NFTA_TRACE_OIF,
+	NFTA_TRACE_OIFTYPE,
+	NFTA_TRACE_MARK,
+	NFTA_TRACE_NFPROTO,
+	NFTA_TRACE_POLICY,
+	__NFTA_TRACE_MAX
+};
+#define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
+
+enum nft_trace_types {
+	NFT_TRACETYPE_UNSPEC,
+	NFT_TRACETYPE_POLICY,
+	NFT_TRACETYPE_RETURN,
+	NFT_TRACETYPE_RULE,
+	__NFT_TRACETYPE_MAX
+};
+#define NFT_TRACETYPE_MAX (__NFT_TRACETYPE_MAX - 1)
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index 107cae5..795307d 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -11,6 +11,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      common.c		\
 		      gen.c		\
 		      table.c		\
+		      trace.c		\
 		      chain.c		\
 		      rule.c		\
 		      set.c		\
diff --git a/src/libnftnl.map b/src/libnftnl.map
index a52b54e..2e193b7 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -498,3 +498,18 @@ global:
 
 local: *;
 };
+
+LIBNFTNL_4.1 {
+	nftnl_trace_alloc;
+	nftnl_trace_free;
+
+	nftnl_trace_is_set;
+
+	nftnl_trace_get_u16;
+	nftnl_trace_get_u32;
+	nftnl_trace_get_u64;
+	nftnl_trace_get_str;
+	nftnl_trace_get_data;
+
+	nftnl_trace_nlmsg_parse;
+} LIBNFTNL_4;
diff --git a/src/trace.c b/src/trace.c
new file mode 100644
index 0000000..b04abb5
--- /dev/null
+++ b/src/trace.c
@@ -0,0 +1,438 @@
+/*
+ * (C) 2015 Red Hat GmbH
+ * Author: Florian Westphal <fw@strlen.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include "internal.h"
+
+#include <time.h>
+#include <endian.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <netinet/in.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libnftnl/trace.h>
+
+struct nftnl_header_data {
+	char *data;
+	unsigned int len;
+};
+
+struct nftnl_trace {
+	char *table;
+	char *chain;
+	char *jump_target;
+	uint64_t rule_handle;
+	struct nftnl_header_data ll;
+	struct nftnl_header_data nh;
+	struct nftnl_header_data th;
+	uint32_t family;
+	uint32_t type;
+	uint32_t id;
+	uint32_t iif;
+	uint32_t oif;
+	uint32_t mark;
+	uint32_t verdict;
+	uint32_t nfproto;
+	uint32_t policy;
+	uint16_t iiftype;
+	uint16_t oiftype;
+
+	uint32_t flags;
+};
+
+EXPORT_SYMBOL(nftnl_trace_alloc);
+struct nftnl_trace *nftnl_trace_alloc(void)
+{
+	return calloc(1, sizeof(struct nftnl_trace));
+}
+
+EXPORT_SYMBOL(nftnl_trace_free);
+void nftnl_trace_free(struct nftnl_trace *t)
+{
+	xfree(t->chain);
+	xfree(t->table);
+	xfree(t->jump_target);
+	xfree(t->ll.data);
+	xfree(t->nh.data);
+	xfree(t->th.data);
+	xfree(t);
+}
+
+EXPORT_SYMBOL(nftnl_trace_is_set);
+bool nftnl_trace_is_set(const struct nftnl_trace *t, uint16_t attr)
+{
+	return t->flags & (1 << attr);
+}
+
+static int nftnl_trace_parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	enum nft_trace_attibutes type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_TRACE_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_TRACE_UNSPEC:
+	case __NFTA_TRACE_MAX:
+		break;
+	case NFTA_TRACE_VERDICT:
+                if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
+		break;
+	case NFTA_TRACE_IIFTYPE:
+	case NFTA_TRACE_OIFTYPE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+			abi_breakage();
+		break;
+	case NFTA_TRACE_ID:
+	case NFTA_TRACE_IIF:
+	case NFTA_TRACE_MARK:
+	case NFTA_TRACE_OIF:
+	case NFTA_TRACE_POLICY:
+	case NFTA_TRACE_NFPROTO:
+	case NFTA_TRACE_TYPE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	case NFTA_TRACE_CHAIN:
+	case NFTA_TRACE_TABLE:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	case NFTA_TRACE_RULE_HANDLE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
+	case NFTA_TRACE_LL_HEADER:	/* fallthrough */
+	case NFTA_TRACE_NETWORK_HEADER:
+	case NFTA_TRACE_TRANSPORT_HEADER:
+		if (mnl_attr_get_payload_len(attr) == 0)
+			abi_breakage();
+		break;
+	};
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+EXPORT_SYMBOL(nftnl_trace_get_data);
+const void *nftnl_trace_get_data(const struct nftnl_trace *trace,
+				 uint16_t type, uint32_t *data_len)
+{
+	enum nftnl_trace_attr attr = type;
+
+	if (!(trace->flags & (1 << type)))
+		return NULL;
+
+	switch (attr) {
+	case NFTNL_TRACE_FAMILY:
+		*data_len = sizeof(uint32_t);
+		return &trace->family;
+	case NFTNL_TRACE_ID:
+		*data_len = sizeof(uint32_t);
+		return &trace->id;
+	case NFTNL_TRACE_IIF:
+		*data_len = sizeof(uint32_t);
+		return &trace->iif;
+	case NFTNL_TRACE_OIF:
+		*data_len = sizeof(uint32_t);
+		return &trace->oif;
+	case NFTNL_TRACE_LL_HEADER:
+		*data_len = trace->ll.len;
+		return trace->ll.data;
+	case NFTNL_TRACE_MARK:
+		*data_len = sizeof(uint32_t);
+		return &trace->mark;
+	case NFTNL_TRACE_NETWORK_HEADER:
+		*data_len = trace->nh.len;
+		return trace->nh.data;
+	case NFTNL_TRACE_TYPE:
+		*data_len = sizeof(uint32_t);
+		return &trace->type;
+	case NFTNL_TRACE_CHAIN:
+		*data_len = strlen(trace->chain);
+		return trace->chain;
+	case NFTNL_TRACE_TABLE:
+		*data_len = strlen(trace->table);
+		return trace->table;
+	case NFTNL_TRACE_JUMP_TARGET:
+		*data_len = strlen(trace->jump_target);
+		return trace->jump_target;
+	case NFTNL_TRACE_TRANSPORT_HEADER:
+		*data_len = trace->th.len;
+		return trace->th.data;
+	case NFTNL_TRACE_RULE_HANDLE:
+		*data_len = sizeof(uint64_t);
+		return &trace->rule_handle;
+	case NFTNL_TRACE_VERDICT:
+		*data_len = sizeof(uint32_t);
+		return &trace->verdict;
+	case NFTNL_TRACE_IIFTYPE:
+		*data_len = sizeof(uint16_t);
+		return &trace->iiftype;
+	case NFTNL_TRACE_OIFTYPE:
+		*data_len = sizeof(uint16_t);
+		return &trace->oiftype;
+	case NFTNL_TRACE_NFPROTO:
+		*data_len = sizeof(uint32_t);
+		return &trace->nfproto;
+	case NFTNL_TRACE_POLICY:
+		*data_len = sizeof(uint32_t);
+		return &trace->policy;
+	case __NFTNL_TRACE_MAX:
+		break;
+	}
+
+	return NULL;
+}
+
+EXPORT_SYMBOL(nftnl_trace_get_str);
+const char *nftnl_trace_get_str(const struct nftnl_trace *trace, uint16_t type)
+{
+	if (!nftnl_trace_is_set(trace, type))
+		return NULL;
+
+	switch (type) {
+	case NFTNL_TRACE_CHAIN: return trace->chain;
+	case NFTNL_TRACE_TABLE: return trace->table;
+	default: break;
+	}
+	return NULL;
+}
+
+EXPORT_SYMBOL(nftnl_trace_get_u16);
+uint16_t nftnl_trace_get_u16(const struct nftnl_trace *trace, uint16_t type)
+{
+	const uint16_t *d;
+	uint32_t dlen;
+
+	d = nftnl_trace_get_data(trace, type, &dlen);
+	if (d && dlen == sizeof(*d))
+		return *d;
+
+	return 0;
+}
+
+EXPORT_SYMBOL(nftnl_trace_get_u32);
+uint32_t nftnl_trace_get_u32(const struct nftnl_trace *trace, uint16_t type)
+{
+	const uint32_t *d;
+	uint32_t dlen;
+
+	d = nftnl_trace_get_data(trace, type, &dlen);
+	if (d && dlen == sizeof(*d))
+		return *d;
+
+	return 0;
+}
+
+EXPORT_SYMBOL(nftnl_trace_get_u64);
+uint64_t nftnl_trace_get_u64(const struct nftnl_trace *trace, uint16_t type)
+{
+	const uint64_t *d;
+	uint32_t dlen;
+
+	d = nftnl_trace_get_data(trace, type, &dlen);
+	if (d && dlen == sizeof(*d))
+		return *d;
+
+	return 0;
+}
+
+static bool nftnl_trace_nlmsg_parse_hdrdata(struct nlattr *attr,
+					    struct nftnl_header_data *header)
+{
+	uint32_t len;
+
+	if (!attr)
+		return false;
+
+	len = mnl_attr_get_payload_len(attr);
+
+	header->data = malloc(len);
+	if (header->data) {
+		memcpy(header->data, mnl_attr_get_payload(attr), len);
+		header->len = len;
+		return true;
+	}
+
+	return false;
+}
+
+static int nftnl_trace_parse_verdict_cb(const struct nlattr *attr, void *data)
+{
+	int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+	switch (type) {
+	case NFTA_VERDICT_CODE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		tb[type] = attr;
+		break;
+	case NFTA_VERDICT_CHAIN:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		tb[type] = attr;
+		break;
+	}
+
+	return MNL_CB_OK;
+}
+
+static void
+nftnl_trace_parse_verdict(const struct nlattr *attr, struct nftnl_trace *t)
+{
+	struct nlattr *tb[NFTA_VERDICT_MAX+1];
+
+	mnl_attr_parse_nested(attr, nftnl_trace_parse_verdict_cb, tb);
+
+	if (!tb[NFTA_VERDICT_CODE])
+		abi_breakage();
+
+	t->verdict = ntohl(mnl_attr_get_u32(tb[NFTA_VERDICT_CODE]));
+	t->flags |= (1 << NFTNL_TRACE_VERDICT);
+
+	switch (t->verdict) {
+	case NFT_GOTO: /* fallthough */
+	case NFT_JUMP:
+		if (!tb[NFTA_VERDICT_CHAIN])
+			abi_breakage();
+		t->jump_target = strdup(mnl_attr_get_str(tb[NFTA_VERDICT_CHAIN]));
+		if (t->jump_target)
+			t->flags |= (1 << NFTNL_TRACE_JUMP_TARGET);
+		break;
+	}
+}
+
+EXPORT_SYMBOL(nftnl_trace_nlmsg_parse);
+int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
+{
+	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[NFTA_TRACE_MAX+1] = {};
+
+	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_trace_parse_attr_cb, tb) < 0)
+		return -1;
+
+	if (!tb[NFTA_TRACE_ID])
+		abi_breakage();
+
+	if (!tb[NFTA_TRACE_TYPE])
+		abi_breakage();
+
+	if (tb[NFTA_TRACE_TABLE])
+		t->table = strdup(mnl_attr_get_str(tb[NFTA_TRACE_TABLE]));
+	if (tb[NFTA_TRACE_CHAIN])
+		t->chain = strdup(mnl_attr_get_str(tb[NFTA_TRACE_CHAIN]));
+
+	t->family = nfg->nfgen_family;
+	t->flags |= (1 << NFTNL_TRACE_FAMILY);
+
+	t->type = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_TYPE]));
+	t->flags |= (1 << NFTNL_TRACE_TYPE);
+
+	t->id = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_ID]));
+	t->flags |= (1 << NFTNL_TRACE_ID);
+
+	if (tb[NFTA_TRACE_IIFTYPE]) {
+		t->iiftype = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_IIFTYPE]));
+		t->flags |= (1 << NFTNL_TRACE_IIFTYPE);
+	}
+
+	if (tb[NFTA_TRACE_IIF]) {
+		t->iif = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_IIF]));
+		t->flags |= (1 << NFTNL_TRACE_IIF);
+	}
+
+	if (tb[NFTA_TRACE_OIFTYPE]) {
+		t->iiftype = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_OIFTYPE]));
+		t->flags |= (1 << NFTNL_TRACE_OIFTYPE);
+	}
+
+	if (tb[NFTA_TRACE_OIF]) {
+		t->oif = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_OIF]));
+		t->flags |= (1 << NFTNL_TRACE_OIF);
+	}
+
+	if (tb[NFTA_TRACE_MARK]) {
+		t->mark = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_MARK]));
+		t->flags |= (1 << NFTNL_TRACE_MARK);
+	}
+
+	if (tb[NFTA_TRACE_RULE_HANDLE]) {
+		t->rule_handle = be64toh(mnl_attr_get_u64(tb[NFTA_TRACE_RULE_HANDLE]));
+		t->flags |= (1 << NFTNL_TRACE_RULE_HANDLE);
+	}
+
+	if (tb[NFTA_TRACE_VERDICT])
+		nftnl_trace_parse_verdict(tb[NFTA_TRACE_VERDICT], t);
+
+	if (nftnl_trace_nlmsg_parse_hdrdata(tb[NFTA_TRACE_LL_HEADER], &t->ll))
+		t->flags |= (1 << NFTNL_TRACE_LL_HEADER);
+
+	if (nftnl_trace_nlmsg_parse_hdrdata(tb[NFTA_TRACE_NETWORK_HEADER], &t->nh))
+		t->flags |= (1 << NFTNL_TRACE_NETWORK_HEADER);
+
+	if (nftnl_trace_nlmsg_parse_hdrdata(tb[NFTA_TRACE_TRANSPORT_HEADER], &t->th))
+		t->flags |= (1 << NFTNL_TRACE_TRANSPORT_HEADER);
+
+	if (tb[NFTA_TRACE_NFPROTO]) {
+		t->iiftype = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_NFPROTO]));
+		t->flags |= (1 << NFTNL_TRACE_NFPROTO);
+	}
+
+	if (tb[NFTA_TRACE_POLICY]) {
+		t->iiftype = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_POLICY]));
+		t->flags |= (1 << NFTNL_TRACE_POLICY);
+	}
+
+	if (tb[NFTA_TRACE_OIF]) {
+		t->oif = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_OIF]));
+		t->flags |= (1 << NFTNL_TRACE_OIF);
+	}
+
+	if (tb[NFTA_TRACE_MARK]) {
+		t->mark = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_MARK]));
+		t->flags |= (1 << NFTNL_TRACE_MARK);
+	}
+
+	if (tb[NFTA_TRACE_RULE_HANDLE]) {
+		t->rule_handle = be64toh(mnl_attr_get_u64(tb[NFTA_TRACE_RULE_HANDLE]));
+		t->flags |= (1 << NFTNL_TRACE_RULE_HANDLE);
+	}
+
+	if (tb[NFTA_TRACE_VERDICT])
+		nftnl_trace_parse_verdict(tb[NFTA_TRACE_VERDICT], t);
+
+	if (nftnl_trace_nlmsg_parse_hdrdata(tb[NFTA_TRACE_LL_HEADER], &t->ll))
+		t->flags |= (1 << NFTNL_TRACE_LL_HEADER);
+
+	if (nftnl_trace_nlmsg_parse_hdrdata(tb[NFTA_TRACE_NETWORK_HEADER], &t->nh))
+		t->flags |= (1 << NFTNL_TRACE_NETWORK_HEADER);
+
+	if (nftnl_trace_nlmsg_parse_hdrdata(tb[NFTA_TRACE_TRANSPORT_HEADER], &t->th))
+		t->flags |= (1 << NFTNL_TRACE_TRANSPORT_HEADER);
+
+	if (t->chain)
+		t->flags |= (1 << NFTNL_TRACE_CHAIN);
+
+	if (t->chain)
+		t->flags |= (1 << NFTNL_TRACE_CHAIN);
+	if (t->table)
+		t->flags |= (1 << NFTNL_TRACE_TABLE);
+
+	return 0;
+}
diff --git a/src/utils.c b/src/utils.c
index 84fbe94..ba36bc4 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -146,12 +146,24 @@ const char *nftnl_verdict2str(uint32_t verdict)
 		return "accept";
 	case NF_DROP:
 		return "drop";
+	case NF_STOLEN:
+		return "stolen";
+	case NF_QUEUE:
+		return "queue";
+	case NF_REPEAT:
+		return "repeat";
+	case NF_STOP:
+		return "stop";
 	case NFT_RETURN:
 		return "return";
 	case NFT_JUMP:
 		return "jump";
 	case NFT_GOTO:
 		return "goto";
+	case NFT_CONTINUE:
+		return "continue";
+	case NFT_BREAK:
+		return "break";
 	default:
 		return "unknown";
 	}
-- 
2.4.10

