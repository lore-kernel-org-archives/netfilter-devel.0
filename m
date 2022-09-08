Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA59C38145
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Sep 2022 15:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiIHPNB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 11:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbiIHPM4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 11:12:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3226F3BD6
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2022 08:12:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oWJD2-0005ZW-G9; Thu, 08 Sep 2022 17:12:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 1/3] nft: support dissection of meta pkktype mode
Date:   Thu,  8 Sep 2022 17:12:40 +0200
Message-Id: <20220908151242.26838-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220908151242.26838-1-fw@strlen.de>
References: <20220908151242.26838-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Makes iptables-nft-save dump 'nft meta pkttype' rules.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-shared.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 74e19ccad226..79c93fe82c60 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -25,6 +25,7 @@
 #include <linux/netfilter/xt_limit.h>
 #include <linux/netfilter/xt_NFLOG.h>
 #include <linux/netfilter/xt_mark.h>
+#include <linux/netfilter/xt_pkttype.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
@@ -323,6 +324,27 @@ static int parse_meta_mark(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	return 0;
 }
 
+static int parse_meta_pkttype(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
+{
+	struct xt_pkttype_info *pkttype;
+	struct xtables_match *match;
+	uint8_t value;
+
+	match = nft_create_match(ctx, ctx->cs, "pkttype");
+	if (!match)
+		return -1;
+
+	pkttype = (void*)match->m->data;
+
+	if (nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP) == NFT_CMP_NEQ)
+		pkttype->invert = 1;
+
+	value = nftnl_expr_get_u8(e, NFTNL_EXPR_CMP_DATA);
+	pkttype->pkttype = value;
+
+	return 0;
+}
+
 int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 	       char *iniface, unsigned char *iniface_mask,
 	       char *outiface, unsigned char *outiface_mask, uint8_t *invflags)
@@ -369,6 +391,9 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 	case NFT_META_MARK:
 		parse_meta_mark(ctx, e);
 		break;
+	case NFT_META_PKTTYPE:
+		parse_meta_pkttype(ctx, e);
+		break;
 	default:
 		return -1;
 	}
-- 
2.35.1

