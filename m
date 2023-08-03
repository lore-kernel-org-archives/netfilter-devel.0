Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDBFC001DF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 19:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjHCTjd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 15:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjHCTjc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 15:39:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8D44221
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 12:39:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qReAP-0007hv-U8; Thu, 03 Aug 2023 21:39:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     robert.smith51@protonmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] nft-ruleparse: parse meta mark set as MARK target
Date:   Thu,  3 Aug 2023 21:39:13 +0200
Message-ID: <20230803193917.26779-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
---
 iptables/nft-ruleparse.c | 83 +++++++++++++++++++++++++++-------------
 1 file changed, 56 insertions(+), 27 deletions(-)

diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index edbbfa40e9c4..44b9bcc268f4 100644
--- a/iptables/nft-ruleparse.c
+++ b/iptables/nft-ruleparse.c
@@ -84,6 +84,37 @@ nft_create_match(struct nft_xt_ctx *ctx,
 	return match->m->data;
 }
 
+static void *
+nft_create_target(struct nft_xt_ctx *ctx,
+		  struct iptables_command_state *cs,
+		  const char *name)
+{
+	struct xtables_target *target;
+	struct xt_entry_target *t;
+	unsigned int size;
+
+	target = xtables_find_target(name, XTF_TRY_LOAD);
+	if (!target) {
+		ctx->errmsg = "target not found";
+		return NULL;
+	}
+
+	size = XT_ALIGN(sizeof(struct xt_entry_target)) + target->size;
+
+	t = xtables_calloc(1, size);
+	t->u.target_size = size;
+	t->u.user.revision = target->revision;
+	strcpy(t->u.user.name, name);
+
+	target->t = t;
+
+	xs_init_target(target);
+
+	ctx->h->ops->rule_parse->target(target, ctx->cs);
+
+	return target->t->data;
+}
+
 static void nft_parse_counter(struct nftnl_expr *e, struct xt_counters *counters)
 {
 	counters->pcnt = nftnl_expr_get_u64(e, NFTNL_EXPR_CTR_PACKETS);
@@ -112,23 +143,14 @@ static bool nft_parse_meta_set_common(struct nft_xt_ctx* ctx,
 		return false;
 	}
 
-	if (sreg->immediate.data[0] == 0) {
-		ctx->errmsg = "meta sreg immediate is 0";
-		return false;
-	}
-
 	return true;
 }
 
 static void nft_parse_meta_set(struct nft_xt_ctx *ctx,
 			       struct nftnl_expr *e)
 {
-	struct xtables_target *target;
 	struct nft_xt_ctx_reg *sreg;
 	enum nft_registers sregnum;
-	struct xt_entry_target *t;
-	unsigned int size;
-	const char *targname;
 
 	sregnum = nftnl_expr_get_u32(e, NFTNL_EXPR_META_SREG);
 	sreg = nft_xt_ctx_get_sreg(ctx, sregnum);
@@ -140,7 +162,13 @@ static void nft_parse_meta_set(struct nft_xt_ctx *ctx,
 		if (!nft_parse_meta_set_common(ctx, sreg))
 			return;
 
-		targname = "TRACE";
+		if (sreg->immediate.data[0] == 0) {
+			ctx->errmsg = "meta sreg immediate is 0";
+			return;
+		}
+
+		if (nft_create_target(ctx, ctx->cs, "TRACE"))
+			return;
 		break;
 	case NFT_META_BRI_BROUTE:
 		if (!nft_parse_meta_set_common(ctx, sreg))
@@ -148,27 +176,28 @@ static void nft_parse_meta_set(struct nft_xt_ctx *ctx,
 
 		ctx->cs->jumpto = "DROP";
 		return;
-	default:
-		ctx->errmsg = "meta sreg key not supported";
-		return;
-	}
-
-	target = xtables_find_target(targname, XTF_TRY_LOAD);
-	if (target == NULL) {
-		ctx->errmsg = "target TRACE not found";
-		return;
-	}
+	case NFT_META_MARK: {
+		struct xt_mark_tginfo2 *mt;
 
-	size = XT_ALIGN(sizeof(struct xt_entry_target)) + target->size;
+		if (!nft_parse_meta_set_common(ctx, sreg))
+			return;
 
-	t = xtables_calloc(1, size);
-	t->u.target_size = size;
-	t->u.user.revision = target->revision;
-	strcpy(t->u.user.name, targname);
+		mt = nft_create_target(ctx, ctx->cs, "MARK");
+		if (!mt)
+			return;
 
-	target->t = t;
+		mt->mark = sreg->immediate.data[0];
+		if (sreg->bitwise.set)
+			mt->mask = sreg->bitwise.mask[0];
+		else
+			mt->mask = ~0u;
 
-	ctx->h->ops->rule_parse->target(target, ctx->cs);
+		return;
+	}
+	default:
+		ctx->errmsg = "meta sreg key not supported";
+		return;
+	}
 }
 
 static void nft_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
-- 
2.41.0

