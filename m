From: ana@soleta.eu
Subject: [libnftnl] src: Add accounters support
Date: Mon, 12 Jan 2015 11:55:52 +0100
Message-ID: <03a8f7e4718a14480fd69fa4ede3a296e50a18fc.1421059891.git.ana@soleta.eu>
References: <cover.1421059192.git.ana@soleta.eu>
Cc: Ana Rey <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:46820 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbbALLEC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:04:02 -0500
In-Reply-To: <cover.1421059192.git.ana@soleta.eu>
In-Reply-To: <cover.1421059891.git.ana@soleta.eu>
References: <cover.1421059891.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ana Rey <ana@soleta.eu>

This adds userspace support to acct: support to accounting objects and
acct expresion.

Moreover, this adds some examples to add/delete/get/reset the accounter
object and add rules using an existing acct.

Example of how to use those examples:

* Add a new acct:
 # ./examples/nft-acct-add ip test acct1

 # ./examples/nft-acct-get ip test acct1 default
 table test family ip acct acct1 packet 0 bytes 0

 * Delete an acct:
 # ./examples/nft-acct-del ip test acct1

 * Add a rule using the acct expresion.
 # ./examples/nft-rule-add ip test output

 * Reset the acct:
 # ./examples/nft-acct-reset ip test acct1

The kernel support is added in the commit:
netfilter: acct: add support to accounters in nftables

Signed-off-by: Ana Rey Botello <ana@soleta.eu>
---
 examples/Makefile.am                |   23 +-
 examples/nft-acct-add.c             |  136 ++++++++
 examples/nft-acct-del.c             |  133 ++++++++
 examples/nft-acct-get.c             |  135 ++++++++
 examples/nft-acct-reset.c           |  121 +++++++
 examples/nft-rule-acct-add.c        |  220 +++++++++++++
 examples/nft-rule-get.c             |    1 +
 include/buffer.h                    |    1 +
 include/libnftnl/Makefile.am        |    3 +-
 include/libnftnl/acct.h             |   87 +++++
 include/libnftnl/expr.h             |    3 +
 include/linux/netfilter/nf_tables.h |   41 +++
 src/Makefile.am                     |    2 +
 src/acct.c                          |  612 +++++++++++++++++++++++++++++++++++
 src/expr/acct.c                     |  201 ++++++++++++
 src/libnftnl.map                    |   30 ++
 16 files changed, 1747 insertions(+), 2 deletions(-)
 create mode 100644 examples/nft-acct-add.c
 create mode 100644 examples/nft-acct-del.c
 create mode 100644 examples/nft-acct-get.c
 create mode 100644 examples/nft-acct-reset.c
 create mode 100644 examples/nft-rule-acct-add.c
 create mode 100644 include/libnftnl/acct.h
 create mode 100644 src/acct.c
 create mode 100644 src/expr/acct.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index fafcb76..d83c2b9 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -22,7 +22,13 @@ check_PROGRAMS = nft-table-add		\
 		 nft-set-elem-get	\
 		 nft-set-elem-del	\
 		 nft-ruleset-get	\
-		 nft-compat-get
+		 nft-compat-get		\
+		 nft-acct-add		\
+		 nft-acct-get		\
+		 nft-acct-reset		\
+		 nft-rule-acct-add	\
+		 nft-acct-del
+
 
 nft_table_add_SOURCES = nft-table-add.c
 nft_table_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
@@ -92,3 +98,18 @@ nft_ruleset_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
 nft_compat_get_SOURCES = nft-compat-get.c
 nft_compat_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_acct_add_SOURCES = nft-acct-add.c
