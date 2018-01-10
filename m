From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] Don't merge adjacent/overlapping ranges by default
Date: Wed, 10 Jan 2018 11:42:21 +0100
Message-ID: <20180110104221.3565-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58294 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751694AbeAJKmc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 05:42:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces a new commandline parameter -m/--merge which
restores the old behaviour.

Previously, when adding multiple ranges to a set they were merged if
overlapping or adjacent. This might cause inconvenience though since it
is afterwards not easily possible anymore to remove one of the merged
ranges again while keeping the others in place.

Since it is not possible to have overlapping ranges, this patch adds a
check for newly added ranges to make sure they don't overlap if merging
is turned off.

Two tests had to be adjusted: One in tests/py to avoid adding
overlapping ranges and the other in tests/shell to call nft with --merge
option.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expression.h                               |  2 +-
 include/netlink.h                                  |  2 ++
 include/nftables.h                                 |  1 +
 include/nftables/nftables.h                        |  3 ++
 src/libnftables.c                                  | 11 +++++++
 src/main.c                                         | 11 ++++++-
 src/rule.c                                         |  8 +++--
 src/segtree.c                                      | 38 ++++++++++++++++++----
 tests/py/any/meta.t                                |  2 +-
 tests/py/any/meta.t.payload                        |  4 +--
 .../sets/0002named_interval_automerging_0          |  2 +-
 11 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 915ce0bad04df..0a0e178fe4680 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -419,7 +419,7 @@ extern struct expr *set_expr_alloc(const struct location *loc,
 				   const struct set *set);
 extern int set_to_intervals(struct list_head *msgs, struct set *set,
 			    struct expr *init, bool add,
-			    unsigned int debug_mask);
+			    unsigned int debug_mask, bool merge);
 extern void interval_map_decompose(struct expr *set);
 
 extern struct expr *mapping_expr_alloc(const struct location *loc,
diff --git a/include/netlink.h b/include/netlink.h
index 51cd5c9d1b94d..4ec215da1dcde 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -42,6 +42,7 @@ extern const struct location netlink_location;
  * @octx:	output context
  * @debug_mask:	display debugging information
  * @cache:	cache context
+ * @range_merge: merge adjacent/overlapping ranges in new set elements
  */
 struct netlink_ctx {
 	struct mnl_socket	*nf_sock;
@@ -55,6 +56,7 @@ struct netlink_ctx {
 	unsigned int		debug_mask;
 	struct output_ctx	*octx;
 	struct nft_cache	*cache;
+	bool			range_merge;
 };
 
 extern struct nftnl_table *alloc_nftnl_table(const struct handle *h);
diff --git a/include/nftables.h b/include/nftables.h
index 3bfa33e5cb336..f22df0d1ddc15 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -31,6 +31,7 @@ struct nft_ctx {
 	unsigned int		debug_mask;
 	struct output_ctx	output;
 	bool			check;
+	bool			range_merge;
 	struct nft_cache	cache;
 	uint32_t		flags;
 };
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 8e59f2b2a59ab..ae0d25832b70c 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -43,6 +43,9 @@ void nft_ctx_free(struct nft_ctx *ctx);
 
 bool nft_ctx_get_dry_run(struct nft_ctx *ctx);
 void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
+bool nft_ctx_get_range_merge(struct nft_ctx *ctx);
+void nft_ctx_set_range_merge(struct nft_ctx *ctx, bool merge);
+
 enum nft_numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx);
 void nft_ctx_output_set_numeric(struct nft_ctx *ctx, enum nft_numeric_level level);
 bool nft_ctx_output_get_stateless(struct nft_ctx *ctx);
diff --git a/src/libnftables.c b/src/libnftables.c
index c86d89477e778..447baa7a7e4f9 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -43,6 +43,7 @@ static int nft_netlink(struct nft_ctx *nft,
 		ctx.nf_sock = nf_sock;
 		ctx.cache = &nft->cache;
 		ctx.debug_mask = nft->debug_mask;
+		ctx.range_merge = nft->range_merge;
 		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0)
@@ -209,6 +210,16 @@ void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry)
 	ctx->check = dry;
 }
 
