From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: remove global nftnl_batch structure in mnl layer
Date: Mon, 29 May 2017 19:44:48 +0200
Message-ID: <1496079888-15768-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46746 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750844AbdE2RpA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 13:45:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E7D29DFE2C
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 19:44:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF2B8100A5E
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 19:44:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 275DFFF2DA
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 19:44:48 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The underlying mnl layer uses a global nftnl_batch structure. Instead,
pass pointer as parameter to the functions that need this. The netlink
layer stores a reference to this structure in struct netlink_ctx.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This is required by libnftables.

 include/mnl.h     |  53 +++++++++++------------
 include/netlink.h |   3 +-
 src/main.c        |  14 +++---
 src/mnl.c         | 125 ++++++++++++++++++++++++++++--------------------------
 src/netlink.c     |  39 +++++++++--------
 5 files changed, 124 insertions(+), 110 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 69dd0b744830..9d2d9410bda6 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -16,18 +16,19 @@ struct mnl_err {
 
 void mnl_err_list_free(struct mnl_err *err);
 
-void mnl_batch_init(void);
-bool mnl_batch_ready(void);
-void mnl_batch_reset(void);
-uint32_t mnl_batch_begin(void);
-void mnl_batch_end(void);
-int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list);
-int mnl_nft_rule_batch_add(struct nftnl_rule *nlr, unsigned int flags,
-			   uint32_t seqnum);
-int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, unsigned int flags,
-			   uint32_t seqnum);
-int mnl_nft_rule_batch_replace(struct nftnl_rule *nlr, unsigned int flags,
-			       uint32_t seqnum);
+struct nftnl_batch *mnl_batch_init(void);
+bool mnl_batch_ready(struct nftnl_batch *batch);
+void mnl_batch_reset(struct nftnl_batch *batch);
+uint32_t mnl_batch_begin(struct nftnl_batch *batch);
+void mnl_batch_end(struct nftnl_batch *batch);
+int mnl_batch_talk(struct mnl_socket *nl, struct nftnl_batch *batch,
+		   struct list_head *err_list);
+int mnl_nft_rule_batch_add(struct nftnl_rule *nlr, struct nftnl_batch *batch,
+			   unsigned int flags, uint32_t seqnum);
+int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, struct nftnl_batch *batch,
+			   unsigned int flags, uint32_t seqnum);
+int mnl_nft_rule_batch_replace(struct nftnl_rule *nlr, struct nftnl_batch *batch,
+			       unsigned int flags, uint32_t seqnum);
 
 int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nftnl_rule *r,
 		     unsigned int flags);
@@ -38,11 +39,11 @@ struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 
 int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
 		      unsigned int flags);
-int mnl_nft_chain_batch_add(struct nftnl_chain *nlc,
+int mnl_nft_chain_batch_add(struct nftnl_chain *nlc, struct nftnl_batch *batch,
 			    unsigned int flags, uint32_t seq);
 int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
                          unsigned int flags);
-int mnl_nft_chain_batch_del(struct nftnl_chain *nlc,
+int mnl_nft_chain_batch_del(struct nftnl_chain *nlc, struct nftnl_batch *batch,
 			    unsigned int flags, uint32_t seq);
 struct nftnl_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
 					  int family);
@@ -51,11 +52,11 @@ int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
 
 int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
 		      unsigned int flags);
-int mnl_nft_table_batch_add(struct nftnl_table *nlt,
+int mnl_nft_table_batch_add(struct nftnl_table *nlt, struct nftnl_batch *batch,
 			    unsigned int flags, uint32_t seq);
 int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
 			 unsigned int flags);
-int mnl_nft_table_batch_del(struct nftnl_table *nlt,
+int mnl_nft_table_batch_del(struct nftnl_table *nlt, struct nftnl_batch *batch,
 			    unsigned int flags, uint32_t seq);
 struct nftnl_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
 					  int family);
