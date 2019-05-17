Return-Path: <SRS0=W6An=TR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590E4C04AB4
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 May 2019 16:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17EDE2087B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 May 2019 16:43:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nkiCbEs8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfEQQnF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 May 2019 12:43:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45819 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfEQQnF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 May 2019 12:43:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id b18so7783208wrq.12
        for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2019 09:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d5cANNyOZIIIfGl8ud346svrZIHniyqUC3FvJSdvxHY=;
        b=nkiCbEs8OOs7ft0r+yR39C7RsTQlvNb//uS6nN2b2HBqKvMgkRP4LxCS6tLvMTMUaA
         LATqotKtdeDfNDYSwQPDmU07NKz7kEUL9F52GaU1jks8c/LglNG/YIxGClKrOhiPUlWp
         1Vb4VW72IYgTqT1TmMfs1TuFPfTxI/No4L+5BGPLfs4PeDGfhPrsppAp9EzRnVaIZhho
         GMp5rieqeIt6v5QVAD4tXMIcmH/Q2hxvoyyD60E2/pA8SrxZXr1hQWTkehmXUigqXHkY
         2l2S7MYa2QDj7F60OCls9/RolLmKNFr8bdBBzeQbPRXkZ9MW+NBIK4QlgPN+fD8s3IQT
         hzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d5cANNyOZIIIfGl8ud346svrZIHniyqUC3FvJSdvxHY=;
        b=gR8ugmIAm/t61wxL9i8GYUyMiAjw+5GMOsgi/vwLV38pXb19/5YvtuDPV2XXQ+mGId
         mmX4UkCwcw8MjpMrRKxX0eri+qGjPGZEzc8Nre3bcj/sSZRHTxkoYemyBuLhiv+kruWU
         aVSD41hkibpGj/TlngLzlbn1Tw3gmnRIxrsBUBtIPDlTYYXLlA/4F6IKJEAnSB57n17d
         jaF6eP4ODitFV41XIo4Eknk2V+7k9bEXl8zl4YIbj0kS/0BppwHCoGRLaLfK8qTReq/d
         eLVi+zR3H0e6ACIZx9b5pItBoWhPPktkn59jRYFi7INWzS3gK82GfYjTkIGBv0Yoj4ja
         AluQ==
X-Gm-Message-State: APjAAAWBdpOs6JutCxGySDWYPdNyNicmy/FJD1oi77WTVP64jajMpYt7
        PdxE8rL34n2F80j0dZi1B591yBjf
X-Google-Smtp-Source: APXvYqwSNCb965185AqiTrFe5joWZQbYhkRHbMnxNkBKsrWHyorVWC53iyKhgaBWf66P/zVb4m94EA==
X-Received: by 2002:adf:f74f:: with SMTP id z15mr9166120wrp.282.1558111382207;
        Fri, 17 May 2019 09:43:02 -0700 (PDT)
Received: from VGer.neptura.lan (neptura.org. [88.174.209.153])
        by smtp.gmail.com with ESMTPSA id s13sm6808708wrw.17.2019.05.17.09.43.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 09:43:01 -0700 (PDT)
From:   =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
Subject: [PATCH libnftnl,v3 2/2] examples: add ct expectation examples
Date:   Fri, 17 May 2019 18:40:31 +0200
Message-Id: <20190517164031.8536-4-sveyret@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190517164031.8536-1-sveyret@gmail.com>
References: <20190517164031.8536-1-sveyret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add examples for ct expectations.

Add, list and delete ct expectation objects from specified table.
Add expectation object to rule.

Signed-off-by: Stéphane Veyret <sveyret@gmail.com>
---
 examples/Makefile.am                   |  16 +++
 examples/nft-ct-expectation-add.c      | 152 +++++++++++++++++++++++
 examples/nft-ct-expectation-del.c      | 128 +++++++++++++++++++
 examples/nft-ct-expectation-get.c      | 144 ++++++++++++++++++++++
 examples/nft-rule-ct-expectation-add.c | 163 +++++++++++++++++++++++++
 5 files changed, 603 insertions(+)
 create mode 100644 examples/nft-ct-expectation-add.c
 create mode 100644 examples/nft-ct-expectation-del.c
 create mode 100644 examples/nft-ct-expectation-get.c
 create mode 100644 examples/nft-rule-ct-expectation-add.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index d044b90..db9164d 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -29,10 +29,14 @@ check_PROGRAMS = nft-table-add		\
 		 nft-flowtable-get	\
 		 nft-ruleset-get	\
 		 nft-compat-get 	\
