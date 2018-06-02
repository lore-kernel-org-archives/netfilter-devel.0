From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/9] netfilter: Libify xt_TPROXY
Date: Sun,  3 Jun 2018 01:14:06 +0200
Message-ID: <20180602231413.31974-3-pablo@netfilter.org>
References: <20180602231413.31974-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602231413.31974-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

The extracted functions will likely be usefull to implement tproxy
support in nf_tables.

Extrancted functions:
	- nf_tproxy_sk_is_transparent
	- nf_tproxy_laddr4
	- nf_tproxy_handle_time_wait4
	- nf_tproxy_get_sock_v4
	- nf_tproxy_laddr6
	- nf_tproxy_handle_time_wait6
	- nf_tproxy_get_sock_v6

(nf_)tproxy_handle_time_wait6 also needed some refactor as its current
implementation was xtables-specific.

Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tproxy.h   | 113 ++++++++++++
 net/ipv4/netfilter/Kconfig          |   5 +-
 net/ipv4/netfilter/Makefile         |   1 +
 net/ipv4/netfilter/nf_tproxy_ipv4.c | 147 +++++++++++++++
 net/ipv6/netfilter/Kconfig          |   5 +-
 net/ipv6/netfilter/Makefile         |   1 +
 net/ipv6/netfilter/nf_tproxy_ipv6.c | 146 +++++++++++++++
 net/netfilter/Kconfig               |   2 +
 net/netfilter/xt_TPROXY.c           | 355 ++----------------------------------
 9 files changed, 436 insertions(+), 339 deletions(-)
 create mode 100644 include/net/netfilter/nf_tproxy.h
 create mode 100644 net/ipv4/netfilter/nf_tproxy_ipv4.c
 create mode 100644 net/ipv6/netfilter/nf_tproxy_ipv6.c

diff --git a/include/net/netfilter/nf_tproxy.h b/include/net/netfilter/nf_tproxy.h
new file mode 100644
index 000000000000..9754a50ecde9
--- /dev/null
+++ b/include/net/netfilter/nf_tproxy.h
@@ -0,0 +1,113 @@
+#ifndef _NF_TPROXY_H_
+#define _NF_TPROXY_H_
+
+#include <net/tcp.h>
+
+enum nf_tproxy_lookup_t {
+	 NF_TPROXY_LOOKUP_LISTENER,
+	 NF_TPROXY_LOOKUP_ESTABLISHED,
+};
+
+static inline bool nf_tproxy_sk_is_transparent(struct sock *sk)
+{
+	if (inet_sk_transparent(sk))
+		return true;
+
+	sock_gen_put(sk);
+	return false;
+}
+
+__be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr);
+
+/**
+ * nf_tproxy_handle_time_wait4 - handle IPv4 TCP TIME_WAIT reopen redirections
+ * @skb:	The skb being processed.
+ * @laddr:	IPv4 address to redirect to or zero.
+ * @lport:	TCP port to redirect to or zero.
+ * @sk:		The TIME_WAIT TCP socket found by the lookup.
+ *
+ * We have to handle SYN packets arriving to TIME_WAIT sockets
+ * differently: instead of reopening the connection we should rather
+ * redirect the new connection to the proxy if there's a listener
+ * socket present.
+ *
+ * nf_tproxy_handle_time_wait4() consumes the socket reference passed in.
+ *
+ * Returns the listener socket if there's one, the TIME_WAIT socket if
+ * no such listener is found, or NULL if the TCP header is incomplete.
+ */
+struct sock *
+nf_tproxy_handle_time_wait4(struct net *net, struct sk_buff *skb,
+			    __be32 laddr, __be16 lport, struct sock *sk);
+
+/*
+ * This is used when the user wants to intercept a connection matching
+ * an explicit iptables rule. In this case the sockets are assumed
+ * matching in preference order:
+ *
+ *   - match: if there's a fully established connection matching the
+ *     _packet_ tuple, it is returned, assuming the redirection
+ *     already took place and we process a packet belonging to an
+ *     established connection
+ *
+ *   - match: if there's a listening socket matching the redirection
+ *     (e.g. on-port & on-ip of the connection), it is returned,
+ *     regardless if it was bound to 0.0.0.0 or an explicit
+ *     address. The reasoning is that if there's an explicit rule, it
+ *     does not really matter if the listener is bound to an interface
+ *     or to 0. The user already stated that he wants redirection
+ *     (since he added the rule).
+ *
+ * Please note that there's an overlap between what a TPROXY target
+ * and a socket match will match. Normally if you have both rules the
+ * "socket" match will be the first one, effectively all packets
+ * belonging to established connections going through that one.
+ */
+struct sock *
+nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb, void *hp,
+		      const u8 protocol,
+		      const __be32 saddr, const __be32 daddr,
+		      const __be16 sport, const __be16 dport,
+		      const struct net_device *in,
+		      const enum nf_tproxy_lookup_t lookup_type);
+
+const struct in6_addr *
+nf_tproxy_laddr6(struct sk_buff *skb, const struct in6_addr *user_laddr,
+		 const struct in6_addr *daddr);
+
+/**
+ * nf_tproxy_handle_time_wait6 - handle IPv6 TCP TIME_WAIT reopen redirections
+ * @skb:	The skb being processed.
+ * @tproto:	Transport protocol.
+ * @thoff:	Transport protocol header offset.
+ * @net:	Network namespace.
+ * @laddr:	IPv6 address to redirect to.
+ * @lport:	TCP port to redirect to or zero.
+ * @sk:		The TIME_WAIT TCP socket found by the lookup.
+ *
+ * We have to handle SYN packets arriving to TIME_WAIT sockets
+ * differently: instead of reopening the connection we should rather
+ * redirect the new connection to the proxy if there's a listener
+ * socket present.
+ *
+ * nf_tproxy_handle_time_wait6() consumes the socket reference passed in.
+ *
+ * Returns the listener socket if there's one, the TIME_WAIT socket if
+ * no such listener is found, or NULL if the TCP header is incomplete.
+ */
+struct sock *
+nf_tproxy_handle_time_wait6(struct sk_buff *skb, int tproto, int thoff,
+			    struct net *net,
+			    const struct in6_addr *laddr,
+			    const __be16 lport,
+			    struct sock *sk);
+
+struct sock *
+nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff, void *hp,
+		      const u8 protocol,
+		      const struct in6_addr *saddr, const struct in6_addr *daddr,
+		      const __be16 sport, const __be16 dport,
+		      const struct net_device *in,
+		      const enum nf_tproxy_lookup_t lookup_type);
+
+#endif /* _NF_TPROXY_H_ */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index d03bc5a01a70..bbfc356cb1b5 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -29,7 +29,10 @@ config NF_SOCKET_IPV4
 	tristate "IPv4 socket lookup support"
 	help
 	  This option enables the IPv4 socket lookup infrastructure. This is
