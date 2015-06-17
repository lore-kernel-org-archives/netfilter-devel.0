From: Daniel Mack <daniel@zonque.org>
Subject: [PATCH nf-next 1/3] netfilter: factor out helpers from xt_socket into separate modules
Date: Wed, 17 Jun 2015 02:08:10 +0200
Message-ID: <1434499692-9832-2-git-send-email-daniel@zonque.org>
References: <1434499692-9832-1-git-send-email-daniel@zonque.org>
Cc: fw@strlen.de, daniel@iogearbox.net, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org, Daniel Mack <daniel@zonque.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:39579 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbbFQARc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 20:17:32 -0400
In-Reply-To: <1434499692-9832-1-git-send-email-daniel@zonque.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The socket lookup helpers are also needed for fixing xt_cgroups
and nft_meta, therefore factor them out.

Based on a patch from Daniel Borkmann, and reworked so that the
code now lives in net/ipv[46]/netfilter/nf_sock_ipv[46].c and is
linked into separate modules.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter_ipv4.h    |   6 +
 include/linux/netfilter_ipv6.h    |   5 +
 net/ipv4/netfilter/Makefile       |   3 +
 net/ipv4/netfilter/nf_sock_ipv4.c | 169 +++++++++++++++++++++++
 net/ipv6/netfilter/Makefile       |   3 +
 net/ipv6/netfilter/nf_sock_ipv6.c | 153 +++++++++++++++++++++
 net/netfilter/Kconfig             |   8 ++
 net/netfilter/xt_socket.c         | 278 ++------------------------------------
 8 files changed, 355 insertions(+), 270 deletions(-)
 create mode 100644 net/ipv4/netfilter/nf_sock_ipv4.c
 create mode 100644 net/ipv6/netfilter/nf_sock_ipv6.c

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 6e4591b..f13fbc2 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -9,4 +9,10 @@
 int ip_route_me_harder(struct sk_buff *skb, unsigned addr_type);
 __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 		       unsigned int dataoff, u_int8_t protocol);
+
+#if IS_ENABLED(CONFIG_NF_SOCK_IPV4)
+struct sock *nf_socket_lookup_v4(const struct sk_buff *skb,
+				 const struct net_device *indev);
+#endif
+
 #endif /*__LINUX_IP_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 8b7d28f..d5b3a07 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -41,4 +41,9 @@ static inline int ipv6_netfilter_init(void) { return 0; }
 static inline void ipv6_netfilter_fini(void) { return; }
 #endif /* CONFIG_NETFILTER */
 
+#if IS_ENABLED(CONFIG_NF_SOCK_IPV6)
+struct sock *nf_socket_lookup_v6(const struct sk_buff *skb,
+				 const struct net_device *indev);
+#endif
+
 #endif /*__LINUX_IP6_NETFILTER_H*/
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 7fe6c70..c036c18 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -35,6 +35,9 @@ obj-$(CONFIG_NF_NAT_MASQUERADE_IPV4) += nf_nat_masquerade_ipv4.o
 # NAT protocols (nf_nat)
 obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
 
+# Socket helpers
+obj-$(CONFIG_NF_SOCK_IPV4) += nf_sock_ipv4.o
+
 obj-$(CONFIG_NF_TABLES_IPV4) += nf_tables_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
