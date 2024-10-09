Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26F91922F4
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 13:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728481475; cv=none; b=I3gdF0HTRLmRUAINEwGIy5Vf4jdndvKjuXkJWe6BhU2MIalAhbWY6HKFY1dZVReEDY/ddRWYw2+nmV0mvhayGloZikSnMccGNTY39SFI9kix5OiE1qdl4tHJ2OLSC/YxnzkOmB9eHs86CrPZo2TokiMzuuo/f4la6SfLW6dTXjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728481475; c=relaxed/simple;
	bh=+9vSfw7NIvvIH2+EBvJ5EJAI2oH8t4WJjs6E2hkaxiA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=WtrVo4dlOxku3VfPGhZmJgyNFo8Ktk9RThcFdTlgC0kijJ+A0Lx6CS++ks6S2o1/JU9zlHAJk57hB3eQK1THK+nH4jN80VagaTFdDtkECz2WbFqB5X4CHszeoO4ewLM0T6DSVHGOq4S+DDcZ+D1yMeIzpKi8IvGmrCGrN050naQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] libnftables: remove set element uncollapse for error reporting
Date: Wed,  9 Oct 2024 15:44:27 +0200
Message-Id: <20241009134427.3487792-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Error reporting works fine with recent -stable kernels:

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

which is provided by this small "fix":

 commit b53c116642502b0c85ecef78bff4f826a7dd4145
 Author: Pablo Neira Ayuso <pablo@netfilter.org>
 Date:   Fri May 20 00:02:06 2022 +0200

    netfilter: nf_tables: set element extended ACK reporting support

no need to relate commands via sequence number, ditch this expensive
workaround in userspace.

Release collapsed commands from list since they contain no elements
anymore.

Fixes: 498a5f0c219d ("rule: collapse set element commands")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: release empty command object after collapsing elements.

 include/cmd.h        |  2 +-
 include/expression.h |  1 -
 include/rule.h       |  1 -
 src/cmd.c            | 42 +++++-------------------------------------
 src/libnftables.c    |  7 +------
 src/rule.c           |  1 -
 6 files changed, 7 insertions(+), 47 deletions(-)

diff --git a/include/cmd.h b/include/cmd.h
index 92a4152bbaea..360d32d0099f 100644
--- a/include/cmd.h
+++ b/include/cmd.h
@@ -7,7 +7,7 @@ void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
 
 void nft_cmd_expand(struct cmd *cmd);
 void nft_cmd_post_expand(struct cmd *cmd);
-bool nft_cmd_collapse(struct list_head *cmds);
+void nft_cmd_collapse(struct list_head *cmds);
 void nft_cmd_uncollapse(struct list_head *cmds);
 
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
index 9a572b5660c7..7f3728d74cbe 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -460,11 +460,10 @@ void nft_cmd_expand(struct cmd *cmd)
 	}
 }
 
-bool nft_cmd_collapse(struct list_head *cmds)
+void nft_cmd_collapse(struct list_head *cmds)
 {
 	struct cmd *cmd, *next, *elems = NULL;
 	struct expr *expr, *enext;
-	bool collapse = false;
 
 	list_for_each_entry_safe(cmd, next, cmds, list) {
 		if (cmd->op != CMD_ADD &&
@@ -498,43 +497,12 @@ bool nft_cmd_collapse(struct list_head *cmds)
 			continue;
 		}
 
-		collapse = true;
-		list_for_each_entry_safe(expr, enext, &cmd->expr->expressions, list) {
-			expr->cmd = cmd;
+		list_for_each_entry_safe(expr, enext, &cmd->expr->expressions, list)
 			list_move_tail(&expr->list, &elems->expr->expressions);
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
+		elems->expr->size += cmd->expr->size;
 
-			list_add(&collapse_cmd->list, &cmd->list);
-		}
+		list_del(&cmd->list);
+		cmd_free(cmd);
 	}
 }
diff --git a/src/libnftables.c b/src/libnftables.c
index 2ae215013cb0..1ea5640e81be 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -513,7 +513,6 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 {
 	struct nft_cache_filter *filter;
 	struct cmd *cmd, *next;
-	bool collapsed = false;
 	unsigned int flags;
 	int err = 0;
 
@@ -529,8 +528,7 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 
 	nft_cache_filter_fini(filter);
 
-	if (nft_cmd_collapse(cmds))
-		collapsed = true;
+	nft_cmd_collapse(cmds);
 
 	list_for_each_entry(cmd, cmds, list) {
 		if (cmd->op != CMD_ADD &&
@@ -553,9 +551,6 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 		}
 	}
 
-	if (collapsed)
-		nft_cmd_uncollapse(cmds);
-
 	if (err < 0 || nft->state->nerrs)
 		return -1;
 
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

