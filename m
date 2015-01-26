From: Ana Rey Botello <ana@soleta.eu>
Subject: [libnftnl v2 1/2] src: Add counters support
Date: Mon, 26 Jan 2015 20:43:28 +0100
Message-ID: <76536606a8f460752fdca9529361863b854f97a0.1422299705.git.ana@soleta.eu>
References: <cover.1422299627.git.ana@soleta.eu>
Cc: Ana Rey <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:47438 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbbAZTm4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:42:56 -0500
In-Reply-To: <cover.1422299627.git.ana@soleta.eu>
In-Reply-To: <cover.1422299705.git.ana@soleta.eu>
References: <cover.1422299705.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ana Rey <ana@soleta.eu>

This adds userspace support to counters: support to counter objects and
counter expression.

Moreover, this adds some examples to add/delete/get/reset the counter
object and add rules using an existing counter.

Example of how to use those examples:

* Add a new counter:
 # ./examples/nft-counter-add ip test counter1

 # ./examples/nft-counter-get ip test counter1 default
 table test family ip counter counter1 packet 0 bytes 0

 * Delete a counter:
 # ./examples/nft-counter-del ip test counter1

 * Add a rule using the counter expression.
 # ./examples/nft-rule-add ip test output

 * Reset the counter:
 # ./examples/nft-counter-reset ip test counter1

The kernel support is added in the commit:
netfilter: named counter: add support to counters in nftables

Signed-off-by: Ana Rey Botello <ana@soleta.eu>
---
 examples/Makefile.am                |   27 +-
 examples/nft-counter-add.c          |  140 ++++++++
 examples/nft-counter-del.c          |  135 +++++++
 examples/nft-counter-get.c          |  137 +++++++
 examples/nft-counter-reset.c        |  123 +++++++
 examples/nft-counters-get.c         |  136 +++++++
 examples/nft-rule-add.c             |    2 +-
 examples/nft-rule-counter-add.c     |  221 ++++++++++++
 examples/nft-rule-get.c             |    1 +
 include/buffer.h                    |    1 +
 include/libnftnl/Makefile.am        |    3 +-
 include/libnftnl/counter.h          |   97 +++++
 include/libnftnl/expr.h             |    1 +
 include/linux/netfilter/nf_tables.h |   33 ++
 src/Makefile.am                     |    1 +
 src/counter.c                       |  671 +++++++++++++++++++++++++++++++++++
 src/expr/counter.c                  |   48 ++-
 src/internal.h                      |    6 +
 src/libnftnl.map                    |   30 ++
 19 files changed, 1808 insertions(+), 5 deletions(-)
 create mode 100644 examples/nft-counter-add.c
 create mode 100644 examples/nft-counter-del.c
 create mode 100644 examples/nft-counter-get.c
 create mode 100644 examples/nft-counter-reset.c
 create mode 100644 examples/nft-counters-get.c
 create mode 100644 examples/nft-rule-counter-add.c
 create mode 100644 include/libnftnl/counter.h
 create mode 100644 src/counter.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index fafcb76..167680a 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -22,7 +22,14 @@ check_PROGRAMS = nft-table-add		\
 		 nft-set-elem-get	\
 		 nft-set-elem-del	\
 		 nft-ruleset-get	\
-		 nft-compat-get
+		 nft-compat-get		\
+		 nft-counter-add	\
+		 nft-counter-get	\
+		 nft-counters-get	\
+		 nft-counter-reset	\
+		 nft-rule-counter-add	\
+		 nft-counter-del
+
 
 nft_table_add_SOURCES = nft-table-add.c
 nft_table_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
@@ -92,3 +99,21 @@ nft_ruleset_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
 nft_compat_get_SOURCES = nft-compat-get.c
 nft_compat_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_counter_add_SOURCES = nft-counter-add.c
