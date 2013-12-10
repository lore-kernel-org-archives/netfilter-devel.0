From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftables] examples: nft-rule-add: use existing batch infrastructure
Date: Tue, 10 Dec 2013 18:18:38 +0100
Message-ID: <1386695918-3623-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46281 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab3LJRSq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:18:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

This patch reworks the existing example to add the rule:

  nft add rule ip filter input tcp dport 22 counter

It uses the existing nfnl batching approach using the generic mnl
netlink message batching infrastructure. It also removed the code
that uses xtables compat code.

Based on original patch by Arturo Borrero Gonzalez.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/nft-rule-add.c             |  257 ++++++++++++++++++++---------------
 include/linux/netfilter/nfnetlink.h |    5 +
 2 files changed, 152 insertions(+), 110 deletions(-)

diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index f896bc0..0534fa5 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -14,126 +14,178 @@
 #include <string.h>
 #include <stddef.h>	/* for offsetof */
 #include <netinet/in.h>
+#include <netinet/ip.h>
+#include <netinet/tcp.h>
 #include <arpa/inet.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <errno.h>
 
 #include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftables/rule.h>
 #include <libnftables/expr.h>
 
-#include <linux/netfilter_ipv4/ipt_LOG.h>
-#include <linux/netfilter/xt_iprange.h>
-
-#include <netinet/ip.h>
-
-static void add_target_log(struct nft_rule_expr *e)
+static void add_payload(struct nft_rule *r, uint32_t base, uint32_t dreg,
+			uint32_t offset, uint32_t len)
 {
-	struct ipt_log_info *info;
+	struct nft_rule_expr *e;
 
-	nft_rule_expr_set(e, NFT_EXPR_TG_NAME, "LOG", strlen("LOG"));
-	nft_rule_expr_set_u32(e, NFT_EXPR_TG_REV, 0);
-
-	info = calloc(1, sizeof(struct ipt_log_info));
-	if (info == NULL)
-		return;
+	e = nft_rule_expr_alloc("payload");
+	if (e == NULL) {
+		perror("expr payload oom");
+		exit(EXIT_FAILURE);
+	}
 
-	sprintf(info->prefix, "test: ");
-	info->prefix[sizeof(info->prefix)-1] = '\0';
-	info->logflags = 0x0f;
-	info->level = 5;
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE, base);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, dreg);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET, offset);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, len);
 
-	nft_rule_expr_set(e, NFT_EXPR_TG_INFO, info, sizeof(*info));
+	nft_rule_add_expr(r, e);
 }
 
-static void add_expr_target(struct nft_rule *r)
+static void add_cmp(struct nft_rule *r, uint32_t sreg, uint32_t op,
+		    const void *data, uint32_t data_len)
 {
-	struct nft_rule_expr *expr;
+	struct nft_rule_expr *e;
 
-	expr = nft_rule_expr_alloc("target");
-	if (expr == NULL)
-		return;
+	e = nft_rule_expr_alloc("cmp");
+	if (e == NULL) {
+		perror("expr cmp oom");
+		exit(EXIT_FAILURE);
+	}
 
-	add_target_log(expr);
+	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_SREG, sreg);
+	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_OP, op);
+	nft_rule_expr_set(e, NFT_EXPR_CMP_DATA, data, data_len);
 
-	nft_rule_add_expr(r, expr);
+	nft_rule_add_expr(r, e);
 }
 
-static void add_match_iprange(struct nft_rule_expr *e)
+static void add_counter(struct nft_rule *r)
 {
-	struct xt_iprange_mtinfo *info;
-
-	nft_rule_expr_set(e, NFT_EXPR_MT_NAME, "iprange", strlen("iprange"));
-	nft_rule_expr_set_u32(e, NFT_EXPR_MT_REV, 1);
+	struct nft_rule_expr *e;
 
-	info = calloc(1, sizeof(struct xt_iprange_mtinfo));
-	if (info == NULL)
-		return;
-
-	info->src_min.ip = info->dst_min.ip = inet_addr("127.0.0.1");
-	info->src_max.ip = info->dst_max.ip = inet_addr("127.0.0.1");
-	info->flags = IPRANGE_SRC;
+	e = nft_rule_expr_alloc("counter");
+	if (e == NULL) {
+		perror("expr counter oom");
+		exit(EXIT_FAILURE);
+	}
 
-	nft_rule_expr_set(e, NFT_EXPR_MT_INFO, info, sizeof(*info));
+	nft_rule_add_expr(r, e);
 }
 
-static void add_expr_match(struct nft_rule *r)
+static struct nft_rule *setup_rule(uint8_t family, const char *table,
+				   const char *chain)
 {
-	struct nft_rule_expr *expr;
+	struct nft_rule *r = NULL;
+	uint8_t proto;
+	uint16_t dport;
 
-	expr = nft_rule_expr_alloc("match");
-	if (expr == NULL)
-		return;
+	r = nft_rule_alloc();
+	if (r == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
 
-	add_match_iprange(expr);
+	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, table);
+	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, chain);
+	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
 
-	nft_rule_add_expr(r, expr);
-}
+	proto = IPPROTO_TCP;
+	add_payload(r, NFT_PAYLOAD_NETWORK_HEADER, NFT_REG_1,
+		    offsetof(struct iphdr, protocol), sizeof(uint8_t));
+	add_cmp(r, NFT_REG_1, NFT_CMP_EQ, &proto, sizeof(uint8_t));
 