@@ -64,11 +65,11 @@ int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
 
 int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 		    unsigned int flags);
-int mnl_nft_set_batch_add(struct nftnl_set *nls,
+int mnl_nft_set_batch_add(struct nftnl_set *nls, struct nftnl_batch *batch,
 			  unsigned int flags, uint32_t seq);
 int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 		       unsigned int flags);
-int mnl_nft_set_batch_del(struct nftnl_set *nls,
+int mnl_nft_set_batch_del(struct nftnl_set *nls, struct nftnl_batch *batch,
 			  unsigned int flags, uint32_t seq);
 struct nftnl_set_list *mnl_nft_set_dump(struct mnl_socket *nf_sock, int family,
 				      const char *table);
@@ -76,23 +77,23 @@ int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nftnl_set *nls);
 
 int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 			unsigned int flags);
-int mnl_nft_setelem_batch_add(struct nftnl_set *nls,
+int mnl_nft_setelem_batch_add(struct nftnl_set *nls, struct nftnl_batch *batch,
 			      unsigned int flags, uint32_t seq);
 int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 			   unsigned int flags);
-int mnl_nft_setelem_batch_del(struct nftnl_set *nls,
+int mnl_nft_setelem_batch_del(struct nftnl_set *nls, struct nftnl_batch *batch,
 			      unsigned int flags, uint32_t seq);
-int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, unsigned int flags,
-				uint32_t seqnum);
+int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, struct nftnl_batch *batch,
+				unsigned int flags, uint32_t seqnum);
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls);
 
 struct nftnl_obj_list *mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family,
 					const char *table, const char *name,
 					uint32_t type, bool dump, bool reset);
-int mnl_nft_obj_batch_add(struct nftnl_obj *nln, unsigned int flags,
-			  uint32_t seqnum);
-int mnl_nft_obj_batch_del(struct nftnl_obj *nln, unsigned int flags,
-			  uint32_t seqnum);
+int mnl_nft_obj_batch_add(struct nftnl_obj *nln, struct nftnl_batch *batch,
+			  unsigned int flags, uint32_t seqnum);
+int mnl_nft_obj_batch_del(struct nftnl_obj *nln, struct nftnl_batch *batch,
+			  unsigned int flags, uint32_t seqnum);
 
 struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 					 uint32_t family);
diff --git a/include/netlink.h b/include/netlink.h
index d3fb8c5da33c..81538fff2424 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -45,6 +45,7 @@ struct netlink_ctx {
 	struct set		*set;
 	const void		*data;
 	uint32_t		seqnum;
+	struct nftnl_batch	*batch;
 	bool			batch_supported;
 };
 
@@ -186,7 +187,7 @@ extern void netlink_dump_expr(const struct nftnl_expr *nle);
 extern void netlink_dump_set(const struct nftnl_set *nls);
 extern void netlink_dump_obj(struct nftnl_obj *nlo);
 
-extern int netlink_batch_send(struct list_head *err_list);
+extern int netlink_batch_send(struct netlink_ctx *ctx, struct list_head *err_list);
 
 extern void netlink_genid_get(void);
 extern void netlink_restart(void);
