From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: make netlink sequence number non-static
Date: Tue, 15 Aug 2017 14:02:28 +0200
Message-ID: <1502798548-24748-1-git-send-email-pablo@netfilter.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752556AbdHOMCy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2017 08:02:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7FB1DD25FE
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Aug 2017 14:02:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6533CDA2D0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Aug 2017 14:02:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40659A7F36
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Aug 2017 14:02:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Place sequence number that is allocated per-command on the struct
netlink_ctx structure. This is allocated from nft_run() to correlate
commands with netlink messages for error reporting. Batch support
probing also shares this sequence numbers with commands.

There is an inpendent cache sequence number though, this routine is
called from a different path, usually from the evaluation phase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h      |  69 ++++++++++----------
 include/netlink.h  |   4 +-
 include/nftables.h |   1 +
 include/rule.h     |   2 +
 src/main.c         |  10 +--
 src/mnl.c          | 187 +++++++++++++++++++++++++++++------------------------
 src/netlink.c      |  54 ++++++++--------
 src/rule.c         |   3 +-
 8 files changed, 177 insertions(+), 153 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 31dff2c2dd2c..7df08236f8ab 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -9,8 +9,8 @@ struct mnl_socket;
 struct mnl_socket *netlink_open_sock(void);
 void netlink_close_sock(struct mnl_socket *nf_sock);
 
-uint32_t mnl_seqnum_alloc(void);
-void mnl_genid_get(struct mnl_socket *nf_sock);
+uint32_t mnl_seqnum_alloc(uint32_t *seqnum);
+void mnl_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum);
 
 struct mnl_err {
 	struct list_head	head;
@@ -23,8 +23,8 @@ void mnl_err_list_free(struct mnl_err *err);
 struct nftnl_batch *mnl_batch_init(void);
 bool mnl_batch_ready(struct nftnl_batch *batch);
 void mnl_batch_reset(struct nftnl_batch *batch);
-uint32_t mnl_batch_begin(struct nftnl_batch *batch);
-void mnl_batch_end(struct nftnl_batch *batch);
+uint32_t mnl_batch_begin(struct nftnl_batch *batch, uint32_t seqnum);
+void mnl_batch_end(struct nftnl_batch *batch, uint32_t seqnum);
 int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list);
 int mnl_nft_rule_batch_add(struct nftnl_rule *nlr, struct nftnl_batch *batch,
 			   unsigned int flags, uint32_t seqnum);
@@ -34,76 +34,79 @@ int mnl_nft_rule_batch_replace(struct nftnl_rule *nlr, struct nftnl_batch *batch
 			       unsigned int flags, uint32_t seqnum);
 
 int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nftnl_rule *r,
-		     unsigned int flags);
+		     unsigned int flags, uint32_t seqnum);
 int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nftnl_rule *r,
-			unsigned int flags);
+			unsigned int flags, uint32_t seqnum);
 struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
-					int family);
+					  int family, uint32_t seqnum);
 
 int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-		      unsigned int flags);
+		      unsigned int flags, uint32_t seqnum);
 int mnl_nft_chain_batch_add(struct nftnl_chain *nlc, struct nftnl_batch *batch,
-			    unsigned int flags, uint32_t seq);
+			    unsigned int flags, uint32_t seqnum);
 int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-                         unsigned int flags);
+                         unsigned int flags, uint32_t seqnum);
 int mnl_nft_chain_batch_del(struct nftnl_chain *nlc, struct nftnl_batch *batch,
-			    unsigned int flags, uint32_t seq);
+			    unsigned int flags, uint32_t seqnum);
 struct nftnl_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
-					  int family);
+					    int family, uint32_t seqnum);
 int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-		      unsigned int flags);
+		      unsigned int flags, uint32_t seqnum);
 
 int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-		      unsigned int flags);
+		      unsigned int flags, uint32_t seqnum);
 int mnl_nft_table_batch_add(struct nftnl_table *nlt, struct nftnl_batch *batch,
-			    unsigned int flags, uint32_t seq);
+			    unsigned int flags, uint32_t seqnum);
 int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-			 unsigned int flags);
+			 unsigned int flags, uint32_t seqnum);
 int mnl_nft_table_batch_del(struct nftnl_table *nlt, struct nftnl_batch *batch,
-			    unsigned int flags, uint32_t seq);
+			    unsigned int flags, uint32_t seqnum);
 struct nftnl_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
