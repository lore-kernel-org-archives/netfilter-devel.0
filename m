From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: don't need keyword for log level
Date: Fri, 21 Oct 2016 13:06:28 +0200
Message-ID: <1477047988-14363-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44996 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754307AbcJULGk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 07:06:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B903C9D33C
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 13:06:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99F0CDA846
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 13:06:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41D40DA846
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 13:06:36 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can handle log levels without keywords in our grammar, use string
instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 32 ++++++++++++++++++++++++--------
 src/scanner.l      |  8 --------
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index baf0a539efa0..f582221a089e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1517,14 +1517,30 @@ log_arg			:	PREFIX			string
 			}
 			;
 
-level_type		:	LEVEL_EMERG	{ $$ = LOG_EMERG; }
-			|	LEVEL_ALERT	{ $$ = LOG_ALERT; }
-			|	LEVEL_CRIT	{ $$ = LOG_CRIT; }
-			|	LEVEL_ERR	{ $$ = LOG_ERR; }
-			|	LEVEL_WARN	{ $$ = LOG_WARNING; }
-			|	LEVEL_NOTICE	{ $$ = LOG_NOTICE; }
-			|	LEVEL_INFO	{ $$ = LOG_INFO; }
-			|	LEVEL_DEBUG	{ $$ = LOG_DEBUG; }
+level_type		:	string
+			{
+				if (!strcmp("emerg", $1))
+					$$ = LOG_EMERG;
+				else if (!strcmp("alert", $1))
+					$$ = LOG_ALERT;
+				else if (!strcmp("crit", $1))
+					$$ = LOG_CRIT;
+				else if (!strcmp("err", $1))
+					$$ = LOG_ERR;
+				else if (!strcmp("warning", $1))
+					$$ = LOG_WARNING;
+				else if (!strcmp("notice", $1))
+					$$ = LOG_NOTICE;
+				else if (!strcmp("info", $1))
+					$$ = LOG_INFO;
+				else if (!strcmp("debug", $1))
+					$$ = LOG_DEBUG;
+				else {
+					erec_queue(error(&@1, "invalid log level", $1),
+						   state->msgs);
+					YYERROR;
+				}
+			}
 			;
 
 limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst
diff --git a/src/scanner.l b/src/scanner.l
index 8b5a383bd095..467954374f11 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -299,14 +299,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "snaplen"		{ return SNAPLEN; }
 "queue-threshold"	{ return QUEUE_THRESHOLD; }
 "level"			{ return LEVEL; }
-"emerg"			{ return LEVEL_EMERG; }
-"alert"			{ return LEVEL_ALERT; }
-"crit"			{ return LEVEL_CRIT; }
-"err"			{ return LEVEL_ERR; }
-"warn"			{ return LEVEL_WARN; }
-"notice"		{ return LEVEL_NOTICE; }
-"info"			{ return LEVEL_INFO; }
-"debug"			{ return LEVEL_DEBUG; }
 
 "queue"			{ return QUEUE;}
 "num"			{ return QUEUENUM;}
-- 
2.1.4

