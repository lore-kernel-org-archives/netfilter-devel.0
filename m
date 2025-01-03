Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1122411CA0
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2025 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735925742; cv=none; b=ia4FkSjk7wSE5ewJ4vobbnf/ctdE2bOjdWP5WjTMJ5XUwcQMUMejZJ2LMk0xLPW/cv752j4nWRCmQjnEUsRPpSgq7l8JMXMAku0NH2LY2T13Z1eb2GQ+9qTlIJDZs6vJwstSGDLSP4BgH34scLSq3UmiLBTdAMlrz70+0guXCfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735925742; c=relaxed/simple;
	bh=t9/t6OFBjKtdmzd3zKIf/X24wpTEfVCw46uuAaBA9dc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QiOrJpv4fqQiIasa1BqKN73ao/F8+S+6gkbwjZcDPwJzNeW21c5fMsV09JF56vxLYND8nk7Q5OyuUxrmzpdktxxTtCTBTUvps5WQ0B9Dq/Az6dVSDiBTTfOO2JNdOcHJkFrhU23fO8ibtzdPrm7RumvIWeLAhoarHZE6jaSpVak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
X-Spam-Level: 
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 7/7] src: rework singleton interval transformation to reduce memory consumption
Date: Fri,  3 Jan 2025 18:35:22 +0100
Message-Id: <20250103173522.773063-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250103173522.773063-1-pablo@netfilter.org>
References: <20250103173522.773063-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set_to_intervals() expands range expressions into a list of singleton
elements before building the netlink message that is sent to userspace.
This is because the kernel expects this list of singleton elements where
EXPR_F_INTERVAL_END denotes a closing interval. This expansion
significantly increases memory consumption in userspace.

This patch updates the logic to transform the range expression up to two
temporary singleton element expressions through setelem_to_interval().
Then, these two elements are used to allocate the nftnl_set_elem objects
through alloc_nftnl_setelem_interval() to build the netlink message,
finally all these temporary objects are released. For anonymous sets,
when adjacent ranges are found, the end element is not added to the set
to pack the set representation as in the original set_to_intervals()
routine.

After this update, set_to_intervals() only deals with adding the
non-matching all zero element to the interval set when it is not there
as the kernel expects.

In combination with the new EXPR_RANGE_VALUE expression, this shrinks
runtime userspace memory consumption from 70.50 Mbytes to 43.38 Mbytes
for a 100k intervals set sample.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - restore set_to_intervals() to use loop to iterate elements.
    - added handling to pack adjacents ranges in anonymous sets for
      mnl_nft_setelem_batch() and setelem_to_interval().
    - fix handling of all-zero never-match element in setelem_to_interval()
      leading to bogus zero element in set.

 include/intervals.h |   2 +
 include/list.h      |   8 ++
 include/mnl.h       |   3 +-
 src/intervals.c     | 187 +++++++++++++++++++++++++++++---------------
 src/mnl.c           |  70 +++++++++++++++--
 src/rule.c          |   4 +-
 6 files changed, 202 insertions(+), 72 deletions(-)

diff --git a/include/intervals.h b/include/intervals.h
index ef0fb53e7577..2366c295ca08 100644
--- a/include/intervals.h
+++ b/include/intervals.h
@@ -7,5 +7,7 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	       struct expr *init, unsigned int debug_mask);
 int set_overlap(struct list_head *msgs, struct set *set, struct expr *init);
 int set_to_intervals(const struct set *set, struct expr *init, bool add);
+int setelem_to_interval(const struct set *set, struct expr *elem,
+			struct expr *next_elem, struct list_head *interval_list);
 
 #endif
diff --git a/include/list.h b/include/list.h
index 37fbe3e275cc..4382a67005e8 100644
--- a/include/list.h
+++ b/include/list.h
@@ -348,6 +348,14 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_first_entry(ptr, type, member) \
 	list_entry((ptr)->next, type, member)
 
