Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C563B6BF7
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Apr 2026 11:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649577; cv=none; b=Jn7UCxtl9cN+QR7rAEt5PxtlFhWi9sO4uYzn5fD6MWLTSY6ldo2X5R0yLl8i524KITbJkPQdVRyZSChuL8ueojsFtxTvu1U6legYFdxX7qBFvw4CMtTW76bMAMPv8vI+7r6Ko2BFaLSl6XgsL2SvBl5LO4Jmy2ai/8RSWbhldH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649577; c=relaxed/simple;
	bh=nkgXogrGRg/OmkvQStAE4PRF9XlDZW1586B3EvJrOrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kM/IL+HtdimKv+PKDnfsNfE4puWtM9f71wKsPMOePobi7ctmVuGfkCTFhjyJ9uZOzC/cl8VugekhwlfnNBgpXXyF2ymemu0wDXuZowbZCMm3YlRWQfKa2ancf9BBRp28mrEWNILJhzVyRYiEz+CjIjCPFAXOUWuk/6/P/g2bn64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=X3gmXUDZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="X3gmXUDZ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 42B776033A;
	Wed,  8 Apr 2026 13:59:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775649573;
	bh=OlAADbsc21NVZGeMocaLErZyMDmKKEVoLvaiRcfK0PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3gmXUDZ6bmfPiQ5Q2IH24yt3UVvQGux49au9d6RJhOQpPOtNzHwsacefpQClbZMX
	 LX2EV2QmSiYVHxRNLn1u0fGrgn4ewiMN3WQJkeTQjRwPdl9kGpQlhumwV4jjp3YDom
	 jnZfW9BiI7g3Z6vW1FxLZ7PBBMsjyO0Ge/+dmgVQkrihpziFutLwX65BSlRUbSrPtQ
	 sTCCtm/A84qzPyl3oY9FmKX0YshBCXKvVF2I1Oios5lyFySkRAU43b+ydWMvrMhu5v
	 MAsV4bMwEd5SP/UhhmE3y9KCox1MqqyWxGrL9kLo5VAG+Ta2HBQErJrUHzTM/wgD7W
	 FFqQVQmDOpDwg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft 5/5] libnftables: support for several list and reset commands
Date: Wed,  8 Apr 2026 13:59:22 +0200
Message-ID: <20260408115922.48676-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260408115922.48676-1-pablo@netfilter.org>
References: <20260408115922.48676-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cache logic woes with either more than one single list or reset
command, e.g. list table x; list table y;

One possibility is to handle this from the cache logic itself through
the existing netlink dump filter infrastructure, but it looks fragile
because this needs to combine the different dump filtering requirements.

The list and reset commands have different semantics, these commands are
not built into the batch that is delivered to the 2-phase commit
protocol in nf_tables, instead these commands follow the netlink dump
path to fetch (and reset) data from the kernel.

This patch updates the parser to create one cmd_batch object that
stores the usual add/delete cmd object in a batch. The exception are
CMD_LIST and CMD_RESET commands, which have a single cmd_batch object
with a single command. Then, iterate over the cmd_batch to handle the
commands sequentially.

The structure is a list of lists, collecting commands

     .-----------.
     | cmd_batch |-> add cmd -> add cmd -> add cmd
     `-----------'
           |
     .-----------.
     | cmd_batch |-> list cmd
     `-----------'

This is handled sequentially, first a batch for the 2-commit phase
protocol is build and delivered, then the list command fetches the
content in the kernel, so it shows the changes already applied by the
previous batch.

In most case, there will be a single cmd_batch object, unless list and
reset commands are used.

After this patch, list and reset commands result in an implicit end of
batch/transaction when mixed with other existing commands. To the user,
these commands are handled now sequentially.

