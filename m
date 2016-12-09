From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 2/7] src: support for stateful objects
Date: Fri,  9 Dec 2016 14:31:54 +0100
Message-ID: <1481290319-10156-2-git-send-email-pablo@netfilter.org>
References: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35560 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753574AbcLINcM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2016 08:32:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AD3B996ECD
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7EBA7524C4
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70890524C6
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:03 +0100 (CET)
In-Reply-To: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows you to add, to delete and to get stateful objects,
this support two object types: counter and quota.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/Makefile.am         |  12 +
 examples/nft-obj-add.c       | 123 ++++++++++
 examples/nft-obj-del.c       | 126 ++++++++++
 examples/nft-obj-get.c       | 151 ++++++++++++
 include/Makefile.am          |   1 +
 include/buffer.h             |   1 +
 include/libnftnl/Makefile.am |   1 +
 include/libnftnl/object.h    |  89 +++++++
 include/obj.h                |  55 +++++
 src/Makefile.am              |   3 +
 src/libnftnl.map             |  31 +++
 src/obj/counter.c            | 184 ++++++++++++++
 src/obj/quota.c              | 205 ++++++++++++++++
 src/object.c                 | 573 +++++++++++++++++++++++++++++++++++++++++++
 tests/Makefile.am            |   4 +
 tests/nft-object-test.c      |  78 ++++++
 tests/test-script.sh         |   1 +
 17 files changed, 1638 insertions(+)
 create mode 100644 examples/nft-obj-add.c
 create mode 100644 examples/nft-obj-del.c
 create mode 100644 examples/nft-obj-get.c
 create mode 100644 include/libnftnl/object.h
 create mode 100644 include/obj.h
 create mode 100644 src/obj/counter.c
 create mode 100644 src/obj/quota.c
 create mode 100644 src/object.c
 create mode 100644 tests/nft-object-test.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index 9dca3a15c2c4..48bc7a16c9c6 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -22,6 +22,9 @@ check_PROGRAMS = nft-table-add		\
 		 nft-set-elem-add	\
 		 nft-set-elem-get	\
 		 nft-set-elem-del	\
+		 nft-obj-add		\
+		 nft-obj-get		\
+		 nft-obj-del		\
 		 nft-ruleset-get	\
 		 nft-ruleset-parse-file	\
 		 nft-compat-get
@@ -92,6 +95,15 @@ nft_set_elem_del_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_set_elem_get_SOURCES = nft-set-elem-get.c
 nft_set_elem_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_obj_add_SOURCES = nft-obj-add.c
+nft_obj_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_obj_del_SOURCES = nft-obj-del.c
+nft_obj_del_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_obj_get_SOURCES = nft-obj-get.c
+nft_obj_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_ruleset_get_SOURCES = nft-ruleset-get.c
 nft_ruleset_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
