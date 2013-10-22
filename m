From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] statement: avoid huge rodata array
Date: Tue, 22 Oct 2013 14:35:02 +0200
Message-ID: <1382445302-8050-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34961 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257Ab3JVMgr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:36:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit b259d1a ('src: operational limit match') creates huge
array, increasing nft binary size from ~240k to ~5m on x86_64.

Use switch statement instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/statement.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/src/statement.c b/src/statement.c
index 658dc5f..f201919 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -142,18 +142,23 @@ struct stmt *log_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &log_stmt_ops);
 }
 
+static const char *get_unit(uint64_t u)
+{
+	switch (u) {
+	case 1: return "seconds";
+	case 60: return "minute";
+	case 60 * 60: return "hour";
+	case 60 * 60 * 24: return "day";
+	case 60 * 60 * 24 * 7: return "week";
+	}
+
+	return "error";
+}
+
 static void limit_stmt_print(const struct stmt *stmt)
 {
-	static const char *units[] = {
-		[1]			= "second",
-		[1 * 60]		= "minute",
-		[1 * 60 * 60]		= "hour",
-		[1 * 60 * 60 * 24]	= "day",
-		[1 * 60 * 60 * 24 * 7]	= "week",
-	};
-
 	printf("limit rate %" PRIu64 "/%s",
-	       stmt->limit.rate, units[stmt->limit.unit]);
+	       stmt->limit.rate, get_unit(stmt->limit.unit));
 }
 
 static const struct stmt_ops limit_stmt_ops = {
-- 
1.8.1.5

