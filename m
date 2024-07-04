Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE8B143741
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2024 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720128872; cv=none; b=SU3UFEEkOd8b14v/y/Ngqo/wLALL7/d5xFdnQHtA5XXMyf2X9sOoIBWiCwD6JCr8g68URlOZQoAHWRi95GD7hfiDQg95Z5efNTWtsw7mrRLCI3wA5hhI3JPZNg+VzKgtyhw6gTLb28fs1WA+gS5SSkk3V0KN70H9x6+cjdovoG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720128872; c=relaxed/simple;
	bh=mojcXQB9NoLyqPCXdyM7AlW1e2KbW6de26gDrL6/vYQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dsh6jRHh5CSLpccmz02gpAjfNHWoMt6NxTI95KjODLdw+2x7ArQLMlbGib0xSFcguikQju45rlpY2gJlCykk54PBmYYLdMzY6L4MZbQw5m5yq1ci6kG2872L4rkPsrq0bijhPY+UGyKHSD4UeIMSOTxMqWtM22CEUBF/wMx5mCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] intervals: fix element deletions with maps
Date: Thu,  4 Jul 2024 23:34:22 +0200
Message-Id: <20240704213423.254356-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240704213423.254356-1-pablo@netfilter.org>
References: <20240704213423.254356-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set element deletion in maps (including catchall elements) does not work.

 # nft delete element ip x m { \* }
 BUG: invalid range expression type catch-all set element
 nft: src/expression.c:1472: range_expr_value_low: Assertion `0' failed.
 Aborted

Call interval_expr_key() to fetch expr->left in the mapping but use the
expression that represents the mapping because it provides access to the
EXPR_F_REMOVE flags.

Moreover, assume maximum value for catchall expression by means of the
expr->len to reuse the existing code to check if the element to be
deleted really exists.

Fixes: 3e8d934e4f72 ("intervals: support to partial deletion with automerge")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 6c3f36fec02a..ff202be9375b 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -383,7 +383,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 			  struct expr *purge, struct expr *elems,
 			  unsigned int debug_mask)
 {
-	struct expr *i, *next, *prev = NULL;
+	struct expr *i, *next, *elem, *prev = NULL;
 	struct range range, prev_range;
 	int err = 0;
 	mpz_t rop;
@@ -394,21 +394,26 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 	mpz_init(range.high);
 	mpz_init(rop);
 
-	list_for_each_entry_safe(i, next, &elems->expressions, list) {
-		if (i->key->etype == EXPR_SET_ELEM_CATCHALL)
-			continue;
+	list_for_each_entry_safe(elem, next, &elems->expressions, list) {
+		i = interval_expr_key(elem);
 
-		range_expr_value_low(range.low, i);
-		range_expr_value_high(range.high, i);
+		if (i->key->etype == EXPR_SET_ELEM_CATCHALL) {
+			/* Assume max value to simplify handling. */
+			mpz_bitmask(range.low, i->len);
+			mpz_bitmask(range.high, i->len);
+		} else {
+			range_expr_value_low(range.low, i);
+			range_expr_value_high(range.high, i);
+		}
 
-		if (!prev && i->flags & EXPR_F_REMOVE) {
+		if (!prev && elem->flags & EXPR_F_REMOVE) {
 			expr_error(msgs, i, "element does not exist");
 			err = -1;
 			goto err;
 		}
 
-		if (!(i->flags & EXPR_F_REMOVE)) {
-			prev = i;
+		if (!(elem->flags & EXPR_F_REMOVE)) {
+			prev = elem;
 			mpz_set(prev_range.low, range.low);
 			mpz_set(prev_range.high, range.high);
 			continue;
@@ -416,12 +421,12 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 
 		if (mpz_cmp(prev_range.low, range.low) == 0 &&
 		    mpz_cmp(prev_range.high, range.high) == 0) {
-			if (i->flags & EXPR_F_REMOVE) {
+			if (elem->flags & EXPR_F_REMOVE) {
 				if (prev->flags & EXPR_F_KERNEL)
 					list_move_tail(&prev->list, &purge->expressions);
 
-				list_del(&i->list);
-				expr_free(i);
+				list_del(&elem->list);
+				expr_free(elem);
 			}
 		} else if (set->automerge) {
 			if (setelem_adjust(set, purge, &prev_range, &range, prev, i) < 0) {
@@ -429,7 +434,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 				err = -1;
 				goto err;
 			}
-		} else if (i->flags & EXPR_F_REMOVE) {
+		} else if (elem->flags & EXPR_F_REMOVE) {
 			expr_error(msgs, i, "element does not exist");
 			err = -1;
 			goto err;
-- 
2.30.2