diff --git a/src/main.c b/src/main.c
index 1cc8b39ff4ab..6dae817af40b 100644
--- a/src/main.c
+++ b/src/main.c
@@ -180,6 +180,7 @@ static const struct input_descriptor indesc_cmdline = {
 
 static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 {
+	struct nftnl_batch *batch;
 	struct netlink_ctx ctx;
 	struct cmd *cmd;
 	struct mnl_err *err, *tmp;
@@ -188,25 +189,26 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 	bool batch_supported = netlink_batch_supported();
 	int ret = 0;
 
-	mnl_batch_init();
+	batch = mnl_batch_init();
 
-	batch_seqnum = mnl_batch_begin();
+	batch_seqnum = mnl_batch_begin(batch);
 	list_for_each_entry(cmd, &state->cmds, list) {
 		memset(&ctx, 0, sizeof(ctx));
 		ctx.msgs = msgs;
 		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc();
+		ctx.batch = batch;
 		ctx.batch_supported = batch_supported;
 		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0)
 			goto out;
 	}
-	mnl_batch_end();
+	mnl_batch_end(batch);
 
-	if (!mnl_batch_ready())
+	if (!mnl_batch_ready(batch))
 		goto out;
 
-	ret = netlink_batch_send(&err_list);
+	ret = netlink_batch_send(&ctx, &err_list);
 
 	list_for_each_entry_safe(err, tmp, &err_list, head) {
 		list_for_each_entry(cmd, &state->cmds, list) {
@@ -225,7 +227,7 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 		}
 	}
 out:
-	mnl_batch_reset();
+	mnl_batch_reset(batch);
 	return ret;
 }
 
diff --git a/src/mnl.c b/src/mnl.c
index 295dd84a5840..da7c09067492 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -129,38 +129,40 @@ static int check_genid(const struct nlmsghdr *nlh)
  */
 #define BATCH_PAGE_SIZE getpagesize() * 32
 
-static struct nftnl_batch *batch;
-
-void mnl_batch_init(void)
+struct nftnl_batch *mnl_batch_init(void)
 {
+	struct nftnl_batch *batch;
+
 	batch = nftnl_batch_alloc(BATCH_PAGE_SIZE, NFT_NLMSG_MAXSIZE);
 	if (batch == NULL)
 		memory_allocation_error();
+
+	return batch;
 }
 
-static void mnl_nft_batch_continue(void)
+static void mnl_nft_batch_continue(struct nftnl_batch *batch)
 {
 	if (nftnl_batch_update(batch) < 0)
 		memory_allocation_error();
 }
 
-uint32_t mnl_batch_begin(void)
+uint32_t mnl_batch_begin(struct nftnl_batch *batch)
 {
 	uint32_t seq = mnl_seqnum_alloc();
 
 	nftnl_batch_begin(nftnl_batch_buffer(batch), seq);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return seq;
 }
 
-void mnl_batch_end(void)
+void mnl_batch_end(struct nftnl_batch *batch)
 {
 	nftnl_batch_end(nftnl_batch_buffer(batch), mnl_seqnum_alloc());
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 }
 
