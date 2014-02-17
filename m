From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink: meta: fix wrong type in attributes
Date: Mon, 17 Feb 2014 16:48:05 +0100
Message-ID: <1392652085-8225-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48845 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753537AbaBQPv5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:51:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We segfault on 'list filter' when meta expr is used as _u8
returns invalid register 0.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 6668308..b976d86 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -346,9 +346,9 @@ static void netlink_parse_meta_sreg(struct netlink_parse_ctx *ctx,
 	struct expr *expr;
 
 	expr = netlink_get_register(ctx, loc,
-			nft_rule_expr_get_u8(nle, NFT_EXPR_META_SREG));
+			nft_rule_expr_get_u32(nle, NFT_EXPR_META_SREG));
 	stmt = meta_stmt_alloc(loc,
-			       nft_rule_expr_get_u8(nle, NFT_EXPR_META_KEY),
+			       nft_rule_expr_get_u32(nle, NFT_EXPR_META_KEY),
 			       expr);
 	expr_set_type(expr, stmt->meta.tmpl->dtype, stmt->meta.tmpl->byteorder);
 
-- 
1.8.1.5

