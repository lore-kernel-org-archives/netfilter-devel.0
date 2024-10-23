Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36C3C1ABEBF
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 13:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729690489; cv=none; b=YPpxjlf/16whby2QkGiLBTd4NFEkKKdl4Hn8cxRnAUGD8Z1BPRr1+gmdDhqXbR68z6d6ApkzBuvNR6LE0E0X9X/C4yvzKvkBPzpuGZ/oT97GoFY1PLfiQ8DQczs8y7hXPDLbmBvNHJFfhfUWD9tKYMKp2wVdUIZQeft2Tp/mT+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729690489; c=relaxed/simple;
	bh=AqSVwUGC1DsagXaX0DZt2BDtzHHwiBZoNanTxg5E3bY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=gmLr5VPQWUD+xgEKFXpIHCqMFRXTRueTOeGkA+hyWOiWsNj5Zu3vDXorG8Kov/bn74iCcU73iJOCi9X7AcPVPOvgr+IhpxePtWDVWSa1sDz7mJmEXsR65nvCMhlD4MCpN4E7+Q0KFffYIym4+sUX2VI7uQ2oCUbJrVowSPAgeoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: collapse set element commands from parser
Date: Wed, 23 Oct 2024 15:34:40 +0200
Message-Id: <20241023133440.527984-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

498a5f0c219d ("rule: collapse set element commands") does not help to
reduce memory consumption in the case of large sets defined by one
element per line:

 add element ip x y { 1.1.1.1 }
 add element ip x y { 1.1.1.2 }
 ...

This patch collapses set element whenver possible to reduce the number
of cmd objects, this reduces memory consumption by ~75%.

This patch also adds a special case for variables for sets similar to:

  be055af5c58d ("cmd: skip variable set elements when collapsing commands")

This patch requires this small kernel fix:

 commit b53c116642502b0c85ecef78bff4f826a7dd4145
 Author: Pablo Neira Ayuso <pablo@netfilter.org>
 Date:   Fri May 20 00:02:06 2022 +0200

    netfilter: nf_tables: set element extended ACK reporting support

which is included in recent -stable kernels:

 # cat ruleset.nft
 add table ip x
 add chain ip x y
 add set ip x y { type ipv4_addr; }
 create element ip x y { 1.1.1.1 }
 create element ip x y { 1.1.1.1 }

 # nft -f ruleset.nft
 ruleset.nft:5:25-31: Error: Could not process rule: File exists
 create element ip x y { 1.1.1.1 }
                         ^^^^^^^

there is no need to relate commands via sequence number, this allows to
remove the uncollapse step too.

Fixes: 498a5f0c219d ("rule: collapse set element commands")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
supersedes: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20241009134427.3487792-1-pablo@netfilter.org/

 include/cmd.h        |   7 +--
 include/expression.h |   1 -
 include/list.h       |  11 +++++
 include/rule.h       |   1 -
 src/cmd.c            | 105 +++++++++++--------------------------------
 src/libnftables.c    |   7 ---
 src/parser_bison.y   |  13 ++++++
 src/rule.c           |   1 -
 8 files changed, 54 insertions(+), 92 deletions(-)

diff --git a/include/cmd.h b/include/cmd.h
index 92a4152bbaea..0a8779b1ea19 100644
--- a/include/cmd.h
+++ b/include/cmd.h
@@ -2,12 +2,13 @@
 #define _NFT_CMD_H_
 
 void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc);
+struct mnl_err;
 void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
 		   struct mnl_err *err);
 
+bool nft_cmd_collapse_elems(enum cmd_ops op, struct list_head *cmds,
+			    struct handle *handle, struct expr *init);
+
 void nft_cmd_expand(struct cmd *cmd);
-void nft_cmd_post_expand(struct cmd *cmd);
-bool nft_cmd_collapse(struct list_head *cmds);
-void nft_cmd_uncollapse(struct list_head *cmds);
 
 #endif
