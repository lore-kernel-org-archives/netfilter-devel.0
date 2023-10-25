Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0F6C25B6E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjJYV0I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjJYV0H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:26:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D99AF184;
        Wed, 25 Oct 2023 14:26:03 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net-next 03/19] netfilter: nf_tables: Open-code audit log call in nf_tables_getrule()
Date:   Wed, 25 Oct 2023 23:25:39 +0200
Message-Id: <20231025212555.132775-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025212555.132775-1-pablo@netfilter.org>
References: <20231025212555.132775-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

The table lookup will be dropped from that function, so remove that
dependency from audit logging code. Using whatever is in
nla[NFTA_RULE_TABLE] is sufficient as long as the previous rule info
filling succeded.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 38f9b224098e..ce3bb38262c4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3589,15 +3589,18 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
 {
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
+	u32 portid = NETLINK_CB(skb).portid;
 	const struct nft_chain *chain;
 	const struct nft_rule *rule;
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct sk_buff *skb2;
 	bool reset = false;
+	char *buf;
 	int err;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -3637,16 +3640,24 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
 		reset = true;
 
-	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
+	err = nf_tables_fill_rule_info(skb2, net, portid,
 				       info->nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
 				       family, table, chain, rule, 0, reset);
 	if (err < 0)
 		goto err_fill_rule_info;
 
-	if (reset)
-		audit_log_rule_reset(table, nft_pernet(net)->base_seq, 1);
+	if (!reset)
+		return nfnetlink_unicast(skb2, net, portid);
 
-	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
+			nla_len(nla[NFTA_RULE_TABLE]),
+			(char *)nla_data(nla[NFTA_RULE_TABLE]),
+			nft_net->base_seq);
+	audit_log_nfcfg(buf, info->nfmsg->nfgen_family, 1,
+			AUDIT_NFT_OP_RULE_RESET, GFP_ATOMIC);
+	kfree(buf);
+
+	return nfnetlink_unicast(skb2, net, portid);
 
 err_fill_rule_info:
 	kfree_skb(skb2);
-- 
2.30.2

