From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-compat PATCH 2/3] nft: fix syntax error
Date: Thu, 16 Oct 2014 16:29:52 +0200
Message-ID: <1413469793-21382-2-git-send-email-giuseppelng@gmail.com>
References: <1413469793-21382-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55253 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaJPOaC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:30:02 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi2so4877557wib.14
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2014 07:30:00 -0700 (PDT)
In-Reply-To: <1413469793-21382-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes a syntax error, remove ; in an if statement

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 2b87092..d6f838c 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -444,7 +444,7 @@ void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 	if (ctx->flags & NFT_XT_CTX_META)
 		ops->parse_meta(ctx, e, data);
 	/* bitwise context is interpreted from payload */
-	if (ctx->flags & NFT_XT_CTX_PAYLOAD);
+	if (ctx->flags & NFT_XT_CTX_PAYLOAD)
 		ops->parse_payload(ctx, e, data);
 }
 
-- 
1.9.1

