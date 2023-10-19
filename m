Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D08CDB482
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 11:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344861AbjJSLeB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 07:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345321AbjJSLdz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 07:33:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC72912A
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 04:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xZQfwZFh0DP25Re6FOo9MdyYk7c1SX//px563wDdHgU=; b=M5Wp90afDNLzVWIdnwDZD5q4pK
        d9YICw2Q1v3FHw8w5xvOJ782WQ1dW+Gy0sLTJPC0IVH51TQa6NSpLT3LBEEpMlkpmexftsGBn5/WG
        d+iaN5B9uggVWWj5GJ+6A7NoW43FNOzltNRg7XHZPcneNBojeeDesuNrO3zo07y4BEl942uIJY5lJ
        PLb5rxOoMMu61+O5TlYI7s+usqW0TiGDRx496bYbuKait4NqXMw5T4mI8ZMTjWdVRqDW/z5YO578l
        MtuABwfuMG/SMYBf/6HG/gNXGJlGdgIqN6TmMp6zygXsNhbqsIEd/iECNxtPS9Fo/+lG72UuMMR2k
        VTOueK9w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qtRHi-0000Sd-U6; Thu, 19 Oct 2023 13:33:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v3 3/3] netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests
Date:   Thu, 19 Oct 2023 13:33:47 +0200
Message-ID: <20231019113347.8753-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231019113347.8753-1-phil@nwl.cc>
References: <20231019113347.8753-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rule reset is not concurrency-safe per-se, so multiple CPUs may reset
the same rule at the same time. At least counter and quota expressions
will suffer from value underruns in this case.

Prevent this by introducing dedicated locking callbacks for nfnetlink
and the asynchronous dump handling to serialize access.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Keep local variable 'nft_net' in nf_tables_getrule_reset()
- No need for local variable 'family' in same function (used only once
  after all the churn)
---
 net/netfilter/nf_tables_api.c | 74 ++++++++++++++++++++++++++++-------
 1 file changed, 60 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 584d3b204372..fbb688c9903c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3551,6 +3551,19 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	return skb->len;
 }
 
+static int nf_tables_dumpreset_rules(struct sk_buff *skb,
+				     struct netlink_callback *cb)
+{
+	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
+	int ret;
+
+	mutex_lock(&nft_net->commit_mutex);
+	ret = nf_tables_dump_rules(skb, cb);
+	mutex_unlock(&nft_net->commit_mutex);
+
+	return ret;
+}
+
 static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 {
 	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
@@ -3570,12 +3583,18 @@ static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 			return -ENOMEM;
 		}
 	}
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
-		ctx->reset = true;
-
 	return 0;
 }
 
+static int nf_tables_dumpreset_rules_start(struct netlink_callback *cb)
+{
+	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
+
+	ctx->reset = true;
+
+	return nf_tables_dump_rules_start(cb);
+}
+
 static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 {
 	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
@@ -3636,13 +3655,9 @@ nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
-	bool reset = false;
-	char *tablename;
-	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -3656,15 +3671,46 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
-		reset = true;
-
-	skb2 = nf_tables_getrule_single(portid, info, nla, reset);
+	skb2 = nf_tables_getrule_single(portid, info, nla, false);
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
 
-	if (!reset)
-		return nfnetlink_unicast(skb2, net, portid);
+	return nfnetlink_unicast(skb2, net, portid);
+}
+
+static int nf_tables_getrule_reset(struct sk_buff *skb,
+				   const struct nfnl_info *info,
+				   const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	u32 portid = NETLINK_CB(skb).portid;
+	struct net *net = info->net;
+	char *tablename, *buf;
+	struct sk_buff *skb2;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start= nf_tables_dumpreset_rules_start,
+			.dump = nf_tables_dumpreset_rules,
+			.done = nf_tables_dump_rules_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+	rcu_read_unlock();
+	mutex_lock(&nft_net->commit_mutex);
+	skb2 = nf_tables_getrule_single(portid, info, nla, true);
+	mutex_unlock(&nft_net->commit_mutex);
+	rcu_read_lock();
+	module_put(THIS_MODULE);
+
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
 
 	tablename = nla_strdup(nla[NFTA_RULE_TABLE], GFP_ATOMIC);
 	buf = kasprintf(GFP_ATOMIC, "%s:%u", tablename, nft_net->base_seq);
@@ -9003,7 +9049,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_GETRULE_RESET] = {
-		.call		= nf_tables_getrule,
+		.call		= nf_tables_getrule_reset,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
-- 
2.41.0

