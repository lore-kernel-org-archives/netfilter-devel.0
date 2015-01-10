From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] netlink_delinearize: fix error handling for invalid registers
Date: Sat, 10 Jan 2015 14:59:15 +0000
Message-ID: <1420901955-21087-3-git-send-email-kaber@trash.net>
References: <1420901955-21087-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49192 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbbAJO7k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Jan 2015 09:59:40 -0500
In-Reply-To: <1420901955-21087-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netlink_delinearize is prepared to deal with malformed expressions from
the kernel that it doesn't understand. However since expressions are now
cloned unconditionally by netlink_get_register(), we crash before such
errors can be detected for invalid inputs.

Fix by only cloning non-NULL expressions.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_delinearize.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e9a04dd..79d5af6 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -75,7 +75,10 @@ static struct expr *netlink_get_register(struct netlink_parse_ctx *ctx,
 	}
 
 	expr = ctx->registers[reg];
-	return expr_clone(expr);
+	if (expr != NULL)
+		expr = expr_clone(expr);
+
+	return expr;
 }
 
 static void netlink_release_registers(struct netlink_parse_ctx *ctx)
-- 
2.1.0

