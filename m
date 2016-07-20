From: jalvarez <jalvarez@toulouse.viveris.com>
Subject: [PATCH libnftnl] examples: selective rule dumping
Date: Wed, 20 Jul 2016 15:36:58 +0200
Message-ID: <578F7E7A.5080901@toulouse.viveris.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.toulouse.viveris.com ([212.99.125.10]:33968 "EHLO
	mailS.toulouse.viveris.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690AbcGTNhB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 09:37:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add example (based on nft-get-rule.c) to demonstrate selective rule 
dumping when table and / or chain attributes are set in a rule dump request.
Used to test the changes made in "[PATCH nf-next] netfilter: nf_tables: 
allow to filter out rules by table and chain" 
(http://marc.info/?t=146237901200004&r=1&w=2).

Signed-off-by: Josue Alvarez <jalvarez@toulouse.viveris.com>
--
diff --git a/examples/Makefile.am b/examples/Makefile.am
index e002d36..73450c2 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -13,6 +13,7 @@ check_PROGRAMS = nft-table-add        \
           nft-rule-parse-add    \
           nft-rule-del        \
           nft-rule-get        \
+         nft-rule-selective-get    \
           nft-events        \
           nft-set-add        \
           nft-set-parse-add    \
@@ -40,6 +41,9 @@ nft_table_del_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
  nft_table_get_SOURCES = nft-table-get.c
  nft_table_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}

+nft_rule_selective_get_SOURCES = nft-rule-selective-get.c
+nft_rule_selective_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
  nft_chain_add_SOURCES = nft-chain-add.c
  nft_chain_add_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}

diff --git a/examples/nft-rule-selective-get.c 
b/examples/nft-rule-selective-get.c
new file mode 100644
index 0000000..a1b82c1
--- /dev/null
+++ b/examples/nft-rule-selective-get.c
@@ -0,0 +1,164 @@
+/*
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This software has been sponsored by Sophos Astaro 
<http://www.sophos.com>
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
+#include <libnftnl/rule.h>
+
+static int table_cb(const struct nlmsghdr *nlh, void *data)
+{
+    struct nftnl_rule *t;
+    char buf[4096];
+    uint32_t *type = data;
+
+    t = nftnl_rule_alloc();
+    if (t == NULL) {
+        perror("OOM");
+        goto err;
+    }
+
+    if (nftnl_rule_nlmsg_parse(nlh, t) < 0) {
+        perror("nftnl_rule_nlmsg_parse");
+        goto err_free;
+    }
+
+    nftnl_rule_snprintf(buf, sizeof(buf), t, *type, 0);
+    printf("%s\n", buf);
+
+err_free:
+    nftnl_rule_free(t);
+err:
+    return MNL_CB_OK;
+}
+
+static struct nftnl_rule *setup_rule(uint8_t family, const char *table,
+                   const char *chain, const char *handle)
+{
+    struct nftnl_rule *r = NULL;
+    uint8_t proto;
+    uint16_t dport;
+    uint64_t handle_num;
+
+    r = nftnl_rule_alloc();
+    if (r == NULL) {
+        perror("OOM");
+        exit(EXIT_FAILURE);
+    }
+
+    if (table != NULL)
+        nftnl_rule_set(r, NFTNL_RULE_TABLE, table);
+
+    if (chain != NULL)
+        nftnl_rule_set(r, NFTNL_RULE_CHAIN, chain);
+
+    nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, family);
+
+    if (handle != NULL) {
+        handle_num = atoll(handle);
+        nftnl_rule_set_u64(r, NFTNL_RULE_POSITION, handle_num);
+    }
+
+    return r;
+}
+
+int main(int argc, char *argv[])
+{
+    struct mnl_socket *nl;
+    char buf[MNL_SOCKET_BUFFER_SIZE];
+    const char *table, *chain = NULL;
+    struct nlmsghdr *nlh;
+    uint32_t portid, seq, type = NFTNL_OUTPUT_DEFAULT;
+    struct nftnl_rule *t, *r = NULL;
+    int ret, family;
+
+    if (argc < 2 || argc > 4) {
+        fprintf(stderr, "Usage: %s <family> [<table>] [<chain>]\n",
+            argv[0]);
+        exit(EXIT_FAILURE);
+    }
+
+    if (strcmp(argv[1], "ip") == 0)
+        family = NFPROTO_IPV4;
+    else if (strcmp(argv[1], "ip6") == 0)
+        family = NFPROTO_IPV6;
+    else if (strcmp(argv[1], "bridge") == 0)
+        family = NFPROTO_BRIDGE;
+    else if (strcmp(argv[1], "arp") == 0)
+        family = NFPROTO_ARP;
+    else if (strcmp(argv[1], "unspec") == 0)
+        family = NFPROTO_UNSPEC;
+    else {
+        fprintf(stderr, "Unknown family: ip, ip6, bridge, arp, unspec\n");
+        exit(EXIT_FAILURE);
+    }
+
+    if (argc > 2)
+        table = argv[2];
+
+    if (argc > 3)
+        chain = argv[3];
+
+    /* XXX requires table, chain and handle attributes for selective get */
+
+    t = nftnl_rule_alloc();
+    if (t == NULL) {
+        perror("OOM");
+        exit(EXIT_FAILURE);
+    }
+
+    r = setup_rule(family, table, chain, NULL);
+
+    seq = time(NULL);
+    nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
+                    NLM_F_DUMP, seq);
+
+    nftnl_rule_nlmsg_build_payload(nlh, r);
+
+
+    nl = mnl_socket_open(NETLINK_NETFILTER);
+    if (nl == NULL) {
+        perror("mnl_socket_open");
+        exit(EXIT_FAILURE);
+    }
+
+    if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+        perror("mnl_socket_bind");
+        exit(EXIT_FAILURE);
+    }
+    portid = mnl_socket_get_portid(nl);
+
+    if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+        perror("mnl_socket_send");
+        exit(EXIT_FAILURE);
+    }
+
+    ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+    while (ret > 0) {
+        ret = mnl_cb_run(buf, ret, seq, portid, table_cb, &type);
+        if (ret <= 0)
+            break;
+        ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+    }
+    if (ret == -1) {
+        perror("error");
+        exit(EXIT_FAILURE);
+    }
+    mnl_socket_close(nl);
+
+    return EXIT_SUCCESS;
+}
