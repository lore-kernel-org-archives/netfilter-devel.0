From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: add ruleset generation class
Date: Fri, 12 Sep 2014 12:49:02 +0200
Message-ID: <1410518942-6197-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48257 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbaILKsT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:48:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The generation object currently only contains the uint32_t that
indicates the generation ID. I could have just add the API to return
the uint32_t ID instead, but I think this API is easier to extend
without adding new APIs.

We can probably include meaningful statistics in the generation
message in the future without much hassle.

This patch also extends examples/nft-events.c.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/nft-events.c               |   28 +++++
 include/libnftnl/gen.h              |   51 +++++++++
 include/linux/netfilter/nf_tables.h |   19 +++-
 src/Makefile.am                     |    1 +
 src/gen.c                           |  199 +++++++++++++++++++++++++++++++++++
 src/libnftnl.map                    |   14 +++
 6 files changed, 310 insertions(+), 2 deletions(-)
 create mode 100644 include/libnftnl/gen.h
 create mode 100644 src/gen.c

diff --git a/examples/nft-events.c b/examples/nft-events.c
index fb18e55..ef860d3 100644
--- a/examples/nft-events.c
+++ b/examples/nft-events.c
@@ -22,6 +22,7 @@
 #include <libnftnl/chain.h>
 #include <libnftnl/rule.h>
 #include <libnftnl/set.h>
+#include <libnftnl/gen.h>
 #include <libnftnl/common.h>
 
 static uint32_t event2flag(uint32_t event)
@@ -32,6 +33,7 @@ static uint32_t event2flag(uint32_t event)
 	case NFT_MSG_NEWRULE:
 	case NFT_MSG_NEWSET:
 	case NFT_MSG_NEWSETELEM:
+	case NFT_MSG_NEWGEN:
 		return NFT_OF_EVENT_NEW;
 	case NFT_MSG_DELTABLE:
 	case NFT_MSG_DELCHAIN:
@@ -165,6 +167,29 @@ err:
 	return MNL_CB_OK;
 }
 
+static int gen_cb(const struct nlmsghdr *nlh, int event, int type)
+{
+	struct nft_gen *gen;
+
+	gen = nft_gen_alloc();
+	if (gen == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nft_gen_nlmsg_parse(nlh, gen) < 0) {
+		perror("nft_gen_parse");
+		goto err_free;
+	}
+
+	nft_gen_fprintf(stdout, gen, type, event2flag(event));
+	fprintf(stdout, "\n");
+err_free:
+	nft_gen_free(gen);
+err:
+	return MNL_CB_OK;
+}
+
 static int events_cb(const struct nlmsghdr *nlh, void *data)
 {
 	int ret = MNL_CB_OK;
@@ -192,6 +217,9 @@ static int events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_DELSETELEM:
 		ret = setelem_cb(nlh, event, type);
 		break;
+	case NFT_MSG_NEWGEN:
+		ret = gen_cb(nlh, event, type);
+		break;
 	}
 
 	return ret;
diff --git a/include/libnftnl/gen.h b/include/libnftnl/gen.h
new file mode 100644
index 0000000..00753b0
--- /dev/null
+++ b/include/libnftnl/gen.h
@@ -0,0 +1,51 @@
+#ifndef _LIBNFTNL_GEN_H_
+#define _LIBNFTNL_GEN_H_
+
+#include <stdio.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <sys/types.h>
+
+#include <libnftnl/common.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+struct nft_gen;
+
+struct nft_gen *nft_gen_alloc(void);
+void nft_gen_free(struct nft_gen *);
+
+enum {
+	NFT_GEN_ID 	= 0,
+	__NFT_GEN_MAX
+};
+#define NFT_GEN_MAX (__NFT_GEN_MAX - 1)
+
+bool nft_gen_attr_is_set(const struct nft_gen *gen, uint16_t attr);
+void nft_gen_attr_unset(struct nft_gen *gen, uint16_t attr);
+void nft_gen_attr_set(struct nft_gen *gen, uint16_t attr, const void *data);
+void nft_gen_attr_set_data(struct nft_gen *gen, uint16_t attr,
+			     const void *data, uint32_t data_len);
+const void *nft_gen_attr_get(struct nft_gen *gen, uint16_t attr);
+const void *nft_gen_attr_get_data(struct nft_gen *gen, uint16_t attr,
+				    uint32_t *data_len);
+
+void nft_gen_attr_set_u32(struct nft_gen *gen, uint16_t attr, uint32_t data);
+uint32_t nft_gen_attr_get_u32(struct nft_gen *gen, uint16_t attr);
+
+struct nlmsghdr;
+int nft_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_gen *gen);
+
+int nft_gen_snprintf(char *buf, size_t size, struct nft_gen *gen, uint32_t type, uint32_t flags);
+int nft_gen_fprintf(FILE *fp, struct nft_gen *gen, uint32_t type, uint32_t flags);
+
+#define nft_gen_nlmsg_build_hdr	nft_nlmsg_build_hdr
+int nft_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_gen *gen);
+
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
+#endif /* _LIBNFTNL_GEN_H_ */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 36c4ca2..b72ccfe 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -51,6 +51,8 @@ enum nft_verdicts {
  * @NFT_MSG_NEWSETELEM: create a new set element (enum nft_set_elem_attributes)
  * @NFT_MSG_GETSETELEM: get a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
+ * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
+ * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -68,6 +70,8 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
+	NFT_MSG_NEWGEN,
+	NFT_MSG_GETGEN,
 	NFT_MSG_MAX,
 };
 
@@ -785,7 +789,7 @@ enum nft_nat_types {
  * @NFTA_NAT_REG_ADDR_MAX: source register of address range end (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
- * @NFTA_NAT_FLAGS: additional NAT configuration (NF_NAT_RANGE_*) (NLA_U32)
+ * @NFTA_NAT_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
  */
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
@@ -803,7 +807,7 @@ enum nft_nat_attributes {
 /**
  * enum nft_masq_attributes - nf_tables masquerade expression attributes
  *
- * @NFTA_MASQ_FLAGS: additional masquerade configuration (NF_NAT_RANGE_*) (NLA_U32)
+ * @NFTA_MASQ_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
  */
 enum nft_masq_attributes {
 	NFTA_MASQ_UNSPEC,
@@ -812,5 +816,16 @@ enum nft_masq_attributes {
 };
 #define NFTA_MASQ_MAX		(__NFTA_MASQ_MAX - 1)
 
+/**
+ * enum nft_gen_attributes - nf_tables ruleset generation attributes
+ *
+ * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
+ */
+enum nft_gen_attributes {
+	NFTA_GEN_UNSPEC,
+	NFTA_GEN_ID,
+	__NFTA_GEN_MAX
+};
+#define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index d57ff96..65bc82a 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -7,6 +7,7 @@ libnftnl_la_LDFLAGS = -Wl,--version-script=$(srcdir)/libnftnl.map	\
 
 libnftnl_la_SOURCES = utils.c		\
 		      common.c		\
+		      gen.c		\
 		      table.c		\
 		      chain.c		\
 		      rule.c		\
diff --git a/src/gen.c b/src/gen.c
new file mode 100644
index 0000000..21d3a49
--- /dev/null
+++ b/src/gen.c
@@ -0,0 +1,199 @@
+/*
+ * (C) 2012-2014 by Pablo Neira Ayuso <pablo@netfilter.org>
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
+#include <limits.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netinet/in.h>
+#include <errno.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libnftnl/gen.h>
+
+struct nft_gen {
+	uint32_t id;
+
+	uint32_t flags;
+};
+
+struct nft_gen *nft_gen_alloc(void)
+{
+	return calloc(1, sizeof(struct nft_gen));
+}
+EXPORT_SYMBOL(nft_gen_alloc);
+
+void nft_gen_free(struct nft_gen *gen)
+{
+	xfree(gen);
+}
+EXPORT_SYMBOL(nft_gen_free);
+
+bool nft_gen_attr_is_set(const struct nft_gen *gen, uint16_t attr)
+{
+	return gen->flags & (1 << attr);
+}
+EXPORT_SYMBOL(nft_gen_attr_is_set);
+
+void nft_gen_attr_unset(struct nft_gen *gen, uint16_t attr)
+{
+	if (!(gen->flags & (1 << attr)))
+		return;
+
+	switch (attr) {
+	case NFT_GEN_ID:
+		break;
+	}
+	gen->flags &= ~(1 << attr);
+}
+EXPORT_SYMBOL(nft_gen_attr_unset);
+
+static uint32_t nft_gen_attr_validate[NFT_GEN_MAX + 1] = {
+	[NFT_GEN_ID]	= sizeof(uint32_t),
+};
+
+void nft_gen_attr_set_data(struct nft_gen *gen, uint16_t attr,
+			   const void *data, uint32_t data_len)
+{
+	if (attr > NFT_GEN_MAX)
+		return;
+
+	nft_assert_validate(data, nft_gen_attr_validate, attr, data_len);
+
+	switch (attr) {
+	case NFT_GEN_ID:
+		gen->id = *((uint32_t *)data);
+		break;
+	}
+	gen->flags |= (1 << attr);
+}
+EXPORT_SYMBOL(nft_gen_attr_set_data);
+
+void nft_gen_attr_set(struct nft_gen *gen, uint16_t attr, const void *data)
+{
+	nft_gen_attr_set_data(gen, attr, data, nft_gen_attr_validate[attr]);
+}
+EXPORT_SYMBOL(nft_gen_attr_set);
+
+void nft_gen_attr_set_u32(struct nft_gen *gen, uint16_t attr, uint32_t val)
+{
+	nft_gen_attr_set_data(gen, attr, &val, sizeof(uint32_t));
+}
+EXPORT_SYMBOL(nft_gen_attr_set_u32);
+
+const void *nft_gen_attr_get_data(struct nft_gen *gen, uint16_t attr,
+				  uint32_t *data_len)
+{
+	if (!(gen->flags & (1 << attr)))
+		return NULL;
+
+	switch(attr) {
+	case NFT_GEN_ID:
+		return &gen->id;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(nft_gen_attr_get_data);
+
+const void *nft_gen_attr_get(struct nft_gen *gen, uint16_t attr)
+{
+	uint32_t data_len;
+	return nft_gen_attr_get_data(gen, attr, &data_len);
+}
+EXPORT_SYMBOL(nft_gen_attr_get);
+
+uint32_t nft_gen_attr_get_u32(struct nft_gen *gen, uint16_t attr)
+{
+	const void *ret = nft_gen_attr_get(gen, attr);
+	return ret == NULL ? 0 : *((uint32_t *)ret);
+}
+EXPORT_SYMBOL(nft_gen_attr_get_u32);
+
+static int nft_gen_parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_GEN_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_GEN_ID:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+int nft_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_gen *gen)
+{
+	struct nlattr *tb[NFTA_GEN_MAX + 1] = {};
+	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
+
+	if (mnl_attr_parse(nlh, sizeof(*nfg), nft_gen_parse_attr_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_GEN_ID]) {
+		gen->id = ntohl(mnl_attr_get_u32(tb[NFTA_GEN_ID]));
+		gen->flags |= (1 << NFT_GEN_ID);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(nft_gen_nlmsg_parse);
+
+static int nft_gen_snprintf_default(char *buf, size_t size, struct nft_gen *gen)
+{
+	return snprintf(buf, size, "ruleset generation ID %u", gen->id);
+}
+
+int nft_gen_snprintf(char *buf, size_t size, struct nft_gen *gen,
+		       uint32_t type, uint32_t flags)
+{
+	int ret, len = size, offset = 0;
+
+	ret = nft_event_header_snprintf(buf + offset, len, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	switch(type) {
+	case NFT_OUTPUT_DEFAULT:
+		ret = nft_gen_snprintf_default(buf + offset, len, gen);
+		break;
+	default:
+		return -1;
+	}
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = nft_event_footer_snprintf(buf + offset, len, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+EXPORT_SYMBOL(nft_gen_snprintf);
+
+static inline int nft_gen_do_snprintf(char *buf, size_t size, void *gen,
+				      uint32_t type, uint32_t flags)
+{
+	return nft_gen_snprintf(buf, size, gen, type, flags);
+}
+
+int nft_gen_fprintf(FILE *fp, struct nft_gen *gen, uint32_t type,
+		    uint32_t flags)
+{
+	return nft_fprintf(fp, gen, type, flags, nft_gen_do_snprintf);
+}
+EXPORT_SYMBOL(nft_gen_fprintf);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index d8dcf8e..be7b998 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -212,4 +212,18 @@ LIBNFTNL_1.2 {
   nft_batch_is_supported;
   nft_batch_begin;
   nft_batch_end;
+
+  nft_gen_alloc;
+  nft_gen_free;
+  nft_gen_attr_is_set;
+  nft_gen_attr_unset;
+  nft_gen_attr_set_data;
+  nft_gen_attr_set;
+  nft_gen_attr_set_u32;
+  nft_gen_attr_get_data;
+  nft_gen_attr_get;
+  nft_gen_attr_get_u32;
+  nft_gen_nlmsg_parse;
+  nft_gen_snprintf;
+  nft_gen_fprintf;
 } LIBNFTNL_1.1;
-- 
1.7.10.4

