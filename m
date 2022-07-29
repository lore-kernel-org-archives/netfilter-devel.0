Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9773C19F29
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jul 2022 09:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbiG2Jid (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 05:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbiG2Jid (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 05:38:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2407A4F674
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2022 02:38:30 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl RFC 1/3] src: add string API support
Date:   Fri, 29 Jul 2022 11:38:21 +0200
Message-Id: <20220729093823.3441-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds strset object that represent a "string set" object.
There is also str object that represent a list of patterns to be
added/deleted to the "string set".

This patch provides 6 example files to create "string set" and populate
them with patterns:

 examples/nft-str-add.c
 examples/nft-str-del.c
 examples/nft-str-get.c
 examples/nft-strset-add.c
 examples/nft-strset-del.c
 examples/nft-strset-get.c

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/Makefile.am                |  26 +-
 examples/nft-str-add.c              | 134 +++++++++
 examples/nft-str-del.c              | 133 +++++++++
 examples/nft-str-get.c              | 122 ++++++++
 examples/nft-strset-add.c           | 131 ++++++++
 examples/nft-strset-del.c           | 111 +++++++
 examples/nft-strset-get.c           | 122 ++++++++
 include/libnftnl/str.h              |  56 ++++
 include/linux/netfilter/nf_tables.h |  45 ++-
 include/str.h                       |  26 ++
 src/Makefile.am                     |   1 +
 src/libnftnl.map                    |  21 ++
 src/str.c                           | 443 ++++++++++++++++++++++++++++
 13 files changed, 1368 insertions(+), 3 deletions(-)
 create mode 100644 examples/nft-str-add.c
 create mode 100644 examples/nft-str-del.c
 create mode 100644 examples/nft-str-get.c
 create mode 100644 examples/nft-strset-add.c
 create mode 100644 examples/nft-strset-del.c
 create mode 100644 examples/nft-strset-get.c
 create mode 100644 include/libnftnl/str.h
 create mode 100644 include/str.h
 create mode 100644 src/str.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index db9164ddf946..10998ffe3399 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -37,7 +37,13 @@ check_PROGRAMS = nft-table-add		\
 		 nft-ct-helper-del	\
 		 nft-rule-ct-helper-add \
 		 nft-rule-ct-expectation-add \
-		 nft-rule-ct-timeout-add
+		 nft-rule-ct-timeout-add \
+		 nft-strset-add		\
+		 nft-strset-del		\
+		 nft-strset-get		\
+		 nft-str-add		\
+		 nft-str-del		\
+		 nft-str-get
 
 nft_table_add_SOURCES = nft-table-add.c
 nft_table_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
@@ -152,3 +158,21 @@ nft_rule_ct_expectation_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
 nft_rule_ct_timeout_add_SOURCES = nft-rule-ct-timeout-add.c
 nft_rule_ct_timeout_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_strset_add_SOURCES = nft-strset-add.c
+nft_strset_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_strset_del_SOURCES = nft-strset-del.c
+nft_strset_del_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_strset_get_SOURCES = nft-strset-get.c
+nft_strset_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_str_add_SOURCES = nft-str-add.c
+nft_str_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_str_del_SOURCES = nft-str-del.c
+nft_str_del_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_str_get_SOURCES = nft-str-get.c
+nft_str_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/examples/nft-str-add.c b/examples/nft-str-add.c
new file mode 100644
index 000000000000..5e52ff2ddf82
--- /dev/null
+++ b/examples/nft-str-add.c
@@ -0,0 +1,134 @@
+/*
+ * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
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
+#include <libnftnl/str.h>
+
+static struct nftnl_string *
+setup_strset(uint8_t family, const char *table, const char *name)
+{
+	struct nftnl_string *s = NULL;
+
+	s = nftnl_string_alloc();
+	if (s == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	nftnl_string_set_str(s, NFTNL_STRING_TABLE, table);
+	nftnl_string_set_str(s, NFTNL_STRING_NAME, name);
+	nftnl_string_set_u32(s, NFTNL_STRING_FAMILY, family);
+
+	nftnl_string_add(s, "test1");
+	nftnl_string_add(s, "test2");
+
+	return s;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	struct nftnl_string *s;
+	struct nlmsghdr *nlh;
+	struct mnl_nlmsg_batch *batch;
+	uint8_t family;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	uint32_t seq = time(NULL);
+	int ret;
+
+	if (argc != 4) {
+		fprintf(stderr, "Usage: %s <family> <table> <strsetname>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
+	else if (strcmp(argv[1], "bridge") == 0)
+		family = NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") == 0)
+		family = NFPROTO_ARP;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
+		exit(EXIT_FAILURE);
+	}
+
+	s = setup_strset(family, argv[2], argv[3]);
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
+
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWSTRING, family,
+				    NLM_F_CREATE|NLM_F_ACK, seq++);
+
+	nftnl_string_nlmsg_build_payload(nlh, s);
+	nftnl_string_free(s);
+	mnl_nlmsg_batch_next(batch);
+
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
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
+	ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(nl), NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-str-del.c b/examples/nft-str-del.c
new file mode 100644
index 000000000000..b60fee6e494b
--- /dev/null
+++ b/examples/nft-str-del.c
@@ -0,0 +1,133 @@
+/*
+ * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
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
+#include <libnftnl/str.h>
+
+static struct nftnl_string *
+setup_strset(uint8_t family, const char *table, const char *name)
+{
+	struct nftnl_string *s = NULL;
+
+	s = nftnl_string_alloc();
+	if (s == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	nftnl_string_set_str(s, NFTNL_STRING_TABLE, table);
+	nftnl_string_set_str(s, NFTNL_STRING_NAME, name);
+	nftnl_string_set_u32(s, NFTNL_STRING_FAMILY, family);
+
+	nftnl_string_add(s, "test1");
+
+	return s;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	struct nftnl_string *s;
+	struct nlmsghdr *nlh;
+	struct mnl_nlmsg_batch *batch;
+	uint8_t family;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	uint32_t seq = time(NULL);
+	int ret;
+
+	if (argc != 4) {
+		fprintf(stderr, "Usage: %s <family> <table> <strsetname>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
+	else if (strcmp(argv[1], "bridge") == 0)
+		family = NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") == 0)
+		family = NFPROTO_ARP;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
+		exit(EXIT_FAILURE);
+	}
+
+	s = setup_strset(family, argv[2], argv[3]);
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
+
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_DELSTRING, family,
+				    NLM_F_ACK, seq++);
+
+	nftnl_string_nlmsg_build_payload(nlh, s);
+	nftnl_string_free(s);
+	mnl_nlmsg_batch_next(batch);
+
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
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
+	ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(nl), NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-str-get.c b/examples/nft-str-get.c
new file mode 100644
index 000000000000..9edeca912830
--- /dev/null
+++ b/examples/nft-str-get.c
@@ -0,0 +1,122 @@
+/*
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
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
+#include <netinet/in.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/str.h>
+
+static int strset_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nftnl_string *t;
+	uint32_t *type = data;
+	char buf[4096];
+
+	t = nftnl_string_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nftnl_string_nlmsg_parse(nlh, t) < 0) {
+		perror("nftnl_string_nlmsg_parse");
+		goto err_free;
+	}
+
+	nftnl_string_snprintf(buf, sizeof(buf), t, *type, 0);
+	printf("%s\n", buf);
+
+err_free:
+	nftnl_string_free(t);
+err:
+	return MNL_CB_OK;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq, family;
+	uint32_t type = NFTNL_OUTPUT_DEFAULT;
+	struct nftnl_string *t = NULL;
+	int ret;
+
+	if (argc != 4) {
+		fprintf(stderr, "%s <family> <table> <name>\n", argv[0]);
+		return EXIT_FAILURE;
+	}
+	t = nftnl_string_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+	seq = time(NULL);
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
+	else if (strcmp(argv[1], "bridge") == 0)
+		family = NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") == 0)
+		family = NFPROTO_ARP;
+	else if (strcmp(argv[1], "unspec") == 0)
+		family = NFPROTO_UNSPEC;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp, unspec\n");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSTRING, family,
+				    NLM_F_DUMP|NLM_F_ACK, seq);
+	nftnl_string_set_str(t, NFTNL_STRING_TABLE, argv[2]);
+	nftnl_string_set_str(t, NFTNL_STRING_NAME, argv[3]);
+	nftnl_string_nlmsg_build_payload(nlh, t);
+	nftnl_string_free(t);
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
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, strset_cb, &type);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-strset-add.c b/examples/nft-strset-add.c
new file mode 100644
index 000000000000..f6722611bf52
--- /dev/null
+++ b/examples/nft-strset-add.c
@@ -0,0 +1,131 @@
+/*
+ * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
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
+#include <libnftnl/str.h>
+
+static struct nftnl_string *
+setup_strset(uint8_t family, const char *table, const char *name)
+{
+	struct nftnl_string *s = NULL;
+
+	s = nftnl_string_alloc();
+	if (s == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	nftnl_string_set_str(s, NFTNL_STRING_TABLE, table);
+	nftnl_string_set_str(s, NFTNL_STRING_NAME, name);
+	nftnl_string_set_u32(s, NFTNL_STRING_FAMILY, family);
+
+	return s;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	struct nftnl_string *s;
+	struct nlmsghdr *nlh;
+	struct mnl_nlmsg_batch *batch;
+	uint8_t family;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	uint32_t seq = time(NULL);
+	int ret;
+
+	if (argc != 4) {
+		fprintf(stderr, "Usage: %s <family> <table> <strsetname>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
+	else if (strcmp(argv[1], "bridge") == 0)
+		family = NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") == 0)
+		family = NFPROTO_ARP;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
+		exit(EXIT_FAILURE);
+	}
+
+	s = setup_strset(family, argv[2], argv[3]);
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
+
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWSTRSET, family,
+				    NLM_F_CREATE|NLM_F_ACK, seq++);
+
+	nftnl_string_nlmsg_build_payload(nlh, s);
+	nftnl_string_free(s);
+	mnl_nlmsg_batch_next(batch);
+
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
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
+	ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(nl), NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-strset-del.c b/examples/nft-strset-del.c
new file mode 100644
index 000000000000..8b3c1b05b3b5
--- /dev/null
+++ b/examples/nft-strset-del.c
@@ -0,0 +1,111 @@
+/*
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
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
+#include <netinet/in.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/str.h>
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct mnl_nlmsg_batch *batch;
+	uint32_t portid, seq, family;
+	struct nftnl_string *t = NULL;
+	int ret;
+
+	if (argc != 4) {
+		fprintf(stderr, "%s <family> <table> <set>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	t = nftnl_string_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	seq = time(NULL);
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
+	else if (strcmp(argv[1], "bridge") == 0)
+		family = NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") == 0)
+		family = NFPROTO_ARP;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
+		exit(EXIT_FAILURE);
+	}
+
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_DELSTRSET, family,
+				    NLM_F_ACK, seq);
+	nftnl_string_set_str(t, NFTNL_STRING_TABLE, argv[2]);
+	nftnl_string_set_str(t, NFTNL_STRING_NAME, argv[3]);
+
+	nftnl_string_nlmsg_build_payload(nlh, t);
+	nftnl_string_free(t);
+	mnl_nlmsg_batch_next(batch);
+
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
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
+	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
+				mnl_nlmsg_batch_size(batch));
+	if (ret < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_nlmsg_batch_stop(batch);
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret < 0) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_cb_run(buf, ret, 0, portid, NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
+		exit(EXIT_FAILURE);
+	}
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-strset-get.c b/examples/nft-strset-get.c
new file mode 100644
index 000000000000..5ba82ecea06e
--- /dev/null
+++ b/examples/nft-strset-get.c
@@ -0,0 +1,122 @@
+/*
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
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
+#include <netinet/in.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/str.h>
+
+static int strset_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nftnl_string *t;
+	uint32_t *type = data;
+	char buf[4096];
+
+	t = nftnl_string_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nftnl_string_nlmsg_parse(nlh, t) < 0) {
+		perror("nftnl_string_nlmsg_parse");
+		goto err_free;
+	}
+
+	nftnl_string_snprintf(buf, sizeof(buf), t, *type, 0);
+	printf("%s\n", buf);
+
+err_free:
+	nftnl_string_free(t);
+err:
+	return MNL_CB_OK;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq, family;
+	uint32_t type = NFTNL_OUTPUT_DEFAULT;
+	struct nftnl_string *t = NULL;
+	int ret;
+
+	if (argc < 2 || argc > 3) {
+		fprintf(stderr, "%s <family>\n", argv[0]);
+		return EXIT_FAILURE;
+	}
+	t = nftnl_string_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+	seq = time(NULL);
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
+	else if (strcmp(argv[1], "bridge") == 0)
+		family = NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") == 0)
+		family = NFPROTO_ARP;
+	else if (strcmp(argv[1], "unspec") == 0)
+		family = NFPROTO_UNSPEC;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp, unspec\n");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSTRSET, family,
+				    NLM_F_DUMP|NLM_F_ACK, seq);
+	/* Use this below if you want to obtain sets per table */
+/*	nftnl_string_set(t, NFT_SET_TABLE, argv[2]); */
+	nftnl_string_nlmsg_build_payload(nlh, t);
+	nftnl_string_free(t);
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
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, strset_cb, &type);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/include/libnftnl/str.h b/include/libnftnl/str.h
new file mode 100644
index 000000000000..1ee74c790a73
--- /dev/null
+++ b/include/libnftnl/str.h
@@ -0,0 +1,56 @@
+#ifndef _LIBNFTNL_SET_H_
+#define _LIBNFTNL_SET_H_
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
+enum nftnl_string_attr {
+	NFTNL_STRING_TABLE,
+	NFTNL_STRING_NAME,
+	NFTNL_STRING_FAMILY,
+	NFTNL_STRING_HANDLE,
+	NFTNL_STRING_LIST,
+	__NFTNL_STRING_MAX
+};
+#define NFTNL_STRING_MAX (__NFTNL_STRING_MAX - 1)
+
+struct nftnl_string;
+
+struct nftnl_string *nftnl_string_alloc(void);
+void nftnl_string_free(const struct nftnl_string *s);
+bool nftnl_string_is_set(const struct nftnl_string *s, uint16_t attr);
+void nftnl_string_unset(struct nftnl_string *s, uint16_t attr);
+int nftnl_string_set_data(struct nftnl_string *s, uint16_t attr, const void *data,
+			  uint32_t data_len);
+void nftnl_string_set_u32(struct nftnl_string *s, uint16_t attr, uint32_t val);
+void nftnl_string_set_u64(struct nftnl_string *s, uint16_t attr, uint64_t val);
+int nftnl_string_set_str(struct nftnl_string *s, uint16_t attr, const char *str);
+const void *nftnl_string_get_data(const struct nftnl_string *s, uint16_t attr,
+				  uint32_t *data_len);
+const void *nftnl_string_get(const struct nftnl_string *s, uint16_t attr);
+const char *nftnl_string_get_str(const struct nftnl_string *s, uint16_t attr);
+uint32_t nftnl_string_get_u32(const struct nftnl_string *s, uint16_t attr);
+uint64_t nftnl_string_get_u64(const struct nftnl_string *s, uint16_t attr);
+
+void nftnl_string_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_string *s);
+int nftnl_string_add(struct nftnl_string *s, const char *word);
+
+int nftnl_string_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_string *s);
+int nftnl_string_snprintf(char *buf, size_t size, const struct nftnl_string *s,
+			  uint32_t type, uint32_t flags);
+int nftnl_string_foreach(struct nftnl_string *str,
+			 int (*cb)(const char *word, void *data), void *data);
+
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
+#endif /* _LIBNFTNL_SET_H_ */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0ae912054cf1..d7a668199611 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -124,6 +124,12 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWFLOWTABLE,
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
+	NFT_MSG_NEWSTRSET,
+	NFT_MSG_DELSTRSET,
+	NFT_MSG_GETSTRSET,
+	NFT_MSG_NEWSTRING,
+	NFT_MSG_DELSTRING,
+	NFT_MSG_GETSTRING,
 	NFT_MSG_MAX,
 };
 
