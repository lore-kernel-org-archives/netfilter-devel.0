From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/7] exthdr: move print of tcp options to tcpopt.c
Date: Sun, 20 Aug 2017 01:14:09 +0200
Message-ID: <20170819231413.15164-4-fw@strlen.de>
References: <20170819231413.15164-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39294 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752270AbdHSXOF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 19:14:05 -0400
In-Reply-To: <20170819231413.15164-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

a followup patch will add template type tests (in order
to print short-hand version of tcp mss mangling), it seems
better to not have this in exthdr.c, so move this code to tcpopt.c
first.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/tcpopt.h |  2 ++
 src/exthdr.c     | 32 +++++++++-----------------------
 src/tcpopt.c     | 20 ++++++++++++++++++++
 3 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/include/tcpopt.h b/include/tcpopt.h
index f96c04c6ee93..42e9cf0506e5 100644
--- a/include/tcpopt.h
+++ b/include/tcpopt.h
@@ -14,6 +14,8 @@ extern void tcpopt_init_raw(struct expr *expr, uint8_t type,
 extern bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
 				 unsigned int *shift);
 
+void tcpopt_expr_print(const struct expr *expr, struct output_ctx *octx);
+
 enum tcpopt_hdr_types {
 	TCPOPTHDR_INVALID,
 	TCPOPTHDR_EOL,
diff --git a/src/exthdr.c b/src/exthdr.c
index a412025c9a48..73b2c05836e0 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -25,29 +25,15 @@
 static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT) {
-		/* Offset calcualtion is a bit hacky at this point.
-		 * There might be an tcp option one day with another
-		 * multiplicator
-		 */
-		unsigned int offset = expr->exthdr.offset / 64;
-		char buf[9] = {0};
-
-		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT) {
-			printf("tcp option %s", expr->exthdr.desc->name);
-			return;
-		}
-
-		if (offset)
-			snprintf(buf, sizeof buf, "%d", offset);
-		printf("tcp option %s%s %s", expr->exthdr.desc->name, buf,
-					     expr->exthdr.tmpl->token);
-	} else {
-		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
-			printf("exthdr %s", expr->exthdr.desc->name);
-		else {
-			printf("%s %s", expr->exthdr.desc ? expr->exthdr.desc->name : "unknown-exthdr",
-					expr->exthdr.tmpl->token);
-		}
+		tcpopt_expr_print(expr, octx);
+		return;
+	}
+
+	if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
+		printf("exthdr %s", expr->exthdr.desc->name);
+	else {
+		printf("%s %s", expr->exthdr.desc ? expr->exthdr.desc->name : "unknown-exthdr",
+				expr->exthdr.tmpl->token);
 	}
 }
 
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 7c6c2557028a..a76ad3490f9c 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -227,6 +227,26 @@ void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
 	}
 }
 
+void tcpopt_expr_print(const struct expr *expr, struct output_ctx *octx)
+{
+	/* Offset calcualtion is a bit hacky at this point.
+	 * There might be an tcp option one day with another
+	 * multiplicator
+	 */
+	unsigned int offset = expr->exthdr.offset / 64;
+	char buf[9] = {0};
+
+	if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT) {
+		printf("tcp option %s", expr->exthdr.desc->name);
+		return;
+	}
+
+	if (offset)
+		snprintf(buf, sizeof buf, "%d", offset);
+	printf("tcp option %s%s %s", expr->exthdr.desc->name, buf,
+				     expr->exthdr.tmpl->token);
+}
+
 bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
 			  unsigned int *shift)
 {
-- 
2.13.0

