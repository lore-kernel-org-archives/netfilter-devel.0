From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/7] payload: enforce ip/ip6 protocol depending on icmp or icmpv6
Date: Fri, 19 May 2017 22:11:08 +0200
Message-ID: <20170519201111.7402-5-fw@strlen.de>
References: <20170519201111.7402-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34044 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755022AbdESULG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 16:11:06 -0400
In-Reply-To: <20170519201111.7402-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After some discussion with Pablo we agreed to treat icmp/icmpv6 specially.

in the case of a rule like 'tcp dport 22' the inet, bridge and netdev
families only care about the lower layer protocol.

In the icmpv6 case however we'd like to also enforce an ipv6 protocol check
(and ipv4 check in icmp case).

This extends payload_gen_special_dependency() to consider this.
With this patch:

add rule $pf filter input meta l4proto icmpv6
add rule $pf filter input meta l4proto icmpv6 icmpv6 type echo-request
add rule $pf filter input icmpv6 type echo-request

will work in all tables and all families.
For inet/bridge/netdev, an ipv6 protocol dependency is added; this will
not match ipv4 packets with ip->protocol == icmpv6, EXCEPT in the case
of the ip family.

Its still possible to match icmpv6-in-ipv4 in inet/bridge/netdev with an
explicit dependency:

add rule inet f i ip protocol ipv6-icmp meta l4proto ipv6-icmp icmpv6 type ...

Implicit dependencies won't get removed at the moment, so
  bridge ... icmp type echo-request
will be shown as
  ether type ip meta l4proto 1 icmp type echo-request

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Patch was not part of v2

 src/payload.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index 38db15ee2664..8796ee57fd4c 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -264,10 +264,29 @@ payload_gen_special_dependency(struct eval_ctx *ctx, const struct expr *expr)
 	case PROTO_BASE_LL_HDR:
 		return payload_get_get_ll_hdr(ctx);
 	case PROTO_BASE_TRANSPORT_HDR:
-		if (expr->payload.desc == &proto_icmp)
-			return &proto_ip;
-		if (expr->payload.desc == &proto_icmp6)
-			return &proto_ip6;
+		if (expr->payload.desc == &proto_icmp ||
+		    expr->payload.desc == &proto_icmp6) {
+			const struct proto_desc *desc, *desc_upper;
+			struct stmt *nstmt;
+
+			desc = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+			if (!desc) {
+				desc = payload_get_get_ll_hdr(ctx);
+				if (!desc)
+					break;
+			}
+
+			desc_upper = &proto_ip6;
+			if (expr->payload.desc == &proto_icmp)
+				desc_upper = &proto_ip;
+
+			if (payload_add_dependency(ctx, desc, desc_upper,
+						   expr, &nstmt) < 0)
+				return NULL;
+
+			list_add_tail(&nstmt->list, &ctx->stmt->list);
+			return desc_upper;
+		}
 		return &proto_inet_service;
 	default:
 		break;
-- 
2.13.0

