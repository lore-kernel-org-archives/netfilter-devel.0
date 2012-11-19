From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] netfilter: ipset: Fix range bug in hash:ip,port,net
Date: Mon, 19 Nov 2012 17:42:21 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211191550450.22583@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:52945 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab2KSQmX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:42:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider applying the next patch for the stable nf tree.
You can also pull the patch from here:

	git://blackhole.kfki.hu/nf master

Due to the missing ininitalization at adding/deleting entries, when
a plain_ip,port,net element was the object, multiple elements were
added/deleted instead. The bug came from the missing dangling
default initialization.

The error-prone default initialization is corrected in all hash:* types.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_ip.c        |    4 ++--
 net/netfilter/ipset/ip_set_hash_ipport.c    |    7 +++----
 net/netfilter/ipset/ip_set_hash_ipportip.c  |    7 +++----
 net/netfilter/ipset/ip_set_hash_ipportnet.c |    7 +++++--
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index ec3dba5..5c0b785 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -173,6 +173,7 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		return adtfn(set, &nip, timeout, flags);
 	}
 
+	ip_to = ip;
 	if (tb[IPSET_ATTR_IP_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
@@ -185,8 +186,7 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (!cidr || cidr > 32)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(ip, ip_to, cidr);
-	} else
-		ip_to = ip;
+	}
 
 	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 0171f75..6283351 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -162,7 +162,7 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport4_elem data = { };
-	u32 ip, ip_to = 0, p = 0, port, port_to;
+	u32 ip, ip_to, p = 0, port, port_to;
 	u32 timeout = h->timeout;
 	bool with_ports = false;
 	int ret;
@@ -210,7 +210,7 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ip_set_eexist(ret, flags) ? 0 : ret;
 	}
 
-	ip = ntohl(data.ip);
+	ip_to = ip = ntohl(data.ip);
 	if (tb[IPSET_ATTR_IP_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
@@ -223,8 +223,7 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (!cidr || cidr > 32)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(ip, ip_to, cidr);
-	} else
-		ip_to = ip;
+	}
 
 	port_to = port = ntohs(data.port);
 	if (with_ports && tb[IPSET_ATTR_PORT_TO]) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 6344ef5..6a21271 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -166,7 +166,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportip4_elem data = { };
-	u32 ip, ip_to = 0, p = 0, port, port_to;
+	u32 ip, ip_to, p = 0, port, port_to;
 	u32 timeout = h->timeout;
 	bool with_ports = false;
 	int ret;
@@ -218,7 +218,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ip_set_eexist(ret, flags) ? 0 : ret;
 	}
 
-	ip = ntohl(data.ip);
+	ip_to = ip = ntohl(data.ip);
 	if (tb[IPSET_ATTR_IP_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
@@ -231,8 +231,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (!cidr || cidr > 32)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(ip, ip_to, cidr);
-	} else
-		ip_to = ip;
+	}
 
 	port_to = port = ntohs(data.port);
 	if (with_ports && tb[IPSET_ATTR_PORT_TO]) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index cb71f9a..2d5cd4e 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -215,8 +215,8 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet4_elem data = { .cidr = HOST_MASK - 1 };
-	u32 ip, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to, ip2_last, ip2;
+	u32 ip, ip_to, p = 0, port, port_to;
+	u32 ip2_from, ip2_to, ip2_last, ip2;
 	u32 timeout = h->timeout;
 	bool with_ports = false;
 	u8 cidr;
@@ -286,6 +286,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ip_set_eexist(ret, flags) ? 0 : ret;
 	}
 
+	ip_to = ip;
 	if (tb[IPSET_ATTR_IP_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
@@ -306,6 +307,8 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (port > port_to)
 			swap(port, port_to);
 	}
+
+	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
 		if (ret)
-- 
1.7.0.4


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
