From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v3 2/5] ipset: add "inner" flag implementation
Date: Sat, 29 Jun 2013 22:32:36 +0100
Message-ID: <51CF5274.3070700@googlemail.com>
References: <cover.1372540515.git.mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50033 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3F2Vcq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 17:32:46 -0400
Received: by mail-wi0-f178.google.com with SMTP id k10so1945489wiv.5
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jun 2013 14:32:45 -0700 (PDT)
In-Reply-To: <cover.1372540515.git.mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements "inner" flag option in set iptables match,
allowing matching based on the properties (source/destination IP address,
protocol, port and so on) of the original (inner) connection in the event
of the following ICMP[v4,v6] messages:

ICMPv4 destination-unreachable (code 3);
ICMPv4 source-quench (code 4);
ICMPv4 time-exceeded (code 11);
ICMPv6 destination-unreachable (code 1);
ICMPv6 packet-too-big (code 2);
ICMPv6 time-exceeded (code 3);

Revision history:

v1 * initial revision
v2 * redundant code removed;
    * added a new header file (ip_set_icmp.h) with 2 inline functions,
      allowing access to the internal icmp header properties;
    * removed ip[46]inneraddr[ptr]functions as they are no longer needed
    * added new ipv[46]addr[ptr] and ip_set_get*port functions, the old
      functions are still preserved for backwards compatibility
v3 * rename and move ip_set_get_icmpv[46]_inner_hdr functions to
      ip_set_core.c and remove ip_set_icmp.h
    * move icmpv[46] protocol and offset checks inside
      ip_set_get_ip[46]_inner_hdr functions
    * eliminate ip[46]addrptr & ip_set_get_ip[46]_port backward-compatible
      functions and rename the new ones to use the same name
    * eliminate single-path error gotos in ip_set.h and ip_set_getport.c

Signed-off-by: Dash Four <mr.dash.four@googlemail.com>
---
  kernel/include/linux/netfilter/ipset/ip_set.h      | 59 ++++++++++++---
  .../include/linux/netfilter/ipset/ip_set_getport.h | 17 +++--
  kernel/include/uapi/linux/netfilter/ipset/ip_set.h |  2 +
  kernel/net/netfilter/ipset/ip_set_core.c           | 85 ++++++++++++++++++++++
  kernel/net/netfilter/ipset/ip_set_getport.c        | 42 +++++++----
  5 files changed, 173 insertions(+), 32 deletions(-)

diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
index 8499e25..212aaa2 100644
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
@@ -275,6 +278,13 @@ extern int ip_set_get_ipaddr4(struct nlattr *nla,  __be32 *ipaddr);
  extern int ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr);
  extern int ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
  				 struct ip_set_ext *ext);
+extern bool ip_set_get_ip4_inner_hdr(const struct sk_buff *skb,
+				     unsigned int *offset,
+				     struct iphdr **ih);
+extern bool ip_set_get_ip6_inner_hdr(const struct sk_buff *skb,
+				     const u8 protocol,
+				     unsigned int *offset,
+				     struct ipv6hdr **ih);

  static inline int
  ip_set_get_hostipaddr4(struct nlattr *nla, u32 *ipaddr)
@@ -361,24 +371,51 @@ static inline int nla_put_ipaddr6(struct sk_buff *skb, int type,
  }

  /* Get address from skbuff */
-static inline __be32
-ip4addr(const struct sk_buff *skb, bool src)
+static inline bool
+ip4addrptr(const struct sk_buff *skb, bool inner, bool src, __be32 *addr)
  {
-	return src ? ip_hdr(skb)->saddr : ip_hdr(skb)->daddr;
+	struct iphdr *ih = ip_hdr(skb);
+	unsigned int protooff = ip_hdrlen(skb);
+
+	if (inner && !ip_set_get_ip4_inner_hdr(skb, &protooff, &ih))
+		return false;
+
+	*addr = src ? ih->saddr : ih->daddr;
+	return true;
  }

-static inline void
-ip4addrptr(const struct sk_buff *skb, bool src, __be32 *addr)
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+static inline bool
+ip6addrptr(const struct sk_buff *skb, bool inner, bool src,
+	    struct in6_addr *addr)
  {
-	*addr = src ? ip_hdr(skb)->saddr : ip_hdr(skb)->daddr;
+	struct ipv6hdr *ih = ipv6_hdr(skb);
+
+	if (inner) {
+		unsigned int protooff;
+		u8 nexthdr = ih->nexthdr;
+		__be16 frag_off;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 3, 0)
+		protooff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr),
+					    &nexthdr, &frag_off);
+#else
+		protooff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr),
+					    &nexthdr);
+#endif
+		if (!ip_set_get_ip6_inner_hdr(skb, nexthdr, &protooff, &ih))
+			return false;
+	}
+	memcpy(addr, src ? &ih->saddr : &ih->daddr, sizeof(*addr));
+	return true;
  }
