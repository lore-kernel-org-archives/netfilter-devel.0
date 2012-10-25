From: Ulrich Weber <ulrich.weber@sophos.com>
Subject: [PATCH] nf_nat: dont check for port change on ICMP tuples
Date: Thu, 25 Oct 2012 17:34:45 +0200
Message-ID: <20121025153445.GA22403@uweber-WS>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <netfilter-devel@vger.kernel.org>
To: <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.sophos.com ([145.253.124.138]:51607 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197Ab2JYPew (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:34:52 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ICMP tuples have id in src and type/code in dst.
So comparing src.u.all with dst.u.all will always fail here
and ip_xfrm_me_harder() is called for every ICMP packet,
even if there was no NAT...

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
---
 net/ipv4/netfilter/iptable_nat.c  |    4 +++-
 net/ipv6/netfilter/ip6table_nat.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 9e0ffaf..a820472 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -184,7 +184,8 @@ nf_nat_ipv4_out(unsigned int hooknum,
 
 		if ((ct->tuplehash[dir].tuple.src.u3.ip !=
 		     ct->tuplehash[!dir].tuple.dst.u3.ip) ||
-		    (ct->tuplehash[dir].tuple.src.u.all !=
+		    (ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMP &&
+		     ct->tuplehash[dir].tuple.src.u.all !=
 		     ct->tuplehash[!dir].tuple.dst.u.all))
 			if (nf_xfrm_me_harder(skb, AF_INET) < 0)
 				ret = NF_DROP;
@@ -221,6 +222,7 @@ nf_nat_ipv4_local_fn(unsigned int hooknum,
 		}
 #ifdef CONFIG_XFRM
 		else if (!(IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED) &&
+			 ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMP &&
 			 ct->tuplehash[dir].tuple.dst.u.all !=
 			 ct->tuplehash[!dir].tuple.src.u.all)
 			if (nf_xfrm_me_harder(skb, AF_INET) < 0)
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index e418bd6..d57dab1 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -186,7 +186,8 @@ nf_nat_ipv6_out(unsigned int hooknum,
 
 		if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.src.u3,
 				      &ct->tuplehash[!dir].tuple.dst.u3) ||
-		    (ct->tuplehash[dir].tuple.src.u.all !=
+		    (ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMPV6 &&
+		     ct->tuplehash[dir].tuple.src.u.all !=
 		     ct->tuplehash[!dir].tuple.dst.u.all))
 			if (nf_xfrm_me_harder(skb, AF_INET6) < 0)
 				ret = NF_DROP;
@@ -222,6 +223,7 @@ nf_nat_ipv6_local_fn(unsigned int hooknum,
 		}
 #ifdef CONFIG_XFRM
 		else if (!(IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED) &&
+			 ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMPV6 &&
 			 ct->tuplehash[dir].tuple.dst.u.all !=
 			 ct->tuplehash[!dir].tuple.src.u.all)
 			if (nf_xfrm_me_harder(skb, AF_INET6))
-- 
1.7.9.5