+nft_acct_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_acct_get_SOURCES = nft-acct-get.c
+nft_acct_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_acct_reset_SOURCES = nft-acct-reset.c
+nft_acct_reset_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_acct_del_SOURCES = nft-acct-del.c
+nft_acct_del_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_rule_acct_add_SOURCES = nft-rule-acct-add.c
+nft_rule_acct_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/examples/nft-acct-add.c b/examples/nft-acct-add.c
new file mode 100644
index 0000000..2598947
--- /dev/null
+++ b/examples/nft-acct-add.c
@@ -0,0 +1,136 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
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
+#include <libnftnl/table.h>
+#include <libnftnl/acct.h>
+
+static struct nft_acct *acct_add_parse(int argc, char *argv[])
+{
+	struct nft_acct *acct;
+	uint16_t family;
+
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "bridge") == 0)
+		family = NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") == 0)
+		family = NFPROTO_ARP;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		return NULL;
+	}
+
+	acct = nft_acct_alloc();
+	if (acct == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	nft_acct_attr_set_str(acct, NFT_ACCT_ATTR_NAME, argv[3]);
+	nft_acct_attr_set_str(acct, NFT_ACCT_ATTR_TABLE, argv[2]);
+	nft_acct_attr_set_u32(acct, NFT_ACCT_ATTR_FAMILY, family);
+
+	return acct;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq, acct_seq, family;
+	struct nft_acct *acct;
+	struct mnl_nlmsg_batch *batch;
+	int ret, batching;
+
+	if (argc != 4) {
+		fprintf(stderr, "%s <family> <table> <acct>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	acct = acct_add_parse(argc, argv);
+	if (acct == NULL)
+		exit(EXIT_FAILURE);
+
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
+	batching = nft_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
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
+	acct_seq = seq;
+	family = nft_acct_attr_get_u32(acct, NFT_ACCT_ATTR_FAMILY);
+	nlh = nft_acct_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				       NFT_MSG_NEWACCT, family,
+				       NLM_F_CREATE|NLM_F_ACK, seq++);
+
+	nft_acct_nlmsg_build_payload(nlh, acct);
+	nft_acct_free(acct);
+	mnl_nlmsg_batch_next(batch);
+
+	if (batching) {
+		nft_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
+
+	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
+				mnl_nlmsg_batch_size(batch));
+	if (ret == -1) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_nlmsg_batch_stop(batch);
+	portid = mnl_socket_get_portid(nl);
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, acct_seq, portid, NULL, NULL);
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
diff --git a/examples/nft-acct-del.c b/examples/nft-acct-del.c
new file mode 100644
index 0000000..2b88b9a
--- /dev/null
+++ b/examples/nft-acct-del.c
@@ -0,0 +1,133 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
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
+#include <libnftnl/acct.h>
+
+static struct nft_acct *acct_del_parse(int argc, char *argv[])
+{
+	struct nft_acct *acct;
+	uint16_t family;
+
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "bridge") == 0)
+		family = NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") == 0)
+		family = NFPROTO_ARP;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		return NULL;
+	}
+
+	acct = nft_acct_alloc();
+	if (acct == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	nft_acct_attr_set_str(acct, NFT_ACCT_ATTR_TABLE, argv[2]);
+	nft_acct_attr_set_u32(acct, NFT_ACCT_ATTR_FAMILY, family);
+	nft_acct_attr_set_str(acct, NFT_ACCT_ATTR_NAME, argv[3]);
+
+	return acct;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq, table_seq, family;
+	struct nft_acct *acct;
+	struct mnl_nlmsg_batch *batch;
+	int ret, batching;
+
+	if (argc != 4) {
+		fprintf(stderr, "%s <family> <table> <acct>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	acct = acct_del_parse(argc, argv);
+	if (acct == NULL)
+		exit(EXIT_FAILURE);
+
+	batching = nft_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
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
+
+	table_seq = seq;
+	family = nft_acct_attr_get_u32(acct, NFT_ACCT_ATTR_FAMILY);
+	nlh = nft_acct_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				       NFT_MSG_DELACCT, family,
+				       NLM_F_ACK, seq++);
+	nft_acct_nlmsg_build_payload(nlh, acct);
+	mnl_nlmsg_batch_next(batch);
+	nft_acct_free(acct);
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
+		ret = mnl_cb_run(buf, ret, table_seq, portid, NULL, NULL);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		printf("error\n");
+		exit(EXIT_FAILURE);
+	}
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-acct-get.c b/examples/nft-acct-get.c
new file mode 100644
index 0000000..4c9c5bc
--- /dev/null
+++ b/examples/nft-acct-get.c
@@ -0,0 +1,135 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
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
+#include <libnftnl/acct.h>
+
+static int acct_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_acct *acct;
+	char buf[4096];
+	uint32_t *type = data;
+
+	acct = nft_acct_alloc();
+	if (acct == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nft_acct_nlmsg_parse(nlh, acct) < 0) {
+		perror("nft_acct_nlmsg_parse");
+		goto err_free;
+	}
+	nft_acct_snprintf(buf, sizeof(buf), acct, *type, 0);
+	printf("%s\n", buf);
+
+err_free:
+	nft_acct_free(acct);
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
+	struct nft_acct *acct = NULL;
+	int ret;
+	uint32_t type = NFT_OUTPUT_DEFAULT;
+
+	if (argc != 5) {
+		fprintf(stderr,
+			"%s <family> <table> <acct> [<default|xml|json>]\n",
+			argv[0]);
+		return EXIT_FAILURE;
+	}
+
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "bridge") == 0)
+		family = NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") == 0)
+		family = NFPROTO_ARP;
+	else if (strcmp(argv[1], "unspec") == 0)
+		family = NFPROTO_UNSPEC;
+	else {
+		fprintf(stderr,
+			"Unknown family: ip, ip6, bridge, arp, unspec\n");
+		exit(EXIT_FAILURE);
+	}
+	if (strcmp(argv[argc-1], "xml") == 0) {
+		type = NFT_OUTPUT_XML;
+		argv[argc-1] = NULL;
+		argc--;
+	} else if (strcmp(argv[argc-1], "json") == 0) {
+		type = NFT_OUTPUT_JSON;
+		argv[argc-1] = NULL;
+		argc--;
+	} else if (strcmp(argv[argc - 1], "default") == 0) {
+		argc--;
+	}
+	acct = nft_acct_alloc();
+	if (acct == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	seq = time(NULL);
+	nlh = nft_acct_nlmsg_build_hdr(buf, NFT_MSG_GETACCT, family, NLM_F_ACK,
+				       seq);
+	nft_acct_attr_set_str(acct, NFT_ACCT_ATTR_NAME, argv[3]);
+	nft_acct_attr_set_str(acct, NFT_ACCT_ATTR_TABLE, argv[2]);
+	nft_acct_nlmsg_build_payload(nlh, acct);
+	nft_acct_free(acct);
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
+
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, acct_cb, &type);
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
diff --git a/examples/nft-acct-reset.c b/examples/nft-acct-reset.c
new file mode 100644
index 0000000..9bcba31
--- /dev/null
+++ b/examples/nft-acct-reset.c
@@ -0,0 +1,121 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
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
+#include <libnftnl/acct.h>
+
+static int acct_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_acct *acct;
+
+	acct = nft_acct_alloc();
+	if (acct == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nft_acct_nlmsg_parse(nlh, acct) < 0) {
+		perror("nft_acct_nlmsg_parse");
+		goto err_free;
+	}
+err_free:
+	nft_acct_free(acct);
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
+	struct nft_acct *acct = NULL;
+	int ret;
+	uint32_t type = NFT_OUTPUT_DEFAULT;
+
+	if (argc != 4) {
+		fprintf(stderr,
+			"%s <family> <table> <acct>\n",
+			argv[0]);
+		return EXIT_FAILURE;
+	}
+
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "bridge") == 0)
+		family = NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") == 0)
+		family = NFPROTO_ARP;
+	else if (strcmp(argv[1], "unspec") == 0)
+		family = NFPROTO_UNSPEC;
+	else {
+		fprintf(stderr,
+			"Unknown family: ip, ip6, bridge, arp, unspec\n");
+		exit(EXIT_FAILURE);
+	}
+
+	acct = nft_acct_alloc();
+	if (acct == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	seq = time(NULL);
+	nlh = nft_acct_nlmsg_build_hdr(buf, NFT_MSG_GETACCT_ZERO, family,
+				       NLM_F_ACK, seq);
+	nft_acct_attr_set_str(acct, NFT_ACCT_ATTR_NAME, argv[3]);
+	nft_acct_attr_set_str(acct, NFT_ACCT_ATTR_TABLE, argv[2]);
+	nft_acct_nlmsg_build_payload(nlh, acct);
+	nft_acct_free(acct);
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
+
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, acct_cb, &type);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+
+	if (ret == -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-rule-acct-add.c b/examples/nft-rule-acct-add.c
new file mode 100644
index 0000000..2214a21
--- /dev/null
+++ b/examples/nft-rule-acct-add.c
@@ -0,0 +1,220 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
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
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+
+static void add_payload(struct nft_rule *r, uint32_t base, uint32_t dreg,
+			uint32_t offset, uint32_t len)
+{
+	struct nft_rule_expr *e;
+
+	e = nft_rule_expr_alloc("payload");
+	if (e == NULL) {
+		perror("expr payload oom");
+		exit(EXIT_FAILURE);
+	}
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE, base);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, dreg);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET, offset);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, len);
+
+	nft_rule_add_expr(r, e);
+}
+
+static void add_cmp(struct nft_rule *r, uint32_t sreg, uint32_t op,
+		    const void *data, uint32_t data_len)
+{
+	struct nft_rule_expr *e;
+
+	e = nft_rule_expr_alloc("cmp");
+	if (e == NULL) {
+		perror("expr cmp oom");
+		exit(EXIT_FAILURE);
+	}
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_SREG, sreg);
+	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_OP, op);
+	nft_rule_expr_set(e, NFT_EXPR_CMP_DATA, data, data_len);
+	nft_rule_add_expr(r, e);
+}
+
+static void add_acct(struct nft_rule *r)
+{
+	struct nft_rule_expr *e;
+
+	e = nft_rule_expr_alloc("acct");
+	if (e == NULL) {
+		perror("expr acct oom");
+		exit(EXIT_FAILURE);
+	}
+	nft_rule_expr_set(e, NFT_EXPR_ACCT_NAME, "acct1", sizeof("acct1"));
+	nft_rule_expr_set_str(e, NFT_EXPR_ACCT_NAME, "acct1");
+
+	nft_rule_add_expr(r, e);
+}
+
+static struct nft_rule *setup_rule(uint8_t family, const char *table,
+				   const char *chain, const char *handle)
+{
+	struct nft_rule *r = NULL;
+	uint8_t proto;
+	uint16_t dport;
+	uint64_t handle_num;
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
+	if (handle != NULL) {
+		handle_num = atoll(handle);
+		nft_rule_attr_set_u64(r, NFT_RULE_ATTR_POSITION, handle_num);
+	}
+
+	proto = IPPROTO_TCP;
+	add_payload(r, NFT_PAYLOAD_NETWORK_HEADER, NFT_REG_1,
+		    offsetof(struct iphdr, protocol), sizeof(uint8_t));
+	add_cmp(r, NFT_REG_1, NFT_CMP_EQ, &proto, sizeof(uint8_t));
+
+	dport = htons(80);
+	add_payload(r, NFT_PAYLOAD_TRANSPORT_HEADER, NFT_REG_1,
+		    offsetof(struct tcphdr, dest), sizeof(uint16_t));
+	add_cmp(r, NFT_REG_1, NFT_CMP_EQ, &dport, sizeof(uint16_t));
+
+	add_acct(r);
+	return r;
+}
+
+static void nft_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = type;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+	nlh->nlmsg_seq = seq;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_INET;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = NFNL_SUBSYS_NFTABLES;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	struct nft_rule *r;
+	struct nlmsghdr *nlh;
+	struct mnl_nlmsg_batch *batch;
+	uint8_t family;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	char buf2[MNL_SOCKET_BUFFER_SIZE];
+	uint32_t seq = time(NULL);
+	int ret;
+
+	if (argc < 4 || argc > 5) {
+		fprintf(stderr,
+			"Usage: %s <family> <table> <chain>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (argc != 5)
+		r = setup_rule(family, argv[2], argv[3], NULL);
+	else
+		r = setup_rule(family, argv[2], argv[3], argv[4]);
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
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch),
+			  NFNL_MSG_BATCH_BEGIN, seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_NEWRULE,
+			nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY),
+			NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
+
+	nft_rule_nlmsg_build_payload(nlh, r);
+	nft_rule_snprintf(buf2, sizeof(buf), r, NFT_OUTPUT_JSON, 0);
+	nft_rule_free(r);
+	mnl_nlmsg_batch_next(batch);
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
+			 seq++);
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
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-rule-get.c b/examples/nft-rule-get.c
index 5803143..5467d7e 100644
--- a/examples/nft-rule-get.c
+++ b/examples/nft-rule-get.c
@@ -19,6 +19,7 @@
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
 
 static int table_cb(const struct nlmsghdr *nlh, void *data)
 {
diff --git a/include/buffer.h b/include/buffer.h
index 2b497f2..d8aa5c0 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -33,6 +33,7 @@ int nft_buf_str(struct nft_buf *b, int type, const char *str, const char *tag);
 int nft_buf_reg(struct nft_buf *b, int type, union nft_data_reg *reg,
 		int reg_type, const char *tag);
 
+#define ACCT			"acct"
 #define BASE			"base"
 #define BYTES			"bytes"
 #define CHAIN			"chain"
diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile.am
index 010c01f..2381589 100644
--- a/include/libnftnl/Makefile.am
+++ b/include/libnftnl/Makefile.am
@@ -5,4 +5,5 @@ pkginclude_HEADERS = table.h		\
 		     set.h		\
 		     ruleset.h		\
 		     common.h		\
-		     gen.h
+		     gen.h		\
+		     acct.h
diff --git a/include/libnftnl/acct.h b/include/libnftnl/acct.h
new file mode 100644
index 0000000..af5dc1d
--- /dev/null
+++ b/include/libnftnl/acct.h
@@ -0,0 +1,87 @@
+#ifndef _LIBNFTNL_ACCT_H_
+#define _LIBNFTNL_ACCT_H_
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
+struct nft_acct;
+
+struct nft_acct *nft_acct_alloc(void);
+void nft_acct_free(struct nft_acct *);
+
+enum {
+	NFT_ACCT_ATTR_NAME	= 0,
+	NFT_ACCT_ATTR_TABLE,
+	NFT_ACCT_ATTR_FAMILY,
+	NFT_ACCT_ATTR_PKTS,
+	NFT_ACCT_ATTR_BYTES,
+	NFT_ACCT_ATTR_FLAGS,
+	NFT_ACCT_ATTR_ID,
+	__NFT_ACCT_ATTR_MAX
+};
+#define NFT_ACCT_ATTR_MAX (__NFT_ACCT_ATTR_MAX - 1)
+
+bool nft_acct_attr_is_set(const struct nft_acct *acct, uint16_t attr);
+void nft_acct_attr_unset(struct nft_acct *acct, uint16_t attr);
+void nft_acct_attr_set(struct nft_acct *acct, uint16_t attr, const void *data);
+void nft_acct_attr_set_data(struct nft_acct *acct, uint16_t attr,
+			     const void *data, uint32_t data_len);
+const void *nft_acct_attr_get(struct nft_acct *t, uint16_t attr);
+const void *nft_acct_attr_get_data(struct nft_acct *t, uint16_t attr,
+				   uint64_t *data_len);
+
+void nft_acct_attr_set_u32(struct nft_acct *acct, uint16_t attr, uint32_t data);
+void nft_acct_attr_set_u64(struct nft_acct *acct, uint16_t attr, uint64_t data);
+void nft_acct_attr_set_str(struct nft_acct *acct, uint16_t attr,
+			    const char *str);
+uint32_t nft_acct_attr_get_u32(struct nft_acct *acct, uint16_t attr);
+uint64_t nft_acct_attr_get_u64(struct nft_acct *acct, uint16_t attr);
+const char *nft_acct_attr_get_str(struct nft_acct *acct, uint16_t attr);
+
+struct nlmsghdr;
+
+void nft_acct_nlmsg_build_payload(struct nlmsghdr *nlh,
+				  const struct nft_acct *acct);
+
+int nft_acct_parse(struct nft_acct *acct, enum nft_parse_type type,
+		   const char *data, struct nft_parse_err *err);
+int nft_acct_parse_file(struct nft_acct *t, enum nft_parse_type type,
+			FILE *fp, struct nft_parse_err *err);
+int nft_acct_snprintf(char *buf, size_t size, struct nft_acct *acct,
+		      uint32_t type, uint32_t flags);
+int nft_acct_fprintf(FILE *fp, struct nft_acct *acct, uint32_t type,
+		     uint32_t flags);
+
+#define nft_acct_nlmsg_build_hdr	nft_nlmsg_build_hdr
+int nft_acct_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_acct *acct);
+struct nft_acct_list;
+
+struct nft_acct_list *nft_acct_list_alloc(void);
+void nft_acct_list_free(struct nft_acct_list *list);
+int nft_acct_list_is_empty(struct nft_acct_list *list);
+int nft_acct_list_foreach(struct nft_acct_list *acct_list,
+			   int (*cb)(struct nft_acct *t, void *data),
+			    void *data);
+void nft_acct_list_add(struct nft_acct *r, struct nft_acct_list *list);
+void nft_acct_list_add_tail(struct nft_acct *r, struct nft_acct_list *list);
+void nft_acct_list_del(struct nft_acct *r);
+
+struct nft_acct_list_iter;
+
+struct nft_acct_list_iter *nft_acct_list_iter_create(struct nft_acct_list *l);
+struct nft_acct *nft_acct_list_iter_next(struct nft_acct_list_iter *iter);
+void nft_acct_list_iter_destroy(struct nft_acct_list_iter *iter);
+
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
+#endif /* _LIBNFTNL_ACCT_H_ */
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 9f25993..6909ebe 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -167,6 +167,9 @@ enum {
 	NFT_EXPR_REDIR_FLAGS,
 };
 
