From: Florian Westphal <fw@strlen.de>
Subject: nft: meta l4proto range printing broken on 32bit
Date: Thu, 16 Jul 2015 15:39:29 +0200
Message-ID: <20150716133929.GK25674@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55614 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705AbbGPNja (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jul 2015 09:39:30 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.80)
	(envelope-from <fw@strlen.de>)
	id 1ZFjNp-0000Yg-7G
	for netfilter-devel@vger.kernel.org; Thu, 16 Jul 2015 15:39:29 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo

09565a4b1ed4863d44c4509a93c50f44efd12771
(netlink_delinearize: consolidate range printing) causes nft
to segfault on 32bit machine when printing l4proto ranges.

The problem is that meta_expr_pctx_update() assumes that
right is a value, but after this change it can also be a value.

Thus, expr->value contents are undefined (its union).
On x86_64 this is also broken but by virtue of struct layout
and pointer sizes, value->_mp_size will almost always be 0
so mpz_get_uint8() returns 0.

But on x86-32 _mp_size will be huge value (contains expr->right pointer
of range), so we crash in libgmp.

This fixes it for me:

diff --git a/src/meta.c b/src/meta.c
index bfc1258..e6d69e3 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -462,7 +462,7 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 {
        const struct hook_proto_desc *h = &hook_proto_desc[ctx->family];
        const struct expr *left = expr->left, *right = expr->right;
-       const struct proto_desc *desc;
+       const struct proto_desc *desc = NULL;
 
        assert(expr->op == OP_EQ);
 
@@ -485,8 +485,10 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
                proto_ctx_update(ctx, PROTO_BASE_NETWORK_HDR, &expr->location, desc);
                break;
        case NFT_META_L4PROTO:
-               desc = proto_find_upper(&proto_inet_service,
-                                       mpz_get_uint8(right->value));
+               if (right->ops->type == EXPR_VALUE)
+                       desc = proto_find_upper(&proto_inet_service,
+                                               mpz_get_uint8(right->value));
+
                if (desc == NULL)
                        desc = &proto_unknown;

If you agree, I'll push this fix to nftables.