-	  is required by the iptables socket match.
+	  is required by the {ip,nf}tables socket match.
+
+config NF_TPROXY_IPV4
+	tristate "IPv4 tproxy support"
 
 if NF_TABLES
 
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index c4b05b174091..8394c17c269f 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_NF_NAT_IPV4) += nf_nat_ipv4.o
 obj-$(CONFIG_NF_DEFRAG_IPV4) += nf_defrag_ipv4.o
 
 obj-$(CONFIG_NF_SOCKET_IPV4) += nf_socket_ipv4.o
+obj-$(CONFIG_NF_TPROXY_IPV4) += nf_tproxy_ipv4.o
 
 # logging
 obj-$(CONFIG_NF_LOG_ARP) += nf_log_arp.o
diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
new file mode 100644
index 000000000000..805e83ec3ad9
--- /dev/null
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -0,0 +1,147 @@
+/*
+ * Copyright (C) 2007-2008 BalaBit IT Ltd.
+ * Author: Krisztian Kovacs
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <net/netfilter/nf_tproxy.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/sock.h>
+#include <net/inet_sock.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+#include <net/udp.h>
+#include <net/tcp.h>
+#include <linux/inetdevice.h>
+
+struct sock *
+nf_tproxy_handle_time_wait4(struct net *net, struct sk_buff *skb,
+			 __be32 laddr, __be16 lport, struct sock *sk)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	struct tcphdr _hdr, *hp;
+
+	hp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_hdr), &_hdr);
+	if (hp == NULL) {
+		inet_twsk_put(inet_twsk(sk));
+		return NULL;
+	}
+
+	if (hp->syn && !hp->rst && !hp->ack && !hp->fin) {
+		/* SYN to a TIME_WAIT socket, we'd rather redirect it
+		 * to a listener socket if there's one */
+		struct sock *sk2;
+
+		sk2 = nf_tproxy_get_sock_v4(net, skb, hp, iph->protocol,
+					    iph->saddr, laddr ? laddr : iph->daddr,
+					    hp->source, lport ? lport : hp->dest,
+					    skb->dev, NF_TPROXY_LOOKUP_LISTENER);
+		if (sk2) {
+			inet_twsk_deschedule_put(inet_twsk(sk));
+			sk = sk2;
+		}
+	}
+
+	return sk;
+}
+EXPORT_SYMBOL_GPL(nf_tproxy_handle_time_wait4);
+
+__be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
+{
+	struct in_device *indev;
+	__be32 laddr;
+
+	if (user_laddr)
+		return user_laddr;
+
+	laddr = 0;
+	indev = __in_dev_get_rcu(skb->dev);
+	for_primary_ifa(indev) {
+		laddr = ifa->ifa_local;
+		break;
+	} endfor_ifa(indev);
+
+	return laddr ? laddr : daddr;
+}
+EXPORT_SYMBOL_GPL(nf_tproxy_laddr4);
+
+struct sock *
+nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb, void *hp,
+		      const u8 protocol,
+		      const __be32 saddr, const __be32 daddr,
+		      const __be16 sport, const __be16 dport,
+		      const struct net_device *in,
+		      const enum nf_tproxy_lookup_t lookup_type)
+{
+	struct sock *sk;
+	struct tcphdr *tcph;
+
+	switch (protocol) {
+	case IPPROTO_TCP:
+		switch (lookup_type) {
+		case NF_TPROXY_LOOKUP_LISTENER:
+			tcph = hp;
+			sk = inet_lookup_listener(net, &tcp_hashinfo, skb,
+						    ip_hdrlen(skb) +
+						      __tcp_hdrlen(tcph),
+						    saddr, sport,
+						    daddr, dport,
+						    in->ifindex, 0);
+
+			if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
+				sk = NULL;
+			/* NOTE: we return listeners even if bound to
+			 * 0.0.0.0, those are filtered out in
+			 * xt_socket, since xt_TPROXY needs 0 bound
+			 * listeners too
+			 */
+			break;
+		case NF_TPROXY_LOOKUP_ESTABLISHED:
+			sk = inet_lookup_established(net, &tcp_hashinfo,
+						    saddr, sport, daddr, dport,
+						    in->ifindex);
+			break;
+		default:
+			BUG();
+		}
+		break;
+	case IPPROTO_UDP:
+		sk = udp4_lib_lookup(net, saddr, sport, daddr, dport,
+				     in->ifindex);
+		if (sk) {
+			int connected = (sk->sk_state == TCP_ESTABLISHED);
+			int wildcard = (inet_sk(sk)->inet_rcv_saddr == 0);
+
+			/* NOTE: we return listeners even if bound to
+			 * 0.0.0.0, those are filtered out in
+			 * xt_socket, since xt_TPROXY needs 0 bound
+			 * listeners too
+			 */
+			if ((lookup_type == NF_TPROXY_LOOKUP_ESTABLISHED &&
+			      (!connected || wildcard)) ||
+			    (lookup_type == NF_TPROXY_LOOKUP_LISTENER && connected)) {
+				sock_put(sk);
+				sk = NULL;
+			}
+		}
+		break;
+	default:
+		WARN_ON(1);
+		sk = NULL;
+	}
+
+	pr_debug("tproxy socket lookup: proto %u %08x:%u -> %08x:%u, lookup type: %d, sock %p\n",
+		 protocol, ntohl(saddr), ntohs(sport), ntohl(daddr), ntohs(dport), lookup_type, sk);
+
+	return sk;
+}
+EXPORT_SYMBOL_GPL(nf_tproxy_get_sock_v4);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Balazs Scheidler, Krisztian Kovacs");
+MODULE_DESCRIPTION("Netfilter IPv4 transparent proxy support");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 9f5b00a39adf..37b14dc9d863 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -29,7 +29,10 @@ config NF_SOCKET_IPV6
 	tristate "IPv6 socket lookup support"
 	help
 	  This option enables the IPv6 socket lookup infrastructure. This
