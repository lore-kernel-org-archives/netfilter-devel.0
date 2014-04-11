From: Ana Rey <anarey@gmail.com>
Subject: [nft PATCH] expression: Fix inconsistent output in set
Date: Fri, 11 Apr 2014 10:26:46 +0200
Message-ID: <1daccfe0798bd032f1770b0ae7888a88db46f3f6.1397204678.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:39378 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaDKI0z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:26:55 -0400
Received: by mail-wg0-f43.google.com with SMTP id x13so5005053wgg.26
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2014 01:26:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a whitespace between the last element in a set and the close braces.

Old output set:

	set set-test {
		type ipv4_address
		elements = { 192.168.1.44, 192.168.2.4}
	}

New output set:
	set set-test {
		type ipv4_address
		elements = { 192.168.1.44, 192.168.2.4 }
	}

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index fa14d99..3b299ff 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -734,7 +734,7 @@ static void set_expr_print(const struct expr *expr)
 {
 	printf("{ ");
 	compound_expr_print(expr, ", ");
-	printf("}");
+	printf(" }");
 }
 
 static void set_expr_set_type(const struct expr *expr,
-- 
1.9.0

