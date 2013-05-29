From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 2/4] ipset: add "inner" flag implementation
Date: Wed, 29 May 2013 01:13:32 +0100
Message-ID: <51A5482C.9020603@googlemail.com>
References: <51A54267.8050402-git-send-email-mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52947 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab3E2ANi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 20:13:38 -0400
Received: by mail-wi0-f176.google.com with SMTP id hr14so3036833wib.9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2013 17:13:36 -0700 (PDT)
In-Reply-To: <51A54267.8050402-git-send-email-mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements "inner" flag option in the set iptables match,
allowing matching based on the properties (source/destination IP address,
protocol, port and so on) of the original (inner) connection in the event
of the following ICMP[v4,v6] messages:

ICMPv4 destination-unreachable (code 3);
ICMPv4 source-quench (code 4);
ICMPv4 time-exceeded (code 11);
ICMPv6 destination-unreachable (code 1);
ICMPv6 packet-too-big (code 2);
ICMPv6 time-exceeded (code 3);

Signed-off-by: Dash Four <mr.dash.four@googlemail.com>
---
  kernel/include/linux/netfilter/ipset/ip_set.h      |  167 +++++++++++++++++++
  .../include/linux/netfilter/ipset/ip_set_getport.h |   16 ++
  kernel/include/uapi/linux/netfilter/ipset/ip_set.h |    2 +
  kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      |    4 +-
  kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   |    4 +-
  kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |   14 +-
  kernel/net/netfilter/ipset/ip_set_getport.c        |  174 ++++++++++++++++++++
  kernel/net/netfilter/ipset/ip_set_hash_ip.c        |   13 +-
  kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |   37 ++++-
  kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |   47 ++++--
  kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |   49 ++++--
  kernel/net/netfilter/ipset/ip_set_hash_net.c       |   15 +-
  kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |   16 +-
  kernel/net/netfilter/ipset/ip_set_hash_netport.c   |   41 +++--
  14 files changed, 542 insertions(+), 57 deletions(-)

diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
index 8499e25..ac29e16 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set.h
@@ -17,6 +17,9 @@
  #include <linux/netfilter/x_tables.h>
  #include <linux/stringify.h>
  #include <linux/vmalloc.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
+#include <net/icmp.h>
  #include <net/netlink.h>
  #include <uapi/linux/netfilter/ipset/ip_set.h>
  #include <linux/netfilter/ipset/ip_set_compat.h>
@@ -373,6 +376,79 @@ ip4addrptr(const struct sk_buff *skb, bool src, __be32 *addr)
  	*addr = src ? ip_hdr(skb)->saddr : ip_hdr(skb)->daddr;
  }

