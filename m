From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netlink: kill non-batch compat code
Date: Sat, 11 Apr 2015 22:55:09 +0100
Message-ID: <1428789309-25129-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53731 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbbDKVzO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 17:55:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While trying to reduce code duplication in the non-batch netlink compat
code, I noticed that from day 1 (commit a72315d, "src: add rule batching
support") all rule updates were performed using batching and
mnl_nft_rule_add() didn't have any callers in the tree.

Given that apparently non-compat was never even used, this strongly
indicates that is not needed and can be removed.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/mnl.h     |  22 ----
 include/netlink.h |   8 --
 src/main.c        |   2 -
 src/mnl.c         | 226 +----------------------------------
 src/netlink.c     | 352 +++++-------------------------------------------------
 src/rule.c        |  10 +-
 6 files changed, 36 insertions(+), 584 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index a0dfa1b..7591670 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -27,19 +27,11 @@ int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 			   uint32_t seqnum);
 
-int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *r,
-		     unsigned int flags);
-int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nft_rule *r,
-			unsigned int flags);
 struct nft_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 					int family);
 
-int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
-		      unsigned int flags);
 int mnl_nft_chain_batch_add(struct nft_chain *nlc,
 			    unsigned int flags, uint32_t seq);
-int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
-                         unsigned int flags);
 int mnl_nft_chain_batch_del(struct nft_chain *nlc,
 			    unsigned int flags, uint32_t seq);
 struct nft_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
@@ -47,12 +39,8 @@ struct nft_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
 int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 		      unsigned int flags);
 
-int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
-		      unsigned int flags);
 int mnl_nft_table_batch_add(struct nft_table *nlt,
 			    unsigned int flags, uint32_t seq);
-int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
-			 unsigned int flags);
 int mnl_nft_table_batch_del(struct nft_table *nlt,
 			    unsigned int flags, uint32_t seq);
 struct nft_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
@@ -60,24 +48,16 @@ struct nft_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
 int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
 		      unsigned int flags);
 
-int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
-		    unsigned int flags);
 int mnl_nft_set_batch_add(struct nft_set *nls,
 			  unsigned int flags, uint32_t seq);
-int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
-		       unsigned int flags);
 int mnl_nft_set_batch_del(struct nft_set *nls,
 			  unsigned int flags, uint32_t seq);
 struct nft_set_list *mnl_nft_set_dump(struct mnl_socket *nf_sock, int family,
 				      const char *table);
 int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nft_set *nls);
 
-int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
-			unsigned int flags);
 int mnl_nft_setelem_batch_add(struct nft_set *nls,
 			      unsigned int flags, uint32_t seq);
-int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
-			   unsigned int flags);
 int mnl_nft_setelem_batch_del(struct nft_set *nls,
 			      unsigned int flags, uint32_t seq);
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
@@ -88,6 +68,4 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 			   int (*cb)(const struct nlmsghdr *nlh, void *data),
 			   void *cb_data);
 
-bool mnl_batch_supported(struct mnl_socket *nf_sock);
-
 #endif /* _NFTABLES_MNL_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index c1ff9c6..98d5a85 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -30,7 +30,6 @@ struct netlink_ctx {
 	struct set		*set;
 	const void		*data;
 	uint32_t		seqnum;
-	bool			batch_supported;
 };
 
 extern struct nft_table *alloc_nft_table(const struct handle *h);
@@ -77,12 +76,6 @@ extern int netlink_delete_rule(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
 extern int netlink_add_rule_list(struct netlink_ctx *ctx, const struct handle *h,
 				 struct list_head *rule_list);
-extern int netlink_add_rule_batch(struct netlink_ctx *ctx,
-				  const struct handle *h,
-				  const struct rule *rule, uint32_t flags);
-extern int netlink_del_rule_batch(struct netlink_ctx *ctx,
-				  const struct handle *h,
-				  const struct location *loc);
 
 extern int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc,
@@ -163,6 +156,5 @@ struct netlink_mon_handler {
 };
 
 extern int netlink_monitor(struct netlink_mon_handler *monhandler);
-bool netlink_batch_supported(void);
 
 #endif /* NFTABLES_NETLINK_H */
diff --git a/src/main.c b/src/main.c
index 4590c30..95bcd57 100644
--- a/src/main.c
+++ b/src/main.c
@@ -178,7 +178,6 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 	struct mnl_err *err, *tmp;
 	LIST_HEAD(err_list);
 	uint32_t batch_seqnum;
-	bool batch_supported = netlink_batch_supported();
 	int ret = 0;
 
 	netlink_genid_get();
@@ -189,7 +188,6 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 		memset(&ctx, 0, sizeof(ctx));
 		ctx.msgs = msgs;
 		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc();
-		ctx.batch_supported = batch_supported;
 		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0)
