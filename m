Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC91C4167B
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 15:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbjKIPB0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 10:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbjKIPBZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 10:01:25 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1EB358C
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 07:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hT39zRe/YxNsrDAdOg53fp7xmGMEDWYjfhPrSMpedA4=; b=a37Ur2eitOIveeyZkLAEuCDacs
        hi/H3MQT7b7m7PQZhHwfBzPmZ5p9QDZXa6f7vX337pYtMJBLwXyjBjdVAdaoYXG7FjutnjpSNNS3k
        QkRSYZFpSYzQ9Xu1HUccJem7QcfTebJe6mxg7Tpz+iASUUvA2xmFyFb0lT9sxoS8KnmA60VkZM8QN
        /vYogn+DS9Vod/EiNHXuAr8IsnTF5nupbo5964Ew/ha7cjHDmGUCm6TNGlWDHd+1AkQRWKNXhx1kg
        LHnJOwzWf1PzmrwaJRPQdo6a/rpDzl7mqcjLIpdx4hCv6NpzouDs0VG74C4LeUB145hwfpuKksJ6a
        4tWpW5VA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r16X3-0005xR-FU; Thu, 09 Nov 2023 16:01:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v4 3/3] netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests
Date:   Thu,  9 Nov 2023 16:01:16 +0100
Message-ID: <20231109150117.17616-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231109150117.17616-1-phil@nwl.cc>
References: <20231109150117.17616-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set expressions' dump callbacks are not concurrency-safe per-se with
reset bit set. If two CPUs reset the same element at the same time,
values may underrun at least with element-attached counters and quotas.

Prevent this by introducing dedicated callbacks for nfnetlink and the
asynchronous dump handling to serialize access.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v3:
- Perform table and set lookups inside the critical secion

Changes since v2:
- Move the audit_log_nft_set_reset() call into the critical section to
  protect the table pointer dereference.
- Drop unused nelems variable from (non-reset) nf_tables_getsetelem().
---
 net/netfilter/nf_tables_api.c | 98 +++++++++++++++++++++++++++++------
 1 file changed, 81 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4e12d0a02e09..1a90ed2e3428 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5816,10 +5816,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
-	if (dump_ctx->reset && args.iter.count > args.iter.skip)
-		audit_log_nft_set_reset(table, cb->seq,
-					args.iter.count - args.iter.skip);
-
 	rcu_read_unlock();
 
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
@@ -5835,6 +5831,26 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	return -ENOSPC;
 }
 
+static int nf_tables_dumpreset_set(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
+	struct nft_set_dump_ctx *dump_ctx = cb->data;
+	int ret, skip = cb->args[0];
+
+	mutex_lock(&nft_net->commit_mutex);
+
+	ret = nf_tables_dump_set(skb, cb);
+
+	if (cb->args[0] > skip)
+		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
+					cb->args[0] - skip);
+
+	mutex_unlock(&nft_net->commit_mutex);
+
+	return ret;
+}
+
 static int nf_tables_dump_set_start(struct netlink_callback *cb)
 {
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
@@ -6078,13 +6094,8 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	struct nft_set_dump_ctx dump_ctx;
-	int rem, err = 0, nelems = 0;
-	struct net *net = info->net;
 	struct nlattr *attr;
-	bool reset = false;
-
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
-		reset = true;
+	int rem, err = 0;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -6094,7 +6105,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 			.module = THIS_MODULE,
 		};
 
-		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
+		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, false);
 		if (err)
 			return err;
 
@@ -6105,22 +6116,75 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
-	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
+	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, false);
 	if (err)
 		return err;
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, reset);
+		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, false);
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
+			break;
+		}
+	}
+
+	return err;
+}
+
+static int nf_tables_getsetelem_reset(struct sk_buff *skb,
+				      const struct nfnl_info *info,
+				      const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	struct netlink_ext_ack *extack = info->extack;
+	struct nft_set_dump_ctx dump_ctx;
+	int rem, err = 0, nelems = 0;
+	struct nlattr *attr;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nf_tables_dump_set_start,
+			.dump = nf_tables_dumpreset_set,
+			.done = nf_tables_dump_set_done,
+			.module = THIS_MODULE,
+		};
+
+		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, true);
+		if (err)
+			return err;
+
+		c.data = &dump_ctx;
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
+		return -EINVAL;
+
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+	rcu_read_unlock();
+	mutex_lock(&nft_net->commit_mutex);
+	rcu_read_lock();
+
+	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, true);
+	if (err)
+		goto out_unlock;
+
+	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
+		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, true);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
 		}
 		nelems++;
 	}
+	audit_log_nft_set_reset(dump_ctx.ctx.table, nft_net->base_seq, nelems);
 
-	if (reset)
-		audit_log_nft_set_reset(dump_ctx.ctx.table, nft_pernet(net)->base_seq,
-					nelems);
+out_unlock:
+	rcu_read_unlock();
+	mutex_unlock(&nft_net->commit_mutex);
+	rcu_read_lock();
+	module_put(THIS_MODULE);
 
 	return err;
 }
@@ -9145,7 +9209,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_GETSETELEM_RESET] = {
-		.call		= nf_tables_getsetelem,
+		.call		= nf_tables_getsetelem_reset,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
-- 
2.41.0