+/**
+ * list_prev_entry - get the prev element in list
+ * @ptr:        the type * to cursor
+ * @member:     the name of the list_head within the struct.
+ */
+#define list_prev_entry(ptr, member) \
+        list_entry((ptr)->member.prev, typeof(*(ptr)), member)
+
 /**
  * list_last_entry - get the last element from a list
  * @ptr:        the list head to take the element from.
diff --git a/include/mnl.h b/include/mnl.h
index 7c465d4426c4..f50ac644ccb9 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -66,7 +66,8 @@ int mnl_nft_setelem_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			const struct set *set, const struct expr *expr,
 			unsigned int flags);
 int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
-			const struct handle *h, const struct expr *init);
+			const struct handle *h, const struct set *set,
+			const struct expr *init);
 int mnl_nft_setelem_flush(struct netlink_ctx *ctx, const struct cmd *cmd);
 int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls,
 			bool reset);
diff --git a/src/intervals.c b/src/intervals.c
index c46874d9a6ce..71ad210bf759 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -683,30 +683,29 @@ static bool segtree_needs_first_segment(const struct set *set,
 
 int set_to_intervals(const struct set *set, struct expr *init, bool add)
 {
-	struct expr *i, *n, *prev = NULL, *elem, *newelem = NULL, *root, *expr;
+	struct expr *i, *n, *prev = NULL, *elem, *root, *expr;
 	LIST_HEAD(intervals);
-	uint32_t flags;
-	mpz_t p, q;
-
-	mpz_init2(p, set->key->len);
-	mpz_init2(q, set->key->len);
+	mpz_t p;
 
 	list_for_each_entry_safe(i, n, &init->expressions, list) {
-		flags = 0;
-
 		elem = interval_expr_key(i);
 
 		if (elem->key->etype == EXPR_SET_ELEM_CATCHALL)
 			continue;
 
-		if (!prev && segtree_needs_first_segment(set, init, add) &&
+		if (prev)
+			break;
+
+		if (segtree_needs_first_segment(set, init, add) &&
 		    mpz_cmp_ui(elem->key->range.low, 0)) {
+			mpz_init2(p, set->key->len);
 			mpz_set_ui(p, 0);
-			expr = constant_expr_alloc(&internal_location,
-						   set->key->dtype,
-						   set->key->byteorder,
-						   set->key->len, NULL);
-			mpz_set(expr->value, p);
+			expr = constant_range_expr_alloc(&internal_location,
+							 set->key->dtype,
+							 set->key->byteorder,
+							 set->key->len, p, p);
+			mpz_clear(p);
+
 			root = set_elem_expr_alloc(&internal_location, expr);
 			if (i->etype == EXPR_MAPPING) {
 				root = mapping_expr_alloc(&internal_location,
@@ -715,65 +714,129 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 			}
 			root->flags |= EXPR_F_INTERVAL_END;
 			list_add(&root->list, &intervals);
-			init->size++;
+			break;
 		}
+		prev = i;
+	}
 
-		if (newelem) {
-			mpz_set(p, interval_expr_key(newelem)->key->value);
-			if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
-				mpz_switch_byteorder(p, set->key->len / BITS_PER_BYTE);
+	list_splice_init(&intervals, &init->expressions);
 
-			if (!(set->flags & NFT_SET_ANONYMOUS) ||
-			    mpz_cmp(p, elem->key->range.low) != 0)
-				list_add_tail(&newelem->list, &intervals);
-			else
-				expr_free(newelem);
-		}
-		newelem = NULL;
-
-		if (mpz_scan0(elem->key->range.high, 0) != set->key->len) {
-			mpz_add_ui(p, elem->key->range.high, 1);
-			expr = constant_expr_alloc(&elem->key->location, set->key->dtype,
-						   set->key->byteorder, set->key->len,
-						   NULL);
-			mpz_set(expr->value, p);
-			if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
-				mpz_switch_byteorder(expr->value, set->key->len / BITS_PER_BYTE);
-
-			newelem = set_elem_expr_alloc(&expr->location, expr);
-			if (i->etype == EXPR_MAPPING) {
-				newelem = mapping_expr_alloc(&expr->location,
-							     newelem,
-							     expr_get(i->right));
-			}
-			newelem->flags |= EXPR_F_INTERVAL_END;
-		} else {
-			flags = EXPR_F_INTERVAL_OPEN;
-		}
+	return 0;
+}
 
-		expr = constant_expr_alloc(&elem->key->location, set->key->dtype,
-					   set->key->byteorder, set->key->len, NULL);
+/* This only works for the supported stateful statements. */
+static void set_elem_stmt_clone(struct expr *dst, const struct expr *src)
+{
+	struct stmt *stmt, *nstmt;
 
-		mpz_set(expr->value, elem->key->range.low);
-		if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
-			mpz_switch_byteorder(expr->value, set->key->len / BITS_PER_BYTE);
+	list_for_each_entry(stmt, &src->stmt_list, list) {
+		nstmt = xzalloc(sizeof(*stmt));
+		*nstmt = *stmt;
+		list_add_tail(&nstmt->list, &dst->stmt_list);
+	}
+}
 
-		expr_free(elem->key);
-		elem->key = expr;
-		i->flags |= flags;
-		init->size++;
-		list_move_tail(&i->list, &intervals);
+static void set_elem_expr_copy(struct expr *dst, const struct expr *src)
+{
+	if (src->comment)
+		dst->comment = xstrdup(src->comment);
+	if (src->timeout)
+		dst->timeout = src->timeout;
+	if (src->expiration)
+		dst->expiration = src->expiration;
+
+	set_elem_stmt_clone(dst, src);
+}
 
