From: Sergey Popovich <popovich_sergei@mail.ru>
Subject: [PATCH 2/2] netnet,netportnet: Fix value range support for IPv4
Date: Mon,  5 May 2014 11:07:06 +0300
Message-ID: <013ebb6b972846e27933e99c2d016492c58564a6.1399275196.git.popovich_sergei@mail.ru>
References: <cover.1399275196.git.popovich_sergei@mail.ru>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.176.18]:41858 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaEEIHh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 04:07:37 -0400
Received: from smtp4.mail.ru (smtp4.mail.ru [94.100.176.44])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id 1A2D0380EA59
	for <netfilter-devel@vger.kernel.org>; Mon,  5 May 2014 12:07:35 +0400 (MSK)
Received: from [195.234.68.4] (port=40497 helo=tuxracer.skif.com.ua)
	by smtp4.mail.ru with esmtpa (envelope-from <popovich_sergei@mail.ru>)
	id 1WhDvd-0003Yx-Lj
	for netfilter-devel@vger.kernel.org; Mon, 05 May 2014 12:07:13 +0400
In-Reply-To: <cover.1399275196.git.popovich_sergei@mail.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ranges of values are broken with hash:net,net and hash:net,port,net.

hash:net,net
============

   # ipset create test-nn hash:net,net
   # ipset add test-nn 10.0.10.1-10.0.10.127,10.0.0.0/8

   # ipset list test-nn
   Name: test-nn
   Type: hash:net,net
   Revision: 0
   Header: family inet hashsize 1024 maxelem 65536
   Size in memory: 16960
   References: 0
   Members:
   10.0.10.1,10.0.0.0/8

   # ipset test test-nn 10.0.10.65,10.0.0.1
   10.0.10.65,10.0.0.1 is NOT in set test-nn.
   # ipset test test-nn 10.0.10.1,10.0.0.1
   10.0.10.1,10.0.0.1 is in set test-nn.

hash:net,port,net
=================

   # ipset create test-npn hash:net,port,net
   # ipset add test-npn 10.0.10.1-10.0.10.127,tcp:80,10.0.0.0/8
   # ipset list test-npn
   Name: test-npn
   Type: hash:net,port,net
   Revision: 0
   Header: family inet hashsize 1024 maxelem 65536
   Size in memory: 17344
   References: 0
   Members:
   10.0.10.8/29,tcp:80,10.0.0.0
   10.0.10.16/28,tcp:80,10.0.0.0
   10.0.10.2/31,tcp:80,10.0.0.0
   10.0.10.64/26,tcp:80,10.0.0.0
   10.0.10.32/27,tcp:80,10.0.0.0
   10.0.10.4/30,tcp:80,10.0.0.0
   10.0.10.1,tcp:80,10.0.0.0
   # ipset list test-npn
   # ipset test test-npn 10.0.10.126,tcp:80,10.0.0.2
   10.0.10.126,tcp:80,10.0.0.2 is NOT in set test-npn.
   # ipset test test-npn 10.0.10.126,tcp:80,10.0.0.0
   10.0.10.126,tcp:80,10.0.0.0 is in set test-npn.

   # ipset create test-npn hash:net,port,net
   # ipset add test-npn 10.0.10.0/24,tcp:80-81,10.0.0.0/8
   # ipset list test-npn
   Name: test-npn
   Type: hash:net,port,net
   Revision: 0
   Header: family inet hashsize 1024 maxelem 65536
   Size in memory: 17024
   References: 0
   Members:
   10.0.10.0,tcp:80,10.0.0.0
   10.0.10.0,tcp:81,10.0.0.0
   # ipset test test-npn 10.0.10.126,tcp:80,10.0.0.0
   10.0.10.126,tcp:80,10.0.0.0 is NOT in set test-npn.
   # ipset test test-npn 10.0.10.0,tcp:80,10.0.0.0
   10.0.10.0,tcp:80,10.0.0.0 is in set test-npn.

Correctly setup from..to variables where no IPSET_ATTR_IP_TO{,2}
attribute is given, so in range processing loop we construct proper
cidr value. Check whenever we have no ranges and can short cut in
hash:net,net properly. Use unlikely() where appropriate, to comply
with other modules.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
---
 kernel/net/netfilter/ipset/ip_set_hash_netnet.c     |   13 +++++++------
 kernel/net/netfilter/ipset/ip_set_hash_netportnet.c |    6 ++++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netnet.c b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
index 3e99987..96b1313 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -203,7 +203,7 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
 
-	if (adt == IPSET_TEST || !(tb[IPSET_ATTR_IP_TO] &&
+	if (adt == IPSET_TEST || !(tb[IPSET_ATTR_IP_TO] ||
 				   tb[IPSET_ATTR_IP2_TO])) {
 		e.ip[0] = htonl(ip & ip_set_hostmask(e.cidr[0]));
 		e.ip[1] = htonl(ip2_from & ip_set_hostmask(e.cidr[1]));
@@ -219,9 +219,10 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			return ret;
 		if (ip_to < ip)
 			swap(ip, ip_to);
-		if (ip + UINT_MAX == ip_to)
+		if (unlikely(ip + UINT_MAX == ip_to))
 			return -IPSET_ERR_HASH_RANGE;
-	}
+	} else
+		ip_set_mask_from_to(ip, ip_to, e.cidr[0]);
 
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
@@ -230,10 +231,10 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			return ret;
 		if (ip2_to < ip2_from)
 			swap(ip2_from, ip2_to);
-		if (ip2_from + UINT_MAX == ip2_to)
+		if (unlikely(ip2_from + UINT_MAX == ip2_to))
 			return -IPSET_ERR_HASH_RANGE;
-
-	}
+	} else
+		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 
 	if (retried)
 		ip = ntohl(h->next.ip[0]);
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_netportnet.c
index c0d2ba7..2f00343 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -257,7 +257,8 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip, ip_to);
 		if (unlikely(ip + UINT_MAX == ip_to))
 			return -IPSET_ERR_HASH_RANGE;
-	}
+	} else
+		ip_set_mask_from_to(ip, ip_to, e.cidr[0]);
 
 	port_to = port = ntohs(e.port);
 	if (tb[IPSET_ATTR_PORT_TO]) {
@@ -275,7 +276,8 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip2_from, ip2_to);
 		if (unlikely(ip2_from + UINT_MAX == ip2_to))
 			return -IPSET_ERR_HASH_RANGE;
-	}
+	} else
+		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 
 	if (retried)
 		ip = ntohl(h->next.ip[0]);
-- 
1.7.10.4