-					  int family);
+					    int family, uint32_t seqnum);
 int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-		      unsigned int flags);
+		      unsigned int flags, uint32_t seqnum);
 
 int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-		    unsigned int flags);
+		    unsigned int flags, uint32_t seqnum);
 int mnl_nft_set_batch_add(struct nftnl_set *nls, struct nftnl_batch *batch,
-			  unsigned int flags, uint32_t seq);
+			  unsigned int flags, uint32_t seqnum);
 int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-		       unsigned int flags);
+		       unsigned int flags, uint32_t seqnum);
 int mnl_nft_set_batch_del(struct nftnl_set *nls, struct nftnl_batch *batch,
-			  unsigned int flags, uint32_t seq);
+			  unsigned int flags, uint32_t seqnum);
 struct nftnl_set_list *mnl_nft_set_dump(struct mnl_socket *nf_sock, int family,
-				      const char *table);
-int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nftnl_set *nls);
+					const char *table, uint32_t seqnum);
+int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nftnl_set *nls,
+		    uint32_t seqnum);
 
 int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-			unsigned int flags);
+			unsigned int flags, uint32_t seqnum);
 int mnl_nft_setelem_batch_add(struct nftnl_set *nls, struct nftnl_batch *batch,
-			      unsigned int flags, uint32_t seq);
+			      unsigned int flags, uint32_t seqnum);
 int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-			   unsigned int flags);
+			   unsigned int flags, uint32_t seqnum);
 int mnl_nft_setelem_batch_del(struct nftnl_set *nls, struct nftnl_batch *batch,
 			      unsigned int flags, uint32_t seq);
 int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, struct nftnl_batch *batch,
 				unsigned int flags, uint32_t seqnum);
-int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls);
+int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls,
+			uint32_t seqnum);
 
 struct nftnl_obj_list *mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family,
-					const char *table, const char *name,
-					uint32_t type, bool dump, bool reset);
+					uint32_t seqnum, const char *table,
+					const char *name, uint32_t type,
+					bool dump, bool reset);
 int mnl_nft_obj_batch_add(struct nftnl_obj *nln, struct nftnl_batch *batch,
 			  unsigned int flags, uint32_t seqnum);
 int mnl_nft_obj_batch_del(struct nftnl_obj *nln, struct nftnl_batch *batch,
 			  unsigned int flags, uint32_t seqnum);
 
 struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
-					 uint32_t family);
+					   uint32_t family, uint32_t seqnum);
 int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 			   int (*cb)(const struct nlmsghdr *nlh, void *data),
 			   void *cb_data);
 
-bool mnl_batch_supported(struct mnl_socket *nf_sock);
+bool mnl_batch_supported(struct mnl_socket *nf_sock, uint32_t *seqnum);
 
 #endif /* _NFTABLES_MNL_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index 3726171424c3..0e1d26b6d5b8 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -195,7 +195,7 @@ extern void netlink_dump_obj(struct nftnl_obj *nlo);
 
 extern int netlink_batch_send(struct netlink_ctx *ctx, struct list_head *err_list);
 
-extern void netlink_genid_get(struct mnl_socket *nf_sock);
+extern void netlink_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum);
 extern void netlink_restart(struct mnl_socket *nf_sock);
 #define netlink_abi_error()	\
 	__netlink_abi_error(__FILE__, __LINE__, strerror(errno));