+		 nft-ct-expectation-add \
+		 nft-ct-expectation-del \
+		 nft-ct-expectation-get \
 		 nft-ct-helper-add	\
 		 nft-ct-helper-get	\
 		 nft-ct-helper-del	\
 		 nft-rule-ct-helper-add \
+		 nft-rule-ct-expectation-add \
 		 nft-rule-ct-timeout-add
 
 nft_table_add_SOURCES = nft-table-add.c
@@ -122,6 +126,15 @@ nft_ruleset_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_compat_get_SOURCES = nft-compat-get.c
 nft_compat_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_ct_expectation_add_SOURCES = nft-ct-expectation-add.c
+nft_ct_expectation_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_ct_expectation_del_SOURCES = nft-ct-expectation-del.c
+nft_ct_expectation_del_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_ct_expectation_get_SOURCES = nft-ct-expectation-get.c
+nft_ct_expectation_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_ct_helper_add_SOURCES = nft-ct-helper-add.c
 nft_ct_helper_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
@@ -134,5 +147,8 @@ nft_ct_helper_del_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_rule_ct_helper_add_SOURCES = nft-rule-ct-helper-add.c
 nft_rule_ct_helper_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_rule_ct_expectation_add_SOURCES = nft-rule-ct-expectation-add.c
+nft_rule_ct_expectation_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_rule_ct_timeout_add_SOURCES = nft-rule-ct-timeout-add.c
 nft_rule_ct_timeout_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/examples/nft-ct-expectation-add.c b/examples/nft-ct-expectation-add.c
