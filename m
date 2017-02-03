From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] statement: Print NAT IPv4 address in nat_stmt_print()
Date: Fri, 3 Feb 2017 16:50:38 -0200
Message-ID: <20170203185038.GA6536@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:34084 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbdBCSup (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 13:50:45 -0500
Received: by mail-yw0-f196.google.com with SMTP id v73so2443545ywg.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Feb 2017 10:50:45 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The case which "nat.addr != NULL && nat.proto != NULL && type != ipv6"
wasn't caught in nat_stmt_print(). Now all cases should be considered.

Also, the if statements were reorganized to get rid of one nested if.

Fixes(Bug 1117 - Table ipv4-nat prerouting dnat doesn't accept dest IP:PORT)

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 src/statement.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/src/statement.c b/src/statement.c
index 9cdabbb..0585d66 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -494,25 +494,26 @@ static void nat_stmt_print(const struct stmt *stmt)
 	};
 
 	printf("%s to ", nat_types[stmt->nat.type]);
-	if (stmt->nat.addr) {
-		if (stmt->nat.proto) {
-			if (stmt->nat.addr->ops->type == EXPR_VALUE &&
-			    stmt->nat.addr->dtype->type == TYPE_IP6ADDR) {
-				printf("[");
-				expr_print(stmt->nat.addr);
-				printf("]");
-			} else if (stmt->nat.addr->ops->type == EXPR_RANGE &&
-				   stmt->nat.addr->left->dtype->type == TYPE_IP6ADDR) {
-				printf("[");
-				expr_print(stmt->nat.addr->left);
-				printf("]-[");
-				expr_print(stmt->nat.addr->right);
-				printf("]");
-			}
+	if (stmt->nat.addr && stmt->nat.proto) {
+		if (stmt->nat.addr->ops->type == EXPR_RANGE &&
+		    stmt->nat.addr->left->dtype->type == TYPE_IP6ADDR) {
+			printf("[");
+			expr_print(stmt->nat.addr->left);
+			printf("]-[");
+			expr_print(stmt->nat.addr->right);
+			printf("]");
+		}
+		else if (stmt->nat.addr->dtype->type == TYPE_IP6ADDR) {
+			printf("[");
+			expr_print(stmt->nat.addr);
+			printf("]");
 		} else {
 			expr_print(stmt->nat.addr);
 		}
 	}
+	else if (stmt->nat.addr) {
+		expr_print(stmt->nat.addr);
+	}
 
 	if (stmt->nat.proto) {
 		printf(":");
-- 
2.7.4