@@ -224,7 +224,7 @@ struct netlink_mon_handler {
 
 extern int netlink_monitor(struct netlink_mon_handler *monhandler,
 			    struct mnl_socket *nf_sock);
-bool netlink_batch_supported(struct mnl_socket *nf_sock);
+bool netlink_batch_supported(struct mnl_socket *nf_sock, uint32_t *seqnum);
 
 int netlink_echo_callback(const struct nlmsghdr *nlh, void *data);
 
diff --git a/include/nftables.h b/include/nftables.h
index a88c86d1d16e..a457aba62ee8 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -40,6 +40,7 @@ struct nft_ctx {
 struct nft_cache {
 	bool			initialized;
 	struct list_head	list;
+	uint32_t		seqnum;
 };
 
 extern unsigned int max_errors;
diff --git a/include/rule.h b/include/rule.h
index 10ac0e26accc..f9de8367a01e 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -470,6 +470,7 @@ extern void cmd_free(struct cmd *cmd);
  * @set:	current set
  * @stmt:	current statement
  * @cache:	cache context
+ * @seqnum:	netlink sequence number
  * @ectx:	expression context
  * @pctx:	payload context
  */
@@ -482,6 +483,7 @@ struct eval_ctx {
 	struct set		*set;
 	struct stmt		*stmt;
 	struct nft_cache	*cache;
+	uint32_t		seqnum;
 	struct expr_ctx		ectx;
 	struct proto_ctx	pctx;
 };
diff --git a/src/main.c b/src/main.c
index 2e77ee0ab68d..888395981d42 100644
--- a/src/main.c
+++ b/src/main.c
@@ -191,22 +191,22 @@ static int nft_netlink(struct nft_ctx *nft, struct nft_cache *cache,
 		       struct parser_state *state, struct list_head *msgs,
 		       struct mnl_socket *nf_sock)
 {
+	uint32_t batch_seqnum, seqnum = 0;
 	struct nftnl_batch *batch;
 	struct netlink_ctx ctx;
 	struct cmd *cmd;
 	struct mnl_err *err, *tmp;
 	LIST_HEAD(err_list);
-	uint32_t batch_seqnum;
-	bool batch_supported = netlink_batch_supported(nf_sock);
+	bool batch_supported = netlink_batch_supported(nf_sock, &seqnum);
 	int ret = 0;
 
 	batch = mnl_batch_init();
 
-	batch_seqnum = mnl_batch_begin(batch);
+	batch_seqnum = mnl_batch_begin(batch, mnl_seqnum_alloc(&seqnum));
 	list_for_each_entry(cmd, &state->cmds, list) {
 		memset(&ctx, 0, sizeof(ctx));
 		ctx.msgs = msgs;
-		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc();
+		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
 		ctx.batch = batch;
 		ctx.batch_supported = batch_supported;
 		ctx.octx = &nft->output;
@@ -218,7 +218,7 @@ static int nft_netlink(struct nft_ctx *nft, struct nft_cache *cache,
 			goto out;
 	}
 	if (!nft->check)
-		mnl_batch_end(batch);
+		mnl_batch_end(batch, mnl_seqnum_alloc(&seqnum));
 
 	if (!mnl_batch_ready(batch))
 		goto out;
diff --git a/src/mnl.c b/src/mnl.c
index 5017b81c96e7..b0f5191313e6 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -30,11 +30,9 @@
 #include <utils.h>
 #include <nftables.h>
 
-static int seq;
-
-uint32_t mnl_seqnum_alloc(void)
+uint32_t mnl_seqnum_alloc(unsigned int *seqnum)
 {
-	return seq++;
+	return *seqnum++;
 }
 
 /* The largest nf_tables netlink message is the set element message, which
@@ -68,7 +66,8 @@ out:
 }
 
 static int
-nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
+nft_mnl_talk(struct mnl_socket *nf_sock, const void *data,
+	     unsigned int len, uint32_t seqnum,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
 {
 	uint32_t portid = mnl_socket_get_portid(nf_sock);
@@ -81,7 +80,7 @@ nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
 	if (mnl_socket_sendto(nf_sock, data, len) < 0)
 		return -1;
 
-	return nft_mnl_recv(nf_sock, seq, portid, cb, cb_data);
+	return nft_mnl_recv(nf_sock, seqnum, portid, cb, cb_data);
 }
 
 /*
@@ -98,14 +97,14 @@ static int genid_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-void mnl_genid_get(struct mnl_socket *nf_sock)
+void mnl_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, AF_UNSPEC, 0, seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, AF_UNSPEC, 0, seqnum);
 	/* Skip error checking, old kernels sets res_id field to zero. */
-	nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, genid_cb, NULL);
+	nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, genid_cb, NULL);
 }
 
 static int check_genid(const struct nlmsghdr *nlh)
@@ -146,19 +145,17 @@ static void mnl_nft_batch_continue(struct nftnl_batch *batch)
 		memory_allocation_error();
 }
 
-uint32_t mnl_batch_begin(struct nftnl_batch *batch)
+uint32_t mnl_batch_begin(struct nftnl_batch *batch, uint32_t seqnum)
 {
-	uint32_t seq = mnl_seqnum_alloc();
-
-	nftnl_batch_begin(nftnl_batch_buffer(batch), seq);
+	nftnl_batch_begin(nftnl_batch_buffer(batch), seqnum);
 	mnl_nft_batch_continue(batch);
 
-	return seq;
+	return seqnum;
 }
 
