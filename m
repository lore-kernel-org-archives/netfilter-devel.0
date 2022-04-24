Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB9FC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Apr 2022 21:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbiDXV70 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Apr 2022 17:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239691AbiDXV7Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Apr 2022 17:59:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0DE8393F7
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Apr 2022 14:56:21 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables 1/7] nft-shared: update context register for bitwise expression
Date:   Sun, 24 Apr 2022 23:56:07 +0200
Message-Id: <20220424215613.106165-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220424215613.106165-1-pablo@netfilter.org>
References: <20220424215613.106165-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update the destination register, otherwise nft_parse_cmp() gives up on
interpreting the cmp expression when bitwise sreg != dreg.

Fixes: 2c4a34c30cb4 ("iptables-compat: fix address prefix")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-shared.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index c57218542c96..b3993211c79d 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -460,6 +460,8 @@ static void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	if (ctx->reg && reg != ctx->reg)
 		return;
 
+	reg = nftnl_expr_get_u32(e, NFTNL_EXPR_BITWISE_DREG);
+	ctx->reg = reg;
 	data = nftnl_expr_get(e, NFTNL_EXPR_BITWISE_XOR, &len);
 	memcpy(ctx->bitwise.xor, data, len);
 	data = nftnl_expr_get(e, NFTNL_EXPR_BITWISE_MASK, &len);
-- 
2.30.2

