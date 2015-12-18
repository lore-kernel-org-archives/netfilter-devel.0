From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/5] netlink: don't handle lhs zero-length expression as concat type
Date: Fri, 18 Dec 2015 22:08:00 +0100
Message-ID: <1450472883-19743-3-git-send-email-fw@strlen.de>
References: <1450472883-19743-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40517 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965282AbbLRVMB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 16:12:01 -0500
In-Reply-To: <1450472883-19743-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

expr->len 0 can appear for some data types whose size can be different
based on some external state, e.g. the conntrack src/dst addresses.

The nft type is 'invalid/0-length' in the template definition, the
size is set (on linearization) based on the network base family,
i.e. the type is changed to ip or ipv6 address at a later stage.

For delinarization, skip zero-length expression as concat type
and give expr_postprocess a chance to fix the types.

Without this change the previous patch will result in nft consuming all
available memory when trying to display e.g. a 'ct saddr' rule.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 306d1b8..a983fce 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -236,7 +236,7 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	    left->dtype != &string_type) {
 		return netlink_error(ctx, loc,
 				     "Relational expression size mismatch");
-	} else if (left->len < right->len) {
+	} else if (left->len > 0 && left->len < right->len) {
 		left = netlink_parse_concat_expr(ctx, loc, sreg, right->len);
 		if (left == NULL)
 			return;
-- 
2.4.10

