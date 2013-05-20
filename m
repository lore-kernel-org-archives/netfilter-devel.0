From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH] rule: display rule handle as comment
Date: Tue, 21 May 2013 01:09:00 +0200
Message-ID: <1369091340-29211-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56985 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab3ETXJS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 May 2013 19:09:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Knowing the rule handle is necessary to be able to delete a single
rule. It was not displayed till now in the output and it was thus
impossible to remove a single rule.
This patch modify the listing output to add a comment containing
the handle.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/rule.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 9d9eaee..b2d7844 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <stdint.h>
 #include <string.h>
+#include <inttypes.h>
 
 #include <statement.h>
 #include <rule.h>
@@ -136,6 +137,7 @@ void rule_print(const struct rule *rule)
 		printf(" ");
 		stmt->ops->print(stmt);
 	}
+	printf(" # handle %" PRIu64, rule->handle.handle);
 	printf("\n");
 }
 
-- 
1.7.10.4

