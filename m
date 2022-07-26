Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEE3C00140
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jul 2022 17:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239625AbiGZRtM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 13:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239644AbiGZRtH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 13:49:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF83113CC0
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2022 10:49:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oGOg4-0007dw-Pa; Tue, 26 Jul 2022 19:49:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf] netfilter: nft_queue: only allow supported familes and hooks
Date:   Tue, 26 Jul 2022 19:49:00 +0200
Message-Id: <20220726174900.7309-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Trying to use 'queue' statement in ingress (for example)
triggers a splat on reinject:

WARNING: CPU: 3 PID: 1345 at net/netfilter/nf_queue.c:291

... because nf_reinject cannot find the ruleset head.

The netdev family doesn't support async resume at the moment anyway,
so disallow loading such rulesets with a more appropriate
error message.

v2: add 'validate' callback and also check hook points, v1 did
allow ingress use in 'table inet', but that doesn't work either. (Pablo)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 nf-queue selftest passes, ingress chain+queue yields -EOPNOTSUPP.

 net/netfilter/nft_queue.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 15e4b7640dc0..d31053452586 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -68,6 +68,30 @@ static void nft_queue_sreg_eval(const struct nft_expr *expr,
 	regs->verdict.code = ret;
 }
 
+static int nft_queue_validate(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr,
+			      const struct nft_data **data)
+{
+	static const unsigned int supported_hooks = ((1 << NF_INET_PRE_ROUTING) |
+						     (1 << NF_INET_LOCAL_IN) |
+						     (1 << NF_INET_FORWARD) |
+						     (1 << NF_INET_LOCAL_OUT) |
+						     (1 << NF_INET_POST_ROUTING));
+
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		break;
+	case NFPROTO_NETDEV: /* fallthrough, lacks okfn */
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, supported_hooks);
+}
+
 static const struct nla_policy nft_queue_policy[NFTA_QUEUE_MAX + 1] = {
 	[NFTA_QUEUE_NUM]	= { .type = NLA_U16 },
 	[NFTA_QUEUE_TOTAL]	= { .type = NLA_U16 },
@@ -164,6 +188,7 @@ static const struct nft_expr_ops nft_queue_ops = {
 	.eval		= nft_queue_eval,
 	.init		= nft_queue_init,
 	.dump		= nft_queue_dump,
+	.validate	= nft_queue_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 };
 
@@ -173,6 +198,7 @@ static const struct nft_expr_ops nft_queue_sreg_ops = {
 	.eval		= nft_queue_sreg_eval,
 	.init		= nft_queue_sreg_init,
 	.dump		= nft_queue_sreg_dump,
+	.validate	= nft_queue_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 };
 
-- 
2.35.1

