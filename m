Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0E4E732F6
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 16:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjI1Qwz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjI1Qwx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 12:52:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883661B0
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 09:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hdDAVBctpyZ/Tqgx4SblgX2duCs87eBSi8oTygKn9A0=; b=f16rdvEExxSAHMYuW/Mb5uwedQ
        vrx+TwTkmoMqAEXWlM2bsw8Zy2opFE0DuK2duetOJ7PIW0XskSq7jYTSBPWMFU8JGvySY13GAIbbk
        ljnaKPjr0aS8oWPJy9Si2rOshylEZcFcdAzG21TojFedYsXP42qOKWYiz2HQEf92Iyy7JEVMqTw+6
        PXoGvHX90cBjh0sQLTY5pyDDtumegDfsFAn4Bq7PrB3N4b+KmFxMJAneYej8TCYjHesMDchNsmgBD
        KtazxgpDFB5qjw7mIiqOQNzRLaC73pvCyUBvKrX6h2RxTzwlUtsK2F43rkXYVTqN4rPBLJqezPZDm
        qZPvTKrw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qluFt-0004wh-Tt; Thu, 28 Sep 2023 18:52:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf PATCH v2 7/8] netfilter: nf_tables: Pass reset bit in nft_set_dump_ctx
Date:   Thu, 28 Sep 2023 18:52:43 +0200
Message-ID: <20230928165244.7168-8-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928165244.7168-1-phil@nwl.cc>
References: <20230928165244.7168-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Relieve the dump callback from having to check nlmsg_type upon each
call. Prep work for set element reset locking.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- New patch
---
 net/netfilter/nf_tables_api.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f154fcc341421..1491d4c65fed9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5731,6 +5731,7 @@ static void audit_log_nft_set_reset(const struct nft_table *table,
 struct nft_set_dump_ctx {
 	const struct nft_set	*set;
 	struct nft_ctx		ctx;
+	bool			reset;
 };
 
 static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
@@ -5770,7 +5771,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	bool set_found = false;
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
-	bool reset = false;
 	u32 portid, seq;
 	int event;
 
@@ -5818,12 +5818,9 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
-		reset = true;
-
 	args.cb			= cb;
 	args.skb		= skb;
-	args.reset		= reset;
+	args.reset		= dump_ctx->reset;
 	args.iter.genmask	= nft_genmask_cur(net);
 	args.iter.skip		= cb->args[0];
 	args.iter.count		= 0;
@@ -5833,11 +5830,11 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 
 	if (!args.iter.err && args.iter.count == cb->args[0])
 		args.iter.err = nft_set_catchall_dump(net, skb, set,
-						      reset, cb->seq);
+						      dump_ctx->reset, cb->seq);
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
-	if (reset && args.iter.count > args.iter.skip)
+	if (dump_ctx->reset && args.iter.count > args.iter.skip)
 		audit_log_nft_set_reset(table, cb->seq,
 					args.iter.count - args.iter.skip);
 
@@ -6088,6 +6085,9 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
+		reset = true;
+
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start = nf_tables_dump_set_start,
@@ -6098,6 +6098,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 		struct nft_set_dump_ctx dump_ctx = {
 			.set = set,
 			.ctx = ctx,
+			.reset = reset,
 		};
 
 		c.data = &dump_ctx;
@@ -6107,9 +6108,6 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
-		reset = true;
-
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_get_set_elem(&ctx, set, attr, reset);
 		if (err < 0) {
-- 
2.41.0

