From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] set: properly account set size when merging recursive set definitions
Date: Fri,  7 Mar 2014 11:21:19 +0100
Message-ID: <1394187679-29596-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36172 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaCGKVV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:21:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index f10d0d9..0c19c9f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -683,6 +683,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			/* Merge recursive set definitions */
 			list_splice_tail_init(&i->expressions, &i->list);
 			list_del(&i->list);
+			set->size      += i->size;
 			set->set_flags |= i->set_flags;
 			expr_free(i);
 		} else if (!expr_is_singleton(i))
-- 
1.8.5.3

