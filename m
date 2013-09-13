From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 3/3] log: s/threshold/queue-threshold/
Date: Fri, 13 Sep 2013 16:44:48 +0200
Message-ID: <1379083488-20752-3-git-send-email-fw@strlen.de>
References: <1379083488-20752-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58018 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757265Ab3IMOpH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:45:07 -0400
In-Reply-To: <1379083488-20752-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

on input we expect "queue-threshold" token, so use the same
name when printing the output.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/statement.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/statement.c b/src/statement.c
index 1a3ea3c..69db48f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -122,7 +122,7 @@ static void log_stmt_print(const struct stmt *stmt)
 	if (stmt->log.snaplen)
 		printf(" snaplen %u", stmt->log.snaplen);
 	if (stmt->log.qthreshold)
-		printf(" threshold %u", stmt->log.qthreshold);
+		printf(" queue-threshold %u", stmt->log.qthreshold);
 }
 
 static void log_stmt_destroy(struct stmt *stmt)
-- 
1.7.8.6

