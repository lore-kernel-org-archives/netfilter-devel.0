From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] src: Honor obligatory stateless printing of flow tables
Date: Wed, 18 Jan 2017 21:06:47 -0200
Message-ID: <20170118230647.GA12926@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33516 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdARXG7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 18:06:59 -0500
Received: by mail-qt0-f194.google.com with SMTP id n13so4805735qtc.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 15:06:54 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 include/nftables.h | 2 +-
 src/main.c         | 4 ++--
 src/statement.c    | 4 ++++
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 760bbff..6f54155 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -26,10 +26,10 @@ enum debug_level {
 
 extern unsigned int max_errors;
 extern unsigned int numeric_output;
+extern unsigned int stateless_output;
 extern unsigned int ip2name_output;
 extern unsigned int handle_output;
 extern unsigned int debug_level;
-extern bool stateless_output;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
 enum nftables_exit_codes {
diff --git a/src/main.c b/src/main.c
index 6d073d5..6ba752b 100644
--- a/src/main.c
+++ b/src/main.c
@@ -30,12 +30,12 @@
 
 unsigned int max_errors = 10;
 unsigned int numeric_output;
+unsigned int stateless_output;
 unsigned int ip2name_output;
 unsigned int handle_output;
 #ifdef DEBUG
 unsigned int debug_level;
 #endif
-bool stateless_output;
 
 const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH };
 static unsigned int num_include_paths = 1;
@@ -291,7 +291,7 @@ int main(int argc, char * const *argv)
 			numeric_output++;
 			break;
 		case OPT_STATELESS:
-			stateless_output = true;
+			stateless_output++;
 			break;
 		case OPT_IP2NAME:
 			ip2name_output++;
diff --git a/src/statement.c b/src/statement.c
index 7e2e448..20f37a6 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -109,6 +109,8 @@ struct stmt *verdict_stmt_alloc(const struct location *loc, struct expr *expr)
 
 static void flow_stmt_print(const struct stmt *stmt)
 {
+	stateless_output++;
+
 	printf("flow ");
 	if (stmt->flow.set) {
 		expr_print(stmt->flow.set, NULL);
@@ -119,6 +121,8 @@ static void flow_stmt_print(const struct stmt *stmt)
 	printf(" ");
 	stmt_print(stmt->flow.stmt);
 	printf("} ");
+
+	stateless_output--;
 }
 
 static void flow_stmt_destroy(struct stmt *stmt)
-- 
2.7.4