+nft_counter_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_counter_get_SOURCES = nft-counter-get.c
+nft_counter_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_counters_get_SOURCES = nft-counters-get.c
+nft_counters_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_counter_reset_SOURCES = nft-counter-reset.c
+nft_counter_reset_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_counter_del_SOURCES = nft-counter-del.c
+nft_counter_del_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_rule_counter_add_SOURCES = nft-rule-counter-add.c
+nft_rule_counter_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/examples/nft-counter-add.c b/examples/nft-counter-add.c
new file mode 100644
index 0000000..34af691
--- /dev/null
+++ b/examples/nft-counter-add.c
@@ -0,0 +1,140 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
+ * (C) 2014 Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2014 Intra2net AG <http://www.intra2net.com>
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
+#include <libnftnl/counter.h>
+
+static struct nft_counter *counter_add_parse(int argc, char *argv[])
+{
+	struct nft_counter *counter;
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
+	counter = nft_counter_alloc();
+	if (counter == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_NAME, argv[3]);
+	nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_TABLE, argv[2]);
+	nft_counter_attr_set_u32(counter, NFT_COUNTER_ATTR_FAMILY, family);
+	nft_counter_attr_set_u64(counter, NFT_COUNTER_ATTR_PKTS, 0);
+	nft_counter_attr_set_u64(counter, NFT_COUNTER_ATTR_BYTES, 0);
+
+	return counter;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq, counter_seq, family;
+	struct nft_counter *counter;
+	struct mnl_nlmsg_batch *batch;
+	int ret, batching;
+
+	if (argc != 4) {
+		fprintf(stderr, "%s <family> <table> <counter>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	counter = counter_add_parse(argc, argv);
+	if (counter == NULL)
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
+	counter_seq = seq;
+	family = nft_counter_attr_get_u32(counter, NFT_COUNTER_ATTR_FAMILY);
+	nlh = nft_counter_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				       NFT_MSG_NEWCOUNTER, family,
+				       NLM_F_CREATE|NLM_F_ACK, seq++);
+
+	nft_counter_nlmsg_build_payload(nlh, counter);
+	nft_counter_free(counter);
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
+		ret = mnl_cb_run(buf, ret, counter_seq, portid, NULL, NULL);
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
diff --git a/examples/nft-counter-del.c b/examples/nft-counter-del.c
new file mode 100644
index 0000000..38e68e7
--- /dev/null
+++ b/examples/nft-counter-del.c
@@ -0,0 +1,135 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
+ * (C) 2014 Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2014 Intra2net AG <http://www.intra2net.com>
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
+#include <libnftnl/counter.h>
+
+static struct nft_counter *counter_del_parse(int argc, char *argv[])
+{
+	struct nft_counter *counter;
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
+	counter = nft_counter_alloc();
+	if (counter == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_TABLE, argv[2]);
+	nft_counter_attr_set_u32(counter, NFT_COUNTER_ATTR_FAMILY, family);
+	nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_NAME, argv[3]);
+
+	return counter;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq, table_seq, family;
+	struct nft_counter *counter;
+	struct mnl_nlmsg_batch *batch;
+	int ret, batching;
+
+	if (argc != 4) {
+		fprintf(stderr, "%s <family> <table> <counter>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	counter = counter_del_parse(argc, argv);
+	if (counter == NULL)
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
+	family = nft_counter_attr_get_u32(counter, NFT_COUNTER_ATTR_FAMILY);
+	nlh = nft_counter_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				       NFT_MSG_DELCOUNTER, family,
+				       NLM_F_ACK, seq++);
+	nft_counter_nlmsg_build_payload(nlh, counter);
+	mnl_nlmsg_batch_next(batch);
+	nft_counter_free(counter);
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
diff --git a/examples/nft-counter-get.c b/examples/nft-counter-get.c
new file mode 100644
index 0000000..b30c8b2
--- /dev/null
+++ b/examples/nft-counter-get.c
@@ -0,0 +1,137 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
+ * (C) 2014 Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2014 Intra2net AG <http://www.intra2net.com>
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
+#include <libnftnl/counter.h>
+
+static int counter_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_counter *counter;
+	char buf[4096];
+	uint32_t *type = data;
+
+	counter = nft_counter_alloc();
+	if (counter == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nft_counter_nlmsg_parse(nlh, counter) < 0) {
+		perror("nft_counter_nlmsg_parse");
+		goto err_free;
+	}
+	nft_counter_snprintf(buf, sizeof(buf), counter, *type, 0);
+	printf("%s\n", buf);
+
+err_free:
+	nft_counter_free(counter);
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
+	struct nft_counter *counter = NULL;
+	int ret;
+	uint32_t type = NFT_OUTPUT_DEFAULT;
+
+	if (argc < 4 || argc > 5) {
+		fprintf(stderr,
+			"%s <family> <table> <counter> [<default|xml|json>]\n",
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
+	counter = nft_counter_alloc();
+	if (counter == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	seq = time(NULL);
+	nlh = nft_counter_nlmsg_build_hdr(buf, NFT_MSG_GETCOUNTER, family,
+					  NLM_F_ACK, seq);
+	nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_NAME, argv[3]);
+	nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_TABLE, argv[2]);
+	nft_counter_nlmsg_build_payload(nlh, counter);
+	nft_counter_free(counter);
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
+		ret = mnl_cb_run(buf, ret, seq, portid, counter_cb, &type);
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
diff --git a/examples/nft-counter-reset.c b/examples/nft-counter-reset.c
new file mode 100644
index 0000000..fc5775c
--- /dev/null
+++ b/examples/nft-counter-reset.c
@@ -0,0 +1,123 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
+ * (C) 2014 Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2014 Intra2net AG <http://www.intra2net.com>
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
+#include <libnftnl/counter.h>
+
+static int counter_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_counter *counter;
+
+	counter = nft_counter_alloc();
+	if (counter == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nft_counter_nlmsg_parse(nlh, counter) < 0) {
+		perror("nft_counter_nlmsg_parse");
+		goto err_free;
+	}
+err_free:
+	nft_counter_free(counter);
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
+	struct nft_counter *counter = NULL;
+	int ret;
+	uint32_t type = NFT_OUTPUT_DEFAULT;
+
+	if (argc != 4) {
+		fprintf(stderr,
+			"%s <family> <table> <counter>\n",
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
+	counter = nft_counter_alloc();
+	if (counter == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	seq = time(NULL);
+	nlh = nft_counter_nlmsg_build_hdr(buf, NFT_MSG_GETCOUNTER_ZERO, family,
+				       NLM_F_ACK, seq);
+	nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_NAME, argv[3]);
+	nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_TABLE, argv[2]);
+	nft_counter_nlmsg_build_payload(nlh, counter);
+	nft_counter_free(counter);
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
+		ret = mnl_cb_run(buf, ret, seq, portid, counter_cb, &type);
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
diff --git a/examples/nft-counters-get.c b/examples/nft-counters-get.c
new file mode 100644
index 0000000..b023325
--- /dev/null
+++ b/examples/nft-counters-get.c
@@ -0,0 +1,136 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
+ * (C) 2014 Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2014 Intra2net AG <http://www.intra2net.com>
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
+#include <libnftnl/counter.h>
+
+static int counter_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_counter *counter;
+	char buf[4096];
+	uint32_t *type = data;
+
+	counter = nft_counter_alloc();
+	if (counter == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nft_counter_nlmsg_parse(nlh, counter) < 0) {
+		perror("nft_counter_nlmsg_parse");
+		goto err_free;
+	}
+	nft_counter_snprintf(buf, sizeof(buf), counter, *type, 0);
+	printf("%s\n", buf);
+
+err_free:
+	nft_counter_free(counter);
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
+	struct nft_counter *counter = NULL;
+	int ret;
+	uint32_t type = NFT_OUTPUT_DEFAULT;
+
+	if (argc < 3 || argc > 4) {
+		fprintf(stderr,
+			"%s <family> <table> [<default|xml|json>]\n",
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
+	counter = nft_counter_alloc();
+	if (counter == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	seq = time(NULL);
+	nlh = nft_counter_nlmsg_build_hdr(buf, NFT_MSG_GETCOUNTER, family,
+					  NLM_F_DUMP | NLM_F_ACK, seq);
+	nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_TABLE, argv[2]);
+	nft_counter_nlmsg_build_payload(nlh, counter);
+	nft_counter_free(counter);
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
+		ret = mnl_cb_run(buf, ret, seq, portid, counter_cb, &type);
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
diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 6961d0d..f845c48 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -107,7 +107,7 @@ static struct nft_rule *setup_rule(uint8_t family, const char *table,
 		    offsetof(struct iphdr, protocol), sizeof(uint8_t));
 	add_cmp(r, NFT_REG_1, NFT_CMP_EQ, &proto, sizeof(uint8_t));
 
-	dport = htons(22);
+	dport = htons(80);
 	add_payload(r, NFT_PAYLOAD_TRANSPORT_HEADER, NFT_REG_1,
 		    offsetof(struct tcphdr, dest), sizeof(uint16_t));
 	add_cmp(r, NFT_REG_1, NFT_CMP_EQ, &dport, sizeof(uint16_t));
diff --git a/examples/nft-rule-counter-add.c b/examples/nft-rule-counter-add.c
new file mode 100644
index 0000000..6335102
--- /dev/null
+++ b/examples/nft-rule-counter-add.c
@@ -0,0 +1,221 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
+ * (C) 2014 Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2014 Intra2net AG <http://www.intra2net.com>
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
+static void add_counter(struct nft_rule *r)
+{
+	struct nft_rule_expr *e;
+
+	e = nft_rule_expr_alloc("counter");
+	if (e == NULL) {
+		perror("expr counter oom");
+		exit(EXIT_FAILURE);
+	}
+	nft_rule_expr_set_str(e, NFT_EXPR_CTR_NAME, "counter1");
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
+	add_counter(r);
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
index 2b497f2..aef7dbb 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -37,6 +37,7 @@ int nft_buf_reg(struct nft_buf *b, int type, union nft_data_reg *reg,
 #define BYTES			"bytes"
 #define CHAIN			"chain"
 #define CODE			"code"
+#define COUNTER			"counter"
 #define DATA			"data"
 #define DIR			"dir"
 #define DREG			"dreg"
diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile.am
index 010c01f..52051d0 100644
--- a/include/libnftnl/Makefile.am
+++ b/include/libnftnl/Makefile.am
@@ -5,4 +5,5 @@ pkginclude_HEADERS = table.h		\
 		     set.h		\
 		     ruleset.h		\
 		     common.h		\
-		     gen.h
+		     gen.h		\
+		     counter.h
diff --git a/include/libnftnl/counter.h b/include/libnftnl/counter.h
new file mode 100644
index 0000000..55118e8
--- /dev/null
+++ b/include/libnftnl/counter.h
@@ -0,0 +1,97 @@
+#ifndef _LIBNFTNL_COUNTER_H_
+#define _LIBNFTNL_COUNTER_H_
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
+struct nft_counter;
+
+struct nft_counter *nft_counter_alloc(void);
+void nft_counter_free(struct nft_counter *counter);
+
+enum {
+	NFT_COUNTER_ATTR_PKTS = 0,
+	NFT_COUNTER_ATTR_BYTES,
+	NFT_COUNTER_ATTR_NAME,
+	NFT_COUNTER_ATTR_TABLE,
+	NFT_COUNTER_ATTR_FAMILY,
+	NFT_COUNTER_ATTR_USE,
+	NFT_COUNTER_ATTR_ID,
+	__NFT_COUNTER_ATTR_MAX
+};
+#define NFT_COUNTER_ATTR_MAX (__NFT_COUNTER_ATTR_MAX - 1)
+
+bool nft_counter_attr_is_set(const struct nft_counter *counter, uint16_t attr);
+void nft_counter_attr_unset(struct nft_counter *counter, uint16_t attr);
+void nft_counter_attr_set(struct nft_counter *counter, uint16_t attr,
+			  const void *data);
+void nft_counter_attr_set_data(struct nft_counter *counter, uint16_t attr,
+			       const void *data, uint32_t data_len);
+const void *nft_counter_attr_get(struct nft_counter *counter, uint16_t attr);
+const void *nft_counter_attr_get_data(struct nft_counter *counter,
+				      uint16_t attr, uint64_t *data_len);
+
+void nft_counter_attr_set_u32(struct nft_counter *counter, uint16_t attr,
+			      uint32_t data);
+void nft_counter_attr_set_u64(struct nft_counter *counter, uint16_t attr,
+			      uint64_t data);
+void nft_counter_attr_set_str(struct nft_counter *counter, uint16_t attr,
+			      const char *str);
+uint32_t nft_counter_attr_get_u32(struct nft_counter *counter, uint16_t attr);
+uint64_t nft_counter_attr_get_u64(struct nft_counter *counter, uint16_t attr);
+const char *nft_counter_attr_get_str(struct nft_counter *counter,
+				     uint16_t attr);
+
+struct nlmsghdr;
+
+void nft_counter_nlmsg_build_payload(struct nlmsghdr *nlh,
+				     const struct nft_counter *counter);
+
+int nft_counter_parse(struct nft_counter *counter, enum nft_parse_type type,
+		      const char *data, struct nft_parse_err *err);
+int nft_counter_parse_file(struct nft_counter *counter,
+			   enum nft_parse_type type, FILE *fp,
+			   struct nft_parse_err *err);
+int nft_counter_snprintf(char *buf, size_t size, struct nft_counter *counter,
+			 uint32_t type, uint32_t flags);
+int nft_counter_fprintf(FILE *fp, struct nft_counter *counter, uint32_t type,
+			uint32_t flags);
+
+#define nft_counter_nlmsg_build_hdr	nft_nlmsg_build_hdr
+int nft_counter_nlmsg_parse(const struct nlmsghdr *nlh,
+			    struct nft_counter *counter);
+struct nft_counter_list;
+
+struct nft_counter_list *nft_counter_list_alloc(void);
+void nft_counter_list_free(struct nft_counter_list *list);
+int nft_counter_list_is_empty(struct nft_counter_list *list);
+int nft_counter_list_foreach(struct nft_counter_list *counter_list,
+			     int (*cb)(struct nft_counter *counter, void *data),
+			     void *data);
+void nft_counter_list_add(struct nft_counter *counter,
+			  struct nft_counter_list *list);
+void nft_counter_list_add_tail(struct nft_counter *counter,
+			       struct nft_counter_list *list);
+void nft_counter_list_del(struct nft_counter *counter);
+
+struct nft_counter_list_iter;
+
+struct nft_counter_list_iter *
+nft_counter_list_iter_create(struct nft_counter_list *l);
+struct nft_counter *
+nft_counter_list_iter_next(struct nft_counter_list_iter *iter);
+void nft_counter_list_iter_destroy(struct nft_counter_list_iter *iter);
+
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
+#endif /* _LIBNFTNL_COUNTER_H_ */
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 9f25993..263d37a 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -71,6 +71,7 @@ enum {
 enum {
 	NFT_EXPR_CTR_PACKETS	= NFT_RULE_EXPR_ATTR_BASE,
 	NFT_EXPR_CTR_BYTES,
+	NFT_EXPR_CTR_NAME,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 832bc46..5eeb60c 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -2,6 +2,7 @@
 #define _LINUX_NF_TABLES_H
 
 #define NFT_CHAIN_MAXNAMELEN	32
+#define NFT_CTR_MAXNAMELEN	16
 #define NFT_USERDATA_MAXLEN	256
 
 enum nft_registers {
@@ -53,6 +54,10 @@ enum nft_verdicts {
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
  * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
+ * @NFT_MSG_NEWCOUNTER: create a new counter (enum nft_counter_attributes)
+ * @NFT_MSG_GETCOUNTER: get a counter (enum nft_counter_attributes)
+ * @NFT_MSG_GETCOUNTER_ZERO: get a reset counter (enum nft_counter_attributes)
+ * @NFT_MSG_DELCOUNTER: delete a counter (enum nft_counter_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -72,6 +77,10 @@ enum nf_tables_msg_types {
 	NFT_MSG_DELSETELEM,
 	NFT_MSG_NEWGEN,
 	NFT_MSG_GETGEN,
+	NFT_MSG_NEWCOUNTER,
+	NFT_MSG_GETCOUNTER,
+	NFT_MSG_GETCOUNTER_ZERO,
+	NFT_MSG_DELCOUNTER,
 	NFT_MSG_MAX,
 };
 
@@ -695,16 +704,40 @@ enum nft_limit_attributes {
  *
  * @NFTA_COUNTER_BYTES: number of bytes (NLA_U64)
  * @NFTA_COUNTER_PACKETS: number of packets (NLA_U64)
+ * @NFTA_COUNTER_NAME: name of the counter (NLA_STRING)
  */
 enum nft_counter_attributes {
 	NFTA_COUNTER_UNSPEC,
 	NFTA_COUNTER_BYTES,
 	NFTA_COUNTER_PACKETS,
+	NFTA_COUNTER_NAME,
 	__NFTA_COUNTER_MAX
 };
 #define NFTA_COUNTER_MAX	(__NFTA_COUNTER_MAX - 1)
 
 /**
+ * enum nft_named_counter_attributes - nf_tables named counter netlink attributes
+ *
+ * @NFTA_NAMED_CTR_NAME: named counter name (NLA_STRING)
+ * @NFTA_NAMED_CTR_TABLE: table name (NLA_STRING)
+ * @NFTA_NAMED_CTR_USE: number of references to this named counter (NLA_U32)
+ * @NFTA_NAMED_CTR_ID: uniquely identifies a named counter in a transaction (NLA_U32)
+ * @NFTA_NAMED_CTR_BYTES: number of bytes (NLA_U64)
+ * @NFTA_NAMED_CTR_PACKETS: number of packets (NLA_U64)
+ */
+enum nft_named_counter_attributes {
+	NFTA_NAMED_CTR_UNSPEC,
+	NFTA_NAMED_CTR_NAME,
+	NFTA_NAMED_CTR_TABLE,
+	NFTA_NAMED_CTR_USE,
+	NFTA_NAMED_CTR_ID,
+	NFTA_NAMED_CTR_BYTES,
+	NFTA_NAMED_CTR_PACKETS,
+	__NFTA_NAMED_CTR_MAX
+};
+#define NFTA_NAMED_CTR_MAX	(__NFTA_NAMED_CTR_MAX - 1)
+
+/**
  * enum nft_log_attributes - nf_tables log expression netlink attributes
  *
  * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U32)
diff --git a/src/Makefile.am b/src/Makefile.am
index c77c3cc..934fa9b 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -8,6 +8,7 @@ libnftnl_la_LDFLAGS = -Wl,--version-script=$(srcdir)/libnftnl.map	\
 libnftnl_la_SOURCES = utils.c		\
 		      buffer.c		\
 		      common.c		\
+		      counter.c		\
 		      gen.c		\
 		      table.c		\
 		      chain.c		\
diff --git a/src/counter.c b/src/counter.c
new file mode 100644
index 0000000..1ee58ae
--- /dev/null
+++ b/src/counter.c
@@ -0,0 +1,671 @@
+/*
+ * (C) 2014 by Ana Rey Botello <ana@soleta.eu>
+ * (C) 2014 Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2014 Intra2net AG <http://www.intra2net.com>
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
+#include <libnftnl/counter.h>
+#include <buffer.h>
+
+struct nft_counter {
+	struct list_head	list;
+	const char              *name;
+	const char		*table;
+	uint32_t		family;
+	uint64_t		pkts;
+	uint64_t		bytes;
+	uint32_t		use;
+	uint32_t		flags;
+};
+
+struct nft_counter *nft_counter_alloc(void)
+{
+	struct nft_counter *counter;
+
+	counter = calloc(1, sizeof(struct nft_counter));
+	if (counter == NULL)
+		return NULL;
+
+	return counter;
+}
+EXPORT_SYMBOL(nft_counter_alloc);
+
+void nft_counter_free(struct nft_counter *counter)
+{
+	if (counter->name != NULL)
+		xfree(counter->name);
+	if (counter->table != NULL)
+		xfree(counter->table);
+
+	xfree(counter);
+}
+EXPORT_SYMBOL(nft_counter_free);
+
+bool nft_counter_attr_is_set(const struct nft_counter *counter, uint16_t attr)
+{
+	return counter->flags & (1 << attr);
+}
+EXPORT_SYMBOL(nft_counter_attr_is_set);
+
+void nft_counter_attr_unset(struct nft_counter *counter, uint16_t attr)
+{
+	if (!(counter->flags & (1 << attr)))
+		return;
+
+	switch (attr) {
+	case NFT_COUNTER_ATTR_NAME:
+		if (counter->name) {
+			xfree(counter->name);
+			counter->name = NULL;
+		}
+		break;
+	case NFT_COUNTER_ATTR_TABLE:
+		if (counter->table) {
+			xfree(counter->table);
+			counter->table = NULL;
+		}
+		break;
+	case NFT_COUNTER_ATTR_BYTES:
+	case NFT_COUNTER_ATTR_PKTS:
+	case NFT_COUNTER_ATTR_USE:
+	case NFT_COUNTER_ATTR_FAMILY:
+		break;
+	}
+	counter->flags &= ~(1 << attr);
+}
+EXPORT_SYMBOL(nft_counter_attr_unset);
+
+static uint32_t nft_counter_attr_validate[NFT_COUNTER_ATTR_MAX + 1] = {
+	[NFT_COUNTER_ATTR_BYTES]	= sizeof(uint64_t),
+	[NFT_COUNTER_ATTR_PKTS]		= sizeof(uint64_t),
+	[NFT_COUNTER_ATTR_FAMILY]	= sizeof(uint32_t),
+};
+
+void nft_counter_attr_set_data(struct nft_counter *counter, uint16_t attr,
+			       const void *data, uint32_t data_len)
+{
+	if (attr > NFT_COUNTER_ATTR_MAX)
+		return;
+
+	nft_assert_validate(data, nft_counter_attr_validate, attr, data_len);
+
+	switch (attr) {
+	case NFT_COUNTER_ATTR_NAME:
+		if (counter->name)
+			xfree(counter->name);
+
+		counter->name = strdup(data);
+		break;
+	case NFT_COUNTER_ATTR_TABLE:
+		if (counter->table)
+			xfree(counter->table);
+
+		counter->table = strdup(data);
+		break;
+	case NFT_COUNTER_ATTR_BYTES:
+		counter->bytes = *((uint64_t *)data);
+		break;
+	case NFT_COUNTER_ATTR_PKTS:
+		counter->pkts = *((uint64_t *)data);
+		break;
+	case NFT_COUNTER_ATTR_USE:
+		counter->use = *((uint32_t *)data);
+		break;
+	case NFT_COUNTER_ATTR_FAMILY:
+		counter->family = *((uint32_t *)data);
+		break;
+	}
+	counter->flags |= (1 << attr);
+}
+EXPORT_SYMBOL(nft_counter_attr_set_data);
+
+void nft_counter_attr_set(struct nft_counter *counter, uint16_t attr,
+			  const void *data)
+{
+	nft_counter_attr_set_data(counter, attr, data,
+				  nft_counter_attr_validate[attr]);
+}
+EXPORT_SYMBOL(nft_counter_attr_set);
+
+void nft_counter_attr_set_u64(struct nft_counter *counter, uint16_t attr,
+			      uint64_t val)
+{
+	nft_counter_attr_set_data(counter, attr, &val, sizeof(uint64_t));
+}
+EXPORT_SYMBOL(nft_counter_attr_set_u64);
+
+void nft_counter_attr_set_u32(struct nft_counter *counter, uint16_t attr,
+			      uint32_t val)
+{
+	nft_counter_attr_set_data(counter, attr, &val, sizeof(uint32_t));
+}
+EXPORT_SYMBOL(nft_counter_attr_set_u32);
+
+void nft_counter_attr_set_str(struct nft_counter *counter, uint16_t attr,
+			      const char *str)
+{
+	nft_counter_attr_set_data(counter, attr, str, 0);
+}
+EXPORT_SYMBOL(nft_counter_attr_set_str);
+
+const void *nft_counter_attr_get_data(struct nft_counter *counter,
+				      uint16_t attr, uint64_t *data_len)
+{
+	if (!(counter->flags & (1 << attr)))
+		return NULL;
+
+	switch (attr) {
+	case NFT_COUNTER_ATTR_NAME:
+		return counter->name;
+	case NFT_COUNTER_ATTR_TABLE:
+		return counter->table;
+	case NFT_COUNTER_ATTR_BYTES:
+		*data_len = sizeof(uint64_t);
+		return &counter->bytes;
+	case NFT_COUNTER_ATTR_PKTS:
+		*data_len = sizeof(uint64_t);
+		return &counter->pkts;
+	case NFT_COUNTER_ATTR_FAMILY:
+		*data_len = sizeof(uint32_t);
+		return &counter->family;
+	case NFT_COUNTER_ATTR_USE:
+		*data_len = sizeof(uint32_t);
+		return &counter->use;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(nft_counter_attr_get_data);
+
+const void *nft_counter_attr_get(struct nft_counter *counter, uint16_t attr)
+{
+	uint64_t data_len;
+
+	return nft_counter_attr_get_data(counter, attr, &data_len);
+}
+EXPORT_SYMBOL(nft_counter_attr_get);
+
+uint64_t nft_counter_attr_get_u64(struct nft_counter *counter, uint16_t attr)
+{
+	const void *ret = nft_counter_attr_get(counter, attr);
+
+	return ret == NULL ? 0 : *((uint64_t *)ret);
+}
+EXPORT_SYMBOL(nft_counter_attr_get_u64);
+
+uint32_t nft_counter_attr_get_u32(struct nft_counter *counter, uint16_t attr)
+{
+	const void *ret = nft_counter_attr_get(counter, attr);
+
+	return ret == NULL ? 0 : *((uint32_t *)ret);
+}
+EXPORT_SYMBOL(nft_counter_attr_get_u32);
+
+const char *nft_counter_attr_get_str(struct nft_counter *counter, uint16_t attr)
+{
+	return nft_counter_attr_get(counter, attr);
+}
+EXPORT_SYMBOL(nft_counter_attr_get_str);
+
+void nft_counter_nlmsg_build_payload(struct nlmsghdr *nlh,
+				  const struct nft_counter *counter)
+{
+	if (counter->flags & (1 << NFT_COUNTER_ATTR_NAME))
+		mnl_attr_put_strz(nlh, NFTA_NAMED_CTR_NAME, counter->name);
+	if (counter->flags & (1 << NFT_COUNTER_ATTR_TABLE))
+		mnl_attr_put_strz(nlh, NFTA_NAMED_CTR_TABLE, counter->table);
+	if (counter->flags & (1 << NFT_COUNTER_ATTR_BYTES)) {
+		mnl_attr_put_u64(nlh, NFTA_NAMED_CTR_BYTES,
+				 htobe64(counter->bytes));
+	}
+	if (counter->flags & (1 << NFT_COUNTER_ATTR_PKTS)) {
+		mnl_attr_put_u64(nlh, NFTA_NAMED_CTR_PACKETS,
+				 htobe64(counter->pkts));
+	}
+}
+EXPORT_SYMBOL(nft_counter_nlmsg_build_payload);
+
+static int nft_counter_parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_NAMED_CTR_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_NAMED_CTR_NAME:
+	case NFTA_NAMED_CTR_TABLE:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	case NFTA_NAMED_CTR_BYTES:
+	case NFTA_NAMED_CTR_PACKETS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
+	case NFTA_NAMED_CTR_USE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+int nft_counter_nlmsg_parse(const struct nlmsghdr *nlh,
+			    struct nft_counter *counter)
+{
+	struct nlattr *tb[NFTA_NAMED_CTR_MAX + 1] = {};
+	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
+
+	if (mnl_attr_parse(nlh, sizeof(*nfg), nft_counter_parse_attr_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_NAMED_CTR_NAME]) {
+		counter->name =
+			strdup(mnl_attr_get_str(tb[NFTA_NAMED_CTR_NAME]));
+		counter->flags |= (1 << NFT_COUNTER_ATTR_NAME);
+	}
+	if (tb[NFTA_NAMED_CTR_TABLE]) {
+		counter->table =
+			strdup(mnl_attr_get_str(tb[NFTA_NAMED_CTR_TABLE]));
+		counter->flags |= (1 << NFT_COUNTER_ATTR_TABLE);
+	}
+	if (tb[NFTA_NAMED_CTR_BYTES]) {
+		counter->bytes =
+			 be64toh(mnl_attr_get_u64(tb[NFTA_NAMED_CTR_BYTES]));
+		counter->flags |= (1 << NFT_COUNTER_ATTR_BYTES);
+	}
+	if (tb[NFTA_NAMED_CTR_PACKETS]) {
+		counter->pkts =
+			 be64toh(mnl_attr_get_u64(tb[NFTA_NAMED_CTR_PACKETS]));
+		counter->flags |= (1 << NFT_COUNTER_ATTR_PKTS);
+	}
+	if (tb[NFTA_NAMED_CTR_USE]) {
+		counter->use = ntohl(mnl_attr_get_u32(tb[NFTA_TABLE_USE]));
+		counter->flags |= (1 << NFT_COUNTER_ATTR_USE);
+	}
+
+	counter->family = nfg->nfgen_family;
+	counter->flags |= (1 << NFT_COUNTER_ATTR_FAMILY);
+
+	return 0;
+}
+EXPORT_SYMBOL(nft_counter_nlmsg_parse);
+
+#ifdef XML_PARSING
+int nft_mxml_counter_parse(mxml_node_t *tree, struct nft_counter *counter,
+			   struct nft_parse_err *err)
+{
+	const char *name, *table;
+	uint64_t pkts, bytes;
+	uint32_t family, use;
+
+	name = nft_mxml_str_parse(tree, "counter", MXML_DESCEND_FIRST,
+				  NFT_XML_MAND, err);
+	if (name != NULL)
+		nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_NAME, name);
+
+	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
+				  NFT_XML_MAND, err);
+	if (table != NULL) {
+		nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_TABLE,
+					 table);
+	}
+	if (nft_mxml_num_parse(tree, "family", MXML_DESCEND, BASE_DEC,
+			       &family, NFT_TYPE_U32, NFT_XML_MAND,
+			       err) == 0) {
+		nft_counter_attr_set_u32(counter, NFT_COUNTER_ATTR_FAMILY,
+					 family);
+	}
+
+	if (nft_mxml_num_parse(tree, "pkts", MXML_DESCEND, BASE_DEC,
+			       &pkts, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
+		nft_counter_attr_set_u64(counter, NFT_COUNTER_ATTR_PKTS, pkts);
+
+	if (nft_mxml_num_parse(tree, "bytes", MXML_DESCEND, BASE_DEC,
+			       &bytes, NFT_TYPE_U64, NFT_XML_MAND, err) == 0) {
+		nft_counter_attr_set_u64(counter, NFT_COUNTER_ATTR_BYTES,
+					 bytes);
+	}
+	if (nft_mxml_num_parse(tree, "use", MXML_DESCEND, BASE_DEC,
+			       &use, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_counter_attr_set_u32(counter, NFT_COUNTER_ATTR_USE, use);
+
+
+	return 0;
+}
+#endif
+
+static int nft_counter_xml_parse(struct nft_counter *counter, const void *data,
+				 struct nft_parse_err *err,
+				 enum nft_parse_input input)
+{
+#ifdef XML_PARSING
+	int ret;
+	mxml_node_t *tree = nft_mxml_build_tree(data, "counter", err, input);
+
+	if (tree == NULL)
+		return -1;
+
+	ret = nft_mxml_counter_parse(tree, counter, err);
+	mxmlDelete(tree);
+	return ret;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+#ifdef JSON_PARSING
+int nft_jansson_parse_counter(struct nft_counter *counter, json_t *tree,
+			      struct nft_parse_err *err)
+{
+	json_t *root;
+	const char *name, *table;
+	uint64_t bytes, pkts;
+	uint32_t family, use;
+
+	root = nft_jansson_get_node(tree, "counter", err);
+	if (root == NULL)
+		return -1;
+
+	name = nft_jansson_parse_str(root, "name", err);
+	if (name != NULL)
+		nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_NAME, name);
+
+	table = nft_jansson_parse_str(root, "table", err);
+	if (table != NULL)
+		nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_TABLE, table);
+
+	if (nft_jansson_parse_val(root, "family", NFT_TYPE_U32, &family,
+				  err) == 0)
+		nft_counter_attr_set_u32(counter, NFT_COUNTER_ATTR_PKTS, family);
+
+	if (nft_jansson_parse_val(root, "pkts", NFT_TYPE_U64, &pkts, err) == 0)
+		nft_counter_attr_set_u64(counter, NFT_COUNTER_ATTR_PKTS, pkts);
+
+	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &bytes,
+				  err) == 0)
+		nft_counter_attr_set_u64(counter, NFT_COUNTER_ATTR_BYTES, bytes);
+
+	if (nft_jansson_parse_val(root, "use", NFT_TYPE_U32, &use,
+				  err) == 0)
+		nft_counter_attr_set_u32(counter, NFT_COUNTER_ATTR_USE, use);
+
+	return 0;
+}
+#endif
+
+static int nft_counter_json_parse(struct nft_counter *counter, const void *json,
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
+	ret = nft_jansson_parse_counter(counter, tree, err);
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
+static int nft_counter_do_parse(struct nft_counter *counter,
+				enum nft_parse_type type, const void *data,
+				struct nft_parse_err *err,
+				enum nft_parse_input input)
+{
+	int ret;
+	struct nft_parse_err perr;
+
+	switch (type) {
+	case NFT_PARSE_XML:
+		ret = nft_counter_xml_parse(counter, data, &perr, input);
+		break;
+	case NFT_PARSE_JSON:
+		ret = nft_counter_json_parse(counter, data, &perr, input);
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
+int nft_counter_parse(struct nft_counter *counter, enum nft_parse_type type,
+		      const char *data, struct nft_parse_err *err)
+{
+	return nft_counter_do_parse(counter, type, data, err, NFT_PARSE_BUFFER);
+}
+EXPORT_SYMBOL(nft_counter_parse);
+
+int nft_counter_parse_file(struct nft_counter *counter,
+			   enum nft_parse_type type, FILE *fp,
+			   struct nft_parse_err *err)
+{
+	return nft_counter_do_parse(counter, type, fp, err, NFT_PARSE_FILE);
+}
+EXPORT_SYMBOL(nft_counter_parse_file);
+
+static int nft_counter_export(char *buf, size_t size,
+			      struct nft_counter *counter, int type)
+{
+	NFT_BUF_INIT(b, buf, size);
+	nft_buf_open(&b, type, COUNTER);
+
+	if (counter->flags & (1 << NFT_COUNTER_ATTR_NAME))
+		nft_buf_str(&b, type, counter->name, NAME);
+	if (counter->flags & (1 << NFT_COUNTER_ATTR_TABLE))
+		nft_buf_str(&b, type, counter->table, TABLE);
+	if (counter->flags & (1 << NFT_COUNTER_ATTR_FAMILY))
+		nft_buf_str(&b, type, nft_family2str(counter->family), FAMILY);
+	if (counter->flags & (1 << NFT_COUNTER_ATTR_PKTS))
+		nft_buf_u64(&b, type, counter->pkts, PACKETS);
+	if (counter->flags & (1 << NFT_COUNTER_ATTR_BYTES))
+		nft_buf_u64(&b, type, counter->bytes, BYTES);
+	if (counter->flags & (1 << NFT_COUNTER_ATTR_USE))
+		nft_buf_u32(&b, type, counter->use, USE);
+	nft_buf_close(&b, type, COUNTER);
+
+	return nft_buf_done(&b);
+}
+
+static int nft_counter_snprintf_default(char *buf, size_t size,
+					struct nft_counter *counter)
+{
+	return snprintf(buf, size,
+			"table %s family %s counter %s packet %"PRIu64" bytes %"PRIu64" use %d",
+			counter->table,
+			nft_family2str(counter->family),
+			counter->name,
+			counter->pkts,
+			counter->bytes,
+			counter->use);
+}
+
+int nft_counter_snprintf(char *buf, size_t len, struct nft_counter *counter,
+		       uint32_t type, uint32_t flags)
+{
+	switch (type) {
+	case NFT_OUTPUT_DEFAULT:
+		return nft_counter_snprintf_default(buf, len, counter);
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
+		return  nft_counter_export(buf, len, counter, type);
+	default:
+		break;
+	}
+	return -1;
+}
+EXPORT_SYMBOL(nft_counter_snprintf);
+
+static int nft_counter_do_snprintf(char *buf, size_t size, void *counter,
+				   uint32_t type, uint32_t flags)
+{
+	return nft_counter_snprintf(buf, size, counter, type, flags);
+}
+
+int nft_counter_fprintf(FILE *fp, struct nft_counter *counter, uint32_t type,
+			uint32_t flags)
+{
+	return nft_fprintf(fp, counter, type, flags, nft_counter_do_snprintf);
+}
+EXPORT_SYMBOL(nft_counter_fprintf);
+
+struct nft_counter_list {
+	struct list_head list;
+};
+
+struct nft_counter_list *nft_counter_list_alloc(void)
+{
+	struct nft_counter_list *list;
+
+	list = calloc(1, sizeof(struct nft_counter_list));
+	if (list == NULL)
+		return NULL;
+
+	INIT_LIST_HEAD(&list->list);
+
+	return list;
+}
+EXPORT_SYMBOL(nft_counter_list_alloc);
+
+void nft_counter_list_free(struct nft_counter_list *list)
+{
+	struct nft_counter *counter, *tmp;
+
+	list_for_each_entry_safe(counter, tmp, &list->list, list) {
+		list_del(&counter->list);
+		nft_counter_free(counter);
+	}
+	xfree(list);
+}
+EXPORT_SYMBOL(nft_counter_list_free);
+
+int nft_counter_list_is_empty(struct nft_counter_list *list)
+{
+	return list_empty(&list->list);
+}
+EXPORT_SYMBOL(nft_counter_list_is_empty);
+
+void nft_counter_list_add(struct nft_counter *counter,
+			  struct nft_counter_list *list)
+{
+	list_add(&counter->list, &list->list);
+}
+EXPORT_SYMBOL(nft_counter_list_add);
+
+void nft_counter_list_add_tail(struct nft_counter *counter,
+			       struct nft_counter_list *list)
+{
+	list_add_tail(&counter->list, &list->list);
+}
+EXPORT_SYMBOL(nft_counter_list_add_tail);
+
+void nft_counter_list_del(struct nft_counter *counter)
+{
+	list_del(&counter->list);
+}
+EXPORT_SYMBOL(nft_counter_list_del);
+
+int nft_counter_list_foreach(struct nft_counter_list *counter_list,
+			  int (*cb)(struct nft_counter *counter, void *data),
+			  void *data)
+{
+	struct nft_counter *cur, *tmp;
+	int ret;
+
+	list_for_each_entry_safe(cur, tmp, &counter_list->list, list) {
+		ret = cb(cur, data);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(nft_counter_list_foreach);
+
+struct nft_counter_list_iter {
+	struct nft_counter_list	*list;
+	struct nft_counter	*cur;
+};
+
+struct nft_counter_list_iter *
+nft_counter_list_iter_create(struct nft_counter_list *l)
+{
+	struct nft_counter_list_iter *iter;
+
+	iter = calloc(1, sizeof(struct nft_counter_list_iter));
+	if (iter == NULL)
+		return NULL;
+
+	iter->list = l;
+	if (nft_counter_list_is_empty(l))
+		iter->cur = NULL;
+	else
+		iter->cur = list_entry(l->list.next, struct nft_counter, list);
+
+	return iter;
+}
+EXPORT_SYMBOL(nft_counter_list_iter_create);
+
+struct nft_counter *
+nft_counter_list_iter_next(struct nft_counter_list_iter *iter)
+{
+	struct nft_counter *counter = iter->cur;
+
+	if (!counter)
+		return NULL;
+
+	iter->cur = list_entry(iter->cur->list.next, struct nft_counter, list);
+	if (&iter->cur->list == iter->list->list.next)
+		return NULL;
+
+	return counter;
+}
+EXPORT_SYMBOL(nft_counter_list_iter_next);
+
+void nft_counter_list_iter_destroy(struct nft_counter_list_iter *iter)
+{
+	xfree(iter);
+}
+EXPORT_SYMBOL(nft_counter_list_iter_destroy);
diff --git a/src/expr/counter.c b/src/expr/counter.c
index e9abc5b..7d9a7bc 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -27,6 +27,7 @@
 struct nft_expr_counter {
 	uint64_t	pkts;
 	uint64_t	bytes;
+	const char	*name;
 };
 
 static int
@@ -42,6 +43,11 @@ nft_rule_expr_counter_set(struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_CTR_PACKETS:
 		ctr->pkts = *((uint64_t *)data);
 		break;
+	case NFT_EXPR_CTR_NAME:
+		if (ctr->name)
+			xfree(ctr->name);
+		ctr->name = strdup(data);
+		break;
 	default:
 		return -1;
 	}
@@ -61,6 +67,9 @@ nft_rule_expr_counter_get(const struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_CTR_PACKETS:
 		*data_len = sizeof(ctr->pkts);
 		return &ctr->pkts;
+	case NFT_EXPR_CTR_NAME:
+		*data_len = sizeof(ctr->name);
+		return ctr->name;
 	}
 	return NULL;
 }
@@ -79,6 +88,10 @@ static int nft_rule_expr_counter_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
 			abi_breakage();
 		break;
+	case NFTA_COUNTER_NAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -94,6 +107,8 @@ nft_rule_expr_counter_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 		mnl_attr_put_u64(nlh, NFTA_COUNTER_BYTES, htobe64(ctr->bytes));
 	if (e->flags & (1 << NFT_EXPR_CTR_PACKETS))
 		mnl_attr_put_u64(nlh, NFTA_COUNTER_PACKETS, htobe64(ctr->pkts));
+	if (e->flags & (1 << NFT_EXPR_CTR_NAME))
+		mnl_attr_put_strz(nlh, NFTA_COUNTER_NAME, ctr->name);
 }
 
 static int
@@ -113,6 +128,12 @@ nft_rule_expr_counter_parse(struct nft_rule_expr *e, struct nlattr *attr)
 		ctr->pkts = be64toh(mnl_attr_get_u64(tb[NFTA_COUNTER_PACKETS]));
 		e->flags |= (1 << NFT_EXPR_CTR_PACKETS);
 	}
+	if (tb[NFTA_COUNTER_NAME]) {
+		if (ctr->name)
+			xfree(ctr->name);
+		ctr->name = strdup(mnl_attr_get_str(tb[NFTA_COUNTER_NAME]));
+		e->flags |= (1 << NFT_EXPR_CTR_NAME);
+	}
 
 	return 0;
 }
@@ -123,6 +144,7 @@ nft_rule_expr_counter_json_parse(struct nft_rule_expr *e, json_t *root,
 {
 #ifdef JSON_PARSING
 	uint64_t uval64;
+	const char *counter_name;
 
 	if (nft_jansson_parse_val(root, "pkts", NFT_TYPE_U64, &uval64,
 				  err) == 0)
@@ -132,6 +154,10 @@ nft_rule_expr_counter_json_parse(struct nft_rule_expr *e, json_t *root,
 				  err) == 0)
 		nft_rule_expr_set_u64(e, NFT_EXPR_CTR_BYTES, uval64);
 
+	counter_name = nft_jansson_parse_str(root, "name", err);
+	if (counter_name != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_CTR_NAME, counter_name);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -145,6 +171,7 @@ nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 {
 #ifdef XML_PARSING
 	uint64_t pkts, bytes;
+	const char *counter_name;
 
 	if (nft_mxml_num_parse(tree, "pkts", MXML_DESCEND_FIRST, BASE_DEC,
 			       &pkts, NFT_TYPE_U64, NFT_XML_MAND,  err) == 0)
@@ -154,6 +181,12 @@ nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 			       &bytes, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
 		nft_rule_expr_set_u64(e, NFT_EXPR_CTR_BYTES, bytes);
 
+	counter_name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
+				  NFT_XML_MAND, err);
+
+	if (counter_name != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_CTR_NAME, counter_name);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -161,6 +194,7 @@ nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
+
 static int nft_rule_expr_counter_export(char *buf, size_t size,
 					struct nft_rule_expr *e, int type)
 {
@@ -171,6 +205,8 @@ static int nft_rule_expr_counter_export(char *buf, size_t size,
 		nft_buf_u64(&b, type, ctr->pkts, PKTS);
 	if (e->flags & (1 << NFT_EXPR_CTR_BYTES))
 		nft_buf_u64(&b, type, ctr->bytes, BYTES);
+	if (e->flags & (1 << NFT_EXPR_CTR_NAME))
+		nft_buf_str(&b, type, ctr->name, NAME);
 
 	return nft_buf_done(&b);
 }
@@ -179,9 +215,17 @@ static int nft_rule_expr_counter_snprintf_default(char *buf, size_t len,
 						  struct nft_rule_expr *e)
 {
 	struct nft_expr_counter *ctr = nft_expr_data(e);
+	int size = len, offset = 0, ret = 0;
+
+	if (e->flags & (1 << NFT_EXPR_CTR_NAME)) {
+		ret = snprintf(buf, len, "%s ", ctr->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	ret = snprintf(buf + offset, len, "pkts %"PRIu64" bytes %"PRIu64" ",
+		       ctr->pkts, ctr->bytes);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	return snprintf(buf, len, "pkts %"PRIu64" bytes %"PRIu64" ",
-			ctr->pkts, ctr->bytes);
+	return offset;
 }
 
 static int nft_rule_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
diff --git a/src/internal.h b/src/internal.h
index db9af11..4d32ea3 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -90,6 +90,9 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
 struct nft_set;
 int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
 		       struct nft_parse_err *err);
+struct nft_counter;
+int nft_mxml_counter_parse(mxml_node_t *tree, struct nft_counter *counter,
+			   struct nft_parse_err *err);
 #endif
 
 struct nft_set_list;
@@ -139,6 +142,9 @@ int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
 struct nft_set;
 int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 			  struct nft_parse_err *err);
+struct nft_counter;
+int nft_jansson_parse_counter(struct nft_counter *counter, json_t *tree,
+			      struct nft_parse_err *err);
 #endif
 
 const char *nft_family2str(uint32_t family);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index be7b998..3f3a9e9 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -226,4 +226,34 @@ LIBNFTNL_1.2 {
   nft_gen_nlmsg_parse;
   nft_gen_snprintf;
   nft_gen_fprintf;
+
+  nft_counter_alloc;
+  nft_counter_free;
+  nft_counter_attr_is_set;
+  nft_counter_attr_unset;
+  nft_counter_attr_set;
+  nft_counter_attr_get;
+  nft_counter_attr_set_u64;
+  nft_counter_attr_set_u32;
+  nft_counter_attr_set_str;
+  nft_counter_attr_get_u64;
+  nft_counter_attr_get_u32;
+  nft_counter_attr_get_str;
+  nft_counter_parse;
+  nft_counter_parse_file;
+  nft_counter_snprintf;
+  nft_counter_fprintf;
+  nft_counter_nlmsg_build_payload;
+  nft_counter_nlmsg_parse;
+  nft_counter_list_alloc;
+  nft_counter_list_free;
+  nft_counter_list_is_empty;
+  nft_counter_list_foreach;
+  nft_counter_list_add;
+  nft_counter_list_add_tail;
+  nft_counter_list_del;
+  nft_counter_list_iter_create;
+  nft_counter_list_iter_next;
+  nft_counter_list_iter_destroy;
+
 } LIBNFTNL_1.1;
-- 
1.7.10.4

