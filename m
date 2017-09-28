From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 2/5] exthdr: Simplify tcp option printing a bit
Date: Thu, 28 Sep 2017 17:17:42 +0200
Message-ID: <20170928151745.28426-3-phil@nwl.cc>
References: <20170928151745.28426-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35262 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752059AbdI1PR7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2017 11:17:59 -0400
In-Reply-To: <20170928151745.28426-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This eliminates the need for that temporary buffer.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/exthdr.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/src/exthdr.c b/src/exthdr.c
index 4add3da24ad87..37c7688401f60 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -31,17 +31,13 @@ static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 		 * multiplicator
 		 */
 		unsigned int offset = expr->exthdr.offset / 64;
-		char buf[9] = {0};
 
-		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT) {
-			printf("tcp option %s", expr->exthdr.desc->name);
+		printf("tcp option %s", expr->exthdr.desc->name);
+		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
 			return;
-		}
-
 		if (offset)
-			snprintf(buf, sizeof buf, "%d", offset);
-		printf("tcp option %s%s %s", expr->exthdr.desc->name, buf,
-					     expr->exthdr.tmpl->token);
+			printf("%d", offset);
+		printf(" %s", expr->exthdr.tmpl->token);
 	} else {
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
 			printf("exthdr %s", expr->exthdr.desc->name);
-- 
2.13.1

