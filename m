From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] src: nft monitor ruleset
Date: Fri, 28 Jul 2017 10:52:09 +0530
Message-ID: <597aca07.d859620a.30872.0997@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37587 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750827AbdG1FWQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2017 01:22:16 -0400
Received: by mail-pg0-f67.google.com with SMTP id k190so6832741pgk.4
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 22:22:16 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds event reporting for ruleset, which prints only ruleset
events.

Syntax : nft monitor ruleset

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/rule.h     |  1 +
 src/evaluate.c     | 32 ++++++++++++++++++++++++++++++++
 src/parser_bison.y |  1 +
 3 files changed, 34 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 6acd5fa..e220027 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -396,6 +396,7 @@ enum {
 	CMD_MONITOR_OBJ_RULES,
 	CMD_MONITOR_OBJ_SETS,
 	CMD_MONITOR_OBJ_ELEMS,
+	CMD_MONITOR_OBJ_RULESET,
 	CMD_MONITOR_OBJ_MAX
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 27feef4..959e854 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3235,6 +3235,18 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 						  (1 << NFT_MSG_DELSET),
 		[CMD_MONITOR_OBJ_ELEMS]		= (1 << NFT_MSG_NEWSETELEM) |
 						  (1 << NFT_MSG_DELSETELEM),
+		[CMD_MONITOR_OBJ_RULESET]	= (1 << NFT_MSG_NEWTABLE) |
+						  (1 << NFT_MSG_DELTABLE) |
+						  (1 << NFT_MSG_NEWCHAIN) |
+						  (1 << NFT_MSG_DELCHAIN) |
+						  (1 << NFT_MSG_NEWRULE)  |
+						  (1 << NFT_MSG_DELRULE)  |
+						  (1 << NFT_MSG_NEWSET)   |
+						  (1 << NFT_MSG_DELSET)	  |
+						  (1 << NFT_MSG_NEWSETELEM) |
+						  (1 << NFT_MSG_DELSETELEM) |
+						  (1 << NFT_MSG_NEWOBJ)	  |
+						  (1 << NFT_MSG_DELOBJ),
 	},
 	[CMD_MONITOR_EVENT_NEW] = {
 		[CMD_MONITOR_OBJ_ANY]		= (1 << NFT_MSG_NEWTABLE) |
@@ -3247,6 +3259,12 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 		[CMD_MONITOR_OBJ_RULES]		= (1 << NFT_MSG_NEWRULE),
 		[CMD_MONITOR_OBJ_SETS]		= (1 << NFT_MSG_NEWSET),
 		[CMD_MONITOR_OBJ_ELEMS]		= (1 << NFT_MSG_NEWSETELEM),
+		[CMD_MONITOR_OBJ_RULESET]	= (1 << NFT_MSG_NEWTABLE) |
+						  (1 << NFT_MSG_NEWCHAIN) |
+						  (1 << NFT_MSG_NEWRULE)  |
+						  (1 << NFT_MSG_NEWSET)   |
+						  (1 << NFT_MSG_NEWSETELEM) |
+						  (1 << NFT_MSG_NEWOBJ)
 	},
 	[CMD_MONITOR_EVENT_DEL] = {
 		[CMD_MONITOR_OBJ_ANY]		= (1 << NFT_MSG_DELTABLE) |
@@ -3259,6 +3277,12 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 		[CMD_MONITOR_OBJ_RULES]		= (1 << NFT_MSG_DELRULE),
 		[CMD_MONITOR_OBJ_SETS]		= (1 << NFT_MSG_DELSET),
 		[CMD_MONITOR_OBJ_ELEMS]		= (1 << NFT_MSG_DELSETELEM),
+		[CMD_MONITOR_OBJ_RULESET]	= (1 << NFT_MSG_DELTABLE) |
+						  (1 << NFT_MSG_DELCHAIN) |
+						  (1 << NFT_MSG_DELRULE)  |
+						  (1 << NFT_MSG_DELSET)   |
+						  (1 << NFT_MSG_DELSETELEM) |
+						  (1 << NFT_MSG_DELOBJ),
 	},
 	[CMD_MONITOR_EVENT_TRACE] = {
 		[CMD_MONITOR_OBJ_ANY]		= (1 << NFT_MSG_NEWTABLE) |
@@ -3274,6 +3298,14 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 						  (1 << NFT_MSG_DELCHAIN),
 		[CMD_MONITOR_OBJ_RULES]		= (1 << NFT_MSG_NEWRULE) |
 						  (1 << NFT_MSG_DELRULE),
+		[CMD_MONITOR_OBJ_RULESET]       = (1 << NFT_MSG_NEWTABLE) |
+						  (1 << NFT_MSG_NEWCHAIN) |
+						  (1 << NFT_MSG_NEWRULE)  |
+						  (1 << NFT_MSG_NEWOBJ)	  |
+						  (1 << NFT_MSG_DELTABLE) |
+						  (1 << NFT_MSG_DELCHAIN) |
+						  (1 << NFT_MSG_DELRULE)  |
+						  (1 << NFT_MSG_DELOBJ),
 	},
 };
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 45b1dc9..86baf23 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1195,6 +1195,7 @@ monitor_object		:	/* empty */	{ $$ = CMD_MONITOR_OBJ_ANY; }
 			| 	SETS		{ $$ = CMD_MONITOR_OBJ_SETS; }
 			|	RULES		{ $$ = CMD_MONITOR_OBJ_RULES; }
 			|	ELEMENTS	{ $$ = CMD_MONITOR_OBJ_ELEMS; }
+			|	RULESET		{ $$ = CMD_MONITOR_OBJ_RULESET; }
 			;
 
 monitor_format		:	/* empty */	{ $$ = NFTNL_OUTPUT_DEFAULT; }
-- 
2.9.4

