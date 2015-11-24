From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 5/6] src: add trace infrastructure support
Date: Tue, 24 Nov 2015 11:02:10 +0100
Message-ID: <1448359331-12692-6-git-send-email-fw@strlen.de>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58372 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbbKXKC3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:02:29 -0500
In-Reply-To: <1448359331-12692-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parses trace monitor netlink messages from the kernel and
supports printing most of the 'important' header data such as
ether/ip/ip6 src/dst addresses and udp/tcp port numbers.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libnftnl/Makefile.am        |   1 +
 include/libnftnl/trace.h            |  56 +++
 include/linux/netfilter/nf_tables.h |  32 ++
 src/Makefile.am                     |   1 +
 src/libnftnl.map                    |  17 +
 src/trace.c                         | 725 ++++++++++++++++++++++++++++++++++++
 src/utils.c                         |   4 +
 7 files changed, 836 insertions(+)
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
index 0000000..a570194
--- /dev/null
+++ b/include/libnftnl/trace.h
@@ -0,0 +1,56 @@
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
+	NFTNL_TRACE_DEV_TYPE,
+	NFTNL_TRACE_FAMILY,
+	NFTNL_TRACE_ID,
+	NFTNL_TRACE_IIF,
+	NFTNL_TRACE_OIF,
+	NFTNL_TRACE_LL_HEADER,
+	NFTNL_TRACE_MARK,
+	NFTNL_TRACE_NETWORK_HEADER,
+	NFTNL_TRACE_TABLE,
+	NFTNL_TRACE_TRANSPORT_HEADER,
+	NFTNL_TRACE_TRANSPORT_PROTO,
+	NFTNL_TRACE_TYPE,
+	NFTNL_TRACE_RULE_HANDLE,
+	NFTNL_TRACE_VERDICT,
+	NFTNL_TRACE_VLAN_TAG,
+};
+#define NFTNL_TRACE_MAX NFTNL_TRACE_VLAN_TAG
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
+uint8_t nftnl_trace_get_u8(const struct nftnl_trace *trace, uint16_t type);
+uint16_t nftnl_trace_get_u16(const struct nftnl_trace *trace, uint16_t type);
+uint32_t nftnl_trace_get_u32(const struct nftnl_trace *trace, uint16_t type);
+uint64_t nftnl_trace_get_u64(const struct nftnl_trace *trace, uint16_t type);
+const char *nftnl_trace_get_str(const struct nftnl_trace *trace, uint16_t type);
+
+int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t);
+int nftnl_trace_snprintf(char *buf, size_t size, const struct nftnl_trace *t, uint32_t type);
+int nftnl_trace_fprintf(FILE *fh, const struct nftnl_trace *t, uint32_t type);
+
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
+#endif /* _LIBNFTNL_TRACE_H_ */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 9796d82..09ede2b 100644
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
 
@@ -970,4 +972,34 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+enum nft_trace_attibutes {
+	NFTA_TRACE_UNSPEC,
+	NFTA_TRACE_CHAIN,
+	NFTA_TRACE_DEV_TYPE,
+	NFTA_TRACE_ID,
+	NFTA_TRACE_IIF,
+	NFTA_TRACE_OIF,
+	NFTA_TRACE_LL_HEADER,
+	NFTA_TRACE_MARK,
+	NFTA_TRACE_NETWORK_HEADER,
+	NFTA_TRACE_TABLE,
+	NFTA_TRACE_TRANSPORT_HEADER,
+	NFTA_TRACE_TRANSPORT_PROTO,
+	NFTA_TRACE_TYPE,
+	NFTA_TRACE_RULE_HANDLE,
+	NFTA_TRACE_VERDICT,
+	NFTA_TRACE_VLAN_TAG,
+	__NFTA_TRACE_MAX
+};
+#define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
+
+enum nft_trace_types {
+	NFT_TRACETYPE_UNSPEC,
+	NFT_TRACETYPE_PACKET,
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
index a52b54e..7fc2eb9 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -498,3 +498,20 @@ global:
 
 local: *;
 };