+static inline __be32
+ip4inneraddr(const struct sk_buff *skb, bool src)
+{
+	struct iphdr _iph;
+	struct icmphdr _icmph;
+	u8 type;
+	const struct iphdr *ih;
+	const struct icmphdr *ich;
+	static const size_t len = 8 + sizeof(struct iphdr);
+
+	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
+	if (ih == NULL || ih->protocol != IPPROTO_ICMP ||
+	    ntohs(ih->frag_off) & IP_OFFSET)
+		goto err;
+
+	ich = skb_header_pointer(skb, ih->ihl*4,
+				 sizeof(_icmph), &_icmph);
+	if (ich == NULL ||
+	    (ich->type <= NR_ICMP_TYPES && skb->len - ih->ihl*4 < len))
+		goto err;
+
+	type = ich->type;
+	if (type == ICMP_DEST_UNREACH ||
+	    type == ICMP_SOURCE_QUENCH ||
+	    type == ICMP_TIME_EXCEEDED) {
+		ih = skb_header_pointer(skb, ih->ihl*4 + sizeof(_icmph),
+					sizeof(_iph), &_iph);
+		if (ih == NULL || ntohs(ih->frag_off) & IP_OFFSET)
+			goto err;
+
+		return src ? ih->saddr : ih->daddr;
+	}
+err:
+	return 0;
+}
+
+static inline void
+ip4inneraddrptr(const struct sk_buff *skb, bool src, __be32 *addr)
+{
+	struct iphdr _iph;
+	struct icmphdr _icmph;
+	u8 type;
+	const struct iphdr *ih;
+	const struct icmphdr *ich;
+	static const size_t len = 8 + sizeof(struct iphdr);
+
+	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
+	if (ih == NULL || ntohs(ih->frag_off) & IP_OFFSET ||
+	    ih->protocol != IPPROTO_ICMP)
+		goto err;
+
+	ich = skb_header_pointer(skb, ih->ihl*4,
+				 sizeof(_icmph), &_icmph);
+	if (ich == NULL ||
+	    (ich->type <= NR_ICMP_TYPES && skb->len - ih->ihl*4 < len))
+		goto err;
+
+	type = ich->type;
+	if (type == ICMP_DEST_UNREACH ||
+	    type == ICMP_SOURCE_QUENCH ||
+	    type == ICMP_TIME_EXCEEDED) {
+		ih = skb_header_pointer(skb, ih->ihl*4 + sizeof(_icmph),
+					sizeof(_iph), &_iph);
+		if (ih == NULL || ntohs(ih->frag_off) & IP_OFFSET)
+			goto err;
+
+		*addr = src ? ih->saddr : ih->daddr;
+		return;
+	}
+err:
+	*addr = 0;
+}
+
  static inline void
  ip6addrptr(const struct sk_buff *skb, bool src, struct in6_addr *addr)
  {
@@ -380,6 +456,97 @@ ip6addrptr(const struct sk_buff *skb, bool src, struct in6_addr *addr)
  	       sizeof(*addr));
  }

+#define ip6_ext_hdr(hdr)  ((hdr == IPPROTO_HOPOPTS) || \
+			   (hdr == IPPROTO_ROUTING) || \
+			   (hdr == IPPROTO_FRAGMENT) || \
+			   (hdr == IPPROTO_ESP) || \
+			   (hdr == IPPROTO_AH) || \
+			   (hdr == IPPROTO_NONE) || \
+			   (hdr == IPPROTO_DSTOPTS))
+static inline void
+ip6inneraddrptr(const struct sk_buff *skb, bool src, struct in6_addr *addr)
+{
+	u8 type, currenthdr;
+	bool fragment = false;
+	unsigned int ptr, hdrlen = 0;
+	struct ipv6hdr _ip6h;
+	struct icmp6hdr _icmp6h;
+	const struct ipv6hdr *ih;
+	const struct icmp6hdr *ic;
+
+	ih = skb_header_pointer(skb, 0, sizeof(_ip6h), &_ip6h);
+	if (ih == NULL)
+		goto err;
+
+	ptr = sizeof(struct ipv6hdr);
+	currenthdr = ih->nexthdr;
+	while (currenthdr != NEXTHDR_NONE && ip6_ext_hdr(currenthdr)) {
+		struct ipv6_opt_hdr _hdr;
+		const struct ipv6_opt_hdr *hp;
+
+		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
+		if (hp == NULL)
+			goto err;
+
+		switch (currenthdr) {
+		case IPPROTO_FRAGMENT: {
+			struct frag_hdr _fhdr;
+			const struct frag_hdr *fh;
+
+			fh = skb_header_pointer(skb, ptr, sizeof(_fhdr),
+						&_fhdr);
+			if (fh == NULL)
+				goto err;
+			if (ntohs(fh->frag_off) & 0xFFF8)
+				fragment = true;
+
+			hdrlen = 8;
+			break;
+		}
+		case IPPROTO_DSTOPTS:
+		case IPPROTO_ROUTING:
+		case IPPROTO_HOPOPTS:
+			if (fragment)
+				goto err;
+
+			hdrlen = ipv6_optlen(hp);
+			break;
+		case IPPROTO_AH:
+			hdrlen = (hp->hdrlen+2)<<2;
+			break;
+		case IPPROTO_ESP:
+		default:
+			goto err;
+		} /* switch IPPROTO */
+
+		currenthdr = hp->nexthdr;
+		ptr += hdrlen;
+	}
+	if (fragment || currenthdr != IPPROTO_ICMPV6)
+		goto err;
+
+	ic = skb_header_pointer(skb, ptr, sizeof(_icmp6h), &_icmp6h);
+	if (ic == NULL)
+		goto err;
+
+	type = ic->icmp6_type;
+	if (type == ICMPV6_DEST_UNREACH ||
+	    type == ICMPV6_PKT_TOOBIG ||
+	    type == ICMPV6_TIME_EXCEED) {
+		ih = skb_header_pointer(skb, ptr + sizeof(_icmp6h),
+					sizeof(_ip6h), &_ip6h);
+		if (ih == NULL)
+			goto err;
+
+		memcpy(addr, src ? &ih->saddr : &ih->daddr,
+		       sizeof(*addr));
+		return;
+	}
+
+err:
+	memset(addr, 0, sizeof(*addr));
+}
+
  /* Calculate the bytes required to store the inclusive range of a-b */
  static inline int
  bitmap_bytes(u32 a, u32 b)
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_getport.h b/kernel/include/linux/netfilter/ipset/ip_set_getport.h
index 90d0930..549d013 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set_getport.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set_getport.h
@@ -4,20 +4,36 @@
  extern bool ip_set_get_ip4_port(const struct sk_buff *skb, bool src,
  				__be16 *port, u8 *proto);