-	  is used by the ip6tables socket match.
+	  is used by the {ip6,nf}tables socket match.
+
+config NF_TPROXY_IPV6
+	tristate "IPv6 tproxy support"
 
 if NF_TABLES
 
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 71518f22ae39..10a5a1c87320 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -26,6 +26,7 @@ nf_defrag_ipv6-y := nf_defrag_ipv6_hooks.o nf_conntrack_reasm.o
 obj-$(CONFIG_NF_DEFRAG_IPV6) += nf_defrag_ipv6.o
 
 obj-$(CONFIG_NF_SOCKET_IPV6) += nf_socket_ipv6.o
+obj-$(CONFIG_NF_TPROXY_IPV6) += nf_tproxy_ipv6.o
 
 # logging
 obj-$(CONFIG_NF_LOG_IPV6) += nf_log_ipv6.o
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
new file mode 100644
index 000000000000..bf1d6c421e3b
--- /dev/null
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -0,0 +1,146 @@
+#include <net/netfilter/nf_tproxy.h>
+#include <linux/module.h>
+#include <net/inet6_hashtables.h>
+#include <net/addrconf.h>
+#include <net/udp.h>
+#include <net/tcp.h>
+
+const struct in6_addr *
+nf_tproxy_laddr6(struct sk_buff *skb, const struct in6_addr *user_laddr,
+	      const struct in6_addr *daddr)
+{
+	struct inet6_dev *indev;
+	struct inet6_ifaddr *ifa;
+	struct in6_addr *laddr;
+
+	if (!ipv6_addr_any(user_laddr))
+		return user_laddr;
+	laddr = NULL;
+
+	indev = __in6_dev_get(skb->dev);
+	if (indev) {
+		read_lock_bh(&indev->lock);
+		list_for_each_entry(ifa, &indev->addr_list, if_list) {
+			if (ifa->flags & (IFA_F_TENTATIVE | IFA_F_DEPRECATED))
+				continue;
+
+			laddr = &ifa->addr;
+			break;
+		}
+		read_unlock_bh(&indev->lock);
+	}
+
+	return laddr ? laddr : daddr;
+}
+EXPORT_SYMBOL_GPL(nf_tproxy_laddr6);
+
+struct sock *
+nf_tproxy_handle_time_wait6(struct sk_buff *skb, int tproto, int thoff,
+			 struct net *net,
+			 const struct in6_addr *laddr,
+			 const __be16 lport,
+			 struct sock *sk)
+{
+	const struct ipv6hdr *iph = ipv6_hdr(skb);
+	struct tcphdr _hdr, *hp;
+
+	hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
+	if (hp == NULL) {
+		inet_twsk_put(inet_twsk(sk));
+		return NULL;
+	}
+
+	if (hp->syn && !hp->rst && !hp->ack && !hp->fin) {
+		/* SYN to a TIME_WAIT socket, we'd rather redirect it
+		 * to a listener socket if there's one */
+		struct sock *sk2;
+
+		sk2 = nf_tproxy_get_sock_v6(net, skb, thoff, hp, tproto,
+					    &iph->saddr,
+					    nf_tproxy_laddr6(skb, laddr, &iph->daddr),
+					    hp->source,
+					    lport ? lport : hp->dest,
+					    skb->dev, NF_TPROXY_LOOKUP_LISTENER);
+		if (sk2) {
+			inet_twsk_deschedule_put(inet_twsk(sk));
+			sk = sk2;
+		}
+	}
+
+	return sk;
+}
+EXPORT_SYMBOL_GPL(nf_tproxy_handle_time_wait6);
+
+struct sock *
+nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff, void *hp,
+		      const u8 protocol,
+		      const struct in6_addr *saddr, const struct in6_addr *daddr,
+		      const __be16 sport, const __be16 dport,
+		      const struct net_device *in,
+		      const enum nf_tproxy_lookup_t lookup_type)
+{
+	struct sock *sk;
+	struct tcphdr *tcph;
+
+	switch (protocol) {
+	case IPPROTO_TCP:
+		switch (lookup_type) {
+		case NF_TPROXY_LOOKUP_LISTENER:
+			tcph = hp;
+			sk = inet6_lookup_listener(net, &tcp_hashinfo, skb,
+						   thoff + __tcp_hdrlen(tcph),
+						   saddr, sport,
+						   daddr, ntohs(dport),
+						   in->ifindex, 0);
+
+			if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
+				sk = NULL;
+			/* NOTE: we return listeners even if bound to
+			 * 0.0.0.0, those are filtered out in
+			 * xt_socket, since xt_TPROXY needs 0 bound
+			 * listeners too
+			 */
+			break;
+		case NF_TPROXY_LOOKUP_ESTABLISHED:
+			sk = __inet6_lookup_established(net, &tcp_hashinfo,
+							saddr, sport, daddr, ntohs(dport),
+							in->ifindex, 0);
+			break;
+		default:
+			BUG();
+		}
+		break;
+	case IPPROTO_UDP:
+		sk = udp6_lib_lookup(net, saddr, sport, daddr, dport,
+				     in->ifindex);
+		if (sk) {
+			int connected = (sk->sk_state == TCP_ESTABLISHED);
+			int wildcard = ipv6_addr_any(&sk->sk_v6_rcv_saddr);
+
+			/* NOTE: we return listeners even if bound to
+			 * 0.0.0.0, those are filtered out in
+			 * xt_socket, since xt_TPROXY needs 0 bound
+			 * listeners too
+			 */
+			if ((lookup_type == NF_TPROXY_LOOKUP_ESTABLISHED && (!connected || wildcard)) ||
+			    (lookup_type == NF_TPROXY_LOOKUP_LISTENER && connected)) {
+				sock_put(sk);
+				sk = NULL;
+			}
+		}
+		break;
+	default:
+		WARN_ON(1);
+		sk = NULL;
+	}
+
+	pr_debug("tproxy socket lookup: proto %u %pI6:%u -> %pI6:%u, lookup type: %d, sock %p\n",
+		 protocol, saddr, ntohs(sport), daddr, ntohs(dport), lookup_type, sk);
+
+	return sk;
+}
+EXPORT_SYMBOL_GPL(nf_tproxy_get_sock_v6);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Balazs Scheidler, Krisztian Kovacs");
+MODULE_DESCRIPTION("Netfilter IPv4 transparent proxy support");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 276e1e32f44e..41240abd755f 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -989,6 +989,8 @@ config NETFILTER_XT_TARGET_TPROXY
 	depends on IP_NF_MANGLE
 	select NF_DEFRAG_IPV4
 	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES != n