diff --git a/src/mnl.c b/src/mnl.c
index 89c2bb5..6375cb8 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -342,6 +342,10 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
 	return ret;
 }
 
+/*
+ * Rule
+ */
+
 int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 			   uint32_t seqnum)
 {
@@ -374,37 +378,6 @@ int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 	return 0;
 }
 
-/*
- * Rule
- */
-int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *nlr,
-		     unsigned int flags)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
-			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
-			NLM_F_ACK | NLM_F_CREATE | flags, seq);
-	nft_rule_nlmsg_build_payload(nlh, nlr);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-}
-
-int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nft_rule *nlr,
-			unsigned int flags)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_DELRULE,
-			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
-			NLM_F_ACK, seq);
-	nft_rule_nlmsg_build_payload(nlh, nlr);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-}
-
 static int rule_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nft_rule_list *nlr_list = data;
@@ -455,20 +428,6 @@ err:
 /*
  * Chain
  */
-int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
-		      unsigned int flags)
-
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
-			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
-			NLM_F_CREATE | NLM_F_ACK | flags, seq);
-	nft_chain_nlmsg_build_payload(nlh, nlc);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-}
 
 int mnl_nft_chain_batch_add(struct nft_chain *nlc, unsigned int flags,
 			    uint32_t seqnum)
@@ -486,20 +445,6 @@ int mnl_nft_chain_batch_add(struct nft_chain *nlc, unsigned int flags,
 	return 0;
 }
 
-int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
-			 unsigned int flags)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN,
-			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
-			NLM_F_ACK, seq);
-	nft_chain_nlmsg_build_payload(nlh, nlc);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-}
-
 int mnl_nft_chain_batch_del(struct nft_chain *nlc, unsigned int flags,
 			    uint32_t seqnum)
 {
@@ -585,19 +530,6 @@ int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 /*
  * Table
  */
-int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
-		      unsigned int flags)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE,
-			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
-			NLM_F_ACK | flags, seq);
-	nft_table_nlmsg_build_payload(nlh, nlt);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-}
 
 int mnl_nft_table_batch_add(struct nft_table *nlt, unsigned int flags,
 			    uint32_t seqnum)
@@ -614,20 +546,6 @@ int mnl_nft_table_batch_add(struct nft_table *nlt, unsigned int flags,
 	return 0;
 }
 
-int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
-		      unsigned int flags)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_DELTABLE,
-			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
-			NLM_F_ACK, seq);
-	nft_table_nlmsg_build_payload(nlh, nlt);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-}
-
 int mnl_nft_table_batch_del(struct nft_table *nlt, unsigned int flags,
 			    uint32_t seqnum)
 {
@@ -715,39 +633,6 @@ int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
 /*
  * Set
  */
-static int set_add_cb(const struct nlmsghdr *nlh, void *data)
-{
-	nft_set_nlmsg_parse(nlh, data);
-	return MNL_CB_OK;
-}
-
-int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
-		    unsigned int flags)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET,
-			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
-			NLM_F_CREATE | NLM_F_ACK | flags, seq);
-	nft_set_nlmsg_build_payload(nlh, nls);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_add_cb, nls);
-}
-
-int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
-		       unsigned int flags)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_DELSET,
-			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
-			flags|NLM_F_ACK, seq);
-	nft_set_nlmsg_build_payload(nlh, nls);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-}
 
 int mnl_nft_set_batch_add(struct nft_set *nls, unsigned int flags,
 			  uint32_t seqnum)
@@ -860,44 +745,6 @@ int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nft_set *nls)
 /*
  * Set elements
  */
