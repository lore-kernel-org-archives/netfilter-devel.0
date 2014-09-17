From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] parser: compact log level grammar
Date: Wed, 17 Sep 2014 15:26:31 +0200
Message-ID: <1410960391-17909-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55774 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbaIQN0e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:26:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Put rule and action on a single line as for other simple mappings.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser.y | 40 ++++++++--------------------------------
 1 file changed, 8 insertions(+), 32 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index 653c764..be3b2e9 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -1316,38 +1316,14 @@ log_arg			:	PREFIX			string
 			}
 			;
 
-level_type		:	LEVEL_EMERG
-			{
-				$$ = LOG_EMERG;
-			}
-			|	LEVEL_ALERT
-			{
-				$$ = LOG_ALERT;
-			}
-			|	LEVEL_CRIT
-			{
-				$$ = LOG_CRIT;
-			}
-			|	LEVEL_ERR
-			{
-				$$ = LOG_ERR;
-			}
-			|	LEVEL_WARN
-			{
-				$$ = LOG_WARNING;
-			}
-			|	LEVEL_NOTICE
-			{
-				$$ = LOG_NOTICE;
-			}
-			|	LEVEL_INFO
-			{
-				$$ = LOG_INFO;
-			}
-			|	LEVEL_DEBUG
-			{
-				$$ = LOG_DEBUG;
-			}
+level_type		:	LEVEL_EMERG	{ $$ = LOG_EMERG; }
+			|	LEVEL_ALERT	{ $$ = LOG_ALERT; }
+			|	LEVEL_CRIT	{ $$ = LOG_CRIT; }
+			|	LEVEL_ERR	{ $$ = LOG_ERR; }
+			|	LEVEL_WARN	{ $$ = LOG_WARNING; }
+			|	LEVEL_NOTICE	{ $$ = LOG_NOTICE; }
+			|	LEVEL_INFO	{ $$ = LOG_INFO; }
+			|	LEVEL_DEBUG	{ $$ = LOG_DEBUG; }
 			;
 
 limit_stmt		:	LIMIT	RATE	NUM	SLASH	time_unit
-- 
1.9.3

