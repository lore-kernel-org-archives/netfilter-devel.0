Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A17CDB483
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 14:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbjJSODo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbjJSODo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 10:03:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23704CF
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 07:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SQ1WjZghDUBsmPrq6fyM1O4+pbCYIT4qfjC7uHDGqYs=; b=SSNGkAanhoM5vFdT+4fs7cUKXY
        s7IgIl/Zs3+zFbpY4tGZ2FJEevekXKFFWz3PKLGaaw/Qzhp1n9QqmwM1qNNsAxFrdFn2PSuvZb+ak
        IHd1cZMTF6oSVPOkhoGAtqQjBQLUcWUkr6LJrCzy3EiN1TcBXNEbhZ4uBKIxYqznGIZSNAizQ0sTo
        dOGEBFVLMg1Ic1HFvoiOxX2SXhtzIzUO31UMQe0XaeJ/V6sbhbKK3ilikt6nqEleARlKMQO8XPHkE
        zllS367RZ+10+jcY4/ulKJ4JlTFigDTJmF29e+aIYRD5uKEszbRocOJ6w752Fsr1yOYldcCN6HlMN
        LIdnKmcA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qtTch-0002P3-Vz; Thu, 19 Oct 2023 16:03:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v4 1/3] netfilter: nf_tables: Open-code audit log call in nf_tables_getrule()
Date:   Thu, 19 Oct 2023 16:03:34 +0200
Message-ID: <20231019140336.31563-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231019140336.31563-1-phil@nwl.cc>
References: <20231019140336.31563-1-phil@nwl.cc>
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
Changes since v3:
- Make use of '%.*s' format spec to avoid temporary nla_strdup()
---
 net/netfilter/nf_tables_api.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 72ed4d2045c5..77ae5bc4931c 100644
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
2.41.0

