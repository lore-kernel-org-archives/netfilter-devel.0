From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/6] src: add maximum number of parser errors to struct nft_ctx
Date: Tue, 22 Aug 2017 19:05:07 +0200
Message-ID: <1503421511-17814-3-git-send-email-pablo@netfilter.org>
References: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40952 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751679AbdHVRF3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 13:05:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3A2CCD25EE
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2894DA7F30
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:13 +0200 (CEST)
In-Reply-To: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not a global variable anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h | 2 +-
 src/main.c         | 2 +-
 src/parser_bison.y | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 8399b1ae68f9..8858ad605516 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -41,12 +41,12 @@ struct nft_cache {
 struct nft_ctx {
 	const char		*include_paths[INCLUDE_PATHS_MAX];
 	unsigned int		num_include_paths;
+	unsigned int		parser_max_errors;
 	struct output_ctx	output;
 	bool			check;
 	struct nft_cache	cache;
 };
 
-extern unsigned int max_errors;
 extern unsigned int debug_level;
 
 enum nftables_exit_codes {
diff --git a/src/main.c b/src/main.c
index eb0dfb02fd15..fc44b186d5f0 100644
--- a/src/main.c
+++ b/src/main.c
@@ -29,7 +29,6 @@
 #include <cli.h>
 
 static struct nft_ctx nft;
-unsigned int max_errors = 10;
 #ifdef DEBUG
 unsigned int debug_level;
 #endif
@@ -295,6 +294,7 @@ static void nft_ctx_init(struct nft_ctx *nft)
 {
 	nft->include_paths[0]	= DEFAULT_INCLUDE_PATH;
 	nft->num_include_paths	= 1;
+	nft->parser_max_errors = 10;
 }
 
 int main(int argc, char * const *argv)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 18c0f0aa9600..7c00f4f099f7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -692,7 +692,7 @@ input			:	/* empty */
 
 					list_add_tail(&$2->list, &list);
 					if (cmd_evaluate(&state->ectx, $2) < 0) {
-						if (++state->nerrs == max_errors)
+						if (++state->nerrs == nft->parser_max_errors)
 							YYABORT;
 					} else
 						list_splice_tail(&list, &state->cmds);
@@ -731,7 +731,7 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_seperator
 			}
 			|	error		stmt_seperator
 			{
-				if (++state->nerrs == max_errors)
+				if (++state->nerrs == nft->parser_max_errors)
 					YYABORT;
 				yyerrok;
 			}
@@ -758,7 +758,7 @@ line			:	common_block			{ $$ = NULL; }
 
 					list_add_tail(&$1->list, &list);
 					if (cmd_evaluate(&state->ectx, $1) < 0) {
-						if (++state->nerrs == max_errors)
+						if (++state->nerrs == nft->parser_max_errors)
 							YYABORT;
 					} else
 						list_splice_tail(&list, &state->cmds);
-- 
2.1.4


