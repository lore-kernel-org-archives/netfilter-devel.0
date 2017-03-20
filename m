From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/2] evaluate: set: Fix nested set merge size adjustment
Date: Mon, 20 Mar 2017 17:38:56 +0100
Message-ID: <20170320163856.6064-3-phil@nwl.cc>
References: <20170320163856.6064-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:42665 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755376AbdCTRCz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 13:02:55 -0400
In-Reply-To: <20170320163856.6064-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When merging a nested set into the parent one, we are actually replacing
one item with the items of the nested set. Therefore we have to remove
the replaced item from size.

The respective bug isn't as easy to trigger, since the size field seems
to be relevant only when set elements are ranges which are checked for
overlaps. Here's an example of how to trigger it:

| add rule ip saddr { { 1.1.1.0/24, 3.3.3.0/24 }, 2.2.2.0/24 }

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 86ff8ebd17629..b5db724cbd37b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1149,7 +1149,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			/* Merge recursive set definitions */
 			list_splice_tail_init(&i->expressions, &i->list);
 			list_del(&i->list);
-			set->size      += i->size;
+			set->size      += i->size - 1;
 			set->set_flags |= i->set_flags;
 			expr_free(i);
 		} else if (!expr_is_singleton(i))
-- 
2.11.0

