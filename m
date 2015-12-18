From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/5] netlink: only drop mask if it matches left known-size operand
Date: Fri, 18 Dec 2015 22:08:01 +0100
Message-ID: <1450472883-19743-4-git-send-email-fw@strlen.de>
References: <1450472883-19743-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40518 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965367AbbLRVMB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 16:12:01 -0500
In-Reply-To: <1450472883-19743-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

During delinearization we attempt to remove masks, for instance
ip saddr $x/32. (mask matches the entire size).

However, in some special cases the lhs size is unknown (0), this
happens f.e. with

'ct saddr original 1.2.3.4/24' which had its '/24' chopped off.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index a983fce..c9db27d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -331,12 +331,14 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 		mpz_ior(m, m, o);
 	}
 
-	if (mpz_scan0(m, 0) != left->len) {
+	if (left->len > 0 && mpz_scan0(m, 0) == left->len) {
+		/* mask encompasses the entire value */
+		expr_free(mask);
+	} else {
 		mpz_set(mask->value, m);
 		expr = binop_expr_alloc(loc, OP_AND, expr, mask);
 		expr->len = left->len;
-	} else
-		expr_free(mask);
+	}
 
 	if (mpz_cmp_ui(x, 0)) {
 		mpz_set(xor->value, x);
-- 
2.4.10

