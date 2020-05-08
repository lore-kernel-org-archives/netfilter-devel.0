Return-Path: <SRS0=IXkg=6W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD5FC38A2A
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 May 2020 13:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B7220870
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 May 2020 13:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgEHNRL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 May 2020 09:17:11 -0400
Received: from correo.us.es ([193.147.175.20]:35524 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729176AbgEHMoS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 May 2020 08:44:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9FD4B15C112
        for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2020 14:44:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 935AC203E9
        for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2020 14:44:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 88F225BC; Fri,  8 May 2020 14:44:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8145B203E9;
        Fri,  8 May 2020 14:44:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 08 May 2020 14:44:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6406142EF4E1;
        Fri,  8 May 2020 14:44:14 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 3/3] src: add CMD_OBJ_SETELEMS
Date:   Fri,  8 May 2020 14:44:03 +0200
Message-Id: <20200508124403.876-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200508124403.876-1-pablo@netfilter.org>
References: <20200508124403.876-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new command type results from expanding the set definition in two
commands: One to add the set and another to add the elements. This
results in 1:1 mapping between the command object to the netlink API.
The command is then translated into a netlink message which gets a
unique sequence number. This sequence number allows to correlate the
netlink extended error reporting with the corresponding command.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |  2 ++
 src/rule.c     | 23 +++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index f0f7ee33a3ae..cfb76b8a0c10 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -561,6 +561,7 @@ enum cmd_ops {
  * @CMD_OBJ_ELEMENTS:	set element(s)
  * @CMD_OBJ_SET:	set
  * @CMD_OBJ_SETS:	multiple sets
+ * @CMD_OBJ_SETELEMS:	set elements
  * @CMD_OBJ_RULE:	rule
  * @CMD_OBJ_CHAIN:	chain
  * @CMD_OBJ_CHAINS:	multiple chains
@@ -588,6 +589,7 @@ enum cmd_obj {
 	CMD_OBJ_INVALID,
 	CMD_OBJ_ELEMENTS,
 	CMD_OBJ_SET,
+	CMD_OBJ_SETELEMS,
 	CMD_OBJ_SETS,
 	CMD_OBJ_RULE,
 	CMD_OBJ_CHAIN,
diff --git a/src/rule.c b/src/rule.c
index 227b9f30b91d..1f56faeb5c3c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1417,11 +1417,11 @@ void cmd_add_loc(struct cmd *cmd, uint16_t offset, struct location *loc)
 void nft_cmd_expand(struct cmd *cmd)
 {
 	struct list_head new_cmds;
+	struct set *set, *newset;
 	struct flowtable *ft;
 	struct table *table;
 	struct chain *chain;
 	struct rule *rule;
-	struct set *set;
 	struct obj *obj;
 	struct cmd *new;
 	struct handle h;
@@ -1477,6 +1477,18 @@ void nft_cmd_expand(struct cmd *cmd)
 		}
 		list_splice(&new_cmds, &cmd->list);
 		break;
+	case CMD_OBJ_SET:
+		set = cmd->set;
+		memset(&h, 0, sizeof(h));
+		handle_merge(&h, &set->handle);
+		newset = set_clone(set);
+		newset->handle.set_id = set->handle.set_id;
+		newset->init = set->init;
+		set->init = NULL;
+		new = cmd_alloc(CMD_ADD, CMD_OBJ_SETELEMS, &h,
+				&set->location, newset);
+		list_add(&new->list, &cmd->list);
+		break;
 	default:
 		break;
 	}
@@ -1525,6 +1537,7 @@ void cmd_free(struct cmd *cmd)
 			expr_free(cmd->expr);
 			break;
 		case CMD_OBJ_SET:
+		case CMD_OBJ_SETELEMS:
 			set_free(cmd->set);
 			break;
 		case CMD_OBJ_RULE:
@@ -1610,7 +1623,7 @@ static int do_add_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
 }
 
 static int do_add_set(struct netlink_ctx *ctx, struct cmd *cmd,
-		      uint32_t flags)
+		      uint32_t flags, bool add)
 {
 	struct set *set = cmd->set;
 
@@ -1621,7 +1634,7 @@ static int do_add_set(struct netlink_ctx *ctx, struct cmd *cmd,
 				     &ctx->nft->output) < 0)
 			return -1;
 	}
-	if (mnl_nft_set_add(ctx, cmd, flags) < 0)
+	if (add && mnl_nft_set_add(ctx, cmd, flags) < 0)
 		return -1;
 	if (set->init != NULL) {
 		return __do_add_setelems(ctx, set, set->init, flags);
@@ -1644,7 +1657,9 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_RULE:
 		return mnl_nft_rule_add(ctx, cmd, flags | NLM_F_APPEND);
 	case CMD_OBJ_SET:
-		return do_add_set(ctx, cmd, flags);
+		return do_add_set(ctx, cmd, flags, true);
+	case CMD_OBJ_SETELEMS:
+		return do_add_set(ctx, cmd, flags, false);
 	case CMD_OBJ_ELEMENTS:
 		return do_add_setelems(ctx, cmd, flags);
 	case CMD_OBJ_COUNTER:
-- 
2.20.1

