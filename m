From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/8] payload: keep dependencies that enforce a specific l3 protocol
Date: Fri, 27 Oct 2017 01:06:09 +0200
Message-ID: <20171026230611.14269-7-fw@strlen.de>
References: <20171026230611.14269-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59774 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932334AbdJZXGQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2017 19:06:16 -0400
In-Reply-To: <20171026230611.14269-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This change makes dependency removal consider both the type
of the dependency and base of the dependency (linklayer, network).

For icmp, we allow removal as it implies ipv4 even if dependency
'ip protocol' rather than 'meta l4proto', for ipv4 these are the
same.

For ipv6, we do not do this, as 'ip6 nexthdr' does not skip extension
headers.

Because the default is changed to 'keep dependency', this will result
in a ton of test case warnings, we fix them up by allowing more
dependency removals in followup patches.

Most warnings occur in inet table as we no longer remove 'meta nfproto',
even if it is redundant.  Example:

inet test-inet input ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234'
will be shown as
meta nfproto ipv6 ip6 saddr 1...

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index 9cb8c6144d70..184a611704ea 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -469,7 +469,8 @@ static enum proto_bases expr_to_base(const struct expr *expr)
 }
 
 static bool get_relop_base(const struct stmt *stmt,
-			   enum proto_bases *base)
+			   enum proto_bases *base,
+			   unsigned int *type)
 {
 	const struct expr *lhs, *rel;
 
@@ -485,6 +486,7 @@ static bool get_relop_base(const struct stmt *stmt,
 		return false;
 
 	*base = expr_to_base(lhs);
+	*type = lhs->ops->type;
 	return *base != PROTO_BASE_INVALID;
 }
 
@@ -510,11 +512,12 @@ static bool pdep_is_redundant(struct payload_dep_ctx *pdctx,
 	const struct stmt *stmt = pdctx->pdep;
 	unsigned int family = pctx->family;
 	enum proto_bases depbase;
+	unsigned int type;
 
 	if (family == NFPROTO_IPV4 || family == NFPROTO_IPV6)
 		return true;
 
-	if (!get_relop_base(stmt, &depbase))
+	if (!get_relop_base(stmt, &depbase, &type))
 		return true;
 
 	proto = pctx->protocol[depbase].desc;
@@ -522,7 +525,43 @@ static bool pdep_is_redundant(struct payload_dep_ctx *pdctx,
 	if (proto == proto_upper)
 		return true;
 
-	return true;
+	switch (depbase) {
+	case PROTO_BASE_NETWORK_HDR:
+		/* if pdep is meta its redundant ('meta l4proto'). */
+		if (type == EXPR_META)
+			return true;
+
+		/* exceptions: icmp implies ipv4 */
+		if (proto_upper == &proto_icmp && proto == &proto_ip)
+			return true;
+		/* no exception for &proto_icmp6: 'ip protocol' that is
+		 * handled above is NOT the same as ip6 nexthdr, due to
+		 * extension headers in ipv6.
+		 */
+		break;
+	case PROTO_BASE_LL_HDR:
+		/*
+		 * It would be nice to also remove
+		 * 'meta nfproto' in cases like
+		 * meta nfproto ipv6 icmpv6 type ..., but we can't.
+		 * problem is that we do not know the upper (l4 protocol)
+		 * as, we only have access to the next expression.
+		 *
+		 * In this case, that would be EXPR_META (meta l4proto),
+		 * but we need to know the rhs to learn the protocol.
+		 *
+		 * Just removing blindly here
+		 * (if (e->ops->type == EXPR_META) return true), would
+		 * break cases like
+		 * meta nfproto ipv6 tcp dport ..., as tcp doesn't imply
+		 * ipv4 or ipv6, unlike icmp/icmpv6.
+		 */
+		break;
+	default:
+		return true;
+	}
+
+	return false;
 }
 
 /**
-- 
2.13.6

