From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next 1/2] netfilter: x_tables: refactor lookup helpers from xt_socket
Date: Tue, 24 Mar 2015 16:30:28 +0100
Message-ID: <28d131fe108384514ac10c3c93ad82ce36d065b1.1427209409.git.daniel@iogearbox.net>
References: <cover.1427209409.git.daniel@iogearbox.net>
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:44012 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbbCXPae (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2015 11:30:34 -0400
In-Reply-To: <cover.1427209409.git.daniel@iogearbox.net>
In-Reply-To: <cover.1427209409.git.daniel@iogearbox.net>
References: <cover.1427209409.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The socket lookup helpers are also needed for fixing xt_cgroups,
therefore refactor them into shareable helper functions.

This simplifies and optimizes the xt_socket code itself a bit
as well, i.e. time to verdict for early demux sockets should be
much faster than previously:

We've unnecessarily extracted proto, {s,d}addr and {s,d}ports
from the skb data, accessing possible conntrack information,
etc even though we were not even calling into the socket lookup
via xt_socket_get_sock_v4() due to skb->sk hit.

After this patch, we only proceed the slow-path when we have a
skb->sk miss.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Daniel Mack <daniel@zonque.org>
Cc: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_sk_helper.h | 282 +++++++++++++++++++++++++++++++++++++++++
 net/netfilter/xt_socket.c    | 293 +++----------------------------------------
 2 files changed, 300 insertions(+), 275 deletions(-)
 create mode 100644 net/netfilter/xt_sk_helper.h

diff --git a/net/netfilter/xt_sk_helper.h b/net/netfilter/xt_sk_helper.h
new file mode 100644
index 0000000..604b7ac
--- /dev/null
+++ b/net/netfilter/xt_sk_helper.h
@@ -0,0 +1,282 @@
+/*
+ * Transparent proxy support for Linux/iptables
+ *
+ * Copyright (C) 2007-2008 BalaBit IT Ltd.
+ * Author: Krisztian Kovacs
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/skbuff.h>
+
+#include <net/tcp.h>
+#include <net/udp.h>
+#include <net/icmp.h>
+#include <net/sock.h>
+
+#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+#define XT_HAVE_IPV6 1
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <net/inet6_hashtables.h>
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+#endif
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#define XT_HAVE_CONNTRACK 1
+#include <net/netfilter/nf_conntrack.h>
+#endif
+
+static int extract_icmp4_fields(const struct sk_buff *skb, u8 *protocol,
+				__be32 *raddr, __be32 *laddr, __be16 *rport,
+				__be16 *lport)
+{
+	unsigned int outside_hdrlen = ip_hdrlen(skb);
+	struct iphdr *inside_iph, _inside_iph;
+	struct icmphdr *icmph, _icmph;
+	__be16 *ports, _ports[2];
+
+	icmph = skb_header_pointer(skb, outside_hdrlen,
+				   sizeof(_icmph), &_icmph);
+	if (icmph == NULL)
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
+	if (inside_iph == NULL)
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
+	if (ports == NULL)
+		return 1;
+
+	/* The inside IP packet is the one quoted from our side, thus
+	 * its saddr is the local address.
+	 */
+
+	*protocol = inside_iph->protocol;
+	*laddr = inside_iph->saddr;
+	*lport = ports[0];
+	*raddr = inside_iph->daddr;
+	*rport = ports[1];
+
+	return 0;
+}
+
+static struct sock *xt_get_sk_v4(struct net *net, const u8 protocol,
+				 const __be32 saddr, const __be32 daddr,
+				 const __be16 sport, const __be16 dport,
+				 const struct net_device *in)
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
+
+	return NULL;
+}
+
+static struct sock *xt_sk_lookup(const struct sk_buff *skb,
+				 const struct net_device *indev)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	__be32 uninitialized_var(daddr), uninitialized_var(saddr);
+	__be16 uninitialized_var(dport), uninitialized_var(sport);
+	u8 uninitialized_var(protocol);
+#ifdef XT_HAVE_CONNTRACK
+	struct nf_conn const *ct;
+	enum ip_conntrack_info ctinfo;
+#endif
+
+	if (iph->protocol == IPPROTO_UDP || iph->protocol == IPPROTO_TCP) {
+		struct udphdr _hdr, *hp = NULL;
+
+		hp = skb_header_pointer(skb, ip_hdrlen(skb),
+					sizeof(_hdr), &_hdr);
+		if (hp == NULL)
+			return NULL;
+
+		protocol = iph->protocol;
+
+		saddr = iph->saddr;
+		daddr = iph->daddr;
+
+		sport = hp->source;
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
+#ifdef XT_HAVE_CONNTRACK
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
+	return xt_get_sk_v4(dev_net(skb->dev), protocol, saddr, daddr,
+			    sport, dport, indev);
+}
+
+#ifdef XT_HAVE_IPV6
+static int extract_icmp6_fields(const struct sk_buff *skb,
+				unsigned int outside_hdrlen,
+				int *protocol,
+				const struct in6_addr **raddr,
+				const struct in6_addr **laddr,
+				__be16 *rport, __be16 *lport,
+				struct ipv6hdr *ipv6_var)
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
+	if (icmph == NULL)
+		return 1;
+
+	if (icmph->icmp6_type & ICMPV6_INFOMSG_MASK)
+		return 1;
+
+	inside_iph = skb_header_pointer(skb, outside_hdrlen + sizeof(_icmph),
+					sizeof(*ipv6_var), ipv6_var);
+	if (inside_iph == NULL)
+		return 1;
+
+	inside_nexthdr = inside_iph->nexthdr;
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
+	if (ports == NULL)
+		return 1;
+
+	/* The inside IP packet is the one quoted from our side, thus
+	 * its saddr is the local address.
+	 */
+
+	*protocol = inside_nexthdr;
+	*laddr = &inside_iph->saddr;
+	*lport = ports[0];
+	*raddr = &inside_iph->daddr;
+	*rport = ports[1];
+
+	return 0;
+}
+
+static struct sock *xt_get_sk_v6(struct net *net, const u8 protocol,
+				 const struct in6_addr *saddr,
+				 const struct in6_addr *daddr,
+				 const __be16 sport, const __be16 dport,
+				 const struct net_device *in)
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
+static struct sock *xt_sk_lookup6(const struct sk_buff *skb,
+				  const struct net_device *indev)
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
+		if (hp == NULL)
+			return NULL;
+
+		saddr = &iph->saddr;
+		daddr = &iph->daddr;
+
+		sport = hp->source;
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
+	return xt_get_sk_v6(dev_net(skb->dev), tproto, saddr, daddr,
+			    sport, dport, indev);
+}
+#endif /* XT_HAVE_IPV6 */
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 895534e..570ae6e 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -7,90 +7,18 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
  */