-
-static inline void
-ip6addrptr(const struct sk_buff *skb, bool src, struct in6_addr *addr)
+#else
+static inline bool
+ip6addrptr(const struct sk_buff *skb, bool inner, bool src,
+	    struct in6_addr *addr)
  {
-	memcpy(addr, src ? &ipv6_hdr(skb)->saddr : &ipv6_hdr(skb)->daddr,
-	       sizeof(*addr));
+	return false;
  }
+#endif

  /* Calculate the bytes required to store the inclusive range of a-b */
  static inline int
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_getport.h b/kernel/include/linux/netfilter/ipset/ip_set_getport.h
index 90d0930..5ec6dc6 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set_getport.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set_getport.h
@@ -1,22 +1,23 @@
  #ifndef _IP_SET_GETPORT_H
  #define _IP_SET_GETPORT_H

-extern bool ip_set_get_ip4_port(const struct sk_buff *skb, bool src,
-				__be16 *port, u8 *proto);
+extern bool ip_set_get_ip4_port(const struct sk_buff *skb, bool inner,
+				bool src, __be16 *port, u8 *proto);

  #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-extern bool ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
-				__be16 *port, u8 *proto);
+extern bool ip_set_get_ip6_port(const struct sk_buff *skb, bool inner,
+				bool src, __be16 *port, u8 *proto);
  #else
-static inline bool ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
-				       __be16 *port, u8 *proto)
+static inline bool ip_set_get_ip6_port(const struct sk_buff *skb,
+					bool inner, bool src,
+					__be16 *port, u8 *proto)
  {
  	return false;
  }
  #endif

-extern bool ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src,
-				__be16 *port);
+extern bool ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool inner,
+				bool src, __be16 *port);

  static inline bool ip_set_proto_with_ports(u8 proto)
  {
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
diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfilter/ipset/ip_set_core.c
index 2c646cb..0f2aa97 100644
--- a/kernel/net/netfilter/ipset/ip_set_core.c
+++ b/kernel/net/netfilter/ipset/ip_set_core.c
@@ -13,6 +13,8 @@
  #include <linux/module.h>
  #include <linux/moduleparam.h>
  #include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/icmp.h>
  #include <linux/skbuff.h>
  #include <linux/spinlock.h>
  #include <linux/netlink.h>
@@ -617,6 +619,89 @@ ip_set_nfnl_put(ip_set_id_t index)
  }
  EXPORT_SYMBOL_GPL(ip_set_nfnl_put);

+bool ip_set_get_ip4_inner_hdr(const struct sk_buff *skb, unsigned int *offset,
+			      struct iphdr **ih)
+{
+	u8 type;
+	struct iphdr _iph;
+	struct icmphdr _icmph;
+	struct iphdr *iph;
+	const struct icmphdr *ich;
+	/* RFC 1122: 3.2.2. req'd len: IP header + 8 bytes of inner header */
+	static const size_t req_len = sizeof(struct iphdr) + 8;
+
+	if (offset == NULL || ih == NULL || *ih == NULL ||
+	    (*ih)->protocol != IPPROTO_ICMP)
+		goto err;
+
+	ich = skb_header_pointer(skb, *offset, sizeof(_icmph), &_icmph);
+	if (ich == NULL ||
+	    (ich->type <= NR_ICMP_TYPES && skb->len - *offset < req_len))
+		goto err;
+
+	type = ich->type;
+	if (type == ICMP_DEST_UNREACH ||
+	    type == ICMP_SOURCE_QUENCH ||
+	    type == ICMP_TIME_EXCEEDED) {
+		*offset += sizeof(_icmph);
+		iph = skb_header_pointer(skb, *offset, sizeof(_iph), &_iph);
+		if (iph == NULL || ntohs(iph->frag_off) & IP_OFFSET)
+			goto err;
+
+		*ih = iph;
+		return true;
+	}
+
+err:
+	return false;
+}
+EXPORT_SYMBOL_GPL(ip_set_get_ip4_inner_hdr);
+
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+bool ip_set_get_ip6_inner_hdr(const struct sk_buff *skb, const u8 protocol,
+			      unsigned int *offset,
+			      struct ipv6hdr **ih)
+{
+	u8 type;
+	const struct icmp6hdr *ic;
+	struct icmp6hdr _icmp6h;
+	struct ipv6hdr _ip6h;
+	struct ipv6hdr *iph;
+
+	if (offset == NULL || *offset < 0 ||
+	    ih == NULL || protocol != IPPROTO_ICMPV6)
+		goto err;
+
+	ic = skb_header_pointer(skb, *offset, sizeof(_icmp6h), &_icmp6h);
+	if (ic == NULL)
+		goto err;
+
+	type = ic->icmp6_type;
+	if (type == ICMPV6_DEST_UNREACH ||
+	    type == ICMPV6_PKT_TOOBIG ||
+	    type == ICMPV6_TIME_EXCEED) {
+		*offset += sizeof(_icmp6h);
+		iph = skb_header_pointer(skb, *offset, sizeof(_ip6h), &_ip6h);
+		if (iph == NULL)
+			goto err;
+
+		*ih = iph;
+		return true;
+	}
+
+err:
+	return false;
+}
+#else
+bool ip_set_get_ip6_inner_hdr(const struct sk_buff *skb, const u8 protocol,
+			      unsigned int offset,
+			      struct ipv6hdr **ih)
+{
+	return false;
+}
+#endif
+EXPORT_SYMBOL_GPL(ip_set_get_ip6_inner_hdr);
+
  /*
   * Communication protocol with userspace over netlink.
   *
diff --git a/kernel/net/netfilter/ipset/ip_set_getport.c b/kernel/net/netfilter/ipset/ip_set_getport.c
index a0d96eb..9093581 100644
--- a/kernel/net/netfilter/ipset/ip_set_getport.c
+++ b/kernel/net/netfilter/ipset/ip_set_getport.c
@@ -19,7 +19,9 @@
  #include <linux/netfilter_ipv6/ip6_tables.h>
  #include <net/ip.h>
  #include <net/ipv6.h>
+#include <net/icmp.h>

+#include <linux/netfilter/ipset/ip_set.h>
  #include <linux/netfilter/ipset/ip_set_getport.h>

  /* We must handle non-linear skbs */