-		prev = i;
+static struct expr *setelem_key(struct expr *expr)
+{
+	struct expr *key;
+
+	switch (expr->etype) {
+	case EXPR_MAPPING:
+		key = expr->left->key;
+		break;
+	case EXPR_SET_ELEM:
+		key = expr->key;
+		break;
+	default:
+		BUG("unhandled expression type %d\n", expr->etype);
+		return NULL;
 	}
 
-	if (newelem)
-		list_add_tail(&newelem->list, &intervals);
+	return key;
+}
 
-	list_splice_init(&intervals, &init->expressions);
+int setelem_to_interval(const struct set *set, struct expr *elem,
+			struct expr *next_elem, struct list_head *intervals)
+{
+	struct expr *key, *next_key = NULL, *low, *high;
+	bool adjacent = false;
+
+	key = setelem_key(elem);
+	if (key->etype == EXPR_SET_ELEM_CATCHALL)
+		return 0;
+
+	if (next_elem) {
+		next_key = setelem_key(next_elem);
+		if (next_key->etype == EXPR_SET_ELEM_CATCHALL)
+			next_key = NULL;
+	}
+
+	assert(key->etype == EXPR_RANGE_VALUE);
+	assert(!next_key || next_key->etype == EXPR_RANGE_VALUE);
+
+	/* skip end element for adjacents intervals in anonymous sets. */
+	if (!(elem->flags & EXPR_F_INTERVAL_END) && next_key) {
+		mpz_t p;
+
+		mpz_init2(p, set->key->len);
+		mpz_add_ui(p, key->range.high, 1);
+
+		if (!mpz_cmp(p, next_key->range.low))
+			adjacent = true;
+
+		mpz_clear(p);
+	}
+
+	low = constant_expr_alloc(&key->location, set->key->dtype,
+				  set->key->byteorder, set->key->len, NULL);
+
+	mpz_set(low->value, key->range.low);
+	if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
+		mpz_switch_byteorder(low->value, set->key->len / BITS_PER_BYTE);
+
+	low = set_elem_expr_alloc(&key->location, low);
+	set_elem_expr_copy(low, interval_expr_key(elem));
+
+	if (elem->etype == EXPR_MAPPING)
+		low = mapping_expr_alloc(&elem->location,
+					 low, expr_get(elem->right));
+
+	list_add_tail(&low->list, intervals);
+
+	if (adjacent)
+		return 0;
+	else if (!mpz_cmp_ui(key->value, 0) && elem->flags & EXPR_F_INTERVAL_END) {
+		low->flags |= EXPR_F_INTERVAL_END;
+		return 0;
+	} else if (mpz_scan0(key->range.high, 0) == set->key->len) {
+		low->flags |= EXPR_F_INTERVAL_OPEN;
+		return 0;
+	}
+
+	high = constant_expr_alloc(&key->location, set->key->dtype,
+				   set->key->byteorder, set->key->len,
+				   NULL);
+	mpz_set(high->value, key->range.high);
+	mpz_add_ui(high->value, high->value, 1);
+	if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
+		mpz_switch_byteorder(high->value, set->key->len / BITS_PER_BYTE);
+
+	high = set_elem_expr_alloc(&key->location, high);
 
-	mpz_clear(p);
-	mpz_clear(q);
+	high->flags |= EXPR_F_INTERVAL_END;
+	list_add_tail(&high->list, intervals);
 
 	return 0;
 }
diff --git a/src/mnl.c b/src/mnl.c
index 5983fd468e56..64b1aaedb84c 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -30,6 +30,7 @@
 
 #include <mnl.h>
 #include <cmd.h>
+#include <intervals.h>
 #include <net/if.h>
 #include <sys/socket.h>
 #include <arpa/inet.h>
@@ -1725,17 +1726,46 @@ static void netlink_dump_setelem_done(struct netlink_ctx *ctx)
 	fprintf(fp, "\n");
 }
 
