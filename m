From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 3/4 v4] example: Parse and create netlink message using the new parsing functions.
Date: Fri, 30 Jan 2015 15:35:24 +0100
Message-ID: <1422628525-28109-3-git-send-email-alvaroneay@gmail.com>
References: <1422628525-28109-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:44915 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759175AbbA3OfW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 09:35:22 -0500
Received: by mail-we0-f178.google.com with SMTP id k48so27466957wev.9
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2015 06:35:21 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id mz10sm7185759wic.9.2015.01.30.06.35.20
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Jan 2015 06:35:20 -0800 (PST)
In-Reply-To: <1422628525-28109-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With this example, we can parse the elements in the ruleset and create the
netlink message with the action associated. For example:

- Flush ruleset
- Add, delete or flush tables/chains
- Add, delete sets
- Add, delete set elements
- Add, delete, replace or prepend rules

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v4]
 * Update the example don't use the set function of the ruleset context
 * Cosmetic changes

 examples/Makefile.am              |    4 +
 examples/nft-ruleset-parse-file.c |  448 +++++++++++++++++++++++++++++++++++++
 2 files changed, 452 insertions(+)
 create mode 100644 examples/nft-ruleset-parse-file.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index fafcb76..e002d36 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -22,6 +22,7 @@ check_PROGRAMS = nft-table-add		\
 		 nft-set-elem-get	\
 		 nft-set-elem-del	\
 		 nft-ruleset-get	\
+		 nft-ruleset-parse-file	\
 		 nft-compat-get
 
 nft_table_add_SOURCES = nft-table-add.c
@@ -90,5 +91,8 @@ nft_set_elem_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_ruleset_get_SOURCES = nft-ruleset-get.c
 nft_ruleset_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_ruleset_parse_file_SOURCES = nft-ruleset-parse-file.c
+nft_ruleset_parse_file_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_compat_get_SOURCES = nft-compat-get.c
 nft_compat_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/examples/nft-ruleset-parse-file.c b/examples/nft-ruleset-parse-file.c
