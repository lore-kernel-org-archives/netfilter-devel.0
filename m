From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] xt: use struct xt_xlate_{mt,tg}_params
Date: Sun, 24 Jul 2016 12:55:51 +0200
Message-ID: <1469357751-17414-1-git-send-email-pablo@netfilter.org>
Cc: pablombg@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33271 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbcGXKz7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Jul 2016 06:55:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7FAD8C510D
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 12:55:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6748AFF12D
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 12:55:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 33505FC61C
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 12:55:55 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adapt this code to the new interface that introduces
struct xt_xlate_{mt,tg}_params.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/xt.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/src/xt.c b/src/xt.c
index afcc836..0777d9c 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -35,9 +35,14 @@ void xt_stmt_xlate(const struct stmt *stmt)
 		if (stmt->xt.match == NULL && stmt->xt.opts) {
 			printf("%s", stmt->xt.opts);
 		} else if (stmt->xt.match->xlate) {
-			stmt->xt.match->xlate(stmt->xt.entry,
-					      stmt->xt.match->m, xl, 0);
-				printf("%s", xt_xlate_get(xl));
+			struct xt_xlate_mt_params params = {
+				.ip		= stmt->xt.entry,
+				.match		= stmt->xt.match->m,
+				.numeric        = 0,
+			};
+
+			stmt->xt.match->xlate(xl, &params);
+			printf("%s", xt_xlate_get(xl));
 		} else if (stmt->xt.match->print) {
 			printf("#");
 			stmt->xt.match->print(&stmt->xt.entry,
@@ -49,8 +54,13 @@ void xt_stmt_xlate(const struct stmt *stmt)
 		if (stmt->xt.target == NULL && stmt->xt.opts) {
 			printf("%s", stmt->xt.opts);
 		} else if (stmt->xt.target->xlate) {
-			stmt->xt.target->xlate(stmt->xt.entry,
-					       stmt->xt.target->t, xl, 0);
+			struct xt_xlate_tg_params params = {
+				.ip		= stmt->xt.entry,
+				.target		= stmt->xt.target->t,
+				.numeric        = 0,
+			};
+
+			stmt->xt.target->xlate(xl, &params);
 			printf("%s", xt_xlate_get(xl));
 		} else if (stmt->xt.target->print) {
 			printf("#");
-- 
2.1.4

