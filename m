From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: nat: fix spurious connection timeouts
Date: Mon, 11 Feb 2019 17:53:19 +0100
Message-ID: <20190211165319.17965-3-pablo@netfilter.org>
References: <20190211165319.17965-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190211165319.17965-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Sander Eikelenboom bisected a NAT related regression down
to the l4proto->manip_pkt indirection removal.

I forgot that ICMP(v6) errors (e.g. PKTTOOBIG) can be set as related
to the existing conntrack entry.

Therefore, when passing the skb to nf_nat_ipv4/6_manip_pkt(), that
ended up calling the wrong l4 manip function, as tuple->dst.protonum
is the original flows l4 protocol (TCP, UDP, etc).

Set the dst protocol field to ICMP(v6), we already have a private copy
of the tuple due to the inversion of src/dst.

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Fixes: faec18dbb0405 ("netfilter: nat: remove l4proto->manip_pkt")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c | 1 +
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index 2687db015b6f..fa2ba7c500e4 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -215,6 +215,7 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 
 	/* Change outer to look like the reply to an incoming packet */
 	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+	target.dst.protonum = IPPROTO_ICMP;
 	if (!nf_nat_ipv4_manip_pkt(skb, 0, &target, manip))
 		return 0;
 
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index 23022447eb49..7a41ee3c11b4 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -226,6 +226,7 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 	}
 
 	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+	target.dst.protonum = IPPROTO_ICMPV6;
 	if (!nf_nat_ipv6_manip_pkt(skb, 0, &target, manip))
 		return 0;
 
-- 
2.11.0
