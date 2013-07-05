From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v4 1/2] ipset (kernel): add set match "inner" flag support
Date: Fri, 05 Jul 2013 23:23:57 +0100
Message-ID: <51D7477D.5090506@googlemail.com>
References: <cover.1373061728.git.mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:59756 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3GEWYI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:24:08 -0400
Received: by mail-we0-f177.google.com with SMTP id m19so2302273wev.36
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2013 15:24:06 -0700 (PDT)
In-Reply-To: <cover.1373061728.git.mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements "inner" flag support to all registered ipset types.

Revision history:

v1 * initial revision
v2 * redundant code removed;
    * use the new ipv[46]addr[ptr] and ip_set_get*port functions;
v3 * revert to the old ip[46]addrptr and ip_set_get_ip[46]_port
      function names;
v4 * add inner flag version support on all ipsets;

Signed-off-by: Dash Four <mr.dash.four@googlemail.com>
---
  kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      | 10 ++++++--
  kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   | 10 ++++++--
  kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |  4 ++-
  kernel/net/netfilter/ipset/ip_set_hash_ip.c        | 13 +++++++---
  kernel/net/netfilter/ipset/ip_set_hash_ipport.c    | 19 ++++++++------
  kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  | 25 ++++++++++++-------
  kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c | 29 ++++++++++++++--------
  kernel/net/netfilter/ipset/ip_set_hash_net.c       | 13 +++++++---
  kernel/net/netfilter/ipset/ip_set_hash_netiface.c  | 13 +++++++---
  kernel/net/netfilter/ipset/ip_set_hash_netport.c   | 24 ++++++++++--------
  10 files changed, 107 insertions(+), 53 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
index ce99d26..0c1b808 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -26,7 +26,8 @@
  #include <linux/netfilter/ipset/ip_set_bitmap.h>

  #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counter support added */
