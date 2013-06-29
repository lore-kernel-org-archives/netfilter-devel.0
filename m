From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v3 3/5] ipset: add set match "inner" flag support
Date: Sat, 29 Jun 2013 22:32:50 +0100
Message-ID: <51CF5282.8060604@googlemail.com>
References: <cover.1372540515.git.mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:33581 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3F2Vc6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 17:32:58 -0400
Received: by mail-we0-f178.google.com with SMTP id u53so2194563wes.23
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jun 2013 14:32:57 -0700 (PDT)
In-Reply-To: <cover.1372540515.git.mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements "inner" flag support to all registered ipset types.

Revision history:

v1 * initial revision
v2 * redundant code removed;
    * use the new ipv[46]addr[ptr] and ip_set_get*port functions;
v3 * revert to the old ip[46]addrptr and ip_set_get_ip[46]_port
      function names;

Signed-off-by: Dash Four <mr.dash.four@googlemail.com>
---
  kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      |  7 ++++++-
  kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   |  7 ++++++-
  kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |  1 +
  kernel/net/netfilter/ipset/ip_set_hash_ip.c        | 10 ++++++++--
  kernel/net/netfilter/ipset/ip_set_hash_ipport.c    | 16 ++++++++++------
  kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  | 22 ++++++++++++++--------
  kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c | 22 ++++++++++++++--------
  kernel/net/netfilter/ipset/ip_set_hash_net.c       |  8 ++++++--
  kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |  8 ++++++--
  kernel/net/netfilter/ipset/ip_set_hash_netport.c   | 17 ++++++++++-------
  10 files changed, 81 insertions(+), 37 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
index ce99d26..aba3e81 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -115,8 +115,13 @@ bitmap_ip_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct bitmap_ip_adt_elem e = { };
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, map);
  	u32 ip;
+	__be32 _ip;

-	ip = ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
+	if (!ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &_ip))
+		return -EINVAL;
+
+	ip = ntohl(_ip);
  	if (ip < map->first_ip || ip > map->last_ip)
  		return -IPSET_ERR_BITMAP_RANGE;

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 6d5bad9..fb396b9 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -218,12 +218,17 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct bitmap_ipmac_adt_elem e = {};
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, map);
  	u32 ip;
+	__be32 _ip;

  	/* MAC can be src only */
  	if (!(opt->flags & IPSET_DIM_TWO_SRC))
  		return 0;

-	ip = ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
+	if (!ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &_ip))
+		return -EINVAL;
+
+	ip = ntohl(_ip);
  	if (ip < map->first_ip || ip > map->last_ip)
  		return -IPSET_ERR_BITMAP_RANGE;

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
index b220489..4cef9a3 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -111,6 +111,7 @@ bitmap_port_kadt(struct ip_set *set, const struct sk_buff *skb,
  	u16 port = 0;

  	if (!ip_set_get_ip_port(skb, opt->family,
+				opt->cmdflags & IPSET_FLAG_INNER,
  				opt->flags & IPSET_DIM_ONE_SRC, &__port))
  		return -EINVAL;

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ip.c b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
index 260c9a8..c8b07ed 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
@@ -102,7 +102,10 @@ hash_ip4_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
  	__be32 ip;

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &ip);
+	if (!ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &ip))
+		return -EINVAL;
+
  	ip &= ip_set_netmask(h->netmask);
  	if (ip == 0)
  		return -EINVAL;
@@ -255,7 +258,10 @@ hash_ip6_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct hash_ip6_elem e = {};
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);

-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	if (!ip6addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6))
+		return -EINVAL;
+
  	hash_ip6_netmask(&e.ip, h->netmask);
  	if (ipv6_addr_any(&e.ip.in6))
  		return -EINVAL;
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
index 64caad3..10501e8 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -121,11 +121,13 @@ hash_ipport4_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct hash_ipport4_elem e = { };
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);

-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
+	if (!ip_set_get_ip4_port(skb, opt->cmdflags & IPSET_FLAG_INNER,
+				 opt->flags & IPSET_DIM_TWO_SRC, &e.port,
+				 &e.proto) ||
+	    !ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip))
  		return -EINVAL;

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
  }

@@ -311,11 +313,13 @@ hash_ipport6_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct hash_ipport6_elem e = { };
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);

-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
+	if (!ip_set_get_ip6_port(skb, opt->cmdflags & IPSET_FLAG_INNER,
+				 opt->flags & IPSET_DIM_TWO_SRC, &e.port,
+				 &e.proto) ||
+	    !ip6addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6))
  		return -EINVAL;

