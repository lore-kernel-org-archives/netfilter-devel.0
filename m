From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/69]: xt_TCPMSS: consider reverse route's MTU in clamp-to-pmtu
Date: Wed, 30 Jan 2008 21:17:28 +0100 (MET)
Message-ID: <20080130201725.29874.26606.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60696 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbYA3URb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:31 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_TCPMSS: consider reverse route's MTU in clamp-to-pmtu

The TCPMSS target in Xtables should consider the MTU of the reverse
route on forwarded packets as part of the path MTU.

Point in case: IN=ppp0, OUT=eth0. MSS set to 1460 in spite of MTU of
ppp0 being 1392.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 09a855c601cbbf240e7f127705dea74317658c45
tree ee82dc3cf0ff1e97e3bfa126678b4625d3a6d7b1
parent 5925cf9534dffe7165056399a6911609bd1fb44b
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 29 Jan 2008 16:22:03 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:18 +0100

 net/netfilter/xt_TCPMSS.c |   62 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 60e3767..217e2b6 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -13,7 +13,10 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
+#include <net/dst.h>
+#include <net/flow.h>
 #include <net/ipv6.h>
+#include <net/route.h>
 #include <net/tcp.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
@@ -41,6 +44,7 @@ optlen(const u_int8_t *opt, unsigned int offset)
 static int
 tcpmss_mangle_packet(struct sk_buff *skb,
 		     const struct xt_tcpmss_info *info,
+		     unsigned int in_mtu,
 		     unsigned int tcphoff,
 		     unsigned int minlen)
 {
@@ -76,7 +80,13 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 				       dst_mtu(skb->dst));
 			return -1;
 		}
-		newmss = dst_mtu(skb->dst) - minlen;
+		if (in_mtu <= minlen) {
+			if (net_ratelimit())
+				printk(KERN_ERR "xt_TCPMSS: unknown or "
+				       "invalid path-MTU (%u)\n", in_mtu);
+			return -1;
+		}
+		newmss = min(dst_mtu(skb->dst), in_mtu) - minlen;
 	} else
 		newmss = info->mss;
 
@@ -137,6 +147,28 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	return TCPOLEN_MSS;
 }
 
+static u_int32_t tcpmss_reverse_mtu4(const struct iphdr *iph)
+{
+	struct flowi fl = {
+		.fl4_dst = iph->saddr,
+	};
+	const struct nf_afinfo *ai;
+	struct rtable *rt = NULL;
+	u_int32_t mtu     = ~0U;
+
+	rcu_read_lock();
+	ai = nf_get_afinfo(AF_INET);
+	if (ai != NULL)
+		ai->route((struct dst_entry **)&rt, &fl);
+	rcu_read_unlock();
+
+	if (rt != NULL) {
+		mtu = dst_mtu(&rt->u.dst);
+		dst_release(&rt->u.dst);
+	}
+	return mtu;
+}
+
 static unsigned int
 tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
            const struct net_device *out, unsigned int hooknum,
@@ -146,7 +178,8 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 	__be16 newlen;
 	int ret;
 
-	ret = tcpmss_mangle_packet(skb, targinfo, iph->ihl * 4,
+	ret = tcpmss_mangle_packet(skb, targinfo, tcpmss_reverse_mtu4(iph),
+				   iph->ihl * 4,
 				   sizeof(*iph) + sizeof(struct tcphdr));
 	if (ret < 0)
 		return NF_DROP;
@@ -160,6 +193,28 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+static u_int32_t tcpmss_reverse_mtu6(const struct ipv6hdr *iph)
+{
+	struct flowi fl = {
+		.fl6_dst = iph->saddr,
+	};
+	const struct nf_afinfo *ai;
+	struct rtable *rt = NULL;
+	u_int32_t mtu     = ~0U;
+
+	rcu_read_lock();
+	ai = nf_get_afinfo(AF_INET6);
+	if (ai != NULL)
+		ai->route((struct dst_entry **)&rt, &fl);
+	rcu_read_unlock();
+
+	if (rt != NULL) {
+		mtu = dst_mtu(&rt->u.dst);
+		dst_release(&rt->u.dst);
+	}
+	return mtu;
+}
+
 static unsigned int
 tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
            const struct net_device *out, unsigned int hooknum,
@@ -174,7 +229,8 @@ tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
 	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr);
 	if (tcphoff < 0)
 		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, targinfo, tcphoff,
+	ret = tcpmss_mangle_packet(skb, targinfo, tcpmss_reverse_mtu6(ipv6h),
+				   tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));
 	if (ret < 0)
 		return NF_DROP;