new file mode 100644
index 0000000..a9b505d
--- /dev/null
+++ b/examples/nft-ruleset-parse-file.c
@@ -0,0 +1,448 @@
+/*
+ * (C) 2014 by Alvaro Neira Ayuso <alvaroneay@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdlib.h>
+#include <time.h>
+#include <string.h>
+#include <stddef.h>     /* for offsetof */
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <netinet/tcp.h>
+#include <arpa/inet.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <errno.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/ruleset.h>
+#include <libnftnl/table.h>
+#include <libnftnl/chain.h>
+#include <libnftnl/rule.h>
+#include <libnftnl/set.h>
+
+struct mnl_nlmsg_batch *batch;
+uint32_t seq;
+
+static int nft_ruleset_flush_rules(const struct nft_parse_ctx *ctx);
+
+static int nft_ruleset_set_elems(const struct nft_parse_ctx *ctx,
+				 uint32_t ctx_cmd)
+{
+	struct nft_set_elems_iter *iter_elems;
+	struct nft_set_elem *elem;
+	struct nft_set *tmp;
+	uint16_t type = 0, cmd = 0;
+	struct nlmsghdr *nlh;
+	struct nft_set *set;
+
+	set = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
+	if (set == NULL)
+		return -1;
+
+	switch (ctx_cmd) {
+	case NFT_CMD_ADD:
+		cmd = NFT_MSG_NEWSETELEM;
+		type = NLM_F_CREATE|NLM_F_EXCL|NLM_F_ACK;
+		break;
+	case NFT_CMD_DELETE:
+		cmd = NFT_MSG_DELSETELEM;
+		type = NLM_F_ACK;
+		break;
+	}
+
+	iter_elems = nft_set_elems_iter_create(set);
+	elem = nft_set_elems_iter_next(iter_elems);
+	while (elem != NULL) {
+		tmp = nft_set_alloc();
+		if (tmp == NULL)
+			return -1;
+
+		nft_set_attr_set(tmp, NFT_SET_ATTR_TABLE,
+				 nft_set_attr_get_str(set, NFT_SET_ATTR_TABLE));
+		nft_set_attr_set(tmp, NFT_SET_ATTR_NAME,
+				 nft_set_attr_get_str(set, NFT_SET_ATTR_NAME));
+
+		nft_set_elem_add(tmp, elem);
+
+		nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					      cmd,
+					      nft_set_attr_get_u32(set,
+							   NFT_SET_ATTR_FAMILY),
+					      type, seq++);
+		nft_set_elems_nlmsg_build_payload(nlh, tmp);
+		mnl_nlmsg_batch_next(batch);
+		elem = nft_set_elems_iter_next(iter_elems);
+	}
+
+	return 0;
+}
+
+static int nft_ruleset_set(const struct nft_parse_ctx *ctx, uint32_t ctx_cmd)
+{
+
+	struct nlmsghdr *nlh;
+	uint16_t type = 0, cmd = 0;
+	struct nft_set *set;
+
+	set = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
+	if (set == NULL)
+		return -1;
+
+	switch (ctx_cmd) {
+	case NFT_CMD_ADD:
+		cmd = NFT_MSG_NEWSET;
+		type = NLM_F_CREATE|NLM_F_ACK;
+		break;
+	case NFT_CMD_DELETE:
+		cmd = NFT_MSG_DELSET;
+		type = NLM_F_ACK;
+		break;
+	}
+
+	nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				      cmd,
+				      nft_set_attr_get_u32(set,
+							   NFT_SET_ATTR_FAMILY),
+				      type,
+				      seq++);
+
+	nft_set_nlmsg_build_payload(nlh, set);
+
+	mnl_nlmsg_batch_next(batch);
+
+	if (nft_ruleset_set_elems(ctx, ctx_cmd) < 0)
+		return -1;
+
+	return 0;
+}
+
+static int nft_ruleset_rule(const struct nft_parse_ctx *ctx, uint32_t ctx_cmd,
+			    struct nft_rule *nlr)
+{
+	struct nlmsghdr *nlh;
+	uint16_t type = 0, cmd = 0;
+	struct nft_rule *rule;
+
+	if (nft_ruleset_ctx_is_set(ctx, NFT_RULESET_CTX_RULE))
+		rule = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_RULE);
+	else
+		rule = nlr;
+
+	if (rule == NULL)
+		return -1;
+
+	switch (ctx_cmd) {
+	case NFT_CMD_ADD:
+		cmd = NFT_MSG_NEWRULE;
+		type = NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK;
+		nft_rule_attr_unset(rule, NFT_RULE_ATTR_HANDLE);
+		break;
+	case NFT_CMD_DELETE:
+		cmd = NFT_MSG_DELRULE;
+		type = NLM_F_ACK;
+		break;
+	case NFT_CMD_REPLACE:
+		cmd = NFT_MSG_NEWRULE;
+		type = NLM_F_REPLACE|NLM_F_ACK;
+		break;
+	case NFT_CMD_INSERT:
+		cmd = NFT_MSG_NEWRULE;
+		type = NLM_F_CREATE|NLM_F_ACK;
+		nft_rule_attr_unset(rule, NFT_RULE_ATTR_HANDLE);
+		break;
+	}
+
+	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				       cmd,
+				       nft_rule_attr_get_u32(rule,
+							  NFT_RULE_ATTR_FAMILY),
+				       type,
+				       seq++);
+
+	nft_rule_nlmsg_build_payload(nlh, rule);
+
+	mnl_nlmsg_batch_next(batch);
+	nft_rule_free(rule);
+	return 0;
+}
+
+static int nft_ruleset_chain(const struct nft_parse_ctx *ctx, uint32_t ctx_cmd)
+{
+	struct nlmsghdr *nlh;
+	uint16_t type = 0, cmd = 0;
+	struct nft_chain *chain;
+
+	chain = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_CHAIN);
+	if (chain == NULL)
+		return -1;
+
+	switch (ctx_cmd) {
+	case NFT_CMD_ADD:
+		cmd = NFT_MSG_NEWCHAIN;
+		type = NLM_F_CREATE|NLM_F_ACK;
+		break;
+	case NFT_CMD_DELETE:
+		cmd = NFT_MSG_DELCHAIN;
+		type = NLM_F_ACK;
+		break;
+	case NFT_CMD_FLUSH:
+		return nft_ruleset_flush_rules(ctx);
+	}
+
+	nft_chain_attr_unset(chain, NFT_CHAIN_ATTR_HANDLE);
+	nlh = nft_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					cmd,
+					nft_chain_attr_get_u32(chain,
+							 NFT_CHAIN_ATTR_FAMILY),
+					type,
+					seq++);
+
+	nft_chain_nlmsg_build_payload(nlh, chain);
+
+	mnl_nlmsg_batch_next(batch);
+	nft_chain_free(chain);
+	return 0;
+}
+
+static int nft_ruleset_table(const struct nft_parse_ctx *ctx, uint32_t ctx_cmd,
+			     struct nft_table *nlt)
+{
+	struct nlmsghdr *nlh;
+	uint16_t type = 0, cmd = 0;
+	struct nft_table *table;
+
+	if (nft_ruleset_ctx_is_set(ctx, NFT_RULESET_CTX_TABLE))
+		table = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_TABLE);
+	else
+		table = nlt;
+
+	if (table == NULL)
+		return -1;
+
+	switch (ctx_cmd) {
+	case NFT_CMD_ADD:
+		cmd = NFT_MSG_NEWTABLE;
+		type = NLM_F_CREATE|NLM_F_ACK;
+		break;
+	case NFT_CMD_DELETE:
+		cmd = NFT_MSG_DELTABLE;
+		type = NLM_F_ACK;
+		break;
+	case NFT_CMD_FLUSH:
+		return nft_ruleset_flush_rules(ctx);
+	}
+
+	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					cmd,
+					nft_table_attr_get_u32(table,
+							 NFT_TABLE_ATTR_FAMILY),
+					type,
+					seq++);
+
+	nft_table_nlmsg_build_payload(nlh, table);
+	mnl_nlmsg_batch_next(batch);
+	nft_table_free(table);
+	return 0;
+}
+
+static int nft_ruleset_flush_rules(const struct nft_parse_ctx *ctx)
+{
+	struct nft_rule *nlr;
+	struct nft_table *nlt;
+	struct nft_chain *nlc;
+	uint32_t type;
+
+	nlr = nft_rule_alloc();
+	if (nlr == NULL)
+		return -1;
+
+	type = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_TYPE);
+	switch (type) {
+	case NFT_RULESET_TABLE:
+		nlt = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_TABLE);
+		nft_rule_attr_set(nlr, NFT_RULE_ATTR_TABLE,
+				  nft_table_attr_get(nlt, NFT_TABLE_ATTR_NAME));
+		nft_rule_attr_set(nlr, NFT_RULE_ATTR_FAMILY,
+				nft_table_attr_get(nlt, NFT_TABLE_ATTR_FAMILY));
+		break;
+	case NFT_RULESET_CHAIN:
+		nlc = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_CHAIN);
+		nft_rule_attr_set(nlr, NFT_RULE_ATTR_TABLE,
+				  nft_chain_attr_get(nlc,
+						     NFT_CHAIN_ATTR_TABLE));
+		nft_rule_attr_set(nlr, NFT_RULE_ATTR_CHAIN,
+				  nft_chain_attr_get(nlc,
+						     NFT_CHAIN_ATTR_NAME));
+		nft_rule_attr_set(nlr, NFT_RULE_ATTR_FAMILY,
+				nft_chain_attr_get(nlc, NFT_TABLE_ATTR_FAMILY));
+		break;
+	}
+
+	return nft_ruleset_rule(ctx, NFT_CMD_DELETE, nlr);
+}
+
+static int nft_ruleset_flush_ruleset(const struct nft_parse_ctx *ctx)
+{
+	struct nft_table *nlt;
+
+	nlt = nft_table_alloc();
+	if (nlt == NULL)
+		return -1;
+
+	return nft_ruleset_table(ctx, NFT_CMD_DELETE, nlt);
+}
+
+static int ruleset_elems_cb(const struct nft_parse_ctx *ctx)
+{
+	uint32_t ctx_cmd;
+	uint32_t type;
+
+	type = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_TYPE);
+	ctx_cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+
+	switch (type) {
+	case NFT_RULESET_TABLE:
+		if (nft_ruleset_table(ctx, ctx_cmd, NULL) < 0)
+			return -1;
+		break;
+	case NFT_RULESET_CHAIN:
+		if (nft_ruleset_chain(ctx, ctx_cmd) < 0)
+			return -1;
+		break;
+	case NFT_RULESET_RULE:
+		if (nft_ruleset_rule(ctx, ctx_cmd, NULL) < 0)
+			return -1;
+		break;
+	case NFT_RULESET_SET:
+		if (nft_ruleset_set(ctx, ctx_cmd) < 0)
+			return -1;
+		break;
+	case NFT_RULESET_SET_ELEMS:
+		if (nft_ruleset_set_elems(ctx, ctx_cmd) < 0)
+			return -1;
+		break;
+	case NFT_RULESET_RULESET:
+		if (nft_ruleset_flush_ruleset(ctx) < 0)
+			return -1;
+		break;
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct nft_parse_err *err;
+	const char *filename;
+	FILE *fp;
+	int ret = -1, len, batching, portid;
+	uint32_t ruleset_seq;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct mnl_socket *nl;
+
+	if (argc < 2) {
+		printf("Usage: %s <file>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	fp = fopen(argv[1], "r");
+	if (fp == NULL) {
+		printf("unable to open file %s: %s\n", argv[1],
+		       strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	err = nft_parse_err_alloc();
+	if (err == NULL) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+	batching = nft_batch_is_supported();
+	if (batching < 0) {
+		perror("Cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
+
+	seq = time(NULL);
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	if (batching) {
+		nft_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
+	ruleset_seq = seq;
+
+	filename = argv[1];
+	len = strlen(filename);
+	if (strcmp(&filename[len-5], ".json") == 0)
+		ret = nft_ruleset_parse_file_cb(NFT_PARSE_JSON, fp, err, NULL,
+						&ruleset_elems_cb);
+	else if (strcmp(&filename[len-4], ".xml") == 0)
+		ret = nft_ruleset_parse_file_cb(NFT_PARSE_XML, fp, err, NULL,
+						&ruleset_elems_cb);
+	else {
+		printf("the filename %s must to end in .xml or .json\n",
+			filename);
+		exit(EXIT_FAILURE);
+	}
+
+	if (ret < 0) {
+		nft_parse_perror("fail", err);
+		exit(EXIT_FAILURE);
+	}
+
+	fclose(fp);
+
+	if (batching) {
+		nft_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	mnl_nlmsg_fprintf(stdout, mnl_nlmsg_batch_head(batch),
+			  mnl_nlmsg_batch_size(batch), sizeof(struct nfgenmsg));
+
+	if (mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
+			      mnl_nlmsg_batch_size(batch)) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_nlmsg_batch_stop(batch);
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, ruleset_seq, portid, NULL, NULL);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_socket_close(nl);
+	return EXIT_SUCCESS;
+}
-- 
1.7.10.4

