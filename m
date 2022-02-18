Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB395C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Feb 2022 12:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbiBRMRa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Feb 2022 07:17:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiBRMRa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Feb 2022 07:17:30 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642E628DDCA
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Feb 2022 04:17:13 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nL2CF-0001jw-0J; Fri, 18 Feb 2022 13:17:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_limit: fix stateful object memory leak
Date:   Fri, 18 Feb 2022 13:17:05 +0100
Message-Id: <20220218121705.3475-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We need to provide a destroy callback to release the extra fields.

Fixes: 3b9e2ea6c11b ("netfilter: nft_limit: move stateful fields out of expression data")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_limit.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index c4f308460dd1..a726b623963d 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -340,11 +340,20 @@ static int nft_limit_obj_pkts_dump(struct sk_buff *skb,
 	return nft_limit_dump(skb, &priv->limit, NFT_LIMIT_PKTS);
 }
 
+static void nft_limit_obj_pkts_destroy(const struct nft_ctx *ctx,
+				       struct nft_object *obj)
+{
+	struct nft_limit_priv_pkts *priv = nft_obj_data(obj);
+
+	nft_limit_destroy(ctx, &priv->limit);
+}
+
 static struct nft_object_type nft_limit_obj_type;
 static const struct nft_object_ops nft_limit_obj_pkts_ops = {
 	.type		= &nft_limit_obj_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv_pkts)),
 	.init		= nft_limit_obj_pkts_init,
+	.destroy	= nft_limit_obj_pkts_destroy,
 	.eval		= nft_limit_obj_pkts_eval,
 	.dump		= nft_limit_obj_pkts_dump,
 };
@@ -378,11 +387,20 @@ static int nft_limit_obj_bytes_dump(struct sk_buff *skb,
 	return nft_limit_dump(skb, priv, NFT_LIMIT_PKT_BYTES);
 }
 
+static void nft_limit_obj_bytes_destroy(const struct nft_ctx *ctx,
+					struct nft_object *obj)
+{
+	struct nft_limit_priv *priv = nft_obj_data(obj);
+
+	nft_limit_destroy(ctx, priv);
+}
+
 static struct nft_object_type nft_limit_obj_type;
 static const struct nft_object_ops nft_limit_obj_bytes_ops = {
 	.type		= &nft_limit_obj_type,
 	.size		= sizeof(struct nft_limit_priv),
 	.init		= nft_limit_obj_bytes_init,
+	.destroy	= nft_limit_obj_bytes_destroy,
 	.eval		= nft_limit_obj_bytes_eval,
 	.dump		= nft_limit_obj_bytes_dump,
 };
-- 
2.34.1

