Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA99C0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjJYV0L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjJYV0J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:26:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98CCB13D;
        Wed, 25 Oct 2023 14:26:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net-next 05/19] netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests
Date:   Wed, 25 Oct 2023 23:25:41 +0200
Message-Id: <20231025212555.132775-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025212555.132775-1-pablo@netfilter.org>
References: <20231025212555.132775-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Rule reset is not concurrency-safe per-se, so multiple CPUs may reset
the same rule at the same time. At least counter and quota expressions
will suffer from value underruns in this case.

Prevent this by introducing dedicated locking callbacks for nfnetlink
and the asynchronous dump handling to serialize access.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 77 +++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d39990c3ae1d..03a306d15f43 100644
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
@@ -8995,7 +9046,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_GETRULE_RESET] = {
-		.call		= nf_tables_getrule,
+		.call		= nf_tables_getrule_reset,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
-- 
2.30.2

