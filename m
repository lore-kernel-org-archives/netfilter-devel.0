From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] cmd: initialize cmd list and use list_splice_tail() for adding to command list
Date: Wed,  5 Feb 2014 19:10:09 +0000
Message-ID: <1391627409-4750-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59290 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBETKN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:10:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With incremental evaluation we're first evaluating the command before
adding it to the global command list, so the command's list_head is
uninitialized during evaluation. We need to initialize it to handle the
case that an implicit set declaration will prepend a command to the list.

Also list_splice_tail() needs to be used instead of list_add_tail() to
add the entire list of commands.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser.y | 4 ++--
 src/rule.c   | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index f6c9488..2050f8a 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -497,7 +497,7 @@ input			:	/* empty */
 						if (++state->nerrs == max_errors)
 							YYABORT;
 					} else
-						list_add_tail(&$2->list, &state->cmds);
+						list_splice_tail(&$2->list, &state->cmds);
 				}
 			}
 			;
@@ -560,7 +560,7 @@ line			:	common_block			{ $$ = NULL; }
 						if (++state->nerrs == max_errors)
 							YYABORT;
 					} else
-						list_add_tail(&$1->list, &state->cmds);
+						list_splice_tail(&$1->list, &state->cmds);
 				}
 				$$ = NULL;
 
diff --git a/src/rule.c b/src/rule.c
index 657695a..ab96e62 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -426,6 +426,7 @@ struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 	struct cmd *cmd;
 
 	cmd = xzalloc(sizeof(*cmd));
+	init_list_head(&cmd->list);
 	cmd->op       = op;
 	cmd->obj      = obj;
 	cmd->handle   = *h;
-- 
1.8.5.3

