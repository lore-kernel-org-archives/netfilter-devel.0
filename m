From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] payload: remove byteorder conversion
Date: Fri,  9 Sep 2016 14:43:16 +0200
Message-ID: <1473424996-26957-4-git-send-email-fw@strlen.de>
References: <1473424996-26957-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48770 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753033AbcIIMnL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 08:43:11 -0400
In-Reply-To: <1473424996-26957-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is what made ether addresses get formatted correctly with
plain payload expression (ether saddr 00:11 ...) when listing
rules.  Not needed anymore since etheraddr_type is now BIG_ENDIAN.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index cddbfa6..05edb01 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1161,8 +1161,6 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 	list_for_each_entry(left, &list, list) {
 		tmp = constant_expr_splice(right, left->len);
 		expr_set_type(tmp, left->dtype, left->byteorder);
-		if (tmp->byteorder == BYTEORDER_HOST_ENDIAN)
-			mpz_switch_byteorder(tmp->value, tmp->len / BITS_PER_BYTE);
 
 		nexpr = relational_expr_alloc(&expr->location, expr->op,
 					      left, tmp);
-- 
2.7.3

