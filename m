From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 22/34] netfilter: ipset: Use HOST_MASK literal to represent host address CIDR len
Date: Sat,  2 May 2015 19:28:11 +0200
Message-ID: <1430587703-3387-23-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:36991 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbbEBR2J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:09 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c      | 7 ++++---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c   | 3 ++-
 net/netfilter/ipset/ip_set_hash_ip.c        | 2 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c    | 2 +-
 net/netfilter/ipset/ip_set_hash_ipport.c    | 2 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c  | 2 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c | 2 +-
 7 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index a080516..48cd80f 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -36,6 +36,7 @@ IP_SET_MODULE_DESC("bitmap:ip", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
 MODULE_ALIAS("ip_set_bitmap:ip");
 
 #define MTYPE		bitmap_ip
+#define HOST_MASK	32
 
 /* Type structure */
 struct bitmap_ip {
@@ -171,7 +172,7 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
-		if (!cidr || cidr > 32)
+		if (!cidr || cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	} else
@@ -274,7 +275,7 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
-		if (cidr >= 32)
+		if (cidr >= HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(first_ip, last_ip, cidr);
 	} else
@@ -283,7 +284,7 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_NETMASK]) {
 		netmask = nla_get_u8(tb[IPSET_ATTR_NETMASK]);
 
-		if (netmask > 32)
+		if (netmask > HOST_MASK)
 			return -IPSET_ERR_INVALID_NETMASK;
 
 		first_ip &= ip_set_hostmask(netmask);
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 5c3bb34..2e8826a 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -36,6 +36,7 @@ IP_SET_MODULE_DESC("bitmap:ip,mac", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
 MODULE_ALIAS("ip_set_bitmap:ip,mac");
 
 #define MTYPE		bitmap_ipmac
+#define HOST_MASK	32
 #define IP_SET_BITMAP_STORED_TIMEOUT
 
 enum {
@@ -348,7 +349,7 @@ bitmap_ipmac_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
-		if (cidr >= 32)
+		if (cidr >= HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(first_ip, last_ip, cidr);
 	} else
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 3ad61fe..6916097 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -141,7 +141,7 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
-		if (!cidr || cidr > 32)
+		if (!cidr || cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 0bf56aa..0095df2 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -143,7 +143,7 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
-		if (!cidr || cidr > 32)
+		if (!cidr || cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 254a629..0a0d55f 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -164,7 +164,7 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
-		if (!cidr || cidr > 32)
+		if (!cidr || cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index e323b95..52bd8e8 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -170,7 +170,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
-		if (!cidr || cidr > 32)
+		if (!cidr || cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 37dad02..f895339 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -242,7 +242,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
-		if (!cidr || cidr > 32)
+		if (!cidr || cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
-- 
1.8.5.1