-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
  }

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
index 2873bbc..5a0a62d 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -125,12 +125,15 @@ hash_ipportip4_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct hash_ipportip4_elem e = { };
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);

-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
+	if (!ip_set_get_ip4_port(skb, opt->cmdflags & IPSET_FLAG_INNER,
+				 opt->flags & IPSET_DIM_TWO_SRC, &e.port,
+				 &e.proto) ||
+	    !ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip) ||
+	    !ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_THREE_SRC, &e.ip2))
  		return -EINVAL;

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
-	ip4addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2);
  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
  }

@@ -324,12 +327,15 @@ hash_ipportip6_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct hash_ipportip6_elem e = { };
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);

-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
+	if (!ip_set_get_ip6_port(skb, opt->cmdflags & IPSET_FLAG_INNER,
+				 opt->flags & IPSET_DIM_TWO_SRC, &e.port,
+				 &e.proto) ||
+	    !ip6addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6) ||
+	    !ip6addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_THREE_SRC, &e.ip2.in6))
  		return -EINVAL;

-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	ip6addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2.in6);
  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
  }

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
index db0e761..eed52ed 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -177,12 +177,15 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK - 1;

-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
+	if (!ip_set_get_ip4_port(skb, opt->cmdflags & IPSET_FLAG_INNER,
+				 opt->flags & IPSET_DIM_TWO_SRC, &e.port,
+				 &e.proto) ||
+	    !ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip) ||
+	    !ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_THREE_SRC, &e.ip2))
  		return -EINVAL;

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
-	ip4addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2);
  	e.ip2 &= ip_set_netmask(e.cidr + 1);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
@@ -461,12 +464,15 @@ hash_ipportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK - 1;

-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
+	if (!ip_set_get_ip6_port(skb, opt->cmdflags & IPSET_FLAG_INNER,
+				 opt->flags & IPSET_DIM_TWO_SRC, &e.port,
+				 &e.proto) ||
+	    !ip6addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6) ||
+	    !ip6addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_THREE_SRC, &e.ip2.in6))
  		return -EINVAL;

-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	ip6addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2.in6);
  	ip6_netmask(&e.ip2, e.cidr + 1);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_net.c b/kernel/net/netfilter/ipset/ip_set_hash_net.c
index 846ec80..bc6f724 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_net.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_net.c
@@ -151,8 +151,10 @@ hash_net4_kadt(struct ip_set *set, const struct sk_buff *skb,
  		return -EINVAL;
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK;
+	if (!ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip))
+		return -EINVAL;

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
  	e.ip &= ip_set_netmask(e.cidr);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
@@ -346,8 +348,10 @@ hash_net6_kadt(struct ip_set *set, const struct sk_buff *skb,
  		return -EINVAL;
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK;
+	if (!ip6addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6))
+		return -EINVAL;

-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
  	ip6_netmask(&e.ip, e.cidr);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
index 8f0e496..d046955 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -275,8 +275,10 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
  		return -EINVAL;
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK;
+	if (!ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip))
+		return -EINVAL;

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
  	e.ip &= ip_set_netmask(e.cidr);

  #define IFACE(dir)	(par->dir ? par->dir->name : NULL)
@@ -544,8 +546,10 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
  		return -EINVAL;
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK;
+	if (!ip6addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6))
+		return -EINVAL;

-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
  	ip6_netmask(&e.ip, e.cidr);

  	if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netport.c b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
index 021d716..fcba938 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
@@ -169,11 +169,13 @@ hash_netport4_kadt(struct ip_set *set, const struct sk_buff *skb,
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK - 1;

-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
+	if (!ip_set_get_ip4_port(skb, opt->cmdflags & IPSET_FLAG_INNER,
+				 opt->flags & IPSET_DIM_TWO_SRC, &e.port,
+				 &e.proto) ||
+	    !ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip))
  		return -EINVAL;

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
  	e.ip &= ip_set_netmask(e.cidr + 1);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
@@ -413,12 +415,13 @@ hash_netport6_kadt(struct ip_set *set, const struct sk_buff *skb,

  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK - 1;
-
-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
+	if (!ip_set_get_ip6_port(skb, opt->cmdflags & IPSET_FLAG_INNER,
+				 opt->flags & IPSET_DIM_TWO_SRC, &e.port,
+				 &e.proto) ||
+	    !ip6addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6))
  		return -EINVAL;

-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
  	ip6_netmask(&e.ip, e.cidr + 1);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);

