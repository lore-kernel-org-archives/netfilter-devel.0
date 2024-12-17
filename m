Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36CC21DA61D
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2024 21:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470130; cv=none; b=JdZLzhSnE55jPyeBl9IfEriandslmWHAGONDs+j4Ch9bmwCD1DbWIuGFLohDX7F+4uFVOajzefEg37ptNT1Jj/JevCtTPmL4KOy8NadxLBR1w2E6AKe6ZgfG/UfG4hFRhaSoYg0rFzazz+1+MdY7mxmC5AhuLRazs98Afyya2bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470130; c=relaxed/simple;
	bh=2CwENfB4ksTEwKlmYQw0THwPCKq041UE9CPjM/vg98s=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y8HfahBbdaQyGgIzDC3yATyzpJpje1M0jloNXYvY5l9xiAx7pk0VlplhxmzP2TJ0qg9CaS7bcrELhZdV6xmOl/7jm7D7C0QVhJ+e0n0dYr+T2xm7lQNLJdbsvNijY7eoNs3zexVmDexdH0WVwoYfA3TeSINVMH1sJylZOTNM+Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 6/6] src: rework singleton interval transformation to reduce memory consumption
Date: Tue, 17 Dec 2024 22:15:16 +0100
Message-Id: <20241217211516.1644623-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241217211516.1644623-1-pablo@netfilter.org>
References: <20241217211516.1644623-1-pablo@netfilter.org>
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
finally all these temporary objects are released.

After this update, set_to_intervals() only deals with adding the
non-matching all zero element to the interval set when it is not there
as the kernel expects. The set size used to be monotonically incremented
from set_to_intervals() during the expansion from range to singleton
elements. After this patch, mnl_nft_set_add() calculates the set size
based on the expansion to individual elements.

In combination with the new EXPR_RANGE_VALUE expression, this shrinks
runtime userspace memory consumption from 70.50 Mbytes to 43.38 Mbytes
for a 100k intervals set sample.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/intervals.h |   2 +
 include/list.h      |   8 ++
 include/mnl.h       |   3 +-
 src/intervals.c     | 180 ++++++++++++++++++++++++++------------------
 src/mnl.c           |  73 ++++++++++++++++--
 src/rule.c          |   4 +-
 6 files changed, 185 insertions(+), 85 deletions(-)

diff --git a/include/intervals.h b/include/intervals.h
index ef0fb53e7577..e71238abe238 100644
--- a/include/intervals.h
+++ b/include/intervals.h
@@ -7,5 +7,7 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	       struct expr *init, unsigned int debug_mask);
 int set_overlap(struct list_head *msgs, struct set *set, struct expr *init);
 int set_to_intervals(const struct set *set, struct expr *init, bool add);
