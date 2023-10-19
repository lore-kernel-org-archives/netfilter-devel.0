Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADC5C41513
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 11:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbjJSLeA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 07:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345251AbjJSLdz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 07:33:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC515119
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 04:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UU0SvHxwSpY+PXWFTJClnKoqcOHaQb5UAchK50dyA0A=; b=hMw4exGrlrEl1ZV+R68vRx54VM
        fxMQ32KmKXZWBWP16M45xy39SyVfOcTOzXScn+BpLyVOBfRxnvGrbZTBkpUyYovLOMa2mPpY5j2Lq
        +OGSEIWH9Gqw94VY+sTuDZ6zcaNC7PBiVgT8+naIejVhAl3Wz1CfR1n9Q138Vm2HcuUTQemJPMHdi
        yuk6P8GgFVDz1M6aLk+GLkozITsM9w2qfjmvldgd5/qftBLKyzxjm/zKcX8zHgHWmYlHmZrqqQIm9
        8Obd5nMc8ybdpPutZzgQ+mZYk8C/72kH+BHQCyKb0LrKE9n9A6CeOUz3PuXMsMg2Yw+bGCXI+V8Nv
        zKqR2bsg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qtRHi-0000Sa-Jq; Thu, 19 Oct 2023 13:33:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v3 1/3] netfilter: nf_tables: Open-code audit log call in nf_tables_getrule()
Date:   Thu, 19 Oct 2023 13:33:45 +0200
Message-ID: <20231019113347.8753-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231019113347.8753-1-phil@nwl.cc>
References: <20231019113347.8753-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The table lookup will be dropped from that function, so remove that
dependency from audit logging code. Using whatever is in
nla[NFTA_RULE_TABLE] is sufficient as long as the previous rule info
filling succeded.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- New patch
---
 net/netfilter/nf_tables_api.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 72ed4d2045c5..3c65ce7a2f51 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3589,15 +3589,19 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
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
+	char *tablename;
+	char *buf;
 	int err;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -3637,16 +3641,23 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
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
+	tablename = nla_strdup(nla[NFTA_RULE_TABLE], GFP_ATOMIC);
+	buf = kasprintf(GFP_ATOMIC, "%s:%u", tablename, nft_net->base_seq);
+	audit_log_nfcfg(buf, info->nfmsg->nfgen_family, 1,
+			AUDIT_NFT_OP_RULE_RESET, GFP_ATOMIC);
+	kfree(buf);
+	kfree(tablename);
+
+	return nfnetlink_unicast(skb2, net, portid);
 
 err_fill_rule_info:
 	kfree_skb(skb2);
-- 
2.41.0