diff --git a/examples/nft-obj-add.c b/examples/nft-obj-add.c
new file mode 100644
index 000000000000..83941c41323f
--- /dev/null
+++ b/examples/nft-obj-add.c
@@ -0,0 +1,123 @@
+/*
+ * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
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
+#include <libnftnl/object.h>
+
+static struct nftnl_obj *obj_add_parse(int argc, char *argv[])
+{
+	struct nftnl_obj *t;
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
+	t = nftnl_obj_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	nftnl_obj_set_u32(t, NFTNL_OBJ_FAMILY, family);
+	nftnl_obj_set_u32(t, NFTNL_OBJ_TYPE, NFT_OBJECT_COUNTER);
+	nftnl_obj_set_str(t, NFTNL_OBJ_TABLE, argv[2]);
+	nftnl_obj_set_str(t, NFTNL_OBJ_NAME, argv[3]);
+
+	return t;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq, obj_seq, family;
+	struct nftnl_obj *t;
+	struct mnl_nlmsg_batch *batch;
+	int ret;
+
+	if (argc != 4) {
+		fprintf(stderr, "%s <family> <table> <name>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	t = obj_add_parse(argc, argv);
+	if (t == NULL)
+		exit(EXIT_FAILURE);
+
+	seq = time(NULL);
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	obj_seq = seq;
+	family = nftnl_obj_get_u32(t, NFTNL_OBJ_FAMILY);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWOBJ, family, NLM_F_ACK, seq++);
+	nftnl_obj_nlmsg_build_payload(nlh, t);
+	nftnl_obj_free(t);
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
+		ret = mnl_cb_run(buf, ret, obj_seq, portid, NULL, NULL);
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
diff --git a/examples/nft-obj-del.c b/examples/nft-obj-del.c
new file mode 100644
index 000000000000..0aa63c0c4742
--- /dev/null
+++ b/examples/nft-obj-del.c
@@ -0,0 +1,126 @@
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
+#include <netinet/in.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/object.h>
+
+static struct nftnl_obj *obj_del_parse(int argc, char *argv[])
+{
+	struct nftnl_obj *t;
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
+	t = nftnl_obj_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	nftnl_obj_set_str(t, NFTNL_OBJ_TABLE, argv[2]);
+	nftnl_obj_set_str(t, NFTNL_OBJ_NAME, argv[3]);
+	nftnl_obj_set_u32(t, NFTNL_OBJ_TYPE, NFT_OBJECT_COUNTER);
+	nftnl_obj_set_u32(t, NFTNL_OBJ_FAMILY, family);
+
+	return t;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq, obj_seq, family;
+	struct nftnl_obj *t;
+	struct mnl_nlmsg_batch *batch;
+	int ret;
+
+	if (argc != 4) {
+		fprintf(stderr, "%s <family> <table> <name>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	t = obj_del_parse(argc, argv);
+	if (t == NULL)
+		exit(EXIT_FAILURE);
+
+	seq = time(NULL);
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	obj_seq = seq;
+	family = nftnl_obj_get_u32(t, NFTNL_OBJ_FAMILY);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_DELOBJ, family, NLM_F_ACK,
+				    seq++);
+	nftnl_obj_nlmsg_build_payload(nlh, t);
+	mnl_nlmsg_batch_next(batch);
+	nftnl_obj_free(t);
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
+		ret = mnl_cb_run(buf, ret, obj_seq, portid, NULL, NULL);
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
diff --git a/examples/nft-obj-get.c b/examples/nft-obj-get.c
new file mode 100644
index 000000000000..bec33b693731
--- /dev/null
+++ b/examples/nft-obj-get.c
@@ -0,0 +1,151 @@
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
+#include <netinet/in.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/object.h>
+
+static int obj_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nftnl_obj *t;
+	char buf[4096];
+	uint32_t *type = data;
+
+	t = nftnl_obj_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nftnl_obj_nlmsg_parse(nlh, t) < 0) {
+		perror("nftnl_obj_nlmsg_parse");
+		goto err_free;
+	}
+
+	nftnl_obj_snprintf(buf, sizeof(buf), t, *type, 0);
+	printf("%s\n", buf);
+
+err_free:
+	nftnl_obj_free(t);
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
+	struct nftnl_obj *t = NULL;
+	int ret;
+	uint32_t type = NFTNL_OUTPUT_DEFAULT;
+
+	if (argc < 2 || argc > 5) {
+		fprintf(stderr, "%s <family> <table> [<obj>] [<default|xml|json>]\n",
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
+		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp, unspec\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (strcmp(argv[argc-1], "xml") == 0) {
+		type = NFTNL_OUTPUT_XML;
+		argv[argc-1] = NULL;
+		argc--;
+	}else if (strcmp(argv[argc-1], "json") == 0) {
+		type = NFTNL_OUTPUT_JSON;
+		argv[argc-1] = NULL;
+		argc--;
+	} else if (strcmp(argv[argc - 1], "default") == 0) {
+		argc--;
+	}
+
+	if (argc == 3 || argc == 4) {
+		t = nftnl_obj_alloc();
+		if (t == NULL) {
+			perror("OOM");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	seq = time(NULL);
+	if (argc < 4) {
+		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETOBJ, family,
+					    NLM_F_DUMP, seq);
+		if (argc == 3) {
+			nftnl_obj_set(t, NFTNL_OBJ_TABLE, argv[2]);
+			nftnl_obj_nlmsg_build_payload(nlh, t);
+			nftnl_obj_free(t);
+		}
+	} else {
+		nftnl_obj_set(t, NFTNL_OBJ_TABLE, argv[2]);
+		nftnl_obj_set(t, NFTNL_OBJ_NAME, argv[3]);
+		nftnl_obj_set_u32(t, NFTNL_OBJ_TYPE, NFT_OBJECT_COUNTER);
+
+		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETOBJ, family,
+					    NLM_F_ACK, seq);
+		nftnl_obj_nlmsg_build_payload(nlh, t);
+		nftnl_obj_free(t);
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
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, obj_cb, &type);
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
diff --git a/include/Makefile.am b/include/Makefile.am
index a049e2e1de5d..fd4cb408a44a 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -5,6 +5,7 @@ noinst_HEADERS = internal.h	\
 		 buffer.h	\
 		 data_reg.h	\
 		 expr_ops.h	\
+		 obj.h		\
 		 linux_list.h	\
 		 set.h		\
 		 common.h	\
diff --git a/include/buffer.h b/include/buffer.h
index ab1d468af989..c5716570f9d0 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -41,6 +41,7 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 #define BURST			"burst"
 #define CHAIN			"chain"
 #define CODE			"code"
+#define CONSUMED		"consumed"
 #define DATA			"data"
 #define DEVICE			"device"
 #define DIR			"dir"
diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile.am
index 457ec95bcbc5..6dc7b2b38590 100644
--- a/include/libnftnl/Makefile.am
+++ b/include/libnftnl/Makefile.am
@@ -2,6 +2,7 @@ pkginclude_HEADERS = batch.h		\
 		     table.h		\
 		     trace.h		\
 		     chain.h		\
+		     object.h		\
 		     rule.h		\
 		     expr.h		\
 		     set.h		\
diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
new file mode 100644
index 000000000000..074a37789734
--- /dev/null
+++ b/include/libnftnl/object.h
@@ -0,0 +1,89 @@
+#ifndef _LIBNFTNL_OBJECT_H_
+#define _LIBNFTNL_OBJECT_H_
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
+enum {
+	NFTNL_OBJ_TABLE		= 0,
+	NFTNL_OBJ_NAME,
+	NFTNL_OBJ_TYPE,
+	NFTNL_OBJ_FAMILY,
+	NFTNL_OBJ_USE,
+	NFTNL_OBJ_BASE		= 16,
+	__NFTNL_OBJ_MAX
+};
+#define NFTNL_OBJ_MAX (__NFTNL_OBJ_MAX - 1)
+
+enum {
+	NFTNL_OBJ_CTR_PKTS	= NFTNL_OBJ_BASE,
+	NFTNL_OBJ_CTR_BYTES,
+};
+
+enum {
+	NFTNL_OBJ_QUOTA_BYTES	= NFTNL_OBJ_BASE,
+	NFTNL_OBJ_QUOTA_CONSUMED,
+	NFTNL_OBJ_QUOTA_FLAGS,
+};
+
+struct nftnl_obj;
+
+struct nftnl_obj *nftnl_obj_alloc(void);
+void nftnl_obj_free(const struct nftnl_obj *ne);
+
+bool nftnl_obj_is_set(const struct nftnl_obj *ne, uint16_t attr);
+void nftnl_obj_unset(struct nftnl_obj *ne, uint16_t attr);
+void nftnl_obj_set_data(struct nftnl_obj *ne, uint16_t attr, const void *data,
+			uint32_t data_len);
+void nftnl_obj_set(struct nftnl_obj *ne, uint16_t attr, const void *data);
+void nftnl_obj_set_u32(struct nftnl_obj *ne, uint16_t attr, uint32_t val);
+void nftnl_obj_set_u64(struct nftnl_obj *obj, uint16_t attr, uint64_t val);
+void nftnl_obj_set_str(struct nftnl_obj *ne, uint16_t attr, const char *str);
+const void *nftnl_obj_get_data(struct nftnl_obj *ne, uint16_t attr,
+			       uint32_t *data_len);
+const void *nftnl_obj_get(struct nftnl_obj *ne, uint16_t attr);
+uint32_t nftnl_obj_get_u32(struct nftnl_obj *ne, uint16_t attr);
+uint64_t nftnl_obj_get_u64(struct nftnl_obj *obj, uint16_t attr);
+const char *nftnl_obj_get_str(struct nftnl_obj *ne, uint16_t attr);
+
+void nftnl_obj_nlmsg_build_payload(struct nlmsghdr *nlh,
+				   const struct nftnl_obj *ne);
+int nftnl_obj_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_obj *ne);
+int nftnl_obj_parse(struct nftnl_obj *ne, enum nftnl_parse_type type,
+		    const char *data, struct nftnl_parse_err *err);
+int nftnl_obj_parse_file(struct nftnl_obj *ne, enum nftnl_parse_type type,
+			 FILE *fp, struct nftnl_parse_err *err);
+int nftnl_obj_snprintf(char *buf, size_t size, const struct nftnl_obj *ne,
+		       uint32_t type, uint32_t flags);
+int nftnl_obj_fprintf(FILE *fp, const struct nftnl_obj *ne, uint32_t type,
+		      uint32_t flags);
+
+struct nftnl_obj_list;
+struct nftnl_obj_list *nftnl_obj_list_alloc(void);
+void nftnl_obj_list_free(struct nftnl_obj_list *list);
+int nftnl_obj_list_is_empty(struct nftnl_obj_list *list);
+void nftnl_obj_list_add(struct nftnl_obj *r, struct nftnl_obj_list *list);
+void nftnl_obj_list_add_tail(struct nftnl_obj *r, struct nftnl_obj_list *list);
+void nftnl_obj_list_del(struct nftnl_obj *t);
+int nftnl_obj_list_foreach(struct nftnl_obj_list *table_list,
+			   int (*cb)(struct nftnl_obj *t, void *data),
+			   void *data);
+
+struct nftnl_obj_list_iter;
+struct nftnl_obj_list_iter *nftnl_obj_list_iter_create(struct nftnl_obj_list *l);
+struct nftnl_obj *nftnl_obj_list_iter_next(struct nftnl_obj_list_iter *iter);
+void nftnl_obj_list_iter_destroy(struct nftnl_obj_list_iter *iter);
+
+#ifdef __cplusplusg
+} /* extern "C" */
+#endif
+
+#endif /* _OBJ_H_ */
diff --git a/include/obj.h b/include/obj.h
new file mode 100644
index 000000000000..edbf023f5cdd
--- /dev/null
+++ b/include/obj.h
@@ -0,0 +1,55 @@
+#ifndef _OBJ_OPS_H_
+#define _OBJ_OPS_H_
+
+#include <stdint.h>
+#include "internal.h"
+
+struct nlattr;
+struct nlmsghdr;
+struct nftnl_obj;
+
+struct nftnl_obj {
+	struct list_head	head;
+	struct obj_ops		*ops;
+
+	const char		*table;
+	const char		*name;
+
+	uint32_t		family;
+	uint32_t		use;
+
+	uint32_t		flags;
+
+	union {
+		struct nftnl_obj_counter {
+			uint64_t	pkts;
+			uint64_t	bytes;
+		} counter;
+		struct nftnl_obj_quota {
+			uint64_t        bytes;
+			uint64_t	consumed;
+			uint32_t        flags;
+		} quota;
+	} data;
+};
+
+struct obj_ops {
+	const char *name;
+	uint32_t type;
+	size_t	alloc_len;
+	int	max_attr;
+	int	(*set)(struct nftnl_obj *e, uint16_t type, const void *data, uint32_t data_len);
+	const void *(*get)(const struct nftnl_obj *e, uint16_t type, uint32_t *data_len);
+	int	(*parse)(struct nftnl_obj *e, struct nlattr *attr);
+	void	(*build)(struct nlmsghdr *nlh, const struct nftnl_obj *e);
+	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags, const struct nftnl_obj *e);
+	int	(*json_parse)(struct nftnl_obj *e, json_t *data,
+			      struct nftnl_parse_err *err);
+};
+
+extern struct obj_ops obj_ops_counter;
+extern struct obj_ops obj_ops_quota;
+
+#define nftnl_obj_data(obj) (void *)&obj->data
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index e1e4144526c3..909c6a668b77 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -13,6 +13,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      table.c		\
 		      trace.c		\
 		      chain.c		\
