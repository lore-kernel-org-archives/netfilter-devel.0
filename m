Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC3AE732F4
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 16:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjI1Qwy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjI1Qwx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 12:52:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2A31A5
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 09:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=L3w8WxheC71ObxLFiK2CxEL1VfPapPr4wm0c4p74b1g=; b=MhsqQaKJ9yPnvHWrNFu+YmL62/
        TLK43kp2ijEV2e5LCq7ELJH4t0oD6095yunj7CwOQ5K8uq3pyrEKRKsfvELE0uF3ZCy0g70s8yoMX
        S3vroOUBmIhyESLxDn4ihP/J3jdU7MHNox0dt/LmOfuS7oF184dVdw6rkX7kNEyQ6k70Sf8vWMrZm
        K7GFvzgi7GHaYi/o4D8ic1rs1VWi8X46ajIo4dqnU6R3/EnalsLZ8cVUi6nB57sbAdTjqLJT1zk2/
        hB3uVKS3sJZUS+SYXCd3NUjujt5r/tBWiYi+B8ldAD0rCEdvZQla3MkX/B0wGP593ccOCfNaZrUZH
        eC05ggtw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qluFs-0004wH-Au; Thu, 28 Sep 2023 18:52:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf PATCH v2 3/8] netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests
Date:   Thu, 28 Sep 2023 18:52:39 +0200
Message-ID: <20230928165244.7168-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928165244.7168-1-phil@nwl.cc>
References: <20230928165244.7168-1-phil@nwl.cc>
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
Changes since v1:
- commit_mutex instead of dedicated spinlock
---
 net/netfilter/nf_tables_api.c | 85 ++++++++++++++++++++++++++---------
 1 file changed, 65 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 641ae9bde46fa..2e0402a4078cf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3552,6 +3552,19 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
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
@@ -3571,12 +3584,18 @@ static int nf_tables_dump_rules_start(struct netlink_callback *cb)
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
@@ -3637,12 +3656,8 @@ nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
 {
-	u8 family = info->nfmsg->nfgen_family;
 	u32 portid = NETLINK_CB(skb).portid;
-	struct net *net = info->net;
 	struct sk_buff *skb2;
-	bool reset = false;
-	char *tablename;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -3656,6 +3671,35 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
+	skb2 = nf_tables_getrule_single(portid, info, nla, false);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
+
+	return nfnetlink_unicast(skb2, info->net, portid);
+}
+
+static int nf_tables_getrule_reset(struct sk_buff *skb,
+				   const struct nfnl_info *info,
+				   const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	u8 family = info->nfmsg->nfgen_family;
+	u32 portid = NETLINK_CB(skb).portid;
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
 	if (!nla[NFTA_RULE_TABLE])
 		return -EINVAL;
 
@@ -3663,25 +3707,26 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!tablename)
 		return -ENOMEM;
 
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
-		reset = true;
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+	rcu_read_unlock();
+	mutex_lock(&nft_net->commit_mutex);
+	skb2 = nf_tables_getrule_single(portid, info, nla, true);
+	mutex_unlock(&nft_net->commit_mutex);
+	rcu_read_lock();
+	module_put(THIS_MODULE);
 
-	skb2 = nf_tables_getrule_single(portid, info, nla, reset);
 	if (IS_ERR(skb2)) {
 		kfree(tablename);
 		return PTR_ERR(skb2);
 	}
 
-	if (reset) {
-		char *buf = kasprintf(GFP_ATOMIC, "%s:%u",
-				      tablename, nft_pernet(net)->base_seq);
-
-		audit_log_nfcfg(buf, family, 1,
-				AUDIT_NFT_OP_RULE_RESET, GFP_ATOMIC);
-		kfree(buf);
-	}
+	buf = kasprintf(GFP_ATOMIC, "%s:%u", tablename, nft_net->base_seq);
+	audit_log_nfcfg(buf, family, 1, AUDIT_NFT_OP_RULE_RESET, GFP_ATOMIC);
+	kfree(buf);
+	kfree(tablename);
 
-	return nfnetlink_unicast(skb2, net, portid);
+	return nfnetlink_unicast(skb2, info->net, portid);
 }
 
 void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
@@ -8980,7 +9025,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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

