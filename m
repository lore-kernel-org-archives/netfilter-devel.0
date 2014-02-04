From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 6/8] parser: recover from errors in any block
Date: Tue,  4 Feb 2014 08:35:18 +0000
Message-ID: <1391502920-19186-7-git-send-email-kaber@trash.net>
References: <1391502920-19186-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43624 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaBDIf2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:35:28 -0500
In-Reply-To: <1391502920-19186-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Move error recovery to the common_block definition to handle errors
in any block. Queue those errors and abort parsing once a threshold
is reached.

With this in place, we can continue parsing when errors occur and
show all of them to the user at once.

tests/error.1:3:8-8: Error: syntax error, unexpected '{', expecting string
filter {
       ^
tests/error.1:4:13-13: Error: syntax error, unexpected newline
filter input
            ^
tests/error.1:5:17-17: Error: syntax error, unexpected newline
filter input tcp
                ^
tests/error.1:6:23-23: Error: syntax error, unexpected newline
filter input tcp dport

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/nftables.h | 1 +
 include/parser.h   | 1 +
 src/main.c         | 3 ++-
 src/parser.y       | 7 ++++++-
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 5a00087..7f3968d 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -24,6 +24,7 @@ enum debug_level {
 
 #define INCLUDE_PATHS_MAX	16
 
+extern unsigned int max_errors;
 extern unsigned int numeric_output;
 extern unsigned int handle_output;
 extern unsigned int debug_level;
diff --git a/include/parser.h b/include/parser.h
index f5dd6f4..7a1c2db 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -19,6 +19,7 @@ struct parser_state {
 	unsigned int			indesc_idx;
 
 	struct list_head		*msgs;
+	unsigned int			nerrs;
 
 	struct scope			top_scope;
 	struct scope			*scopes[SCOPE_NEST_MAX];
diff --git a/src/main.c b/src/main.c
index 28ce1aa..2320a82 100644
--- a/src/main.c
+++ b/src/main.c
@@ -26,6 +26,7 @@
 #include <erec.h>
 #include <mnl.h>
 
+unsigned int max_errors = 10;
 unsigned int numeric_output;
 unsigned int handle_output;
 #ifdef DEBUG
@@ -219,7 +220,7 @@ int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 	int ret = 0;
 
 	ret = nft_parse(scanner, state);
-	if (ret != 0)
+	if (ret != 0 || state->nerrs > 0)
 		return -1;
 
 	memset(&ctx, 0, sizeof(ctx));
diff --git a/src/parser.y b/src/parser.y
index fa33b57..0dad036 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -518,6 +518,12 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_seperator
 				symbol_bind(current_scope(state), $2, $4);
 				xfree($2);
 			}
+			|	error		stmt_seperator
+			{
+				if (++state->nerrs == max_errors)
+					YYABORT;
+				yyerrok;
+			}
 			;
 
 line			:	common_block			{ $$ = NULL; }
@@ -542,7 +548,6 @@ line			:	common_block			{ $$ = NULL; }
 
 				YYACCEPT;
 			}
-			|	base_cmd	error		{ $$ = $1; }
 			;
 
 base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
-- 
1.8.5.3

