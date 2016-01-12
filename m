From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] ipset: allow a 0 netmask with hash_netiface type
Date: Tue, 12 Jan 2016 17:07:05 +0100
Message-ID: <1452614825-19749-1-git-send-email-fw@strlen.de>
Cc: kadlec@blackhole.kfki.hu, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58029 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbcALQHv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 11:07:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef says:
 The correct behaviour is that if we have
 ipset create test1 hash:net,iface
 ipset add test1 0.0.0.0/0,eth0
 iptables -A INPUT -m set --match-set test1 src,src

 then the rule should match for any traffic coming in through eth0.

This removes the -EINVAL runtime test to make matching work
in case packet arrived via the specified interface.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1297092
Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 43d8c98..f0f688d 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -164,8 +164,6 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	if (e.cidr == 0)
-		return -EINVAL;
 	if (adt == IPSET_TEST)
 		e.cidr = HOST_MASK;
 
@@ -377,8 +375,6 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	if (e.cidr == 0)
-		return -EINVAL;
 	if (adt == IPSET_TEST)
 		e.cidr = HOST_MASK;
 
-- 
2.4.10

