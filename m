From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/2] expr: fix crash when listing non-verdict mappings
Date: Mon, 12 Jan 2015 10:02:08 +0000
Message-ID: <1421056928-1247-2-git-send-email-kaber@trash.net>
References: <1421056928-1247-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33883 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbbALKCW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:02:22 -0500
In-Reply-To: <1421056928-1247-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix regression introduced by commit 87c2a2205:

  netlink_delinearize: clone on netlink_get_register(), release previous on _set()

When using a non-verdict mapping, the set ref expression is assigned to the
destination register. The next get_register() will attempt to clone it and
crash because of the missing ->clone() callback.

# nft filter input meta mark set ip daddr map { 192.168.0.1 : 123 }
# nft list table filter
Segmentation fault (core dumped)

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/expression.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index 8ba2e8a..5b848da 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -858,6 +858,11 @@ static void set_ref_expr_print(const struct expr *expr)
 		printf("@%s", expr->set->handle.set);
 }
 
+static void set_ref_expr_clone(struct expr *new, const struct expr *expr)
+{
+	new->set = set_get(expr->set);
+}
+
 static void set_ref_expr_destroy(struct expr *expr)
 {
 	set_free(expr->set);
@@ -867,6 +872,7 @@ static const struct expr_ops set_ref_expr_ops = {
 	.type		= EXPR_SET_REF,
 	.name		= "set reference",
 	.print		= set_ref_expr_print,
+	.clone		= set_ref_expr_clone,
 	.destroy	= set_ref_expr_destroy,
 };
 
-- 
2.1.0

