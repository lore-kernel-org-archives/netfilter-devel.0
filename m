Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD66DEB64D9
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Jun 2023 14:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbjFOOby (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 10:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjFOOby (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 10:31:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1813E57
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2023 07:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5uah9TWXfumo6JHjrCrCNWySKHiVJwLnBoyEE3moAxU=; b=Woob6YSJdcrUjA0AAdgd1Rvf6L
        AfYXxRIQZOuYrtsTQn1lbOD9QrdEmcW1ArsdZdKUu1TG06RoL1in7bfvwBzk6t2fr9KfslBb0NICG
        QrMcaDytN7FTB1mTC1xzCFfIbvpfLiySeEJu+tBR8Jc05pmkd4+QCmEt6BU+G59LNlpLcOjRBDKt3
        KmYcKno1tqn9Hef5v20SM/Fa9eGWD8QMjUxr+yHEw/KrzxyN7IQ2PbUvJOccGKDkg3fVQh3Nk2vq1
        SaD5RaxqtwoWJGO5m2THm3wo4WXlzT/WAe7c5t888xFfi4+wracm1tjXlJRhWED3WeedijvSCX9yl
        i+A8rjgQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1q9o0r-0003cM-0e; Thu, 15 Jun 2023 16:31:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH] netfilter: nf_tables: Introduce NFT_MSG_GETSETELEM_RESET
Date:   Thu, 15 Jun 2023 16:31:40 +0200
Message-Id: <20230615143140.29489-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Analogous to NFT_MSG_GETOBJ_RESET, but for set elements with a timeout
or attached stateful expressions like counters or quotas - reset them
all at once. Respect a per element timeout value if present to reset the
'expires' value to.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/netfilter/nf_tables_api.c            | 68 +++++++++++++++++-------
 2 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index e059dc2644dfb..8466c2a9938f3 100644
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
index dc58991705d7a..477c39358da7d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5230,7 +5230,8 @@ static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX +
 
 static int nft_set_elem_expr_dump(struct sk_buff *skb,
 				  const struct nft_set *set,
-				  const struct nft_set_ext *ext)
+				  const struct nft_set_ext *ext,
+				  bool reset)
 {
 	struct nft_set_elem_expr *elem_expr;
 	u32 size, num_exprs = 0;
@@ -5243,7 +5244,7 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
 	if (num_exprs == 1) {
 		expr = nft_setelem_expr_at(elem_expr, 0);
-		if (nft_expr_dump(skb, NFTA_SET_ELEM_EXPR, expr, false) < 0)
+		if (nft_expr_dump(skb, NFTA_SET_ELEM_EXPR, expr, reset) < 0)
 			return -1;
 
 		return 0;
@@ -5254,7 +5255,7 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
 		nft_setelem_expr_foreach(expr, elem_expr, size) {
 			expr = nft_setelem_expr_at(elem_expr, size);
-			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, false) < 0)
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
 				goto nla_put_failure;
 		}
 		nla_nest_end(skb, nest);
@@ -5267,11 +5268,13 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
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
@@ -5294,7 +5297,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS) &&
-	    nft_set_elem_expr_dump(skb, set, ext))
+	    nft_set_elem_expr_dump(skb, set, ext, reset))
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
@@ -5307,11 +5310,15 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
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
@@ -5326,6 +5333,9 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 				 nf_jiffies64_to_msecs(expires),
 				 NFTA_SET_ELEM_PAD))
 			goto nla_put_failure;
+
+		if (reset)
+			*nft_set_ext_expiration(ext) = now + timeout;
 	}
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_USERDATA)) {
@@ -5349,6 +5359,7 @@ struct nft_set_dump_args {
 	const struct netlink_callback	*cb;
 	struct nft_set_iter		iter;
 	struct sk_buff			*skb;
+	bool				reset;
 };
 
 static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
@@ -5359,7 +5370,7 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 	struct nft_set_dump_args *args;
 
 	args = container_of(iter, struct nft_set_dump_args, iter);
-	return nf_tables_fill_setelem(args->skb, set, elem);
+	return nf_tables_fill_setelem(args->skb, set, elem, args->reset);
 }
 
 struct nft_set_dump_ctx {
@@ -5368,7 +5379,7 @@ struct nft_set_dump_ctx {
 };
 
 static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
-				 const struct nft_set *set)
+				 const struct nft_set *set, bool reset)
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_cur(net);
@@ -5383,7 +5394,7 @@ static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
 			continue;
 
 		elem.priv = catchall->elem;
-		ret = nf_tables_fill_setelem(skb, set, &elem);
+		ret = nf_tables_fill_setelem(skb, set, &elem, reset);
 		break;
 	}
 
@@ -5401,6 +5412,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	bool set_found = false;
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
+	bool reset = false;
 	u32 portid, seq;
 	int event;
 
@@ -5448,8 +5460,12 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -5458,7 +5474,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	set->ops->walk(&dump_ctx->ctx, set, &args.iter);
 
 	if (!args.iter.err && args.iter.count == cb->args[0])
-		args.iter.err = nft_set_catchall_dump(net, skb, set);
+		args.iter.err = nft_set_catchall_dump(net, skb, set, reset);
 	rcu_read_unlock();
 
 	nla_nest_end(skb, nest);
@@ -5496,7 +5512,8 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 				       const struct nft_ctx *ctx, u32 seq,
 				       u32 portid, int event, u16 flags,
 				       const struct nft_set *set,
-				       const struct nft_set_elem *elem)
+				       const struct nft_set_elem *elem,
+				       bool reset)
 {
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
@@ -5517,7 +5534,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	err = nf_tables_fill_setelem(skb, set, elem);
+	err = nf_tables_fill_setelem(skb, set, elem, reset);
 	if (err < 0)
 		goto nla_put_failure;
 
@@ -5623,7 +5640,7 @@ static int nft_setelem_get(struct nft_ctx *ctx, struct nft_set *set,
 }
 
 static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
-			    const struct nlattr *attr)
+			    const struct nlattr *attr, bool reset)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	struct nft_set_elem elem;
@@ -5667,7 +5684,8 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		return err;
 
 	err = nf_tables_fill_setelem_info(skb, ctx, ctx->seq, ctx->portid,
-					  NFT_MSG_NEWSETELEM, 0, set, &elem);
+					  NFT_MSG_NEWSETELEM, 0, set, &elem,
+					  reset);
 	if (err < 0)
 		goto err_fill_setelem;
 
@@ -5691,6 +5709,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	struct nft_set *set;
 	struct nlattr *attr;
 	struct nft_ctx ctx;
+	bool reset = false;
 	int rem, err = 0;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
@@ -5725,8 +5744,11 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
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
@@ -5759,7 +5781,7 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 		flags |= ctx->flags & (NLM_F_CREATE | NLM_F_EXCL);
 
 	err = nf_tables_fill_setelem_info(skb, ctx, 0, portid, event, flags,
-					  set, elem);
+					  set, elem, false);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -8716,6 +8738,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
2.40.0

