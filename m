From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC nft 2/2] src: add set netlink message to the batch
Date: Tue, 25 Mar 2014 21:39:42 +0100
Message-ID: <1395779982-3459-2-git-send-email-pablo@netfilter.org>
References: <1395779982-3459-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50402 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbaCYUjy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:39:54 -0400
In-Reply-To: <1395779982-3459-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves the netlink set messages to the batch that contains
the rules. This helps to speed up rule-set restoration time by
changing the operational from:

 1) create the set message and send it to the kernel.
 2) process the response message that contains the allocated name
    from the kernel.
 3) add the set elements and send it to the kernel.
 4) process the response message from the kernel indicating the
    result.

To:

 1) add the set to the batch.
 2) add the set elements to the batch.
 3) add the rule that points to the set.
 4) send batch to the kernel.

To achieve this, an internal set ID which is unique to the batch
is allocated as suggested by Patrick.

To retain backward compatibility, nft initially guesses if the
kernel supports set in batches. Otherwise, it falls back to the
previous (slowier) operational.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h           |   12 ++++
 include/netlink.h       |    4 ++
 include/rule.h          |    2 +
 src/main.c              |    2 +
 src/mnl.c               |  130 +++++++++++++++++++++++++++++++++++
 src/netlink.c           |  173 ++++++++++++++++++++++++++++++++++++++++++++---
 src/netlink_linearize.c |    8 +++
 7 files changed, 323 insertions(+), 8 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index f4de27d..d62c146 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -67,4 +67,16 @@ int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
 
 struct nft_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 					 uint32_t family);
+
+int mnl_nft_set_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+			  unsigned int flags);
+int mnl_nft_set_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
+			  unsigned int flags);
+int mnl_nft_setelem_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+			      unsigned int flags);
+int mnl_nft_setelem_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
+			      unsigned int flags);
+
+bool mnl_set_batch_supported(struct mnl_socket *nf_sock);
+
 #endif /* _NFTABLES_MNL_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index 4e3f8aa..4f6bd5a 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -30,6 +30,7 @@ struct netlink_ctx {
 	struct set		*set;
 	const void		*data;
 	uint32_t		seqnum;
+	bool			set_batch_supported;
 };
 
 extern struct nft_table *alloc_nft_table(const struct handle *h);
@@ -142,4 +143,7 @@ extern int netlink_io_error(struct netlink_ctx *ctx,
 extern struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 						const struct handle *h,
 						const struct location *loc);
+
+bool netlink_set_batch_supported(void);
+
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/rule.h b/include/rule.h
index ecf801f..226353d 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -12,6 +12,7 @@
  * @table:	table name
  * @chain:	chain name (chains and rules only)
  * @set:	set name (sets only)
+ * @set_id:	set ID (sets only)
  * @handle:	rule handle (rules only)
  * @position:	rule position (rules only)
  * @comment:	human-readable comment (rules only)
@@ -21,6 +22,7 @@ struct handle {
 	const char		*table;
 	const char		*chain;
 	const char		*set;
+	uint64_t		set_id;
 	uint64_t		handle;
 	uint64_t		position;
 	const char		*comment;
diff --git a/src/main.c b/src/main.c
index 9d50577..355f606 100644
--- a/src/main.c
+++ b/src/main.c
@@ -170,6 +170,7 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 	struct mnl_err *err, *tmp;
 	LIST_HEAD(err_list);
 	uint32_t batch_seqnum;
+	bool set_batch_supported = netlink_set_batch_supported();
 	int ret = 0;
 
 	batch_seqnum = mnl_batch_begin();
@@ -177,6 +178,7 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 		memset(&ctx, 0, sizeof(ctx));
 		ctx.msgs = msgs;
 		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc();
+		ctx.set_batch_supported = set_batch_supported;
 		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0)
diff --git a/src/mnl.c b/src/mnl.c
index e825fb0..c5d9b27 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -622,6 +622,38 @@ int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
+int mnl_nft_set_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+			  unsigned int flags)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_NEWSET,
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+			NLM_F_CREATE | flags, seq);
+	nft_set_nlmsg_build_payload(nlh, nls);
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+
+	return 0;
+}
+
+int mnl_nft_set_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
+			  unsigned int flags)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_DELSET,
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+			flags, seq);
+	nft_set_nlmsg_build_payload(nlh, nls);
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+
+	return 0;
+}
+
 static int set_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nft_set_list *nls_list = data;