-bool mnl_batch_ready(void)
+bool mnl_batch_ready(struct nftnl_batch *batch)
 {
 	/* Check if the batch only contains the initial and trailing batch
 	 * messages. In that case, the batch is empty.
@@ -169,7 +171,7 @@ bool mnl_batch_ready(void)
 	       (NLMSG_HDRLEN + sizeof(struct nfgenmsg)) * 2;
 }
 
-void mnl_batch_reset(void)
+void mnl_batch_reset(struct nftnl_batch *batch)
 {
 	nftnl_batch_free(batch);
 }
@@ -192,7 +194,8 @@ void mnl_err_list_free(struct mnl_err *err)
 
 static int nlbuffsiz;
 
-static void mnl_set_sndbuffer(const struct mnl_socket *nl)
+static void mnl_set_sndbuffer(const struct mnl_socket *nl,
+			      struct nftnl_batch *batch)
 {
 	int newbuffsiz;
 
@@ -209,7 +212,8 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl)
 	nlbuffsiz = newbuffsiz;
 }
 
-static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
+static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl,
+				      struct nftnl_batch *batch)
 {
 	static const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
@@ -226,7 +230,7 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 	uint32_t i;
 #endif
 
-	mnl_set_sndbuffer(nl);
+	mnl_set_sndbuffer(nl, batch);
 	nftnl_batch_iovec(batch, iov, iov_len);
 
 #ifdef DEBUG
@@ -242,7 +246,8 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
 }
 
-int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
+int mnl_batch_talk(struct mnl_socket *nl, struct nftnl_batch *batch,
+		   struct list_head *err_list)
 {
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
 	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
@@ -252,7 +257,7 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
 		.tv_usec	= 0
 	};
 
-	ret = mnl_nft_socket_sendmsg(nl);
+	ret = mnl_nft_socket_sendmsg(nl, batch);
 	if (ret == -1)
 		return -1;
 
@@ -286,8 +291,8 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
 	return ret;
 }
 
-int mnl_nft_rule_batch_add(struct nftnl_rule *nlr, unsigned int flags,
-			   uint32_t seqnum)
+int mnl_nft_rule_batch_add(struct nftnl_rule *nlr, struct nftnl_batch *batch,
+			   unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -296,13 +301,13 @@ int mnl_nft_rule_batch_add(struct nftnl_rule *nlr, unsigned int flags,
 				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
 				    NLM_F_CREATE | flags, seqnum);
 	nftnl_rule_nlmsg_build_payload(nlh, nlr);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
 
-int mnl_nft_rule_batch_replace(struct nftnl_rule *nlr, unsigned int flags,
-			       uint32_t seqnum)
+int mnl_nft_rule_batch_replace(struct nftnl_rule *nlr, struct nftnl_batch *batch,
+			       unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -311,13 +316,13 @@ int mnl_nft_rule_batch_replace(struct nftnl_rule *nlr, unsigned int flags,
 				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
 				    NLM_F_REPLACE | flags, seqnum);
 	nftnl_rule_nlmsg_build_payload(nlh, nlr);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
 
-int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, unsigned int flags,
-			   uint32_t seqnum)
+int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, struct nftnl_batch *batch,
+			   unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -326,7 +331,7 @@ int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, unsigned int flags,
 				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
 				    0, seqnum);
 	nftnl_rule_nlmsg_build_payload(nlh, nlr);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
@@ -427,9 +432,8 @@ int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
 	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
-int mnl_nft_chain_batch_add(struct nftnl_chain *nlc, unsigned int flags,
-			    uint32_t seqnum)
-
+int mnl_nft_chain_batch_add(struct nftnl_chain *nlc, struct nftnl_batch *batch,
+			    unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -438,7 +442,7 @@ int mnl_nft_chain_batch_add(struct nftnl_chain *nlc, unsigned int flags,
 				    nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY),
 				    NLM_F_CREATE | flags, seqnum);
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
@@ -457,8 +461,8 @@ int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
 	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
-int mnl_nft_chain_batch_del(struct nftnl_chain *nlc, unsigned int flags,
-			    uint32_t seqnum)
+int mnl_nft_chain_batch_del(struct nftnl_chain *nlc, struct nftnl_batch *batch,
+			    unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -467,7 +471,7 @@ int mnl_nft_chain_batch_del(struct nftnl_chain *nlc, unsigned int flags,
 				    nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY),
 				    NLM_F_ACK, seqnum);
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
@@ -556,8 +560,8 @@ int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
 	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
-int mnl_nft_table_batch_add(struct nftnl_table *nlt, unsigned int flags,
-			    uint32_t seqnum)
+int mnl_nft_table_batch_add(struct nftnl_table *nlt, struct nftnl_batch *batch,
+			    unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -566,7 +570,7 @@ int mnl_nft_table_batch_add(struct nftnl_table *nlt, unsigned int flags,
 				    nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY),
 				    flags, seqnum);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
@@ -585,8 +589,8 @@ int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
 	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
-int mnl_nft_table_batch_del(struct nftnl_table *nlt, unsigned int flags,
-			    uint32_t seqnum)
+int mnl_nft_table_batch_del(struct nftnl_table *nlt, struct nftnl_batch *batch,
+			    unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -595,7 +599,7 @@ int mnl_nft_table_batch_del(struct nftnl_table *nlt, unsigned int flags,
 				    nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY),
 				    NLM_F_ACK, seqnum);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
@@ -706,8 +710,8 @@ int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
-int mnl_nft_set_batch_add(struct nftnl_set *nls, unsigned int flags,
-			  uint32_t seqnum)
+int mnl_nft_set_batch_add(struct nftnl_set *nls, struct nftnl_batch *batch,
+			  unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -716,13 +720,13 @@ int mnl_nft_set_batch_add(struct nftnl_set *nls, unsigned int flags,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
 				    NLM_F_CREATE | flags, seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
 
-int mnl_nft_set_batch_del(struct nftnl_set *nls, unsigned int flags,
-			  uint32_t seqnum)
+int mnl_nft_set_batch_del(struct nftnl_set *nls, struct nftnl_batch *batch,
+			  unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -731,7 +735,7 @@ int mnl_nft_set_batch_del(struct nftnl_set *nls, unsigned int flags,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
 				    flags, seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
@@ -793,8 +797,8 @@ err:
 	return NULL;
 }
 
-int mnl_nft_obj_batch_add(struct nftnl_obj *nln, unsigned int flags,
-			  uint32_t seqnum)
+int mnl_nft_obj_batch_add(struct nftnl_obj *nln, struct nftnl_batch *batch,
+			  unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -803,13 +807,13 @@ int mnl_nft_obj_batch_add(struct nftnl_obj *nln, unsigned int flags,
 				    nftnl_obj_get_u32(nln, NFTNL_OBJ_FAMILY),
 				    NLM_F_CREATE | flags, seqnum);
 	nftnl_obj_nlmsg_build_payload(nlh, nln);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
 
-int mnl_nft_obj_batch_del(struct nftnl_obj *nln, unsigned int flags,
-			  uint32_t seqnum)
+int mnl_nft_obj_batch_del(struct nftnl_obj *nln, struct nftnl_batch *batch,
+			  unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -818,7 +822,7 @@ int mnl_nft_obj_batch_del(struct nftnl_obj *nln, unsigned int flags,
 				    nftnl_obj_get_u32(nln, NFTNL_OBJ_FAMILY),
 				    flags, seqnum);
 	nftnl_obj_nlmsg_build_payload(nlh, nln);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
@@ -968,6 +972,7 @@ static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
 }
 
 static int mnl_nft_setelem_batch(struct nftnl_set *nls,
+				 struct nftnl_batch *batch,
 				 enum nf_tables_msg_types cmd,
 				 unsigned int flags, uint32_t seqnum)
 {
@@ -984,7 +989,7 @@ static int mnl_nft_setelem_batch(struct nftnl_set *nls,
 					    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
 					    NLM_F_CREATE | flags, seqnum);
 		ret = nftnl_set_elems_nlmsg_build_payload_iter(nlh, iter);
-		mnl_nft_batch_continue();
+		mnl_nft_batch_continue(batch);
 		if (ret <= 0)
 			break;
 	}
@@ -994,14 +999,15 @@ static int mnl_nft_setelem_batch(struct nftnl_set *nls,
 	return 0;
 }
 
-int mnl_nft_setelem_batch_add(struct nftnl_set *nls, unsigned int flags,
-			      uint32_t seqnum)
+int mnl_nft_setelem_batch_add(struct nftnl_set *nls, struct nftnl_batch *batch,
+			      unsigned int flags, uint32_t seqnum)
 {
-	return mnl_nft_setelem_batch(nls, NFT_MSG_NEWSETELEM, flags, seqnum);
+	return mnl_nft_setelem_batch(nls, batch, NFT_MSG_NEWSETELEM, flags,
+				     seqnum);
 }
 
-int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, unsigned int flags,
-				uint32_t seqnum)
+int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, struct nftnl_batch *batch,
+				unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -1010,15 +1016,16 @@ int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, unsigned int flags,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
 				    NLM_F_CREATE | flags, seqnum);
 	nftnl_set_elems_nlmsg_build_payload(nlh, nls);
-	mnl_nft_batch_continue();
+	mnl_nft_batch_continue(batch);
 
 	return 0;
 }
 
-int mnl_nft_setelem_batch_del(struct nftnl_set *nls, unsigned int flags,
-			      uint32_t seqnum)
+int mnl_nft_setelem_batch_del(struct nftnl_set *nls, struct nftnl_batch *batch,
+			      unsigned int flags, uint32_t seqnum)
 {
-	return mnl_nft_setelem_batch(nls, NFT_MSG_DELSETELEM, flags, seqnum);
+	return mnl_nft_setelem_batch(nls, batch, NFT_MSG_DELSETELEM, flags,
+				     seqnum);
 }
 
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls)
diff --git a/src/netlink.c b/src/netlink.c
index 28821903f18c..6fda0b97f3b3 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -447,7 +447,8 @@ int netlink_add_rule_batch(struct netlink_ctx *ctx,
 
 	nlr = alloc_nftnl_rule(&rule->handle);
 	netlink_linearize_rule(ctx, nlr, rule);
-	err = mnl_nft_rule_batch_add(nlr, flags | NLM_F_EXCL, ctx->seqnum);
+	err = mnl_nft_rule_batch_add(nlr, ctx->batch, flags | NLM_F_EXCL,
+				     ctx->seqnum);
 	nftnl_rule_free(nlr);
 	if (err < 0)
 		netlink_io_error(ctx, &rule->location,
@@ -465,7 +466,7 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 
 	nlr = alloc_nftnl_rule(&rule->handle);
 	netlink_linearize_rule(ctx, nlr, rule);
-	err = mnl_nft_rule_batch_replace(nlr, 0, ctx->seqnum);
+	err = mnl_nft_rule_batch_replace(nlr, ctx->batch, 0, ctx->seqnum);
 	nftnl_rule_free(nlr);
 
 	if (err < 0)
@@ -494,7 +495,7 @@ int netlink_del_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nlr = alloc_nftnl_rule(h);
-	err = mnl_nft_rule_batch_del(nlr, 0, ctx->seqnum);
+	err = mnl_nft_rule_batch_del(nlr, ctx->batch, 0, ctx->seqnum);
 	nftnl_rule_free(nlr);
 
 	if (err < 0)
@@ -651,7 +652,7 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 	}
 
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_batch_add(nlc, excl ? NLM_F_EXCL : 0,
+	err = mnl_nft_chain_batch_add(nlc, ctx->batch, excl ? NLM_F_EXCL : 0,
 				      ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -702,7 +703,7 @@ static int netlink_rename_chain_batch(struct netlink_ctx *ctx,
 	nlc = alloc_nftnl_chain(h);
 	nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, name);
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_batch_add(nlc, 0, ctx->seqnum);
+	err = mnl_nft_chain_batch_add(nlc, ctx->batch, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -747,7 +748,7 @@ static int netlink_del_chain_batch(struct netlink_ctx *ctx,
 
 	nlc = alloc_nftnl_chain(h);
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_batch_del(nlc, 0, ctx->seqnum);
+	err = mnl_nft_chain_batch_del(nlc, ctx->batch, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -927,7 +928,7 @@ static int netlink_add_table_batch(struct netlink_ctx *ctx,
 	else
 		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, 0);
 
-	err = mnl_nft_table_batch_add(nlt, excl ? NLM_F_EXCL : 0,
+	err = mnl_nft_table_batch_add(nlt, ctx->batch, excl ? NLM_F_EXCL : 0,
 				      ctx->seqnum);
 	nftnl_table_free(nlt);
 
@@ -972,7 +973,7 @@ static int netlink_del_table_batch(struct netlink_ctx *ctx,
 	int err;
 
 	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_batch_del(nlt, 0, ctx->seqnum);
+	err = mnl_nft_table_batch_del(nlt, ctx->batch, 0, ctx->seqnum);
 	nftnl_table_free(nlt);
 
 	if (err < 0)
@@ -1315,7 +1316,8 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 
 	netlink_dump_set(nls);
 
-	err = mnl_nft_set_batch_add(nls, excl ? NLM_F_EXCL : 0, ctx->seqnum);
+	err = mnl_nft_set_batch_add(nls, ctx->batch, excl ? NLM_F_EXCL : 0,
+				    ctx->seqnum);
 	if (err < 0)
 		netlink_io_error(ctx, &set->location, "Could not add set: %s",
 				 strerror(errno));
@@ -1358,7 +1360,7 @@ static int netlink_del_set_batch(struct netlink_ctx *ctx,
 	int err;
 
 	nls = alloc_nftnl_set(h);
-	err = mnl_nft_set_batch_del(nls, 0, ctx->seqnum);
+	err = mnl_nft_set_batch_del(nls, ctx->batch, 0, ctx->seqnum);
 	nftnl_set_free(nls);
 
 	if (err < 0)
@@ -1454,7 +1456,7 @@ static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_batch_add(nls, excl ? NLM_F_EXCL : 0,
+	err = mnl_nft_setelem_batch_add(nls, ctx->batch, excl ? NLM_F_EXCL : 0,
 					ctx->seqnum);
 	nftnl_set_free(nls);
 	if (err < 0)
@@ -1505,7 +1507,7 @@ static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
 		alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_batch_del(nls, 0, ctx->seqnum);
+	err = mnl_nft_setelem_batch_del(nls, ctx->batch, 0, ctx->seqnum);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1543,7 +1545,7 @@ int netlink_flush_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	nls = alloc_nftnl_set(h);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_batch_flush(nls, 0, ctx->seqnum);
+	err = mnl_nft_setelem_batch_flush(nls, ctx->batch, 0, ctx->seqnum);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, loc,
@@ -1772,7 +1774,8 @@ int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
 	nlo = alloc_nftnl_obj(h, obj);
 	netlink_dump_obj(nlo);
 
-	err = mnl_nft_obj_batch_add(nlo, excl ? NLM_F_EXCL : 0, ctx->seqnum);
+	err = mnl_nft_obj_batch_add(nlo, ctx->batch, excl ? NLM_F_EXCL : 0,
+				    ctx->seqnum);
 	if (err < 0)
 		netlink_io_error(ctx, &obj->location, "Could not add %s: %s",
 				 obj_type_name(obj->type), strerror(errno));
@@ -1790,7 +1793,7 @@ int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
 	nlo = __alloc_nftnl_obj(h, type);
 	netlink_dump_obj(nlo);
 
-	err = mnl_nft_obj_batch_del(nlo, 0, ctx->seqnum);
+	err = mnl_nft_obj_batch_del(nlo, ctx->batch, 0, ctx->seqnum);
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not delete %s: %s",
 				 obj_type_name(type), strerror(errno));
@@ -1894,9 +1897,9 @@ int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-int netlink_batch_send(struct list_head *err_list)
+int netlink_batch_send(struct netlink_ctx *ctx, struct list_head *err_list)
 {
-	return mnl_batch_talk(nf_sock, err_list);
+	return mnl_batch_talk(nf_sock, ctx->batch, err_list);
 }
 
 int netlink_flush_ruleset(struct netlink_ctx *ctx, const struct handle *h,
@@ -1909,7 +1912,7 @@ int netlink_flush_ruleset(struct netlink_ctx *ctx, const struct handle *h,
 		return netlink_io_error(ctx, loc, "Operation not supported");
 
 	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_batch_del(nlt, 0, ctx->seqnum);
+	err = mnl_nft_table_batch_del(nlt, ctx->batch, 0, ctx->seqnum);
 	nftnl_table_free(nlt);
 
 	if (err < 0)
-- 
2.1.4

