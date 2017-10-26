From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/8] payload: add basic infrastructure to keep some dependencies
Date: Fri, 27 Oct 2017 01:06:08 +0200
Message-ID: <20171026230611.14269-6-fw@strlen.de>
References: <20171026230611.14269-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59770 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932335AbdJZXGN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2017 19:06:13 -0400
In-Reply-To: <20171026230611.14269-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

all the errors highlighted by the new test cases are because our current
dependency removal scheme is too trigger-happy.

Add infrastructure to do extra checks to see if the dependency can really
be removed.

This change has no effect because the new pdep_is_redundant() function
always returns true.

The next patch changes the default to false (keep dependency).

The split is to clarify infrastructure vs. conditions that need to be met
for a dependency to be okay.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index 12d359fd1738..9cb8c6144d70 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -468,6 +468,63 @@ static enum proto_bases expr_to_base(const struct expr *expr)
 	return PROTO_BASE_INVALID;
 }
 
+static bool get_relop_base(const struct stmt *stmt,
+			   enum proto_bases *base)
+{
+	const struct expr *lhs, *rel;
+
+	if (stmt->ops->type != STMT_EXPRESSION)
+		return false;
+
+	rel = stmt->expr;
+	if (rel->ops->type != EXPR_RELATIONAL)
+		return false;
+
+	lhs = rel->left;
+	if ((lhs->flags & EXPR_F_PROTOCOL) == 0)
+		return false;
+
+	*base = expr_to_base(lhs);
+	return *base != PROTO_BASE_INVALID;
+}
+
+/*
+ * For INET/BRIDGE/NETDEV families extra care needs to be taken before
+ * removing a dependency, it might restrict the l3 protocol.  Examples:
+ *
+ * ip protocol tcp tcp dport 22
+ *
+ * In bridge/inet/netdev case, this rule only matches tcp/ipv4 so the
+ * l3 dependency cannot be removed.
+ *
+ * ip protocol ipv6-icmp meta l4proto ipv6-icmp icmpv6 type 1
+ *
+ * This only matches ipv6-icmp in ipv4, so 'ip protocol' must not be
+ * removed either.
+ */
+static bool pdep_is_redundant(struct payload_dep_ctx *pdctx,
+			      const struct proto_ctx *pctx,
+			      enum proto_bases base)
+{
+	const struct proto_desc *proto, *proto_upper;
+	const struct stmt *stmt = pdctx->pdep;
+	unsigned int family = pctx->family;
+	enum proto_bases depbase;
+
+	if (family == NFPROTO_IPV4 || family == NFPROTO_IPV6)
+		return true;
+
+	if (!get_relop_base(stmt, &depbase))
+		return true;
+
+	proto = pctx->protocol[depbase].desc;
+	proto_upper = pctx->protocol[base].desc;
+	if (proto == proto_upper)
+		return true;
+
+	return true;
+}
+
 /**
  * __payload_dependency_kill - kill a redundant payload depedency
  *
@@ -484,7 +541,8 @@ void __payload_dependency_kill(struct payload_dep_ctx *pdctx,
 {
 	if (pdctx->pbase != PROTO_BASE_INVALID &&
 	    pdctx->pbase == base &&
-	    pdctx->pdep != NULL) {
+	    pdctx->pdep != NULL &&
+	    pdep_is_redundant(pdctx, pctx, base)) {
 		list_del(&pdctx->pdep->list);
 		stmt_free(pdctx->pdep);
 
-- 
2.13.6

