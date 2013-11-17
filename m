From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 1/3] expression: fix indent
Date: Mon, 18 Nov 2013 00:54:43 +0100
Message-ID: <1384732485-12944-2-git-send-email-eric@regit.org>
References: <DUB109-W87FE1E5161E5C42ED6593AE1F80@phx.gbl>
 <1384732485-12944-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	Alex Chapman <ajchapman88@hotmail.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:42591 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3KRARp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Nov 2013 19:17:45 -0500
In-Reply-To: <1384732485-12944-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/expression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index 8cf3f62..71154cc 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -156,7 +156,7 @@ static void verdict_expr_clone(struct expr *new, const struct expr *expr)
 
 static void verdict_expr_destroy(struct expr *expr)
 {
-        xfree(expr->chain);
+	xfree(expr->chain);
 }
 
 static const struct expr_ops verdict_expr_ops = {
-- 
1.8.4.3

