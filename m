From: Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 2/7] payload: print base and raw values for unknown payloads
Date: Wed, 27 Jul 2016 02:43:11 +0200
Message-ID: <1469580196-2100-3-git-send-email-fw@strlen.de>
References: <1469580196-2100-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60780 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758182AbcG0BPa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 21:15:30 -0400
In-Reply-To: <1469580196-2100-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We currently print 'unknown' rather than the raw offset values
for unrecognized header values.

If its unknown, prefer to print

payload @nh,0,16 set payload @nh,0,16

rather than 'unknown'.

Also add a helper to check if payload expression has a description
assigned to it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h |  1 +
 src/payload.c     | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/payload.h b/include/payload.h
index 37375c1..bda3188 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -31,6 +31,7 @@ struct payload_dep_ctx {
 	struct stmt		*prev;
 };
 
+extern bool payload_is_known(const struct expr *expr);
 extern bool payload_is_stacked(const struct proto_desc *desc,
 			       const struct expr *expr);
 extern void payload_dependency_store(struct payload_dep_ctx *ctx,
diff --git a/src/payload.c b/src/payload.c
index 9ba980a..af533b2 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -26,6 +26,18 @@
 #include <gmputil.h>
 #include <utils.h>
 
+bool payload_is_known(const struct expr *expr)
+{
+	const struct proto_hdr_template *tmpl;
+	const struct proto_desc *desc;
+
+	desc = expr->payload.desc;
+	tmpl = expr->payload.tmpl;
+
+	return desc && tmpl && desc != &proto_unknown &&
+	       tmpl != &proto_unknown_template;
+}
+
 static void payload_expr_print(const struct expr *expr)
 {
 	const struct proto_desc *desc;
@@ -33,7 +45,7 @@ static void payload_expr_print(const struct expr *expr)
 
 	desc = expr->payload.desc;
 	tmpl = expr->payload.tmpl;
-	if (desc != NULL && tmpl != NULL)
+	if (payload_is_known(expr))
 		printf("%s %s", desc->name, tmpl->token);
 	else
 		printf("payload @%s,%u,%u",
-- 
2.7.3

