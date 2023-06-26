Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE75EB64D7
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 06:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjFZGsE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 02:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjFZGsB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 02:48:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C7F1E51;
        Sun, 25 Jun 2023 23:47:59 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 7/8] netfilter: nf_tables: Introduce NFT_MSG_GETSETELEM_RESET
Date:   Mon, 26 Jun 2023 08:47:48 +0200
Message-Id: <20230626064749.75525-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230626064749.75525-1-pablo@netfilter.org>
References: <20230626064749.75525-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Analogous to NFT_MSG_GETOBJ_RESET, but for set elements with a timeout
or attached stateful expressions like counters or quotas - reset them
all at once. Respect a per element timeout value if present to reset the
'expires' value to.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/netfilter/nf_tables_api.c            | 68 +++++++++++++++++-------
 2 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index e059dc2644df..8466c2a9938f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -105,6 +105,7 @@ enum nft_verdicts {
  * @NFT_MSG_DESTROYSETELEM: destroy a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_DESTROYOBJ: destroy a stateful object (enum nft_object_attributes)
  * @NFT_MSG_DESTROYFLOWTABLE: destroy flow table (enum nft_flowtable_attributes)
+ * @NFT_MSG_GETSETELEM_RESET: get set elements and reset attached stateful expressions (enum nft_set_elem_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -140,6 +141,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_DESTROYSETELEM,
 	NFT_MSG_DESTROYOBJ,
 	NFT_MSG_DESTROYFLOWTABLE,
+	NFT_MSG_GETSETELEM_RESET,
 	NFT_MSG_MAX,
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dfd441ff1e3e..30fd62224df9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5229,7 +5229,8 @@ static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX +
 
 static int nft_set_elem_expr_dump(struct sk_buff *skb,
 				  const struct nft_set *set,
-				  const struct nft_set_ext *ext)
+				  const struct nft_set_ext *ext,
+				  bool reset)
 {
 	struct nft_set_elem_expr *elem_expr;
 	u32 size, num_exprs = 0;
@@ -5242,7 +5243,7 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
 	if (num_exprs == 1) {
 		expr = nft_setelem_expr_at(elem_expr, 0);
-		if (nft_expr_dump(skb, NFTA_SET_ELEM_EXPR, expr, false) < 0)
+		if (nft_expr_dump(skb, NFTA_SET_ELEM_EXPR, expr, reset) < 0)
 			return -1;
 
 		return 0;
@@ -5253,7 +5254,7 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
 		nft_setelem_expr_foreach(expr, elem_expr, size) {
 			expr = nft_setelem_expr_at(elem_expr, size);
-			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, false) < 0)
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
 				goto nla_put_failure;
 		}
 		nla_nest_end(skb, nest);
@@ -5266,11 +5267,13 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
 static int nf_tables_fill_setelem(struct sk_buff *skb,
 				  const struct nft_set *set,
-				  const struct nft_set_elem *elem)
+				  const struct nft_set_elem *elem,
+				  bool reset)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
+	u64 timeout = 0;
 
 	nest = nla_nest_start_noflag(skb, NFTA_LIST_ELEM);
 	if (nest == NULL)
@@ -5293,7 +5296,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS) &&
-	    nft_set_elem_expr_dump(skb, set, ext))
+	    nft_set_elem_expr_dump(skb, set, ext, reset))
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
@@ -5306,11 +5309,15 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		         htonl(*nft_set_ext_flags(ext))))
 		goto nla_put_failure;
 
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
-	    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
-			 nf_jiffies64_to_msecs(*nft_set_ext_timeout(ext)),
-			 NFTA_SET_ELEM_PAD))
-		goto nla_put_failure;
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
+		timeout = *nft_set_ext_timeout(ext);
+		if (nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
+				 nf_jiffies64_to_msecs(timeout),
+				 NFTA_SET_ELEM_PAD))
+			goto nla_put_failure;
+	} else if (set->flags & NFT_SET_TIMEOUT) {
+		timeout = READ_ONCE(set->timeout);
+	}
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 		u64 expires, now = get_jiffies_64();
@@ -5325,6 +5332,9 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 				 nf_jiffies64_to_msecs(expires),
 				 NFTA_SET_ELEM_PAD))
 			goto nla_put_failure;
