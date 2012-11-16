From: pablo@netfilter.org
Subject: [PATCH 3/3] [-stable] netfilter: nf_nat: don't check for port change on ICMP tuples
Date: Fri, 16 Nov 2012 15:00:14 +0100
Message-ID: <1353074415-21379-4-git-send-email-pablo@netfilter.org>
References: <1353074415-21379-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36222 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab2KPOAh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:00:37 -0500
In-Reply-To: <1353074415-21379-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ulrich Weber <ulrich.weber@sophos.com>

ICMP tuples have id in src and type/code in dst.
So comparing src.u.all with dst.u.all will always fail here
and ip_xfrm_me_harder() is called for every ICMP packet,
even if there was no NAT.

This patch is a backport of:

[ 38fe36a netfilter: nf_nat: don't check for port change on ICMP tuples ]

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_standalone.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 483b76d..b2c3ed7 100644
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
1.7.10.4