+		      object.c		\
 		      rule.c		\
 		      set.c		\
 		      set_elem.c	\
@@ -50,4 +51,6 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/masq.c	\
 		      expr/redir.c	\
 		      expr/hash.c	\
+		      obj/counter.c	\
+		      obj/quota.c	\
 		      libnftnl.map
diff --git a/src/libnftnl.map b/src/libnftnl.map
index abed8b9e1295..64b9b0ba4f1f 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -533,3 +533,34 @@ LIBNFTNL_4.2 {
 	nftnl_rule_cmp;
 	nftnl_expr_cmp;
 } LIBNFTNL_4.1;
+
+LIBNFTNL_4.3 {
+	nftnl_obj_alloc;
+	nftnl_obj_free;
+	nftnl_obj_is_set;
+	nftnl_obj_unset;
+	nftnl_obj_set;
+	nftnl_obj_get;
+	nftnl_obj_set_u32;
+	nftnl_obj_set_u64;
+	nftnl_obj_set_str;
+	nftnl_obj_get_u32;
+	nftnl_obj_get_str;
+	nftnl_obj_get_u64;
+	nftnl_obj_parse;
+	nftnl_obj_parse_file;
+	nftnl_obj_snprintf;
+	nftnl_obj_fprintf;
+	nftnl_obj_nlmsg_build_payload;
+	nftnl_obj_nlmsg_parse;
+	nftnl_obj_list_alloc;
+	nftnl_obj_list_free;
+	nftnl_obj_list_is_empty;
+	nftnl_obj_list_foreach;
+	nftnl_obj_list_add;
+	nftnl_obj_list_add_tail;
+	nftnl_obj_list_del;
+	nftnl_obj_list_iter_create;
+	nftnl_obj_list_iter_next;
+	nftnl_obj_list_iter_destroy;
+} LIBNFTNL_4.2;
diff --git a/src/obj/counter.c b/src/obj/counter.c
new file mode 100644
index 000000000000..beadc93a8c35
--- /dev/null
+++ b/src/obj/counter.c
@@ -0,0 +1,184 @@
+/*
+ * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
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
+#include <libmnl/libmnl.h>
+#include <libnftnl/object.h>
+
+#include "internal.h"
+#include "obj.h"
+
+static int
+nftnl_obj_counter_set(struct nftnl_obj *e, uint16_t type,
+			  const void *data, uint32_t data_len)
+{
+	struct nftnl_obj_counter *ctr = nftnl_obj_data(e);
+
+	switch(type) {
+	case NFTNL_OBJ_CTR_BYTES:
+		ctr->bytes = *((uint64_t *)data);
+		break;
+	case NFTNL_OBJ_CTR_PKTS:
+		ctr->pkts = *((uint64_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nftnl_obj_counter_get(const struct nftnl_obj *e, uint16_t type,
+			  uint32_t *data_len)
+{
+	struct nftnl_obj_counter *ctr = nftnl_obj_data(e);
+
+	switch(type) {
+	case NFTNL_OBJ_CTR_BYTES:
+		*data_len = sizeof(ctr->bytes);
+		return &ctr->bytes;
+	case NFTNL_OBJ_CTR_PKTS:
+		*data_len = sizeof(ctr->pkts);
+		return &ctr->pkts;
+	}
+	return NULL;
+}
+
+static int nftnl_obj_counter_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_COUNTER_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_COUNTER_BYTES:
+	case NFTA_COUNTER_PACKETS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nftnl_obj_counter_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
+{
+	struct nftnl_obj_counter *ctr = nftnl_obj_data(e);
+
+	if (e->flags & (1 << NFTNL_OBJ_CTR_BYTES))
+		mnl_attr_put_u64(nlh, NFTA_COUNTER_BYTES, htobe64(ctr->bytes));
+	if (e->flags & (1 << NFTNL_OBJ_CTR_PKTS))
+		mnl_attr_put_u64(nlh, NFTA_COUNTER_PACKETS, htobe64(ctr->pkts));
+}
+
+static int
+nftnl_obj_counter_parse(struct nftnl_obj *e, struct nlattr *attr)
+{
+	struct nftnl_obj_counter *ctr = nftnl_obj_data(e);
+	struct nlattr *tb[NFTA_COUNTER_MAX+1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_obj_counter_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_COUNTER_BYTES]) {
+		ctr->bytes = be64toh(mnl_attr_get_u64(tb[NFTA_COUNTER_BYTES]));
+		e->flags |= (1 << NFTNL_OBJ_CTR_BYTES);
+	}
+	if (tb[NFTA_COUNTER_PACKETS]) {
+		ctr->pkts = be64toh(mnl_attr_get_u64(tb[NFTA_COUNTER_PACKETS]));
+		e->flags |= (1 << NFTNL_OBJ_CTR_PKTS);
+	}
+
+	return 0;
+}
+
+static int
+nftnl_obj_counter_json_parse(struct nftnl_obj *e, json_t *root,
+				 struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	uint64_t uval64;
+
+	if (nftnl_jansson_parse_val(root, "pkts", NFTNL_TYPE_U64, &uval64,
+				  err) == 0)
+		nftnl_obj_set_u64(e, NFTNL_OBJ_CTR_PKTS, uval64);
+
+	if (nftnl_jansson_parse_val(root, "bytes", NFTNL_TYPE_U64, &uval64,
+				  err) == 0)
+		nftnl_obj_set_u64(e, NFTNL_OBJ_CTR_BYTES, uval64);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nftnl_obj_counter_export(char *buf, size_t size,
+				    const struct nftnl_obj *e, int type)
+{
+	struct nftnl_obj_counter *ctr = nftnl_obj_data(e);
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_OBJ_CTR_PKTS))
+		nftnl_buf_u64(&b, type, ctr->pkts, PKTS);
+	if (e->flags & (1 << NFTNL_OBJ_CTR_BYTES))
+		nftnl_buf_u64(&b, type, ctr->bytes, BYTES);
+
+	return nftnl_buf_done(&b);
+}
+
+static int nftnl_obj_counter_snprintf_default(char *buf, size_t len,
+					       const struct nftnl_obj *e)
+{
+	struct nftnl_obj_counter *ctr = nftnl_obj_data(e);
+
+	return snprintf(buf, len, "pkts %"PRIu64" bytes %"PRIu64" ",
+			ctr->pkts, ctr->bytes);
+}
+
+static int nftnl_obj_counter_snprintf(char *buf, size_t len, uint32_t type,
+				       uint32_t flags,
+				       const struct nftnl_obj *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_obj_counter_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_obj_counter_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct obj_ops obj_ops_counter = {
+	.name		= "counter",
+	.type		= NFT_OBJECT_COUNTER,
+	.alloc_len	= sizeof(struct nftnl_obj_counter),
+	.max_attr	= NFTA_COUNTER_MAX,
+	.set		= nftnl_obj_counter_set,
+	.get		= nftnl_obj_counter_get,
+	.parse		= nftnl_obj_counter_parse,
+	.build		= nftnl_obj_counter_build,
+	.snprintf	= nftnl_obj_counter_snprintf,
+	.json_parse	= nftnl_obj_counter_json_parse,
+};
diff --git a/src/obj/quota.c b/src/obj/quota.c
new file mode 100644
index 000000000000..d5757b29d40d
--- /dev/null
+++ b/src/obj/quota.c
@@ -0,0 +1,205 @@
+/*
+ * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
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
+#include <libnftnl/object.h>
+
+#include "obj.h"
+
+static int nftnl_obj_quota_set(struct nftnl_obj *e, uint16_t type,
+				const void *data, uint32_t data_len)
+{
+	struct nftnl_obj_quota *quota = nftnl_obj_data(e);
+
+	switch (type) {
+	case NFTNL_OBJ_QUOTA_BYTES:
+		quota->bytes = *((uint64_t *)data);
+		break;
+	case NFTNL_OBJ_QUOTA_CONSUMED:
+		quota->consumed = *((uint64_t *)data);
+		break;
+	case NFTNL_OBJ_QUOTA_FLAGS:
+		quota->flags = *((uint32_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *nftnl_obj_quota_get(const struct nftnl_obj *e,
+					uint16_t type, uint32_t *data_len)
+{
+	struct nftnl_obj_quota *quota = nftnl_obj_data(e);
+
+	switch (type) {
+	case NFTNL_OBJ_QUOTA_BYTES:
+		*data_len = sizeof(quota->bytes);
+		return &quota->bytes;
+	case NFTNL_OBJ_QUOTA_CONSUMED:
+		*data_len = sizeof(quota->consumed);
+		return &quota->consumed;
+	case NFTNL_OBJ_QUOTA_FLAGS:
+		*data_len = sizeof(quota->flags);
+		return &quota->flags;
+	}
+	return NULL;
+}
+
+static int nftnl_obj_quota_cb(const struct nlattr *attr, void *data)
+{
+	int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+	if (mnl_attr_type_valid(attr, NFTA_QUOTA_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_QUOTA_BYTES:
+	case NFTA_QUOTA_CONSUMED:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
+	case NFTA_QUOTA_FLAGS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nftnl_obj_quota_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
+{
+	struct nftnl_obj_quota *quota = nftnl_obj_data(e);
+
+	if (e->flags & (1 << NFTNL_OBJ_QUOTA_BYTES))
+		mnl_attr_put_u64(nlh, NFTA_QUOTA_BYTES, htobe64(quota->bytes));
+	if (e->flags & (1 << NFTNL_OBJ_QUOTA_CONSUMED))
+		mnl_attr_put_u64(nlh, NFTA_QUOTA_CONSUMED,
+				 htobe64(quota->consumed));
+	if (e->flags & (1 << NFTNL_OBJ_QUOTA_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_QUOTA_FLAGS, htonl(quota->flags));
+}
+
+static int
+nftnl_obj_quota_parse(struct nftnl_obj *e, struct nlattr *attr)
+{
+	struct nftnl_obj_quota *quota = nftnl_obj_data(e);
+	struct nlattr *tb[NFTA_QUOTA_MAX + 1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_obj_quota_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_QUOTA_BYTES]) {
+		quota->bytes = be64toh(mnl_attr_get_u64(tb[NFTA_QUOTA_BYTES]));
+		e->flags |= (1 << NFTNL_OBJ_QUOTA_BYTES);
+	}
+	if (tb[NFTA_QUOTA_CONSUMED]) {
+		quota->consumed =
+			be64toh(mnl_attr_get_u64(tb[NFTA_QUOTA_CONSUMED]));
+		e->flags |= (1 << NFTNL_OBJ_QUOTA_CONSUMED);
+	}
+	if (tb[NFTA_QUOTA_FLAGS]) {
+		quota->flags = ntohl(mnl_attr_get_u32(tb[NFTA_QUOTA_FLAGS]));
+		e->flags |= (1 << NFTNL_OBJ_QUOTA_FLAGS);
+	}
+
+	return 0;
+}
+
+static int
+nftnl_obj_quota_json_parse(struct nftnl_obj *e, json_t *root,
+				 struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	uint64_t bytes;
+	uint32_t flags;
+
+	if (nftnl_jansson_parse_val(root, "bytes", NFTNL_TYPE_U64, &bytes,
+				  err) == 0)
+		nftnl_obj_set_u64(e, NFTNL_OBJ_QUOTA_BYTES, bytes);
+	if (nftnl_jansson_parse_val(root, "consumed", NFTNL_TYPE_U64, &bytes,
+				    err) == 0)
+		nftnl_obj_set_u64(e, NFTNL_OBJ_QUOTA_CONSUMED, bytes);
+	if (nftnl_jansson_parse_val(root, "flags", NFTNL_TYPE_U32, &flags,
+				  err) == 0)
+		nftnl_obj_set_u32(e, NFTNL_OBJ_QUOTA_FLAGS, flags);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nftnl_obj_quota_export(char *buf, size_t size,
+				   const struct nftnl_obj *e, int type)
+{
+	struct nftnl_obj_quota *quota = nftnl_obj_data(e);
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_OBJ_QUOTA_BYTES))
+		nftnl_buf_u64(&b, type, quota->bytes, BYTES);
+	if (e->flags & (1 << NFTNL_OBJ_QUOTA_CONSUMED))
+		nftnl_buf_u64(&b, type, quota->consumed, CONSUMED);
+	if (e->flags & (1 << NFTNL_OBJ_QUOTA_FLAGS))
+		nftnl_buf_u32(&b, type, quota->flags, FLAGS);
+
+	return nftnl_buf_done(&b);
+}
+
+static int nftnl_obj_quota_snprintf_default(char *buf, size_t len,
+					       const struct nftnl_obj *e)
+{
+	struct nftnl_obj_quota *quota = nftnl_obj_data(e);
+
+	return snprintf(buf, len, "bytes %"PRIu64" flags %u ",
+			quota->bytes, quota->flags);
+}
+
+static int nftnl_obj_quota_snprintf(char *buf, size_t len, uint32_t type,
+				       uint32_t flags,
+				       const struct nftnl_obj *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_obj_quota_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_obj_quota_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct obj_ops obj_ops_quota = {
+	.name		= "quota",
+	.type		= NFT_OBJECT_QUOTA,
+	.alloc_len	= sizeof(struct nftnl_obj_quota),
+	.max_attr	= NFTA_QUOTA_MAX,
+	.set		= nftnl_obj_quota_set,
+	.get		= nftnl_obj_quota_get,
+	.parse		= nftnl_obj_quota_parse,
+	.build		= nftnl_obj_quota_build,
+	.snprintf	= nftnl_obj_quota_snprintf,
+	.json_parse	= nftnl_obj_quota_json_parse,
+};
diff --git a/src/object.c b/src/object.c
new file mode 100644
index 000000000000..0190e9409797
--- /dev/null
+++ b/src/object.c
@@ -0,0 +1,573 @@
+/*
+ * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
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
+#include <libnftnl/object.h>
+#include <buffer.h>
+#include "obj.h"
+
+static struct obj_ops *obj_ops[] = {
+	[NFT_OBJECT_COUNTER]	= &obj_ops_counter,
+	[NFT_OBJECT_QUOTA]	= &obj_ops_quota,
+};
+
+static struct obj_ops *nftnl_obj_ops_lookup(uint32_t type)
+{
+	if (type > NFT_OBJECT_QUOTA)
+		return NULL;
+
+	return obj_ops[type];
+}
+
+struct nftnl_obj *nftnl_obj_alloc(void)
+{
+	return calloc(1, sizeof(struct nftnl_obj));
+}
+EXPORT_SYMBOL(nftnl_obj_alloc);
+
+void nftnl_obj_free(const struct nftnl_obj *obj)
+{
+	if (obj->flags & (1 << NFTNL_OBJ_TABLE))
+		xfree(obj->table);
+	if (obj->flags & (1 << NFTNL_OBJ_NAME))
+		xfree(obj->name);
+
+	xfree(obj);
+}
+EXPORT_SYMBOL(nftnl_obj_free);
+
+bool nftnl_obj_is_set(const struct nftnl_obj *obj, uint16_t attr)
+{
+	return obj->flags & (1 << attr);
+}
+EXPORT_SYMBOL(nftnl_obj_is_set);
+
+static uint32_t nftnl_obj_validate[NFTNL_OBJ_MAX + 1] = {
+	[NFTNL_OBJ_FAMILY]	= sizeof(uint32_t),
+	[NFTNL_OBJ_USE]		= sizeof(uint32_t),
+};
+
+void nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
+			const void *data, uint32_t data_len)
+{
+	if (attr < NFTNL_OBJ_MAX)
+		nftnl_assert_validate(data, nftnl_obj_validate, attr, data_len);
+
+	switch (attr) {
+	case NFTNL_OBJ_TABLE:
+		xfree(obj->table);
+		obj->table = strdup(data);
+		break;
+	case NFTNL_OBJ_NAME:
+		xfree(obj->name);
+		obj->name = strdup(data);
+		break;
+	case NFTNL_OBJ_TYPE:
+		obj->ops = nftnl_obj_ops_lookup(*((uint32_t *)data));
+		break;
+	case NFTNL_OBJ_FAMILY:
+		obj->family = *((uint32_t *)data);
+		break;
+	case NFTNL_OBJ_USE:
+		obj->use = *((uint32_t *)data);
+		break;
+	default:
+		if (obj->ops)
+			obj->ops->set(obj, attr, data, data_len);
+		break;
+	}
+	obj->flags |= (1 << attr);
+}
+EXPORT_SYMBOL(nftnl_obj_set_data);
+
+void nftnl_obj_set(struct nftnl_obj *obj, uint16_t attr, const void *data)
+{
+	nftnl_obj_set_data(obj, attr, data, nftnl_obj_validate[attr]);
+}
+EXPORT_SYMBOL(nftnl_obj_set);
+
+void nftnl_obj_set_u32(struct nftnl_obj *obj, uint16_t attr, uint32_t val)
+{
+	nftnl_obj_set_data(obj, attr, &val, sizeof(uint32_t));
+}
+EXPORT_SYMBOL(nftnl_obj_set_u32);
+
+void nftnl_obj_set_u64(struct nftnl_obj *obj, uint16_t attr, uint64_t val)
+{
+	nftnl_obj_set_data(obj, attr, &val, sizeof(uint64_t));
+}
+EXPORT_SYMBOL(nftnl_obj_set_u64);
+
+void nftnl_obj_set_str(struct nftnl_obj *obj, uint16_t attr, const char *str)
+{
+	nftnl_obj_set_data(obj, attr, str, 0);
+}
+EXPORT_SYMBOL(nftnl_obj_set_str);
+
+const void *nftnl_obj_get_data(struct nftnl_obj *obj, uint16_t attr,
+			       uint32_t *data_len)
+{
+	if (!(obj->flags & (1 << attr)))
+		return NULL;
+
+	switch(attr) {
+	case NFTNL_OBJ_TABLE:
+		return obj->table;
+	case NFTNL_OBJ_NAME:
+		return obj->name;
+	case NFTNL_OBJ_TYPE:
+		if (!obj->ops)
+			return NULL;
+
+		*data_len = sizeof(uint32_t);
+		return &obj->ops->type;
+	case NFTNL_OBJ_FAMILY:
+		*data_len = sizeof(uint32_t);
+		return &obj->family;
+	case NFTNL_OBJ_USE:
+		*data_len = sizeof(uint32_t);
+		return &obj->use;
+	default:
+		if (obj->ops)
+			return obj->ops->get(obj, attr, data_len);
+		break;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(nftnl_obj_get_data);
+
+const void *nftnl_obj_get(struct nftnl_obj *obj, uint16_t attr)
+{
+	uint32_t data_len;
+	return nftnl_obj_get_data(obj, attr, &data_len);
+}
+EXPORT_SYMBOL(nftnl_obj_get);
+
+uint32_t nftnl_obj_get_u32(struct nftnl_obj *obj, uint16_t attr)
+{
+	const void *ret = nftnl_obj_get(obj, attr);
+	return ret == NULL ? 0 : *((uint32_t *)ret);
+}
+EXPORT_SYMBOL(nftnl_obj_get_u32);
+
+uint64_t nftnl_obj_get_u64(struct nftnl_obj *obj, uint16_t attr)
+{
+	const void *ret = nftnl_obj_get(obj, attr);
+	return ret == NULL ? 0 : *((uint64_t *)ret);
+}
+EXPORT_SYMBOL(nftnl_obj_get_u64);
+
+const char *nftnl_obj_get_str(struct nftnl_obj *obj, uint16_t attr)
+{
+	return nftnl_obj_get(obj, attr);
+}
+EXPORT_SYMBOL(nftnl_obj_get_str);
+
+void nftnl_obj_nlmsg_build_payload(struct nlmsghdr *nlh,
+				   const struct nftnl_obj *obj)
+{
+	if (obj->flags & (1 << NFTNL_OBJ_TABLE))
+		mnl_attr_put_strz(nlh, NFTA_OBJ_TABLE, obj->table);
+	if (obj->flags & (1 << NFTNL_OBJ_NAME))
+		mnl_attr_put_strz(nlh, NFTA_OBJ_NAME, obj->name);
+	if (obj->flags & (1 << NFTNL_OBJ_TYPE))
+		mnl_attr_put_u32(nlh, NFTA_OBJ_TYPE, htonl(obj->ops->type));
+
+	if (obj->ops) {
+		struct nlattr *nest = mnl_attr_nest_start(nlh, NFTA_OBJ_DATA);
+
+		obj->ops->build(nlh, obj);
+		mnl_attr_nest_end(nlh, nest);
+	}
+}
+EXPORT_SYMBOL(nftnl_obj_nlmsg_build_payload);
+
+static int nftnl_obj_parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_OBJ_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_OBJ_TABLE:
+	case NFTA_OBJ_NAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	case NFTA_OBJ_DATA:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
+		break;
+	case NFTA_OBJ_USE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+int nftnl_obj_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_obj *obj)
+{
+	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[NFTA_OBJ_MAX + 1] = {};
+	int err;
+
+	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_obj_parse_attr_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_OBJ_TABLE]) {
+		obj->table = strdup(mnl_attr_get_str(tb[NFTA_OBJ_TABLE]));
+		obj->flags |= (1 << NFTNL_OBJ_TABLE);
+	}
+	if (tb[NFTA_OBJ_NAME]) {
+		obj->name = strdup(mnl_attr_get_str(tb[NFTA_OBJ_NAME]));
+		obj->flags |= (1 << NFTNL_OBJ_NAME);
+	}
+	if (tb[NFTA_OBJ_TYPE]) {
+		uint32_t type = ntohl(mnl_attr_get_u32(tb[NFTA_OBJ_TYPE]));
+
+		obj->ops = nftnl_obj_ops_lookup(type);
+		obj->flags |= (1 << NFTNL_OBJ_TYPE);
+	}
+	if (tb[NFTA_OBJ_DATA]) {
+		if (obj->ops) {
+			err = obj->ops->parse(obj, tb[NFTA_OBJ_DATA]);
+			if (err < 0)
+				return err;
+		}
+	}
+	if (tb[NFTA_OBJ_USE]) {
+		obj->use = ntohl(mnl_attr_get_u32(tb[NFTA_OBJ_USE]));
+		obj->flags |= (1 << NFTNL_OBJ_USE);
+	}
+
+	obj->family = nfg->nfgen_family;
+	obj->flags |= (1 << NFTNL_OBJ_FAMILY);
+
+	return 0;
+}
+EXPORT_SYMBOL(nftnl_obj_nlmsg_parse);
+
+#ifdef JSON_PARSING
+static int nftnl_jansson_parse_obj(struct nftnl_obj *t, json_t *tree,
+			    struct nftnl_parse_err *err)
+{
+	const char *str;
+	json_t *root;
+
+	root = nftnl_jansson_get_node(tree, "obj", err);
+	if (root == NULL)
+		return -1;
+
+	str = nftnl_jansson_parse_str(root, "table", err);
+	if (str != NULL)
+		nftnl_obj_set_str(t, NFTNL_OBJ_TABLE, str);
+
+	str = nftnl_jansson_parse_str(root, "name", err);
+	if (str != NULL)
+		nftnl_obj_set_str(t, NFTNL_OBJ_NAME, str);
+
+	return 0;
+}
+#endif
+
+static int nftnl_obj_json_parse(struct nftnl_obj *t, const void *json,
+				struct nftnl_parse_err *err,
+				enum nftnl_parse_input input)
+{
+#ifdef JSON_PARSING
+	json_t *tree;
+	json_error_t error;
+	int ret;
+
+	tree = nftnl_jansson_create_root(json, &error, err, input);
+	if (tree == NULL)
+		return -1;
+
+	ret = nftnl_jansson_parse_obj(t, tree, err);
+
+	nftnl_jansson_free_root(tree);
+
+	return ret;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nftnl_obj_do_parse(struct nftnl_obj *obj, enum nftnl_parse_type type,
+			      const void *data, struct nftnl_parse_err *err,
+			      enum nftnl_parse_input input)
+{
+	struct nftnl_parse_err perr;
+	int ret;
+
+	switch (type) {
+	case NFTNL_PARSE_JSON:
+		ret = nftnl_obj_json_parse(obj, data, &perr, input);
+		break;
+	case NFTNL_PARSE_XML:
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
+int nftnl_obj_parse(struct nftnl_obj *obj, enum nftnl_parse_type type,
+		      const char *data, struct nftnl_parse_err *err)
+{
+	return nftnl_obj_do_parse(obj, type, data, err, NFTNL_PARSE_BUFFER);
+}
+EXPORT_SYMBOL(nftnl_obj_parse);
+
+int nftnl_obj_parse_file(struct nftnl_obj *obj, enum nftnl_parse_type type,
+			   FILE *fp, struct nftnl_parse_err *err)
+{
+	return nftnl_obj_do_parse(obj, type, fp, err, NFTNL_PARSE_FILE);
+}
+EXPORT_SYMBOL(nftnl_obj_parse_file);
+
+static int nftnl_obj_export(char *buf, size_t size,
+			    const struct nftnl_obj *obj,
+			    uint32_t type, uint32_t flags)
+{
+	int ret = 0;
+
+	NFTNL_BUF_INIT(b, buf, size);
+
+	nftnl_buf_open(&b, type, TABLE);
+	if (obj->flags & (1 << NFTNL_OBJ_TABLE))
+		nftnl_buf_str(&b, type, obj->name, NAME);
+	if (obj->flags & (1 << NFTNL_OBJ_NAME))
+		nftnl_buf_str(&b, type, obj->name, NAME);
+	if (obj->flags & (1 << NFTNL_OBJ_FAMILY))
+		nftnl_buf_str(&b, type, nftnl_family2str(obj->family), FAMILY);
+	if (obj->flags & (1 << NFTNL_OBJ_USE))
+		nftnl_buf_u32(&b, type, obj->use, USE);
+
+	if (obj->ops)
+		ret = obj->ops->snprintf(buf + b.len, size - b.len, type,
+					 flags, obj);
+
+	b.len += ret;
+	nftnl_buf_close(&b, type, TABLE);
+
+	return nftnl_buf_done(&b);
+}
+
+static int nftnl_obj_snprintf_dflt(char *buf, size_t size,
+				   const struct nftnl_obj *obj,
+				   uint32_t type, uint32_t flags)
+{
+	int ret, len = size, offset = 0;
+
+	ret = snprintf(buf, size, "table %s name %s use %u [ %s ",
+		       obj->table, obj->name, obj->use, obj->ops->name);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (obj->ops) {
+		ret = obj->ops->snprintf(buf + offset, offset, type, flags, obj);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	ret = snprintf(buf + offset, offset, "]");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int nftnl_obj_cmd_snprintf(char *buf, size_t size,
+				    const struct nftnl_obj *obj, uint32_t cmd,
+				    uint32_t type, uint32_t flags)
+{
+	int ret, len = size, offset = 0;
+
+	ret = nftnl_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	switch (type) {
+	case NFT_OUTPUT_DEFAULT:
+		ret = nftnl_obj_snprintf_dflt(buf + offset, len, obj, type,
+					      flags);
+		break;
+	case NFT_OUTPUT_JSON:
+		ret = nftnl_obj_export(buf + offset, len, obj, type, flags);
+		break;
+	case NFT_OUTPUT_XML:
+	default:
+		return -1;
+	}
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = nftnl_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+int nftnl_obj_snprintf(char *buf, size_t size, const struct nftnl_obj *obj,
+		       uint32_t type, uint32_t flags)
+{
+	return nftnl_obj_cmd_snprintf(buf, size, obj, nftnl_flag2cmd(flags),
+				      type, flags);
+}
+EXPORT_SYMBOL(nftnl_obj_snprintf);
+
+static int nftnl_obj_do_snprintf(char *buf, size_t size, const void *obj,
+				 uint32_t cmd, uint32_t type, uint32_t flags)
+{
+	return nftnl_obj_snprintf(buf, size, obj, type, flags);
+}
+
+int nftnl_obj_fprintf(FILE *fp, const struct nftnl_obj *obj, uint32_t type,
+		      uint32_t flags)
+{
+	return nftnl_fprintf(fp, obj, NFT_CMD_UNSPEC, type, flags,
+			     nftnl_obj_do_snprintf);
+}
+EXPORT_SYMBOL(nftnl_obj_fprintf);
+
+struct nftnl_obj_list {
+	struct list_head list;
+};
+
+struct nftnl_obj_list *nftnl_obj_list_alloc(void)
+{
+	struct nftnl_obj_list *list;
+
+	list = calloc(1, sizeof(struct nftnl_obj_list));
+	if (list == NULL)
+		return NULL;
+
+	INIT_LIST_HEAD(&list->list);
+
+	return list;
+}
+EXPORT_SYMBOL(nftnl_obj_list_alloc);
+
+void nftnl_obj_list_free(struct nftnl_obj_list *list)
+{
+	struct nftnl_obj *r, *tmp;
+
+	list_for_each_entry_safe(r, tmp, &list->list, head) {
+		list_del(&r->head);
+		nftnl_obj_free(r);
+	}
+	xfree(list);
+}
+EXPORT_SYMBOL(nftnl_obj_list_free);
+
+int nftnl_obj_list_is_empty(struct nftnl_obj_list *list)
+{
+	return list_empty(&list->list);
+}
+EXPORT_SYMBOL(nftnl_obj_list_is_empty);
+
+void nftnl_obj_list_add(struct nftnl_obj *r, struct nftnl_obj_list *list)
+{
+	list_add(&r->head, &list->list);
+}
+EXPORT_SYMBOL(nftnl_obj_list_add);
+
+void nftnl_obj_list_add_tail(struct nftnl_obj *r,
+			       struct nftnl_obj_list *list)
+{
+	list_add_tail(&r->head, &list->list);
+}
+EXPORT_SYMBOL(nftnl_obj_list_add_tail);
+
+void nftnl_obj_list_del(struct nftnl_obj *t)
+{
+	list_del(&t->head);
+}
+EXPORT_SYMBOL(nftnl_obj_list_del);
+
+int nftnl_obj_list_foreach(struct nftnl_obj_list *table_list,
+			     int (*cb)(struct nftnl_obj *t, void *data),
+			     void *data)
+{
+	struct nftnl_obj *cur, *tmp;
+	int ret;
+
+	list_for_each_entry_safe(cur, tmp, &table_list->list, head) {
+		ret = cb(cur, data);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(nftnl_obj_list_foreach);
+
+struct nftnl_obj_list_iter {
+	struct nftnl_obj_list	*list;
+	struct nftnl_obj	*cur;
+};
+
+struct nftnl_obj_list_iter *
+nftnl_obj_list_iter_create(struct nftnl_obj_list *l)
+{
+	struct nftnl_obj_list_iter *iter;
+
+	iter = calloc(1, sizeof(struct nftnl_obj_list_iter));
+	if (iter == NULL)
+		return NULL;
+
+	iter->list = l;
+	if (nftnl_obj_list_is_empty(l))
+		iter->cur = NULL;
+	else
+		iter->cur = list_entry(l->list.next, struct nftnl_obj, head);
+
+	return iter;
+}
+EXPORT_SYMBOL(nftnl_obj_list_iter_create);
+
+struct nftnl_obj *nftnl_obj_list_iter_next(struct nftnl_obj_list_iter *iter)
+{
+	struct nftnl_obj *r = iter->cur;
+
+	if (r == NULL)
+		return NULL;
+
+	/* get next table, if any */
+	iter->cur = list_entry(iter->cur->head.next, struct nftnl_obj, head);
+	if (&iter->cur->head == iter->list->list.next)
+		return NULL;
+
+	return r;
+}
+EXPORT_SYMBOL(nftnl_obj_list_iter_next);
+
+void nftnl_obj_list_iter_destroy(struct nftnl_obj_list_iter *iter)
+{
+	xfree(iter);
+}
+EXPORT_SYMBOL(nftnl_obj_list_iter_destroy);
diff --git a/tests/Makefile.am b/tests/Makefile.am
index d51895974406..812ebff17126 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -6,6 +6,7 @@ EXTRA_DIST =		test-script.sh			\
 check_PROGRAMS = 	nft-parsing-test		\
 			nft-table-test			\
 			nft-chain-test			\