new file mode 100644
index 0000000..c930f35
--- /dev/null
+++ b/examples/nft-ct-expectation-add.c
@@ -0,0 +1,152 @@
+/*
+ * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <time.h>
+#include <string.h>
+#include <netinet/in.h>
+
+#include <linux/netfilter.h>
+
+#include <obj.h>
+#include <libmnl/libmnl.h>
+
+static uint16_t parse_family(char *str, const char *option)
+{
+	if (strcmp(str, "ip") == 0)
+		return NFPROTO_IPV4;
+	else if (strcmp(str, "ip6") == 0)
+		return NFPROTO_IPV6;
+	else if (strcmp(str, "inet") == 0)
+		return NFPROTO_INET;
+	else if (strcmp(str, "arp") == 0)
+		return NFPROTO_INET;
+	else {
+		fprintf(stderr, "Unknown %s: ip, ip6, inet, arp\n", option);
+		exit(EXIT_FAILURE);
+	}
+}
+
+static uint8_t parse_l4proto(char *str)
+{
+	if (strcmp(str, "udp") == 0)
+		return IPPROTO_UDP;
+	else if (strcmp(str, "tcp") == 0)
+		return IPPROTO_TCP;
+	else {
+		fprintf(stderr, "Unknown l4proto: tcp, udp\n");
+		exit(EXIT_FAILURE);
+	}
+	return IPPROTO_TCP;
+}
+
+static struct nftnl_obj *obj_parse(int argc, char *argv[])
+{
+	struct nftnl_obj *t;
+	uint16_t family, l3proto, dport;
+	uint8_t l4proto;
+	uint32_t timeout;
+
+	t = nftnl_obj_alloc();
+	if (t == NULL) {
+			perror("OOM");
+			return NULL;
+	}
+
+	family = parse_family(argv[1], "family");
+	nftnl_obj_set_u32(t, NFTNL_OBJ_FAMILY, family);
+	nftnl_obj_set_u32(t, NFTNL_OBJ_TYPE, NFT_OBJECT_CT_EXPECT);
+	nftnl_obj_set_str(t, NFTNL_OBJ_TABLE, argv[2]);
+	nftnl_obj_set_str(t, NFTNL_OBJ_NAME, argv[3]);
+
+	if (argc > 7) {
+		l3proto = parse_family(argv[7], "l3proto");
+		nftnl_obj_set_u16(t, NFTNL_OBJ_CT_EXPECT_L3PROTO, l3proto);
+	}
+	l4proto = parse_l4proto(argv[4]);
+	nftnl_obj_set_u8(t, NFTNL_OBJ_CT_EXPECT_L4PROTO, l4proto);
+	dport = strtol(argv[5], NULL, 10);
+	nftnl_obj_set_u16(t, NFTNL_OBJ_CT_EXPECT_DPORT, dport);
+	timeout = strtol(argv[6], NULL, 10);
+	nftnl_obj_set_u32(t, NFTNL_OBJ_CT_EXPECT_TIMEOUT, timeout);
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
+	if (argc < 7 || argc > 8) {
+		fprintf(stderr, "%s <family> <table> <name> <l4proto> <dport> <timeout> [l3proto]\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	t = obj_parse(argc, argv);
+	if (t == NULL) {
+		exit(EXIT_FAILURE);
+	}
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
+					NFT_MSG_NEWOBJ, family, NLM_F_ACK | NLM_F_CREATE, seq++);
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
+				  mnl_nlmsg_batch_size(batch)) < 0) {
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
diff --git a/examples/nft-ct-expectation-del.c b/examples/nft-ct-expectation-del.c
new file mode 100644
index 0000000..e38b8bd
--- /dev/null
+++ b/examples/nft-ct-expectation-del.c
@@ -0,0 +1,128 @@
+/*
+ * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
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
+static uint16_t parse_family(char *str, const char *option)
+{
+	if (strcmp(str, "ip") == 0)
+		return NFPROTO_IPV4;
+	else if (strcmp(str, "ip6") == 0)
+		return NFPROTO_IPV6;
+	else if (strcmp(str, "inet") == 0)
+		return NFPROTO_INET;
+	else if (strcmp(str, "arp") == 0)
+		return NFPROTO_INET;
+	else {
+		fprintf(stderr, "Unknown %s: ip, ip6, inet, arp\n", option);
+		exit(EXIT_FAILURE);
+	}
+}
+
+static struct nftnl_obj *obj_parse(int argc, char *argv[])
+{
+	struct nftnl_obj *t;
+	uint16_t family;
+
+	t = nftnl_obj_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	family = parse_family(argv[1], "family");
+	nftnl_obj_set_u32(t, NFTNL_OBJ_FAMILY, family);
+	nftnl_obj_set_u32(t, NFTNL_OBJ_TYPE, NFT_OBJECT_CT_EXPECT);
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
+	t = obj_parse(argc, argv);
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
diff --git a/examples/nft-ct-expectation-get.c b/examples/nft-ct-expectation-get.c
new file mode 100644
index 0000000..405ba9a
--- /dev/null
+++ b/examples/nft-ct-expectation-get.c
@@ -0,0 +1,144 @@
+/*
+ * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
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
+static uint16_t parse_family(char *str, const char *option)
+{
+	if (strcmp(str, "ip") == 0)
+		return NFPROTO_IPV4;
+	else if (strcmp(str, "ip6") == 0)
+		return NFPROTO_IPV6;
+	else if (strcmp(str, "inet") == 0)
+		return NFPROTO_INET;
+	else if (strcmp(str, "arp") == 0)
+		return NFPROTO_INET;
+	else {
+		fprintf(stderr, "Unknown %s: ip, ip6, inet, arp\n", option);
+		exit(EXIT_FAILURE);
+	}
+}
+
+static struct nftnl_obj *obj_parse(int argc, char *argv[])
+{
+	struct nftnl_obj *t;
+	uint16_t family;
+
+	t = nftnl_obj_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	family = parse_family(argv[1], "family");
+	nftnl_obj_set_u32(t, NFTNL_OBJ_FAMILY, family);
+	nftnl_obj_set_u32(t, NFTNL_OBJ_TYPE, NFT_OBJECT_CT_EXPECT);
+	nftnl_obj_set_str(t, NFTNL_OBJ_TABLE, argv[2]);
+
+	if (argc > 3)
+		nftnl_obj_set_str(t, NFTNL_OBJ_NAME, argv[3]);
+
+	return t;
+}
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
+	struct nftnl_obj *t;
+	int ret;
+	uint32_t type = NFTNL_OUTPUT_DEFAULT;
+	uint16_t flags = NLM_F_ACK;
+
+	if (argc < 3 || argc > 4) {
+		fprintf(stderr, "%s <family> <table> [<name>]\n", argv[0]);
+		return EXIT_FAILURE;
+	}
+
+	t = obj_parse(argc, argv);
+	if (t == NULL)
+		exit(EXIT_FAILURE);
+	family = nftnl_obj_get_u32(t, NFTNL_OBJ_FAMILY);
+
+	seq = time(NULL);
+	if (argc < 4)
+		flags = NLM_F_DUMP;
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETOBJ, family, flags, seq);
+	nftnl_obj_nlmsg_build_payload(nlh, t);
+	nftnl_obj_free(t);
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
diff --git a/examples/nft-rule-ct-expectation-add.c b/examples/nft-rule-ct-expectation-add.c
new file mode 100644
index 0000000..794bb2c
--- /dev/null
+++ b/examples/nft-rule-ct-expectation-add.c
@@ -0,0 +1,163 @@
+/*
+ * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
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
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+
+static uint16_t parse_family(char *str, const char *option)
+{
+	if (strcmp(str, "ip") == 0)
+		return NFPROTO_IPV4;
+	else if (strcmp(str, "ip6") == 0)
+		return NFPROTO_IPV6;
+	else if (strcmp(str, "inet") == 0)
+		return NFPROTO_INET;
+	else if (strcmp(str, "arp") == 0)
+		return NFPROTO_INET;
+	else {
+		fprintf(stderr, "Unknown %s: ip, ip6, inet, arp\n", option);
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void add_ct_expect(struct nftnl_rule *r, const char *obj_name)
+{
+	struct nftnl_expr *e;
+
+	e = nftnl_expr_alloc("objref");
+	if (e == NULL) {
+		perror("expr objref oom");
+		exit(EXIT_FAILURE);
+	}
+	nftnl_expr_set_str(e, NFTNL_EXPR_OBJREF_IMM_NAME, obj_name);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_OBJREF_IMM_TYPE, NFT_OBJECT_CT_EXPECT);
+
+	nftnl_rule_add_expr(r, e);
+}
+
+static struct nftnl_rule *setup_rule(uint8_t family, const char *table,
+				   const char *chain, const char *handle, const char *obj_name)
+{
+	struct nftnl_rule *r = NULL;
+	uint64_t handle_num;
+
+	r = nftnl_rule_alloc();
+	if (r == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	nftnl_rule_set(r, NFTNL_RULE_TABLE, table);
+	nftnl_rule_set(r, NFTNL_RULE_CHAIN, chain);
+	nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, family);
+
+	if (handle != NULL) {
+		handle_num = atoll(handle);
+		nftnl_rule_set_u64(r, NFTNL_RULE_POSITION, handle_num);
+	}
+
+	add_ct_expect(r, obj_name);
+
+	return r;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	struct nftnl_rule *r;
+	struct nlmsghdr *nlh;
+	struct mnl_nlmsg_batch *batch;
+	uint8_t family;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	uint32_t seq = time(NULL);
+	int ret;
+
+	if (argc < 5 || argc > 6) {
+		fprintf(stderr,
+			"Usage: %s <family> <table> <chain> [<handle>] <name>\n",
+			argv[0]);
+		exit(EXIT_FAILURE);
+	}
+	family = parse_family(argv[1], "family");
+
+	if (argc != 6)
+		r = setup_rule(family, argv[2], argv[3], NULL, argv[4]);
+	else
+		r = setup_rule(family, argv[2], argv[3], argv[4], argv[5]);
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
+	nlh = nftnl_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+		NFT_MSG_NEWRULE,
+		nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY),
+		NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
+
+	nftnl_rule_nlmsg_build_payload(nlh, r);
+	nftnl_rule_free(r);
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
-- 
2.21.0

