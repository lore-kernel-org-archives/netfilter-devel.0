From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 24/34] netfilter: ipset: Make sure we always return line number on batch
Date: Sat,  2 May 2015 19:28:13 +0200
Message-ID: <1430587703-3387-25-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:37003 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbbEBR2L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:11 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

Even if we return with generic IPSET_ERR_PROTOCOL it is good idea
to return line number if we called in batch mode.

Moreover we are not always exiting with IPSET_ERR_PROTOCOL. For
example hash:ip,port,net may return IPSET_ERR_HASH_RANGE_UNSUPPORTED
or IPSET_ERR_INVALID_CIDR.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c       |  6 +++---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |  6 +++---
 net/netfilter/ipset/ip_set_bitmap_port.c     |  6 +++---
 net/netfilter/ipset/ip_set_hash_ip.c         | 12 ++++++------
 net/netfilter/ipset/ip_set_hash_ipmark.c     | 12 ++++++------
 net/netfilter/ipset/ip_set_hash_ipport.c     | 12 ++++++------
 net/netfilter/ipset/ip_set_hash_ipportip.c   | 12 ++++++------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  | 12 ++++++------
 net/netfilter/ipset/ip_set_hash_mac.c        |  6 +++---
 net/netfilter/ipset/ip_set_hash_net.c        | 12 ++++++------
 net/netfilter/ipset/ip_set_hash_netiface.c   | 12 ++++++------
 net/netfilter/ipset/ip_set_hash_netnet.c     | 12 ++++++------
 net/netfilter/ipset/ip_set_hash_netport.c    | 12 ++++++------
 net/netfilter/ipset/ip_set_hash_netportnet.c | 12 ++++++------
 net/netfilter/ipset/ip_set_list_set.c        |  6 +++---
 15 files changed, 75 insertions(+), 75 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 48cd80f..4ddde53 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -138,12 +138,12 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret = 0;
 
-	if (unlikely(!tb[IPSET_ATTR_IP]))
-		return -IPSET_ERR_PROTOCOL;
-
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
+	if (unlikely(!tb[IPSET_ATTR_IP]))
+		return -IPSET_ERR_PROTOCOL;
+
 	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 2e8826a..e1899fe 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -247,12 +247,12 @@ bitmap_ipmac_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip = 0;
 	int ret = 0;
 
-	if (unlikely(!tb[IPSET_ATTR_IP]))
-		return -IPSET_ERR_PROTOCOL;
-
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
+	if (unlikely(!tb[IPSET_ATTR_IP]))
+		return -IPSET_ERR_PROTOCOL;
+
 	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index d61a9f7..4d79d84 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -136,13 +136,13 @@ bitmap_port_uadt(struct ip_set *set, struct nlattr *tb[],
 	u16 port_to;
 	int ret = 0;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	port = ip_set_get_h16(tb[IPSET_ATTR_PORT]);
 	if (port < map->first_port || port > map->last_port)
 		return -IPSET_ERR_BITMAP_RANGE;
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 6f6005b..9b591e3 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -108,12 +108,12 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip = 0, ip_to = 0, hosts;
 	int ret = 0;
 
-	if (unlikely(!tb[IPSET_ATTR_IP]))
-		return -IPSET_ERR_PROTOCOL;
-
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
+	if (unlikely(!tb[IPSET_ATTR_IP]))
+		return -IPSET_ERR_PROTOCOL;
+
 	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
 	if (ret)
 		return ret;
@@ -241,6 +241,9 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP]))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(tb[IPSET_ATTR_IP_TO]))
@@ -251,9 +254,6 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[],
 			return -IPSET_ERR_INVALID_CIDR;
 	}
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index ebb1c47..0fce8ab 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -109,13 +109,13 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip, ip_to = 0;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_MARK)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip);
 	if (ret)
 		return ret;
@@ -237,6 +237,9 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_MARK)))
 		return -IPSET_ERR_PROTOCOL;
@@ -248,9 +251,6 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 			return -IPSET_ERR_INVALID_CIDR;
 	}
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 2a4222b..76de70a 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -117,14 +117,14 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	bool with_ports = false;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip);
 	if (ret)
 		return ret;
@@ -276,6 +276,9 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	bool with_ports = false;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO)))
@@ -288,9 +291,6 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 			return -IPSET_ERR_INVALID_CIDR;
 	}
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index f9f124b..5c57bdd 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -119,14 +119,14 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	bool with_ports = false;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip);
 	if (ret)
 		return ret;
@@ -284,6 +284,9 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	bool with_ports = false;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO)))
@@ -296,9 +299,6 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 			return -IPSET_ERR_INVALID_CIDR;
 	}
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index eea1e80..a10f44b 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -173,15 +173,15 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u8 cidr;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
 	if (ret)
 		return ret;
@@ -420,6 +420,9 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	u8 cidr;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
@@ -433,9 +436,6 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 			return -IPSET_ERR_INVALID_CIDR;
 	}
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 3b4f579..ad7308b 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -102,12 +102,12 @@ hash_mac4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
-	if (unlikely(!tb[IPSET_ATTR_ETHER]))
-		return -IPSET_ERR_PROTOCOL;
-
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
+	if (unlikely(!tb[IPSET_ATTR_ETHER]))
+		return -IPSET_ERR_PROTOCOL;
+
 	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 16ddce3..db39b5d 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -146,13 +146,13 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip = 0, ip_to = 0, last;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
 	if (ret)
 		return ret;
@@ -312,15 +312,15 @@ hash_net6_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(tb[IPSET_ATTR_IP_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index b885476..d051e2a 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -205,14 +205,14 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip = 0, ip_to = 0, last;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !tb[IPSET_ATTR_IFACE] ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
 	if (ret)
 		return ret;
@@ -413,6 +413,9 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !tb[IPSET_ATTR_IFACE] ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
@@ -420,9 +423,6 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(tb[IPSET_ATTR_IP_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 10da0b6..1cf93be 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -167,14 +167,14 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u8 cidr, cidr2;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	e.cidr[0] = e.cidr[1] = HOST_MASK;
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
 	if (ret)
 		return ret;
@@ -392,6 +392,9 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	e.cidr[0] = e.cidr[1] = HOST_MASK;
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
@@ -399,9 +402,6 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_IP2_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip[0]);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 38bf122..86372bc 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -166,15 +166,15 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u8 cidr;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
 	if (ret)
 		return ret;
@@ -378,6 +378,9 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	u8 cidr;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
@@ -386,9 +389,6 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(tb[IPSET_ATTR_IP_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 0ff0ae9..c74ac7e 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -183,6 +183,9 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u8 cidr, cidr2;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	e.cidr[0] = e.cidr[1] = HOST_MASK;
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
@@ -190,9 +193,6 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
 	if (ret)
 		return ret;
@@ -453,6 +453,9 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	bool with_ports = false;
 	int ret;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	e.cidr[0] = e.cidr[1] = HOST_MASK;
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
@@ -462,9 +465,6 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_IP2_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip[0]);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 898c197..8745995 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -357,13 +357,13 @@ list_set_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set *s;
 	int ret = 0;
 
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
 	if (unlikely(!tb[IPSET_ATTR_NAME] ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
-		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-
 	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
-- 
1.8.5.1