Given list and reset commands trigger this implicit end of batch, this
adds a restriction to disallow complicated mixes that could result in
more than one single transaction. Currently this allows for a batch
for the 2-phase commit protocol and commands to list/reset as long as
they are not intertwined, eg.

     .-----------.
     | cmd_batch |-> add cmd -> add cmd -> add cmd
     `-----------'
           |
     .-----------.
     | cmd_batch |-> list cmd
     `-----------'
           |
     .-----------.
     | cmd_batch |-> add cmd -> add cmd -> add cmd
     `-----------'

This is not allowed, this reports "unsupported command mix" as an error.

There is also a bug in bugzilla that refers to users hitting issues when
using the list command in a file, this patch should address this too.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cmd.h      |  10 +++++
 src/cmd.c          | 100 ++++++++++++++++++++++++++++++++++++++++++++-
 src/libnftables.c  |  39 +++++++++++++++---
 src/parser_bison.y |  12 +++++-
 src/parser_json.c  |   9 ++--
 5 files changed, 157 insertions(+), 13 deletions(-)

diff --git a/include/cmd.h b/include/cmd.h
index cf7e43bf46ec..48f4a07675ed 100644
--- a/include/cmd.h
+++ b/include/cmd.h
@@ -1,6 +1,8 @@
 #ifndef _NFT_CMD_H_
 #define _NFT_CMD_H_
 
+#include <list.h>
+
 void cmd_add_loc(struct cmd *cmd, const struct nlmsghdr *nlh, const struct location *loc);
 struct mnl_err;
 void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
@@ -11,4 +13,12 @@ bool nft_cmd_collapse_elems(enum cmd_ops op, struct list_head *cmds,
 
 void nft_cmd_expand(struct cmd *cmd);
 
+struct cmd_batch {
+	struct list_head	list;
+	struct list_head	sublist;
+};
+
+void __cmd_batch_add(struct cmd *cmd, struct list_head *cmds);
+int cmd_batch_add(struct cmd *cmd, struct list_head *cmds);
+
 #endif
diff --git a/src/cmd.c b/src/cmd.c
index 9d5544f03c32..365fcd8ec0d9 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -384,6 +384,7 @@ static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds
 bool nft_cmd_collapse_elems(enum cmd_ops op, struct list_head *cmds,
 			    struct handle *handle, struct expr *init)
 {
+	struct cmd_batch *cmd_batch;
 	struct cmd *last_cmd;
 
 	if (list_empty(cmds))
@@ -392,7 +393,9 @@ bool nft_cmd_collapse_elems(enum cmd_ops op, struct list_head *cmds,
 	if (init->etype == EXPR_VARIABLE)
 		return false;
 
-	last_cmd = list_last_entry(cmds, struct cmd, list);
+	cmd_batch = list_last_entry(cmds, struct cmd_batch, list);
+
+	last_cmd = list_last_entry(&cmd_batch->sublist, struct cmd, list);
 	if (last_cmd->op != op ||
 	    last_cmd->obj != CMD_OBJ_ELEMENTS ||
 	    last_cmd->expr->etype == EXPR_VARIABLE ||
@@ -489,3 +492,98 @@ void nft_cmd_expand(struct cmd *cmd)
 		break;
 	}
 }
+
+void __cmd_batch_add(struct cmd *cmd, struct list_head *cmds)
+{
+	struct cmd_batch *cmd_batch;
+
+	cmd_batch = xmalloc(sizeof(struct cmd_batch));
+	init_list_head(&cmd_batch->sublist);
+	list_add_tail(&cmd->list, &cmd_batch->sublist);
+	list_add_tail(&cmd_batch->list, cmds);
+}
+
+/* Reject a batch mixing too many of these commands. */
+static int cmd_batch_mix(struct cmd *cmd, enum cmd_ops last_cmd_op)
+{
+	if ((last_cmd_op == CMD_LIST || last_cmd_op == CMD_RESET) &&
+	    (cmd->op != CMD_LIST && cmd->op != CMD_RESET))
+		return true;
+
+	if ((last_cmd_op != CMD_LIST && last_cmd_op != CMD_RESET) &&
+	    (cmd->op == CMD_LIST || cmd->op == CMD_RESET))
+		return true;
+
+	return false;
+}
+
+/* Allow simple mix of list and reset commands, the following combinations
+ * are rejected:
+ *
+ *	add + list + add
+ *
+ * which would trigger two independent add transactions. Same applies
+ * to this combination.
+ *
+ *      list + add + list
+ *
+ * This is allowed:
+ *
+ *	add + list
+ *	list + add
+ *
+ * This can be one or more commands of the same class, as long as they are
+ * not intertwined.
+ */
+static int cmd_batch_validate(struct list_head *cmds)
+{
+	enum cmd_ops last_cmd_op = CMD_INVALID;
+	struct cmd_batch *cmd_batch;
+	struct cmd *cmd;
+	uint32_t mix = 0;
+
+	list_for_each_entry(cmd_batch, cmds, list) {
+		cmd = list_first_entry(&cmd_batch->sublist, struct cmd, list);
+		if (last_cmd_op == CMD_INVALID) {
+			last_cmd_op = cmd->op;
+			continue;
+		}
+		if (cmd_batch_mix(cmd, last_cmd_op))
+			mix++;
+
+		if (mix == UINT32_MAX)
+			break;
+
+		last_cmd_op = cmd->op;
+	}
+
+	return mix < 2;
+}
+
+int cmd_batch_add(struct cmd *cmd, struct list_head *cmds)
+{
+	struct cmd_batch *cmd_batch = NULL;
+	struct cmd *last_cmd = NULL;
+
+	if (!list_empty(cmds)) {
+		cmd_batch = list_last_entry(cmds, struct cmd_batch, list);
+		last_cmd = list_last_entry(&cmd_batch->sublist, struct cmd, list);
+	}
+
+	if ((cmd->op == CMD_LIST || cmd->op == CMD_RESET) ||
+	    ((last_cmd  && (last_cmd->op == CMD_LIST || last_cmd->op == CMD_RESET)) &&
+	     (cmd->op != CMD_LIST && cmd->op != CMD_RESET))) {
+		__cmd_batch_add(cmd, cmds);
+		goto out;
+	}
+
+	if (!cmd_batch)
+		__cmd_batch_add(cmd, cmds);
+	else
+		list_add_tail(&cmd->list, &cmd_batch->sublist);
+out:
+	if (!cmd_batch_validate(cmds))
+		return -1;
+
+	return 0;
+}
diff --git a/src/libnftables.c b/src/libnftables.c
index 987f5d73ade4..c645314d89b2 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -665,7 +665,8 @@ err:
 EXPORT_SYMBOL(nft_run_cmd_from_buffer);
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 {
-	int rc = -EINVAL;
+	struct cmd_batch *cmd_batch, *next;
+	int rc = -EINVAL, rc_loop = 0;
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
 	char *nlbuf;
@@ -679,7 +680,19 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
 					    &indesc_cmdline);
 
-	rc = nft_eval_run_cmds(nft, &msgs, &cmds, rc);
+	if (rc < 0 && list_empty(&cmds))
+		erec_print_list(&nft->output, &msgs, nft->debug_mask);
+
+	list_for_each_entry_safe(cmd_batch, next, &cmds, list) {
+		rc = nft_eval_run_cmds(nft, &msgs, &cmd_batch->sublist, rc);
+		assert(list_empty(&cmd_batch->sublist));
+		list_del(&cmd_batch->list);
+		free(cmd_batch);
+		if (rc < 0)
+			rc_loop = rc;
+	}
+	if (rc_loop)
+		rc = rc_loop;
 
 	free(nlbuf);
 	iface_cache_release();
@@ -760,10 +773,11 @@ static struct error_record *filename_is_useable(struct nft_ctx *nft, const char
 
 static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
+	struct cmd_batch *cmd_batch, *next;
 	struct error_record *erec;
+	int rc, rc_loop = 0;
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
-	int rc;
 
 	erec = filename_is_useable(nft, filename);
 	if (erec) {
@@ -782,10 +796,23 @@ static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename
 	if (rc == -EINVAL)
 		rc = nft_parse_bison_filename(nft, filename, &msgs, &cmds);
 
-	if (nft->optimize_flags)
-		nft_optimize(nft, &cmds);
+	if (rc < 0 && list_empty(&cmds))
+		erec_print_list(&nft->output, &msgs, nft->debug_mask);
+
+	list_for_each_entry_safe(cmd_batch, next, &cmds, list) {
+		if (nft->optimize_flags)
+			nft_optimize(nft, &cmd_batch->sublist);
+
+		rc = nft_eval_run_cmds(nft, &msgs, &cmd_batch->sublist, rc);
+		assert(list_empty(&cmd_batch->sublist));
+		list_del(&cmd_batch->list);
+		free(cmd_batch);
+		if (rc < 0)
+			rc_loop = rc;
+	}
 
-	rc = nft_eval_run_cmds(nft, &msgs, &cmds, rc);
+	if (rc_loop)
+		rc = rc_loop;
 
 	iface_cache_release();
 	if (nft->scanner) {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5a334bf0c499..48151a419096 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1073,7 +1073,11 @@ input			:	/* empty */
 			{
 				if ($2 != NULL) {
 					$2->location = @2;
-					list_add_tail(&$2->list, state->cmds);
+					if (cmd_batch_add($2, state->cmds) < 0) {
+						erec_queue(error(&@2, "unsupported command mix"),
+							   state->msgs);
+						YYERROR;
+					}
 				}
 			}
 			;
@@ -1210,7 +1214,11 @@ line			:	common_block			{ $$ = NULL; }
 				 */
 				if ($1 != NULL) {
 					$1->location = @1;
-					list_add_tail(&$1->list, state->cmds);
+					if (cmd_batch_add($1, state->cmds) < 0) {
+						erec_queue(error(&@2, "unsupported command mix"),
+							   state->msgs);
+						YYERROR;
+					}
 				}
 				$$ = NULL;
 				YYACCEPT;
diff --git a/src/parser_json.c b/src/parser_json.c
index 2f70b9877c6e..9656e154f052 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -4492,7 +4492,6 @@ static int __json_parse(struct json_ctx *ctx)
 
 	json_array_foreach(tmp, index, value) {
 		/* this is more or less from parser_bison.y:716 */
-		LIST_HEAD(list);
 		struct cmd *cmd;
 		json_t *tmp2;
 
@@ -4522,9 +4521,11 @@ static int __json_parse(struct json_ctx *ctx)
 			return -1;
 		}
 
-		list_add_tail(&cmd->list, &list);
-
-		list_splice_tail(&list, ctx->cmds);
+		if (cmd_batch_add(cmd, ctx->cmds) < 0) {
+			json_error(ctx, "unsupported command mix");
+			cmd_free(cmd);
+			return -1;
+		}
 
 		if (nft_output_echo(&ctx->nft->output))
 			json_cmd_assoc_add(value, cmd);
-- 
2.47.3