+	select NF_TPROXY_IPV4
+	select NF_TPROXY_IPV6 if IP6_NF_IPTABLES
 	help
 	  This option adds a `TPROXY' target, which is somewhat similar to
 	  REDIRECT.  It can only be used in the mangle table and is useful
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 74df7977c17c..58fce4e749a9 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -33,253 +33,9 @@
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #endif
 
+#include <net/netfilter/nf_tproxy.h>
 #include <linux/netfilter/xt_TPROXY.h>
 
-enum nf_tproxy_lookup_t {
-	 NFT_LOOKUP_LISTENER,
-	 NFT_LOOKUP_ESTABLISHED,
-};
-
-static bool tproxy_sk_is_transparent(struct sock *sk)
-{
-	if (inet_sk_transparent(sk))
-		return true;
-
-	sock_gen_put(sk);
-	return false;
-}
-
-static inline __be32
-tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
-{
-	struct in_device *indev;
-	__be32 laddr;
-
-	if (user_laddr)
-		return user_laddr;
-
-	laddr = 0;
-	indev = __in_dev_get_rcu(skb->dev);
-	for_primary_ifa(indev) {
-		laddr = ifa->ifa_local;
-		break;
-	} endfor_ifa(indev);
-
-	return laddr ? laddr : daddr;
-}
-
-/*
- * This is used when the user wants to intercept a connection matching
- * an explicit iptables rule. In this case the sockets are assumed
- * matching in preference order:
- *
- *   - match: if there's a fully established connection matching the
- *     _packet_ tuple, it is returned, assuming the redirection
- *     already took place and we process a packet belonging to an
- *     established connection
- *
- *   - match: if there's a listening socket matching the redirection
- *     (e.g. on-port & on-ip of the connection), it is returned,
- *     regardless if it was bound to 0.0.0.0 or an explicit
- *     address. The reasoning is that if there's an explicit rule, it
- *     does not really matter if the listener is bound to an interface
- *     or to 0. The user already stated that he wants redirection
- *     (since he added the rule).
- *
- * Please note that there's an overlap between what a TPROXY target
- * and a socket match will match. Normally if you have both rules the
- * "socket" match will be the first one, effectively all packets
- * belonging to established connections going through that one.
- */
-static inline struct sock *
-nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb, void *hp,
-		      const u8 protocol,
-		      const __be32 saddr, const __be32 daddr,
-		      const __be16 sport, const __be16 dport,
-		      const struct net_device *in,
-		      const enum nf_tproxy_lookup_t lookup_type)
-{
-	struct sock *sk;
-	struct tcphdr *tcph;
-
-	switch (protocol) {
-	case IPPROTO_TCP:
-		switch (lookup_type) {
-		case NFT_LOOKUP_LISTENER:
-			tcph = hp;
-			sk = inet_lookup_listener(net, &tcp_hashinfo, skb,
-						    ip_hdrlen(skb) +
-						      __tcp_hdrlen(tcph),
-						    saddr, sport,
-						    daddr, dport,
-						    in->ifindex, 0);
-
-			if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
-				sk = NULL;
-			/* NOTE: we return listeners even if bound to
-			 * 0.0.0.0, those are filtered out in
-			 * xt_socket, since xt_TPROXY needs 0 bound
-			 * listeners too
-			 */
-			break;
-		case NFT_LOOKUP_ESTABLISHED:
-			sk = inet_lookup_established(net, &tcp_hashinfo,
-						    saddr, sport, daddr, dport,
-						    in->ifindex);
-			break;
-		default:
-			BUG();
-		}
-		break;
-	case IPPROTO_UDP:
-		sk = udp4_lib_lookup(net, saddr, sport, daddr, dport,
-				     in->ifindex);
-		if (sk) {
-			int connected = (sk->sk_state == TCP_ESTABLISHED);
-			int wildcard = (inet_sk(sk)->inet_rcv_saddr == 0);
-
-			/* NOTE: we return listeners even if bound to
-			 * 0.0.0.0, those are filtered out in
-			 * xt_socket, since xt_TPROXY needs 0 bound
-			 * listeners too
-			 */
-			if ((lookup_type == NFT_LOOKUP_ESTABLISHED && (!connected || wildcard)) ||
-			    (lookup_type == NFT_LOOKUP_LISTENER && connected)) {
-				sock_put(sk);
-				sk = NULL;
-			}
-		}
-		break;
-	default:
-		WARN_ON(1);
-		sk = NULL;
-	}
-
-	pr_debug("tproxy socket lookup: proto %u %08x:%u -> %08x:%u, lookup type: %d, sock %p\n",
-		 protocol, ntohl(saddr), ntohs(sport), ntohl(daddr), ntohs(dport), lookup_type, sk);
-
-	return sk;
-}
-
-#ifdef XT_TPROXY_HAVE_IPV6
-static inline struct sock *
-nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff, void *hp,
-		      const u8 protocol,
-		      const struct in6_addr *saddr, const struct in6_addr *daddr,
-		      const __be16 sport, const __be16 dport,
-		      const struct net_device *in,
-		      const enum nf_tproxy_lookup_t lookup_type)
-{
-	struct sock *sk;
-	struct tcphdr *tcph;
-
-	switch (protocol) {
-	case IPPROTO_TCP:
-		switch (lookup_type) {
-		case NFT_LOOKUP_LISTENER:
-			tcph = hp;
-			sk = inet6_lookup_listener(net, &tcp_hashinfo, skb,
-						   thoff + __tcp_hdrlen(tcph),
-						   saddr, sport,
-						   daddr, ntohs(dport),
-						   in->ifindex, 0);
-
-			if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
-				sk = NULL;
-			/* NOTE: we return listeners even if bound to
-			 * 0.0.0.0, those are filtered out in
-			 * xt_socket, since xt_TPROXY needs 0 bound
-			 * listeners too
-			 */
-			break;
-		case NFT_LOOKUP_ESTABLISHED:
-			sk = __inet6_lookup_established(net, &tcp_hashinfo,
-							saddr, sport, daddr, ntohs(dport),
-							in->ifindex, 0);
-			break;
-		default:
-			BUG();
-		}
-		break;
-	case IPPROTO_UDP:
-		sk = udp6_lib_lookup(net, saddr, sport, daddr, dport,
-				     in->ifindex);
-		if (sk) {
-			int connected = (sk->sk_state == TCP_ESTABLISHED);
-			int wildcard = ipv6_addr_any(&sk->sk_v6_rcv_saddr);
-
-			/* NOTE: we return listeners even if bound to
-			 * 0.0.0.0, those are filtered out in
-			 * xt_socket, since xt_TPROXY needs 0 bound
-			 * listeners too
-			 */
-			if ((lookup_type == NFT_LOOKUP_ESTABLISHED && (!connected || wildcard)) ||
-			    (lookup_type == NFT_LOOKUP_LISTENER && connected)) {
-				sock_put(sk);
-				sk = NULL;
-			}
-		}
-		break;
-	default:
-		WARN_ON(1);
-		sk = NULL;
-	}
-
-	pr_debug("tproxy socket lookup: proto %u %pI6:%u -> %pI6:%u, lookup type: %d, sock %p\n",
-		 protocol, saddr, ntohs(sport), daddr, ntohs(dport), lookup_type, sk);
-
-	return sk;
-}
-#endif
-
-/**
- * tproxy_handle_time_wait4 - handle IPv4 TCP TIME_WAIT reopen redirections
- * @skb:	The skb being processed.
- * @laddr:	IPv4 address to redirect to or zero.
- * @lport:	TCP port to redirect to or zero.
- * @sk:		The TIME_WAIT TCP socket found by the lookup.
- *
- * We have to handle SYN packets arriving to TIME_WAIT sockets
- * differently: instead of reopening the connection we should rather
- * redirect the new connection to the proxy if there's a listener
- * socket present.
- *
- * tproxy_handle_time_wait4() consumes the socket reference passed in.
- *
- * Returns the listener socket if there's one, the TIME_WAIT socket if
- * no such listener is found, or NULL if the TCP header is incomplete.
- */
-static struct sock *
-tproxy_handle_time_wait4(struct net *net, struct sk_buff *skb,
-			 __be32 laddr, __be16 lport, struct sock *sk)
-{
-	const struct iphdr *iph = ip_hdr(skb);
-	struct tcphdr _hdr, *hp;
-
-	hp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_hdr), &_hdr);
-	if (hp == NULL) {
-		inet_twsk_put(inet_twsk(sk));
-		return NULL;
-	}
-
-	if (hp->syn && !hp->rst && !hp->ack && !hp->fin) {
-		/* SYN to a TIME_WAIT socket, we'd rather redirect it
-		 * to a listener socket if there's one */
-		struct sock *sk2;
-
-		sk2 = nf_tproxy_get_sock_v4(net, skb, hp, iph->protocol,
-					    iph->saddr, laddr ? laddr : iph->daddr,
-					    hp->source, lport ? lport : hp->dest,
-					    skb->dev, NFT_LOOKUP_LISTENER);
-		if (sk2) {
-			inet_twsk_deschedule_put(inet_twsk(sk));
-			sk = sk2;
-		}
-	}
-
-	return sk;
-}
-
 /* assign a socket to the skb -- consumes sk */
 static void
 nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk)
@@ -308,26 +64,26 @@ tproxy_tg4(struct net *net, struct sk_buff *skb, __be32 laddr, __be16 lport,
 	sk = nf_tproxy_get_sock_v4(net, skb, hp, iph->protocol,
 				   iph->saddr, iph->daddr,
 				   hp->source, hp->dest,
-				   skb->dev, NFT_LOOKUP_ESTABLISHED);
+				   skb->dev, NF_TPROXY_LOOKUP_ESTABLISHED);
 
-	laddr = tproxy_laddr4(skb, laddr, iph->daddr);
+	laddr = nf_tproxy_laddr4(skb, laddr, iph->daddr);
 	if (!lport)
 		lport = hp->dest;
 
 	/* UDP has no TCP_TIME_WAIT state, so we never enter here */
 	if (sk && sk->sk_state == TCP_TIME_WAIT)
 		/* reopening a TIME_WAIT connection needs special handling */
-		sk = tproxy_handle_time_wait4(net, skb, laddr, lport, sk);
+		sk = nf_tproxy_handle_time_wait4(net, skb, laddr, lport, sk);
 	else if (!sk)
 		/* no, there's no established connection, check if
 		 * there's a listener on the redirected addr/port */
 		sk = nf_tproxy_get_sock_v4(net, skb, hp, iph->protocol,
 					   iph->saddr, laddr,
 					   hp->source, lport,
-					   skb->dev, NFT_LOOKUP_LISTENER);
+					   skb->dev, NF_TPROXY_LOOKUP_LISTENER);
 
 	/* NOTE: assign_sock consumes our sk reference */
-	if (sk && tproxy_sk_is_transparent(sk)) {
+	if (sk && nf_tproxy_sk_is_transparent(sk)) {
 		/* This should be in a separate target, but we don't do multiple
 		   targets on the same rule yet */
 		skb->mark = (skb->mark & ~mark_mask) ^ mark_value;
@@ -366,87 +122,6 @@ tproxy_tg4_v1(struct sk_buff *skb, const struct xt_action_param *par)
 
 #ifdef XT_TPROXY_HAVE_IPV6
 
-static inline const struct in6_addr *
-tproxy_laddr6(struct sk_buff *skb, const struct in6_addr *user_laddr,
-	      const struct in6_addr *daddr)
-{
-	struct inet6_dev *indev;
-	struct inet6_ifaddr *ifa;
-	struct in6_addr *laddr;
-
-	if (!ipv6_addr_any(user_laddr))
-		return user_laddr;
-	laddr = NULL;
-
-	indev = __in6_dev_get(skb->dev);
-	if (indev) {
-		read_lock_bh(&indev->lock);
-		list_for_each_entry(ifa, &indev->addr_list, if_list) {
-			if (ifa->flags & (IFA_F_TENTATIVE | IFA_F_DEPRECATED))
-				continue;
-
-			laddr = &ifa->addr;
-			break;
-		}
-		read_unlock_bh(&indev->lock);
-	}
-
-	return laddr ? laddr : daddr;
-}
-
-/**
- * tproxy_handle_time_wait6 - handle IPv6 TCP TIME_WAIT reopen redirections
- * @skb:	The skb being processed.
- * @tproto:	Transport protocol.
- * @thoff:	Transport protocol header offset.
- * @par:	Iptables target parameters.
- * @sk:		The TIME_WAIT TCP socket found by the lookup.
- *
- * We have to handle SYN packets arriving to TIME_WAIT sockets
- * differently: instead of reopening the connection we should rather
- * redirect the new connection to the proxy if there's a listener
- * socket present.
- *
- * tproxy_handle_time_wait6() consumes the socket reference passed in.
- *
- * Returns the listener socket if there's one, the TIME_WAIT socket if
- * no such listener is found, or NULL if the TCP header is incomplete.
- */
-static struct sock *
-tproxy_handle_time_wait6(struct sk_buff *skb, int tproto, int thoff,
-			 const struct xt_action_param *par,
-			 struct sock *sk)
-{
-	const struct ipv6hdr *iph = ipv6_hdr(skb);
-	struct tcphdr _hdr, *hp;
-	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
-
-	hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
-	if (hp == NULL) {
-		inet_twsk_put(inet_twsk(sk));
-		return NULL;
-	}
-
-	if (hp->syn && !hp->rst && !hp->ack && !hp->fin) {
-		/* SYN to a TIME_WAIT socket, we'd rather redirect it
-		 * to a listener socket if there's one */
-		struct sock *sk2;
-
-		sk2 = nf_tproxy_get_sock_v6(xt_net(par), skb, thoff, hp, tproto,
-					    &iph->saddr,
-					    tproxy_laddr6(skb, &tgi->laddr.in6, &iph->daddr),
-					    hp->source,
-					    tgi->lport ? tgi->lport : hp->dest,
-					    skb->dev, NFT_LOOKUP_LISTENER);
-		if (sk2) {
-			inet_twsk_deschedule_put(inet_twsk(sk));
-			sk = sk2;
-		}
-	}
-
-	return sk;
-}
-
 static unsigned int
 tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -478,25 +153,31 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	sk = nf_tproxy_get_sock_v6(xt_net(par), skb, thoff, hp, tproto,
 				   &iph->saddr, &iph->daddr,
 				   hp->source, hp->dest,
-				   xt_in(par), NFT_LOOKUP_ESTABLISHED);
+				   xt_in(par), NF_TPROXY_LOOKUP_ESTABLISHED);
 
-	laddr = tproxy_laddr6(skb, &tgi->laddr.in6, &iph->daddr);
+	laddr = nf_tproxy_laddr6(skb, &tgi->laddr.in6, &iph->daddr);
 	lport = tgi->lport ? tgi->lport : hp->dest;
 
 	/* UDP has no TCP_TIME_WAIT state, so we never enter here */
-	if (sk && sk->sk_state == TCP_TIME_WAIT)
+	if (sk && sk->sk_state == TCP_TIME_WAIT) {
+		const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
 		/* reopening a TIME_WAIT connection needs special handling */
-		sk = tproxy_handle_time_wait6(skb, tproto, thoff, par, sk);
+		sk = nf_tproxy_handle_time_wait6(skb, tproto, thoff,
+					      xt_net(par),
+					      &tgi->laddr.in6,
+					      tgi->lport,
+					      sk);
+	}
 	else if (!sk)
 		/* no there's no established connection, check if
 		 * there's a listener on the redirected addr/port */
 		sk = nf_tproxy_get_sock_v6(xt_net(par), skb, thoff, hp,
 					   tproto, &iph->saddr, laddr,
 					   hp->source, lport,
-					   xt_in(par), NFT_LOOKUP_LISTENER);
+					   xt_in(par), NF_TPROXY_LOOKUP_LISTENER);
 
 	/* NOTE: assign_sock consumes our sk reference */
-	if (sk && tproxy_sk_is_transparent(sk)) {
+	if (sk && nf_tproxy_sk_is_transparent(sk)) {
 		/* This should be in a separate target, but we don't do multiple
 		   targets on the same rule yet */
 		skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
-- 
2.11.0