@@ -734,6 +766,38 @@ static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
+int mnl_nft_setelem_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+			      unsigned int flags)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_elem_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_NEWSETELEM,
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+			NLM_F_CREATE | flags, seq);
+	nft_set_elems_nlmsg_build_payload(nlh, nls);
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+
+	return 0;
+}
+
+int mnl_nft_setelem_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
+			      unsigned int flags)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_elem_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_DELSETELEM,
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+			0, seq);
+	nft_set_elems_nlmsg_build_payload(nlh, nls);
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+
+	return 0;
+}
+
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
@@ -805,3 +869,69 @@ out:
 	nft_ruleset_free(rs);
 	return NULL;
 }
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
+bool mnl_set_batch_supported(struct mnl_socket *nf_sock)
+{
+	struct mnl_nlmsg_batch *b;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	int ret;
+
+	b = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(b), NFNL_MSG_BATCH_BEGIN,
+			  seq++);
+	mnl_nlmsg_batch_next(b);
+
+	nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(b),
+				NFT_MSG_NEWSET, AF_INET,
+				NLM_F_ACK, seq++);
+	mnl_nlmsg_batch_next(b);
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(b), NFNL_MSG_BATCH_END,
+			  seq++);
+	mnl_nlmsg_batch_next(b);
+
+	ret = mnl_socket_sendto(nf_sock, mnl_nlmsg_batch_head(b),
+				mnl_nlmsg_batch_size(b));
+	if (ret < 0)
+		goto err;
+
+	mnl_nlmsg_batch_stop(b);
+
+	ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(nf_sock),
+				 NULL, NULL);
+		if (ret <= 0)
+			break;
+
+		ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
+	}
+
+	/* We're sending an incomplete message to see if the kernel supports
+	 * set messages in batches. EINVAL means that we sent an incomplete
+	 * message with missing attributes. The kernel just ignores messages
+	 * that we cannot include in the batch.
+	 */
+	return (ret == -1 && errno == EINVAL) ? true : false;
+err:
+	mnl_nlmsg_batch_stop(b);
+	return ret;
+}
diff --git a/src/netlink.c b/src/netlink.c
index daac64c..6ddf274 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -149,6 +149,8 @@ struct nft_set *alloc_nft_set(const struct handle *h)
 	nft_set_attr_set_str(nls, NFT_SET_ATTR_TABLE, h->table);
 	if (h->set != NULL)
 		nft_set_attr_set_str(nls, NFT_SET_ATTR_NAME, h->set);
+	if (h->set_id)
+		nft_set_attr_set_u64(nls, NFT_SET_ATTR_ID, h->set_id);
 
 	return nls;
 }
@@ -755,8 +757,8 @@ void netlink_dump_set(struct nft_set *nls)
 #endif
 }
 
-int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
-		    struct set *set)
+static int netlink_add_set_compat(struct netlink_ctx *ctx,
+				  const struct handle *h, struct set *set)
 {
 	struct nft_set *nls;
 	int err;
@@ -787,8 +789,60 @@ int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
-		       const struct location *loc)
+/* internal set ID used in the batch */
+static uint64_t set_id;
+
+static int netlink_add_set_batch(struct netlink_ctx *ctx,
+				 const struct handle *h, struct set *set)
+{
+	struct nft_set *nls;
+	int err;
+
+	nls = alloc_nft_set(h);
+	nft_set_attr_set_u32(nls, NFT_SET_ATTR_FLAGS, set->flags);
+	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_TYPE,
+			     dtype_map_to_kernel(set->keytype));
+	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_LEN,
+			     set->keylen / BITS_PER_BYTE);
+	if (set->flags & NFT_SET_MAP) {
+		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_TYPE,
+				     dtype_map_to_kernel(set->datatype));
+		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_LEN,
+				     set->datalen / BITS_PER_BYTE);
+	}
+	netlink_dump_set(nls);
+
+	if (set->flags & SET_F_ANONYMOUS) {
+		set->handle.set_id = ++set_id;
+		nft_set_attr_set_u64(nls, NFT_SET_ATTR_ID, set->handle.set_id);
+	}
+
+	err = mnl_nft_set_batch_add(nf_sock, nls, NLM_F_EXCL);
+	if (err < 0) {
+		netlink_io_error(ctx, &set->location, "Could not add set: %s",
+				 strerror(errno));
+	}
+	nft_set_free(nls);
+
+	return err;
+}
+
+int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
+		    struct set *set)
+{
+	int ret;
+
+	if (ctx->set_batch_supported)
+		ret = netlink_add_set_batch(ctx, h, set);
+	else
+		ret = netlink_add_set_compat(ctx, h, set);
+
+	return ret;
+}
+
+static int netlink_del_set_compat(struct netlink_ctx *ctx,
+				  const struct handle *h,
+				  const struct location *loc)
 {
 	struct nft_set *nls;
 	int err;
@@ -803,6 +857,36 @@ int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
+static int netlink_del_set_batch(struct netlink_ctx *ctx,
+				 const struct handle *h,
+				 const struct location *loc)
+{
+	struct nft_set *nls;
+	int err;
+
+	nls = alloc_nft_set(h);
+	err = mnl_nft_set_batch_del(nf_sock, nls, 0);
+	nft_set_free(nls);
+
+	if (err < 0)
+		netlink_io_error(ctx, loc, "Could not delete set: %s",
+				 strerror(errno));
+	return err;
+}
+
+int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
+		       const struct location *loc)
+{
+	int ret;
+
+	if (ctx->set_batch_supported)
+		ret = netlink_del_set_batch(ctx, h, loc);
+	else
+		ret = netlink_del_set_compat(ctx, h, loc);
+
+	return ret;
+}
+
 static int list_set_cb(struct nft_set *nls, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
@@ -916,8 +1000,29 @@ static void alloc_setelem_cache(const struct expr *set, struct nft_set *nls)
 	}
 }
 
