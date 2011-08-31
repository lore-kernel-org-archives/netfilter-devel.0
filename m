From: Ulrich Weber <ulrich.weber@sophos.com>
Subject: [PATCH] nf_nat: dont check for port change on ICMP tuples
Date: Wed, 31 Aug 2011 14:13:52 +0200
Message-ID: <20110831121352.GA7966@WS-uweber>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-18.dex002.intermedia.net ([64.78.21.84]:8192 "EHLO
	dhost002-18.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755302Ab1HaMUN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:20:13 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ICMP tuples have id in src and type/code in dst.
So comparing src.u.all with dst.u.all will always fail here
and ip_xfrm_me_harder() is called for every ICMP packet,
even if there was no NAT...

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
---
 net/ipv4/netfilter/nf_nat_standalone.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 9290048..e32b542 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -194,7 +194,8 @@ nf_nat_out(unsigned int hooknum,
 
 		if ((ct->tuplehash[dir].tuple.src.u3.ip !=
 		     ct->tuplehash[!dir].tuple.dst.u3.ip) ||
-		    (ct->tuplehash[dir].tuple.src.u.all !=
+		    (ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMP &&
+		     ct->tuplehash[dir].tuple.src.u.all !=
 		     ct->tuplehash[!dir].tuple.dst.u.all)
 		   )
 			return ip_xfrm_me_harder(skb) == 0 ? ret : NF_DROP;
@@ -230,7 +231,8 @@ nf_nat_local_fn(unsigned int hooknum,
 				ret = NF_DROP;
 		}
 #ifdef CONFIG_XFRM
-		else if (ct->tuplehash[dir].tuple.dst.u.all !=
+		else if (ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMP &&
+			 ct->tuplehash[dir].tuple.dst.u.all !=
 			 ct->tuplehash[!dir].tuple.src.u.all)
 			if (ip_xfrm_me_harder(skb))
 				ret = NF_DROP;
-- 
1.7.4.1