-int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
-			unsigned int flags)
-{
-	char buf[NFT_NLMSG_MAXSIZE];
-	struct nlmsghdr *nlh;
-	struct nft_set_elems_iter *iter;
-	int ret, err;
-
-	iter = nft_set_elems_iter_create(nls);
-	if (iter == NULL)
-		memory_allocation_error();
-
-	do {
-		nlh = nft_set_elem_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM,
-				nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
-				NLM_F_CREATE | NLM_F_ACK | flags, seq);
-		ret = nft_set_elems_nlmsg_build_payload_iter(nlh, iter);
-		err = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-	} while (ret > 0 && err >= 0);
-
-	nft_set_elems_iter_destroy(iter);
-
-	return err;
-}
-
-int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
-			   unsigned int flags)
-{
-	char buf[NFT_NLMSG_MAXSIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nft_set_elem_nlmsg_build_hdr(buf, NFT_MSG_DELSETELEM,
-			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
-			NLM_F_ACK, seq);
-	nft_set_elems_nlmsg_build_payload(nlh, nls);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-}
 
 static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
 {
@@ -1030,68 +877,3 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 {
 	return nft_mnl_recv(nf_sock, 0, 0, cb, cb_data);
 }
-
-static void nft_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfg;
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
-	nlh->nlmsg_seq = seq;
-
-	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_INET;
-	nfg->version = NFNETLINK_V0;
-	nfg->res_id = NFNL_SUBSYS_NFTABLES;
-}
-
-bool mnl_batch_supported(struct mnl_socket *nf_sock)
-{
-	struct mnl_nlmsg_batch *b;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	int ret;
-
-	b = mnl_nlmsg_batch_start(buf, sizeof(buf));
-
-	nft_mnl_batch_put(mnl_nlmsg_batch_current(b), NFNL_MSG_BATCH_BEGIN,
-			  seq++);
-	mnl_nlmsg_batch_next(b);
-
-	nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(b),
-				NFT_MSG_NEWSET, AF_INET,
-				NLM_F_ACK, seq++);
-	mnl_nlmsg_batch_next(b);
-
-	nft_mnl_batch_put(mnl_nlmsg_batch_current(b), NFNL_MSG_BATCH_END,
-			  seq++);
-	mnl_nlmsg_batch_next(b);
-
-	ret = mnl_socket_sendto(nf_sock, mnl_nlmsg_batch_head(b),
-				mnl_nlmsg_batch_size(b));
-	if (ret < 0)
-		goto err;
-
-	mnl_nlmsg_batch_stop(b);
-
-	ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(nf_sock),
-				 NULL, NULL);
-		if (ret <= 0)
-			break;
-
-		ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
-	}
-
-	/* We're sending an incomplete message to see if the kernel supports
-	 * set messages in batches. EINVAL means that we sent an incomplete
-	 * message with missing attributes. The kernel just ignores messages
-	 * that we cannot include in the batch.
-	 */
-	return (ret == -1 && errno == EINVAL) ? true : false;
-err:
-	mnl_nlmsg_batch_stop(b);
-	return ret;
-}
diff --git a/src/netlink.c b/src/netlink.c
index f957295..e56041c 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -354,9 +354,8 @@ struct expr *netlink_alloc_data(const struct location *loc,
 	}
 }
 
-int netlink_add_rule_batch(struct netlink_ctx *ctx,
-			   const struct handle *h,
-		           const struct rule *rule, uint32_t flags)
+int netlink_add_rule(struct netlink_ctx *ctx, const struct handle *h,
+		     const struct rule *rule, uint32_t flags)
 {
 	struct nft_rule *nlr;
 	int err;
@@ -378,15 +377,15 @@ int netlink_add_rule_list(struct netlink_ctx *ctx, const struct handle *h,
 	struct rule *rule;
 
 	list_for_each_entry(rule, rule_list, list) {
-		if (netlink_add_rule_batch(ctx, &rule->handle, rule,
-					   NLM_F_APPEND) < 0)
+		if (netlink_add_rule(ctx, &rule->handle, rule,
+				     NLM_F_APPEND) < 0)
 			return -1;
 	}
 	return 0;
 }
 
-int netlink_del_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
-			   const struct location *loc)
+int netlink_delete_rule(struct netlink_ctx *ctx, const struct handle *h,
+			const struct location *loc)
 {
 	struct nft_rule *nlr;
 	int err;
@@ -475,7 +474,7 @@ static int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h,
 static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc)
 {
-	return netlink_del_rule_batch(ctx, h, loc);
+	return netlink_delete_rule(ctx, h, loc);
 }
 
 void netlink_dump_chain(struct nft_chain *nlc)
@@ -491,43 +490,9 @@ void netlink_dump_chain(struct nft_chain *nlc)
 #endif
 }
 
