Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72904C48BE4
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Aug 2022 22:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240806AbiHXWDv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Aug 2022 18:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240789AbiHXWDq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2022 18:03:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D6EE76949;
        Wed, 24 Aug 2022 15:03:46 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 03/14] netfilter: nft_tproxy: restrict to prerouting hook
Date:   Thu, 25 Aug 2022 00:03:19 +0200
Message-Id: <20220824220330.64283-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220824220330.64283-1-pablo@netfilter.org>
References: <20220824220330.64283-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

TPROXY is only allowed from prerouting, but nft_tproxy doesn't check this.
This fixes a crash (null dereference) when using tproxy from e.g. output.

Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Reported-by: Shell Chen <xierch@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_tproxy.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 68b2eed742df..62da25ad264b 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -312,6 +312,13 @@ static int nft_tproxy_dump(struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_tproxy_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, 1 << NF_INET_PRE_ROUTING);
+}
+
 static struct nft_expr_type nft_tproxy_type;
 static const struct nft_expr_ops nft_tproxy_ops = {
 	.type		= &nft_tproxy_type,
@@ -321,6 +328,7 @@ static const struct nft_expr_ops nft_tproxy_ops = {
 	.destroy	= nft_tproxy_destroy,
 	.dump		= nft_tproxy_dump,
 	.reduce		= NFT_REDUCE_READONLY,
+	.validate	= nft_tproxy_validate,
 };
 
 static struct nft_expr_type nft_tproxy_type __read_mostly = {
-- 
2.30.2

