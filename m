From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 4/4] evaluate: reject meta nfproto outside of inet family
Date: Fri, 16 Jun 2017 22:34:11 +0200
Message-ID: <20170616203411.16408-5-fw@strlen.de>
References: <20170616203411.16408-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39958 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752041AbdFPUeG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2017 16:34:06 -0400
In-Reply-To: <20170616203411.16408-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

meta nfproto loads the hook family type of the current rule context
in the kernel, i.e. it will be NFPROTO_IPV6 for ip6 family,
NFPROTO_BRIDGE for bridge and so on.

The only case where this is useful is the inet pseudo family,
where this is useful to determine the real hook family
(NFPROTO_IPV4 or NFPROTO_IPV6).

In all other families 'meta nfproto' is either always true or false.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml    |  9 ++++++++-
 src/evaluate.c | 15 ++++++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index d0d37396dddf..e9ccd63c7164 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -478,7 +478,9 @@ filter input iif $int_ifs accept
 			</simplelist>.
 
 			The <literal>inet</literal> address family is a dummy family which is used to create
-			hybrid IPv4/IPv6 tables.
+			hybrid IPv4/IPv6 tables.  The <literal>meta</literal> expression <literal>nfproto</literal>
+			keyword can be used to test which family (ipv4 or ipv6) context the packet is being processed in.
+
 
 			When no address family is specified, <literal>ip</literal> is used by default.
 		</para>
@@ -1907,6 +1909,11 @@ filter output icmpv6 type { echo-request, echo-reply }
 								<entry>integer (32 bit)</entry>
 							</row>
 							<row>
+								<entry>nfproto</entry>
+								<entry>real hook protocol family, useful only in inet table</entry>
+								<entry>integer (32 bit)</entry>
+							</row>
+							<row>
 								<entry>protocol</entry>
 								<entry>Ethertype protocol value</entry>
 								<entry>ether_type</entry>
diff --git a/src/evaluate.c b/src/evaluate.c
index 311c86c5abe9..4cbbd5f9b52a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1691,6 +1691,18 @@ static int expr_evaluate_fib(struct eval_ctx *ctx, struct expr **exprp)
 	return expr_evaluate_primary(ctx, exprp);
 }
 
+static int expr_evaluate_meta(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *meta = *exprp;
+
+	if (ctx->pctx.family != NFPROTO_INET &&
+	    meta->flags & EXPR_F_PROTOCOL &&
+	    meta->meta.key == NFT_META_NFPROTO)
+		return expr_error(ctx->msgs, meta,
+					  "meta nfproto is only useful in the inet family");
+	return expr_evaluate_primary(ctx, exprp);
+}
+
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
 #ifdef DEBUG
@@ -1712,8 +1724,9 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_EXTHDR:
 		return expr_evaluate_exthdr(ctx, expr);
 	case EXPR_VERDICT:
-	case EXPR_META:
 		return expr_evaluate_primary(ctx, expr);
+	case EXPR_META:
+		return expr_evaluate_meta(ctx, expr);
 	case EXPR_FIB:
 		return expr_evaluate_fib(ctx, expr);
 	case EXPR_PAYLOAD:
-- 
2.13.0