-static int netlink_add_chain_compat(struct netlink_ctx *ctx,
-				    const struct handle *h,
-				    const struct location *loc,
-				    const struct chain *chain, bool excl)
-{
-	struct nft_chain *nlc;
-	int err;
-
-	nlc = alloc_nft_chain(h);
-	if (chain != NULL) {
-		if (chain->flags & CHAIN_F_BASECHAIN) {
-			nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
-					       chain->hooknum);
-			nft_chain_attr_set_s32(nlc, NFT_CHAIN_ATTR_PRIO,
-					       chain->priority);
-			nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
-					       chain->type);
-		}
-		if (chain->policy != -1)
-			nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_POLICY,
-					       chain->policy);
-	}
-
-	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_add(nf_sock, nlc, excl ? NLM_F_EXCL : 0);
-	nft_chain_free(nlc);
-
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not add chain: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_add_chain_batch(struct netlink_ctx *ctx,
-				   const struct handle *h,
-				   const struct location *loc,
-				   const struct chain *chain, bool excl)
+int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
+		      const struct location *loc, const struct chain *chain,
+		      bool excl)
 {
 	struct nft_chain *nlc;
 	int err;
@@ -558,40 +523,8 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 	return err;
 }
 
-int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
-		      const struct location *loc, const struct chain *chain,
-		      bool excl)
-{
-	if (ctx->batch_supported)
-		return netlink_add_chain_batch(ctx, h, loc, chain, excl);
-	else
-		return netlink_add_chain_compat(ctx, h, loc, chain, excl);
-}
-
-static int netlink_rename_chain_compat(struct netlink_ctx *ctx,
-				       const struct handle *h,
-				       const struct location *loc,
-				       const char *name)
-{
-	struct nft_chain *nlc;
-	int err;
-
-	nlc = alloc_nft_chain(h);
-	nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_NAME, name);
-	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_add(nf_sock, nlc, 0);
-	nft_chain_free(nlc);
-
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not rename chain: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_rename_chain_batch(struct netlink_ctx *ctx,
-				      const struct handle *h,
-				      const struct location *loc,
-				      const char *name)
+int netlink_rename_chain(struct netlink_ctx *ctx, const struct handle *h,
+			 const struct location *loc, const char *name)
 {
 	struct nft_chain *nlc;
 	int err;
@@ -608,36 +541,8 @@ static int netlink_rename_chain_batch(struct netlink_ctx *ctx,
 	return err;
 }
 
-int netlink_rename_chain(struct netlink_ctx *ctx, const struct handle *h,
-			 const struct location *loc, const char *name)
-{
-	if (ctx->batch_supported)
-		return netlink_rename_chain_batch(ctx, h, loc, name);
-	else
-		return netlink_rename_chain_compat(ctx, h, loc, name);
-}
-
-static int netlink_del_chain_compat(struct netlink_ctx *ctx,
-				    const struct handle *h,
-				    const struct location *loc)
-{
-	struct nft_chain *nlc;
-	int err;
-
-	nlc = alloc_nft_chain(h);
-	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_delete(nf_sock, nlc, 0);
-	nft_chain_free(nlc);
-
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not delete chain: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_del_chain_batch(struct netlink_ctx *ctx,
-				   const struct handle *h,
-				   const struct location *loc)
+int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
+			 const struct location *loc)
 {
 	struct nft_chain *nlc;
 	int err;
@@ -653,15 +558,6 @@ static int netlink_del_chain_batch(struct netlink_ctx *ctx,
 	return err;
 }
 
-int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
-			 const struct location *loc)
-{
-	if (ctx->batch_supported)
-		return netlink_del_chain_batch(ctx, h, loc);
-	else
-		return netlink_del_chain_compat(ctx, h, loc);
-}
-
 static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 					       struct nft_chain *nlc)
 {
@@ -785,31 +681,12 @@ int netlink_list_chain(struct netlink_ctx *ctx, const struct handle *h,
 int netlink_flush_chain(struct netlink_ctx *ctx, const struct handle *h,
 			const struct location *loc)
 {
-	return netlink_del_rule_batch(ctx, h, loc);
+	return netlink_delete_rule(ctx, h, loc);
 }
 
-static int netlink_add_table_compat(struct netlink_ctx *ctx,
-				    const struct handle *h,
-				    const struct location *loc,
-				    const struct table *table, bool excl)
-{
-	struct nft_table *nlt;
-	int err;
-
-	nlt = alloc_nft_table(h);
-	err = mnl_nft_table_add(nf_sock, nlt, excl ? NLM_F_EXCL : 0);
-	nft_table_free(nlt);
-
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not add table: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_add_table_batch(struct netlink_ctx *ctx,
-				   const struct handle *h,
-				   const struct location *loc,
-				   const struct table *table, bool excl)
+int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
+		      const struct location *loc,
+		      const struct table *table, bool excl)
 {
 	struct nft_table *nlt;
 	int err;
@@ -830,36 +707,8 @@ static int netlink_add_table_batch(struct netlink_ctx *ctx,
 	return err;
 }
 
-int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
-		      const struct location *loc,
-		      const struct table *table, bool excl)
-{
-	if (ctx->batch_supported)
-		return netlink_add_table_batch(ctx, h, loc, table, excl);
-	else
-		return netlink_add_table_compat(ctx, h, loc, table, excl);
-}
-
-static int netlink_del_table_compat(struct netlink_ctx *ctx,
-				    const struct handle *h,
-				    const struct location *loc)
-{
-	struct nft_table *nlt;
-	int err;
-
-	nlt = alloc_nft_table(h);
-	err = mnl_nft_table_delete(nf_sock, nlt, 0);
-	nft_table_free(nlt);
-
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not delete table: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_del_table_batch(struct netlink_ctx *ctx,
-				   const struct handle *h,
-				   const struct location *loc)
+int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
+			 const struct location *loc)
 {
 	struct nft_table *nlt;
 	int err;
@@ -874,15 +723,6 @@ static int netlink_del_table_batch(struct netlink_ctx *ctx,
 	return err;
 }
 
-int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
-			 const struct location *loc)
-{
-	if (ctx->batch_supported)
-		return netlink_del_table_batch(ctx, h, loc);
-	else
-		return netlink_del_table_compat(ctx, h, loc);
-}
-
 void netlink_dump_table(struct nft_table *nlt)
 {
 #ifdef DEBUG
@@ -1072,43 +912,11 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	return set;
 }
 
-static int netlink_add_set_compat(struct netlink_ctx *ctx,
-				  const struct handle *h, struct set *set)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	nft_set_attr_set_u32(nls, NFT_SET_ATTR_FLAGS, set->flags);
-	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_TYPE,
-			     dtype_map_to_kernel(set->keytype));
-	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_LEN,
-			     set->keylen / BITS_PER_BYTE);
-	if (set->flags & NFT_SET_MAP) {
-		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_TYPE,
-				     dtype_map_to_kernel(set->datatype));
-		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_LEN,
-				     set->datalen / BITS_PER_BYTE);
-	}
-	netlink_dump_set(nls);
-
-	err = mnl_nft_set_add(nf_sock, nls, NLM_F_EXCL | NLM_F_ECHO);
-	if (err < 0)
-		netlink_io_error(ctx, &set->location, "Could not add set: %s",
-				 strerror(errno));
-
-	set->handle.set =
-		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
-	nft_set_free(nls);
-
-	return err;
-}
-
 /* internal ID to uniquely identify a set in the batch */
 static uint32_t set_id;
 