+enum {
+	NFT_EXPR_ACCT_NAME	= NFT_RULE_EXPR_ATTR_BASE,
+};
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 832bc46..ee00dec 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -53,6 +53,10 @@ enum nft_verdicts {
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
  * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
+ * @NFT_MSG_NEWACCT: create an new accounter (enum nft_acct_attributes)
+ * @NFT_MSG_GETACCT: get an accounter (enum nft_acct_attributes)
+ * @NFT_MSG_GETACCT_ZERO: get a reset accounter (enum nft_acct_attributes)
+ * @NFT_MSG_DELACCT: delete an accounter (enum nft_acct_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -72,6 +76,10 @@ enum nf_tables_msg_types {
 	NFT_MSG_DELSETELEM,
 	NFT_MSG_NEWGEN,
 	NFT_MSG_GETGEN,
+	NFT_MSG_NEWACCT,
+	NFT_MSG_GETACCT,
+	NFT_MSG_GETACCT_ZERO,
+	NFT_MSG_DELACCT,
 	NFT_MSG_MAX,
 };
 
@@ -867,4 +875,37 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+/*
+ * enum nft_acct_attributes - nf_tables acct netlink attributes
+ *
+ * @NFTA_ACCT_NAME: name of the accounter (NLA_STRING)
+ * @NFTA_ACCT_TABLE: table name (NLA_STRING)
+ * @NFTA_ACCT_BYTES: number of bytes (NLA_U64)
+ * @NFTA_ACCT_PACKETS: number of packets (NLA_U64)
+ * @NFTA_ACCT_USE: number of rule in this accts (NLA_U32)
+ * @NFTA_ACCT_ID: uniquely identifies a acct in a transaction (NLA_U32)
+ */
+enum nft_acct_attributes {
+	NFTA_ACCT_UNSPEC,
+	NFTA_ACCT_NAME,
+	NFTA_ACCT_TABLE,
+	NFTA_ACCT_BYTES,
+	NFTA_ACCT_PACKETS,
+	NFTA_ACCT_USE,
+	NFTA_ACCT_ID,
+	__NFTA_ACCT_MAX
+};
+#define NFTA_ACCT_MAX		(__NFTA_ACCT_MAX - 1)
+
+enum nft_acct_expr_attr {
+	NFTA_ACCT_EXPR_UNSPEC,
+	NFTA_ACCT_EXPR_NAME,
+	__NFTA_ACCT_EXPR_MAX
+};
+#define NFTA_ACCT_EXPR_MAX        (__NFTA_ACCT_EXPR_MAX - 1)
+
+#ifndef NFTA_ACCT_NAME_MAX
+#define NFTA_ACCT_NAME_MAX	32
+#endif
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index c77c3cc..0ae91b9 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,6 +6,7 @@ libnftnl_la_LDFLAGS = -Wl,--version-script=$(srcdir)/libnftnl.map	\
 		      -version-info $(LIBVERSION)
 
 libnftnl_la_SOURCES = utils.c		\
+		      acct.c		\
 		      buffer.c		\
 		      common.c		\
 		      gen.c		\
@@ -19,6 +20,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      jansson.c		\
 		      expr.c		\
 		      expr_ops.c	\
+		      expr/acct.c	\
 		      expr/bitwise.c	\
 		      expr/byteorder.c	\
 		      expr/cmp.c	\
diff --git a/src/acct.c b/src/acct.c
new file mode 100644
index 0000000..908c1b5
--- /dev/null
+++ b/src/acct.c
@@ -0,0 +1,612 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
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
+#include <inttypes.h>
+
+#include <linux/types.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/table.h>
+#include <libnftnl/acct.h>
+#include <buffer.h>
+
+struct nft_acct {
+	struct list_head	list;
+	const char              *name;
+	const char		*table;
+	uint32_t		family;
+	unsigned long           flags;
+	uint64_t		pkts;
+	uint64_t		bytes;
+	uint32_t		use;
+};
+
+struct nft_acct *nft_acct_alloc(void)
+{
+	struct nft_acct *acct;
+
+	acct = calloc(1, sizeof(struct nft_acct));
+	if (acct == NULL)
+		return NULL;
+
+	return acct;
+}
+EXPORT_SYMBOL(nft_acct_alloc);
+
+void nft_acct_free(struct nft_acct *acct)
+{
+	if (acct->name != NULL)
+		xfree(acct->name);
+	if (acct->table != NULL)
+		xfree(acct->table);
+
+	xfree(acct);
+}
+EXPORT_SYMBOL(nft_acct_free);
+
+bool nft_acct_attr_is_set(const struct nft_acct *acct, uint16_t attr)
+{
+	return acct->flags & (1 << attr);
+}
+EXPORT_SYMBOL(nft_acct_attr_is_set);
+
+void nft_acct_attr_unset(struct nft_acct *acct, uint16_t attr)
+{
+	if (!(acct->flags & (1 << attr)))
+		return;
+
+	switch (attr) {
+	case NFT_ACCT_ATTR_NAME:
+		if (acct->name) {
+			xfree(acct->name);
+			acct->name = NULL;
+		}
+		break;
+	case NFT_ACCT_ATTR_TABLE:
+		if (acct->table) {
+			xfree(acct->table);
+			acct->table = NULL;
+		}
+		break;
+	case NFT_ACCT_ATTR_BYTES:
+	case NFT_ACCT_ATTR_PKTS:
+	case NFT_ACCT_ATTR_FAMILY:
+		break;
+	}
+	acct->flags &= ~(1 << attr);
+}
+EXPORT_SYMBOL(nft_acct_attr_unset);
+
+static uint32_t nft_acct_attr_validate[NFT_ACCT_ATTR_MAX + 1] = {
+	[NFT_ACCT_ATTR_BYTES]	= sizeof(uint64_t),
+	[NFT_ACCT_ATTR_PKTS]	= sizeof(uint64_t),
+	[NFT_ACCT_ATTR_FAMILY]	= sizeof(uint32_t),
+};
+
+void nft_acct_attr_set_data(struct nft_acct *acct, uint16_t attr,
+			    const void *data, uint32_t data_len)
+{
+	if (attr > NFT_ACCT_ATTR_MAX)
+		return;
+
+	nft_assert_validate(data, nft_acct_attr_validate, attr, data_len);
+
+	switch (attr) {
+	case NFT_ACCT_ATTR_NAME:
+		if (acct->name)
+			xfree(acct->name);
+
+		acct->name = strdup(data);
+		break;
+	case NFT_ACCT_ATTR_TABLE:
+		if (acct->table)
+			xfree(acct->table);
+
+		acct->table = strdup(data);
+		break;
+	case NFT_ACCT_ATTR_BYTES:
+		acct->bytes = *((uint64_t *)data);
+		break;
+	case NFT_ACCT_ATTR_PKTS:
+		acct->pkts = *((uint64_t *)data);
+		break;
+	case NFT_ACCT_ATTR_FAMILY:
+		acct->family = *((uint32_t *)data);
+		break;
+	}
+	acct->flags |= (1 << attr);
+}
+EXPORT_SYMBOL(nft_acct_attr_set_data);
+
+void nft_acct_attr_set(struct nft_acct *acct, uint16_t attr, const void *data)
+{
+	nft_acct_attr_set_data(acct, attr, data, nft_acct_attr_validate[attr]);
+}
+EXPORT_SYMBOL(nft_acct_attr_set);
+
+void nft_acct_attr_set_u64(struct nft_acct *acct, uint16_t attr, uint64_t val)
+{
+	nft_acct_attr_set_data(acct, attr, &val, sizeof(uint64_t));
+}
+EXPORT_SYMBOL(nft_acct_attr_set_u64);
+
+void nft_acct_attr_set_u32(struct nft_acct *acct, uint16_t attr, uint32_t val)
+{
+	nft_acct_attr_set_data(acct, attr, &val, sizeof(uint32_t));
+}
+EXPORT_SYMBOL(nft_acct_attr_set_u32);
+
+void nft_acct_attr_set_str(struct nft_acct *acct, uint16_t attr,
+			   const char *str)
+{
+	nft_acct_attr_set_data(acct, attr, str, 0);
+}
+EXPORT_SYMBOL(nft_acct_attr_set_str);
+
+const void *nft_acct_attr_get_data(struct nft_acct *acct, uint16_t attr,
+				   uint64_t *data_len)
+{
+	if (!(acct->flags & (1 << attr)))
+		return NULL;
+
+	switch (attr) {
+	case NFT_ACCT_ATTR_NAME:
+		return acct->name;
+	case NFT_ACCT_ATTR_TABLE:
+		return acct->table;
+	case NFT_ACCT_ATTR_BYTES:
+		*data_len = sizeof(uint64_t);
+		return &acct->bytes;
+	case NFT_ACCT_ATTR_PKTS:
+		*data_len = sizeof(uint64_t);
+		return &acct->pkts;
+	case NFT_ACCT_ATTR_FAMILY:
+		*data_len = sizeof(uint32_t);
+		return &acct->family;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(nft_acct_attr_get_data);
+
+const void *nft_acct_attr_get(struct nft_acct *acct, uint16_t attr)
+{
+	uint64_t data_len;
+
+	return nft_acct_attr_get_data(acct, attr, &data_len);
+}
+EXPORT_SYMBOL(nft_acct_attr_get);
+
+uint64_t nft_acct_attr_get_u64(struct nft_acct *acct, uint16_t attr)
+{
+	const void *ret = nft_acct_attr_get(acct, attr);
+
+	return ret == NULL ? 0 : *((uint64_t *)ret);
+}
+EXPORT_SYMBOL(nft_acct_attr_get_u64);
+
+uint32_t nft_acct_attr_get_u32(struct nft_acct *acct, uint16_t attr)
+{
+	const void *ret = nft_acct_attr_get(acct, attr);
+
+	return ret == NULL ? 0 : *((uint32_t *)ret);
+}
+EXPORT_SYMBOL(nft_acct_attr_get_u32);
+
+const char *nft_acct_attr_get_str(struct nft_acct *acct, uint16_t attr)
+{
+	return nft_acct_attr_get(acct, attr);
+}
+EXPORT_SYMBOL(nft_acct_attr_get_str);
+
+void nft_acct_nlmsg_build_payload(struct nlmsghdr *nlh,
+				  const struct nft_acct *acct)
+{
+	if (acct->flags & (1 << NFT_ACCT_ATTR_NAME))
+		mnl_attr_put_strz(nlh, NFTA_ACCT_NAME, acct->name);
+	if (acct->flags & (1 << NFT_ACCT_ATTR_TABLE))
+		mnl_attr_put_strz(nlh, NFTA_ACCT_TABLE, acct->table);
+	if (acct->flags & (1 << NFT_ACCT_ATTR_BYTES))
+		mnl_attr_put_u64(nlh, NFTA_ACCT_BYTES, htobe64(acct->bytes));
+	if (acct->flags & (1 << NFT_ACCT_ATTR_PKTS))
+		mnl_attr_put_u64(nlh, NFTA_ACCT_PACKETS, htobe64(acct->pkts));
+}
+EXPORT_SYMBOL(nft_acct_nlmsg_build_payload);
+
+static int nft_acct_parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_ACCT_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_ACCT_NAME:
+	case NFTA_ACCT_TABLE:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	case NFTA_ACCT_BYTES:
+	case NFTA_ACCT_PACKETS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+int nft_acct_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_acct *acct)
+{
+	struct nlattr *tb[NFTA_ACCT_MAX + 1] = {};
+	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
+
+	if (mnl_attr_parse(nlh, sizeof(*nfg), nft_acct_parse_attr_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_ACCT_NAME]) {
+		acct->name = strdup(mnl_attr_get_str(tb[NFTA_ACCT_NAME]));
+		acct->flags |= (1 << NFT_ACCT_ATTR_NAME);
+	}
+	if (tb[NFTA_ACCT_TABLE]) {
+		acct->table = strdup(mnl_attr_get_str(tb[NFTA_ACCT_TABLE]));
+		acct->flags |= (1 << NFT_ACCT_ATTR_TABLE);
+	}
+	if (tb[NFTA_ACCT_BYTES]) {
+		acct->bytes = be64toh(mnl_attr_get_u64(tb[NFTA_ACCT_BYTES]));
+		acct->flags |= (1 << NFT_ACCT_ATTR_BYTES);
+	}
+	if (tb[NFTA_ACCT_PACKETS]) {
+		acct->pkts = be64toh(mnl_attr_get_u64(tb[NFTA_ACCT_PACKETS]));
+		acct->flags |= (1 << NFT_ACCT_ATTR_PKTS);
+	}
+	acct->family = nfg->nfgen_family;
+	acct->flags |= (1 << NFT_ACCT_ATTR_FAMILY);
+
+	return 0;
+}
+EXPORT_SYMBOL(nft_acct_nlmsg_parse);
+
+#ifdef XML_PARSING
+int nft_mxml_acct_parse(mxml_node_t *tree, struct nft_accte *acct,
+			struct nft_parse_err *err)
+{
+	const char *name, *table;
+	uint64_t pkts, bytes;
+	uint32_t family;
+
+	name = nft_mxml_str_parse(tree, "acct", MXML_DESCEND_FIRST,
+				  NFT_XML_MAND, err);
+	if (name != NULL)
+		nft_acct_attr_set_str(t, NFT_ACCT_ATTR_NAME, name);
+
+	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
+				  NFT_XML_MAND, err);
+	if (table != NULL)
+		nft_acct_attr_set_str(t, NFT_ACCT_ATTR_TABLE, table);
+
+	if (nft_mxml_num_parse(tree, "family", MXML_DESCEND, BASE_DEC,
+			       &use, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_acct_attr_set_u32(t, NFT_ACCT_ATTR_FAMILY, family);
+
+	if (nft_mxml_num_parse(tree, "pkts", MXML_DESCEND, BASE_DEC,
+			       &use, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
+		nft_acct_attr_set_u64(t, NFT_ACCT_ATTR_PKTS, pkts);
+
+	if (nft_mxml_num_parse(tree, "bytes", MXML_DESCEND, BASE_DEC,
+			       &use, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
+		nft_acct_attr_set_u64(t, NFT_ACCT_ATTR_BYTES, bytes);
+
+
+	return 0;
+}
+#endif
+
+static int nft_acct_xml_parse(struct nft_acct *acct, const void *data,
+			      struct nft_parse_err *err,
+			      enum nft_parse_input input)
+{
+#ifdef XML_PARSING
+	int ret;
+	mxml_node_t *tree = nft_mxml_build_tree(data, "acct", err, input);
+
+	if (tree == NULL)
+		return -1;
+
+	ret = nft_mxml_acct_parse(tree, acct, err);
+	mxmlDelete(tree);
+	return ret;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+#ifdef JSON_PARSING
+int nft_jansson_parse_acct(struct nft_acct *acct, json_t *tree,
+			   struct nft_parse_err *err)
+{
+	json_t *root;
+	uint64_t bytes, pkts;
+	const char *name, table;
+
+	root = nft_jansson_get_node(tree, "acct", err);
+	if (root == NULL)
+		return -1;
+
+	name = nft_jansson_parse_str(root, "name", err);
+	if (name != NULL)
+		nft_acct_attr_set_str(acct, NFT_ACCT_ATTR_NAME, name);
+
+	table = nft_jansson_parse_str(root, "table", err);
+	if (table != NULL)
+		nft_acct_attr_set_str(acct, NFT_ACCT_ATTR_TABLE, table);
+
+	if (nft_jansson_parse_val(root, "family", NFT_TYPE_U32, &family,
+				  err) == 0)
+		nft_acct_attr_set_u32(t, NFT_ACCT_ATTR_PKTS, family);
+
+	if (nft_jansson_parse_val(root, "pkts", NFT_TYPE_U64, &pkts, err) == 0)
+		nft_acct_attr_set_u64(t, NFT_ACCT_ATTR_PKTS, pkts);
+
+	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &bytes,
+				  err) == 0)
+		nft_acct_attr_set_u64(t, NFT_ACCT_ATTR_BYTES, bytes);
+
+	return 0;
+}
+#endif
+
+static int nft_acct_json_parse(struct nft_acct *acct, const void *json,
+			       struct nft_parse_err *err,
+			       enum nft_parse_input input)
+{
+#ifdef JSON_PARSING
+	json_t *tree;
+	json_error_t error;
+	int ret;
+
+	tree = nft_jansson_create_root(json, &error, err, input);
+	if (tree == NULL)
+		return -1;
+
+	ret = nft_jansson_parse_acct(acct, tree, err);
+
+	nft_jansson_free_root(tree);
+
+	return ret;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nft_acct_do_parse(struct nft_acct *acct, enum nft_parse_type type,
+			     const void *data, struct nft_parse_err *err,
+			     enum nft_parse_input input)
+{
+	int ret;
+	struct nft_parse_err perr;
+
+	switch (type) {
+	case NFT_PARSE_XML:
+		ret = nft_acct_xml_parse(acct, data, &perr, input);
+		break;
+	case NFT_PARSE_JSON:
+		ret = nft_acct_json_parse(acct, data, &perr, input);
+		break;
+	default:
+		ret = -1;
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	if (err != NULL)
+		*err = perr;
+
+	return ret;
+}
+
+int nft_acct_parse(struct nft_acct *acct, enum nft_parse_type type,
+		    const char *data, struct nft_parse_err *err)
+{
+	return nft_acct_do_parse(acct, type, data, err, NFT_PARSE_BUFFER);
+}
+EXPORT_SYMBOL(nft_acct_parse);
+
+int nft_acct_parse_file(struct nft_acct *acct, enum nft_parse_type type,
+			FILE *fp, struct nft_parse_err *err)
+{
+	return nft_acct_do_parse(acct, type, fp, err, NFT_PARSE_FILE);
+}
+EXPORT_SYMBOL(nft_acct_parse_file);
+
+static int nft_acct_export(char *buf, size_t size, struct nft_acct *acct,
+			   int type)
+{
+	NFT_BUF_INIT(b, buf, size);
+	nft_buf_open(&b, type, ACCT);
+
+	if (acct->flags & (1 << NFT_ACCT_ATTR_NAME))
+		nft_buf_str(&b, type, acct->name, NAME);
+	if (acct->flags & (1 << NFT_ACCT_ATTR_TABLE))
+		nft_buf_str(&b, type, acct->table, TABLE);
+	if (acct->flags & (1 << NFT_ACCT_ATTR_FAMILY))
+		nft_buf_str(&b, type, nft_family2str(acct->family), FAMILY);
+	if (acct->flags & (1 << NFT_ACCT_ATTR_PKTS))
+		nft_buf_u64(&b, type, acct->pkts, PACKETS);
+	if (acct->flags & (1 << NFT_ACCT_ATTR_BYTES))
+		nft_buf_u64(&b, type, acct->bytes, BYTES);
+	nft_buf_close(&b, type, ACCT);
+
+	return nft_buf_done(&b);
+}
+
+static int nft_acct_snprintf_default(char *buf, size_t size,
+				     struct nft_acct *acct)
+{
+	return snprintf(buf, size,
+			"table %s family %s acct %s packet %"PRIu64" bytes %"PRIu64"",
+			acct->table,
+			nft_family2str(acct->family),
+			acct->name,
+			acct->pkts,
+			acct->bytes);
+}
+
+int nft_acct_snprintf(char *buf, size_t len, struct nft_acct *acct,
+		       uint32_t type, uint32_t flags)
+{
+	switch (type) {
+	case NFT_OUTPUT_DEFAULT:
+		return nft_acct_snprintf_default(buf, len, acct);
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
+		return  nft_acct_export(buf, len, acct, type);
+	default:
+		break;
+	}
+	return -1;
+}
+EXPORT_SYMBOL(nft_acct_snprintf);
+
+static inline int nft_acct_do_snprintf(char *buf, size_t size, void *acct,
+				       uint32_t type, uint32_t flags)
+{
+	return nft_acct_snprintf(buf, size, acct, type, flags);
+}
+
+int nft_acct_fprintf(FILE *fp, struct nft_acct *acct, uint32_t type,
+		     uint32_t flags)
+{
+	return nft_fprintf(fp, acct, type, flags, nft_acct_do_snprintf);
+}
+EXPORT_SYMBOL(nft_acct_fprintf);
+
+struct nft_acct_list {
+	struct list_head list;
+};
+
+struct nft_acct_list *nft_acct_list_alloc(void)
+{
+	struct nft_acct_list *list;
+
+	list = calloc(1, sizeof(struct nft_acct_list));
+	if (list == NULL)
+		return NULL;
+
+	INIT_LIST_HEAD(&list->list);
+
+	return list;
+}
+EXPORT_SYMBOL(nft_acct_list_alloc);
+
+void nft_acct_list_free(struct nft_acct_list *list)
+{
+	struct nft_acct *acct, *tmp;
+
+	list_for_each_entry_safe(acct, tmp, &list->list, list) {
+		list_del(&acct->list);
+		nft_acct_free(acct);
+	}
+	xfree(list);
+}
+EXPORT_SYMBOL(nft_acct_list_free);
+
+int nft_acct_list_is_empty(struct nft_acct_list *list)
+{
+	return list_empty(&list->list);
+}
+EXPORT_SYMBOL(nft_acct_list_is_empty);
+
+void nft_acct_list_add(struct nft_acct *acct, struct nft_acct_list *list)
+{
+	list_add(&acct->list, &list->list);
+}
+EXPORT_SYMBOL(nft_acct_list_add);
+
+void nft_acct_list_add_tail(struct nft_acct *acct, struct nft_acct_list *list)
+{
+	list_add_tail(&acct->list, &list->list);
+}
+EXPORT_SYMBOL(nft_acct_list_add_tail);
+
+void nft_acct_list_del(struct nft_acct *acct)
+{
+	list_del(&acct->list);
+}
+EXPORT_SYMBOL(nft_acct_list_del);
+
+int nft_acct_list_foreach(struct nft_acct_list *acct_list,
+			  int (*cb)(struct nft_acct *acct, void *data),
+			  void *data)
+{
+	struct nft_acct *cur, *tmp;
+	int ret;
+
+	list_for_each_entry_safe(cur, tmp, &acct_list->list, list) {
+		ret = cb(cur, data);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(nft_acct_list_foreach);
+
+struct nft_acct_list_iter {
+	struct nft_acct_list	*list;
+	struct nft_acct		*cur;
+};
+
+struct nft_acct_list_iter *nft_acct_list_iter_create(struct nft_acct_list *l)
+{
+	struct nft_acct_list_iter *iter;
+
+	iter = calloc(1, sizeof(struct nft_acct_list_iter));
+	if (iter == NULL)
+		return NULL;
+
+	iter->list = l;
+	iter->cur = list_entry(l->list.next, struct nft_acct, list);
+
+	return iter;
+}
+EXPORT_SYMBOL(nft_acct_list_iter_create);
+
+struct nft_acct *nft_acct_list_iter_next(struct nft_acct_list_iter *iter)
+{
+	struct nft_acct *r = iter->cur;
+
+	/* get next acct, if any */
+	iter->cur = list_entry(iter->cur->list.next, struct nft_acct, list);
+	if (&iter->cur->list == iter->list->list.next)
+		return NULL;
+
+	return r;
+}
+EXPORT_SYMBOL(nft_acct_list_iter_next);
+
+void nft_acct_list_iter_destroy(struct nft_acct_list_iter *iter)
+{
+	xfree(iter);
+}
+EXPORT_SYMBOL(nft_acct_list_iter_destroy);
diff --git a/src/expr/acct.c b/src/expr/acct.c
new file mode 100644
index 0000000..9aabdd5
--- /dev/null
+++ b/src/expr/acct.c
@@ -0,0 +1,201 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
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
+#include <arpa/inet.h>
+#include <errno.h>
+#include <inttypes.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/rule.h>
+#include "expr_ops.h"
+#include <buffer.h>
+
+
+struct nft_expr_acct {
+	const char	*name;
+};
+
+static int nft_rule_expr_acct_set(struct nft_rule_expr *e, uint16_t type,
+				  const void *data, uint32_t data_len)
+{
+	struct nft_expr_acct *acct = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_ACCT_NAME:
+		if (acct->name)
+			xfree(acct->name);
+		acct->name = strdup(data);
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static const void *nft_rule_expr_acct_get(const struct nft_rule_expr *e,
+					  uint16_t type, uint32_t *data_len)
+{
+	struct nft_expr_acct *acct = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_ACCT_NAME:
+		*data_len = sizeof(acct->name);
+		return acct->name;
+	}
+
+	return NULL;
+}
+
+static int nft_rule_expr_acct_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_ACCT_EXPR_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_ACCT_EXPR_NAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+
+	return MNL_CB_OK;
+}
+
+static void nft_rule_expr_acct_build(struct nlmsghdr *nlh,
+				     struct nft_rule_expr *e)
+{
+	struct nft_expr_acct *acct = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_ACCT_NAME))
+		mnl_attr_put_strz(nlh, NFTA_ACCT_EXPR_NAME, acct->name);
+}
+
+static int nft_rule_expr_acct_parse(struct nft_rule_expr *e,
+				    struct nlattr *attr)
+{
+	struct nft_expr_acct *acct = nft_expr_data(e);
+	struct nlattr *tb[NFTA_ACCT_EXPR_MAX + 1] = {};
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_acct_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_ACCT_EXPR_NAME]) {
+		if (acct->name)
+			xfree(acct->name);
+		acct->name = strdup(mnl_attr_get_str(tb[NFTA_ACCT_EXPR_NAME]));
+		e->flags |= (1 << NFT_EXPR_ACCT_NAME);
+	}
+
+	return 0;
+}
+
+static int nft_rule_expr_acct_json_parse(struct nft_rule_expr *e, json_t *root,
+					 struct nft_parse_err *err)
+{
+#ifdef JSON_PARSING
+	const char *name;
+
+	name = nft_jansson_parse_str(root, "acct", err);
+	if (name != NULL)
+		nft_rule_expr_set_str(root, NFT_EXPR_ACCT_NAME, name);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nft_rule_expr_acct_xml_parse(struct nft_rule_expr *e,
+					mxml_node_t *tree,
+					struct nft_parse_err *err)
+{
+#ifdef XML_PARSING
+	const char *name;
+
+	name = nft_mxml_str_parse(tree, "acct", MXML_DESCEND_FIRST,
+				  NFT_XML_MAND, err);
+
+	if (name != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_ACCT_NAME, acct);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nft_rule_expr_acct_export(char *buf, size_t size,
+				     struct nft_rule_expr *e, int type)
+{
+	struct nft_expr_acct *acct = nft_expr_data(e);
+
+	NFT_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFT_EXPR_ACCT_NAME))
+		nft_buf_str(&b, type, acct->name, NAME);
+
+	return nft_buf_done(&b);
+}
+
+static int nft_rule_expr_acct_snprintf_default(char *buf, size_t size,
+					       struct nft_rule_expr *e)
+{
+	struct nft_expr_acct *acct = nft_expr_data(e);
+
+	return snprintf(buf, size, "%s", acct->name);
+}
+
+static int nft_rule_expr_acct_snprintf(char *buf, size_t len, uint32_t type,
+				       uint32_t flags, struct nft_rule_expr *e)
+{
+	switch (type) {
+	case NFT_OUTPUT_DEFAULT:
+		return nft_rule_expr_acct_snprintf_default(buf, len, e);
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
+		return nft_rule_expr_acct_export(buf, len, e, type);
+	default:
+		break;
+	}
+
+	return -1;
+}
+
+struct expr_ops expr_ops_acct = {
+	.name		= "acct",
+	.alloc_len	= sizeof(struct nft_expr_acct),
+	.max_attr	= NFTA_ACCT_EXPR_MAX,
+	.set		= nft_rule_expr_acct_set,
+	.get		= nft_rule_expr_acct_get,
+	.parse		= nft_rule_expr_acct_parse,
+	.build		= nft_rule_expr_acct_build,
+	.snprintf	= nft_rule_expr_acct_snprintf,
+	.xml_parse	= nft_rule_expr_acct_xml_parse,
+	.json_parse	= nft_rule_expr_acct_json_parse,
+};
+
+static void __init expr_acct_init(void)
+{
+	nft_expr_ops_register(&expr_ops_acct);
+}
diff --git a/src/libnftnl.map b/src/libnftnl.map
index be7b998..f81089d 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -226,4 +226,34 @@ LIBNFTNL_1.2 {
   nft_gen_nlmsg_parse;
   nft_gen_snprintf;
   nft_gen_fprintf;
+
+  nft_acct_alloc;
+  nft_acct_free;
+  nft_acct_attr_is_set;
+  nft_acct_attr_unset;
+  nft_acct_attr_set;
+  nft_acct_attr_get;
+  nft_acct_attr_set_u64;
+  nft_acct_attr_set_u32;
+  nft_acct_attr_set_str;
+  nft_acct_attr_get_u64;
+  nft_acct_attr_get_u32;
+  nft_acct_attr_get_str;
+  nft_acct_parse;
+  nft_acct_parse_file;
+  nft_acct_snprintf;
+  nft_acct_fprintf;
+  nft_acct_nlmsg_build_payload;
+  nft_acct_nlmsg_parse;
+  nft_acct_list_alloc;
+  nft_acct_list_free;
+  nft_acct_list_is_empty;
+  nft_acct_list_foreach;
+  nft_acct_list_add;
+  nft_acct_list_add_tail;
+  nft_acct_list_del;
+  nft_acct_list_iter_create;
+  nft_acct_list_iter_next;
+  nft_acct_list_iter_destroy;
+
 } LIBNFTNL_1.1;
-- 
1.7.10.4

