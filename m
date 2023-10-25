Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFD0C25B6E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 20:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjJYUIo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 16:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjJYUIn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 16:08:43 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87B5181
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 13:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ffWBsxM4APy9vmGiwqJv9BPY9/lXqkoyGyngj/32/lE=; b=N1xfeHg0ozp6dHmg7eb/A+7kpw
        c9EZWhj2j1yFnj7wgJV2pUZWLc+53KBZ1TXkt6CRziHMZqZTtS+mLjUMrf4F7GfbrDpcynP7+d5A/
        i8RM6K9daUaqCD9ZgDUxHFlUrC4UXB6b13LebFKasKeKLUIaUsu4O0Z85bQEsJbZWKYBguErQGvUm
        TeHmkbfPUJUavW6h0lHg2zYJC+5I1K+LX4ozBlSx0GrW4ayy4McLnzKS9lVUbFMzSGBNHoYg+D4se
        am0eEgwV8twOqlRxSXgqV/kLIEDS5Xu+/e5MC0G6impDRI+ULef5prDSCJU0Yp0MNZMbjJv0DJYxi
        TzfuXHmQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qvkBC-0003cf-1w; Wed, 25 Oct 2023 22:08:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v3 3/3] netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests
Date:   Wed, 25 Oct 2023 22:08:28 +0200
Message-ID: <20231025200828.5482-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231025200828.5482-1-phil@nwl.cc>
References: <20231025200828.5482-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Objects' dump callbacks are not concurrency-safe per-se with reset bit
set. If two CPUs perform a reset at the same time, at least counter and
quota objects suffer from value underrun.

Prevent this by introducing dedicated locking callbacks for nfnetlink
and the asynchronous dump handling to serialize access.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 72 ++++++++++++++++++++++++++++-------
 1 file changed, 59 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5f84bdd40c3f..245a2c5be082 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7732,6 +7732,19 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int nf_tables_dumpreset_obj(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
+	int ret;
+
+	mutex_lock(&nft_net->commit_mutex);
+	ret = nf_tables_dump_obj(skb, cb);
+	mutex_unlock(&nft_net->commit_mutex);
+
+	return ret;
+}
+
 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 {
 	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
@@ -7748,12 +7761,18 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		ctx->reset = true;
-
 	return 0;
 }
 
+static int nf_tables_dumpreset_obj_start(struct netlink_callback *cb)
+{
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
+
+	ctx->reset = true;
+
+	return nf_tables_dump_obj_start(cb);
+}
+
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
 	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
@@ -7812,18 +7831,43 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
+{
+	u32 portid = NETLINK_CB(skb).portid;
+	struct sk_buff *skb2;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nf_tables_dump_obj_start,
+			.dump = nf_tables_dump_obj,
+			.done = nf_tables_dump_obj_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	skb2 = nf_tables_getobj_single(portid, info, nla, false);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
+
+	return nfnetlink_unicast(skb2, info->net, portid);
+}
+
+static int nf_tables_getobj_reset(struct sk_buff *skb,
+				  const struct nfnl_info *info,
+				  const struct nlattr * const nla[])
 {
 	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
-	bool reset = false;
 	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
-			.start = nf_tables_dump_obj_start,
-			.dump = nf_tables_dump_obj,
+			.start = nf_tables_dumpreset_obj_start,
+			.dump = nf_tables_dumpreset_obj,
 			.done = nf_tables_dump_obj_done,
 			.module = THIS_MODULE,
 			.data = (void *)nla,
@@ -7832,16 +7876,18 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		reset = true;
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+	rcu_read_unlock();
+	mutex_lock(&nft_net->commit_mutex);
+	skb2 = nf_tables_getobj_single(portid, info, nla, true);
+	mutex_unlock(&nft_net->commit_mutex);
+	rcu_read_lock();
+	module_put(THIS_MODULE);
 
-	skb2 = nf_tables_getobj_single(portid, info, nla, reset);
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
 
-	if (!reset)
-		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
-
 	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
 			nla_len(nla[NFTA_OBJ_TABLE]),
 			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
@@ -9128,7 +9174,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ_RESET] = {
-		.call		= nf_tables_getobj,
+		.call		= nf_tables_getobj_reset,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
-- 
2.41.0

