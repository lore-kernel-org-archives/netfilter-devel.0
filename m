From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] examples: add nft-ruleset-replace
Date: Tue, 26 Aug 2014 11:57:16 +0200
Message-ID: <20140826095716.3463.89684.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47580 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934346AbaHZJ5Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:57:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This code examples uses the new NFT_MSG_DELTABLE functionality to replace
an entire ruleset in a single transaction/batch.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/Makefile.am           |    4 +
 examples/nft-ruleset-replace.c |  203 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 207 insertions(+)
 create mode 100644 examples/nft-ruleset-replace.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index 69f5c7f..1fbeff9 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -23,6 +23,7 @@ check_PROGRAMS = nft-table-add		\
 		 nft-set-elem-get	\
 		 nft-set-elem-del	\
 		 nft-ruleset-get	\
+		 nft-ruleset-replace	\
 		 nft-compat-get
 
 nft_table_add_SOURCES = nft-table-add.c
@@ -94,5 +95,8 @@ nft_set_elem_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_ruleset_get_SOURCES = nft-ruleset-get.c
 nft_ruleset_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_ruleset_replace_SOURCES = nft-ruleset-replace.c
+nft_ruleset_replace_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_compat_get_SOURCES = nft-compat-get.c
 nft_compat_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/examples/nft-ruleset-replace.c b/examples/nft-ruleset-replace.c
new file mode 100644
index 0000000..8b7babd
--- /dev/null
+++ b/examples/nft-ruleset-replace.c
@@ -0,0 +1,203 @@
+/*
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
+ */
+
+#include <stdlib.h>
+#include <time.h>
+#include <string.h>
+#include <stddef.h>	/* for offsetof */
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
+#include <libnftnl/expr.h>
+
+static void add_counter(struct nft_rule *r)
+{
+	struct nft_rule_expr *e;
+
+	e = nft_rule_expr_alloc("counter");
+	if (e == NULL) {
+		perror("expr counter oom");
+		exit(EXIT_FAILURE);
+	}
+
+	nft_rule_add_expr(r, e);
+}
+
+static struct nft_rule *setup_rule(uint8_t family, const char *table,
+				   const char *chain)
+{
+	struct nft_rule *r = NULL;
+
+	r = nft_rule_alloc();
+	if (r == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, table);
+	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, chain);
+	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
+
+	add_counter(r);
+
+	return r;
+}
+
+static struct nft_table *setup_table(uint8_t family, const char *name)
+{
+	struct nft_table *t;
+
+	t = nft_table_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	if (name != NULL)
+		nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, name);
+
+	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
+
+	return t;
+}
+
+static struct nft_chain *setup_chain(uint8_t family, const char *table,
+				     const char *name)
+{
+	struct nft_chain *c;
+
+	c = nft_chain_alloc();
+	if (c == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, table);
+	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, name);
+	nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, family);
+
+	return c;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	struct nft_table *t;
+	struct nft_chain *c;
+	struct nft_rule *r;
+	struct nlmsghdr *nlh;
+	struct mnl_nlmsg_batch *batch;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	uint32_t seq = time(NULL), wipe_seq;
+	int ret, i;
+	uint32_t families[4] = { NFPROTO_IPV4,
+				 NFPROTO_IPV6,
+				 NFPROTO_ARP,
+				 NFPROTO_BRIDGE };
+
+	if (!nft_batch_is_supported()) {
+		fprintf(stderr, "This code example requires a newer kernel.\n");
+		exit(EXIT_FAILURE);
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
+
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+	nft_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	wipe_seq = seq++;
+	t = setup_table(NFPROTO_UNSPEC, NULL);
+	nlh = nft_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				  NFT_MSG_DELTABLE, NFPROTO_UNSPEC,
+				  NLM_F_ACK, wipe_seq);
+	nft_table_nlmsg_build_payload(nlh, t);
+	nft_table_free(t);
+	mnl_nlmsg_batch_next(batch);
+
+	for (i = 0; i < 4; i++) {
+		t = setup_table(families[i], "test_table");
+		nlh = nft_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				NFT_MSG_NEWTABLE, families[i],
+				NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
+		nft_table_nlmsg_build_payload(nlh, t);
+		nft_table_free(t);
+		mnl_nlmsg_batch_next(batch);
+
+		c = setup_chain(families[i], "test_table", "test_chain");
+		nlh = nft_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				NFT_MSG_NEWCHAIN, families[i],
+				NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
+		nft_chain_nlmsg_build_payload(nlh, c);
+		nft_chain_free(c);
+		mnl_nlmsg_batch_next(batch);
+
+		r = setup_rule(families[i], "test_table", "test_chain");
+		nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				NFT_MSG_NEWRULE, families[i],
+				NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
+		nft_rule_nlmsg_build_payload(nlh, r);
+		nft_rule_free(r);
+		mnl_nlmsg_batch_next(batch);
+	}
+
+	nft_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
+				mnl_nlmsg_batch_size(batch));
+	if (ret == -1) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_nlmsg_batch_stop(batch);
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	if (ret == -1) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_cb_run(buf, ret, wipe_seq,
+			 mnl_socket_get_portid(nl), NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}

