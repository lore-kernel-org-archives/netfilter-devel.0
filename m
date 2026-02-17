Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AB0372B4D;
	Tue, 17 Feb 2026 16:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345984; cv=none; b=Mg6TWfoF+2EH5Q+poqPjpu3ltjzy8UHz88SZ6TA9nHbi/jINGA58YrV0FIgs/BzcFLEYQIYsVNvJNDX2XGPXTTvxpV4C9aJ4HXYhtTJaWf3jMWEiVzuP5Asr9eCw8hom6RM3v7BB8FcSWSvBiOvk9Du0ddLhT6+77pMwDN1kiJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345984; c=relaxed/simple;
	bh=4Is009v1Dq+QEeOAxeU6C17/TjX3eNjYhTs3fdY1/4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4rWRE5MuwfA3xue5A3drrP9NTfXKQriIaJ8oBotPBmmDznu7X/OTP1ex3dVjJkB2VNTyqDIverMlPkI3YV58ey74z549PRVKKUPttDgFXOPrxzugu9YRgprSdXftUGuDRUo2QzgAWdzpp9jR2fYI+yFLGWKHkD/bgXdbxtRrXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 819AC60683; Tue, 17 Feb 2026 17:33:00 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 04/10] netfilter: nf_tables: revert commit_mutex usage in reset path
Date: Tue, 17 Feb 2026 17:32:27 +0100
Message-ID: <20260217163233.31455-5-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260217163233.31455-1-fw@strlen.de>
References: <20260217163233.31455-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Brian Witte <brianwitte@mailfence.com>

It causes circular lock dependency between commit_mutex, nfnl_subsys_ipset
and nlk_cb_mutex when nft reset, ipset list, and iptables-nft with '-m set'
rule run at the same time.

Previous patches made it safe to run individual reset handlers concurrently
so commit_mutex is no longer required to prevent this.

Fixes: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Fixes: 3d483faa6663 ("netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests")
Fixes: 3cb03edb4de3 ("netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests")
Link: https://lore.kernel.org/all/aUh_3mVRV8OrGsVo@strlen.de/
Reported-by: <syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=ff16b505ec9152e5f448
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 248 ++++++----------------------------
 1 file changed, 42 insertions(+), 206 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1ed034a47bd0..819056ea1ce1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3901,23 +3901,6 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	return skb->len;
 }
 
-static int nf_tables_dumpreset_rules(struct sk_buff *skb,
-				     struct netlink_callback *cb)
-{
-	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
-	int ret;
-
-	/* Mutex is held is to prevent that two concurrent dump-and-reset calls
-	 * do not underrun counters and quotas. The commit_mutex is used for
-	 * the lack a better lock, this is not transaction path.
-	 */
-	mutex_lock(&nft_net->commit_mutex);
-	ret = nf_tables_dump_rules(skb, cb);
-	mutex_unlock(&nft_net->commit_mutex);
-
-	return ret;
-}
-
 static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 {
 	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
@@ -3937,16 +3920,10 @@ static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 			return -ENOMEM;
 		}
 	}
-	return 0;
-}
-
-static int nf_tables_dumpreset_rules_start(struct netlink_callback *cb)
-{
-	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
-
-	ctx->reset = true;
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		ctx->reset = true;
 
-	return nf_tables_dump_rules_start(cb);
+	return 0;
 }
 
 static int nf_tables_dump_rules_done(struct netlink_callback *cb)
@@ -4012,6 +3989,8 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
+	bool reset = false;
+	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -4025,47 +4004,16 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
-	skb2 = nf_tables_getrule_single(portid, info, nla, false);
-	if (IS_ERR(skb2))
-		return PTR_ERR(skb2);
-
-	return nfnetlink_unicast(skb2, net, portid);
-}
-
-static int nf_tables_getrule_reset(struct sk_buff *skb,
-				   const struct nfnl_info *info,
-				   const struct nlattr * const nla[])
-{
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
-	u32 portid = NETLINK_CB(skb).portid;
-	struct net *net = info->net;
-	struct sk_buff *skb2;
-	char *buf;
-
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start= nf_tables_dumpreset_rules_start,
-			.dump = nf_tables_dumpreset_rules,
-			.done = nf_tables_dump_rules_done,
-			.module = THIS_MODULE,
-			.data = (void *)nla,
-		};
-
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
-	skb2 = nf_tables_getrule_single(portid, info, nla, true);
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		reset = true;
 
+	skb2 = nf_tables_getrule_single(portid, info, nla, reset);
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
 
+	if (!reset)
+		return nfnetlink_unicast(skb2, net, portid);
+
 	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
 			nla_len(nla[NFTA_RULE_TABLE]),
 			(char *)nla_data(nla[NFTA_RULE_TABLE]),
@@ -6324,6 +6272,10 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
+	if (dump_ctx->reset && args.iter.count > args.iter.skip)
+		audit_log_nft_set_reset(table, cb->seq,
+					args.iter.count - args.iter.skip);
+
 	rcu_read_unlock();
 
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
@@ -6339,26 +6291,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	return -ENOSPC;
 }
 