-static int netlink_add_set_batch(struct netlink_ctx *ctx,
-				 const struct handle *h, struct set *set)
+int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
+		    struct set *set)
 {
 	struct nft_set *nls;
 	int err;
@@ -1151,35 +959,8 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	return err;
 }
 
-int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
-		    struct set *set)
-{
-	if (ctx->batch_supported)
-		return netlink_add_set_batch(ctx, h, set);
-	else
-		return netlink_add_set_compat(ctx, h, set);
-}
-
-static int netlink_del_set_compat(struct netlink_ctx *ctx,
-				  const struct handle *h,
-				  const struct location *loc)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	err = mnl_nft_set_delete(nf_sock, nls, 0);
-	nft_set_free(nls);
-
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not delete set: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_del_set_batch(struct netlink_ctx *ctx,
-				 const struct handle *h,
-				 const struct location *loc)
+int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
+		       const struct location *loc)
 {
 	struct nft_set *nls;
 	int err;
@@ -1194,15 +975,6 @@ static int netlink_del_set_batch(struct netlink_ctx *ctx,
 	return err;
 }
 
-int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
-		       const struct location *loc)
-{
-	if (ctx->batch_supported)
-		return netlink_del_set_batch(ctx, h, loc);
-	else
-		return netlink_del_set_compat(ctx, h, loc);
-}
-
 static int list_set_cb(struct nft_set *nls, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
@@ -1274,9 +1046,8 @@ static void alloc_setelem_cache(const struct expr *set, struct nft_set *nls)
 	}
 }
 