+/*				1	   Counter support added    */
+#define IPSET_TYPE_REV_MAX	2	/* Inner flag support added */

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -115,8 +116,13 @@ bitmap_ip_kadt(struct ip_set *set, const struct sk_buff *skb,
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
index 6d5bad9..68ee7dd 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -26,7 +26,8 @@
  #include <linux/netfilter/ipset/ip_set_bitmap.h>

  #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counter support added */
+/*				1	   Counter support added    */
+#define IPSET_TYPE_REV_MAX	2	/* Inner flag support added */

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -218,12 +219,17 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
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
index b220489..ec1f6eb 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -21,7 +21,8 @@
  #include <linux/netfilter/ipset/ip_set_getport.h>

  #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counter support added */
+/*				1	   Counter support added    */
+#define IPSET_TYPE_REV_MAX	2	/* Inner flag support added */

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -111,6 +112,7 @@ bitmap_port_kadt(struct ip_set *set, const struct sk_buff *skb,
  	u16 port = 0;

  	if (!ip_set_get_ip_port(skb, opt->family,
+				opt->cmdflags & IPSET_FLAG_INNER,
  				opt->flags & IPSET_DIM_ONE_SRC, &__port))
  		return -EINVAL;

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ip.c b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
index 260c9a8..84eacf6 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
@@ -24,7 +24,8 @@
  #include <linux/netfilter/ipset/ip_set_hash.h>

  #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counters support */
+/*				1	   Counter support added    */
+#define IPSET_TYPE_REV_MAX	2	/* Inner flag support added */

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -102,7 +103,10 @@ hash_ip4_kadt(struct ip_set *set, const struct sk_buff *skb,
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
@@ -255,7 +259,10 @@ hash_ip6_kadt(struct ip_set *set, const struct sk_buff *skb,
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
index 64caad3..f5fe62a 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -26,7 +26,8 @@

  #define IPSET_TYPE_REV_MIN	0
  /*				1    SCTP and UDPLITE support added */
-#define IPSET_TYPE_REV_MAX	2 /* Counters support added */
+/*				2    Counter support added    	    */
+#define IPSET_TYPE_REV_MAX	3 /* Inner flag support added 	    */

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -121,11 +122,13 @@ hash_ipport4_kadt(struct ip_set *set, const struct sk_buff *skb,
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

@@ -311,11 +314,13 @@ hash_ipport6_kadt(struct ip_set *set, const struct sk_buff *skb,
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
index 2873bbc..250376e 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -26,7 +26,8 @@

  #define IPSET_TYPE_REV_MIN	0
  /*				1    SCTP and UDPLITE support added */
-#define IPSET_TYPE_REV_MAX	2 /* Counters support added */
+/*				2    Counter support added	    */
+#define IPSET_TYPE_REV_MAX	3 /* Inner flag support added	    */

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -125,12 +126,15 @@ hash_ipportip4_kadt(struct ip_set *set, const struct sk_buff *skb,
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

@@ -324,12 +328,15 @@ hash_ipportip6_kadt(struct ip_set *set, const struct sk_buff *skb,
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
index db0e761..43c4ca8 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -25,10 +25,11 @@
  #include <linux/netfilter/ipset/ip_set_hash.h>

  #define IPSET_TYPE_REV_MIN	0
-/*				1    SCTP and UDPLITE support added */
+/*				1    SCTP and UDPLITE support added	   */
  /*				2    Range as input support for IPv4 added */
-/*				3    nomatch flag support added */
-#define IPSET_TYPE_REV_MAX	4 /* Counters support added */
+/*				3    nomatch flag support added		   */
+/*				4    Counter support added		   */
+#define IPSET_TYPE_REV_MAX	5 /* Inner flag support added		   */

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -177,12 +178,15 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
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
@@ -461,12 +465,15 @@ hash_ipportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
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
index 846ec80..82a0c76 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_net.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_net.c
@@ -24,8 +24,9 @@

  #define IPSET_TYPE_REV_MIN	0
  /*				1    Range as input support for IPv4 added */
-/*				2    nomatch flag support added */
-#define IPSET_TYPE_REV_MAX	3 /* Counters support added */
+/*				2    nomatch flag support added		   */
+/*				3    Counter support added    		   */
+#define IPSET_TYPE_REV_MAX	4 /* Inner flag support added 		   */

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -151,8 +152,10 @@ hash_net4_kadt(struct ip_set *set, const struct sk_buff *skb,
  		return -EINVAL;
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK;
+	if (!ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip))
+		return -EINVAL;

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
  	e.ip &= ip_set_netmask(e.cidr);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
@@ -346,8 +349,10 @@ hash_net6_kadt(struct ip_set *set, const struct sk_buff *skb,
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
index 8f0e496..a8c1103 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -25,8 +25,9 @@

  #define IPSET_TYPE_REV_MIN	0
  /*				1    nomatch flag support added */
-/*				2    /0 support added */
-#define IPSET_TYPE_REV_MAX	3 /* Counters support added */
+/*				2    /0 support added		*/
+/*				3    Counter support added	*/
+#define IPSET_TYPE_REV_MAX	4 /* Inner flag support added	*/

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -275,8 +276,10 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
  		return -EINVAL;
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK;
+	if (!ip4addrptr(skb, opt->cmdflags & IPSET_FLAG_INNER,
+			opt->flags & IPSET_DIM_ONE_SRC, &e.ip))
+		return -EINVAL;

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
  	e.ip &= ip_set_netmask(e.cidr);

  #define IFACE(dir)	(par->dir ? par->dir->name : NULL)
@@ -544,8 +547,10 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
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
index 021d716..beb3d2f 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
@@ -24,10 +24,11 @@
  #include <linux/netfilter/ipset/ip_set_hash.h>

  #define IPSET_TYPE_REV_MIN	0
-/*				1    SCTP and UDPLITE support added */
+/*				1    SCTP and UDPLITE support added	   */
  /*				2    Range as input support for IPv4 added */
-/*				3    nomatch flag support added */
-#define IPSET_TYPE_REV_MAX	4 /* Counters support added */
+/*				3    nomatch flag support added		   */
+/*				4    Counter support added		   */
+#define IPSET_TYPE_REV_MAX	5 /* Inner flag support added		   */

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -169,11 +170,13 @@ hash_netport4_kadt(struct ip_set *set, const struct sk_buff *skb,
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
@@ -413,12 +416,13 @@ hash_netport6_kadt(struct ip_set *set, const struct sk_buff *skb,

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
