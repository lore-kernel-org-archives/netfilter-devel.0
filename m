From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/4] src: add create set command
Date: Wed, 24 Aug 2016 16:45:04 +0200
Message-ID: <1472049907-7935-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756136AbcHXOqY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 10:46:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3E9E3231660
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D568100795
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2F14D100A5D
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:11 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for the 'create' command, we already support this in other
existing objects, so support this for sets too, eg.

 # nft add set x y { type ipv4_addr\; }
 # nft create set x y { type ipv4_addr\; }
 <cmdline>:1:1-35: Error: Could not process rule: File exists
 create set x y { type ipv4_addr; }
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 # nft add set x y { type ipv4_addr\; }
 #

This command sets the NLM_F_EXCL netlink flag, so if the object already
exists, nf_tables returns -EEXIST.

This is changing the existing behaviour of 'nft add set' which was
setting this flag, this is inconsistent with regards to the way other
objects behave.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h  |  2 +-
 src/netlink.c      | 17 ++++++++++-------
 src/parser_bison.y | 14 ++++++++++++++
 src/rule.c         |  8 ++++----
 4 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 76a9da4..5f48707 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -148,7 +148,7 @@ extern int netlink_flush_table(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
 
 extern int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
-			   struct set *set);
+			   struct set *set, bool excl);
 extern int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
 			      const struct location *loc);
 extern int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
diff --git a/src/netlink.c b/src/netlink.c
index cf24c8a..f897b0e 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1117,8 +1117,10 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 }
 
 static int netlink_add_set_compat(struct netlink_ctx *ctx,
-				  const struct handle *h, struct set *set)
+				  const struct handle *h, struct set *set,
+				  bool excl)
 {
+	unsigned int flags = excl ? NLM_F_EXCL : 0;
 	struct nftnl_set *nls;
 	int err;
 
@@ -1136,7 +1138,7 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 	}
 	netlink_dump_set(nls);
 
-	err = mnl_nft_set_add(nf_sock, nls, NLM_F_EXCL | NLM_F_ECHO);
+	err = mnl_nft_set_add(nf_sock, nls, NLM_F_ECHO | flags);
 	if (err < 0)
 		netlink_io_error(ctx, &set->location, "Could not add set: %s",
 				 strerror(errno));
@@ -1148,7 +1150,8 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 }
 
 static int netlink_add_set_batch(struct netlink_ctx *ctx,
-				 const struct handle *h, struct set *set)
+				 const struct handle *h, struct set *set,
+				 bool excl)
 {
 	struct nftnl_set *nls;
 	int err;
@@ -1183,7 +1186,7 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 
 	netlink_dump_set(nls);
 
-	err = mnl_nft_set_batch_add(nls, NLM_F_EXCL, ctx->seqnum);
+	err = mnl_nft_set_batch_add(nls, excl ? NLM_F_EXCL : 0, ctx->seqnum);
 	if (err < 0)
 		netlink_io_error(ctx, &set->location, "Could not add set: %s",
 				 strerror(errno));
@@ -1193,12 +1196,12 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 }
 
 int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
-		    struct set *set)
+		    struct set *set, bool excl)
 {
 	if (ctx->batch_supported)
-		return netlink_add_set_batch(ctx, h, set);
+		return netlink_add_set_batch(ctx, h, set, excl);
 	else
-		return netlink_add_set_compat(ctx, h, set);
+		return netlink_add_set_compat(ctx, h, set, excl);
 }
 
 static int netlink_del_set_compat(struct netlink_ctx *ctx,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a3d93bf..5d5ce8c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -774,6 +774,20 @@ create_cmd		:	TABLE		table_spec
 				close_scope(state);
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_CHAIN, &$2, &@$, $5);
 			}
+			|	SET		set_spec	set_block_alloc
+						'{'	set_block	'}'
+			{
+				$5->location = @5;
+				handle_merge(&$3->handle, &$2);
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SET, &$2, &@$, $5);
+			}
+			|	MAP		set_spec	map_block_alloc
+						'{'	map_block	'}'
+			{
+				$5->location = @5;
+				handle_merge(&$3->handle, &$2);
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SET, &$2, &@$, $5);
+			}
 			;
 
 insert_cmd		:	RULE		rule_position	rule
diff --git a/src/rule.c b/src/rule.c
index 14e57f2..54edd8c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -906,9 +906,9 @@ static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 }
 
 static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
-		      struct set *set)
+		      struct set *set, bool excl)
 {
-	if (netlink_add_set(ctx, h, set) < 0)
+	if (netlink_add_set(ctx, h, set, excl) < 0)
 		return -1;
 	if (set->init != NULL)
 		return __do_add_setelems(ctx, &set->handle, set, set->init);
@@ -934,7 +934,7 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 		}
 		list_for_each_entry(set, &table->sets, list) {
 			handle_merge(&set->handle, &table->handle);
-			if (do_add_set(ctx, &set->handle, set) < 0)
+			if (do_add_set(ctx, &set->handle, set, excl) < 0)
 				return -1;
 		}
 		list_for_each_entry(chain, &table->chains, list) {
@@ -958,7 +958,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 		return netlink_add_rule_batch(ctx, &cmd->handle,
 					      cmd->rule, NLM_F_APPEND);
 	case CMD_OBJ_SET:
-		return do_add_set(ctx, &cmd->handle, cmd->set);
+		return do_add_set(ctx, &cmd->handle, cmd->set, excl);
 	case CMD_OBJ_SETELEM:
 		return do_add_setelems(ctx, &cmd->handle, cmd->expr);
 	default:
-- 
2.1.4