-void mnl_batch_end(struct nftnl_batch *batch)
+void mnl_batch_end(struct nftnl_batch *batch, uint32_t seqnum)
 {
-	nftnl_batch_end(nftnl_batch_buffer(batch), mnl_seqnum_alloc());
+	nftnl_batch_end(nftnl_batch_buffer(batch), seqnum);
 	mnl_nft_batch_continue(batch);
 }
 
@@ -340,31 +337,31 @@ int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, struct nftnl_batch *batch,
  * Rule
  */
 int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nftnl_rule *nlr,
-		     unsigned int flags)
+		     unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
 				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
-				    NLM_F_ACK | NLM_F_CREATE | flags, seq);
+				    NLM_F_ACK | NLM_F_CREATE | flags, seqnum);
 	nftnl_rule_nlmsg_build_payload(nlh, nlr);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
 }
 
 int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nftnl_rule *nlr,
-			unsigned int flags)
+			unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELRULE,
 				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
-				    NLM_F_ACK, seq);
+				    NLM_F_ACK, seqnum);
 	nftnl_rule_nlmsg_build_payload(nlh, nlr);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
 }
 
 static int rule_cb(const struct nlmsghdr *nlh, void *data)
@@ -390,7 +387,8 @@ err_free:
 	return MNL_CB_OK;
 }
 
-struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock, int family)
+struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
+					  int family, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -402,9 +400,10 @@ struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock, int family
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
-				    NLM_F_DUMP, seq);
+				    NLM_F_DUMP, seqnum);
 
-	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, rule_cb,
+			   nlr_list);
 	if (ret < 0)
 		goto err;
 
@@ -418,7 +417,7 @@ err:
  * Chain
  */
 int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-		      unsigned int flags)
+		      unsigned int flags, uint32_t seqnum)
 
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
@@ -426,10 +425,10 @@ int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
 				    nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY),
-				    NLM_F_CREATE | NLM_F_ACK | flags, seq);
+				    NLM_F_CREATE | NLM_F_ACK | flags, seqnum);
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
 }
 
 int mnl_nft_chain_batch_add(struct nftnl_chain *nlc, struct nftnl_batch *batch,
@@ -448,17 +447,17 @@ int mnl_nft_chain_batch_add(struct nftnl_chain *nlc, struct nftnl_batch *batch,
 }
 
 int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-			 unsigned int flags)
+			 unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN,
 				    nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY),
-				    NLM_F_ACK, seq);
+				    NLM_F_ACK, seqnum);
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
 }
 
 int mnl_nft_chain_batch_del(struct nftnl_chain *nlc, struct nftnl_batch *batch,
@@ -499,7 +498,8 @@ err_free:
 	return MNL_CB_OK;
 }
 
-struct nftnl_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock, int family)
+struct nftnl_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
+					    int family, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -511,9 +511,10 @@ struct nftnl_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock, int fami
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
-				    NLM_F_DUMP, seq);
+				    NLM_F_DUMP, seqnum);
 
-	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, chain_cb,
+			   nlc_list);
 	if (ret < 0)
 		goto err;
 
@@ -530,34 +531,35 @@ static int chain_get_cb(const struct nlmsghdr *nlh, void *data)
 }
 
 int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-		      unsigned int flags)
+		      unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN,
 				    nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY),
-				    NLM_F_ACK | flags, seq);
+				    seqnum, NLM_F_ACK | flags);
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, chain_get_cb, nlc);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, chain_get_cb,
+			    nlc);
 }
 
 /*
  * Table
  */
 int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-		      unsigned int flags)
+		      unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE,
 				    nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY),
-				    NLM_F_ACK | flags, seq);
+				    NLM_F_ACK | flags, seqnum);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
 }
 
 int mnl_nft_table_batch_add(struct nftnl_table *nlt, struct nftnl_batch *batch,
@@ -576,17 +578,17 @@ int mnl_nft_table_batch_add(struct nftnl_table *nlt, struct nftnl_batch *batch,
 }
 
 int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-		      unsigned int flags)
+			 unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELTABLE,
 				    nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY),
-				    NLM_F_ACK, seq);
+				    NLM_F_ACK, seqnum);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
 }
 
 int mnl_nft_table_batch_del(struct nftnl_table *nlt, struct nftnl_batch *batch,
@@ -627,7 +629,8 @@ err_free:
 	return MNL_CB_OK;
 }
 
