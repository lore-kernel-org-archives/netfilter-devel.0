From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [PATCH 11/11] TProxy: added IPv6 support to the socket match
Date: Mon, 24 Aug 2009 14:52:07 +0200
Message-ID: <700c31ea135cebf4b431117540d8dba7b2fc34ab.1251295408.git.bazsi@balabit.hu>
References: <cover.1251295408.git.bazsi@balabit.hu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Harry Mason <harry.mason@smoothwall.net>
To: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:58545 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751956AbZH2Pu0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Aug 2009 11:50:26 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id ACF6813A249
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2009 17:21:43 +0200 (CEST)
In-Reply-To: <cover.1251295408.git.bazsi@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Balazs Scheidler <bazsi@balabit.hu>
---
 net/netfilter/xt_socket.c |  111 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 105 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 12a7140..41a8383 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -14,6 +14,7 @@
 #include <linux/skbuff.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/icmp.h>
@@ -21,6 +22,7 @@
 #include <net/inet_sock.h>
 #include <net/netfilter/nf_tproxy_core.h>
 #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 
 #include <linux/netfilter/xt_socket.h>
 
@@ -30,7 +32,7 @@
 #endif
 
 static int
-extract_icmp_fields(const struct sk_buff *skb,
+extract_icmp4_fields(const struct sk_buff *skb,
 		    u8 *protocol,
 		    __be32 *raddr,
 		    __be32 *laddr,
@@ -115,7 +117,7 @@ socket_match(const struct sk_buff *skb, const struct xt_match_param *par,
 		dport = hp->dest;
 
 	} else if (iph->protocol == IPPROTO_ICMP) {
-		if (extract_icmp_fields(skb, &protocol, &saddr, &daddr,
+		if (extract_icmp4_fields(skb, &protocol, &saddr, &daddr,
 					&sport, &dport))
 			return false;
 	} else {
@@ -175,23 +177,107 @@ socket_match(const struct sk_buff *skb, const struct xt_match_param *par,
 }
 
 static bool
-socket_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
+socket_mt4_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	return socket_match(skb, par, NULL);
 }
 
 static bool
-socket_mt_v1(const struct sk_buff *skb, const struct xt_match_param *par)
+socket_mt4_v1(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	return socket_match(skb, par, par->matchinfo);
 }
 
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+
+static int
+extract_icmp6_fields(const struct sk_buff *skb,
+		     u8 *protocol,
+		     struct in6_addr **raddr,
+		     struct in6_addr **laddr,
+		     __be16 *rport,
+		     __be16 *lport)
+{
+	return 1;
+}
+
+static bool
+socket_mt6_v1(const struct sk_buff *skb, const struct xt_match_param *par)
+{
+	struct ipv6hdr *iph = ipv6_hdr(skb);
+	struct udphdr _hdr, *hp = NULL;
+	struct sock *sk;
+	struct in6_addr *daddr, *saddr;
+	__be16 dport, sport;
+        int thoff;
+	u8 tproto;
+        const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
+        
+        tproto = ipv6_find_hdr(skb, &thoff, -1, NULL);
+        if (tproto < 0) {
+		pr_debug("socket match: Unable to find transport header in IPv6 packet, dropping\n");
+		return NF_DROP;
+        }
+
+	if (tproto == IPPROTO_UDP || tproto == IPPROTO_TCP) {
+		hp = skb_header_pointer(skb, thoff,
+					sizeof(_hdr), &_hdr);
+		if (hp == NULL)
+			return false;
+
+		saddr = &iph->saddr;
+		sport = hp->source;
+		daddr = &iph->daddr;
+		dport = hp->dest;
+
+	} else if (tproto == IPPROTO_ICMP) {
+		if (extract_icmp6_fields(skb, &tproto, &saddr, &daddr,
+					&sport, &dport))
+			return false;
+	} else {
+		return false;
+	}
+
+	sk = nf_tproxy_get_sock_v6(dev_net(skb->dev), tproto,
+				   saddr, daddr, sport, dport, par->in, NFT_LOOKUP_ANY);
+	if (sk != NULL) {
+		bool wildcard;
+		bool transparent = true;
+
+		/* Ignore sockets listening on INADDR_ANY */
+		wildcard = (sk->sk_state != TCP_TIME_WAIT &&
+			    ipv6_addr_any(&inet6_sk(sk)->rcv_saddr));
+
+		/* Ignore non-transparent sockets,
+		   if XT_SOCKET_TRANSPARENT is used */
+		if (info && info->flags & XT_SOCKET_TRANSPARENT)
+			transparent = ((sk->sk_state != TCP_TIME_WAIT &&
+					inet_sk(sk)->transparent) ||
+				       (sk->sk_state == TCP_TIME_WAIT &&
+					inet_twsk(sk)->tw_transparent));
+
+		nf_tproxy_put_sock(sk);
+
+		if (wildcard || !transparent)
+			sk = NULL;
+	}
+
+	pr_debug("socket match: proto %u %pI6:%u -> %pI6:%u "
+		 "(orig %pI6:%u) sock %p\n",
+		 tproto, saddr, ntohs(sport),
+		 daddr, ntohs(dport),
+		 &iph->daddr, hp ? ntohs(hp->dest) : 0, sk);
+
+	return (sk != NULL);
+}
+#endif
+
 static struct xt_match socket_mt_reg[] __read_mostly = {
 	{
 		.name		= "socket",
 		.revision	= 0,
 		.family		= NFPROTO_IPV4,
-		.match		= socket_mt_v0,
+		.match		= socket_mt4_v0,
 		.hooks		= 1 << NF_INET_PRE_ROUTING,
 		.me		= THIS_MODULE,
 	},
@@ -199,16 +285,28 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.name		= "socket",
 		.revision	= 1,
 		.family		= NFPROTO_IPV4,
-		.match		= socket_mt_v1,
+		.match		= socket_mt4_v1,
+		.matchsize	= sizeof(struct xt_socket_mtinfo1),
+		.hooks		= 1 << NF_INET_PRE_ROUTING,
+		.me		= THIS_MODULE,
+	},
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	{
+		.name		= "socket",
+		.revision	= 1,
+		.family		= NFPROTO_IPV6,
+		.match		= socket_mt6_v1,
 		.matchsize	= sizeof(struct xt_socket_mtinfo1),
 		.hooks		= 1 << NF_INET_PRE_ROUTING,
 		.me		= THIS_MODULE,
 	},
+#endif
 };
 
 static int __init socket_mt_init(void)
 {
 	nf_defrag_ipv4_enable();
+	nf_defrag_ipv6_enable();
 	return xt_register_matches(socket_mt_reg, ARRAY_SIZE(socket_mt_reg));
 }
 
@@ -224,3 +322,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Krisztian Kovacs, Balazs Scheidler");
 MODULE_DESCRIPTION("x_tables socket match module");
 MODULE_ALIAS("ipt_socket");
+MODULE_ALIAS("ip6t_socket");
-- 
1.6.0.4


