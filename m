Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5845C120
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 05:09:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rAVB5-0008LJ-0n; Tue, 05 Dec 2023 14:09:31 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] intervals: don't assert when symbolic expression is to be split into a range
Date: Tue,  5 Dec 2023 14:09:19 +0100
Message-ID: <20231205130923.3633-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tests/shell/testcases/bogons/nft-f/set_definition_with_no_key_assert
BUG: unhandled key type 2
nft: src/intervals.c:59: setelem_expr_to_range: Assertion `0' failed.

Fixes: 3975430b12d9 ("src: expand table command before evaluation")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/intervals.h                           |  1 -
 src/intervals.c                               | 60 +++++++++++++++----
 .../nft-f/set_definition_with_no_key_assert   | 12 ++++
 3 files changed, 60 insertions(+), 13 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/set_definition_with_no_key_assert

diff --git a/include/intervals.h b/include/intervals.h
index 964804b19dda..ef0fb53e7577 100644
--- a/include/intervals.h
+++ b/include/intervals.h
@@ -1,7 +1,6 @@
 #ifndef NFTABLES_INTERVALS_H
 #define NFTABLES_INTERVALS_H
 
-void set_to_range(struct expr *init);
 int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 		  struct expr *init, unsigned int debug_mask);
 int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
diff --git a/src/intervals.c b/src/intervals.c
index 85de0199c373..7181af58013e 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -13,7 +13,9 @@
 #include <intervals.h>
 #include <rule.h>
 
-static void setelem_expr_to_range(struct expr *expr)
+static int set_to_range(struct expr *init);
+
+static int setelem_expr_to_range(struct expr *expr)
 {
 	unsigned char data[sizeof(struct in6_addr) * BITS_PER_BYTE];
 	struct expr *key, *value;
@@ -55,9 +57,13 @@ static void setelem_expr_to_range(struct expr *expr)
 		expr_free(expr->key);
 		expr->key = key;
 		break;
+	case EXPR_SYMBOL:
+		return -1;
 	default:
 		BUG("unhandled key type %d\n", expr->key->etype);
 	}
+
+	return 0;
 }
 
 struct set_automerge_ctx {
@@ -120,24 +126,33 @@ static bool merge_ranges(struct set_automerge_ctx *ctx,
 	return false;
 }
 
-static void set_sort_splice(struct expr *init, struct set *set)
+static int set_sort_splice(struct expr *init, struct set *set)
 {
 	struct set *existing_set = set->existing_set;
+	int err;
+
+	err = set_to_range(init);
+	if (err)
+		return err;
 
-	set_to_range(init);
 	list_expr_sort(&init->expressions);
 
 	if (!existing_set)
-		return;
+		return 0;
 
 	if (existing_set->init) {
-		set_to_range(existing_set->init);
+		err = set_to_range(existing_set->init);
+		if (err)
+			return err;
+
 		list_splice_sorted(&existing_set->init->expressions,
 				   &init->expressions);
 		init_list_head(&existing_set->init->expressions);
 	} else {
 		existing_set->init = set_expr_alloc(&internal_location, set);
 	}
+
+	return 0;
 }
 
 static void setelem_automerge(struct set_automerge_ctx *ctx)
@@ -215,14 +230,21 @@ static struct expr *interval_expr_key(struct expr *i)
 	return elem;
 }
 
-void set_to_range(struct expr *init)
+static int set_to_range(struct expr *init)
 {
 	struct expr *i, *elem;
 
 	list_for_each_entry(i, &init->expressions, list) {
+		int err;
+
 		elem = interval_expr_key(i);
-		setelem_expr_to_range(elem);
+
+		err = setelem_expr_to_range(elem);
+		if (err < 0)
+			return err;
 	}
+
+	return 0;
 }
 
 int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
@@ -237,14 +259,21 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	struct expr *i, *next, *clone;
 	struct cmd *purge_cmd;
 	struct handle h = {};
+	int err;
 
 	if (set->flags & NFT_SET_MAP) {
-		set_to_range(init);
+		err = set_to_range(init);
+
+		if (err < 0)
+			return err;
+
 		list_expr_sort(&init->expressions);
 		return 0;
 	}
 
-	set_sort_splice(init, set);
+	err = set_sort_splice(init, set);
+	if (err)
+		return err;
 
 	ctx.purge = set_expr_alloc(&internal_location, set);
 
@@ -478,12 +507,17 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	LIST_HEAD(del_list);
 	int err;
 
-	set_to_range(init);
+	err = set_to_range(init);
+	if (err)
+		return err;
+
 	if (set->automerge)
 		automerge_delete(msgs, set, init, debug_mask);
 
 	if (existing_set->init) {
-		set_to_range(existing_set->init);
+		err = set_to_range(existing_set->init);
+		if (err)
+			return err;
 	} else {
 		existing_set->init = set_expr_alloc(&internal_location, set);
 	}
@@ -611,7 +645,9 @@ int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 	struct expr *i, *n, *clone;
 	int err;
 
-	set_sort_splice(init, set);
+	err = set_sort_splice(init, set);
+	if (err)
+		return err;
 
 	err = setelem_overlap(msgs, set, init);
 
diff --git a/tests/shell/testcases/bogons/nft-f/set_definition_with_no_key_assert b/tests/shell/testcases/bogons/nft-f/set_definition_with_no_key_assert
new file mode 100644
index 000000000000..59ef1ab3b5cb
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/set_definition_with_no_key_assert
@@ -0,0 +1,12 @@
+table inet testifsets {
+	map map_wild {	elements = { "abcdex*",
+			     "othername",
+			     "ppp0" }
+	}
+	map map_wild {
+		type ifname : verdict
+		flags interval
+		elements = { "abcdez*" : jump do_nothing,
+			     "eth0" : jump do_nothing }
+	}
+}
-- 
2.41.0

