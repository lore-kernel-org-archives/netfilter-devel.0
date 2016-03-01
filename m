From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 08/10] exthdr: store offset for later use
Date: Tue,  1 Mar 2016 16:37:48 +0100
Message-ID: <1456846670-28179-9-git-send-email-fw@strlen.de>
References: <1456846670-28179-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49312 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358AbcCAPiA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:38:00 -0500
In-Reply-To: <1456846670-28179-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Its possible that we cannot find the template without also
considering an implicit mask.  For this we need to store the offset.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/expression.h | 1 +
 src/exthdr.c         | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/expression.h b/include/expression.h
index eacbb2d..72b6f69 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -264,6 +264,7 @@ struct expr {
 			/* EXPR_EXTHDR */
 			const struct exthdr_desc	*desc;
 			const struct proto_hdr_template	*tmpl;
+			unsigned int			offset;
 		} exthdr;
 		struct {
 			/* EXPR_META */
diff --git a/src/exthdr.c b/src/exthdr.c
index 9ed0b6a..512de0a 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -37,6 +37,7 @@ static void exthdr_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->exthdr.desc = expr->exthdr.desc;
 	new->exthdr.tmpl = expr->exthdr.tmpl;
+	new->exthdr.offset = expr->exthdr.offset;
 }
 
 static const struct expr_ops exthdr_expr_ops = {
@@ -86,6 +87,7 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
 	assert(expr->ops->type == EXPR_EXTHDR);
 
 	expr->len = len;
+	expr->exthdr.offset = offset;
 	expr->exthdr.desc = exthdr_protocols[type];
 	assert(expr->exthdr.desc != NULL);
 
-- 
2.4.10

