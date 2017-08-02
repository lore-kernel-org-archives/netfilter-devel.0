From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] src: handle rule tracing as an monitor object
Date: Wed,  2 Aug 2017 14:15:09 +0200
Message-ID: <1501676110-9173-1-git-send-email-pablo@netfilter.org>
Cc: rvarsha016@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40300 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753082AbdHBMP2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2017 08:15:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAAD3D25E4
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2017 14:15:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A6A31B3D38
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2017 14:15:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38EB71B3356
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2017 14:15:10 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Traces are not an event type, they should be handled as an object.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     |  1 +
 src/evaluate.c     | 31 ++++---------------------------
 src/parser_bison.y |  2 ++
 src/scanner.l      |  1 +
 4 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index e22002724f90..a0edda2fec83 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -397,6 +397,7 @@ enum {
 	CMD_MONITOR_OBJ_SETS,
 	CMD_MONITOR_OBJ_ELEMS,
 	CMD_MONITOR_OBJ_RULESET,
+	CMD_MONITOR_OBJ_TRACE,
 	CMD_MONITOR_OBJ_MAX
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 959e8542dfff..d24526fef295 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3218,7 +3218,6 @@ enum {
 	CMD_MONITOR_EVENT_ANY,
 	CMD_MONITOR_EVENT_NEW,
 	CMD_MONITOR_EVENT_DEL,
-	CMD_MONITOR_EVENT_TRACE,
 	CMD_MONITOR_EVENT_MAX
 };
 
@@ -3247,6 +3246,7 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 						  (1 << NFT_MSG_DELSETELEM) |
 						  (1 << NFT_MSG_NEWOBJ)	  |
 						  (1 << NFT_MSG_DELOBJ),
+		[CMD_MONITOR_OBJ_TRACE]		= (1 << NFT_MSG_TRACE),
 	},
 	[CMD_MONITOR_EVENT_NEW] = {
 		[CMD_MONITOR_OBJ_ANY]		= (1 << NFT_MSG_NEWTABLE) |
@@ -3264,7 +3264,8 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 						  (1 << NFT_MSG_NEWRULE)  |
 						  (1 << NFT_MSG_NEWSET)   |
 						  (1 << NFT_MSG_NEWSETELEM) |
-						  (1 << NFT_MSG_NEWOBJ)
+						  (1 << NFT_MSG_NEWOBJ),
+		[CMD_MONITOR_OBJ_TRACE]		= 0,
 	},
 	[CMD_MONITOR_EVENT_DEL] = {
 		[CMD_MONITOR_OBJ_ANY]		= (1 << NFT_MSG_DELTABLE) |
@@ -3283,29 +3284,7 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 						  (1 << NFT_MSG_DELSET)   |
 						  (1 << NFT_MSG_DELSETELEM) |
 						  (1 << NFT_MSG_DELOBJ),
-	},
-	[CMD_MONITOR_EVENT_TRACE] = {
-		[CMD_MONITOR_OBJ_ANY]		= (1 << NFT_MSG_NEWTABLE) |
-						  (1 << NFT_MSG_NEWCHAIN) |
-						  (1 << NFT_MSG_NEWRULE)  |
-						  (1 << NFT_MSG_DELTABLE) |
-						  (1 << NFT_MSG_DELCHAIN) |
-						  (1 << NFT_MSG_DELRULE)  |
-						  (1 << NFT_MSG_TRACE),
-		[CMD_MONITOR_OBJ_TABLES]	= (1 << NFT_MSG_NEWTABLE) |
-						  (1 << NFT_MSG_DELTABLE),
-		[CMD_MONITOR_OBJ_CHAINS]	= (1 << NFT_MSG_NEWCHAIN) |
-						  (1 << NFT_MSG_DELCHAIN),
-		[CMD_MONITOR_OBJ_RULES]		= (1 << NFT_MSG_NEWRULE) |
-						  (1 << NFT_MSG_DELRULE),
-		[CMD_MONITOR_OBJ_RULESET]       = (1 << NFT_MSG_NEWTABLE) |
-						  (1 << NFT_MSG_NEWCHAIN) |
-						  (1 << NFT_MSG_NEWRULE)  |
-						  (1 << NFT_MSG_NEWOBJ)	  |
-						  (1 << NFT_MSG_DELTABLE) |
-						  (1 << NFT_MSG_DELCHAIN) |
-						  (1 << NFT_MSG_DELRULE)  |
-						  (1 << NFT_MSG_DELOBJ),
+		[CMD_MONITOR_OBJ_TRACE]		= 0,
 	},
 };
 
@@ -3324,8 +3303,6 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 		event = CMD_MONITOR_EVENT_NEW;
 	else if (strcmp(cmd->monitor->event, "destroy") == 0)
 		event = CMD_MONITOR_EVENT_DEL;
-	else if (strcmp(cmd->monitor->event, "trace") == 0)
-		event = CMD_MONITOR_EVENT_TRACE;
 	else {
 		return monitor_error(ctx, cmd->monitor, "invalid event %s",
 				     cmd->monitor->event);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 86baf23a00c1..e7bb9097929b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -194,6 +194,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token MAPS			"maps"
 %token HANDLE			"handle"
 %token RULESET			"ruleset"
+%token TRACE			"trace"
 
 %token INET			"inet"
 %token NETDEV			"netdev"
@@ -1196,6 +1197,7 @@ monitor_object		:	/* empty */	{ $$ = CMD_MONITOR_OBJ_ANY; }
 			|	RULES		{ $$ = CMD_MONITOR_OBJ_RULES; }
 			|	ELEMENTS	{ $$ = CMD_MONITOR_OBJ_ELEMS; }
 			|	RULESET		{ $$ = CMD_MONITOR_OBJ_RULESET; }
+			|	TRACE		{ $$ = CMD_MONITOR_OBJ_TRACE; }
 			;
 
 monitor_format		:	/* empty */	{ $$ = NFTNL_OUTPUT_DEFAULT; }
diff --git a/src/scanner.l b/src/scanner.l
index 7d5437f123ce..b6ba32d88f4a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -250,6 +250,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "maps"			{ return MAPS; }
 "handle"		{ return HANDLE; }
 "ruleset"		{ return RULESET; }
+"trace"			{ return TRACE; }
 
 "accept"		{ return ACCEPT; }
 "drop"			{ return DROP; }
-- 
2.1.4