-struct nftnl_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock, int family)
+struct nftnl_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
+					    int family, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -639,9 +642,10 @@ struct nftnl_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock, int fami
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
-				    NLM_F_DUMP, seq);
+				    NLM_F_DUMP, seqnum);
 
-	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_cb, nlt_list);
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, table_cb,
+			   nlt_list);
 	if (ret < 0)
 		goto err;
 
@@ -660,17 +664,18 @@ static int table_get_cb(const struct nlmsghdr *nlh, void *data)
 }
 
 int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-		      unsigned int flags)
+		      unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE,
 				    nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY),
-				    NLM_F_ACK, seq);
+				    NLM_F_ACK, seqnum);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_get_cb, nlt);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, table_get_cb,
+			    nlt);
 }
 
 /*
@@ -683,31 +688,32 @@ static int set_add_cb(const struct nlmsghdr *nlh, void *data)
 }
 
 int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-		    unsigned int flags)
+		    unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWSET,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    NLM_F_CREATE | NLM_F_ACK | flags, seq);
+				    NLM_F_CREATE | NLM_F_ACK | flags, seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_add_cb, nls);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum,
+			    set_add_cb, nls);
 }
 
 int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-		       unsigned int flags)
+		       unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELSET,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    flags | NLM_F_ACK, seq);
+				    flags | NLM_F_ACK, seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
 }
 
 int mnl_nft_set_batch_add(struct nftnl_set *nls, struct nftnl_batch *batch,
@@ -764,7 +770,8 @@ err_free:
 }
 
 struct nftnl_set_list *
-mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
+mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table,
+		 uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -777,7 +784,7 @@ mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
-				    NLM_F_DUMP | NLM_F_ACK, seq);
+				    NLM_F_DUMP | NLM_F_ACK, seqnum);
 	if (table != NULL)
 		nftnl_set_set(s, NFTNL_SET_TABLE, table);
 	nftnl_set_nlmsg_build_payload(nlh, s);
@@ -787,7 +794,8 @@ mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
 	if (nls_list == NULL)
 		memory_allocation_error();
 
-	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_cb, nls_list);
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, set_cb,
+			   nls_list);
 	if (ret < 0)
 		goto err;
 
@@ -852,8 +860,9 @@ err_free:
 
 
 struct nftnl_obj_list *
-mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, const char *table,
-		 const char *name,  uint32_t type, bool dump, bool reset)
+mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, uint32_t seqnum,
+		 const char *table, const char *name,  uint32_t type, bool dump,
+		 bool reset)
 {
 	uint16_t nl_flags = dump ? NLM_F_DUMP : 0;
 	struct nftnl_obj_list *nln_list;
@@ -872,7 +881,7 @@ mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, const char *table,
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, msg_type, family,
-				    nl_flags | NLM_F_ACK, seq);
+				    nl_flags | NLM_F_ACK, seqnum);
 	if (table != NULL)
 		nftnl_obj_set_str(n, NFTNL_OBJ_TABLE, table);
 	if (name != NULL)
@@ -886,7 +895,8 @@ mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, const char *table,
 	if (nln_list == NULL)
 		memory_allocation_error();
 
-	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, obj_cb, nln_list);
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, obj_cb,
+			   nln_list);
 	if (ret < 0)
 		goto err;
 
@@ -904,24 +914,26 @@ static int set_get_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nftnl_set *nls)
+int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nftnl_set *nls,
+		    uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSET,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    NLM_F_ACK, seq);
+				    NLM_F_ACK, seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_get_cb, nls);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, set_get_cb,
+			    nls);
 }
 
 /*
  * Set elements
  */
 int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-			unsigned int flags)
+			unsigned int flags, uint32_t seqnum)
 {
 	char buf[NFT_NLMSG_MAXSIZE];
 	struct nlmsghdr *nlh;
@@ -936,9 +948,10 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM,
 					    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
 					    NLM_F_CREATE | NLM_F_ACK | flags,
-					    seq);
+					    seqnum);
 		ret = nftnl_set_elems_nlmsg_build_payload_iter(nlh, iter);
-		err = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+		err = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum,
+				   NULL, NULL);
 		if (ret <= 0 || err < 0)
 			break;
 	}
@@ -949,17 +962,17 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 }
 
 int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-			   unsigned int flags)
