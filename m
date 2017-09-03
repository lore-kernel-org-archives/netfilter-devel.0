From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 44/47] netfilter: conntrack: don't log "invalid" icmpv6 connections
Date: Mon,  4 Sep 2017 00:42:51 +0200
Message-ID: <1504478574-13281-9-git-send-email-pablo@netfilter.org>
References: <1504478574-13281-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1504478574-13281-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When enabling logging for invalid connections we currently also log most
icmpv6 types, which we don't track intentionally (e.g. neigh discovery).
"invalid" should really mean "invalid", i.e. short header or bad checksum.

We don't do any logging for icmp(v4) either, its just useless noise.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 808f63e2e1ff..43544b975eae 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -121,11 +121,6 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
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
2.1.4
