Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD973587A7
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 05:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770095276; cv=none; b=gCkN2voD1cEXXUmPZ0uhXxRExnk3EFpLB+e+ia0vVUXKCMJuKOYlod1osprG2AgJcBpXDMbrWRrnMhVLMog8JxetywdmmpOfyCbDXmXaKHtHihnmN0xZx/nyOmsIzvNPics2tmTFlzCP5QpKdVlGDHLjIUUzAHrz613sPdtEU74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770095276; c=relaxed/simple;
	bh=QfiGTCQfRKxYAFTcXYQoa56q4Elw30W9Z8s9mGQvKfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUh0p6+Whg6VHluUkwN9rtunAOnx6jtCnIH29YZKk+J3JSpIKnAx1jQeuerI/A8FQGYGKdV9CpzxqdNXVoRbvYZzQECEGrmYWmWVM7xsxfRLR+RMvAZuzRV1Xboc57fijcuy5l8aYQRVxAXVdekwN/T6y1ddgbGZI9RxALEWsBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=KSFSI6X5; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="KSFSI6X5"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id 8939E1D75;
	Tue,  3 Feb 2026 06:07:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770095271;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=BBQAwB5p5BemYtJkwX4KGFefUdV5UqwPcb30lZPEP5g=;
	b=KSFSI6X5KYg534GHZcbWLpoMfxs646e6Z5/keNDKeadKu+prbMf48jieQKpnENeb
	qwmGv7SzQ2QSS0stc35KU3kJIT0bA2NY3e8xQ6/W6CKAqIxwqmTtR9fMMmFb3BUPaYS
	xC+Y8kAAK4It8bDOnDpnwXzkERT+Oi/e5vko63beuOwWkCp5lQB/5FrGO+crE2O7byT
	2d4oMpc1OFofySsRDdDU79XZYVpSecdY5gv3uGNDoQtD/GOQv0WLlfXU6Aa2ryqOyXi
	HpvEuSeSm1jlYVBY9XfzCeDTtwXzMaHRaOegu1kg6TedxBc1pmBCTdS8Qwztp2pt6JP
	Te+cWUMu6A==
Received: by smtp.mailfence.com with ESMTPSA ; Tue, 3 Feb 2026 06:07:49 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com,
	Brian Witte <brianwitte@mailfence.com>
Subject: [PATCH v4 nf-next 1/2] Revert nf_tables commit_mutex in reset path
Date: Mon,  2 Feb 2026 23:07:22 -0600
Message-ID: <20260203050723.263515-2-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260203050723.263515-1-brianwitte@mailfence.com>
References: <20260203050723.263515-1-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

Revert mutex-based locking for reset requests. It caused a circular
lock dependency between commit_mutex, nfnl_subsys_ipset, and
nlk_cb_mutex when nft reset, ipset list, and iptables-nft with set
match ran concurrently.

This reverts bd662c4218f9, 3d483faa6663, 3cb03edb4de3.

Reported-by: syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
Fixes: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Fixes: 3d483faa6663 ("netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests")
Fixes: 3cb03edb4de3 ("netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests")
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
---
 net/netfilter/nf_tables_api.c | 248 ++++++----------------------------
 1 file changed, 43 insertions(+), 205 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9923387907e3..9969d8488de4 100644
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
@@ -4008,44 +3985,18 @@ nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 
 static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
-{
-	u32 portid = NETLINK_CB(skb).portid;
-	struct net *net = info->net;
-	struct sk_buff *skb2;
-
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start= nf_tables_dump_rules_start,
-			.dump = nf_tables_dump_rules,
-			.done = nf_tables_dump_rules_done,
-			.module = THIS_MODULE,
-			.data = (void *)nla,
-		};
-
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
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
 {
 	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
+	bool reset = false;
 	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
-			.start= nf_tables_dumpreset_rules_start,
-			.dump = nf_tables_dumpreset_rules,
+			.start= nf_tables_dump_rules_start,
+			.dump = nf_tables_dump_rules,
 			.done = nf_tables_dump_rules_done,
 			.module = THIS_MODULE,
 			.data = (void *)nla,
@@ -4054,18 +4005,16 @@ static int nf_tables_getrule_reset(struct sk_buff *skb,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
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
@@ -6324,6 +6273,10 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
+	if (dump_ctx->reset && args.iter.count > args.iter.skip)
+		audit_log_nft_set_reset(table, cb->seq,
+					args.iter.count - args.iter.skip);
+
 	rcu_read_unlock();
 
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
@@ -6339,26 +6292,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -6602,8 +6535,13 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
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
@@ -6613,7 +6551,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 			.module = THIS_MODULE,
 		};
 
-		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, false);
+		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
 		if (err)
 			return err;
 
@@ -6624,75 +6562,21 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
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
@@ -8564,19 +8448,6 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -8593,16 +8464,10 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
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
@@ -8663,43 +8528,18 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
-{
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
 {
 	struct nftables_pernet *nft_net = nft_pernet(info->net);
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
@@ -8708,18 +8548,16 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
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
@@ -10037,7 +9875,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_GETRULE_RESET] = {
-		.call		= nf_tables_getrule_reset,
+		.call		= nf_tables_getrule,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
@@ -10091,7 +9929,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_GETSETELEM_RESET] = {
-		.call		= nf_tables_getsetelem_reset,
+		.call		= nf_tables_getsetelem,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
@@ -10137,7 +9975,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ_RESET] = {
-		.call		= nf_tables_getobj_reset,
+		.call		= nf_tables_getobj,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
-- 
2.47.3