diff --git a/include/expression.h b/include/expression.h
index 8982110cce95..da2f693e72d3 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -255,7 +255,6 @@ struct expr {
 	enum expr_types		etype:8;
 	enum ops		op:8;
 	unsigned int		len;
-	struct cmd		*cmd;
 
 	union {
 		struct {
diff --git a/include/list.h b/include/list.h
index 857921e34201..37fbe3e275cc 100644
--- a/include/list.h
+++ b/include/list.h
@@ -348,6 +348,17 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_first_entry(ptr, type, member) \
 	list_entry((ptr)->next, type, member)
 
+/**
+ * list_last_entry - get the last element from a list
+ * @ptr:        the list head to take the element from.
+ * @type:       the type of the struct this is embedded in.
+ * @member:     the name of the list_head within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_last_entry(ptr, type, member) \
+	list_entry((ptr)->prev, type, member)
+
 /**
  * list_next_entry - get the next element in list
  * @pos: the type * to cursor
diff --git a/include/rule.h b/include/rule.h
index 5b3e12b5d7dc..a1628d82d275 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -718,7 +718,6 @@ struct cmd {
 	enum cmd_obj		obj;
 	struct handle		handle;
 	uint32_t		seqnum;
-	struct list_head	collapse_list;
 	union {
 		void		*data;
 		struct expr	*expr;
diff --git a/src/cmd.c b/src/cmd.c
index 9a572b5660c7..e010dcb8113e 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -378,6 +378,32 @@ static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds
 	}
 }
 
+bool nft_cmd_collapse_elems(enum cmd_ops op, struct list_head *cmds,
+			    struct handle *handle, struct expr *init)
+{
+	struct cmd *last_cmd;
+
+	if (list_empty(cmds))
+		return false;
+
+	if (init->etype == EXPR_VARIABLE)
+		return false;
+
+	last_cmd = list_last_entry(cmds, struct cmd, list);
+	if (last_cmd->op != op ||
+	    last_cmd->obj != CMD_OBJ_ELEMENTS ||
+	    last_cmd->expr->etype == EXPR_VARIABLE ||
+	    last_cmd->handle.family != handle->family ||
+	    strcmp(last_cmd->handle.table.name, handle->table.name) ||
+	    strcmp(last_cmd->handle.set.name, handle->set.name))
+		return false;
+
+	list_splice_tail_init(&init->expressions, &last_cmd->expr->expressions);
+	last_cmd->expr->size += init->size;
+
+	return true;
+}
+
 void nft_cmd_expand(struct cmd *cmd)
 {
 	struct list_head new_cmds;
@@ -459,82 +485,3 @@ void nft_cmd_expand(struct cmd *cmd)
 		break;
 	}
 }
-
-bool nft_cmd_collapse(struct list_head *cmds)
-{
-	struct cmd *cmd, *next, *elems = NULL;
-	struct expr *expr, *enext;
-	bool collapse = false;
-
-	list_for_each_entry_safe(cmd, next, cmds, list) {
-		if (cmd->op != CMD_ADD &&
-		    cmd->op != CMD_CREATE) {
-			elems = NULL;
-			continue;
-		}
-
-		if (cmd->obj != CMD_OBJ_ELEMENTS) {
-			elems = NULL;
-			continue;
-		}
-
-		if (cmd->expr->etype == EXPR_VARIABLE)
-			continue;
-
-		if (!elems) {
-			elems = cmd;
-			continue;
-		}
-
-		if (cmd->op != elems->op) {
-			elems = cmd;
-			continue;
-		}
-
-		if (elems->handle.family != cmd->handle.family ||
-		    strcmp(elems->handle.table.name, cmd->handle.table.name) ||
-		    strcmp(elems->handle.set.name, cmd->handle.set.name)) {
-			elems = cmd;
-			continue;
-		}
-
-		collapse = true;
-		list_for_each_entry_safe(expr, enext, &cmd->expr->expressions, list) {
-			expr->cmd = cmd;
-			list_move_tail(&expr->list, &elems->expr->expressions);
-		}
-		elems->expr->size += cmd->expr->size;
-		list_move_tail(&cmd->list, &elems->collapse_list);
-	}
-
-	return collapse;
-}
-
-void nft_cmd_uncollapse(struct list_head *cmds)
-{
-	struct cmd *cmd, *cmd_next, *collapse_cmd, *collapse_cmd_next;
-	struct expr *expr, *next;
-
-	list_for_each_entry_safe(cmd, cmd_next, cmds, list) {
-		if (list_empty(&cmd->collapse_list))
-			continue;
-
-		assert(cmd->obj == CMD_OBJ_ELEMENTS);
-
-		list_for_each_entry_safe(expr, next, &cmd->expr->expressions, list) {
-			if (!expr->cmd)
-				continue;
-
-			list_move_tail(&expr->list, &expr->cmd->expr->expressions);
-			cmd->expr->size--;
-			expr->cmd = NULL;
-		}
-
-		list_for_each_entry_safe(collapse_cmd, collapse_cmd_next, &cmd->collapse_list, list) {
-			if (cmd->elem.set)
-				collapse_cmd->elem.set = set_get(cmd->elem.set);
-
-			list_add(&collapse_cmd->list, &cmd->list);
-		}
-	}
-}
diff --git a/src/libnftables.c b/src/libnftables.c
index 2ae215013cb0..2834c9922486 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -513,7 +513,6 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 {
 	struct nft_cache_filter *filter;
 	struct cmd *cmd, *next;
-	bool collapsed = false;
 	unsigned int flags;
 	int err = 0;
 
@@ -529,9 +528,6 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 
 	nft_cache_filter_fini(filter);
 
-	if (nft_cmd_collapse(cmds))
-		collapsed = true;
-
 	list_for_each_entry(cmd, cmds, list) {
 		if (cmd->op != CMD_ADD &&
 		    cmd->op != CMD_CREATE)
@@ -553,9 +549,6 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 		}
 	}
 
-	if (collapsed)
-		nft_cmd_uncollapse(cmds);
-
 	if (err < 0 || nft->state->nerrs)
 		return -1;
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e2936d10efe4..602fc60e6de3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -35,6 +35,7 @@
 #include <libnftnl/udata.h>
 
 #include <rule.h>
+#include <cmd.h>
 #include <statement.h>
 #include <expression.h>
 #include <headers.h>
@@ -1219,6 +1220,12 @@ add_cmd			:	TABLE		table_spec
 			}
 			|	ELEMENT		set_spec	set_block_expr
 			{
+				if (nft_cmd_collapse_elems(CMD_ADD, state->cmds, &$2, $3)) {
+					handle_free(&$2);
+					expr_free($3);
+					$$ = NULL;
+					break;
+				}
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_ELEMENTS, &$2, &@$, $3);
 			}
 			|	FLOWTABLE	flowtable_spec	flowtable_block_alloc
@@ -1336,6 +1343,12 @@ create_cmd		:	TABLE		table_spec
 			}
 			|	ELEMENT		set_spec	set_block_expr
 			{
+				if (nft_cmd_collapse_elems(CMD_CREATE, state->cmds, &$2, $3)) {
+					handle_free(&$2);
+					expr_free($3);
+					$$ = NULL;
+					break;
+				}
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_ELEMENTS, &$2, &@$, $3);
 			}
 			|	FLOWTABLE	flowtable_spec	flowtable_block_alloc
diff --git a/src/rule.c b/src/rule.c
index 9bc160ec0d88..9536e68c7524 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1332,7 +1332,6 @@ struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 	cmd->attr     = xzalloc_array(NFT_NLATTR_LOC_MAX,
 				      sizeof(struct nlerr_loc));
 	cmd->attr_array_len = NFT_NLATTR_LOC_MAX;
-	init_list_head(&cmd->collapse_list);
 
 	return cmd;
 }
-- 
2.30.2

