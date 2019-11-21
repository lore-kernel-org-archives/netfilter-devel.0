Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877DEC432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 623992068D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKURhW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:37:22 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:41652 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfKURhW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:37:22 -0500
Received: from localhost ([::1]:54742 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iXqOP-0006Kd-6x; Thu, 21 Nov 2019 18:37:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v4 09/12] nft: Bore up nft_parse_payload()
Date:   Thu, 21 Nov 2019 18:36:44 +0100
Message-Id: <20191121173647.31488-10-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191121173647.31488-1-phil@nwl.cc>
References: <20191121173647.31488-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow for closer inspection by storing payload expression's base and
length values. Also facilitate for two consecutive payload expressions
as LHS of a (cmp/lookup) statement as used with concatenations.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 8 ++++++++
 iptables/nft-shared.h | 4 +++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 80d4e1fcdcea1..a67302ee621ae 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -445,8 +445,16 @@ static void nft_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 
 static void nft_parse_payload(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
+	if (ctx->flags & NFT_XT_CTX_PAYLOAD) {
+		memcpy(&ctx->prev_payload, &ctx->payload,
+		       sizeof(ctx->prev_payload));
+		ctx->flags |= NFT_XT_CTX_PREV_PAYLOAD;
+	}
+
 	ctx->reg = nftnl_expr_get_u32(e, NFTNL_EXPR_META_DREG);
+	ctx->payload.base = nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_BASE);
 	ctx->payload.offset = nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_OFFSET);
+	ctx->payload.len = nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_LEN);
 	ctx->flags |= NFT_XT_CTX_PAYLOAD;
 }
 
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index e79323c882f4d..4dc44b8460f0d 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -43,6 +43,7 @@ enum {
 	NFT_XT_CTX_META		= (1 << 1),
 	NFT_XT_CTX_BITWISE	= (1 << 2),
 	NFT_XT_CTX_IMMEDIATE	= (1 << 3),
+	NFT_XT_CTX_PREV_PAYLOAD	= (1 << 4),
 };
 
 struct nft_xt_ctx {
@@ -53,9 +54,10 @@ struct nft_xt_ctx {
 
 	uint32_t reg;
 	struct {
+		uint32_t base;
 		uint32_t offset;
 		uint32_t len;
-	} payload;
+	} payload, prev_payload;
 	struct {
 		uint32_t key;
 	} meta;
-- 
2.24.0