+extern bool ip_set_get_inner_ip4_port(const struct sk_buff *skb, bool src,
+				      __be16 *port, u8 *proto);
+
  #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
  extern bool ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
  				__be16 *port, u8 *proto);
+
+extern bool ip_set_get_inner_ip6_port(const struct sk_buff *skb, bool src,
+				__be16 *port, u8 *proto);
  #else
  static inline bool ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
  				       __be16 *port, u8 *proto)
  {
  	return false;
  }
+
+static inline bool ip_set_get_inner_ip6_port(const struct sk_buff *skb,
+					     bool src,
+					     __be16 *port, u8 *proto)
+{
+	return false;
+}
  #endif

  extern bool ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src,
  				__be16 *port);

+extern bool ip_set_get_inner_ip_port(const struct sk_buff *skb, u8 pf,
+				     bool src, __be16 *port);
+
  static inline bool ip_set_proto_with_ports(u8 proto)
  {
  	switch (proto) {
diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
index 8024cdf..e9e6586 100644
--- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -161,6 +161,8 @@ enum ipset_cmd_flags {
  		(1 << IPSET_FLAG_BIT_SKIP_SUBCOUNTER_UPDATE),
  	IPSET_FLAG_BIT_MATCH_COUNTERS = 5,
  	IPSET_FLAG_MATCH_COUNTERS = (1 << IPSET_FLAG_BIT_MATCH_COUNTERS),
+	IPSET_FLAG_BIT_INNER = 6,
+	IPSET_FLAG_INNER = (1 << IPSET_FLAG_BIT_INNER),
  	IPSET_FLAG_BIT_RETURN_NOMATCH = 7,
  	IPSET_FLAG_RETURN_NOMATCH = (1 << IPSET_FLAG_BIT_RETURN_NOMATCH),
  	IPSET_FLAG_CMD_MAX = 15,
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
index ce99d26..7552d6d 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -116,7 +116,9 @@ bitmap_ip_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, map);
  	u32 ip;

-	ip = ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
+	ip = opt->cmdflags & IPSET_FLAG_INNER ?
+		ntohl(ip4inneraddr(skb, opt->flags & IPSET_DIM_ONE_SRC)) :
+		ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
  	if (ip < map->first_ip || ip > map->last_ip)
  		return -IPSET_ERR_BITMAP_RANGE;

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 6d5bad9..df5f3b4 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -223,7 +223,9 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
  	if (!(opt->flags & IPSET_DIM_TWO_SRC))
  		return 0;

-	ip = ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
+	ip = opt->cmdflags & IPSET_FLAG_INNER ?
+		ntohl(ip4inneraddr(skb, opt->flags & IPSET_DIM_ONE_SRC)) :
+		ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
  	if (ip < map->first_ip || ip > map->last_ip)
  		return -IPSET_ERR_BITMAP_RANGE;

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
index b220489..d29395b 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -110,9 +110,17 @@ bitmap_port_kadt(struct ip_set *set, const struct sk_buff *skb,
  	__be16 __port;
  	u16 port = 0;

-	if (!ip_set_get_ip_port(skb, opt->family,
-				opt->flags & IPSET_DIM_ONE_SRC, &__port))
-		return -EINVAL;
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		if (!ip_set_get_inner_ip_port(skb, opt->family,
+					opt->flags & IPSET_DIM_ONE_SRC,
+					&__port))
+			return -EINVAL;
+	} else {
+		if (!ip_set_get_ip_port(skb, opt->family,
+					opt->flags & IPSET_DIM_ONE_SRC,
+					&__port))
+			return -EINVAL;
+	}

  	port = ntohs(__port);

diff --git a/kernel/net/netfilter/ipset/ip_set_getport.c b/kernel/net/netfilter/ipset/ip_set_getport.c
index 6c019b3..f6ba3e8 100644
--- a/kernel/net/netfilter/ipset/ip_set_getport.c
+++ b/kernel/net/netfilter/ipset/ip_set_getport.c
@@ -19,6 +19,7 @@
  #include <linux/netfilter_ipv6/ip6_tables.h>
  #include <net/ip.h>
  #include <net/ipv6.h>
+#include <net/icmp.h>

  #include <linux/netfilter/ipset/ip_set_getport.h>

@@ -128,6 +129,47 @@ ip_set_get_ip4_port(const struct sk_buff *skb, bool src,
  }
  EXPORT_SYMBOL_GPL(ip_set_get_ip4_port);

+bool
+ip_set_get_inner_ip4_port(const struct sk_buff *skb, bool src,
+			  __be16 *port, u8 *proto)
+{
+	unsigned int protooff;
+	u8 type;
+	struct iphdr _iph;
+	struct icmphdr _icmph;
+	const struct iphdr *ih;
+	const struct icmphdr *ich;
+	static const size_t len = 8 + sizeof(struct iphdr);
+
+	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
+	if (ih == NULL || ih->protocol != IPPROTO_ICMP ||
+	    ntohs(ih->frag_off) & IP_OFFSET)
+		goto err;
+
+	protooff = ih->ihl*4;
+	ich = skb_header_pointer(skb, protooff, sizeof(_icmph), &_icmph);
+	if (ich == NULL ||
+	    (ich->type <= NR_ICMP_TYPES && skb->len - protooff < len))
+		goto err;
+
+	type = ich->type;
+	if (type == ICMP_DEST_UNREACH ||
+	    type == ICMP_SOURCE_QUENCH ||
+	    type == ICMP_TIME_EXCEEDED) {
+		protooff += sizeof(_icmph);
+		ih = skb_header_pointer(skb, protooff, sizeof(_iph), &_iph);
+		if (ih == NULL || ntohs(ih->frag_off) & IP_OFFSET)
+			goto err;
+
+		protooff += ih->ihl*4;
+		return get_port(skb, ih->protocol, protooff, src,
+				port, proto);
+	}
+err:
+	return false;
+}
+EXPORT_SYMBOL_GPL(ip_set_get_inner_ip4_port);
+
  #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
  bool
  ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
@@ -152,6 +194,109 @@ ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
  	return get_port(skb, nexthdr, protooff, src, port, proto);
  }
  EXPORT_SYMBOL_GPL(ip_set_get_ip6_port);
+
+#define ip6_ext_hdr(hdr)  ((hdr == IPPROTO_HOPOPTS) || \
+			   (hdr == IPPROTO_ROUTING) || \
+			   (hdr == IPPROTO_FRAGMENT) || \
+			   (hdr == IPPROTO_ESP) || \
+			   (hdr == IPPROTO_AH) || \
+			   (hdr == IPPROTO_NONE) || \
+			   (hdr == IPPROTO_DSTOPTS))
+
+bool process_ip6_hdr(const struct sk_buff *skb, u8 *currenthdr,
+		     const unsigned int offset, unsigned int *ptr)
+{
+	unsigned int hdrlen = 0;
+	bool fragment = false;
+	struct ipv6hdr _ip6h;
+	const struct ipv6hdr *ih;
+
+	ih = skb_header_pointer(skb, offset, sizeof(_ip6h), &_ip6h);
+	if (ih == NULL)
+		goto err;
+
+	*ptr = offset + sizeof(struct ipv6hdr);
+	*currenthdr = ih->nexthdr;
+	while (*currenthdr != NEXTHDR_NONE && ip6_ext_hdr(*currenthdr)) {
+		struct ipv6_opt_hdr _hdr;
+		const struct ipv6_opt_hdr *hp;
+
+		hp = skb_header_pointer(skb, *ptr, sizeof(_hdr), &_hdr);
+		if (hp == NULL)
+			goto err;
+
+		switch (*currenthdr) {
+		case IPPROTO_FRAGMENT: {
+			struct frag_hdr _fhdr;
+			const struct frag_hdr *fh;
+
+			fh = skb_header_pointer(skb, *ptr, sizeof(_fhdr),
+						&_fhdr);
+			if (fh == NULL)
+				goto err;
+			if (ntohs(fh->frag_off) & 0xFFF8)
+				fragment = true;
+
+			hdrlen = 8;
+			break;
+		}
+		case IPPROTO_DSTOPTS:
+		case IPPROTO_ROUTING:
+		case IPPROTO_HOPOPTS:
+			if (fragment)
+				goto err;
+
+			hdrlen = ipv6_optlen(hp);
+			break;
+		case IPPROTO_AH:
+			hdrlen = (hp->hdrlen+2)<<2;
+			break;
+		case IPPROTO_ESP:
+		default:
+			goto err;
+		} /* switch IPPROTO */
+
+		*currenthdr = hp->nexthdr;
+		*ptr += hdrlen;
+	}
+	return !fragment;
+
+err:
+	return false;
+}
+
+bool
+ip_set_get_inner_ip6_port(const struct sk_buff *skb, bool src,
+		    __be16 *port, u8 *proto)
+{
+	u8 type, currenthdr = 0;
+	unsigned int ptr = 0;
+	struct icmp6hdr _icmp6h;
+	const struct icmp6hdr *ic;
+
+	if (!process_ip6_hdr(skb, &currenthdr, 0, &ptr) ||
+	    currenthdr != IPPROTO_ICMPV6)
+		goto err;
+
+	ic = skb_header_pointer(skb, ptr, sizeof(_icmp6h), &_icmp6h);
+	if (ic == NULL)
+		goto err;
+
+	type = ic->icmp6_type;
+	if (type == ICMPV6_DEST_UNREACH ||
+	    type == ICMPV6_PKT_TOOBIG ||
+	    type == ICMPV6_TIME_EXCEED) {
+		if (!process_ip6_hdr(skb, &currenthdr,
+				ptr + sizeof(_icmp6h), &ptr) || ptr < 0)
+			goto err;
+
+		return get_port(skb, currenthdr, ptr, src, port, proto);
+	}
+
+err:
+	return false;
+}
+EXPORT_SYMBOL_GPL(ip_set_get_inner_ip6_port);
  #endif

  bool