+
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <net/tcp.h>
-#include <net/udp.h>
-#include <net/icmp.h>
-#include <net/sock.h>
-#include <net/inet_sock.h>
-#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
-
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-#define XT_SOCKET_HAVE_IPV6 1
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <net/inet6_hashtables.h>
-#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
-#endif
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_socket.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
 
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
+#include "xt_sk_helper.h"
 
 /* "socket" match based redirection (no specific rule)
  * ===================================================
@@ -111,23 +39,6 @@ extract_icmp4_fields(const struct sk_buff *skb,
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
@@ -147,63 +58,13 @@ static bool
 socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 	     const struct xt_socket_mtinfo1 *info)
 {
-	const struct iphdr *iph = ip_hdr(skb);
-	struct udphdr _hdr, *hp = NULL;
 	struct sock *sk = skb->sk;
-	__be32 uninitialized_var(daddr), uninitialized_var(saddr);
-	__be16 uninitialized_var(dport), uninitialized_var(sport);
-	u8 uninitialized_var(protocol);
-#ifdef XT_SOCKET_HAVE_CONNTRACK
-	struct nf_conn const *ct;
-	enum ip_conntrack_info ctinfo;
-#endif
-
-	if (iph->protocol == IPPROTO_UDP || iph->protocol == IPPROTO_TCP) {
-		hp = skb_header_pointer(skb, ip_hdrlen(skb),
-					sizeof(_hdr), &_hdr);
-		if (hp == NULL)
-			return false;
-
-		protocol = iph->protocol;
-		saddr = iph->saddr;
-		sport = hp->source;
-		daddr = iph->daddr;
-		dport = hp->dest;
-
-	} else if (iph->protocol == IPPROTO_ICMP) {
-		if (extract_icmp4_fields(skb, &protocol, &saddr, &daddr,
-					&sport, &dport))
-			return false;
-	} else {
-		return false;
-	}
-
-#ifdef XT_SOCKET_HAVE_CONNTRACK
-	/* Do the lookup with the original socket address in case this is a
-	 * reply packet of an established SNAT-ted connection. */
-
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
 
 	if (!sk)
