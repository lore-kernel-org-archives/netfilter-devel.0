From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] examples: delete compat stuff in nft-rule-add.c
Date: Tue, 10 Dec 2013 17:21:47 +0100
Message-ID: <20131210162147.25279.57019.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41313 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752802Ab3LJQV5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:21:57 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 9806C51ED5B
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2013 16:21:54 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cvq9U3IElQ0l for <netfilter-devel@vger.kernel.org>;
	Tue, 10 Dec 2013 17:21:48 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id C3FEB51ED53
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2013 17:21:48 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rework nft-rule-add.c to delete compat stuff.

A new rule is added of this kind:
 `nft rule add filter input tcp dport 22 counter'

While at it, implement batching support, given there is no other way to get
rules added to the kernel.
The bactching code is a copy of what you can find at nftables's src/mnl.c

I didn't delete so much batching code, so it can effectively serve as example.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-rule-add.c |  388 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 285 insertions(+), 103 deletions(-)

diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index f896bc0..1c6ea7c 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -14,116 +14,328 @@
 #include <string.h>
 #include <stddef.h>	/* for offsetof */
 #include <netinet/in.h>
+#include <netinet/ip.h>
 #include <arpa/inet.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <errno.h>
+#include <linux_list.h>
 
 #include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftables/rule.h>
 #include <libnftables/expr.h>
 
-#include <linux/netfilter_ipv4/ipt_LOG.h>
-#include <linux/netfilter/xt_iprange.h>
+static void *xmalloc(size_t size)
+{
+	void *ptr;
 
-#include <netinet/ip.h>
+	ptr = malloc(size);
+	if (ptr == NULL) {
+		perror("oom");
+		exit(EXIT_FAILURE);
+	}
+	return ptr;
+}
 
-static void add_target_log(struct nft_rule_expr *e)
+static void add_payload(struct nft_rule *r, uint32_t base, uint32_t dreg,
+			uint32_t offset, uint32_t len)
 {
-	struct ipt_log_info *info;
+	struct nft_rule_expr *e;
+
+	e = nft_rule_expr_alloc("payload");
+	if (e == NULL) {
+		perror("expr payload oom");
+		exit(EXIT_FAILURE);
+	}
 
-	nft_rule_expr_set(e, NFT_EXPR_TG_NAME, "LOG", strlen("LOG"));
-	nft_rule_expr_set_u32(e, NFT_EXPR_TG_REV, 0);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE, base);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, dreg);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET, offset);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, len);
 
-	info = calloc(1, sizeof(struct ipt_log_info));
-	if (info == NULL)
-		return;
+	nft_rule_add_expr(r, e);
+}
 
-	sprintf(info->prefix, "test: ");
-	info->prefix[sizeof(info->prefix)-1] = '\0';
-	info->logflags = 0x0f;
-	info->level = 5;
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
+
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
+
+	nft_rule_add_expr(r, e);
+}
+
+static struct nft_rule *new_rule(const char *table, const char *chain,
+				 uint32_t family)
+{
+	struct nft_rule *r = NULL;
+	uint8_t proto;
+	uint16_t dport;
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
+	/* protocol tcp */
+	proto = 6;
+	add_payload(r, NFT_PAYLOAD_NETWORK_HEADER, NFT_REG_1,
+		    offsetof(struct iphdr, protocol), 1);
+	add_cmp(r, NFT_REG_1, NFT_CMP_EQ, &proto, 1);
+
+	/* tcp dport 22 */
+	/* FIX: this needs further investigation: the value 5632 is 0x00001600
+	 * which is what the kernel understands as 22, instead of the more
+	 * natural value 0x00000016. Likely an endianness issue somewhere.
+	 */
+	dport = 5632;
+	add_payload(r, NFT_PAYLOAD_TRANSPORT_HEADER, NFT_REG_1, 2, 2);
+	add_cmp(r, NFT_REG_1, NFT_CMP_EQ, &dport, 2);
+
+	add_counter(r);
+
+	return r;
+}
+
+/*
+ * some netlink helpers
+ */
+
+static struct mnl_socket *nl_socket(void)
+{
+	struct mnl_socket *nl;
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
 
-	nft_rule_expr_set(e, NFT_EXPR_TG_INFO, info, sizeof(*info));
+	return nl;
 }
 
-static void add_expr_target(struct nft_rule *r)
+/*
+ * batching
+ */
+static int seq;
+
+static uint32_t mnl_seqnum_alloc(void)
 {
-	struct nft_rule_expr *expr;
+	return seq++;
+}
 
-	expr = nft_rule_expr_alloc("target");
-	if (expr == NULL)
-		return;
+/* selected batch page is 256 Kbytes long to load ruleset of
+ * half a million rules without hitting -EMSGSIZE due to large
+ * iovec.
+ */
+#define BATCH_PAGE_SIZE getpagesize() * 32
+
+static struct mnl_nlmsg_batch *batch;
 
-	add_target_log(expr);
+static struct mnl_nlmsg_batch *mnl_batch_alloc(void)
+{
+	static char *buf;
 
-	nft_rule_add_expr(r, expr);
+	/* libmnl needs higher buffer to handle batch overflows */
+	buf = xmalloc(BATCH_PAGE_SIZE + getpagesize());
+	return mnl_nlmsg_batch_start(buf, BATCH_PAGE_SIZE);
 }
 
-static void add_match_iprange(struct nft_rule_expr *e)
+static void mnl_batch_init(void)
 {
-	struct xt_iprange_mtinfo *info;
+	batch = mnl_batch_alloc();
+}
 
-	nft_rule_expr_set(e, NFT_EXPR_MT_NAME, "iprange", strlen("iprange"));
-	nft_rule_expr_set_u32(e, NFT_EXPR_MT_REV, 1);
+static LIST_HEAD(batch_page_list);
+static int batch_num_pages;
 
-	info = calloc(1, sizeof(struct xt_iprange_mtinfo));
-	if (info == NULL)
-		return;
+struct batch_page {
+	struct list_head	head;
+	struct mnl_nlmsg_batch *batch;
+};
 
-	info->src_min.ip = info->dst_min.ip = inet_addr("127.0.0.1");
-	info->src_max.ip = info->dst_max.ip = inet_addr("127.0.0.1");
-	info->flags = IPRANGE_SRC;
+static void mnl_batch_page_add(void)
+{
+	struct batch_page *batch_page;
 
-	nft_rule_expr_set(e, NFT_EXPR_MT_INFO, info, sizeof(*info));
+	batch_page = xmalloc(sizeof(struct batch_page));
+	batch_page->batch = batch;
+	list_add_tail(&batch_page->head, &batch_page_list);
+	batch_num_pages++;
+	batch = mnl_batch_alloc();
 }
 
-static void add_expr_match(struct nft_rule *r)
+static void mnl_batch_put(int type)
 {
-	struct nft_rule_expr *expr;
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
 
-	expr = nft_rule_expr_alloc("match");
-	if (expr == NULL)
-		return;
+	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh->nlmsg_type = type;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+	nlh->nlmsg_seq = mnl_seqnum_alloc();
 
-	add_match_iprange(expr);
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_INET;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = NFNL_SUBSYS_NFTABLES;
 
-	nft_rule_add_expr(r, expr);
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
 }
 
-#define field_sizeof(t, f)	(sizeof(((t *)NULL)->f))
+static void mnl_batch_begin(void)
+{
+	mnl_batch_put(NFNL_MSG_BATCH_BEGIN);
+}
 
-static void add_payload2(struct nft_rule_expr *e)
+static void mnl_batch_end(void)
 {
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE,
-			      NFT_PAYLOAD_NETWORK_HEADER);
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, NFT_REG_1);
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET,
-			      offsetof(struct iphdr, protocol));
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, 1);
+	mnl_batch_put(NFNL_MSG_BATCH_END);
 }
 
-static void add_payload(struct nft_rule *r)
+static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 {
-	struct nft_rule_expr *expr;
+	static const struct sockaddr_nl snl = {
+		.nl_family = AF_NETLINK
+	};
+	struct iovec iov[batch_num_pages];
+	struct msghdr msg = {
+		.msg_name	= (struct sockaddr *) &snl,
+		.msg_namelen	= sizeof(snl),
+		.msg_iov	= iov,
+		.msg_iovlen	= batch_num_pages,
+	};
+	struct batch_page *batch_page, *next;
+	int i = 0;
+
+	list_for_each_entry_safe(batch_page, next, &batch_page_list, head) {
+		iov[i].iov_base = mnl_nlmsg_batch_head(batch_page->batch);
+		iov[i].iov_len = mnl_nlmsg_batch_size(batch_page->batch);
+		i++;
+
+		/* uncomment to debug */
+		/*mnl_nlmsg_fprintf(stdout,
+				  mnl_nlmsg_batch_head(batch_page->batch),
+				  mnl_nlmsg_batch_size(batch_page->batch),
+				  sizeof(struct nfgenmsg));*/
+
+		list_del(&batch_page->head);
+		free(batch_page->batch);
+		free(batch_page);
+		batch_num_pages--;
+	}
 
-	expr = nft_rule_expr_alloc("payload");
-	if (expr == NULL)
-		return;
+	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
+}
 
-	add_payload2(expr);
+static int mnl_batch_talk(struct mnl_socket *nl)
+{
+	int ret, fd = mnl_socket_get_fd(nl);
+	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
+	fd_set readfds;
+	struct timeval tv = {
+		.tv_sec		= 0,
+		.tv_usec	= 0
+	};
+
+	if (!mnl_nlmsg_batch_is_empty(batch))
+		mnl_batch_page_add();
+
+	ret = mnl_nft_socket_sendmsg(nl);
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
+		/*ret = mnl_cb_run(rcv_buf, ret, 0, portid, NULL, NULL);*/
+
+		ret = select(fd+1, &readfds, NULL, NULL, &tv);
+		if (ret == -1)
+			goto err;
+
+		FD_ZERO(&readfds);
+		FD_SET(fd, &readfds);
+	}
+err:
+	mnl_nlmsg_batch_reset(batch);
+	return ret;
+}
 
-	nft_rule_add_expr(r, expr);
+static int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
+				  uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_NEWRULE,
+			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
+			flags|NLM_F_ACK|NLM_F_CREATE, seqnum);
+
+	nft_rule_nlmsg_build_payload(nlh, nlr);
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+
+	return 0;
 }
 
+/*
+ * finally, the main function
+ */
+
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
-	struct nft_rule *r = NULL;
-	int ret, family;
+	int family;
+	struct nft_rule *r;
+
 
 	if (argc != 4) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain>\n",
@@ -131,12 +343,6 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	r = nft_rule_alloc();
-	if (r == NULL) {
-		perror("OOM");
-		exit(EXIT_FAILURE);
-	}
-
 	if (strcmp(argv[1], "ip") == 0)
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
@@ -150,52 +356,28 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, argv[2]);
-	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, argv[3]);
 
-	add_expr_match(r);
-	add_payload(r);
-	add_expr_target(r);
+	r = new_rule(argv[2], argv[3], family);
+	if (nft_rule_fprintf(stdout, r, NFT_OUTPUT_DEFAULT, 0) < 0)
+		fprintf(stderr, "Error while printing the rule to stderr\n");
 
-	char tmp[1024];
-	nft_rule_snprintf(tmp, sizeof(tmp), r, 0, 0);
-	printf("%s\n", tmp);
+	nl = nl_socket();
 
-	seq = time(NULL);
-	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, family,
-					NLM_F_APPEND|NLM_F_ACK|NLM_F_CREATE,
-					seq);
-	nft_rule_nlmsg_build_payload(nlh, r);
-	nft_rule_free(r);
-
-	nl = mnl_socket_open(NETLINK_NETFILTER);
-	if (nl == NULL) {
-		perror("mnl_socket_open");
-		exit(EXIT_FAILURE);
-	}
+	mnl_batch_init();
+	mnl_batch_begin();
 
-	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		perror("mnl_socket_bind");
-		exit(EXIT_FAILURE);
-	}
-	portid = mnl_socket_get_portid(nl);
+	mnl_nft_rule_batch_add(r, NLM_F_APPEND, seq);
+	nft_rule_free(r);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
-		exit(EXIT_FAILURE);
-	}
+	mnl_batch_end();
 
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
-		if (ret <= 0)
-			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	}
-	if (ret == -1) {
+	if (mnl_batch_talk(nl) < 0) {
 		perror("error");
 		exit(EXIT_FAILURE);
 	}
+
+	free(mnl_nlmsg_batch_head(batch));
+	mnl_nlmsg_batch_stop(batch);
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