+bool nft_ctx_get_range_merge(struct nft_ctx *ctx)
+{
+	return ctx->range_merge;
+}
+
+void nft_ctx_set_range_merge(struct nft_ctx *ctx, bool merge)
+{
+	ctx->range_merge = merge;
+}
+
 enum nft_numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx)
 {
 	return ctx->output.numeric;
diff --git a/src/main.c b/src/main.c
index 353b87bc66631..69b3a1b898f33 100644
--- a/src/main.c
+++ b/src/main.c
@@ -37,10 +37,11 @@ enum opt_vals {
 	OPT_DEBUG		= 'd',
 	OPT_HANDLE_OUTPUT	= 'a',
 	OPT_ECHO		= 'e',
+	OPT_MERGE		= 'm',
 	OPT_INVALID		= '?',
 };
 
-#define OPTSTRING	"hvcf:iI:vnsNae"
+#define OPTSTRING	"hvcf:iI:vnsNaem"
 
 static const struct option options[] = {
 	{
@@ -95,6 +96,10 @@ static const struct option options[] = {
 		.val		= OPT_ECHO,
 	},
 	{
+		.name		= "merge",
+		.val		= OPT_MERGE,
+	},
+	{
 		.name		= NULL
 	}
 };
@@ -119,6 +124,7 @@ static void show_help(const char *name)
 "  -N				Translate IP addresses to names.\n"
 "  -a, --handle			Output rule handle.\n"
 "  -e, --echo			Echo what has been added, inserted or replaced.\n"
+"  -m, --merge			Merge adjacent/overlapping ranges in sets upon insertion.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files. Default is: %s\n"
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
 "\n",
@@ -255,6 +261,9 @@ int main(int argc, char * const *argv)
 		case OPT_ECHO:
 			nft_ctx_output_set_echo(nft, true);
 			break;
+		case OPT_MERGE:
+			nft_ctx_set_range_merge(nft, true);
+			break;
 		case OPT_INVALID:
 			exit(EXIT_FAILURE);
 		}
diff --git a/src/rule.c b/src/rule.c
index bb9add07efaf5..edd0ff6f322c5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -997,7 +997,8 @@ static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	set = set_lookup(table, h->set);
 
 	if (set->flags & NFT_SET_INTERVAL &&
-	    set_to_intervals(ctx->msgs, set, init, true, ctx->debug_mask) < 0)
+	    set_to_intervals(ctx->msgs, set, init, true,
+			     ctx->debug_mask, ctx->range_merge) < 0)
 		return -1;
 
 	return __do_add_setelems(ctx, h, set, init, flags);
@@ -1009,7 +1010,7 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 	if (set->init != NULL) {
 		if (set->flags & NFT_SET_INTERVAL &&
 		    set_to_intervals(ctx->msgs, set, set->init, true,
-				     ctx->debug_mask) < 0)
+				     ctx->debug_mask, ctx->range_merge) < 0)
 			return -1;
 	}
 	if (netlink_add_set(ctx, h, set, flags) < 0)
@@ -1108,7 +1109,8 @@ static int do_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	set = set_lookup(table, h->set);
 
 	if (set->flags & NFT_SET_INTERVAL &&
-	    set_to_intervals(ctx->msgs, set, expr, false, ctx->debug_mask) < 0)
+	    set_to_intervals(ctx->msgs, set, expr, false,
+			     ctx->debug_mask, ctx->range_merge) < 0)
 		return -1;
 
 	if (netlink_delete_setelems(ctx, h, expr) < 0)
diff --git a/src/segtree.c b/src/segtree.c
index 8d36cc9b0d65e..d2c4efaae2f0a 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -375,8 +375,26 @@ static int set_overlap(struct list_head *msgs, const struct set *set,
 	return 0;
 }
 