-		sk = xt_socket_get_sock_v4(dev_net(skb->dev), protocol,
-					   saddr, daddr, sport, dport,
-					   par->in);
+		sk = xt_sk_lookup(skb, par->in);
 	if (sk) {
-		bool wildcard;
 		bool transparent = true;
+		bool wildcard;
 
 		/* Ignore sockets listening on INADDR_ANY,
 		 * unless XT_SOCKET_NOWILDCARD is set
@@ -225,12 +86,7 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 			sk = NULL;
 	}
 
-	pr_debug("proto %hhu %pI4:%hu -> %pI4:%hu (orig %pI4:%hu) sock %p\n",
-		 protocol, &saddr, ntohs(sport),
-		 &daddr, ntohs(dport),
-		 &iph->daddr, hp ? ntohs(hp->dest) : 0, sk);
-
-	return (sk != NULL);
+	return sk != NULL;
 }
 
 static bool
@@ -249,127 +105,18 @@ socket_mt4_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
 	return socket_match(skb, par, par->matchinfo);
 }
 
-#ifdef XT_SOCKET_HAVE_IPV6
-
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
+#ifdef XT_HAVE_IPV6
 static bool
 socket_mt6_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
 {
-	struct ipv6hdr ipv6_var, *iph = ipv6_hdr(skb);
-	struct udphdr _hdr, *hp = NULL;
-	struct sock *sk = skb->sk;
-	const struct in6_addr *daddr = NULL, *saddr = NULL;
-	__be16 uninitialized_var(dport), uninitialized_var(sport);
-	int thoff = 0, uninitialized_var(tproto);
 	const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
-
-	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
-	if (tproto < 0) {
-		pr_debug("unable to find transport header in IPv6 packet, dropping\n");
-		return NF_DROP;
-	}
-
-	if (tproto == IPPROTO_UDP || tproto == IPPROTO_TCP) {
-		hp = skb_header_pointer(skb, thoff,
-					sizeof(_hdr), &_hdr);
-		if (hp == NULL)
-			return false;
-
-		saddr = &iph->saddr;
-		sport = hp->source;
-		daddr = &iph->daddr;
-		dport = hp->dest;
-
-	} else if (tproto == IPPROTO_ICMPV6) {
-		if (extract_icmp6_fields(skb, thoff, &tproto, &saddr, &daddr,
-					 &sport, &dport, &ipv6_var))
-			return false;
-	} else {
-		return false;
-	}
+	struct sock *sk = skb->sk;
 
 	if (!sk)
-		sk = xt_socket_get_sock_v6(dev_net(skb->dev), tproto,
-					   saddr, daddr, sport, dport,
-					   par->in);
+		sk = xt_sk_lookup6(skb, par->in);
 	if (sk) {
-		bool wildcard;
 		bool transparent = true;
+		bool wildcard;
 
 		/* Ignore sockets listening on INADDR_ANY
 		 * unless XT_SOCKET_NOWILDCARD is set
@@ -391,13 +138,7 @@ socket_mt6_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
 			sk = NULL;
 	}
 
-	pr_debug("proto %hhd %pI6:%hu -> %pI6:%hu "
-		 "(orig %pI6:%hu) sock %p\n",
-		 tproto, saddr, ntohs(sport),
-		 daddr, ntohs(dport),
-		 &iph->daddr, hp ? ntohs(hp->dest) : 0, sk);
-
-	return (sk != NULL);
+	return sk != NULL;
 }
 #endif
 
@@ -409,6 +150,7 @@ static int socket_mt_v1_check(const struct xt_mtchk_param *par)
 		pr_info("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V1);
 		return -EINVAL;
 	}
+
 	return 0;
 }
 
@@ -420,6 +162,7 @@ static int socket_mt_v2_check(const struct xt_mtchk_param *par)
 		pr_info("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V2);
 		return -EINVAL;
 	}
+
 	return 0;
 }
 
@@ -444,7 +187,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 				  (1 << NF_INET_LOCAL_IN),
 		.me		= THIS_MODULE,
 	},
-#ifdef XT_SOCKET_HAVE_IPV6
+#ifdef XT_HAVE_IPV6
 	{
 		.name		= "socket",
 		.revision	= 1,
@@ -468,7 +211,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 				  (1 << NF_INET_LOCAL_IN),
 		.me		= THIS_MODULE,
 	},
-#ifdef XT_SOCKET_HAVE_IPV6
+#ifdef XT_HAVE_IPV6
 	{
 		.name		= "socket",
 		.revision	= 2,
@@ -486,7 +229,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 static int __init socket_mt_init(void)
 {
 	nf_defrag_ipv4_enable();
-#ifdef XT_SOCKET_HAVE_IPV6
+#ifdef XT_HAVE_IPV6
 	nf_defrag_ipv6_enable();
 #endif
 
-- 
1.9.3

