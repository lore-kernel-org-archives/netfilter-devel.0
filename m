Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2833C0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjJYV0S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjJYV0P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:26:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AF94191;
        Wed, 25 Oct 2023 14:26:13 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net-next 19/19] netfilter: nf_tables: Carry reset boolean in nft_set_dump_ctx
Date:   Wed, 25 Oct 2023 23:25:55 +0200
Message-Id: <20231025212555.132775-20-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025212555.132775-1-pablo@netfilter.org>
References: <20231025212555.132775-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Relieve the dump callback from having to check nlmsg_type upon each
call. Prep work for set element reset locking.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ed3329fcbe7f..3c1fd8283bf4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5715,6 +5715,7 @@ static void audit_log_nft_set_reset(const struct nft_table *table,
 struct nft_set_dump_ctx {
 	const struct nft_set	*set;
 	struct nft_ctx		ctx;
+	bool			reset;
 };
 
 static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
@@ -5752,7 +5753,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	bool set_found = false;
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
-	bool reset = false;
 	u32 portid, seq;
 	int event;
 
@@ -5800,12 +5800,9 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -5815,11 +5812,11 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 
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
 
@@ -6072,6 +6069,9 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
+		reset = true;
+
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start = nf_tables_dump_set_start,
@@ -6082,6 +6082,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 		struct nft_set_dump_ctx dump_ctx = {
 			.set = set,
 			.ctx = ctx,
+			.reset = reset,
 		};
 
 		c.data = &dump_ctx;
@@ -6091,9 +6092,6 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
-		reset = true;
-
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_get_set_elem(&ctx, set, attr, reset);
 		if (err < 0) {
-- 
2.30.2