+			nft-object-test			\
 			nft-rule-test			\
 			nft-set-test			\
 			nft-expr_bitwise-test		\
@@ -43,6 +44,9 @@ nft_table_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_chain_test_SOURCES = nft-chain-test.c
 nft_chain_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_object_test_SOURCES = nft-object-test.c
+nft_object_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_rule_test_SOURCES = nft-rule-test.c
 nft_rule_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
diff --git a/tests/nft-object-test.c b/tests/nft-object-test.c
new file mode 100644
index 000000000000..d2ca44415341
--- /dev/null
+++ b/tests/nft-object-test.c
@@ -0,0 +1,78 @@
+/*
+ * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netinet/in.h>
+
+#include <linux/netfilter/nf_tables.h>
+#include <libnftnl/object.h>
+
+static int test_ok = 1;
+
+static void print_err(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nftnl_obj(struct nftnl_obj *a, struct nftnl_obj *b)
+{
+	if (strcmp(nftnl_obj_get_str(a, NFTNL_OBJ_TABLE),
+		   nftnl_obj_get_str(b, NFTNL_OBJ_TABLE)) != 0)
+		print_err("table name mismatches");
+	if (strcmp(nftnl_obj_get_str(a, NFTNL_OBJ_NAME),
+		   nftnl_obj_get_str(b, NFTNL_OBJ_NAME)) != 0)
+		print_err("name mismatches");
+	if (nftnl_obj_get_u32(a, NFTNL_OBJ_FAMILY) !=
+	    nftnl_obj_get_u32(b, NFTNL_OBJ_FAMILY))
+		print_err("family mismatches");
+	if (nftnl_obj_get_u32(a, NFTNL_OBJ_TYPE) !=
+	    nftnl_obj_get_u32(b, NFTNL_OBJ_TYPE))
+		print_err("type mismatches");
+}
+
+int main(int argc, char *argv[])
+{
+	char buf[4096];
+	struct nlmsghdr *nlh;
+	struct nftnl_obj *a;
+	struct nftnl_obj *b;
+
+	a = nftnl_obj_alloc();
+	b = nftnl_obj_alloc();
+	if (a == NULL || b == NULL)
+		print_err("OOM");
+
+	nftnl_obj_set_str(a, NFTNL_OBJ_TABLE, "test");
+	nftnl_obj_set_str(a, NFTNL_OBJ_NAME, "test");
+	nftnl_obj_set_u32(a, NFTNL_OBJ_FAMILY, AF_INET);
+	nftnl_obj_set_u32(a, NFTNL_OBJ_USE, 1);
+	nftnl_obj_set_u64(a, NFTNL_OBJ_CTR_BYTES, 0x12345678abcd);
+	nftnl_obj_set_u64(a, NFTNL_OBJ_CTR_PKTS, 0xcd12345678ab);
+
+	/* cmd extracted from include/linux/netfilter/nf_tables.h */
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWOBJ, AF_INET, 0, 1234);
+	nftnl_obj_nlmsg_build_payload(nlh, a);
+
+	if (nftnl_obj_nlmsg_parse(nlh, b) < 0)
+		print_err("parsing problems");
+
+	cmp_nftnl_obj(a, b);
+
+	nftnl_obj_free(a);
+	nftnl_obj_free(b);
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/test-script.sh b/tests/test-script.sh
index 3244f802e1cb..743e514da698 100755
--- a/tests/test-script.sh
+++ b/tests/test-script.sh
@@ -27,4 +27,5 @@
 ./nft-rule-test
 ./nft-set-test
 ./nft-table-test
+./nft-object-test
 ./nft-parsing-test -d jsonfiles
-- 
2.1.4

