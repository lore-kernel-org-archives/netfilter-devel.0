Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3315CDB484
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 14:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345906AbjJSODq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345858AbjJSODp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 10:03:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24298124
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 07:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GWw8uINJGmP4GefsXIzGAriujtRKwL4vlcA0uZrV1ho=; b=JZFWDOitzRQkVTw7gZ+6kiQ7lz
        yevl8aspyUmgEa07glYBPd2Fo/O6DAKLT53bgn9GO7uoCdO7m/juNQzZGbvskpaiA4+waYiugUChX
        MvPAb6ZNHyuNSJAUGQL1vqGvdYEZKpZVBetVFaViv3nPIDlUlvgK5uAd8ykzW3+M9yPmEupuQKBfg
        0DQSzDaLZAgfK/ThnKYpOXB4KCw6uuWfDykGaP9sqlriFtk6UmWPlegTW4p3Ht7Rk37biGdtvJccV
        5ncC8iMqRqfuJSj/cgV2g83EEVaWX7X0joELwOZpQbN7BqlYbt9FdZx9+Oq3GOXoEslOZAElLNvjB
        3RR11fhg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qtTci-0002P7-AP; Thu, 19 Oct 2023 16:03:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v4 3/3] netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests
Date:   Thu, 19 Oct 2023 16:03:36 +0200
Message-ID: <20231019140336.31563-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231019140336.31563-1-phil@nwl.cc>
References: <20231019140336.31563-1-phil@nwl.cc>
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
Changes since v3:
- Add comment to dumpreset function as suggested
---
 net/netfilter/nf_tables_api.c | 77 +++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 19b3f0087c67..20734fbb0d94 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3551,6 +3551,23 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	return skb->len;
 }
 
+static int nf_tables_dumpreset_rules(struct sk_buff *skb,
+				     struct netlink_callback *cb)
+{
+	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
+	int ret;
+
+	/* Mutex is held is to prevent that two concurrent dump-and-reset calls
+	 * do not underrun counters and quotas. The commit_mutex is used for
+	 * the lack a better lock, this is not transaction path.
+	 */
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
@@ -3570,12 +3587,18 @@ static int nf_tables_dump_rules_start(struct netlink_callback *cb)
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
@@ -3636,12 +3659,9 @@ nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
-	bool reset = false;
-	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -3655,15 +3675,46 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
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
+	struct sk_buff *skb2;
+	char *buf;
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
 
 	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
 			nla_len(nla[NFTA_RULE_TABLE]),
@@ -9003,7 +9054,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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

