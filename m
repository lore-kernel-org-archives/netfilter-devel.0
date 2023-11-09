Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2317DC4167D
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 15:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbjKIPB0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 10:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbjKIPBY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 10:01:24 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851A3325B
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 07:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V86smVVjVrXa1GwgFQYceqheP+Wt0C6BO2Yh68qT9gc=; b=W/no5LfpMf42JgFbX7BvTyEZ/b
        MZxRWOjWhXvOQ0aPACwGqc8/jZXkBfGKWFW8VVdX80qP0wvPprmzlP7KOvQh54TqCo8lCgcDoml3a
        RffCGCFLTPEsGqz2Su8YIWiQMmvQKggEWOT2Tkr5D7za/RUE7xZWSUo+IjD25VQsMUuVe7fC5WJp6
        muQeZugBNKmVxK5k4UCdqeveHjn+j7jYU0doqSAU9jult8SLH9Ii9oa+00As0KdecHqr4ZhkJKkWU
        BmDHgW1IYoDLK+84pRQ6nVeM9OhRSFZi/H9PLUHYdVXXW5RKVJbuHXGoU3Cc0StIMPqp860goeG00
        8mcz2Wvg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r16X2-0005xF-S4; Thu, 09 Nov 2023 16:01:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v4 2/3] netfilter: nf_tables: Introduce nft_set_dump_ctx_init()
Date:   Thu,  9 Nov 2023 16:01:15 +0100
Message-ID: <20231109150117.17616-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231109150117.17616-1-phil@nwl.cc>
References: <20231109150117.17616-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a wrapper around nft_ctx_init() for use in
nf_tables_getsetelem() and a resetting equivalent introduced later.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 49 +++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d63b11073297..4e12d0a02e09 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6038,21 +6038,18 @@ static int nft_get_set_elem(struct nft_ctx *ctx, const struct nft_set *set,
 	return err;
 }
 
-/* called with rcu_read_lock held */
-static int nf_tables_getsetelem(struct sk_buff *skb,
-				const struct nfnl_info *info,
-				const struct nlattr * const nla[])
+static int nft_set_dump_ctx_init(struct nft_set_dump_ctx *dump_ctx,
+				 const struct sk_buff *skb,
+				 const struct nfnl_info *info,
+				 const struct nlattr * const nla[],
+				 bool reset)
 {
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
-	int rem, err = 0, nelems = 0;
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct nft_set *set;
-	struct nlattr *attr;
-	struct nft_ctx ctx;
-	bool reset = false;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
 				 genmask, 0);
@@ -6067,7 +6064,24 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 		return PTR_ERR(set);
 	}
 
-	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
+	nft_ctx_init(&dump_ctx->ctx, net, skb,
+		     info->nlh, family, table, NULL, nla);
+	dump_ctx->set = set;
+	dump_ctx->reset = reset;
+	return 0;
+}
+
+/* called with rcu_read_lock held */
+static int nf_tables_getsetelem(struct sk_buff *skb,
+				const struct nfnl_info *info,
+				const struct nlattr * const nla[])
+{
+	struct netlink_ext_ack *extack = info->extack;
+	struct nft_set_dump_ctx dump_ctx;
+	int rem, err = 0, nelems = 0;
+	struct net *net = info->net;
+	struct nlattr *attr;
+	bool reset = false;
 
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
 		reset = true;
@@ -6079,11 +6093,10 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 			.done = nf_tables_dump_set_done,
 			.module = THIS_MODULE,
 		};
-		struct nft_set_dump_ctx dump_ctx = {
-			.set = set,
-			.ctx = ctx,
-			.reset = reset,
-		};
+
+		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
+		if (err)
+			return err;
 
 		c.data = &dump_ctx;
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
@@ -6092,8 +6105,12 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
+	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
+	if (err)
+		return err;
+
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&ctx, set, attr, reset);
+		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, reset);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
@@ -6102,7 +6119,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	}
 
 	if (reset)
-		audit_log_nft_set_reset(table, nft_pernet(net)->base_seq,
+		audit_log_nft_set_reset(dump_ctx.ctx.table, nft_pernet(net)->base_seq,
 					nelems);
 
 	return err;
-- 
2.41.0

