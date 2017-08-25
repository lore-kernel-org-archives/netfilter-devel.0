From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: don't log "invalid" icmpv6 connections
Date: Fri, 25 Aug 2017 02:59:41 +0200
Message-ID: <20170825005941.8773-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38486 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753456AbdHYA7X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 20:59:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When enabling logging for invalid connections we currently also log most
icmpv6 types, which we don't track intentionally (e.g. neigh discovery).
"invalid" should really mean "invalid", i.e. short header or bad checksum.

We don't do any logging for icmp(v4) either, its just useless noise.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 413c4a0093da..0ce826d8ebff 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -130,11 +130,6 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 		pr_debug("icmpv6: can't create new conn with type %u\n",
 			 type + 128);
 		nf_ct_dump_tuple_ipv6(&ct->tuplehash[0].tuple);
-		if (LOG_INVALID(nf_ct_net(ct), IPPROTO_ICMPV6))
-			nf_log_packet(nf_ct_net(ct), PF_INET6, 0, skb, NULL,
-				      NULL, NULL,
-				      "nf_ct_icmpv6: invalid new with type %d ",
-				      type + 128);
 		return false;
 	}
 	return true;
-- 
2.13.0