@@ -753,7 +759,7 @@ enum nft_dynset_attributes {
  * @NFT_PAYLOAD_LL_HEADER: link layer header
  * @NFT_PAYLOAD_NETWORK_HEADER: network header
  * @NFT_PAYLOAD_TRANSPORT_HEADER: transport header
- * @NFT_PAYLOAD_INNER_HEADER: inner header
+ * @NFT_PAYLOAD_INNER_HEADER: inner header / payload
  */
 enum nft_payload_bases {
 	NFT_PAYLOAD_LL_HEADER,
@@ -898,7 +904,8 @@ enum nft_meta_keys {
 	NFT_META_OIF,
 	NFT_META_IIFNAME,
 	NFT_META_OIFNAME,
-	NFT_META_IIFTYPE,
+	NFT_META_IFTYPE,
+#define NFT_META_IIFTYPE	NFT_META_IFTYPE
 	NFT_META_OIFTYPE,
 	NFT_META_SKUID,
 	NFT_META_SKGID,
@@ -925,6 +932,7 @@ enum nft_meta_keys {
 	NFT_META_TIME_HOUR,
 	NFT_META_SDIF,
 	NFT_META_SDIFNAME,
+	__NFT_META_IIFTYPE,
 };
 
 /**
@@ -1670,6 +1678,39 @@ enum nft_flowtable_hook_attributes {
 };
 #define NFTA_FLOWTABLE_HOOK_MAX	(__NFTA_FLOWTABLE_HOOK_MAX - 1)
 
+/**
+ * enum nft_strset_hook_attributes - nf_tables string set netlink attributes
+ *
+ * @NFTA_STRSET_TABLE: table name (NLA_STRING)
+ * @NFTA_STRSET_NAME: string set name (NLA_STRING)
+ * @NFTA_STRSET_LIST: list of string elements (NLA_NESTED)
+ * @NFTA_STRSET_HANDLE: string set handle (NLA_U64)
+ * @NFTA_STRSET_USE: use reference counter (NLA_U32)
+ */
+enum nft_strset_hook_attributes {
+	NFTA_STRSET_UNSPEC,
+	NFTA_STRSET_TABLE,
+	NFTA_STRSET_NAME,
+	NFTA_STRSET_LIST,
+	NFTA_STRSET_HANDLE,
+	NFTA_STRSET_USE,
+	NFTA_STRSET_PAD,
+	__NFTA_STRSET_MAX
+};
+#define NFTA_STRSET_MAX	(__NFTA_STRSET_MAX - 1)
+
+/**
+ * enum nft_string_hook_attributes - nf_tables string netlink attributes
+ *
+ * @NFTA_STRING: string (NLA_STRING)
+ */
+enum nft_string_hook_attributes {
+	NFTA_STRING_UNSPEC,
+	NFTA_STRING,
+	__NFTA_STRING_MAX
+};
+#define NFTA_STRING_MAX	(__NFTA_STRING_MAX - 1)
+
 /**
  * enum nft_osf_attributes - nftables osf expression netlink attributes
  *
diff --git a/include/str.h b/include/str.h
new file mode 100644
index 000000000000..6800c443e365
--- /dev/null
+++ b/include/str.h
@@ -0,0 +1,26 @@
+#ifndef _LIBNFTNL_STRING_INTERNAL_H_
+#define _LIBNFTNL_STRING_INTERNAL_H_
+
+#include <linux/netfilter/nf_tables.h>
+
+struct nftnl_string {
+	struct list_head	head;
+
+	uint32_t		family;
+	const char		*table;
+	const char		*name;
+	uint64_t		handle;
+
+	uint32_t		flags;
+
+	struct list_head	string_list;
+};
+
+struct nftnl_string_list;
+
+struct nftnl_str {
+	struct list_head	head;
+	const char		*value;
+};
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index c3b0ab974bd2..24825d4e3e38 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -17,6 +17,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      rule.c		\
 		      set.c		\
 		      set_elem.c	\
+		      str.c		\
 		      ruleset.c		\
 		      udata.c		\
 		      expr.c		\
diff --git a/src/libnftnl.map b/src/libnftnl.map
index ad8f2af060ae..c39ba541e009 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -387,3 +387,24 @@ LIBNFTNL_16 {
 LIBNFTNL_17 {
   nftnl_set_elem_nlmsg_build;
 } LIBNFTNL_16;
+
+LIBNFTNL_18 {
+  nftnl_string_alloc;
+  nftnl_string_free;
+  nftnl_string_is_set;
+  nftnl_string_unset;
+  nftnl_string_set_data;
+  nftnl_string_set_u32;
+  nftnl_string_set_u64;
+  nftnl_string_set_str;
+  nftnl_string_get_data;
+  nftnl_string_get;
+  nftnl_string_get_str;
+  nftnl_string_get_u32;
+  nftnl_string_get_u64;
+  nftnl_string_nlmsg_build_payload;
+  nftnl_string_add;
+  nftnl_string_nlmsg_parse;
+  nftnl_string_snprintf;
+  nftnl_string_foreach;
+} LIBNFTNL_17;
diff --git a/src/str.c b/src/str.c
new file mode 100644
index 000000000000..f6db07eb9b81
--- /dev/null
+++ b/src/str.c
@@ -0,0 +1,443 @@
+/*
+ * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
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
+#include <inttypes.h>
+#include <netinet/in.h>
+#include <limits.h>
+#include <errno.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include "str.h"
+#include <libnftnl/str.h>
+
+static void nftnl_str_free(struct nftnl_str *str)
+{
+	list_del(&str->head);
+	free(str);
+}
+
+EXPORT_SYMBOL(nftnl_string_alloc);
+struct nftnl_string *nftnl_string_alloc(void)
+{
+	struct nftnl_string *s;
+
+	s = calloc(1, sizeof(struct nftnl_string));
+	if (s == NULL)
+		return NULL;
+
+	INIT_LIST_HEAD(&s->string_list);
+
+	return s;
+}
+
+EXPORT_SYMBOL(nftnl_string_free);
+void nftnl_string_free(const struct nftnl_string *s)
+{
+	struct nftnl_str *str, *next;
+
+	if (s->flags & (1 << NFTNL_STRING_TABLE))
+		xfree(s->table);
+	if (s->flags & (1 << NFTNL_STRING_NAME))
+		xfree(s->name);
+
+	list_for_each_entry_safe(str, next, &s->string_list, head)
+		nftnl_str_free(str);
+
+	xfree(s);
+}
+
+EXPORT_SYMBOL(nftnl_string_is_set);
+bool nftnl_string_is_set(const struct nftnl_string *s, uint16_t attr)
+{
+	return s->flags & (1 << attr);
+}
+
+EXPORT_SYMBOL(nftnl_string_unset);
+void nftnl_string_unset(struct nftnl_string *s, uint16_t attr)
+{
+	struct nftnl_str *str, *next;
+
+	if (!(s->flags & (1 << attr)))
+		return;
+
+	switch (attr) {
+	case NFTNL_STRING_TABLE:
+		xfree(s->table);
+		break;
+	case NFTNL_STRING_NAME:
+		xfree(s->name);
+		break;
+	case NFTNL_STRING_HANDLE:
+		break;
+	case NFTNL_STRING_LIST:
+		list_for_each_entry_safe(str, next, &s->string_list, head)
+			nftnl_str_free(str);
+		break;
+	default:
+		return;
+	}
+
+	s->flags &= ~(1 << attr);
+}
+
+static uint32_t nftnl_string_validate[NFTNL_STRING_MAX + 1] = {
+	[NFTNL_STRING_HANDLE]		= sizeof(uint64_t),
+};
+
+EXPORT_SYMBOL(nftnl_string_set_data);
+int nftnl_string_set_data(struct nftnl_string *s, uint16_t attr, const void *data,
+			  uint32_t data_len)
+{
+	nftnl_assert_attr_exists(attr, NFTNL_STRING_MAX);
+	nftnl_assert_validate(data, nftnl_string_validate, attr, data_len);
+
+	switch(attr) {
+	case NFTNL_STRING_TABLE:
+		if (s->flags & (1 << NFTNL_STRING_TABLE))
+			xfree(s->table);
+
+		s->table = strdup(data);
+		if (!s->table)
+			return -1;
+		break;
+	case NFTNL_STRING_NAME:
+		if (s->flags & (1 << NFTNL_STRING_NAME))
+			xfree(s->name);
+
+		s->name = strdup(data);
+		if (!s->name)
+			return -1;
+		break;
+	case NFTNL_STRING_HANDLE:
+		memcpy(&s->handle, data, sizeof(s->handle));
+		break;
+	}
+	s->flags |= (1 << attr);
+	return 0;
+}
+
+int nftnl_string_set(struct nftnl_string *s, uint16_t attr, const void *data) __visible;
+int nftnl_string_set(struct nftnl_string *s, uint16_t attr, const void *data)
+{
+	return nftnl_string_set_data(s, attr, data, nftnl_string_validate[attr]);
+}
+
+EXPORT_SYMBOL(nftnl_string_set_u32);
+void nftnl_string_set_u32(struct nftnl_string *s, uint16_t attr, uint32_t val)
+{
+	nftnl_string_set_data(s, attr, &val, sizeof(uint64_t));
+}
+EXPORT_SYMBOL(nftnl_string_set_u32);
+
+void nftnl_string_set_u64(struct nftnl_string *s, uint16_t attr, uint64_t val)
+{
+	nftnl_string_set_data(s, attr, &val, sizeof(uint64_t));
+}
+
+EXPORT_SYMBOL(nftnl_string_set_str);
+int nftnl_string_set_str(struct nftnl_string *s, uint16_t attr, const char *str)
+{
+	return nftnl_string_set_data(s, attr, str, strlen(str) + 1);
+}
+
+EXPORT_SYMBOL(nftnl_string_get_data);
+const void *nftnl_string_get_data(const struct nftnl_string *s, uint16_t attr,
+				  uint32_t *data_len)
+{
+	if (!(s->flags & (1 << attr)))
+		return NULL;
+
+	switch(attr) {
+	case NFTNL_STRING_TABLE:
+		*data_len = strlen(s->table) + 1;
+		return s->table;
+	case NFTNL_STRING_NAME:
+		*data_len = strlen(s->name) + 1;
+		return s->name;
+	case NFTNL_STRING_HANDLE:
+		*data_len = sizeof(uint64_t);
+		return &s->handle;
+	}
+	return NULL;
+}
+
+EXPORT_SYMBOL(nftnl_string_get);
+const void *nftnl_string_get(const struct nftnl_string *s, uint16_t attr)
+{
+	uint32_t data_len;
+	return nftnl_string_get_data(s, attr, &data_len);
+}
+
+EXPORT_SYMBOL(nftnl_string_get_str);
+const char *nftnl_string_get_str(const struct nftnl_string *s, uint16_t attr)
+{
+	return nftnl_string_get(s, attr);
+}
+
+EXPORT_SYMBOL(nftnl_string_get_u64);
+uint64_t nftnl_string_get_u64(const struct nftnl_string *s, uint16_t attr)
+{
+	uint32_t data_len;
+	const uint64_t *val = nftnl_string_get_data(s, attr, &data_len);
+
+	nftnl_assert(val, attr, data_len == sizeof(uint64_t));
+
+	return val ? *val : 0;
+}
+
+EXPORT_SYMBOL(nftnl_string_nlmsg_build_payload);
+void nftnl_string_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_string *s)
+{
+	if (s->flags & (1 << NFTNL_STRING_TABLE))
+		mnl_attr_put_strz(nlh, NFTA_STRSET_TABLE, s->table);
+	if (s->flags & (1 << NFTNL_STRING_NAME))
+		mnl_attr_put_strz(nlh, NFTA_STRSET_NAME, s->name);
+	if (s->flags & (1 << NFTNL_STRING_HANDLE))
+		mnl_attr_put_u64(nlh, NFTA_STRSET_HANDLE, htobe64(s->handle));
+	if (!list_empty(&s->string_list)) {
+		struct nftnl_str *str;
+		struct nlattr *nest1, *nest2;
+
+		nest1 = mnl_attr_nest_start(nlh, NFTA_STRSET_LIST);
+		list_for_each_entry(str, &s->string_list, head) {
+			nest2 = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
+			mnl_attr_put_str(nlh, NFTA_STRING, str->value);
+			mnl_attr_nest_end(nlh, nest2);
+		}
+		mnl_attr_nest_end(nlh, nest1);
+	}
+}
+
+EXPORT_SYMBOL(nftnl_string_add);
+int nftnl_string_add(struct nftnl_string *s, const char *word)
+{
+	struct nftnl_str *str;
+
+	str = malloc(sizeof(struct nftnl_str));
+	if (!str)
+		return -1;
+
+	str->value = strdup(word);
+	if (!str->value) {
+		free(str);
+		return -1;
+	}
+
+	list_add_tail(&str->head, &s->string_list);
+
+	return 0;
+}
+
+static int nftnl_string_parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_STRSET_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_STRSET_TABLE:
+	case NFTA_STRSET_NAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	case NFTA_STRSET_HANDLE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
+	case NFTA_STRSET_LIST:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int nftnl_string_parse_cb(const struct nlattr *attr, void *data)
+{
+	int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+	switch (type) {
+	case NFTA_STRING:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING))
+			return MNL_CB_ERROR;
+		break;
+	default:
+		return MNL_CB_OK;
+	}
+
+	tb[type] = attr;
+
+	return MNL_CB_OK;
+}
+
+static struct nftnl_str *nftnl_string_parse(struct nlattr *attr)
+{
+	struct nlattr *tb[NFTA_STRING_MAX + 1] = {};
+	struct nftnl_str *str;
+
+	if (mnl_attr_parse_nested(attr, nftnl_string_parse_cb, tb) < 0)
+		return NULL;
+
+	if (!tb[NFTA_STRING])
+		return NULL;
+
+	str = malloc(sizeof(struct nftnl_str));
+	if (!str)
+		return NULL;
+
+	str->value = strdup(mnl_attr_get_str(tb[NFTA_STRING]));
+	if (!str->value) {
+		free(str);
+		return NULL;
+	}
+
+	return str;
+}
+
+EXPORT_SYMBOL(nftnl_string_nlmsg_parse);
+int nftnl_string_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_string *s)
+{
+	struct nlattr *tb[NFTA_STRSET_MAX + 1] = {};
+	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
+	struct nftnl_str *str, *next;
+
+	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_string_parse_attr_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_STRSET_TABLE]) {
+		if (s->flags & (1 << NFTNL_STRING_TABLE))
+			xfree(s->table);
+		s->table = strdup(mnl_attr_get_str(tb[NFTA_STRSET_TABLE]));
+		if (!s->table)
+			return -1;
+		s->flags |= (1 << NFTNL_STRING_TABLE);
+	}
+	if (tb[NFTA_STRSET_NAME]) {
+		if (s->flags & (1 << NFTNL_STRING_NAME))
+			xfree(s->name);
+		s->name = strdup(mnl_attr_get_str(tb[NFTA_STRSET_NAME]));
+		if (!s->name)
+			return -1;
+		s->flags |= (1 << NFTNL_STRING_NAME);
+	}
+	if (tb[NFTA_STRSET_HANDLE]) {
+		s->handle = be64toh(mnl_attr_get_u64(tb[NFTA_STRSET_HANDLE]));
+		s->flags |= (1 << NFTNL_STRING_HANDLE);
+	}
+	if (tb[NFTA_STRSET_LIST]) {
+		struct nlattr *attr;
+
+		mnl_attr_for_each_nested(attr, tb[NFTA_STRSET_LIST]) {
+			if (mnl_attr_get_type(attr) != NFTA_LIST_ELEM)
+				goto out_str;
+
+			str = nftnl_string_parse(attr);
+			if (str == NULL)
+				goto out_str;
+
+			list_add_tail(&str->head, &s->string_list);
+		}
+		s->flags |= (1 << NFTNL_STRING_LIST);
+	}
+
+	s->family = nfg->nfgen_family;
+	s->flags |= (1 << NFTNL_STRING_FAMILY);
+
+	return 0;
+
+out_str:
+	list_for_each_entry_safe(str, next, &s->string_list, head)
+		nftnl_str_free(str);
+
+	return -1;
+}
+
+static int nftnl_string_snprintf_default(char *buf, size_t remain,
+					 const struct nftnl_string *s,
+					 uint32_t type, uint32_t flags)
+{
+	struct nftnl_str *str;
+	int ret, offset = 0;
+
+	ret = snprintf(buf, remain, "%s %s ", s->name, s->table);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	if (list_empty(&s->string_list))
+		return offset;
+
+	ret = snprintf(buf + offset, remain, "\n");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	list_for_each_entry(str, &s->string_list, head) {
+		ret = snprintf(buf + offset, remain, "%s ", str->value);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
+
+	return offset;
+}
+
+static int nftnl_string_cmd_snprintf(char *buf, size_t remain,
+				     const struct nftnl_string *s, uint32_t cmd,
+				     uint32_t type, uint32_t flags)
+{
+	uint32_t inner_flags = flags;
+	int ret, offset = 0;
+
+	if (type != NFTNL_OUTPUT_DEFAULT)
+		return -1;
+
+	/* prevent set_elems to print as events */
+	inner_flags &= ~NFTNL_OF_EVENT_ANY;
+
+	ret = nftnl_string_snprintf_default(buf + offset, remain, s, type,
+					    inner_flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	return offset;
+}
+
+EXPORT_SYMBOL(nftnl_string_snprintf);
+int nftnl_string_snprintf(char *buf, size_t size, const struct nftnl_string *s,
+			  uint32_t type, uint32_t flags)
+{
+	if (size)
+		buf[0] = '\0';
+
+	return nftnl_string_cmd_snprintf(buf, size, s, nftnl_flag2cmd(flags),
+					 type, flags);
+}
+
+EXPORT_SYMBOL(nftnl_string_foreach);
+int nftnl_string_foreach(struct nftnl_string *str,
+			 int (*cb)(const char *word, void *data), void *data)
+{
+	struct nftnl_str *cur;
+	int ret;
+
+	list_for_each_entry(cur, &str->string_list, head) {
+		ret = cb(cur->value, data);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
-- 
2.30.2

