Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBFCC43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jun 2022 18:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348064AbiFMS7J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jun 2022 14:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239146AbiFMS5y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jun 2022 14:57:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D24A03FDBB
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jun 2022 09:05:39 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 1/2] rule: collapse set element commands
Date:   Mon, 13 Jun 2022 18:05:35 +0200
Message-Id: <20220613160536.127441-1-pablo@netfilter.org>
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

collapse them into one single command, ie.

  add element t s { 1.0.1.0/24, ..., 1.0.2.0/23 }

Since 3da9643fb9ff9 ("intervals: add support to automerge with kernel
elements"), the new interval tracking relies on mergesort. The pattern
above triggers the set sorting for each element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h    |  1 +
 src/libnftables.c |  2 ++
 src/rule.c        | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index e232b97afed7..5d7a6da4a5e7 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -728,6 +728,7 @@ extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 			     const struct handle *h, const struct location *loc,
 			     void *data);
 extern void nft_cmd_expand(struct cmd *cmd);
+extern void nft_cmd_collapse(struct list_head *cmds);
 extern struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type,
 				    const struct handle *h,
 				    const struct location *loc, struct obj *obj);
diff --git a/src/libnftables.c b/src/libnftables.c
index 6a22ea093952..48cff3fb0e1f 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -512,6 +512,8 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 
 	nft_cache_filter_fini(filter);
 
+	nft_cmd_collapse(cmds);
+
 	list_for_each_entry_safe(cmd, next, cmds, list) {
 		struct eval_ctx ectx = {
 			.nft	= nft,
diff --git a/src/rule.c b/src/rule.c
index 7f61bdc1cec9..47a8c24a6b0e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1379,6 +1379,45 @@ void nft_cmd_expand(struct cmd *cmd)
 	}
 }
 
+void nft_cmd_collapse(struct list_head *cmds)
+{
+	struct cmd *cmd, *next, *elems = NULL;
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
+		list_splice_init(&cmd->expr->expressions, &elems->expr->expressions);
+		elems->expr->size += cmd->expr->size;
+		list_del(&cmd->list);
+		cmd_free(cmd);
+	}
+}
+
 struct markup *markup_alloc(uint32_t format)
 {
 	struct markup *markup;
-- 
2.30.2

