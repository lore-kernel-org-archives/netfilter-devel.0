From: Aaron Hopkins <lists@die.net>
Subject: [PATCH] ipt_TARPIT
Date: Sat, 30 Nov 2002 02:35:47 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0211300217050.18069-100000@asherah.die.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On April 2, I submitted a patch to add --reject-with tcp-synack to the
REJECT target.  It was suggested that this functionality was "antisocial",
but that it would be accepted into patch-o-matic as a separate module.  I
wrote such a module, put in production, then promptly forgot about it.

As I've recently received a few inquiries from people failing to understand
how to build a new kernel with it, I thought I would try again to get it
into the netfilter distribution.  The use of patch-o-matic would simplify
things greatly for the people interested in it.

Here's a patch against the current netfilter CVS tree.  The module itself
has been well tested.  The patch-o-matic bits have only be tested enough to
let me build a kernel.

This is also available from
http://ftp.die.net/pub/linux-kernel-tarpit/netfilter-20021130-ipt_TARPIT.patch
should it get mangled in e-mail.

                                    -- Aaron

---

diff -urP netfilter/patch-o-matic/extra/ipt_TARPIT.patch netfilter-tarpit/patch-o-matic/extra/ipt_TARPIT.patch
--- netfilter/patch-o-matic/extra/ipt_TARPIT.patch	Wed Dec 31 16:00:00 1969
+++ netfilter-tarpit/patch-o-matic/extra/ipt_TARPIT.patch	Sat Nov 30 02:03:46 2002
@@ -0,0 +1,288 @@
+diff -urP linux-2.4.18-18.7.x-orig/net/ipv4/netfilter/ipt_TARPIT.c linux-2.4.18-18.7.x/net/ipv4/netfilter/ipt_TARPIT.c
+--- linux-2.4.18-18.7.x-orig/net/ipv4/netfilter/ipt_TARPIT.c	Wed Dec 31 16:00:00 1969
++++ linux-2.4.18-18.7.x/net/ipv4/netfilter/ipt_TARPIT.c	Wed Nov 27 23:54:02 2002
+@@ -0,0 +1,284 @@
++/* 
++ * Kernel module to capture and hold incoming TCP connections using 
++ * no local per-connection resources.
++ * 
++ * Based on ipt_REJECT.c and offering functionality similar to 
++ * LaBrea <http://www.hackbusters.net/LaBrea/>.
++ * 
++ * Copyright (c) 2002 Aaron Hopkins <tools@die.net>
++ * 
++ * This program is free software; you can redistribute it and/or modify
++ * it under the terms of the GNU General Public License as published by
++ * the Free Software Foundation; either version 2 of the License, or
++ * (at your option) any later version.
++ *
++ * This program is distributed in the hope that it will be useful,
++ * but WITHOUT ANY WARRANTY; without even the implied warranty of
++ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
++ * GNU General Public License for more details.
++ *
++ * You should have received a copy of the GNU General Public License
++ * along with this program; if not, write to the Free Software
++ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
++ * 
++ * Goal:
++ * - Allow incoming TCP connections to be established.
++ * - Passing data should result in the connection being switched to the 
++ *   persist state (0 byte window), in which the remote side stops sending 
++ *   data and asks to continue every 60 seconds.
++ * - Attempts to shut down the connection should be ignored completely, so 
++ *   the remote side ends up having to time it out.
++ *
++ * This means:
++ * - Reply to TCP SYN,!ACK,!RST,!FIN with SYN-ACK, window 5 bytes
++ * - Reply to TCP SYN,ACK,!RST,!FIN with RST to prevent spoofing
++ * - Reply to TCP !SYN,!RST,!FIN with ACK, window 0 bytes, rate-limited
++ */
++
++#include <linux/config.h>
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/ip.h>
++#include <net/ip.h>
++#include <net/tcp.h>
++#include <net/icmp.h>
++struct in_device;
++#include <net/route.h>
++#include <linux/random.h>
++#include <linux/netfilter_ipv4/ip_tables.h>
++
++#if 0
++#define DEBUGP printk
++#else
++#define DEBUGP(format, args...)
++#endif
++
++
++/* Stolen from ip_finish_output2 */
++static int ip_direct_send(struct sk_buff *skb)
++{
++	struct dst_entry *dst = skb->dst;
++	struct hh_cache *hh = dst->hh;
++
++	if (hh) {    
++		read_lock_bh(&hh->hh_lock);
++		memcpy(skb->data - 16, hh->hh_data, 16);
++                read_unlock_bh(&hh->hh_lock);
++                skb_push(skb, hh->hh_len);
++                return hh->hh_output(skb);
++        } else if (dst->neighbour)
++                return dst->neighbour->output(skb);
++
++	if (net_ratelimit())
++		printk(KERN_DEBUG "TARPIT ip_direct_send: no header cache and no neighbor!\n");
++        kfree_skb(skb);
++        return -EINVAL;
++}
++
++
++/* Send reply */
++static void tarpit_tcp(struct sk_buff *oskb,struct rtable *ort,int local)
++{
++	struct sk_buff *nskb;
++	struct rtable *nrt;
++	struct tcphdr *otcph, *ntcph;
++	unsigned int otcplen;
++	u_int16_t tmp;
++
++	/* A truncated TCP header isn't going to be useful */
++	if (oskb->len < (oskb->nh.iph->ihl*4) + sizeof(struct tcphdr))
++		return;
++
++	otcph = (struct tcphdr *)((u_int32_t*)oskb->nh.iph 
++                                  + oskb->nh.iph->ihl);
++	otcplen = oskb->len - oskb->nh.iph->ihl*4;
++
++	/* No replies for RST or FIN */
++	if (otcph->rst || otcph->fin)
++		return;
++
++	/* No reply to !SYN,!ACK.  Rate-limit replies to !SYN,ACKs */
++	if (!otcph->syn && (!otcph->ack || !xrlim_allow(&ort->u.dst, 1*HZ)))
++		return;
++
++	/* Check checksum. */
++	if (tcp_v4_check(otcph, otcplen, oskb->nh.iph->saddr,
++			 oskb->nh.iph->daddr,
++			 csum_partial((char *)otcph, otcplen, 0)) != 0)
++		return;
++
++	/* Copy skb (even if skb is about to be dropped, we can't just
++           clone it because there may be other things, such as tcpdump,
++           interested in it) */
++	nskb = skb_copy(oskb, GFP_ATOMIC);
++	if (!nskb)
++		return;
++
++	/* This packet will not be the same as the other: clear nf fields */
++	nf_conntrack_put(nskb->nfct);
++	nskb->nfct = NULL;
++	nskb->nfcache = 0;
++#ifdef CONFIG_NETFILTER_DEBUG
++	nskb->nf_debug = 0;
++#endif
++
++	ntcph = (struct tcphdr *)((u_int32_t*)nskb->nh.iph + nskb->nh.iph->ihl);
++
++	/* Truncate to length (no data) */
++	ntcph->doff = sizeof(struct tcphdr)/4;
++	skb_trim(nskb, nskb->nh.iph->ihl*4 + sizeof(struct tcphdr));
++	nskb->nh.iph->tot_len = htons(nskb->len);
++
++	/* Swap source and dest */
++	nskb->nh.iph->daddr = xchg(&nskb->nh.iph->saddr, nskb->nh.iph->daddr);
++	tmp = ntcph->source;
++	ntcph->source = ntcph->dest;
++	ntcph->dest = tmp;
++
++	/* Use supplied sequence number or make a new one */
++	ntcph->seq = otcph->ack ? otcph->ack_seq 
++                     : htonl(secure_tcp_sequence_number(nskb->nh.iph->saddr, 
++						        nskb->nh.iph->daddr, 
++						        ntcph->source, 
++			     			        ntcph->dest));
++
++	/* Our SYN-ACKs must have a >0 window */
++	ntcph->window = (otcph->syn && !otcph->ack) ? htons(5) : 0;
++
++	ntcph->urg_ptr = 0;
++
++	/* Reset flags */
++	((u_int8_t *)ntcph)[13] = 0;
++
++	if (otcph->syn && otcph->ack) {
++		ntcph->rst = 1;
++		ntcph->ack_seq = 0;
++	} else {
++		ntcph->syn = otcph->syn;
++		ntcph->ack = 1;
++		ntcph->ack_seq = htonl(ntohl(otcph->seq) + otcph->syn);
++	}
++
++	/* Adjust TCP checksum */
++	ntcph->check = 0;
++	ntcph->check = tcp_v4_check(ntcph, sizeof(struct tcphdr),
++				   nskb->nh.iph->saddr,
++				   nskb->nh.iph->daddr,
++				   csum_partial((char *)ntcph,
++						sizeof(struct tcphdr), 0));
++
++	/* Adjust IP TTL */
++	nskb->nh.iph->ttl = sysctl_ip_default_ttl;
++
++	/* Set DF, id = 0 */
++	nskb->nh.iph->frag_off = htons(IP_DF);
++	nskb->nh.iph->id = 0;
++
++	/* Adjust IP checksum */
++	nskb->nh.iph->check = 0;
++	nskb->nh.iph->check = ip_fast_csum((unsigned char *)nskb->nh.iph, 
++					   nskb->nh.iph->ihl);
++
++	if (ip_route_output(&nrt, nskb->nh.iph->daddr, 
++			    local ? nskb->nh.iph->saddr : 0,
++			    RT_TOS(nskb->nh.iph->tos) | RTO_CONN, 
++			    0) != 0)
++		goto free_nskb;
++
++	dst_release(nskb->dst);
++	nskb->dst = &nrt->u.dst;
++
++	/* "Never happens" */
++	if (nskb->len > nskb->dst->pmtu)
++		goto free_nskb;
++
++	ip_direct_send (nskb);
++
++	return;
++
++ free_nskb:
++	kfree_skb(nskb);
++}
++
++
++static unsigned int tarpit(struct sk_buff **pskb,
++			   unsigned int hooknum,
++			   const struct net_device *in,
++			   const struct net_device *out,
++			   const void *targinfo,
++			   void *userinfo)
++{
++	struct sk_buff *skb = *pskb;
++	struct rtable *rt = (struct rtable*)skb->dst;
++
++	/* Do we have an input route cache entry? */
++	if (!rt)
++		return NF_DROP;
++
++        /* No replies to physical multicast/broadcast */
++        if (skb->pkt_type != PACKET_HOST && skb->pkt_type != PACKET_OTHERHOST)
++     		return NF_DROP;
++
++        /* Now check at the protocol level */
++	if (rt->rt_flags&(RTCF_BROADCAST|RTCF_MULTICAST))
++                return NF_DROP;
++
++	/* Our naive response construction doesn't deal with IP
++           options, and probably shouldn't try. */
++	if (skb->nh.iph->ihl*4 != sizeof(struct iphdr))
++		return NF_DROP;
++
++        /* We aren't interested in fragments */
++	if (skb->nh.iph->frag_off & htons(IP_OFFSET))
++                return NF_DROP;
++
++	tarpit_tcp(skb,rt,hooknum == NF_IP_LOCAL_IN);
++
++	return NF_DROP;
++}
++
++
++static int check(const char *tablename,
++		 const struct ipt_entry *e,
++		 void *targinfo,
++		 unsigned int targinfosize,
++		 unsigned int hook_mask)
++{
++	/* Only allow these for input/forward packet filtering. */
++	if (strcmp(tablename, "filter") != 0) {
++		DEBUGP("TARPIT: bad table %s'.\n", tablename);
++		return 0;
++	}
++	if ((hook_mask & ~((1 << NF_IP_LOCAL_IN) 
++                           | (1 << NF_IP_FORWARD))) != 0) {
++		DEBUGP("TARPIT: bad hook mask %X\n", hook_mask);
++		return 0;
++	}
++
++	/* Must specify that it's a TCP packet */
++	if (e->ip.proto != IPPROTO_TCP || (e->ip.invflags & IPT_INV_PROTO)) {
++		DEBUGP("TARPIT: not valid for non-tcp\n");
++		return 0;
++	}
++
++	return 1;
++}
++
++static struct ipt_target ipt_tarpit_reg
++= { { NULL, NULL }, "TARPIT", tarpit, check, NULL, THIS_MODULE };
++
++static int __init init(void)
++{
++	if (ipt_register_target(&ipt_tarpit_reg))
++		return -EINVAL;
++	return 0;
++}
++
++static void __exit fini(void)
++{
++	ipt_unregister_target(&ipt_tarpit_reg);
++}
++
++module_init(init);
++module_exit(fini);
++MODULE_LICENSE("GPL");
diff -urP netfilter/patch-o-matic/extra/ipt_TARPIT.patch.config.in netfilter-tarpit/patch-o-matic/extra/ipt_TARPIT.patch.config.in
--- netfilter/patch-o-matic/extra/ipt_TARPIT.patch.config.in	Wed Dec 31 16:00:00 1969
+++ netfilter-tarpit/patch-o-matic/extra/ipt_TARPIT.patch.config.in	Sat Nov 30 02:11:43 2002
@@ -0,0 +1,2 @@
+      dep_tristate '    MIRROR target support (EXPERIMENTAL)' CONFIG_IP_NF_TARGET_MIRROR $CONFIG_IP_NF_FILTER
+      dep_tristate '    TARPIT target support (EXPERIMENTAL)' CONFIG_IP_NF_TARGET_TARPIT $CONFIG_IP_NF_FILTER
diff -urP netfilter/patch-o-matic/extra/ipt_TARPIT.patch.help netfilter-tarpit/patch-o-matic/extra/ipt_TARPIT.patch.help
--- netfilter/patch-o-matic/extra/ipt_TARPIT.patch.help	Wed Dec 31 16:00:00 1969
+++ netfilter-tarpit/patch-o-matic/extra/ipt_TARPIT.patch.help	Sat Nov 30 02:03:46 2002
@@ -0,0 +1,31 @@
+Author: "Aaron Hopkins" <lists@die.net>
+Status: Works for me
+
+
+Adds a TARPIT target to iptables, which captures and holds incoming TCP
+connections using no local per-connection resources.  Connections are
+accepted, but immediately switched to the persist state (0 byte window), in
+which the remote side stops sending data and asks to continue every 60-240
+seconds.  Attempts to close the connection are ignored, forcing the remote
+side to time out the connection in 12-24 minutes.
+
+This offers similar functionality to LaBrea
+<http://www.hackbusters.net/LaBrea/> but doesn't require dedicated hardware
+or IPs.  Any TCP port that you would normally DROP or REJECT can instead
+become a tarpit.
+
+To tarpit connections to TCP port 80 destined for the current machine:
+
+  iptables -A INPUT -p tcp -m tcp --dport 80 -j TARPIT
+
+To significantly slow down Code Red/Nimda-style scans of unused address
+space, forward unused ip addresses to a Linux box not acting as a router
+(e.g. "ip route 10.0.0.0 255.0.0.0 ip.of.linux.box" on a Cisco), enable IP
+forwarding on the Linux box, and add:
+
+  iptables -A FORWARD -p tcp -j TARPIT
+  iptables -A FORWARD -j DROP
+
+You probably don't want the conntrack module loaded while you are using
+TARPIT, or you will be using resources per connection.
+
diff -urP netfilter/patch-o-matic/extra/ipt_TARPIT.patch.makefile netfilter-tarpit/patch-o-matic/extra/ipt_TARPIT.patch.makefile
--- netfilter/patch-o-matic/extra/ipt_TARPIT.patch.makefile	Wed Dec 31 16:00:00 1969
+++ netfilter-tarpit/patch-o-matic/extra/ipt_TARPIT.patch.makefile	Sat Nov 30 02:10:17 2002
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_TARGET_MIRROR) += ipt_MIRROR.o
+obj-$(CONFIG_IP_NF_TARGET_TARPIT) += ipt_TARPIT.o
diff -urP netfilter/userspace/extensions/Makefile netfilter-tarpit/userspace/extensions/Makefile
--- netfilter/userspace/extensions/Makefile	Fri Aug  9 00:47:12 2002
+++ netfilter-tarpit/userspace/extensions/Makefile	Sat Nov 30 02:03:46 2002
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp length limit mac mark multiport owner pkttype standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TCPMSS TOS ULOG
+PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp length limit mac mark multiport owner pkttype standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS ULOG
 PF6_EXT_SLIB:=eui64 icmpv6 length limit mac mark multiport owner standard tcp udp LOG MARK
 
 # The following may not be present, but compile them anyway.
