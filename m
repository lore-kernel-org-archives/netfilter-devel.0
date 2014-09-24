From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/3] rule: rename do_command_list_cleanup() to table_cleanup()
Date: Wed, 24 Sep 2014 12:32:18 +0200
Message-ID: <1411554740-16660-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:49253 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbaIXKdJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:33:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's use a more generic name for this functions, since it has nothing to do
with commands.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/rule.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 2fe2520..ab533da 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -733,7 +733,7 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
-static void do_command_list_cleanup(struct table *table)
+static void table_cleanup(struct table *table)
 {
 	struct chain *chain, *nchain;
 	struct set *set, *nset;
@@ -837,10 +837,10 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	}
 
 	table_print(table);
-	do_command_list_cleanup(table);
+	table_cleanup(table);
 	return 0;
 err:
-	do_command_list_cleanup(table);
+	table_cleanup(table);
 	return -1;
 }
 
-- 
1.7.10.4

