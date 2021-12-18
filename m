Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7616C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Dec 2021 20:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbhLRUOY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Dec 2021 15:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbhLRUOX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Dec 2021 15:14:23 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C78C061574
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Dec 2021 12:14:23 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1myg60-0006MH-Ei; Sat, 18 Dec 2021 21:14:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] nft-shared: set correc register value
Date:   Sat, 18 Dec 2021 21:14:15 +0100
Message-Id: <20211218201415.257721-1-fw@strlen.de>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

reg is populated based off the payload base:

NFTNL_EXPR_META_KEY     = NFTNL_EXPR_BASE,
NFTNL_EXPR_META_DREG,
NFTNL_EXPR_PAYLOAD_DREG = NFTNL_EXPR_BASE,

Fix this.  It worked because the simple nft rules
currently generated via ipables-nft have
base == register-number but this is a coincidence.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index b281ba2987cc..4394e8b7c4e8 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -443,7 +443,7 @@ static void nft_parse_payload(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		ctx->flags |= NFT_XT_CTX_PREV_PAYLOAD;
 	}
 
-	ctx->reg = nftnl_expr_get_u32(e, NFTNL_EXPR_META_DREG);
+	ctx->reg = nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_DREG);
 	ctx->payload.base = nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_BASE);
 	ctx->payload.offset = nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_OFFSET);
 	ctx->payload.len = nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_LEN);
-- 
2.33.1