+
+LIBNFTNL_4.1 {
+	nftnl_trace_alloc;
+	nftnl_trace_free;
+
+	nftnl_trace_is_set;
+
+	nftnl_trace_get_u8;
+	nftnl_trace_get_u16;
+	nftnl_trace_get_u32;
+	nftnl_trace_get_u64;
+	nftnl_trace_get_str;
+
+	nftnl_trace_nlmsg_parse;
+	nftnl_trace_snprintf;
+	nftnl_trace_fprintf;
+} LIBNFTNL_4;
diff --git a/src/trace.c b/src/trace.c
new file mode 100644
index 0000000..0b95d02
--- /dev/null
+++ b/src/trace.c
@@ -0,0 +1,725 @@
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
+/* header snprintf */
+#include <inttypes.h>
+#include <arpa/inet.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <netinet/udp.h>
+#include <net/ethernet.h>
+#include <net/if_arp.h>
+
+struct nftnl_header_data {
+	char *data;
+	unsigned int len;
+};
+
+struct nftnl_trace {
+	char *chain;
+	char *table;
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
+	uint16_t vlan_tag;
+	uint16_t devtype;
+	uint8_t  th_prot;
+
+	uint32_t flags;
+};
+
+static const char *type2str(int type)
+{
+	enum nft_trace_types t = type;
+
+	switch (t) {
+	case NFT_TRACETYPE_PACKET:
+		return "packet"; /* trace start */
+	case NFT_TRACETYPE_POLICY:
+		return "policy";
+	case NFT_TRACETYPE_RETURN:
+		return "return";
+	case NFT_TRACETYPE_RULE:
+		return "rule";
+	case NFT_TRACETYPE_UNSPEC: /* fallthrough */
+	case __NFT_TRACETYPE_MAX:
+		break;
+	}
+
+	return "";
+}
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
+	case NFTA_TRACE_TRANSPORT_PROTO:
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
+		break;
+	case NFTA_TRACE_DEV_TYPE:
+	case NFTA_TRACE_VLAN_TAG:
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+			abi_breakage();
+		break;
+	case NFTA_TRACE_ID:
+	case NFTA_TRACE_IIF:
+	case NFTA_TRACE_OIF:
+	case NFTA_TRACE_MARK:
+	case NFTA_TRACE_TYPE:
+	case NFTA_TRACE_VERDICT:
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
+	case NFTA_TRACE_LL_HEADER:
+		if (mnl_attr_get_payload_len(attr) == 0)
+			abi_breakage();
+		break;
+	case NFTA_TRACE_NETWORK_HEADER:
+		if (mnl_attr_get_payload_len(attr) < sizeof(struct iphdr))
+			abi_breakage();
+		break;
+	case NFTA_TRACE_TRANSPORT_HEADER:
+		if (mnl_attr_get_payload_len(attr) < sizeof(uint32_t))
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
+	case NFTNL_TRACE_TRANSPORT_HEADER:
+		*data_len = trace->th.len;
+		return trace->th.data;
+	case NFTNL_TRACE_TRANSPORT_PROTO:
+		*data_len = sizeof(uint8_t);
+		return &trace->th_prot;
+	case NFTNL_TRACE_RULE_HANDLE:
+		*data_len = sizeof(uint64_t);
+		return &trace->rule_handle;
+	case NFTNL_TRACE_VERDICT:
+		*data_len = sizeof(uint32_t);
+		return &trace->verdict;
+	case NFTNL_TRACE_VLAN_TAG:
+		*data_len = sizeof(uint16_t);
+		return &trace->vlan_tag;
+	case NFTNL_TRACE_DEV_TYPE:
+		*data_len = sizeof(uint16_t);
+		return &trace->devtype;
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
+EXPORT_SYMBOL(nftnl_trace_get_u8);
+uint8_t nftnl_trace_get_u8(const struct nftnl_trace *trace, uint16_t type)
+{
+	const uint8_t *d;
+	uint32_t dlen;
+
+	d = nftnl_trace_get_data(trace, type, &dlen);
+	if (d && dlen == sizeof(*d))
+		return *d;
+
+	return 0;
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
+	if (tb[NFTA_TRACE_IIF]) {
+		t->iif = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_IIF]));
+		t->flags |= (1 << NFTNL_TRACE_IIF);
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
+	if (tb[NFTA_TRACE_VERDICT]) {
+		t->verdict = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_VERDICT]));
+		t->flags |= (1 << NFTNL_TRACE_VERDICT);
+	}
+
+	if (tb[NFTA_TRACE_VLAN_TAG]) {
+		t->vlan_tag = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_VLAN_TAG]));
+		t->flags |= (1 << NFTNL_TRACE_VLAN_TAG);
+	}
+
+	if (tb[NFTA_TRACE_DEV_TYPE]) {
+		t->devtype = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_DEV_TYPE]));
+		t->flags |= (1 << NFTNL_TRACE_DEV_TYPE);
+	}
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
+	if (tb[NFTA_TRACE_TRANSPORT_PROTO]) {
+		t->th_prot = mnl_attr_get_u8(tb[NFTA_TRACE_TRANSPORT_PROTO]);
+		t->flags |= (1 << NFTNL_TRACE_TRANSPORT_PROTO);
+	}
+
+	if (t->chain)
+		t->flags |= (1 << NFTNL_TRACE_CHAIN);
+	if (t->table)
+		t->flags |= (1 << NFTNL_TRACE_TABLE);
+
+	return 0;
+}
+
+static int print_ether_addr(char *buf, size_t size, const void *addr)
+{
+	const uint8_t *mac = addr;
+
+	return snprintf(buf, size, "%02x:%02x:%02x:%02x:%02x:%02x",
+			mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
+}
+
+static int print_ip4(char *buf, size_t size, uint32_t addr)
+{
+	char addrs[INET_ADDRSTRLEN];
+
+	inet_ntop(AF_INET, &addr, addrs, sizeof(addrs));
+	return snprintf(buf, size, "%s", addrs);
+}
+
+static int print_ip6(char *buf, size_t size, const void *addr)
+{
+	char addrs[INET6_ADDRSTRLEN];
+
+	inet_ntop(AF_INET6, addr, addrs, sizeof(addrs));
+	return snprintf(buf, size, "%s", addrs);
+}
+
+static int
+print_th(const struct nftnl_trace *t, char *buf, size_t size)
+{
+	uint8_t proto = nftnl_trace_get_u8(t, NFTNL_TRACE_TRANSPORT_PROTO);
+	int ret, len = size, offset = 0;
+	const struct udphdr *uh;
+	uint32_t plen;
+
+	ret = snprintf(buf+offset, len, " protocol %u", proto);
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	switch (proto) {
+	case IPPROTO_DCCP:
+	case IPPROTO_SCTP:
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		break;
+	default:
+		return 0;
+	}
+
+	/* warning: only sport/dport are valid */
+	uh = nftnl_trace_get_data(t, NFTNL_TRACE_TRANSPORT_HEADER, &plen);
+	if (!uh)
+		return 0;
+
+	ret = snprintf(buf+offset, len, " sport %"PRIu16 " dport %"PRIu16,
+			ntohs(uh->uh_sport), ntohs(uh->uh_dport));
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	return offset;
+}
+
+static int log_packet6(const struct nftnl_trace *t, char *buf, size_t size)
+{
+	int ret, len = size, offset = 0;
+	const struct ip6_hdr *iph;
+	uint32_t plen;
+
+	iph = nftnl_trace_get_data(t, NFTNL_TRACE_NETWORK_HEADER, &plen);
+	if (!iph || plen < sizeof(iph))
+		return 0;
+
+	ret = snprintf(buf+offset, len, " src ");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = print_ip6(buf+offset, len, &iph->ip6_src);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, len, " dst ");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = print_ip6(buf+offset, len, &iph->ip6_dst);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, len, " len %u hoplimit %u",
+		       ntohs(iph->ip6_plen), iph->ip6_hlim);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = print_th(t, buf+offset, len);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int log_packet4(const struct nftnl_trace *t, char *buf, size_t size)
+{
+	int ret, len = size, offset = 0;
+	const struct iphdr *iph;
+	uint32_t plen;
+
+	iph = nftnl_trace_get_data(t, NFTNL_TRACE_NETWORK_HEADER, &plen);
+	if (!iph || plen < sizeof(iph))
+		return 0;
+
+	ret = snprintf(buf+offset, len, " src ");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = print_ip4(buf+offset, len, iph->saddr);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, len, " dst ");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = print_ip4(buf+offset, len, iph->daddr);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, len, " len %u ttl %u id %u",
+			ntohs(iph->tot_len), iph->ttl, ntohs(iph->id));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (iph->frag_off & htons(IP_OFFMASK)) {
+		ret = snprintf(buf+offset, len, " frag %u protocol %u",
+				ntohs(iph->frag_off) & IP_OFFMASK, iph->protocol);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else {
+		ret = print_th(t, buf+offset, len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static bool log_packet_inet(const struct nftnl_trace *t, char *buf, size_t size)
+{
+	const struct iphdr *iph;
+	uint32_t plen;
+
+	iph = nftnl_trace_get_data(t, NFTNL_TRACE_NETWORK_HEADER, &plen);
+	if (!iph)
+		return 0;
+
+	switch (iph->version) {
+	case 4: return log_packet4(t, buf, size);
+	case 6: return log_packet6(t, buf, size);
+	default: break;
+	}
+	return true;
+}
+
+static bool log_packet_arp(const struct nftnl_trace *t, char *buf, size_t size)
+{
+	int ret, len = size, offset = 0;
+	const struct arphdr *arph;
+	uint32_t plen;
+
+	arph = nftnl_trace_get_data(t, NFTNL_TRACE_NETWORK_HEADER, &plen);
+	if (!arph || plen < sizeof(arph))
+		return 0;
+
+	ret = snprintf(buf+offset, len, " arpop 0x%x", ntohs(arph->ar_op));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return ret;
+}
+
+static int log_packet_bridge(const struct nftnl_trace *t, char *buf, size_t size)
+{
+	const struct ether_header *ethh;
+	int ret, len = size, offset = 0;
+	uint32_t hlen;
+
+	ethh = nftnl_trace_get_data(t, NFTNL_TRACE_LL_HEADER, &hlen);
+	if (!ethh || hlen < sizeof(ethh))
+		return log_packet_inet(t, buf+offset, len);
+
+	ret = snprintf(buf+offset, len, " src ");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = print_ether_addr(buf+offset, len, ethh->ether_shost);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, len, " dst ");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = print_ether_addr(buf+offset, len, ethh->ether_dhost);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	switch (ntohs(ethh->ether_type)) {
+	case ETHERTYPE_ARP:
+		return log_packet_arp(t, buf+offset, len);
+	case ETHERTYPE_IP:
+		return log_packet4(t, buf+offset, len);
+	case ETHERTYPE_IPV6:
+		return log_packet6(t, buf+offset, len);
+	default:
+		ret = snprintf(buf+offset, len, " ethertype 0x%x", ntohs(ethh->ether_type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		break;
+	}
+
+	return offset;
+
+}
+
+static int log_packet_netdev(const struct nftnl_trace *t, char *buf, size_t size)
+{
+	int ret, len = size, offset = 0;
+
+	switch (t->devtype) {
+	case ARPHRD_ETHER:
+		return log_packet_bridge(t, buf+offset, len);
+	default:
+		ret = snprintf(buf+offset, len, "devtype 0x%04x", t->devtype);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		return log_packet_inet(t, buf+offset, len);
+	}
+
+	return 0;
+}
+
+static int log_packet(const struct nftnl_trace *t, char *buf, size_t size)
+{
+	int ret, len = size, offset = 0;
+	switch (t->family) {
+	case NFPROTO_IPV4:
+		ret = log_packet4(t, buf+offset, len);
+		break;
+	case NFPROTO_IPV6:
+		ret = log_packet6(t, buf+offset, len);
+		break;
+	case NFPROTO_INET:
+		ret = log_packet_inet(t, buf+offset, len);
+		break;
+	case NFPROTO_ARP: /* fallthrough */
+	case NFPROTO_BRIDGE:
+		ret = log_packet_bridge(t, buf+offset, len);
+		break;
+	case NFPROTO_NETDEV:
+		ret = log_packet_netdev(t, buf+offset, len);
+		break;
+	default:
+		ret = snprintf(buf+offset, len, " family %d", t->family);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		break;
+	}
+
+	return offset;
+}
+
+static int nftnl_trace_snprintf_default(char *buf, size_t size,
+				        const struct nftnl_trace *t)
+{
+	int ret, len = size, offset = 0;
+
+	ret = snprintf(buf+offset, len, "id %08x", nftnl_trace_get_u32(t, NFTNL_TRACE_ID));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, len, " %s", nftnl_family2str(t->family));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (nftnl_trace_is_set(t, NFTNL_TRACE_TABLE)) {
+		ret = snprintf(buf+offset, len, " %s", t->table);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (nftnl_trace_is_set(t, NFTNL_TRACE_CHAIN)) {
+		ret = snprintf(buf+offset, len, " %s", t->chain);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret = snprintf(buf+offset, len, " %s", type2str(t->type));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (nftnl_trace_is_set(t, NFTNL_TRACE_VERDICT)) {
+		ret = snprintf(buf+offset, len, " verdict %s",
+				nftnl_verdict2str(nftnl_trace_get_u32(t, NFTNL_TRACE_VERDICT)));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (nftnl_trace_is_set(t, NFTNL_TRACE_MARK)) {
+		ret = snprintf(buf+offset, len,
+			       " mark 0x%x", nftnl_trace_get_u32(t, NFTNL_TRACE_MARK));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (nftnl_trace_is_set(t, NFTNL_TRACE_VLAN_TAG)) {
+		ret = snprintf(buf+offset, len,
+			       " vlan id %d", nftnl_trace_get_u16(t, NFTNL_TRACE_VLAN_TAG));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (nftnl_trace_is_set(t, NFTNL_TRACE_LL_HEADER) ||
+	    nftnl_trace_is_set(t, NFTNL_TRACE_NETWORK_HEADER)) {
+		ret = log_packet(t, buf+offset, len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+
+EXPORT_SYMBOL(nftnl_trace_snprintf);
+int nftnl_trace_snprintf(char *buf, size_t size, const struct nftnl_trace *t, uint32_t type)
+{
+	int ret = 0;
+
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		ret = nftnl_trace_snprintf_default(buf, size, t);
+		break;
+	default:
+		return -1;
+	}
+
+	return ret;
+}
+
+static int nftnl_trace_do_snprintf(char *buf, size_t size, void *r,
+				   uint32_t cmd, uint32_t type,
+				   uint32_t flags)
+{
+	return nftnl_trace_snprintf(buf, size, r, type);
+}
+
+
+EXPORT_SYMBOL(nftnl_trace_fprintf);
+int nftnl_trace_fprintf(FILE *fp, const struct nftnl_trace *t, uint32_t type)
+{
+	return nftnl_fprintf(fp, (void *) t, NFTNL_CMD_UNSPEC, type, 0,
+			   nftnl_trace_do_snprintf);
+}
diff --git a/src/utils.c b/src/utils.c
index 84fbe94..fb68b1a 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -152,6 +152,10 @@ const char *nftnl_verdict2str(uint32_t verdict)
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

