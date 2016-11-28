From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 1/3] evaluate: Add set to cache only when well-formed
Date: Mon, 28 Nov 2016 17:43:08 +0100
Message-ID: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:39568 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932357AbcK1Qn1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 11:43:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When creating a set (in set_evaluate), it is added to the table cache before
being checked for correctness. When the set is ill-formed, the function returns
without removing the (non-existent, since the function returned) set. Further
references to this set will not result in an error (since the set is in the
lookup table), but the malformed set will probably cause a segfault.

The symptom (the segfault) was fixed by checking for NULL when evaluating a
reference to the set (commit 5afa5a164ff1c066af1ec56d875b91562882bd50), this
should fix the root cause.

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 src/evaluate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8b113c8..b12af14 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2550,9 +2550,6 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 				 ctx->cmd->handle.table);
 
-	if (set_lookup(table, set->handle.set) == NULL)
-		set_add_hash(set_get(set), table);
-
 	type = set->flags & SET_F_MAP ? "map" : "set";
 
 	if (set->keytype == NULL)
@@ -2583,6 +2580,9 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	}
 	ctx->set = NULL;
 
+	if (set_lookup(table, set->handle.set) == NULL)
+		set_add_hash(set_get(set), table);
+
 	/* Default timeout value implies timeout support */
 	if (set->timeout)
 		set->flags |= SET_F_TIMEOUT;
-- 
2.11.0.rc2

