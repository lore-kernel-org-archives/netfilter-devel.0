Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BC0CDB483
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 11:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbjJSLeA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 07:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345351AbjJSLdz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 07:33:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E86CBE
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 04:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Mu0mkJvQ72ha5hMf8ViNbEKWF2mPoAkr6QpQh0ONifY=; b=Yz+FXJ2yh7yeKaFweGe6E590n1
        esvZ7A/wCCadNkkYCXUVersNKbtON34vhP9myEMYSG7Zqb21MaNRuy3jyXH8xcsk4TKxey3dUOjOy
        E/Tyr7+cMUXyJlbXanuB8mwUX+Wylag2+Hu4nDc7XDnD8kOIHrGREUgD8612SlGcGYijdqroEFde1
        i/yZ08SDhy6KTe+vgBkpX9ntEEvn2Yl23VjYTxDtoUraY1RxMVj8wzLSJ6LjGxpOTBxzX3ua9oOh9
        YLpMGLyK9ya3SGdUXwIj6S4ctBoeTHFN2mTypnMna+xtiUm3GPRqpwVCRPMSjNvuyhylruUuuEEdQ
        5Lmzzx3w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qtRHj-0000Sk-7w; Thu, 19 Oct 2023 13:33:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v3 2/3] netfilter: nf_tables: Introduce nf_tables_getrule_single()
Date:   Thu, 19 Oct 2023 13:33:46 +0200
Message-ID: <20231019113347.8753-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231019113347.8753-1-phil@nwl.cc>
References: <20231019113347.8753-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Outsource the reply skb preparation for non-dump getrule requests into a
distinct function. Prep work for rule reset locking.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 76 ++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 32 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3c65ce7a2f51..584d3b204372 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3586,66 +3586,82 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
-			     const struct nlattr * const nla[])
+static struct sk_buff *
+nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
+			 const struct nlattr * const nla[], bool reset)
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
-	u32 portid = NETLINK_CB(skb).portid;
 	const struct nft_chain *chain;
 	const struct nft_rule *rule;
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct sk_buff *skb2;
-	bool reset = false;
-	char *tablename;
-	char *buf;
 	int err;
 
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
 	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
-		return PTR_ERR(table);
+		return ERR_CAST(table);
 	}
 
 	chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN], genmask);
 	if (IS_ERR(chain)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN]);
-		return PTR_ERR(chain);
+		return ERR_CAST(chain);
 	}
 
 	rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
 	if (IS_ERR(rule)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
-		return PTR_ERR(rule);
+		return ERR_CAST(rule);
 	}
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
-		return -ENOMEM;
-
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
-		reset = true;
+		return ERR_PTR(-ENOMEM);
 
 	err = nf_tables_fill_rule_info(skb2, net, portid,
 				       info->nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
 				       family, table, chain, rule, 0, reset);
-	if (err < 0)
-		goto err_fill_rule_info;
+	if (err < 0) {
+		kfree_skb(skb2);
+		return ERR_PTR(err);
+	}
+
+	return skb2;
+}
+
+static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	u32 portid = NETLINK_CB(skb).portid;
+	struct net *net = info->net;
+	struct sk_buff *skb2;
+	bool reset = false;
+	char *tablename;
+	char *buf;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start= nf_tables_dump_rules_start,
+			.dump = nf_tables_dump_rules,
+			.done = nf_tables_dump_rules_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		reset = true;
+
+	skb2 = nf_tables_getrule_single(portid, info, nla, reset);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
 
 	if (!reset)
 		return nfnetlink_unicast(skb2, net, portid);
@@ -3658,10 +3674,6 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	kfree(tablename);
 
 	return nfnetlink_unicast(skb2, net, portid);
-
-err_fill_rule_info:
-	kfree_skb(skb2);
-	return err;
 }
 
 void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
-- 
2.41.0

