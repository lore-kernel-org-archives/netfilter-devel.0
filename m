Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9ED4C00528
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Aug 2023 23:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjHDXPv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 19:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjHDXPu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 19:15:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C92E60
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Aug 2023 16:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=satVHyOCGnCKJI0NY94uMiJEoYCJnJIXh0wTkLOtEmk=; b=aNlqerM7sprrmulcRsuEGjY98v
        rniAUwOx/2j+uMNwgutpMvZY9/5re6yw06oifoHZyxdEKWPO9uj5z83kDOpKUu3qE7zrtQueVchQE
        jJ1uvRr3RhJz66fzHDOJEk5RHN+V4O+CGoGpkMSEv4aTYQgT5D5DM6tK9VbZNoexUKkLkDxgSHbey
        6ibGr8oEz5Ut/0GGXmr+taZ7ML1PbApk7LRuDb6536Q6WdhdWo42E7TQu9M41COnTYckA3+8nDrpb
        9grPE4kb/+FFUVWVTZoXpqFst/nKzZqJGqXeZCRgcZVyaVxjC/mhuvOWDccD8wT6TMWU6stkF3FPA
        kvMuBb0w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qS41J-0008KD-SF; Sat, 05 Aug 2023 01:15:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 2/2] nft-ruleparse: parse meta mark set as MARK target
Date:   Sat,  5 Aug 2023 01:15:37 +0200
Message-Id: <20230804231537.17705-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230804231537.17705-1-phil@nwl.cc>
References: <20230804231537.17705-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Mixing nftables and iptables-nft in the same table doesn't work,
but some people do this.

v1.8.8 ignored rules it could not represent in iptables syntax,
v1.8.9 bails in this case.

Add parsing of meta mark expressions so iptables-nft can render them
as -j MARK rules.

This is flawed, nft has features that have no corresponding
syntax in iptables, but we can't undo this.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1659
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ruleparse.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index a5eb6d098084a..c8322f936acd9 100644
--- a/iptables/nft-ruleparse.c
+++ b/iptables/nft-ruleparse.c
@@ -146,11 +146,6 @@ static bool nft_parse_meta_set_common(struct nft_xt_ctx* ctx,
 		return false;
 	}
 
-	if (sreg->immediate.data[0] == 0) {
-		ctx->errmsg = "meta sreg immediate is 0";
-		return false;
-	}
-
 	return true;
 }
 
@@ -159,7 +154,6 @@ static void nft_parse_meta_set(struct nft_xt_ctx *ctx,
 {
 	struct nft_xt_ctx_reg *sreg;
 	enum nft_registers sregnum;
-	const char *targname;
 
 	sregnum = nftnl_expr_get_u32(e, NFTNL_EXPR_META_SREG);
 	sreg = nft_xt_ctx_get_sreg(ctx, sregnum);
@@ -171,21 +165,43 @@ static void nft_parse_meta_set(struct nft_xt_ctx *ctx,
 		if (!nft_parse_meta_set_common(ctx, sreg))
 			return;
 
-		targname = "TRACE";
+		if (sreg->immediate.data[0] == 0) {
+			ctx->errmsg = "meta sreg immediate is 0";
+			return;
+		}
+
+		if (!nft_create_target(ctx, "TRACE"))
+			ctx->errmsg = "target TRACE not found";
 		break;
 	case NFT_META_BRI_BROUTE:
 		if (!nft_parse_meta_set_common(ctx, sreg))
 			return;
 
 		ctx->cs->jumpto = "DROP";
-		return;
+		break;
+	case NFT_META_MARK: {
+		struct xt_mark_tginfo2 *mt;
+
+		if (!nft_parse_meta_set_common(ctx, sreg))
+			return;
+
+		mt = nft_create_target(ctx, "MARK");
+		if (!mt) {
+			ctx->errmsg = "target MARK not found";
+			return;
+		}
+
+		mt->mark = sreg->immediate.data[0];
+		if (sreg->bitwise.set)
+			mt->mask = sreg->bitwise.mask[0];
+		else
+			mt->mask = ~0u;
+		break;
+	}
 	default:
 		ctx->errmsg = "meta sreg key not supported";
-		return;
+		break;
 	}
-
-	if (!nft_create_target(ctx, targname))
-		ctx->errmsg = "target TRACE not found";
 }
 
 static void nft_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
-- 
2.40.0