diff --git a/net/ipv4/netfilter/nf_sock_ipv4.c b/net/ipv4/netfilter/nf_sock_ipv4.c
new file mode 100644
index 0000000..78543be
--- /dev/null
+++ b/net/ipv4/netfilter/nf_sock_ipv4.c
@@ -0,0 +1,169 @@
+/*
+ * Socket lookup helper functions for iptables/nf_tables
+ *
+ * Copyright (C) 2007-2008 BalaBit IT Ltd.
+ * Author: Krisztian Kovacs
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <net/icmp.h>
+#include <net/inet_sock.h>
+#include <net/sock.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+
+static int
+extract_icmp4_fields(const struct sk_buff *skb,
+		     u8 *protocol,
+		     __be32 *raddr,
+		     __be32 *laddr,
+		     __be16 *rport,
+		     __be16 *lport)
+{
+	unsigned int outside_hdrlen = ip_hdrlen(skb);
+	struct iphdr *inside_iph, _inside_iph;
+	struct icmphdr *icmph, _icmph;
+	__be16 *ports, _ports[2];
+
+	icmph = skb_header_pointer(skb, outside_hdrlen,
+				   sizeof(_icmph), &_icmph);
+	if (!icmph)
+		return 1;
+
+	switch (icmph->type) {
+	case ICMP_DEST_UNREACH:
+	case ICMP_SOURCE_QUENCH:
+	case ICMP_REDIRECT:
+	case ICMP_TIME_EXCEEDED:
+	case ICMP_PARAMETERPROB:
+		break;
+	default:
+		return 1;
+	}
+
+	inside_iph = skb_header_pointer(skb, outside_hdrlen +
+					sizeof(struct icmphdr),
+					sizeof(_inside_iph), &_inside_iph);
+	if (!inside_iph)
+		return 1;
+
+	if (inside_iph->protocol != IPPROTO_TCP &&
+	    inside_iph->protocol != IPPROTO_UDP)
+		return 1;
+
+	ports = skb_header_pointer(skb, outside_hdrlen +
+				   sizeof(struct icmphdr) +
+				   (inside_iph->ihl << 2),
+				   sizeof(_ports), &_ports);
+	if (!ports)
+		return 1;
+
+	/* the inside IP packet is the one quoted from our side, thus
+	 * its saddr is the local address */
+	*protocol = inside_iph->protocol;
+	*laddr = inside_iph->saddr;
+	*lport = ports[0];
+	*raddr = inside_iph->daddr;
+	*rport = ports[1];
+
+	return 0;
+}
+
+static struct sock *
+nf_get_sock_v4(struct net *net, const u8 protocol,
+	       const __be32 saddr, const __be32 daddr,
+	       const __be16 sport, const __be16 dport,
+	       const struct net_device *in)
+{
+	switch (protocol) {
+	case IPPROTO_TCP:
+		return __inet_lookup(net, &tcp_hashinfo,
+				     saddr, sport, daddr, dport,
+				     in->ifindex);
+	case IPPROTO_UDP:
+		return udp4_lib_lookup(net, saddr, sport, daddr, dport,
+				       in->ifindex);
+	}
+	return NULL;
+}
+
+struct sock *nf_socket_lookup_v4(const struct sk_buff *skb,
+				 const struct net_device *indev)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	__be32 uninitialized_var(daddr), uninitialized_var(saddr);
+	__be16 uninitialized_var(dport), uninitialized_var(sport);
+	u8 uninitialized_var(protocol);
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	struct nf_conn const *ct;
+	enum ip_conntrack_info ctinfo;
+#endif
+
+	if (iph->protocol == IPPROTO_UDP || iph->protocol == IPPROTO_TCP) {
+		struct udphdr _hdr, *hp;
+
+		hp = skb_header_pointer(skb, ip_hdrlen(skb),
+					sizeof(_hdr), &_hdr);
+		if (!hp)
+			return NULL;
+
+		protocol = iph->protocol;
+		saddr = iph->saddr;
+		sport = hp->source;
+		daddr = iph->daddr;
+		dport = hp->dest;
+
+	} else if (iph->protocol == IPPROTO_ICMP) {
+		if (extract_icmp4_fields(skb, &protocol, &saddr, &daddr,
+					 &sport, &dport))
+			return NULL;
+	} else {
+		return NULL;
+	}
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	/* Do the lookup with the original socket address in
+	 * case this is a reply packet of an established
+	 * SNAT-ted connection.
+	 */
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct && !nf_ct_is_untracked(ct) &&
+	    ((iph->protocol != IPPROTO_ICMP &&
+	      ctinfo == IP_CT_ESTABLISHED_REPLY) ||
+	     (iph->protocol == IPPROTO_ICMP &&
+	      ctinfo == IP_CT_RELATED_REPLY)) &&
+	    (ct->status & IPS_SRC_NAT_DONE)) {
+
+		daddr = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip;
+		dport = (iph->protocol == IPPROTO_TCP) ?
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port :
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
+	}
+#endif
+
+	return nf_get_sock_v4(dev_net(skb->dev), protocol, saddr, daddr,
+			      sport, dport, indev);
+}
+EXPORT_SYMBOL_GPL(nf_socket_lookup_v4);
+
+static int __init nf_socket_ipv4_init(void)
+{
+	return 0;
+}
+
+static void __exit nf_socket_ipv4_exit(void) {}
+
+module_init(nf_socket_ipv4_init);
+module_exit(nf_socket_ipv4_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index c36e0a5..3a8cf8d 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -30,6 +30,9 @@ obj-$(CONFIG_NF_LOG_IPV6) += nf_log_ipv6.o
 # reject
 obj-$(CONFIG_NF_REJECT_IPV6) += nf_reject_ipv6.o
 
+# Socket helpers
+obj-$(CONFIG_NF_SOCK_IPV6) += nf_sock_ipv6.o
+
 # nf_tables
 obj-$(CONFIG_NF_TABLES_IPV6) += nf_tables_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV6) += nft_chain_route_ipv6.o
