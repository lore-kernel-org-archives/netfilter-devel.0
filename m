From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_TARPIT 20070926
Date: Wed, 26 Sep 2007 10:31:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709261029350.3121@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55189 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbXIZIb7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:31:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id D36771CD319DD
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Sep 2007 10:31:57 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Resend - It still compiles :)


Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---------- Forwarded message ----------
Date: Mon, 6 Aug 2007 15:06:28 +0200 (CEST)


Along comes a new version of xt_TARPIT.

---
 net/netfilter/Kconfig     |   17 +++
 net/netfilter/Makefile    |    1 
 net/netfilter/xt_TARPIT.c |  246 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 264 insertions(+)

Index: linux-2.6.22.1/net/netfilter/Kconfig
===================================================================
--- linux-2.6.22.1.orig/net/netfilter/Kconfig
+++ linux-2.6.22.1/net/netfilter/Kconfig
@@ -375,6 +375,23 @@ config NETFILTER_XT_TARGET_CONNSECMARK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_TARPIT
+	tristate '"TARPIT" target support'
+	depends on NETFILTER_XTABLES
+	---help---
+	  Adds a TARPIT target to iptables, which captures and holds
+	  incoming TCP connections using no local per-connection resources.
+	  Connections are accepted, but immediately switched to the persist
+	  state (0 byte window), in which the remote side stops sending data
+	  and asks to continue every 60-240 seconds. Attempts to close the
+	  connection are ignored, forcing the remote side to time out the
+	  connection in 12-24 minutes.
+
+	  This offers similar functionality to LaBrea
+	  <http://www.hackbusters.net/LaBrea/>, but does not require dedicated
+	  hardware or IPs. Any TCP port that you would normally DROP or REJECT
+	  can instead become a tarpit.
+
 config NETFILTER_XT_TARGET_TCPMSS
 	tristate '"TCPMSS" target support'
 	depends on NETFILTER_XTABLES && (IPV6 || IPV6=n)
Index: linux-2.6.22.1/net/netfilter/Makefile
===================================================================
--- linux-2.6.22.1.orig/net/netfilter/Makefile
+++ linux-2.6.22.1/net/netfilter/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) 
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TARPIT) += xt_TARPIT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
 