-static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
-				      const struct handle *h,
-				      const struct expr *expr)
+int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
+			 const struct expr *expr)
 {
 	struct nft_set *nls;
 	int err;
@@ -1294,38 +1065,8 @@ static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
 	return err;
 }
 
-static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
-				       const struct handle *h,
-				       const struct expr *expr)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls);
-
-	err = mnl_nft_setelem_add(nf_sock, nls, 0);
-	nft_set_free(nls);
-	if (err < 0)
-		netlink_io_error(ctx, &expr->location,
-				 "Could not add set elements: %s",
-				 strerror(errno));
-	return err;
-}
-
-int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			 const struct expr *expr)
-{
-	if (ctx->batch_supported)
-		return netlink_add_setelems_batch(ctx, h, expr);
-	else
-		return netlink_add_setelems_compat(ctx, h, expr);
-}
-
-static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
-				      const struct handle *h,
-				      const struct expr *expr)
+int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
+			    const struct expr *expr)
 {
 	struct nft_set *nls;
 	int err;
@@ -1343,26 +1084,6 @@ static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
 	return err;
 }
 
-static int netlink_del_setelems_compat(struct netlink_ctx *ctx,
-				       const struct handle *h,
-				       const struct expr *expr)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls);
-
-	err = mnl_nft_setelem_delete(nf_sock, nls, 0);
-	nft_set_free(nls);
-	if (err < 0)
-		netlink_io_error(ctx, &expr->location,
-				 "Could not delete set elements: %s",
-				 strerror(errno));
-	return err;
-}
-
 static int netlink_delinearize_setelem(struct nft_set_elem *nlse,
 				       struct set *set)
 {
@@ -1416,15 +1137,6 @@ out:
 	return 0;
 }
 
-int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			    const struct expr *expr)
-{
-	if (ctx->batch_supported)
-		return netlink_del_setelems_batch(ctx, h, expr);
-	else
-		return netlink_del_setelems_compat(ctx, h, expr);
-}
-
 static int list_setelem_cb(struct nft_set_elem *nlse, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
@@ -1477,9 +1189,6 @@ int netlink_flush_ruleset(struct netlink_ctx *ctx, const struct handle *h,
 	struct nft_table *nlt;
 	int err;
 
-	if (!ctx->batch_supported)
-		return netlink_io_error(ctx, loc, "Operation not supported");
-
 	nlt = alloc_nft_table(h);
 	err = mnl_nft_table_batch_del(nlt, 0, ctx->seqnum);
 	nft_table_free(nlt);
@@ -2092,8 +1801,3 @@ int netlink_monitor(struct netlink_mon_handler *monhandler)
 	return mnl_nft_event_listener(nf_mon_sock, netlink_events_cb,
 				      monhandler);
 }
-
-bool netlink_batch_supported(void)
-{
-	return mnl_batch_supported(nf_sock);
-}
diff --git a/src/rule.c b/src/rule.c
index 7114380..86cf080 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -730,8 +730,8 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 		return do_add_chain(ctx, &cmd->handle, &cmd->location,
 				    cmd->chain, excl);
 	case CMD_OBJ_RULE:
-		return netlink_add_rule_batch(ctx, &cmd->handle,
-					      cmd->rule, NLM_F_APPEND);
+		return netlink_add_rule(ctx, &cmd->handle,
+					cmd->rule, NLM_F_APPEND);
 	case CMD_OBJ_SET:
 		return do_add_set(ctx, &cmd->handle, cmd->set);
 	case CMD_OBJ_SETELEM:
@@ -746,8 +746,7 @@ static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_RULE:
-		return netlink_add_rule_batch(ctx, &cmd->handle,
-					      cmd->rule, 0);
+		return netlink_add_rule(ctx, &cmd->handle, cmd->rule, 0);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -762,8 +761,7 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CHAIN:
 		return netlink_delete_chain(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_RULE:
-		return netlink_del_rule_batch(ctx, &cmd->handle,
-					      &cmd->location);
+		return netlink_delete_rule(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_SET:
 		return netlink_delete_set(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_SETELEM:
-- 
2.1.0