@@ -181,3 +326,32 @@ ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src, __be16 *port)
  	}
  }
  EXPORT_SYMBOL_GPL(ip_set_get_ip_port);
+
+bool
+ip_set_get_inner_ip_port(const struct sk_buff *skb, u8 pf, bool src,
+			 __be16 *port)
+{
+	bool ret;
+	u8 proto;
+
+	switch (pf) {
+	case NFPROTO_IPV4:
+		ret = ip_set_get_inner_ip4_port(skb, src, port, &proto);
+		break;
+	case NFPROTO_IPV6:
+		ret = ip_set_get_inner_ip6_port(skb, src, port, &proto);
+		break;
+	default:
+		return false;
+	}
+	if (!ret)
+		return ret;
+	switch (proto) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		return true;
+	default:
+		return false;
+	}
+}
+EXPORT_SYMBOL_GPL(ip_set_get_inner_ip_port);
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ip.c b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
index 260c9a8..e9b19a8 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
@@ -102,7 +102,11 @@ hash_ip4_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
  	__be32 ip;

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &ip);
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		ip4inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &ip);
+	} else {
+		ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &ip);
+	}
  	ip &= ip_set_netmask(h->netmask);
  	if (ip == 0)
  		return -EINVAL;
@@ -255,7 +259,12 @@ hash_ip6_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct hash_ip6_elem e = {};
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);