+static int intervals_overlap(struct list_head *msgs,
+			     struct elementary_interval **intervals,
+			     unsigned int keylen)
+{
+	unsigned int i, j;
+
+	for (i = 0; i < keylen - 1; i++) {
+		for (j = i + 1; j < keylen; j++) {
+			if (interval_overlap(intervals[i], intervals[j]))
+				return expr_error(msgs, intervals[j]->expr,
+					"interval overlaps with previous one");
+		}
+	}
+
+	return 0;
+}
+
 static int set_to_segtree(struct list_head *msgs, struct set *set,
-			  struct expr *init, struct seg_tree *tree, bool add)
+			  struct expr *init, struct seg_tree *tree,
+			  bool add, bool merge)
 {
 	struct elementary_interval *intervals[init->size];
 	struct expr *i, *next;
@@ -394,6 +412,12 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 
 	n = expr_to_intervals(init, tree->keylen, intervals);
 
+	if (add && !merge) {
+		err = intervals_overlap(msgs, intervals, n);
+		if (err < 0)
+			return err;
+	}
+
 	list_for_each_entry_safe(i, next, &init->expressions, list) {
 		list_del(&i->list);
 		expr_free(i);
@@ -450,7 +474,7 @@ static bool segtree_needs_first_segment(const struct set *set,
 
 static void segtree_linearize(struct list_head *list, const struct set *set,
 			      const struct expr *init, struct seg_tree *tree,
-			      bool add)
+			      bool add, bool merge)
 {
 	bool needs_first_segment = segtree_needs_first_segment(set, init, add);
 	struct elementary_interval *ei, *nei, *prev = NULL;
@@ -489,7 +513,8 @@ static void segtree_linearize(struct list_head *list, const struct set *set,
 				mpz_sub_ui(q, ei->left, 1);
 				nei = ei_alloc(p, q, NULL, EI_F_INTERVAL_END);
 				list_add_tail(&nei->list, list);
-			} else if (add && ei->expr->ops->type != EXPR_MAPPING) {
+			} else if (add && merge &&
+			           ei->expr->ops->type != EXPR_MAPPING) {
 				/* Merge contiguous segments only in case of
 				 * new additions.
 				 */
@@ -550,16 +575,17 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 }
 
 int set_to_intervals(struct list_head *errs, struct set *set,
-		     struct expr *init, bool add, unsigned int debug_mask)
+		     struct expr *init, bool add, unsigned int debug_mask,
+		     bool merge)
 {
 	struct elementary_interval *ei, *next;
 	struct seg_tree tree;
 	LIST_HEAD(list);
 
 	seg_tree_init(&tree, set, init, debug_mask);
-	if (set_to_segtree(errs, set, init, &tree, add) < 0)
+	if (set_to_segtree(errs, set, init, &tree, add, merge) < 0)
 		return -1;
-	segtree_linearize(&list, set, init, &tree, add);
+	segtree_linearize(&list, set, init, &tree, add, merge);
 
 	init->size = 0;
 	list_for_each_entry_safe(ei, next, &list, list) {
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index a38c5011f7082..3158e8877357a 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -15,7 +15,7 @@ meta length 33-45;ok
 meta length != 33-45;ok
 meta length { 33, 55, 67, 88};ok
 meta length { 33-55, 67-88};ok
-meta length { 33-55, 55-88, 100-120};ok;meta length { 33-88, 100-120}
+meta length { 33-55, 56-88, 100-120};ok;meta length { 33-55, 56-88, 100-120}
 meta length != { 33, 55, 67, 88};ok
 meta length { 33-55};ok
 meta length != { 33-55};ok
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index b2065f3d920b4..d0199b8ae510b 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -52,10 +52,10 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __set%d ]
 
-# meta length { 33-55, 55-88, 100-120}
+# meta length { 33-55, 56-88, 100-120}
 __set%d test-ip4 7
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 59000000  : 1 [end]	element 64000000  : 0 [end]	element 79000000  : 1 [end]
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 0 [end]	element 59000000  : 1 [end]	element 64000000  : 0 [end]	element 79000000  : 1 [end]
 ip test-ip4 input
   [ meta load len => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
diff --git a/tests/shell/testcases/sets/0002named_interval_automerging_0 b/tests/shell/testcases/sets/0002named_interval_automerging_0
index b07e0b0954bdb..f91bbbb063ee0 100755
--- a/tests/shell/testcases/sets/0002named_interval_automerging_0
+++ b/tests/shell/testcases/sets/0002named_interval_automerging_0
@@ -6,7 +6,7 @@ set -e
 
 $NFT add table t
 $NFT add set t s { type ipv4_addr \; flags interval \; }
-$NFT add element t s { 192.168.0.0/24, 192.168.1.0/24 }
+$NFT --merge add element t s { 192.168.0.0/24, 192.168.1.0/24 }
 $NFT list ruleset | grep "192.168.0.0/23" >/dev/null && exit 0
 echo "E: automerging of adjavect intervals failed in named set" >&2
 exit 1
-- 
2.13.1