-#define field_sizeof(t, f)	(sizeof(((t *)NULL)->f))
+	dport = htons(22);
+	add_payload(r, NFT_PAYLOAD_TRANSPORT_HEADER, NFT_REG_1,
+		    offsetof(struct tcphdr, dest), sizeof(uint16_t));
+	add_cmp(r, NFT_REG_1, NFT_CMP_EQ, &dport, sizeof(uint16_t));
 
-static void add_payload2(struct nft_rule_expr *e)
-{
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE,
-			      NFT_PAYLOAD_NETWORK_HEADER);
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, NFT_REG_1);
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET,
-			      offsetof(struct iphdr, protocol));
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, 1);
+	add_counter(r);
+
+	return r;
 }
 
-static void add_payload(struct nft_rule *r)
+static int seq;
+
+static void nft_mnl_batch_put(struct mnl_nlmsg_batch *batch, int type)
 {
-	struct nft_rule_expr *expr;
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
 
-	expr = nft_rule_expr_alloc("payload");
-	if (expr == NULL)
-		return;
+	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh->nlmsg_type = type;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+	nlh->nlmsg_seq = seq++;
 
-	add_payload2(expr);
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_INET;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = NFNL_SUBSYS_NFTABLES;
 
-	nft_rule_add_expr(r, expr);
+	mnl_nlmsg_batch_next(batch);
+}
+
+static int nft_mnl_batch_talk(struct mnl_socket *nl, struct mnl_nlmsg_batch *b)
+{
+	int ret, fd = mnl_socket_get_fd(nl);
+	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
+	fd_set readfds;
+	struct timeval tv = {
+		.tv_sec		= 0,
+		.tv_usec	= 0
+	};
+
+	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(b),
+				mnl_nlmsg_batch_size(b));
+	if (ret == -1)
+		goto err;
+
+	FD_ZERO(&readfds);
+	FD_SET(fd, &readfds);
+
+	/* receive and digest all the acknowledgments from the kernel. */
+	ret = select(fd+1, &readfds, NULL, NULL, &tv);
+	if (ret == -1)
+		goto err;
+
+	while (ret > 0 && FD_ISSET(fd, &readfds)) {
+		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
+		if (ret == -1)
+			goto err;
+
+		ret = mnl_cb_run(rcv_buf, ret, 0, mnl_socket_get_portid(nl),
+				 NULL, NULL);
+		if (ret < 0)
+			goto err;
+
+		ret = select(fd+1, &readfds, NULL, NULL, &tv);
+		if (ret == -1)
+			goto err;
+
+		FD_ZERO(&readfds);
+		FD_SET(fd, &readfds);
+	}
+err:
+	return ret;
 }
 
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nft_rule *r;
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
-	struct nft_rule *r = NULL;
-	int ret, family;
+	struct mnl_nlmsg_batch *batch;
+	uint8_t family;
+	char buf[4096];
 
 	if (argc != 4) {
-		fprintf(stderr, "Usage: %s <family> <table> <chain>\n",
-			argv[0]);
-		exit(EXIT_FAILURE);
-	}
-
-	r = nft_rule_alloc();
-	if (r == NULL) {
-		perror("OOM");
+		fprintf(stderr, "Usage: %s <family> <table> <chain>\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
 
@@ -141,32 +193,12 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
-	else if (strcmp(argv[1], "bridge") == 0)
-		family = NFPROTO_BRIDGE;
-	else if (strcmp(argv[1], "arp") == 0)
-		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6\n");
 		exit(EXIT_FAILURE);
 	}
 
-	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, argv[2]);
-	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, argv[3]);
-
-	add_expr_match(r);
-	add_payload(r);
-	add_expr_target(r);
-
-	char tmp[1024];
-	nft_rule_snprintf(tmp, sizeof(tmp), r, 0, 0);
-	printf("%s\n", tmp);
-
-	seq = time(NULL);
-	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, family,
-					NLM_F_APPEND|NLM_F_ACK|NLM_F_CREATE,
-					seq);
-	nft_rule_nlmsg_build_payload(nlh, r);
-	nft_rule_free(r);
+	r = setup_rule(family, argv[2], argv[3]);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -178,24 +210,29 @@ int main(int argc, char *argv[])
 		perror("mnl_socket_bind");
 		exit(EXIT_FAILURE);
 	}
-	portid = mnl_socket_get_portid(nl);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
-		exit(EXIT_FAILURE);
-	}
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
-		if (ret <= 0)
-			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	}
-	if (ret == -1) {
-		perror("error");
+	nft_mnl_batch_put(batch, NFNL_MSG_BATCH_BEGIN);
+
+	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_NEWRULE,
+			nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY),
+			NLM_F_APPEND|NLM_F_CREATE, seq);
+
+	nft_rule_nlmsg_build_payload(nlh, r);
+	nft_rule_free(r);
+	mnl_nlmsg_batch_next(batch);
+
+	nft_mnl_batch_put(batch, NFNL_MSG_BATCH_END);
+
+	if (nft_mnl_batch_talk(nl, batch) < 0) {
+		perror("Netlink problem");
 		exit(EXIT_FAILURE);
 	}
+
+	mnl_nlmsg_batch_stop(batch);
+
 	mnl_socket_close(nl);
 
 	return EXIT_SUCCESS;
diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 91eebab..336c10c 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -97,4 +97,9 @@ extern void nfnl_unlock(void);
 	MODULE_ALIAS("nfnetlink-subsys-" __stringify(subsys))
 
 #endif	/* __KERNEL__ */
+
+/* Reserved control nfnetlink messages */
+#define NFNL_MSG_BATCH_BEGIN            NLMSG_MIN_TYPE
+#define NFNL_MSG_BATCH_END              NLMSG_MIN_TYPE+1
+
 #endif	/* _NFNETLINK_H */
-- 
1.7.10.4

