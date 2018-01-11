From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/5] src: segtree: use value expression length
Date: Thu, 11 Jan 2018 16:30:20 +0100
Message-ID: <20180111153024.25198-3-fw@strlen.de>
References: <20180111153024.25198-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57488 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751968AbeAKPmk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 10:42:40 -0500
In-Reply-To: <20180111153024.25198-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case of EXPR_MAPPING, expr->len is 0, we need to use
the length of the key instead.

Without this we can get assertion failure later on:
nft: netlink_delinearize.c:1484: binop_adjust_one: Assertion `value->len >= binop->right->len' failed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/segtree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 8d36cc9b0d65..1f0d1a4ba7ae 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -697,7 +697,7 @@ void interval_map_decompose(struct expr *set)
 			struct expr *tmp;
 
 			tmp = constant_expr_alloc(&low->location, low->dtype,
-						  low->byteorder, low->len,
+						  low->byteorder, expr_value(low)->len,
 						  NULL);
 
 			mpz_add(range, range, expr_value(low)->value);
-- 
2.13.6

