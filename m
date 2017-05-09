From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 06/10] netlink_delinearize: reject: remove dependency for tcp-resets
Date: Tue,  9 May 2017 17:51:18 +0200
Message-ID: <20170509155122.26356-7-fw@strlen.de>
References: <20170509155122.26356-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44562 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755803AbdEIPvZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 11:51:25 -0400
In-Reply-To: <20170509155122.26356-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can remove a l4 dependency in ip/ipv6 families.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 6 ++++++
 tests/py/ip6/reject.t     | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f0288cd49914..49dc6a6016ba 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1856,10 +1856,16 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 	case NFPROTO_IPV4:
 		stmt->reject.family = rctx->pctx.family;
 		stmt->reject.expr->dtype = &icmp_code_type;
+		if (stmt->reject.type == NFT_REJECT_TCP_RST)
+			__payload_dependency_kill(&rctx->pdctx,
+						  PROTO_BASE_TRANSPORT_HDR);
 		break;
 	case NFPROTO_IPV6:
 		stmt->reject.family = rctx->pctx.family;
 		stmt->reject.expr->dtype = &icmpv6_code_type;
+		if (stmt->reject.type == NFT_REJECT_TCP_RST)
+			__payload_dependency_kill(&rctx->pdctx,
+						  PROTO_BASE_TRANSPORT_HDR);
 		break;
 	case NFPROTO_INET:
 		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH) {
diff --git a/tests/py/ip6/reject.t b/tests/py/ip6/reject.t
index 7d21aa8ef160..de09fd978418 100644
--- a/tests/py/ip6/reject.t
+++ b/tests/py/ip6/reject.t
@@ -9,7 +9,7 @@ reject with icmpv6 type addr-unreachable;ok
 reject with icmpv6 type port-unreachable;ok;reject
 reject with icmpv6 type policy-fail;ok
 reject with icmpv6 type reject-route;ok
-reject with tcp reset;ok;ip6 nexthdr 6 reject with tcp reset
+reject with tcp reset;ok
 
 reject with icmpv6 type host-unreachable;fail
 reject with icmp type host-unreachable;fail
-- 
2.10.2