+
+		if (reset)
+			*nft_set_ext_expiration(ext) = now + timeout;
 	}
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_USERDATA)) {
@@ -5348,6 +5358,7 @@ struct nft_set_dump_args {
 	const struct netlink_callback	*cb;
 	struct nft_set_iter		iter;
 	struct sk_buff			*skb;
+	bool				reset;
 };
 
 static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
@@ -5358,7 +5369,7 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 	struct nft_set_dump_args *args;
 
 	args = container_of(iter, struct nft_set_dump_args, iter);
-	return nf_tables_fill_setelem(args->skb, set, elem);
+	return nf_tables_fill_setelem(args->skb, set, elem, args->reset);
 }
 
 struct nft_set_dump_ctx {
@@ -5367,7 +5378,7 @@ struct nft_set_dump_ctx {
 };
 
 static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
-				 const struct nft_set *set)
+				 const struct nft_set *set, bool reset)
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_cur(net);
@@ -5382,7 +5393,7 @@ static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
 			continue;
 
 		elem.priv = catchall->elem;
-		ret = nf_tables_fill_setelem(skb, set, &elem);
+		ret = nf_tables_fill_setelem(skb, set, &elem, reset);
 		break;
 	}
 
@@ -5400,6 +5411,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	bool set_found = false;
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
+	bool reset = false;
 	u32 portid, seq;
 	int event;
 
@@ -5447,8 +5459,12 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nest == NULL)
 		goto nla_put_failure;
 
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
+		reset = true;
+
 	args.cb			= cb;
 	args.skb		= skb;
+	args.reset		= reset;
 	args.iter.genmask	= nft_genmask_cur(net);
 	args.iter.skip		= cb->args[0];
 	args.iter.count		= 0;
@@ -5457,7 +5473,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	set->ops->walk(&dump_ctx->ctx, set, &args.iter);
 
 	if (!args.iter.err && args.iter.count == cb->args[0])
-		args.iter.err = nft_set_catchall_dump(net, skb, set);
+		args.iter.err = nft_set_catchall_dump(net, skb, set, reset);
 	rcu_read_unlock();
 
 	nla_nest_end(skb, nest);
@@ -5495,7 +5511,8 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 				       const struct nft_ctx *ctx, u32 seq,
 				       u32 portid, int event, u16 flags,
 				       const struct nft_set *set,
-				       const struct nft_set_elem *elem)
+				       const struct nft_set_elem *elem,
+				       bool reset)
 {
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
@@ -5516,7 +5533,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	err = nf_tables_fill_setelem(skb, set, elem);
+	err = nf_tables_fill_setelem(skb, set, elem, reset);
 	if (err < 0)
 		goto nla_put_failure;
 
@@ -5622,7 +5639,7 @@ static int nft_setelem_get(struct nft_ctx *ctx, struct nft_set *set,
 }
 
 static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
-			    const struct nlattr *attr)
+			    const struct nlattr *attr, bool reset)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	struct nft_set_elem elem;
@@ -5666,7 +5683,8 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		return err;
 
 	err = nf_tables_fill_setelem_info(skb, ctx, ctx->seq, ctx->portid,
-					  NFT_MSG_NEWSETELEM, 0, set, &elem);
+					  NFT_MSG_NEWSETELEM, 0, set, &elem,
+					  reset);
 	if (err < 0)
 		goto err_fill_setelem;
 
@@ -5690,6 +5708,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	struct nft_set *set;
 	struct nlattr *attr;
 	struct nft_ctx ctx;
+	bool reset = false;
 	int rem, err = 0;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
@@ -5724,8 +5743,11 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
+		reset = true;
+
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&ctx, set, attr);
+		err = nft_get_set_elem(&ctx, set, attr, reset);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
@@ -5758,7 +5780,7 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 		flags |= ctx->flags & (NLM_F_CREATE | NLM_F_EXCL);
 
 	err = nf_tables_fill_setelem_info(skb, ctx, 0, portid, event, flags,
-					  set, elem);
+					  set, elem, false);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -8715,6 +8737,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
+	[NFT_MSG_GETSETELEM_RESET] = {
+		.call		= nf_tables_getsetelem,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
+		.policy		= nft_set_elem_list_policy,
+	},
 	[NFT_MSG_DELSETELEM] = {
 		.call		= nf_tables_delsetelem,
 		.type		= NFNL_CB_BATCH,
-- 
2.30.2

