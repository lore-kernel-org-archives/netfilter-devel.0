From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables-compat] iptables-compat: get rid of error reporting via perror
Date: Tue, 30 Sep 2014 19:45:29 +0200
Message-ID: <1412099129-9479-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54639 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbaI3RoT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:44:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The compat layer should report problems in the iptables way instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c                   |   80 +++++++++++---------------------------
 iptables/xtables-config-parser.y |   10 ++---
 iptables/xtables-events.c        |   30 +++++---------
 3 files changed, 35 insertions(+), 85 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index a4cea22..91e9133 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -61,10 +61,8 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	int ret;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 
-	if (mnl_socket_sendto(h->nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
+	if (mnl_socket_sendto(h->nl, nlh, nlh->nlmsg_len) < 0)
 		return -1;
-	}
 
 	ret = mnl_socket_recvfrom(h->nl, buf, sizeof(buf));
 	while (ret > 0) {
@@ -212,26 +210,21 @@ static int mnl_nft_batch_talk(struct nft_handle *h)
 	int err = 0;
 
 	ret = mnl_nft_socket_sendmsg(h->nl);
-	if (ret == -1) {
-		perror("mnl_socket_sendmsg");
+	if (ret == -1)
 		return -1;
-	}
 
 	FD_ZERO(&readfds);
 	FD_SET(fd, &readfds);
 
 	/* receive and digest all the acknowledgments from the kernel. */
 	ret = select(fd+1, &readfds, NULL, NULL, &tv);
-	if (ret == -1) {
-		perror("select");
+	if (ret == -1)
 		return -1;
-	}
+
 	while (ret > 0 && FD_ISSET(fd, &readfds)) {
 		ret = mnl_socket_recvfrom(h->nl, rcv_buf, sizeof(rcv_buf));
-		if (ret == -1) {
-			perror("mnl_socket_recvfrom");
+		if (ret == -1)
 			return -1;
-		}
 
 		ret = mnl_cb_run2(rcv_buf, ret, 0, h->portid,
 				  NULL, NULL, cb_ctl_array,
@@ -241,10 +234,9 @@ static int mnl_nft_batch_talk(struct nft_handle *h)
 			err = errno;
 
 		ret = select(fd+1, &readfds, NULL, NULL, &tv);
-		if (ret == -1) {
-			perror("select");
+		if (ret == -1)
 			return -1;
-		}
+
 		FD_ZERO(&readfds);
 		FD_SET(fd, &readfds);
 	}
@@ -727,15 +719,12 @@ err:
 int nft_init(struct nft_handle *h, struct builtin_table *t)
 {
 	h->nl = mnl_socket_open(NETLINK_NETFILTER);
-	if (h->nl == NULL) {
-		perror("mnl_socket_open");
+	if (h->nl == NULL)
 		return -1;
-	}
 
-	if (mnl_socket_bind(h->nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		perror("mnl_socket_bind");
+	if (mnl_socket_bind(h->nl, 0, MNL_SOCKET_AUTOPID) < 0)
 		return -1;
-	}
+
 	h->portid = mnl_socket_get_portid(h->nl);
 	h->tables = t;
 
@@ -1069,15 +1058,11 @@ static int nft_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_chain_list *list = data;
 
 	c = nft_chain_alloc();
-	if (c == NULL) {
-		perror("OOM");
+	if (c == NULL)
 		goto err;
-	}
 
-	if (nft_chain_nlmsg_parse(nlh, c) < 0) {
-		perror("nft_rule_nlmsg_parse");
+	if (nft_chain_nlmsg_parse(nlh, c) < 0)
 		goto out;
-	}
 
 	nft_chain_list_add_tail(c, list);
 
@@ -1175,15 +1160,11 @@ static int nft_rule_list_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_rule_list *list = data;
 
 	r = nft_rule_alloc();
-	if (r == NULL) {
-		perror("OOM");
+	if (r == NULL)
 		goto err;
-	}
 
-	if (nft_rule_nlmsg_parse(nlh, r) < 0) {
-		perror("nft_rule_nlmsg_parse");
+	if (nft_rule_nlmsg_parse(nlh, r) < 0)
 		goto out;
-	}
 
 	nft_rule_list_add_tail(r, list);
 
@@ -1511,15 +1492,11 @@ static int nft_table_list_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_table_list *list = data;
 
 	t = nft_table_alloc();
-	if (t == NULL) {
-		perror("OOM");
+	if (t == NULL)
 		goto err;
-	}
 
-	if (nft_table_nlmsg_parse(nlh, t) < 0) {
-		perror("nft_rule_nlmsg_parse");
+	if (nft_table_nlmsg_parse(nlh, t) < 0)
 		goto out;
-	}
 
 	nft_table_list_add_tail(t, list);
 
@@ -2309,8 +2286,6 @@ static int nft_action(struct nft_handle *h, int action)
 		h->batch = mnl_nft_batch_page_add(h->batch);
 
 	ret = mnl_nft_batch_talk(h);
-	if (ret < 0)
-		perror("mnl_nft_batch_talk:");
 
 	mnl_nlmsg_batch_reset(h->batch);
 
@@ -2359,33 +2334,24 @@ int nft_compatible_revision(const char *name, uint8_t rev, int opt)
 		name, rev, type);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
-	if (nl == NULL) {
-		perror("mnl_socket_open");
+	if (nl == NULL)
 		return 0;
-	}
 
-	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		perror("mnl_socket_bind");
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
 		goto err;
-	}
+
 	portid = mnl_socket_get_portid(nl);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
 		goto err;
-	}
 
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	if (ret == -1) {
-		perror("mnl_socket_recvfrom");
+	if (ret == -1)
 		goto err;
-	}
 
 	ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
-	if (ret == -1) {
-		perror("mnl_cb_run");
+	if (ret == -1)
 		goto err;
-	}
 
 err:
 	mnl_socket_close(nl);
@@ -2598,8 +2564,6 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 		nft_chain_nlmsg_build_payload(nlh, c);
 
 		ret = mnl_talk(h, nlh, NULL, NULL);
-		if (ret < 0)
-			perror("mnl_talk:nft_chain_zero_counters");
 
 		if (chain != NULL)
 			break;
diff --git a/iptables/xtables-config-parser.y b/iptables/xtables-config-parser.y
index 2770a1b..c8116c3 100644
--- a/iptables/xtables-config-parser.y
+++ b/iptables/xtables-config-parser.y
@@ -204,10 +204,9 @@ int xtables_config_parse(char *filename, struct nft_table_list *table_list,
 			break;
 		case T_TABLE:
 			table = nft_table_alloc();
-			if (table == NULL) {
-				perror("nft_table_alloc");
+			if (table == NULL)
 				return -1;
-			}
+
 			nft_table_attr_set_u32(table, NFT_TABLE_ATTR_FAMILY, family);
 			nft_table_attr_set(table, NFT_TABLE_ATTR_NAME, e->data);
 			/* This is intentionally prepending, instead of
@@ -222,10 +221,9 @@ int xtables_config_parse(char *filename, struct nft_table_list *table_list,
 			break;
 		case T_CHAIN:
 			chain = nft_chain_alloc();
-			if (chain == NULL) {
-				perror("nft_chain_alloc");
+			if (chain == NULL)
 				return -1;
-			}
+
 			nft_chain_attr_set(chain, NFT_CHAIN_ATTR_TABLE,
 				(char *)nft_table_attr_get(table, NFT_TABLE_ATTR_NAME));
 			nft_chain_attr_set_u32(chain, NFT_CHAIN_ATTR_FAMILY,
diff --git a/iptables/xtables-events.c b/iptables/xtables-events.c
index 4746825..1e0b175 100644
--- a/iptables/xtables-events.c
+++ b/iptables/xtables-events.c
@@ -34,15 +34,11 @@ static int table_cb(const struct nlmsghdr *nlh, int type)
 	char buf[4096];
 
 	t = nft_table_alloc();
-	if (t == NULL) {
-		perror("OOM");
+	if (t == NULL)
 		goto err;
-	}
 
-	if (nft_table_nlmsg_parse(nlh, t) < 0) {
-		perror("nft_table_nlmsg_parse");
+	if (nft_table_nlmsg_parse(nlh, t) < 0)
 		goto err_free;
-	}
 
 	nft_table_snprintf(buf, sizeof(buf), t, NFT_OUTPUT_DEFAULT, 0);
 	/* FIXME: define syntax to represent table events */
@@ -65,15 +61,11 @@ static int rule_cb(const struct nlmsghdr *nlh, int type)
 	uint8_t family;
 
 	r = nft_rule_alloc();
-	if (r == NULL) {
-		perror("OOM");
+	if (r == NULL)
 		goto err;
-	}
 
-	if (nft_rule_nlmsg_parse(nlh, r) < 0) {
-		perror("nft_rule_nlmsg_parse");
+	if (nft_rule_nlmsg_parse(nlh, r) < 0)
 		goto err_free;
-	}
 
 	family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
 	switch (family) {
@@ -109,15 +101,11 @@ static int chain_cb(const struct nlmsghdr *nlh, int type)
 	char buf[4096];
 
 	t = nft_chain_alloc();
-	if (t == NULL) {
-		perror("OOM");
+	if (t == NULL)
 		goto err;
-	}
 
-	if (nft_chain_nlmsg_parse(nlh, t) < 0) {
-		perror("nft_chain_nlmsg_parse");
+	if (nft_chain_nlmsg_parse(nlh, t) < 0)
 		goto err_free;
-	}
 
 	nft_chain_snprintf(buf, sizeof(buf), t, NFT_OUTPUT_DEFAULT, 0);
 	/* FIXME: define syntax to represent chain events */
@@ -198,12 +186,12 @@ int xtables_events_main(int argc, char *argv[])
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("cannot open nfnetlink socket");
 		exit(EXIT_FAILURE);
 	}
 
 	if (mnl_socket_bind(nl, (1 << (NFNLGRP_NFTABLES-1)), MNL_SOCKET_AUTOPID) < 0) {
-		perror("mnl_socket_bind");
+		perror("cannot bind to nfnetlink socket");
 		exit(EXIT_FAILURE);
 	}
 
@@ -215,7 +203,7 @@ int xtables_events_main(int argc, char *argv[])
 		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	}
 	if (ret == -1) {
-		perror("error");
+		perror("cannot receive from nfnetlink socket");
 		exit(EXIT_FAILURE);
 	}
 	mnl_socket_close(nl);
-- 
1.7.10.4

