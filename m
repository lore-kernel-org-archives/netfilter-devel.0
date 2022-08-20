Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF57BC25B08
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Aug 2022 15:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241526AbiHTPyX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Aug 2022 11:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiHTPyW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Aug 2022 11:54:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EBC26545
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Aug 2022 08:54:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oPQnh-0006Fm-UM; Sat, 20 Aug 2022 17:54:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Shell Chen <xierch@gmail.com>
Subject: [PATCH nf] nefilter: nft_tproxy: restrict to prerouting hook
Date:   Sat, 20 Aug 2022 17:54:06 +0200
Message-Id: <20220820155406.84029-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <CAAqMkDxLzFZ9YT-DiRh5cVQRha=JzZ+8RYcmkcn8iinrucA+GA@mail.gmail.com>
References: <CAAqMkDxLzFZ9YT-DiRh5cVQRha=JzZ+8RYcmkcn8iinrucA+GA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
2.37.2