Index: linux-2.6.22.1/net/netfilter/xt_TARPIT.c
===================================================================
--- /dev/null
+++ linux-2.6.22.1/net/netfilter/xt_TARPIT.c
@@ -0,0 +1,246 @@
+/*
+ * Kernel module to capture and hold incoming TCP connections using
+ * no local per-connection resources.
+ *
+ * Based on ipt_REJECT.c and offering functionality similar to
+ * LaBrea <http://www.hackbusters.net/LaBrea/>.
+ *
+ * Copyright (c) 2002 Aaron Hopkins <tools@die.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Goal:
+ * - Allow incoming TCP connections to be established.
+ * - Passing data should result in the connection being switched to the
+ *   persist state (0 byte window), in which the remote side stops sending
+ *   data and asks to continue every 60 seconds.
+ * - Attempts to shut down the connection should be ignored completely, so
+ *   the remote side ends up having to time it out.
+ *
+ * This means:
+ * - Reply to TCP SYN,!ACK,!RST,!FIN with SYN-ACK, window 5 bytes
+ * - Reply to TCP SYN,ACK,!RST,!FIN with RST to prevent spoofing
+ * - Reply to TCP !SYN,!RST,!FIN with ACK, window 0 bytes, rate-limited
+ */
+
+/*
+#include <net/ip.h>
+#include <net/icmp.h>
+#include <linux/random.h>
+*/
+
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#ifdef CONFIG_BRIDGE_NETFILTER
+#	include <linux/netfilter_bridge.h>
+#endif
+#include <net/route.h>
+#include <net/tcp.h>
+
+/* Send reply */
+static inline void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook)
+{
+	struct tcphdr _otcph, *oth, *tcph;
+	unsigned int addr_type;
+	struct sk_buff *nskb;
+	struct iphdr *niph;
+	u_int16_t tmp;
+
+	/* A truncated TCP header is not going to be useful */
+	if (oldskb->len < ip_hdrlen(oldskb) + sizeof(struct tcphdr))
+		return;
+
+	oth = skb_header_pointer(oldskb, ip_hdrlen(oldskb),
+	                         sizeof(_otcph), &_otcph);
+	if (oth == NULL)
+		return;
+
+	/* No replies for RST, FIN or !SYN,!ACK */
+	if (oth->rst || oth->fin || (!oth->syn && !oth->ack))
+		return;
+
+	/* Rate-limit replies to !SYN,ACKs */
+	/*
+	if (!oth->syn && oth->ack)
+		if (!xrlim_allow(&ort->u.dst, HZ))
+			return;
+	*/
+
+	/* Check checksum. */
+	if (nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), IPPROTO_TCP))
+		return;
+
+	/*
+	 * Copy skb (even if skb is about to be dropped, we cannot just
+	 * clone it because there may be other things, such as tcpdump,
+	 * interested in it)
+	 */
+	nskb = skb_copy_expand(oldskb, LL_MAX_HEADER,
+	                       skb_tailroom(oldskb), GFP_ATOMIC);
+	if (nskb == NULL)
+		return;
+
+	/* This packet will not be the same as the other: clear nf fields */
+	nf_reset(nskb);
+	nskb->mark = 0;
+	skb_init_secmark(nskb);
+
+	skb_shinfo(nskb)->gso_size = 0;
+	skb_shinfo(nskb)->gso_segs = 0;
+	skb_shinfo(nskb)->gso_type = 0;
+
+	tcph = (struct tcphdr *)(skb_network_header(nskb) + ip_hdrlen(nskb));
+
+	/* Swap source and dest */
+	niph         = ip_hdr(nskb);
+	niph->daddr  = xchg(&niph->saddr, niph->daddr);
+	tmp          = tcph->source;
+	tcph->source = tcph->dest;
+	tcph->dest   = tmp;
+
+	/* Truncate to length (no data) */
+	tcph->doff    = sizeof(struct tcphdr) / 4;
+	skb_trim(nskb, ip_hdrlen(nskb) + sizeof(struct tcphdr));
+	niph->tot_len = htons(nskb->len);
+
+	/* Use supplied sequence number or make a new one */
+	tcph->seq = oth->ack ? oth->ack_seq : 0;
+
+	/* Our SYN-ACKs must have a >0 window */
+	tcph->window  = (oth->syn && !oth->ack) ? htons(5) : 0;
+	tcph->urg_ptr = 0;
+
+	/* Reset flags */
+	((u_int8_t *)tcph)[13] = 0;
+
+	if (oth->syn && oth->ack) {
+		tcph->rst     = true;
+		tcph->ack_seq = false;
+	} else {
+		tcph->syn     = oth->syn;
+		tcph->ack     = 1;
+		tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn);
+	}
+
+	/* Adjust TCP checksum */
+	tcph->check = 0;
+	tcph->check = tcp_v4_check(sizeof(struct tcphdr), niph->saddr,
+	              niph->daddr, csum_partial((char *)tcph,
+	              sizeof(struct tcphdr), 0));
+
+	/* Set DF, id = 0 */
+	niph->frag_off = htons(IP_DF);
+	niph->id       = 0;
+
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (hook != NF_IP_FORWARD || (nskb->nf_bridge != NULL &&
+	    nskb->nf_bridge->mask & BRNF_BRIDGED))
+#else
+	if (hook != NF_IP_FORWARD)
+#endif
+		addr_type = RTN_LOCAL;
+
+	if (ip_route_me_harder(&nskb, addr_type))
+		goto free_nskb;
+
+	nskb->ip_summed = CHECKSUM_NONE;
+
+	/* Adjust IP TTL */
+	niph->ttl = dst_metric(nskb->dst, RTAX_HOPLIMIT);
+
+	/* Adjust IP checksum */
+	niph->check = 0;
+	niph->check = ip_fast_csum(skb_network_header(nskb), niph->ihl);
+
+	/* "Never happens" */
+	if (nskb->len > dst_mtu(nskb->dst))
+		goto free_nskb;
+
+	nf_ct_attach(nskb, oldskb);
+
+	NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, nskb, NULL, nskb->dst->dev,
+		dst_output);
+	return;
+
+ free_nskb:
+	kfree_skb(nskb);
+}
+
+static unsigned int xt_tarpit_target(struct sk_buff **pskb,
+                                     const struct net_device *in,
+                                     const struct net_device *out,
+                                     unsigned int hooknum,
+                                     const struct xt_target *target,
+                                     const void *targinfo)
+{
+	struct sk_buff *skb     = *pskb;
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct rtable *rt = (const void *)skb->dst;
+
+	/* Do we have an input route cache entry? (Not in PREROUTING.) */
+	if (rt == NULL)
+		return NF_DROP;
+
+	/* No replies to physical multicast/broadcast */
+	/* skb != PACKET_OTHERHOST handled by ip_rcv() */
+	if (skb->pkt_type != PACKET_HOST)
+		return NF_DROP;
+
+	/* Now check at the protocol level */
+	if (rt->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
+		return NF_DROP;
+
+	/*
+	 * Our naive response construction does not deal with IP
+	 * options, and probably should not try.
+	 */
+	if (ip_hdrlen(skb) != sizeof(struct iphdr))
+		return NF_DROP;
+
+	/* We are not interested in fragments */
+	if (iph->frag_off & htons(IP_OFFSET))
+		return NF_DROP;
+
+	tarpit_tcp(skb, hooknum);
+	return NF_DROP;
+}
+
+static struct xt_target xt_tarpit_reg __read_mostly = {
+	.name       = "TARPIT",
+	.family     = AF_INET,
+	.table      = "filter",
+	.hooks      = (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD),
+	.proto      = IPPROTO_TCP,
+	.target     = xt_tarpit_target,
+	.me         = THIS_MODULE,
+};
+
+static int __init xt_tarpit_init(void)
+{
+	return xt_register_target(&xt_tarpit_reg);
+}
+
+static void __exit xt_tarpit_exit(void)
+{
+	xt_unregister_target(&xt_tarpit_reg);
+}
+
+module_init(xt_tarpit_init);
+module_exit(xt_tarpit_exit);
+MODULE_DESCRIPTION("netfilter xt_TARPIT target module");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
+MODULE_LICENSE("GPL");