diff --git a/net/ipv6/netfilter/nf_sock_ipv6.c b/net/ipv6/netfilter/nf_sock_ipv6.c
new file mode 100644
index 0000000..59aeb9e
--- /dev/null
+++ b/net/ipv6/netfilter/nf_sock_ipv6.c
@@ -0,0 +1,153 @@
+/*
+ * Socket lookup helper functions for iptables/nf_tables
+ *
+ * Copyright (C) 2007-2008 BalaBit IT Ltd.
+ * Author: Krisztian Kovacs
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter_ipv6.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <net/inet6_hashtables.h>
+#include <net/icmp.h>
+#include <net/inet_sock.h>
+#include <net/sock.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+
+static int
+extract_icmp6_fields(const struct sk_buff *skb,
+		     unsigned int outside_hdrlen,
+		     int *protocol,
+		     const struct in6_addr **raddr,
+		     const struct in6_addr **laddr,
+		     __be16 *rport,
+		     __be16 *lport,
+		     struct ipv6hdr *ipv6_var)
+{
+	const struct ipv6hdr *inside_iph;
+	struct icmp6hdr *icmph, _icmph;
+	__be16 *ports, _ports[2];
+	u8 inside_nexthdr;
+	__be16 inside_fragoff;
+	int inside_hdrlen;
+
+	icmph = skb_header_pointer(skb, outside_hdrlen,
+				   sizeof(_icmph), &_icmph);
+	if (!icmph)
+		return 1;
+
+	if (icmph->icmp6_type & ICMPV6_INFOMSG_MASK)
+		return 1;
+
+	inside_iph = skb_header_pointer(skb, outside_hdrlen + sizeof(_icmph),
+					sizeof(*ipv6_var), ipv6_var);
+	if (!inside_iph)
+		return 1;
+	inside_nexthdr = inside_iph->nexthdr;
+
+	inside_hdrlen = ipv6_skip_exthdr(skb, outside_hdrlen + sizeof(_icmph) +
+					      sizeof(*ipv6_var),
+					 &inside_nexthdr, &inside_fragoff);
+	if (inside_hdrlen < 0)
+		return 1; /* hjm: Packet has no/incomplete transport layer headers. */
+
+	if (inside_nexthdr != IPPROTO_TCP &&
+	    inside_nexthdr != IPPROTO_UDP)
+		return 1;
+
+	ports = skb_header_pointer(skb, inside_hdrlen,
+				   sizeof(_ports), &_ports);
+	if (!ports)
+		return 1;
+
+	/* the inside IP packet is the one quoted from our side, thus
+	 * its saddr is the local address */
+	*protocol = inside_nexthdr;
+	*laddr = &inside_iph->saddr;
+	*lport = ports[0];
+	*raddr = &inside_iph->daddr;
+	*rport = ports[1];
+
+	return 0;
+}
+
+static struct sock *
+nf_socket_get_sock_v6(struct net *net, const u8 protocol,
+		      const struct in6_addr *saddr,
+		      const struct in6_addr *daddr,
+		      const __be16 sport, const __be16 dport,
+		      const struct net_device *in)
+{
+	switch (protocol) {
+	case IPPROTO_TCP:
+		return inet6_lookup(net, &tcp_hashinfo,
+				    saddr, sport, daddr, dport,
+				    in->ifindex);
+	case IPPROTO_UDP:
+		return udp6_lib_lookup(net, saddr, sport, daddr, dport,
+				       in->ifindex);
+	}
+
+	return NULL;
+}
+
+struct sock *nf_socket_lookup_v6(const struct sk_buff *skb,
+				 const struct net_device *indev)
+{
+	__be16 uninitialized_var(dport), uninitialized_var(sport);
+	const struct in6_addr *daddr = NULL, *saddr = NULL;
+	struct ipv6hdr *iph = ipv6_hdr(skb);
+	int thoff = 0, tproto;
+
+	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
+	if (tproto < 0) {
+		pr_debug("unable to find transport header in IPv6 packet, dropping\n");
+		return NULL;
+	}
+
+	if (tproto == IPPROTO_UDP || tproto == IPPROTO_TCP) {
+		struct udphdr _hdr, *hp;
+
+		hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
+		if (!hp)
+			return NULL;
+
+		saddr = &iph->saddr;
+		sport = hp->source;
+		daddr = &iph->daddr;
+		dport = hp->dest;
+
+	} else if (tproto == IPPROTO_ICMPV6) {
+		struct ipv6hdr ipv6_var;
+
+		if (extract_icmp6_fields(skb, thoff, &tproto, &saddr, &daddr,
+					 &sport, &dport, &ipv6_var))
+			return NULL;
+	} else {
+		return NULL;
+	}
+
+	return nf_socket_get_sock_v6(dev_net(skb->dev), tproto, saddr, daddr,
+				     sport, dport, indev);
+}
+EXPORT_SYMBOL_GPL(nf_socket_lookup_v6);
+
+static int __init nf_socket_ipv6_init(void)
+{
+	return 0;
+}
+
+static void __exit nf_socket_ipv6_exit(void) {}
+
+module_init(nf_socket_ipv6_init);
+module_exit(nf_socket_ipv6_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index fbc8d15..f08e7a8 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -12,6 +12,12 @@ config NETFILTER_INGRESS
 config NETFILTER_NETLINK
 	tristate
 
+config NF_SOCK_IPV4
+	tristate
+
+config NF_SOCK_IPV6
+	tristate
+
 config NETFILTER_NETLINK_ACCT
 tristate "Netfilter NFACCT over NFNETLINK interface"
 	depends on NETFILTER_ADVANCED
@@ -1373,6 +1379,8 @@ config NETFILTER_XT_MATCH_SOCKET
 	depends on (IP6_NF_IPTABLES || IP6_NF_IPTABLES=n)
 	select NF_DEFRAG_IPV4
 	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES
+	select NF_SOCK_IPV4
+	select NF_SOCK_IPV6 if IP6_NF_IPTABLES
 	help
 	  This option adds a `socket' match, which can be used to match
 	  packets for which a TCP or UDP socket lookup finds a valid socket.
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index e092cb0..dbc78d7 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -11,86 +11,15 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
-#include <linux/skbuff.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <net/tcp.h>
-#include <net/udp.h>
-#include <net/icmp.h>
-#include <net/sock.h>
-#include <net/inet_sock.h>
+#include <linux/netfilter/xt_socket.h>
 #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
-
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-#define XT_SOCKET_HAVE_IPV6 1
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <net/inet6_hashtables.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
-#endif
-
-#include <linux/netfilter/xt_socket.h>
-
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-#define XT_SOCKET_HAVE_CONNTRACK 1
-#include <net/netfilter/nf_conntrack.h>
-#endif
-
-static int
-extract_icmp4_fields(const struct sk_buff *skb,
-		    u8 *protocol,
-		    __be32 *raddr,
-		    __be32 *laddr,
-		    __be16 *rport,
-		    __be16 *lport)
-{
-	unsigned int outside_hdrlen = ip_hdrlen(skb);
-	struct iphdr *inside_iph, _inside_iph;
-	struct icmphdr *icmph, _icmph;
-	__be16 *ports, _ports[2];
-
-	icmph = skb_header_pointer(skb, outside_hdrlen,
-				   sizeof(_icmph), &_icmph);
-	if (icmph == NULL)
-		return 1;
-
-	switch (icmph->type) {
-	case ICMP_DEST_UNREACH:
-	case ICMP_SOURCE_QUENCH:
-	case ICMP_REDIRECT:
-	case ICMP_TIME_EXCEEDED:
-	case ICMP_PARAMETERPROB:
-		break;
-	default:
-		return 1;
-	}
-
-	inside_iph = skb_header_pointer(skb, outside_hdrlen +
-					sizeof(struct icmphdr),
-					sizeof(_inside_iph), &_inside_iph);
-	if (inside_iph == NULL)
-		return 1;
-
-	if (inside_iph->protocol != IPPROTO_TCP &&
-	    inside_iph->protocol != IPPROTO_UDP)
-		return 1;
-
-	ports = skb_header_pointer(skb, outside_hdrlen +
-				   sizeof(struct icmphdr) +
-				   (inside_iph->ihl << 2),
-				   sizeof(_ports), &_ports);
-	if (ports == NULL)
-		return 1;
-
-	/* the inside IP packet is the one quoted from our side, thus
-	 * its saddr is the local address */
-	*protocol = inside_iph->protocol;
-	*laddr = inside_iph->saddr;
-	*lport = ports[0];
-	*raddr = inside_iph->daddr;
-	*rport = ports[1];
-
-	return 0;
-}
+#include <net/inet_sock.h>
+#include <net/sock.h>
+#include <net/tcp.h>
 
 /* "socket" match based redirection (no specific rule)
  * ===================================================
@@ -111,23 +40,6 @@ extract_icmp4_fields(const struct sk_buff *skb,
  *     then local services could intercept traffic going through the
  *     box.
  */
-static struct sock *
-xt_socket_get_sock_v4(struct net *net, const u8 protocol,
-		      const __be32 saddr, const __be32 daddr,
-		      const __be16 sport, const __be16 dport,
-		      const struct net_device *in)
-{
-	switch (protocol) {
-	case IPPROTO_TCP:
-		return __inet_lookup(net, &tcp_hashinfo,
-				     saddr, sport, daddr, dport,
-				     in->ifindex);
-	case IPPROTO_UDP:
-		return udp4_lib_lookup(net, saddr, sport, daddr, dport,
-				       in->ifindex);
-	}
-	return NULL;
-}
 
 static bool xt_socket_sk_is_transparent(struct sock *sk)
 {
@@ -143,64 +55,6 @@ static bool xt_socket_sk_is_transparent(struct sock *sk)
 	}
 }
 
-static struct sock *xt_socket_lookup_slow_v4(const struct sk_buff *skb,
-					     const struct net_device *indev)
-{
-	const struct iphdr *iph = ip_hdr(skb);
-	__be32 uninitialized_var(daddr), uninitialized_var(saddr);
-	__be16 uninitialized_var(dport), uninitialized_var(sport);
-	u8 uninitialized_var(protocol);
-#ifdef XT_SOCKET_HAVE_CONNTRACK
-	struct nf_conn const *ct;
-	enum ip_conntrack_info ctinfo;
-#endif
-
-	if (iph->protocol == IPPROTO_UDP || iph->protocol == IPPROTO_TCP) {
-		struct udphdr _hdr, *hp;
-
-		hp = skb_header_pointer(skb, ip_hdrlen(skb),
-					sizeof(_hdr), &_hdr);
-		if (hp == NULL)
-			return NULL;
-
-		protocol = iph->protocol;
-		saddr = iph->saddr;
-		sport = hp->source;
-		daddr = iph->daddr;
-		dport = hp->dest;
-
-	} else if (iph->protocol == IPPROTO_ICMP) {
-		if (extract_icmp4_fields(skb, &protocol, &saddr, &daddr,
-					 &sport, &dport))
-			return NULL;
-	} else {
-		return NULL;
-	}
-
-#ifdef XT_SOCKET_HAVE_CONNTRACK
-	/* Do the lookup with the original socket address in
-	 * case this is a reply packet of an established
-	 * SNAT-ted connection.
-	 */
-	ct = nf_ct_get(skb, &ctinfo);
-	if (ct && !nf_ct_is_untracked(ct) &&
-	    ((iph->protocol != IPPROTO_ICMP &&
-	      ctinfo == IP_CT_ESTABLISHED_REPLY) ||
-	     (iph->protocol == IPPROTO_ICMP &&
-	      ctinfo == IP_CT_RELATED_REPLY)) &&
-	    (ct->status & IPS_SRC_NAT_DONE)) {
-
-		daddr = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip;
-		dport = (iph->protocol == IPPROTO_TCP) ?
-			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port :
-			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
-	}
-#endif
-
-	return xt_socket_get_sock_v4(dev_net(skb->dev), protocol, saddr, daddr,
-				     sport, dport, indev);
-}
-
 static bool
 socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 	     const struct xt_socket_mtinfo1 *info)
@@ -208,7 +62,7 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 	struct sock *sk = skb->sk;
 
 	if (!sk)
-		sk = xt_socket_lookup_slow_v4(skb, par->in);
+		sk = nf_socket_lookup_v4(skb, par->in);
 	if (sk) {
 		bool wildcard;
 		bool transparent = true;
@@ -254,122 +108,6 @@ socket_mt4_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
 
 #ifdef XT_SOCKET_HAVE_IPV6
 
-static int
-extract_icmp6_fields(const struct sk_buff *skb,
-		     unsigned int outside_hdrlen,
-		     int *protocol,
-		     const struct in6_addr **raddr,
-		     const struct in6_addr **laddr,
-		     __be16 *rport,
-		     __be16 *lport,
-		     struct ipv6hdr *ipv6_var)
-{
-	const struct ipv6hdr *inside_iph;
-	struct icmp6hdr *icmph, _icmph;
-	__be16 *ports, _ports[2];
-	u8 inside_nexthdr;
-	__be16 inside_fragoff;
-	int inside_hdrlen;
-
-	icmph = skb_header_pointer(skb, outside_hdrlen,
-				   sizeof(_icmph), &_icmph);
-	if (icmph == NULL)
-		return 1;
-
-	if (icmph->icmp6_type & ICMPV6_INFOMSG_MASK)
-		return 1;
-
-	inside_iph = skb_header_pointer(skb, outside_hdrlen + sizeof(_icmph),
-					sizeof(*ipv6_var), ipv6_var);
-	if (inside_iph == NULL)
-		return 1;
-	inside_nexthdr = inside_iph->nexthdr;
-
-	inside_hdrlen = ipv6_skip_exthdr(skb, outside_hdrlen + sizeof(_icmph) +
-					      sizeof(*ipv6_var),
-					 &inside_nexthdr, &inside_fragoff);
-	if (inside_hdrlen < 0)
-		return 1; /* hjm: Packet has no/incomplete transport layer headers. */
-
-	if (inside_nexthdr != IPPROTO_TCP &&
-	    inside_nexthdr != IPPROTO_UDP)
-		return 1;
-
-	ports = skb_header_pointer(skb, inside_hdrlen,
-				   sizeof(_ports), &_ports);
-	if (ports == NULL)
-		return 1;
-
-	/* the inside IP packet is the one quoted from our side, thus
-	 * its saddr is the local address */
-	*protocol = inside_nexthdr;
-	*laddr = &inside_iph->saddr;
-	*lport = ports[0];
-	*raddr = &inside_iph->daddr;
-	*rport = ports[1];
-
-	return 0;
-}
-
-static struct sock *
-xt_socket_get_sock_v6(struct net *net, const u8 protocol,
-		      const struct in6_addr *saddr, const struct in6_addr *daddr,
-		      const __be16 sport, const __be16 dport,
-		      const struct net_device *in)
-{
-	switch (protocol) {
-	case IPPROTO_TCP:
-		return inet6_lookup(net, &tcp_hashinfo,
-				    saddr, sport, daddr, dport,
-				    in->ifindex);
-	case IPPROTO_UDP:
-		return udp6_lib_lookup(net, saddr, sport, daddr, dport,
-				       in->ifindex);
-	}
-
-	return NULL;
-}
-
-static struct sock *xt_socket_lookup_slow_v6(const struct sk_buff *skb,
-					     const struct net_device *indev)
-{
-	__be16 uninitialized_var(dport), uninitialized_var(sport);
-	const struct in6_addr *daddr = NULL, *saddr = NULL;
-	struct ipv6hdr *iph = ipv6_hdr(skb);
-	int thoff = 0, tproto;
-
-	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
-	if (tproto < 0) {
-		pr_debug("unable to find transport header in IPv6 packet, dropping\n");
-		return NULL;
-	}
-
-	if (tproto == IPPROTO_UDP || tproto == IPPROTO_TCP) {
-		struct udphdr _hdr, *hp;
-
-		hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
-		if (hp == NULL)
-			return NULL;
-
-		saddr = &iph->saddr;
-		sport = hp->source;
-		daddr = &iph->daddr;
-		dport = hp->dest;
-
-	} else if (tproto == IPPROTO_ICMPV6) {
-		struct ipv6hdr ipv6_var;
-
-		if (extract_icmp6_fields(skb, thoff, &tproto, &saddr, &daddr,
-					 &sport, &dport, &ipv6_var))
-			return NULL;
-	} else {
-		return NULL;
-	}
-
-	return xt_socket_get_sock_v6(dev_net(skb->dev), tproto, saddr, daddr,
-				     sport, dport, indev);
-}
-
 static bool
 socket_mt6_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
 {
@@ -377,7 +115,7 @@ socket_mt6_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
 	struct sock *sk = skb->sk;
 
 	if (!sk)
-		sk = xt_socket_lookup_slow_v6(skb, par->in);
+		sk = nf_socket_lookup_v6(skb, par->in);
 	if (sk) {
 		bool wildcard;
 		bool transparent = true;
-- 
2.4.0