+int setelem_to_interval(const struct set *set, struct expr *elem,
+			struct list_head *interval_list);
 
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
index c46874d9a6ce..c9dfed5e550e 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -683,97 +683,129 @@ static bool segtree_needs_first_segment(const struct set *set,
 
 int set_to_intervals(const struct set *set, struct expr *init, bool add)
 {
-	struct expr *i, *n, *prev = NULL, *elem, *newelem = NULL, *root, *expr;
+	struct expr *i, *elem, *root, *expr;
 	LIST_HEAD(intervals);
-	uint32_t flags;
-	mpz_t p, q;
+	mpz_t p;
 
-	mpz_init2(p, set->key->len);
-	mpz_init2(q, set->key->len);
+	if (list_empty(&init->expressions))
+		return 0;
 
-	list_for_each_entry_safe(i, n, &init->expressions, list) {
-		flags = 0;
+	i = list_first_entry(&init->expressions, struct expr, list);
+	if (!i)
+		return 0;
 
-		elem = interval_expr_key(i);
+	elem = interval_expr_key(i);
 
-		if (elem->key->etype == EXPR_SET_ELEM_CATCHALL)
-			continue;
+	if (elem->key->etype == EXPR_SET_ELEM_CATCHALL)
+		return 0;
 
-		if (!prev && segtree_needs_first_segment(set, init, add) &&
-		    mpz_cmp_ui(elem->key->range.low, 0)) {
-			mpz_set_ui(p, 0);
-			expr = constant_expr_alloc(&internal_location,
-						   set->key->dtype,
-						   set->key->byteorder,
-						   set->key->len, NULL);
-			mpz_set(expr->value, p);
-			root = set_elem_expr_alloc(&internal_location, expr);
-			if (i->etype == EXPR_MAPPING) {
-				root = mapping_expr_alloc(&internal_location,
-							  root,
-							  expr_get(i->right));
-			}
-			root->flags |= EXPR_F_INTERVAL_END;
-			list_add(&root->list, &intervals);
-			init->size++;
+	if (segtree_needs_first_segment(set, init, add) &&
+	    mpz_cmp_ui(elem->key->range.low, 0)) {
+		mpz_init2(p, set->key->len);
+		mpz_set_ui(p, 0);
+		expr = constant_range_expr_alloc(&internal_location,
+						 set->key->dtype,
+						 set->key->byteorder,
+					         set->key->len, p, p);
+		mpz_clear(p);
+
+		root = set_elem_expr_alloc(&internal_location, expr);
+		if (i->etype == EXPR_MAPPING) {
+			root = mapping_expr_alloc(&internal_location,
+						  root,
+						  expr_get(i->right));
 		}
+		root->flags |= EXPR_F_INTERVAL_END;
+		list_add(&root->list, &intervals);
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
+
+static void set_elem_stmt_clone(struct expr *dst, const struct expr *src)
+{
+	struct stmt *stmt, *nstmt;
+
+	list_for_each_entry(stmt, &src->stmt_list, list) {
+		nstmt = xzalloc(sizeof(*stmt));
+		/* this is fine by now for the supported stateful statements. */
+		*nstmt = *stmt;
+		list_add_tail(&nstmt->list, &dst->stmt_list);
+	}
+}
 
-		expr = constant_expr_alloc(&elem->key->location, set->key->dtype,
-					   set->key->byteorder, set->key->len, NULL);
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
 
-		mpz_set(expr->value, elem->key->range.low);
-		if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
-			mpz_switch_byteorder(expr->value, set->key->len / BITS_PER_BYTE);
+int setelem_to_interval(const struct set *set, struct expr *elem,
+			struct list_head *intervals)
+{
+	struct expr *key, *low, *high;
 
-		expr_free(elem->key);
-		elem->key = expr;
-		i->flags |= flags;
-		init->size++;
-		list_move_tail(&i->list, &intervals);
+	switch (elem->etype) {
+	case EXPR_MAPPING:
+		key = elem->left->key;
+		break;
+	case EXPR_SET_ELEM:
+		key = elem->key;
+		break;
+	default:
+		BUG("unhandled expression type %d\n", elem->etype);
+		return -1;
+	}
 
-		prev = i;
+	if (key->etype == EXPR_SET_ELEM_CATCHALL)
+		return 0;
+
+	assert(key->etype == EXPR_RANGE_VALUE);
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
+	if (!mpz_cmp_ui(key->range.high, 0)) {
+		low->flags |= EXPR_F_INTERVAL_END;
+		return 0;
+	} else if (mpz_scan0(key->range.high, 0) == set->key->len) {
+		low->flags |= EXPR_F_INTERVAL_OPEN;
+		return 0;
 	}
 
-	if (newelem)
-		list_add_tail(&newelem->list, &intervals);
+	high = constant_expr_alloc(&key->location, set->key->dtype,
+				   set->key->byteorder, set->key->len,
+				   NULL);
+	mpz_set(high->value, key->range.high);
+	mpz_add_ui(high->value, high->value, 1);
+	if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
+		mpz_switch_byteorder(high->value, set->key->len / BITS_PER_BYTE);
 
-	list_splice_init(&intervals, &init->expressions);
+	high = set_elem_expr_alloc(&key->location, high);
 
-	mpz_clear(p);
-	mpz_clear(q);
+	high->flags |= EXPR_F_INTERVAL_END;
+	list_add_tail(&high->list, intervals);
 
 	return 0;
 }
diff --git a/src/mnl.c b/src/mnl.c
index 52085d6d960a..1124fecbbd90 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -30,6 +30,7 @@
 
 #include <mnl.h>
 #include <cmd.h>
+#include <intervals.h>
 #include <net/if.h>
 #include <sys/socket.h>
 #include <arpa/inet.h>
@@ -1266,7 +1267,14 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			nftnl_set_set_u32(nls, NFTNL_SET_DESC_SIZE,
 					  set->desc.size);
 	} else if (set->init) {
-		nftnl_set_set_u32(nls, NFTNL_SET_DESC_SIZE, set->init->size);
+		unsigned int size;
+
+		if (set_is_non_concat_range(set))
+			size = (set->init->size * 2) + 1;
+		else
+			size = set->init->size;
+
+		nftnl_set_set_u32(nls, NFTNL_SET_DESC_SIZE, size);
 	}
 
 	udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
@@ -1727,17 +1735,46 @@ static void netlink_dump_setelem_done(struct netlink_ctx *ctx)
 	fprintf(fp, "\n");
 }
 
+static struct nftnl_set_elem *
+alloc_nftnl_setelem_interval(const struct set *set, const struct expr *init,
+			     struct expr *elem,
+			     struct nftnl_set_elem **nlse_high)
+{
+	struct nftnl_set_elem *nlse[2] = {};
+	LIST_HEAD(interval_list);
+	struct expr *expr, *next;
+	int i = 0;
+
+	if (setelem_to_interval(set, elem, &interval_list) < 0)
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
 	struct nlattr *nest1, *nest2;
-	struct nftnl_set_elem *nlse;
-	struct nlmsghdr *nlh;
 	struct expr *expr = NULL;
+	struct nlmsghdr *nlh;
 	int i = 0;
 
 	if (msg_type == NFT_MSG_NEWSETELEM)
@@ -1770,9 +1807,24 @@ next:
 	assert(expr);
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
 	list_for_each_entry_from(expr, &init->expressions, list) {
-		nlse = alloc_nftnl_setelem(init, expr);
+
+		if (set_is_non_concat_range(set)) {
+			if (!nlse_high) {
+				nlse = alloc_nftnl_setelem_interval(set, init, expr, &nlse_high);
+			} else {
+				nlse = nlse_high;
+				nlse_high = NULL;
+			}
+		} else {
+			nlse = alloc_nftnl_setelem(init, expr);
+		}
 
 		cmd_add_loc(cmd, nlh, &expr->location);
+
+		/* rewind one step, range high still needs to be added. */
+		if (nlse_high)
+			expr = list_prev_entry(expr, list);
+
 		nest2 = mnl_attr_nest_start(nlh, ++i);
 		nftnl_set_elem_nlmsg_build_payload(nlh, nlse);
 		mnl_attr_nest_end(nlh, nest2);
@@ -1780,6 +1832,10 @@ next:
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
@@ -1817,7 +1873,7 @@ int mnl_nft_setelem_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_batch(nls, cmd, ctx->batch, NFT_MSG_NEWSETELEM,
-				    flags, &ctx->seqnum, expr, ctx);
+				    flags, &ctx->seqnum, set, expr, ctx);
 	nftnl_set_free(nls);
 
 	return err;
@@ -1854,7 +1910,8 @@ int mnl_nft_setelem_flush(struct netlink_ctx *ctx, const struct cmd *cmd)
 }
 
 int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
-			const struct handle *h, const struct expr *init)
+			const struct handle *h, const struct set *set,
+			const struct expr *init)
 {
 	enum nf_tables_msg_types msg_type = NFT_MSG_DELSETELEM;
 	struct nftnl_set *nls;
@@ -1877,7 +1934,7 @@ int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
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

