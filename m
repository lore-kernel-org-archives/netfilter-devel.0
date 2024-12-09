Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8CF823315A
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2024 18:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767216; cv=none; b=lLsX+R0ysRLWVhoK4rS3Eocf9Px1IM/yR6IqFiImHv2blpjoMmv065CSFDTv8YGv/2dk3xZ+RqjQrJ2nUC7GmLu2fAHSYZ6VVgSnRL6VQNy3rEHRSouD3SidbC+YWTipp/RmWTY8xilIQTHKaYww/TNMyG/1v/kgz86OCpQLmmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767216; c=relaxed/simple;
	bh=hYbz7TOqEjaFjrYgkNtEnMB6XRP8wyAK50IyEi9xTgs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=E9/KUePdQsnkmLxwUg6nb8ZB0oqlklAMWZNWKCG//+rUq4vQs8xabqRVJ998LsbS6OdI1Dg+vGGnFWzLs9P6czyHOVfAhrVivLcTeGwEZhx8k0crlBHq+h/cNwnr/EG0XX55ZUsPWT62iaylaMFAUnt8pcYFu50BT9N1GYE6P1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH] intervals: set internal element location with the deletion trigger
Date: Mon,  9 Dec 2024 19:00:09 +0100
Message-Id: <20241209180009.518915-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set location of internal elements (already in the kernel) to the one
that partial or fully deletes it.

Otherwise, error reporting refers to internal location.

Before this patch:

 # nft delete element x y { 1.1.1.3 }
 Error: Could not process rule: Too many open files in system
 delete element x y { 1.1.1.3 }
                      ^^^^^^^

After this patch:

 # nft delete element x y { 1.1.1.3 }
 Error: Could not process rule: Too many open files in system
 delete element x y { 1.1.1.3 }
                      ^^^^^^^

This occurs after splitting an existing interval in two:

 remove: [1010100-10101ff]
 add: [1010100-1010102]
 add: [1010104-10101ff]

which results in two additions after removing the existing interval
that is split.

Fixes: 81e36530fcac ("src: replace interval segment tree overlap and automerge")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/src/intervals.c b/src/intervals.c
index ff202be9375b..a58ec5b26397 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -86,6 +86,7 @@ static void remove_overlapping_range(struct set_automerge_ctx *ctx,
 				     struct expr *prev, struct expr *i)
 {
 	if (i->flags & EXPR_F_KERNEL) {
+		i->location = prev->location;
 		purge_elem(ctx, i);
 		return;
 	}
@@ -104,12 +105,14 @@ static bool merge_ranges(struct set_automerge_ctx *ctx,
 			 struct range *prev_range, struct range *range)
 {
 	if (prev->flags & EXPR_F_KERNEL) {
+		prev->location = i->location;
 		purge_elem(ctx, prev);
 		expr_free(i->key->left);
 		i->key->left = expr_get(prev->key->left);
 		mpz_set(prev_range->high, range->high);
 		return true;
 	} else if (i->flags & EXPR_F_KERNEL) {
+		i->location = prev->location;
 		purge_elem(ctx, i);
 		expr_free(prev->key->right);
 		prev->key->right = expr_get(i->key->right);
@@ -304,6 +307,7 @@ static void __adjust_elem_left(struct set *set, struct expr *prev, struct expr *
 static void adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
 			     struct expr *purge)
 {
+	prev->location = i->location;
 	remove_elem(prev, set, purge);
 	__adjust_elem_left(set, prev, i);
 
@@ -323,6 +327,7 @@ static void __adjust_elem_right(struct set *set, struct expr *prev, struct expr
 static void adjust_elem_right(struct set *set, struct expr *prev, struct expr *i,
 			      struct expr *purge)
 {
+	prev->location = i->location;
 	remove_elem(prev, set, purge);
 	__adjust_elem_right(set, prev, i);
 
@@ -335,6 +340,8 @@ static void split_range(struct set *set, struct expr *prev, struct expr *i,
 {
 	struct expr *clone;
 
+	prev->location = i->location;
+
 	if (prev->flags & EXPR_F_KERNEL) {
 		clone = expr_clone(prev);
 		list_move_tail(&clone->list, &purge->expressions);
@@ -422,8 +429,10 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 		if (mpz_cmp(prev_range.low, range.low) == 0 &&
 		    mpz_cmp(prev_range.high, range.high) == 0) {
 			if (elem->flags & EXPR_F_REMOVE) {
-				if (prev->flags & EXPR_F_KERNEL)
+				if (prev->flags & EXPR_F_KERNEL) {
+					prev->location = elem->location;
 					list_move_tail(&prev->list, &purge->expressions);
+				}
 
 				list_del(&elem->list);
 				expr_free(elem);
-- 
2.30.2