-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		ip6inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+				&e.ip.in6);
+	} else {
+		ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	}
  	hash_ip6_netmask(&e.ip, h->netmask);
  	if (ipv6_addr_any(&e.ip.in6))
  		return -EINVAL;
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
index 64caad3..f3528ff 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -121,11 +121,22 @@ hash_ipport4_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct hash_ipport4_elem e = { };
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);

-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
-		return -EINVAL;
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		if (!ip_set_get_inner_ip4_port(skb,
+					opt->flags & IPSET_DIM_TWO_SRC,
+					&e.port, &e.proto))
+			return -EINVAL;
+
+		ip4inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+			       &e.ip);
+	} else {
+		if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+					 &e.port, &e.proto))
+			return -EINVAL;
+
+		ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	}

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
  }

@@ -311,11 +322,21 @@ hash_ipport6_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct hash_ipport6_elem e = { };
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);

-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
-		return -EINVAL;
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		if (!ip_set_get_inner_ip6_port(skb,
+					 opt->flags & IPSET_DIM_TWO_SRC,
+					 &e.port, &e.proto))
+			return -EINVAL;
+
+		ip6inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+				&e.ip.in6);
+	} else {
+		if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+					 &e.port, &e.proto))
+			return -EINVAL;

-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+		ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	}
  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
  }

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
index 2873bbc..8b3bdee 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -125,12 +125,23 @@ hash_ipportip4_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct hash_ipportip4_elem e = { };
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);

