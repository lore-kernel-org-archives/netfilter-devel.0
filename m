Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6958EC43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jul 2022 10:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238766AbiGZKoA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 06:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiGZKn7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 06:43:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0F3201AF
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2022 03:43:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oGI2f-0005ff-EQ; Tue, 26 Jul 2022 12:43:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_queue: only allow supported families
Date:   Tue, 26 Jul 2022 12:43:48 +0200
Message-Id: <20220726104348.2125-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Trying to use 'queue' statement in ingress (for example)
triggers a splat on reinject:

WARNING: CPU: 3 PID: 1345 at net/netfilter/nf_queue.c:291

... because nf_reinject cannot find the ruleset head, so all
"reinject" attempts result in packet drop.

Ingress/egress do not support async resume at the moment anyway,
so disallow loading such rulesets with a more appropriate error
message.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_queue.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 15e4b7640dc0..cb54a0a4b424 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -75,6 +75,24 @@ static const struct nla_policy nft_queue_policy[NFTA_QUEUE_MAX + 1] = {
 	[NFTA_QUEUE_SREG_QNUM]	= { .type = NLA_U32 },
 };
 
+static bool nft_queue_family_supported(const struct nft_ctx *ctx)
+{
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		return true;
+	case NFPROTO_ARP:
+	case NFPROTO_DECNET:
+	case NFPROTO_NETDEV:
+	default:
+		break;
+	}
+
+	return false;
+}
+
 static int nft_queue_init(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr,
 			  const struct nlattr * const tb[])
@@ -82,6 +100,9 @@ static int nft_queue_init(const struct nft_ctx *ctx,
 	struct nft_queue *priv = nft_expr_priv(expr);
 	u32 maxid;
 
+	if (!nft_queue_family_supported(ctx))
+		return -EOPNOTSUPP;
+
 	priv->queuenum = ntohs(nla_get_be16(tb[NFTA_QUEUE_NUM]));
 
 	if (tb[NFTA_QUEUE_TOTAL])
@@ -111,6 +132,9 @@ static int nft_queue_sreg_init(const struct nft_ctx *ctx,
 	struct nft_queue *priv = nft_expr_priv(expr);
 	int err;
 
+	if (!nft_queue_family_supported(ctx))
+		return -EOPNOTSUPP;
+
 	err = nft_parse_register_load(tb[NFTA_QUEUE_SREG_QNUM],
 				      &priv->sreg_qnum, sizeof(u32));
 	if (err < 0)
-- 
2.35.1