+			   unsigned int flags, uint32_t seqnum)
 {
 	char buf[NFT_NLMSG_MAXSIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELSETELEM,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    NLM_F_ACK, seq);
+				    NLM_F_ACK, seqnum);
 	nftnl_set_elems_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
 }
 
 static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
@@ -1028,24 +1041,26 @@ int mnl_nft_setelem_batch_del(struct nftnl_set *nls, struct nftnl_batch *batch,
 				     seqnum);
 }
 
-int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls)
+int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls,
+			uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    NLM_F_DUMP|NLM_F_ACK, seq);
+				    NLM_F_DUMP|NLM_F_ACK, seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_elem_cb, nls);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, set_elem_cb,
+			    nls);
 }
 
 /*
  * ruleset
  */
 struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
-					 uint32_t family)
+					   uint32_t family, uint32_t seqnum)
 {
 	struct nftnl_ruleset *rs;
 	struct nftnl_table_list *t;
@@ -1060,26 +1075,26 @@ struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 	if (rs == NULL)
 		memory_allocation_error();
 
-	t = mnl_nft_table_dump(nf_sock, family);
+	t = mnl_nft_table_dump(nf_sock, family, seqnum);
 	if (t == NULL)
 		goto err;
 
 	nftnl_ruleset_set(rs, NFTNL_RULESET_TABLELIST, t);
 
-	c = mnl_nft_chain_dump(nf_sock, family);
+	c = mnl_nft_chain_dump(nf_sock, family, seqnum);
 	if (c == NULL)
 		goto err;
 
 	nftnl_ruleset_set(rs, NFTNL_RULESET_CHAINLIST, c);
 
-	sl = mnl_nft_set_dump(nf_sock, family, NULL);
+	sl = mnl_nft_set_dump(nf_sock, family, NULL, seqnum);
 	if (sl == NULL)
 		goto err;
 
 	i = nftnl_set_list_iter_create(sl);
 	s = nftnl_set_list_iter_next(i);
 	while (s != NULL) {
-		ret = mnl_nft_setelem_get(nf_sock, s);
+		ret = mnl_nft_setelem_get(nf_sock, s, seqnum);
 		if (ret < 0)
 			goto err;
 
@@ -1089,7 +1104,7 @@ struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 
 	nftnl_ruleset_set(rs, NFTNL_RULESET_SETLIST, sl);
 
-	r = mnl_nft_rule_dump(nf_sock, family);
+	r = mnl_nft_rule_dump(nf_sock, family, seqnum);
 	if (r == NULL)
 		goto err;
 
@@ -1164,7 +1179,7 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 	return ret;
 }
 
-static void nft_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
+static void nft_mnl_batch_put(char *buf, uint16_t type, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfg;
@@ -1172,7 +1187,7 @@ static void nft_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type = type;
 	nlh->nlmsg_flags = NLM_F_REQUEST;
-	nlh->nlmsg_seq = seq;
+	nlh->nlmsg_seq = seqnum;
 
 	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
 	nfg->nfgen_family = AF_INET;
@@ -1180,7 +1195,7 @@ static void nft_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
 	nfg->res_id = NFNL_SUBSYS_NFTABLES;
 }
 
-bool mnl_batch_supported(struct mnl_socket *nf_sock)
+bool mnl_batch_supported(struct mnl_socket *nf_sock, uint32_t *seqnum)
 {
 	struct mnl_nlmsg_batch *b;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
@@ -1189,15 +1204,15 @@ bool mnl_batch_supported(struct mnl_socket *nf_sock)
 	b = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
 	nft_mnl_batch_put(mnl_nlmsg_batch_current(b), NFNL_MSG_BATCH_BEGIN,
-			  seq++);
+			  mnl_seqnum_alloc(seqnum));
 	mnl_nlmsg_batch_next(b);
 
 	nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(b), NFT_MSG_NEWSET,
-			      AF_INET, NLM_F_ACK, seq++);
+			      AF_INET, NLM_F_ACK, mnl_seqnum_alloc(seqnum));
 	mnl_nlmsg_batch_next(b);
 
 	nft_mnl_batch_put(mnl_nlmsg_batch_current(b), NFNL_MSG_BATCH_END,
-			  seq++);
+			  mnl_seqnum_alloc(seqnum));
 	mnl_nlmsg_batch_next(b);
 
 	ret = mnl_socket_sendto(nf_sock, mnl_nlmsg_batch_head(b),
diff --git a/src/netlink.c b/src/netlink.c
index f631c26b2b9c..03769b5b604d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -79,9 +79,9 @@ void netlink_restart(struct mnl_socket *nf_sock)
 	nf_sock = netlink_open_sock();
 }
 