-static int nf_tables_dumpreset_set(struct sk_buff *skb,
-				   struct netlink_callback *cb)
-{
-	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
-	struct nft_set_dump_ctx *dump_ctx = cb->data;
-	int ret, skip = cb->args[0];
-
-	mutex_lock(&nft_net->commit_mutex);
-
-	ret = nf_tables_dump_set(skb, cb);
-
-	if (cb->args[0] > skip)
-		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
-					cb->args[0] - skip);
-
-	mutex_unlock(&nft_net->commit_mutex);
-
-	return ret;
-}
-
 static int nf_tables_dump_set_start(struct netlink_callback *cb)
 {
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
@@ -6602,8 +6534,13 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	struct nft_set_dump_ctx dump_ctx;
+	int rem, err = 0, nelems = 0;
+	struct net *net = info->net;
 	struct nlattr *attr;
-	int rem, err = 0;
+	bool reset = false;
+
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
+		reset = true;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -6613,7 +6550,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 			.module = THIS_MODULE,
 		};
 
-		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, false);
+		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
 		if (err)
 			return err;
 
@@ -6624,75 +6561,21 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
-	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, false);
+	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
 	if (err)
 		return err;
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, false);
-		if (err < 0) {
-			NL_SET_BAD_ATTR(extack, attr);
-			break;
-		}
-	}
-
-	return err;
-}
-
-static int nf_tables_getsetelem_reset(struct sk_buff *skb,
-				      const struct nfnl_info *info,
-				      const struct nlattr * const nla[])
-{
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
-	struct netlink_ext_ack *extack = info->extack;
-	struct nft_set_dump_ctx dump_ctx;
-	int rem, err = 0, nelems = 0;
-	struct nlattr *attr;
-
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start = nf_tables_dump_set_start,
-			.dump = nf_tables_dumpreset_set,
-			.done = nf_tables_dump_set_done,
-			.module = THIS_MODULE,
-		};
-
-		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, true);
-		if (err)
-			return err;
-
-		c.data = &dump_ctx;
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
-	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
-		return -EINVAL;
-
-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
-	rcu_read_lock();
-
-	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, true);
-	if (err)
-		goto out_unlock;
-
-	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, true);
+		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, reset);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
 		}
 		nelems++;
 	}
-	audit_log_nft_set_reset(dump_ctx.ctx.table, nft_base_seq(info->net), nelems);
-
-out_unlock:
-	rcu_read_unlock();
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
+	if (reset)
+		audit_log_nft_set_reset(dump_ctx.ctx.table, nft_base_seq(net),
+					nelems);
 
 	return err;
 }
@@ -8564,19 +8447,6 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static int nf_tables_dumpreset_obj(struct sk_buff *skb,
-				   struct netlink_callback *cb)
-{
-	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
-	int ret;
-
-	mutex_lock(&nft_net->commit_mutex);
-	ret = nf_tables_dump_obj(skb, cb);
-	mutex_unlock(&nft_net->commit_mutex);
-
-	return ret;
-}
-
 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 {
 	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
@@ -8593,16 +8463,10 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-	return 0;
-}
-
-static int nf_tables_dumpreset_obj_start(struct netlink_callback *cb)
-{
-	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
-
-	ctx->reset = true;
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		ctx->reset = true;
 
-	return nf_tables_dump_obj_start(cb);
+	return 0;
 }
 
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
@@ -8664,42 +8528,16 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
-	u32 portid = NETLINK_CB(skb).portid;
-	struct sk_buff *skb2;
-
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start = nf_tables_dump_obj_start,
-			.dump = nf_tables_dump_obj,
-			.done = nf_tables_dump_obj_done,
-			.module = THIS_MODULE,
-			.data = (void *)nla,
-		};
-
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
-	skb2 = nf_tables_getobj_single(portid, info, nla, false);
-	if (IS_ERR(skb2))
-		return PTR_ERR(skb2);
-
-	return nfnetlink_unicast(skb2, info->net, portid);
-}
-
-static int nf_tables_getobj_reset(struct sk_buff *skb,
-				  const struct nfnl_info *info,
-				  const struct nlattr * const nla[])
-{
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
+	bool reset = false;
 	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
-			.start = nf_tables_dumpreset_obj_start,
-			.dump = nf_tables_dumpreset_obj,
+			.start = nf_tables_dump_obj_start,
+			.dump = nf_tables_dump_obj,
 			.done = nf_tables_dump_obj_done,
 			.module = THIS_MODULE,
 			.data = (void *)nla,
@@ -8708,18 +8546,16 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
-	skb2 = nf_tables_getobj_single(portid, info, nla, true);
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		reset = true;
 
+	skb2 = nf_tables_getobj_single(portid, info, nla, reset);
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
 
+	if (!reset)
+		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+
 	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
 			nla_len(nla[NFTA_OBJ_TABLE]),
 			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
@@ -10037,7 +9873,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_GETRULE_RESET] = {
-		.call		= nf_tables_getrule_reset,
+		.call		= nf_tables_getrule,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
@@ -10091,7 +9927,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_GETSETELEM_RESET] = {
-		.call		= nf_tables_getsetelem_reset,
+		.call		= nf_tables_getsetelem,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
@@ -10137,7 +9973,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ_RESET] = {
-		.call		= nf_tables_getobj_reset,
+		.call		= nf_tables_getobj,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
-- 
2.52.0

