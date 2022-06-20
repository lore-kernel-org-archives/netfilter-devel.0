Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58FDAC43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 09:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240388AbiFTJDx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 05:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240283AbiFTJDw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 05:03:52 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB2802C2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 02:03:51 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft,v2 1/2] rule: collapse set element commands
Date:   Mon, 20 Jun 2022 11:03:46 +0200
Message-Id: <20220620090346.1021786-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Robots might generate a long list of singleton element commands such as:

  add element t s { 1.0.1.0/24 }
  ...
  add element t s { 1.0.2.0/23 }

collapse them into one single command before the evaluation step, ie.

  add element t s { 1.0.1.0/24, ..., 1.0.2.0/23 }

this speeds up overlap detection and set element automerge operations in
this worst case scenario.

Since 3da9643fb9ff9 ("intervals: add support to automerge with kernel
elements"), the new interval tracking relies on mergesort. The pattern
above triggers the set sorting for each element.

This patch adds a list to cmd objects that store collapsed commands.
Moreover, expressions also contain a reference to the original command,
to uncollapse the commands after the evaluation step.

These commands are uncollapsed after the evaluation step to ensure error
reporting works as expected (command and netlink message are mapped
1:1).

For the record:

- nftables versions <= 1.0.2 did not perform any kind of overlap
  check for the described scenario above (because set cache only contained
  elements in the kernel in this case). This is a problem for kernels < 5.7
  which rely on userspace to detect overlaps.

- the overlap detection could be skipped for kernels >= 5.7.

- The extended netlink error reporting available for set elements
  since 5.19-rc might allow to remove the uncollapse step, in this case,
  error reporting does not rely on the netlink sequence to refer to the
  command triggering the problem.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Phil: This is v2, restoring error reporting after the command collapse
       operation as you mentioned in your feedback.

       Note nftables <= 1.0.2 does not perform any sort of overlap
       checking from userspace for the scenario described in this commit,
       that's why first nft -f call is "so fast" (set cache was empty in
       that case).

 include/expression.h |  1 +
 include/rule.h       |  3 ++
 src/libnftables.c    | 17 ++++++++--
 src/rule.c           | 75 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 2c3818e89b79..53194c9248e4 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -243,6 +243,7 @@ struct expr {
 	enum expr_types		etype:8;
 	enum ops		op:8;
 	unsigned int		len;
+	struct cmd		*cmd;
 
 	union {
 		struct {
diff --git a/include/rule.h b/include/rule.h
index e232b97afed7..908122559cdf 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -700,6 +700,7 @@ struct cmd {
 	enum cmd_obj		obj;
 	struct handle		handle;
 	uint32_t		seqnum;
+	struct list_head	collapse_list;
 	union {
 		void		*data;
 		struct expr	*expr;
@@ -728,6 +729,8 @@ extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 			     const struct handle *h, const struct location *loc,
 			     void *data);
 extern void nft_cmd_expand(struct cmd *cmd);
+extern bool nft_cmd_collapse(struct list_head *cmds);
+extern void nft_cmd_uncollapse(struct list_head *cmds);
 extern struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type,
 				    const struct handle *h,
 				    const struct location *loc, struct obj *obj);
diff --git a/src/libnftables.c b/src/libnftables.c
index 6a22ea093952..aac682b706ff 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -501,7 +501,9 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 {
 	struct nft_cache_filter *filter;
 	struct cmd *cmd, *next;
+	bool collapsed = false;
 	unsigned int flags;
+	int err = 0;
 
 	filter = nft_cache_filter_init();
 	flags = nft_cache_evaluate(nft, cmds, filter);
@@ -512,17 +514,26 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 
 	nft_cache_filter_fini(filter);
 
+	if (nft_cmd_collapse(cmds))
+		collapsed = true;
+
 	list_for_each_entry_safe(cmd, next, cmds, list) {
 		struct eval_ctx ectx = {
 			.nft	= nft,
 			.msgs	= msgs,
 		};
+
 		if (cmd_evaluate(&ectx, cmd) < 0 &&
-		    ++nft->state->nerrs == nft->parser_max_errors)
-			return -1;
+		    ++nft->state->nerrs == nft->parser_max_errors) {
+			err = -1;
+			break;
+		}
 	}
 
-	if (nft->state->nerrs)
+	if (collapsed)
+		nft_cmd_uncollapse(cmds);
+
+	if (err < 0 || nft->state->nerrs)
 		return -1;
 
 	list_for_each_entry(cmd, cmds, list) {
diff --git a/src/rule.c b/src/rule.c
index 7f61bdc1cec9..0526a1482438 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1279,6 +1279,8 @@ struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 	cmd->handle   = *h;
 	cmd->location = *loc;
 	cmd->data     = data;
+	init_list_head(&cmd->collapse_list);
+
 	return cmd;
 }
 
@@ -1379,6 +1381,79 @@ void nft_cmd_expand(struct cmd *cmd)
 	}
 }
 
+bool nft_cmd_collapse(struct list_head *cmds)
+{
+	struct cmd *cmd, *next, *elems = NULL;
+	struct expr *expr, *enext;
+	bool collapse = false;
+
+	list_for_each_entry_safe(cmd, next, cmds, list) {
+		if (cmd->op != CMD_ADD &&
+		    cmd->op != CMD_CREATE) {
+			elems = NULL;
+			continue;
+		}
+
+		if (cmd->obj != CMD_OBJ_ELEMENTS) {
+			elems = NULL;
+			continue;
+		}
+
+		if (!elems) {
+			elems = cmd;
+			continue;
+		}
+
+		if (cmd->op != elems->op) {
+			elems = cmd;
+			continue;
+		}
+
+		if (strcmp(elems->handle.table.name, cmd->handle.table.name) ||
+		    strcmp(elems->handle.set.name, cmd->handle.set.name)) {
+			elems = cmd;
+			continue;
+		}
+
+		collapse = true;
+		list_for_each_entry_safe(expr, enext, &cmd->expr->expressions, list) {
+			expr->cmd = cmd;
+			list_move_tail(&expr->list, &elems->expr->expressions);
+		}
+		elems->expr->size += cmd->expr->size;
+		list_move_tail(&cmd->list, &elems->collapse_list);
+	}
+
+	return collapse;
+}
+
+void nft_cmd_uncollapse(struct list_head *cmds)
+{
+	struct cmd *cmd, *cmd_next, *collapse_cmd, *collapse_cmd_next;
+	struct expr *expr, *next;
+
+	list_for_each_entry_safe(cmd, cmd_next, cmds, list) {
+		if (list_empty(&cmd->collapse_list))
+			continue;
+
+		assert(cmd->obj == CMD_OBJ_ELEMENTS);
+
+		list_for_each_entry_safe(expr, next, &cmd->expr->expressions, list) {
+			if (!expr->cmd)
+				continue;
+
+			list_move_tail(&expr->list, &expr->cmd->expr->expressions);
+			cmd->expr->size--;
+			expr->cmd = NULL;
+		}
+
+		list_for_each_entry_safe(collapse_cmd, collapse_cmd_next, &cmd->collapse_list, list) {
+			collapse_cmd->elem.set = set_get(cmd->elem.set);
+			list_add(&collapse_cmd->list, &cmd->list);
+		}
+	}
+}
+
 struct markup *markup_alloc(uint32_t format)
 {
 	struct markup *markup;
-- 
2.30.2