-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
-		return -EINVAL;
-
-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
-	ip4addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2);
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		if (!ip_set_get_inner_ip4_port(skb,
+					opt->flags & IPSET_DIM_TWO_SRC,
+				 	&e.port, &e.proto))
+			return -EINVAL;
+
+		ip4inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+		ip4inneraddrptr(skb, opt->flags & IPSET_DIM_THREE_SRC,
+				&e.ip2);
+	} else {
+		if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+				 	 &e.port, &e.proto))
+			return -EINVAL;
+
+		ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+		ip4addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2);
+	}
  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
  }

@@ -324,12 +335,24 @@ hash_ipportip6_kadt(struct ip_set *set, const struct sk_buff *skb,
  	struct hash_ipportip6_elem e = { };
  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);

-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
-		return -EINVAL;
-
-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	ip6addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2.in6);
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		if (!ip_set_get_inner_ip6_port(skb,
+					opt->flags & IPSET_DIM_TWO_SRC,
+					&e.port, &e.proto))
+			return -EINVAL;
+
+		ip6inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+				&e.ip.in6);
+		ip6inneraddrptr(skb, opt->flags & IPSET_DIM_THREE_SRC,
+				&e.ip2.in6);
+	} else {
+		if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+					 &e.port, &e.proto))
+			return -EINVAL;
+
+		ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+		ip6addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2.in6);
+	}
  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
  }

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
index db0e761..154c836 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -177,12 +177,24 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK - 1;

