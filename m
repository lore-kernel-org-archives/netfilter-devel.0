From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/5] src: netlink_delinearize: don't assume element contains a value
Date: Thu, 11 Jan 2018 16:30:21 +0100
Message-ID: <20180111153024.25198-4-fw@strlen.de>
References: <20180111153024.25198-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57492 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932470AbeAKPmn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 10:42:43 -0500
In-Reply-To: <20180111153024.25198-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We cannot assume i->key->key is EXPR_VALUE, we could look e.g.  at a range,
which will trigger an assertion failure in binop_adjust_one().

We should call __binop_adjust recursively again in the EXPR_SET_ELEM case,
using key as new input.

Fixes: b8b8e7b6ae10 ("evaluate: transfer right shifts to set reference side")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 2637f4baaec4..655de9e252b8 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1515,7 +1515,7 @@ static void __binop_adjust(const struct expr *binop, struct expr *right,
 				binop_adjust_one(binop, i->key->right, shift);
 				break;
 			case EXPR_SET_ELEM:
-				binop_adjust_one(binop, i->key->key, shift);
+				__binop_adjust(binop, i->key->key, shift);
 				break;
 			default:
 				BUG("unknown expression type %s\n", i->key->ops->name);
-- 
2.13.6