diff -urP netfilter/userspace/extensions/libipt_TARPIT.c netfilter-tarpit/userspace/extensions/libipt_TARPIT.c
--- netfilter/userspace/extensions/libipt_TARPIT.c	Wed Dec 31 16:00:00 1969
+++ netfilter-tarpit/userspace/extensions/libipt_TARPIT.c	Sat Nov 30 02:03:46 2002
@@ -0,0 +1,67 @@
+/* Shared library add-on to iptables for TARPIT support */
+#include <stdio.h>
+#include <getopt.h>
+#include <iptables.h>
+
+static void
+help(void)
+{
+	fputs(
+"TARPIT takes no options\n"
+"\n", stdout);
+}
+
+static struct option opts[] = {
+	{ 0 }
+};
+
+static void
+init(struct ipt_entry_target *t, unsigned int *nfcache)
+{
+	/* Can't cache this */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      struct ipt_entry_target **target)
+{
+	return 0;
+}
+
+static void final_check(unsigned int flags)
+{
+}
+
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+}
+
+static void save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+}
+
+static
+struct iptables_target tarpit
+= { NULL,
+    "TARPIT",
+    IPTABLES_VERSION,
+    IPT_ALIGN(0),
+    IPT_ALIGN(0),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+	register_target(&tarpit);
+}