-int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			 const struct expr *expr)
+static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
+				      const struct handle *h,
+				      const struct expr *expr)
+{
+	struct nft_set *nls;
+	int err;
+
+	nls = alloc_nft_set(h);
+	alloc_setelem_cache(expr, nls);
+	netlink_dump_set(nls);
+
+	err = mnl_nft_setelem_batch_add(nf_sock, nls, 0);
+	nft_set_free(nls);
+	if (err < 0)
+		netlink_io_error(ctx, &expr->location,
+				 "Could not add set elements: %s",
+				 strerror(errno));
+	return err;
+}
+
+static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
+				       const struct handle *h,
+				       const struct expr *expr)
 {
 	struct nft_set *nls;
 	int err;
@@ -935,8 +1040,42 @@ int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			    const struct expr *expr)
+int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
+			 const struct expr *expr)
+{
+	int ret;
+
+	if (ctx->set_batch_supported)
+		ret = netlink_add_setelems_batch(ctx, h, expr);
+	else
+		ret = netlink_add_setelems_compat(ctx, h, expr);
+
+	return ret;
+}
+
+static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
+				      const struct handle *h,
+				      const struct expr *expr)
+{
+	struct nft_set *nls;
+	int err;
+
+	nls = alloc_nft_set(h);
+	alloc_setelem_cache(expr, nls);
+	netlink_dump_set(nls);
+
+	err = mnl_nft_setelem_batch_del(nf_sock, nls, 0);
+	nft_set_free(nls);
+	if (err < 0)
+		netlink_io_error(ctx, &expr->location,
+				 "Could not delete set elements: %s",
+				 strerror(errno));
+	return err;
+}
+
+static int netlink_del_setelems_compat(struct netlink_ctx *ctx,
+				       const struct handle *h,
+				       const struct expr *expr)
 {
 	struct nft_set *nls;
 	int err;
@@ -954,6 +1093,19 @@ int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
+int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
+			    const struct expr *expr)
+{
+	int ret;
+
+	if (ctx->set_batch_supported)
+		ret = netlink_del_setelems_batch(ctx, h, expr);
+	else
+		ret = netlink_del_setelems_compat(ctx, h, expr);
+
+	return ret;
+}
+
 static int list_setelem_cb(struct nft_set_elem *nlse, void *arg)
 {
 	struct nft_data_delinearize nld;
@@ -1050,3 +1202,8 @@ struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 
 	return rs;
 }
+
+bool netlink_set_batch_supported(void)
+{
+	return mnl_set_batch_supported(nf_sock);
+}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index e80646b..df8da77 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -129,6 +129,10 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_DREG, dreg);
 	nft_rule_expr_set_str(nle, NFT_EXPR_LOOKUP_SET,
 			      expr->mappings->set->handle.set);
+	if (expr->mappings->set->handle.set_id) {
+		nft_rule_expr_set_u64(nle, NFT_EXPR_LOOKUP_SET_ID,
+				      expr->mappings->set->handle.set_id);
+	}
 
 	if (dreg == NFT_REG_VERDICT)
 		release_register(ctx);
@@ -153,6 +157,10 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_SREG, sreg);
 	nft_rule_expr_set_str(nle, NFT_EXPR_LOOKUP_SET,
 			      expr->right->set->handle.set);
+	if (expr->right->set->handle.set_id) {
+		nft_rule_expr_set_u64(nle, NFT_EXPR_LOOKUP_SET_ID,
+				      expr->right->set->handle.set_id);
+	}
 
 	release_register(ctx);
 	nft_rule_add_expr(ctx->nlr, nle);
-- 
1.7.10.4

