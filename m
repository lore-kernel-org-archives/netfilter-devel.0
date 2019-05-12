Return-Path: <SRS0=q8lh=TM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A21C04A6B
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 18:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE3072133D
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 18:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfELS5Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 May 2019 14:57:25 -0400
Received: from mail.us.es ([193.147.175.20]:49774 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbfELS5Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 May 2019 14:57:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1D1E51A098E
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2019 20:57:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1126FDA70A
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2019 20:57:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 06D73DA707; Sun, 12 May 2019 20:57:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E481FDA703;
        Sun, 12 May 2019 20:57:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 12 May 2019 20:57:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B26364265A31;
        Sun, 12 May 2019 20:57:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, ffmancera@riseup.net, harshasharmaiitr@gmail.com
Subject: [PATCH nft] src: use definitions in include/linux/netfilter/nf_tables.h
Date:   Sun, 12 May 2019 20:57:17 +0200
Message-Id: <20190512185717.13547-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use NFT_LOGLEVEL_* definitions in UAPI.

Make an internal definition of NFT_OSF_F_VERSION, this was originally
defined in the UAPI header in the initial patch version, however, this
is not available anymore.

Add a bison rule to deal with the timeout case.

Otherwise, compilation breaks.

Fixes: d3869cae9d62 ("include: refresh nf_tables.h cached copy")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/osf.h      |  2 ++
 src/evaluate.c     |  2 +-
 src/parser_bison.y | 31 ++++++++++++++++---------------
 src/statement.c    | 24 ++++++++++++------------
 4 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/include/osf.h b/include/osf.h
index 8f6f5840620e..2eef257c2b51 100644
--- a/include/osf.h
+++ b/include/osf.h
@@ -1,6 +1,8 @@
 #ifndef NFTABLES_OSF_H
 #define NFTABLES_OSF_H
 
+#define NFT_OSF_F_VERSION	0x1
+
 struct expr *osf_expr_alloc(const struct location *loc, const uint8_t ttl,
 			    const uint32_t flags);
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 3593eb80a6a6..21d9e146e587 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2812,7 +2812,7 @@ static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 			return stmt_error(ctx, stmt,
 				  "flags and group are mutually exclusive");
 	}
-	if (stmt->log.level == LOGLEVEL_AUDIT &&
+	if (stmt->log.level == NFT_LOGLEVEL_AUDIT &&
 	    (stmt->log.flags & ~STMT_LOG_LEVEL || stmt->log.logflags))
 		return stmt_error(ctx, stmt,
 				  "log level audit doesn't support any further options");
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9aea65265332..9e632c0d1f6e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2414,23 +2414,23 @@ log_arg			:	PREFIX			string
 level_type		:	string
 			{
 				if (!strcmp("emerg", $1))
-					$$ = LOG_EMERG;
+					$$ = NFT_LOGLEVEL_EMERG;
 				else if (!strcmp("alert", $1))
-					$$ = LOG_ALERT;
+					$$ = NFT_LOGLEVEL_ALERT;
 				else if (!strcmp("crit", $1))
-					$$ = LOG_CRIT;
+					$$ = NFT_LOGLEVEL_CRIT;
 				else if (!strcmp("err", $1))
-					$$ = LOG_ERR;
+					$$ = NFT_LOGLEVEL_ERR;
 				else if (!strcmp("warn", $1))
-					$$ = LOG_WARNING;
+					$$ = NFT_LOGLEVEL_WARNING;
 				else if (!strcmp("notice", $1))
-					$$ = LOG_NOTICE;
+					$$ = NFT_LOGLEVEL_NOTICE;
 				else if (!strcmp("info", $1))
-					$$ = LOG_INFO;
+					$$ = NFT_LOGLEVEL_INFO;
 				else if (!strcmp("debug", $1))
-					$$ = LOG_DEBUG;
+					$$ = NFT_LOGLEVEL_DEBUG;
 				else if (!strcmp("audit", $1))
-					$$ = LOGLEVEL_AUDIT;
+					$$ = NFT_LOGLEVEL_AUDIT;
 				else {
 					erec_queue(error(&@1, "invalid log level"),
 						   state->msgs);
@@ -4101,7 +4101,6 @@ ct_key			:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
 			|	LABEL		{ $$ = NFT_CT_LABELS; }
 			|	EVENT		{ $$ = NFT_CT_EVENTMASK; }
-			|	TIMEOUT 	{ $$ = NFT_CT_TIMEOUT; }
 			|	ct_key_dir_optional
 			;
 
@@ -4150,16 +4149,18 @@ ct_stmt			:	CT	ct_key		SET	stmt_expr
 					$$->objref.type = NFT_OBJECT_CT_HELPER;
 					$$->objref.expr = $4;
 					break;
-				case NFT_CT_TIMEOUT:
-					$$ = objref_stmt_alloc(&@$);
-					$$->objref.type = NFT_OBJECT_CT_TIMEOUT;
-					$$->objref.expr = $4;
-					break;
 				default:
 					$$ = ct_stmt_alloc(&@$, $2, -1, $4);
 					break;
 				}
 			}
+			|	CT	TIMEOUT		SET	stmt_expr
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_CT_TIMEOUT;
+				$$->objref.expr = $4;
+
+			}
 			|	CT	ct_dir	ct_key_dir_optional SET	stmt_expr
 			{
 				$$ = ct_stmt_alloc(&@$, $3, $2, $5);
diff --git a/src/statement.c b/src/statement.c
index 7f9c10b38244..a9e8b3ae0780 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -256,21 +256,21 @@ struct stmt *objref_stmt_alloc(const struct location *loc)
 	return stmt;
 }
 
-static const char *syslog_level[LOGLEVEL_AUDIT + 1] = {
-	[LOG_EMERG]	= "emerg",
-	[LOG_ALERT]	= "alert",
-	[LOG_CRIT]	= "crit",
-	[LOG_ERR]       = "err",
-	[LOG_WARNING]	= "warn",
-	[LOG_NOTICE]	= "notice",
-	[LOG_INFO]	= "info",
-	[LOG_DEBUG]	= "debug",
-	[LOGLEVEL_AUDIT] = "audit"
+static const char *syslog_level[NFT_LOGLEVEL_MAX + 1] = {
+	[NFT_LOGLEVEL_EMERG]	= "emerg",
+	[NFT_LOGLEVEL_ALERT]	= "alert",
+	[NFT_LOGLEVEL_CRIT]	= "crit",
+	[NFT_LOGLEVEL_ERR]	= "err",
+	[NFT_LOGLEVEL_WARNING]	= "warn",
+	[NFT_LOGLEVEL_NOTICE]	= "notice",
+	[NFT_LOGLEVEL_INFO]	= "info",
+	[NFT_LOGLEVEL_DEBUG]	= "debug",
+	[NFT_LOGLEVEL_AUDIT] 	= "audit"
 };
 
 const char *log_level(uint32_t level)
 {
-	if (level > LOGLEVEL_AUDIT)
+	if (level > NFT_LOGLEVEL_MAX)
 		return "unknown";
 
 	return syslog_level[level];
@@ -280,7 +280,7 @@ int log_level_parse(const char *level)
 {
 	int i;
 
-	for (i = 0; i <= LOGLEVEL_AUDIT; i++) {
+	for (i = 0; i <= NFT_LOGLEVEL_MAX; i++) {
 		if (syslog_level[i] &&
 		    !strcmp(level, syslog_level[i]))
 			return i;
-- 
2.11.0