-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
-		return -EINVAL;
-
-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
-	ip4addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2);
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		if (!ip_set_get_inner_ip4_port(skb,
+					opt->flags & IPSET_DIM_TWO_SRC,
+					&e.port, &e.proto))
+			return -EINVAL;
+
+		ip4inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+				&e.ip);
+		ip4inneraddrptr(skb, opt->flags & IPSET_DIM_THREE_SRC,
+				&e.ip2);
+	} else {
+		if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+					 &e.port, &e.proto))
+			return -EINVAL;
+
+		ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+		ip4addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2);
+	}
  	e.ip2 &= ip_set_netmask(e.cidr + 1);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
@@ -461,12 +473,25 @@ hash_ipportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK - 1;

-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
-		return -EINVAL;
-
-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	ip6addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2.in6);
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		if (!ip_set_get_inner_ip6_port(skb,
+					opt->flags & IPSET_DIM_TWO_SRC,
+					&e.port, &e.proto))
+			return -EINVAL;
+
+		ip6inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+				&e.ip.in6);
+		ip6inneraddrptr(skb, opt->flags & IPSET_DIM_THREE_SRC,
+				&e.ip2.in6);
+	} else {
+		if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+					 &e.port, &e.proto))
+			return -EINVAL;
+
+		ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+		ip6addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC,
+			   &e.ip2.in6);
+	}
  	ip6_netmask(&e.ip2, e.cidr + 1);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_net.c b/kernel/net/netfilter/ipset/ip_set_hash_net.c
index 846ec80..431706a 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_net.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_net.c
@@ -151,8 +151,13 @@ hash_net4_kadt(struct ip_set *set, const struct sk_buff *skb,
  		return -EINVAL;
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK;
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		ip4inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+			       &e.ip);
+	} else {
+		ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	}

-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
  	e.ip &= ip_set_netmask(e.cidr);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
@@ -346,8 +351,12 @@ hash_net6_kadt(struct ip_set *set, const struct sk_buff *skb,
  		return -EINVAL;
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK;
-
-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		ip6inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+				&e.ip.in6);
+	} else {
+		ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	}
  	ip6_netmask(&e.ip, e.cidr);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
index 8f0e496..51415fb 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -275,8 +275,12 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
  		return -EINVAL;
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK;
-
-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		ip4inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+				&e.ip);
+	} else {
+		ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	}
  	e.ip &= ip_set_netmask(e.cidr);

  #define IFACE(dir)	(par->dir ? par->dir->name : NULL)
@@ -544,8 +548,12 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
  		return -EINVAL;
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK;
-
-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		ip6inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+				&e.ip.in6);
+	} else {
+		ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	}
  	ip6_netmask(&e.ip, e.cidr);

  	if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netport.c b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
index 021d716..376a28e 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
@@ -169,11 +169,21 @@ hash_netport4_kadt(struct ip_set *set, const struct sk_buff *skb,
  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK - 1;

-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
-		return -EINVAL;
-
-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		if (!ip_set_get_inner_ip4_port(skb,
+					opt->flags & IPSET_DIM_TWO_SRC,
+					&e.port, &e.proto))
+			return -EINVAL;
+
+		ip4inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+				&e.ip);
+	} else {
+		if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+					 &e.port, &e.proto))
+			return -EINVAL;
+
+		ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	}
  	e.ip &= ip_set_netmask(e.cidr + 1);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
@@ -413,12 +423,21 @@ hash_netport6_kadt(struct ip_set *set, const struct sk_buff *skb,

  	if (adt == IPSET_TEST)
  		e.cidr = HOST_MASK - 1;
-
-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
-				 &e.port, &e.proto))
-		return -EINVAL;
-
-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	if (opt->cmdflags & IPSET_FLAG_INNER) {
+		if (!ip_set_get_inner_ip6_port(skb,
+					opt->flags & IPSET_DIM_TWO_SRC,
+					&e.port, &e.proto))
+			return -EINVAL;
+
+		ip6inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
+				&e.ip.in6);
+	} else {
+		if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+					 &e.port, &e.proto))
+			return -EINVAL;
+
+		ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	}
  	ip6_netmask(&e.ip, e.cidr + 1);

  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);