-void netlink_genid_get(struct mnl_socket *nf_sock)
+void netlink_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum)
 {
-	mnl_genid_get(nf_sock);
+	mnl_genid_get(nf_sock, seqnum);
 }
 
 void __noreturn __netlink_abi_error(const char *file, int line,
@@ -561,7 +561,7 @@ static int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h,
 {
 	struct nftnl_rule_list *rule_cache;
 
-	rule_cache = mnl_nft_rule_dump(ctx->nf_sock, h->family);
+	rule_cache = mnl_nft_rule_dump(ctx->nf_sock, h->family, ctx->seqnum);
 	if (rule_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -618,7 +618,7 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 	}
 
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_add(ctx->nf_sock, nlc, flags);
+	err = mnl_nft_chain_add(ctx->nf_sock, nlc, flags, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -684,7 +684,7 @@ static int netlink_rename_chain_compat(struct netlink_ctx *ctx,
 	nlc = alloc_nftnl_chain(h);
 	nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, name);
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_add(ctx->nf_sock, nlc, 0);
+	err = mnl_nft_chain_add(ctx->nf_sock, nlc, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -731,7 +731,7 @@ static int netlink_del_chain_compat(struct netlink_ctx *ctx,
 
 	nlc = alloc_nftnl_chain(h);
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_delete(ctx->nf_sock, nlc, 0);
+	err = mnl_nft_chain_delete(ctx->nf_sock, nlc, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -834,7 +834,7 @@ int netlink_list_chains(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_chain_list *chain_cache;
 	struct chain *chain;
 
-	chain_cache = mnl_nft_chain_dump(ctx->nf_sock, h->family);
+	chain_cache = mnl_nft_chain_dump(ctx->nf_sock, h->family, ctx->seqnum);
 	if (chain_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -870,7 +870,7 @@ int netlink_get_chain(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nlc = alloc_nftnl_chain(h);
-	err = mnl_nft_chain_get(ctx->nf_sock, nlc, 0);
+	err = mnl_nft_chain_get(ctx->nf_sock, nlc, 0, ctx->seqnum);
 	if (err < 0) {
 		netlink_io_error(ctx, loc,
 				 "Could not receive chain from kernel: %s",
@@ -906,7 +906,7 @@ static int netlink_add_table_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_add(ctx->nf_sock, nlt, flags);
+	err = mnl_nft_table_add(ctx->nf_sock, nlt, flags, ctx->seqnum);
 	nftnl_table_free(nlt);
 
 	if (err < 0)
@@ -956,7 +956,7 @@ static int netlink_del_table_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_delete(ctx->nf_sock, nlt, 0);
+	err = mnl_nft_table_delete(ctx->nf_sock, nlt, 0, ctx->seqnum);
 	nftnl_table_free(nlt);
 
 	if (err < 0)
@@ -1033,7 +1033,7 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 {
 	struct nftnl_table_list *table_cache;
 
-	table_cache = mnl_nft_table_dump(ctx->nf_sock, h->family);
+	table_cache = mnl_nft_table_dump(ctx->nf_sock, h->family, ctx->seqnum);
 	if (table_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -1054,7 +1054,7 @@ int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_get(ctx->nf_sock, nlt, 0);
+	err = mnl_nft_table_get(ctx->nf_sock, nlt, 0, ctx->seqnum);
 	if (err < 0) {
 		netlink_io_error(ctx, loc,
 				 "Could not receive table from kernel: %s",
@@ -1245,7 +1245,8 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 	}
 	netlink_dump_set(nls);
 
-	err = mnl_nft_set_add(ctx->nf_sock, nls, NLM_F_ECHO | flags);
+	err = mnl_nft_set_add(ctx->nf_sock, nls, NLM_F_ECHO | flags,
+			      ctx->seqnum);
 	if (err < 0)
 		netlink_io_error(ctx, &set->location, "Could not add set: %s",
 				 strerror(errno));
@@ -1341,7 +1342,7 @@ static int netlink_del_set_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nls = alloc_nftnl_set(h);
-	err = mnl_nft_set_delete(ctx->nf_sock, nls, 0);
+	err = mnl_nft_set_delete(ctx->nf_sock, nls, 0, ctx->seqnum);
 	nftnl_set_free(nls);
 
 	if (err < 0)
@@ -1394,7 +1395,8 @@ int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_set_list *set_cache;
 	int err;
 
-	set_cache = mnl_nft_set_dump(ctx->nf_sock, h->family, h->table);
+	set_cache = mnl_nft_set_dump(ctx->nf_sock, h->family, h->table,
+				     ctx->seqnum);
 	if (set_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -1415,7 +1417,7 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nls = alloc_nftnl_set(h);
-	err = mnl_nft_set_get(ctx->nf_sock, nls);
+	err = mnl_nft_set_get(ctx->nf_sock, nls, ctx->seqnum);
 	if (err < 0) {
 		nftnl_set_free(nls);
 		return netlink_io_error(ctx, loc,
@@ -1474,7 +1476,7 @@ static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_add(ctx->nf_sock, nls, flags);
+	err = mnl_nft_setelem_add(ctx->nf_sock, nls, flags, ctx->seqnum);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1524,7 +1526,7 @@ static int netlink_del_setelems_compat(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_delete(ctx->nf_sock, nls, 0);
+	err = mnl_nft_setelem_delete(ctx->nf_sock, nls, 0, ctx->seqnum);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1724,7 +1726,7 @@ int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 
 	nls = alloc_nftnl_set(h);
 
-	err = mnl_nft_setelem_get(ctx->nf_sock, nls);
+	err = mnl_nft_setelem_get(ctx->nf_sock, nls, ctx->seqnum);
 	if (err < 0) {
 		nftnl_set_free(nls);
 		if (errno == EINTR)
@@ -1860,8 +1862,8 @@ int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_obj_list *obj_cache;
 	int err;
 
-	obj_cache = mnl_nft_obj_dump(ctx->nf_sock, h->family, h->table, NULL,
-				     0, true, false);
+	obj_cache = mnl_nft_obj_dump(ctx->nf_sock, h->family, ctx->seqnum,
+				     h->table, NULL, 0, true, false);
 	if (obj_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -1880,8 +1882,8 @@ int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_obj_list *obj_cache;
 	int err;
 
-	obj_cache = mnl_nft_obj_dump(ctx->nf_sock, h->family, h->table, h->obj,
-				     type, dump, true);
+	obj_cache = mnl_nft_obj_dump(ctx->nf_sock, h->family, ctx->seqnum,
+				     h->table, h->obj, type, dump, true);
 	if (obj_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -1926,7 +1928,7 @@ struct nftnl_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 {
 	struct nftnl_ruleset *rs;
 
-	rs = mnl_nft_ruleset_dump(ctx->nf_sock, h->family);
+	rs = mnl_nft_ruleset_dump(ctx->nf_sock, h->family, ctx->seqnum);
 	if (rs == NULL) {
 		if (errno == EINTR)
 			return NULL;
@@ -3118,7 +3120,7 @@ int netlink_monitor(struct netlink_mon_handler *monhandler,
 	return mnl_nft_event_listener(nf_sock, netlink_events_cb, monhandler);
 }
 
-bool netlink_batch_supported(struct mnl_socket *nf_sock)
+bool netlink_batch_supported(struct mnl_socket *nf_sock, uint32_t *seqnum)
 {
-	return mnl_batch_supported(nf_sock);
+	return mnl_batch_supported(nf_sock, seqnum);
 }
diff --git a/src/rule.c b/src/rule.c
index 1bd5c80158b7..b4405af38fa0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -135,6 +135,7 @@ static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 	ctx.nf_sock = nf_sock;
 	ctx.cache = cache;
 	ctx.msgs = msgs;
+	ctx.seqnum = cache->seqnum++;
 
 	ret = cache_init_tables(&ctx, &handle, cache);
 	if (ret < 0)
@@ -154,7 +155,7 @@ int cache_update(struct mnl_socket *nf_sock, struct nft_cache *cache,
 	if (cache->initialized)
 		return 0;
 replay:
-	netlink_genid_get(nf_sock);
+	netlink_genid_get(nf_sock, cache->seqnum++);
 	ret = cache_init(nf_sock, cache, cmd, msgs);
 	if (ret < 0) {
 		cache_release(cache);
-- 
2.1.4