@@ -97,10 +99,10 @@ get_port(const struct sk_buff *skb, int protocol, unsigned int protooff,
  }

  bool
-ip_set_get_ip4_port(const struct sk_buff *skb, bool src,
+ip_set_get_ip4_port(const struct sk_buff *skb, bool inner, bool src,
  		    __be16 *port, u8 *proto)
  {
-	const struct iphdr *iph = ip_hdr(skb);
+	struct iphdr *iph = ip_hdr(skb);
  	unsigned int protooff = ip_hdrlen(skb);
  	int protocol = iph->protocol;

@@ -123,47 +125,61 @@ ip_set_get_ip4_port(const struct sk_buff *skb, bool src,
  			*proto = protocol;
  			return true;
  		}
+	if (inner) {
+		if (!ip_set_get_ip4_inner_hdr(skb, &protooff, &iph))
+			return false;

+		protocol = iph->protocol;
+		protooff += iph->ihl*4;
+	}
  	return get_port(skb, protocol, protooff, src, port, proto);
  }
  EXPORT_SYMBOL_GPL(ip_set_get_ip4_port);

  #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
  bool
-ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
+ip_set_get_ip6_port(const struct sk_buff *skb, bool inner, bool src,
  		    __be16 *port, u8 *proto)
  {
-	int protoff;
-	u8 nexthdr;
+	unsigned int protooff;
+	struct ipv6hdr *ih = ipv6_hdr(skb);
+	u8 nexthdr = ih->nexthdr;
  	__be16 frag_off = 0;

-	nexthdr = ipv6_hdr(skb)->nexthdr;
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 3, 0)
-	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
+	protooff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
  				   &frag_off);
  #else
-	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr);
+	protooff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr);
  #endif
-	if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
+	if (protooff < 0 || (frag_off & htons(~0x7)) != 0)
  		return false;

-	return get_port(skb, nexthdr, protoff, src, port, proto);
+	if (inner) {
+		if (!ip_set_get_ip6_inner_hdr(skb, nexthdr, &protooff, &ih))
+			return false;
+
+		nexthdr = ih->nexthdr;
+		protooff += sizeof(struct ipv6hdr);
+	}
+	return get_port(skb, nexthdr, protooff, src, port, proto);
  }
  EXPORT_SYMBOL_GPL(ip_set_get_ip6_port);
  #endif

  bool
-ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src, __be16 *port)
+ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool inner, bool src,
+		   __be16 *port)
  {
  	bool ret;
  	u8 proto;

  	switch (pf) {
  	case NFPROTO_IPV4:
-		ret = ip_set_get_ip4_port(skb, src, port, &proto);
+		ret = ip_set_get_ip4_port(skb, inner, src, port, &proto);
  		break;
  	case NFPROTO_IPV6:
-		ret = ip_set_get_ip6_port(skb, src, port, &proto);
+		ret = ip_set_get_ip6_port(skb, inner, src, port, &proto);
  		break;
  	default:
  		return false;