+static struct nftnl_set_elem *
+alloc_nftnl_setelem_interval(const struct set *set, const struct expr *init,
+			     struct expr *elem, struct expr *next_elem,
+			     struct nftnl_set_elem **nlse_high)
+{
+	struct nftnl_set_elem *nlse[2] = {};
+	LIST_HEAD(interval_list);
+	struct expr *expr, *next;
+	int i = 0;
+
+	if (setelem_to_interval(set, elem, next_elem, &interval_list) < 0)
+		memory_allocation_error();
+
+	if (list_empty(&interval_list)) {
+		*nlse_high = NULL;
+		nlse[i++] = alloc_nftnl_setelem(init, elem);
+		return nlse[0];
+	}
+
+	list_for_each_entry_safe(expr, next, &interval_list, list) {
+		nlse[i++] = alloc_nftnl_setelem(init, expr);
+		list_del(&expr->list);
+		expr_free(expr);
+	}
+	*nlse_high = nlse[1];
+
+	return nlse[0];
+}
+
 static int mnl_nft_setelem_batch(const struct nftnl_set *nls, struct cmd *cmd,
 				 struct nftnl_batch *batch,
 				 enum nf_tables_msg_types msg_type,
 				 unsigned int flags, uint32_t *seqnum,
-				 const struct expr *init,
+				 const struct set *set, const struct expr *init,
 				 struct netlink_ctx *ctx)
 {
+	struct nftnl_set_elem *nlse, *nlse_high = NULL;
+	struct expr *expr = NULL, *next;
 	struct nlattr *nest1, *nest2;
-	struct nftnl_set_elem *nlse;
 	struct nlmsghdr *nlh;
-	struct expr *expr = NULL;
 	int i = 0;
 
 	if (msg_type == NFT_MSG_NEWSETELEM)
@@ -1768,9 +1798,30 @@ next:
 	assert(expr);
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
 	list_for_each_entry_from(expr, &init->expressions, list) {
-		nlse = alloc_nftnl_setelem(init, expr);
+
+		if (set_is_non_concat_range(set)) {
+			if (set_is_anonymous(set->flags) &&
+			    !list_is_last(&expr->list, &init->expressions))
+				next = list_next_entry(expr, list);
+			else
+				next = NULL;
+
+			if (!nlse_high) {
+				nlse = alloc_nftnl_setelem_interval(set, init, expr, next, &nlse_high);
+			} else {
+				nlse = nlse_high;
+				nlse_high = NULL;
+			}
+		} else {
+			nlse = alloc_nftnl_setelem(init, expr);
+		}
 
 		cmd_add_loc(cmd, nlh, &expr->location);
+
+		/* remain with this element, range high still needs to be added. */
+		if (nlse_high)
+			expr = list_prev_entry(expr, list);
+
 		nest2 = mnl_attr_nest_start(nlh, ++i);
 		nftnl_set_elem_nlmsg_build_payload(nlh, nlse);
 		mnl_attr_nest_end(nlh, nest2);
@@ -1778,6 +1829,10 @@ next:
 		netlink_dump_setelem(nlse, ctx);
 		nftnl_set_elem_free(nlse);
 		if (mnl_nft_attr_nest_overflow(nlh, nest1, nest2)) {
+			if (nlse_high) {
+				nftnl_set_elem_free(nlse_high);
+				nlse_high = NULL;
+			}
 			mnl_attr_nest_end(nlh, nest1);
 			mnl_nft_batch_continue(batch);
 			mnl_seqnum_inc(seqnum);
@@ -1815,7 +1870,7 @@ int mnl_nft_setelem_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_batch(nls, cmd, ctx->batch, NFT_MSG_NEWSETELEM,
-				    flags, &ctx->seqnum, expr, ctx);
+				    flags, &ctx->seqnum, set, expr, ctx);
 	nftnl_set_free(nls);
 
 	return err;
@@ -1852,7 +1907,8 @@ int mnl_nft_setelem_flush(struct netlink_ctx *ctx, const struct cmd *cmd)
 }
 
 int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
-			const struct handle *h, const struct expr *init)
+			const struct handle *h, const struct set *set,
+			const struct expr *init)
 {
 	enum nf_tables_msg_types msg_type = NFT_MSG_DELSETELEM;
 	struct nftnl_set *nls;
@@ -1875,7 +1931,7 @@ int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
 		msg_type = NFT_MSG_DESTROYSETELEM;
 
 	err = mnl_nft_setelem_batch(nls, cmd, ctx->batch, msg_type, 0,
-				    &ctx->seqnum, init, ctx);
+				    &ctx->seqnum, set, init, ctx);
 	nftnl_set_free(nls);
 
 	return err;
diff --git a/src/rule.c b/src/rule.c
index 151ed531969c..b897a15fcdf1 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1550,14 +1550,14 @@ static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
 {
+	const struct set *set = cmd->elem.set;
 	struct expr *expr = cmd->elem.expr;
-	struct set *set = cmd->elem.set;
 
 	if (set_is_non_concat_range(set) &&
 	    set_to_intervals(set, expr, false) < 0)
 		return -1;
 
-	if (mnl_nft_setelem_del(ctx, cmd, &cmd->handle, cmd->elem.expr) < 0)
+	if (mnl_nft_setelem_del(ctx, cmd, &cmd->handle, set, cmd->elem.expr) < 0)
 		return -1;
 
 	return 0;
-- 
2.30.2

