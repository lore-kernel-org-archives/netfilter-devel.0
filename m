From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] Add bridged IPv6 packet filtering
Date: Wed, 1 Sep 2004 22:34:26 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409012234.26310.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	usagi-core@linux-ipv6.org,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S.Miller <davem@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

=46rom reading Yasuyuki's reply and the specific code, the IPv6 checks
before giving a bridged packet to ip6tables should now be accurate.

These are the changes made to the original patch:

=2D *	Aug 28 2004: add IPv6 filtering (bdschuym)
+ *	Sep 01 2004: add IPv6 filtering (bdschuym)

@@ -321,11 +321,12 @@ static unsigned int br_nf_pre_routing_ip
 			goto inhdr_error;
 	}
 	if (hdr->nexthdr =3D=3D NEXTHDR_HOP) {
=2D		skb->h.raw =3D (u8*)(hdr+1);
=2D#if 0
=2D		if (ipv6_parse_hopopts(skb, offsetof(struct ipv6hdr, nexthdr))<0)
+		/* We only check the length. A bridge shouldn't do any
+		 * hop-by-hop stuff anyway. */
+		unsigned char *raw =3D (u8*)(skb->nh.ipv6h+1);
+
+		if ((raw + ((int)(raw[1]+1)<<3)) - skb->data > skb_headlen(skb))
 			goto inhdr_error;
=2D#endif

As the change to the original patch is minimal and the original patch has
been tested, I suggest applying the patch below.

cheers,
Bart

=2D-- linux-2.6.8.1/include/linux/netfilter_ipv6.h.old	2004-09-01 22:17:13.=
000000000 +0200
+++ linux-2.6.8.1/include/linux/netfilter_ipv6.h	2004-09-01 21:09:58.000000=
000 +0200
@@ -58,8 +58,10 @@ enum nf_ip6_hook_priorities {
 	NF_IP6_PRI_FIRST =3D INT_MIN,
 	NF_IP6_PRI_SELINUX_FIRST =3D -225,
 	NF_IP6_PRI_CONNTRACK =3D -200,
+	NF_IP6_PRI_BRIDGE_SABOTAGE_FORWARD =3D -175,
 	NF_IP6_PRI_MANGLE =3D -150,
 	NF_IP6_PRI_NAT_DST =3D -100,
+	NF_IP6_PRI_BRIDGE_SABOTAGE_LOCAL_OUT =3D -50,
 	NF_IP6_PRI_FILTER =3D 0,
 	NF_IP6_PRI_NAT_SRC =3D 100,
 	NF_IP6_PRI_SELINUX_LAST =3D 225,
=2D-- linux-2.6.8.1/net/bridge/br_netfilter.c.old	2004-09-01 22:19:04.00000=
0000 +0200
+++ linux-2.6.8.1/net/bridge/br_netfilter.c	2004-09-01 21:59:51.000000000 +=
0200
@@ -11,6 +11,7 @@
  *	Jun 19 2003: let arptables see bridged ARP traffic (bdschuym)
  *	Oct 06 2003: filter encapsulated IP/ARP VLAN traffic on untagged bridge
  *	             (bdschuym)
+ *	Sep 01 2004: add IPv6 filtering (bdschuym)
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -29,9 +30,11 @@
 #include <linux/if_vlan.h>
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_arp.h>
 #include <linux/in_route.h>
 #include <net/ip.h>
+#include <net/ipv6.h>
 #include <asm/uaccess.h>
 #include <asm/checksum.h>
 #include "br_private.h"
@@ -39,7 +42,6 @@
 #include <linux/sysctl.h>
 #endif
=20
=2D
 #define skb_origaddr(skb)	 (((struct bridge_skb_cb *) \
 				 (skb->nf_bridge->data))->daddr.ipv4)
 #define store_orig_dstaddr(skb)	 (skb_origaddr(skb) =3D (skb)->nh.iph->dad=
dr)
@@ -51,6 +53,7 @@
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
 static int brnf_call_iptables =3D 1;
+static int brnf_call_ip6tables =3D 1;
 static int brnf_call_arptables =3D 1;
 static int brnf_filter_vlan_tagged =3D 1;
 #else
@@ -60,6 +63,9 @@ static int brnf_filter_vlan_tagged =3D 1;
 #define IS_VLAN_IP (skb->protocol =3D=3D __constant_htons(ETH_P_8021Q) && =
   \
 	hdr->h_vlan_encapsulated_proto =3D=3D __constant_htons(ETH_P_IP) &&  \
 	brnf_filter_vlan_tagged)
+#define IS_VLAN_IPV6 (skb->protocol =3D=3D __constant_htons(ETH_P_8021Q) &=
&    \
+	hdr->h_vlan_encapsulated_proto =3D=3D __constant_htons(ETH_P_IPV6) &&  \
+	brnf_filter_vlan_tagged)
 #define IS_VLAN_ARP (skb->protocol =3D=3D __constant_htons(ETH_P_8021Q) &&=
   \
 	hdr->h_vlan_encapsulated_proto =3D=3D __constant_htons(ETH_P_ARP) && \
 	brnf_filter_vlan_tagged)
@@ -71,8 +77,7 @@ static int brnf_filter_vlan_tagged =3D 1;
  * Currently, we fill in the PMTU entry because netfilter
  * refragmentation needs it, and the rt_flags entry because
  * ipt_REJECT needs it.  Future netfilter modules might
=2D * require us to fill additional fields.
=2D */
+ * require us to fill additional fields. */
 static struct net_device __fake_net_device =3D {
 	.hard_header_len	=3D ETH_HLEN
 };
@@ -91,6 +96,36 @@ static struct rtable __fake_rtable =3D {
=20
=20
 /* PF_BRIDGE/PRE_ROUTING *********************************************/
+/* Undo the changes made for ip6tables PREROUTING and continue the
+ * bridge PRE_ROUTING hook. */
+static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
+{
+	struct nf_bridge_info *nf_bridge =3D skb->nf_bridge;
+
+#ifdef CONFIG_NETFILTER_DEBUG
+	skb->nf_debug ^=3D (1 << NF_BR_PRE_ROUTING);
+#endif
+
+	if (nf_bridge->mask & BRNF_PKT_TYPE) {
+		skb->pkt_type =3D PACKET_OTHERHOST;
+		nf_bridge->mask ^=3D BRNF_PKT_TYPE;
+	}
+	nf_bridge->mask ^=3D BRNF_NF_BRIDGE_PREROUTING;
+
+	skb->dst =3D (struct dst_entry *)&__fake_rtable;
+	dst_hold(skb->dst);
+
+	skb->dev =3D nf_bridge->physindev;
+	if (skb->protocol =3D=3D __constant_htons(ETH_P_8021Q)) {
+		skb_push(skb, VLAN_HLEN);
+		skb->nh.raw -=3D VLAN_HLEN;
+	}
+	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
+		       br_handle_frame_finish, 1);
+
+	return 0;
+}
+
 static void __br_dnat_complain(void)
 {
 	static unsigned long last_complaint;
@@ -102,7 +137,6 @@ static void __br_dnat_complain(void)
 	}
 }
=20
=2D
 /* This requires some explaining. If DNAT has taken place,
  * we will need to fix up the destination Ethernet address,
  * and this is a tricky process.
@@ -145,9 +179,7 @@ static void __br_dnat_complain(void)
  *
  * --Lennert, 20020411
  * --Bart, 20020416 (updated)
=2D * --Bart, 20021007 (updated)
=2D */
=2D
+ * --Bart, 20021007 (updated) */
 static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 {
 #ifdef CONFIG_NETFILTER_DEBUG
@@ -195,8 +227,7 @@ static int br_nf_pre_routing_finish(stru
=20
 			if (!ip_route_output_key(&rt, &fl)) {
 				/* Bridged-and-DNAT'ed traffic doesn't
=2D				 * require ip_forwarding.
=2D				 */
+				 * require ip_forwarding. */
 				if (((struct dst_entry *)rt)->dev =3D=3D dev) {
 					skb->dst =3D (struct dst_entry *)rt;
 					goto bridged_dnat;
@@ -210,8 +241,7 @@ static int br_nf_pre_routing_finish(stru
 			if (skb->dst->dev =3D=3D dev) {
 bridged_dnat:
 				/* Tell br_nf_local_out this is a
=2D				 * bridged frame
=2D				 */
+				 * bridged frame */
 				nf_bridge->mask |=3D BRNF_BRIDGED_DNAT;
 				skb->dev =3D nf_bridge->physindev;
 				if (skb->protocol =3D=3D
@@ -245,12 +275,81 @@ bridged_dnat:
 	return 0;
 }
=20
=2D/* Replicate the checks that IPv4 does on packet reception.
+/* Some common code for IPv4/IPv6 */
+static void setup_pre_routing(struct sk_buff *skb)
+{
+	struct nf_bridge_info *nf_bridge =3D skb->nf_bridge;
+
+	if (skb->pkt_type =3D=3D PACKET_OTHERHOST) {
+		skb->pkt_type =3D PACKET_HOST;
+		nf_bridge->mask |=3D BRNF_PKT_TYPE;
+	}
+
+	nf_bridge->mask |=3D BRNF_NF_BRIDGE_PREROUTING;
+	nf_bridge->physindev =3D skb->dev;
+	skb->dev =3D bridge_parent(skb->dev);
+}
+
+/* Replicate the checks that IPv6 does on packet reception and pass the pa=
cket
+ * to ip6tables, which doesn't support NAT, so things are fairly simple. */
+static unsigned int br_nf_pre_routing_ipv6(unsigned int hook,
+   struct sk_buff *skb, const struct net_device *in,
+   const struct net_device *out, int (*okfn)(struct sk_buff *))
+{
+	struct ipv6hdr *hdr;
+	u32 pkt_len;
+	struct nf_bridge_info *nf_bridge;
+
+	if (skb->len < sizeof(struct ipv6hdr))
+		goto inhdr_error;
+
+	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		goto inhdr_error;
+
+	hdr =3D skb->nh.ipv6h;
+
+	if (hdr->version !=3D 6)
+		goto inhdr_error;
+
+	pkt_len =3D ntohs(hdr->payload_len);
+
+	if (pkt_len || hdr->nexthdr !=3D NEXTHDR_HOP) {
+		if (pkt_len + sizeof(struct ipv6hdr) > skb->len)
+			goto inhdr_error;
+		if (pkt_len + sizeof(struct ipv6hdr) < skb->len &&
+		    __pskb_trim(skb, pkt_len + sizeof(struct ipv6hdr)))
+			goto inhdr_error;
+	}
+	if (hdr->nexthdr =3D=3D NEXTHDR_HOP) {
+		/* We only check the length. A bridge shouldn't do any
+		 * hop-by-hop stuff anyway. */
+		unsigned char *raw =3D (u8*)(skb->nh.ipv6h+1);
+
+		if ((raw + ((int)(raw[1]+1)<<3)) - skb->data > skb_headlen(skb))
+			goto inhdr_error;
+	}
+#ifdef CONFIG_NETFILTER_DEBUG
+	skb->nf_debug ^=3D (1 << NF_IP6_PRE_ROUTING);
+#endif
+	if ((nf_bridge =3D nf_bridge_alloc(skb)) =3D=3D NULL)
+		return NF_DROP;
+	setup_pre_routing(skb);
+
+	NF_HOOK(PF_INET6, NF_IP6_PRE_ROUTING, skb, skb->dev, NULL,
+		br_nf_pre_routing_finish_ipv6);
+
+	return NF_STOLEN;
+
+inhdr_error:
+	return NF_DROP;
+}
+
+/* Direct IPv6 traffic to br_nf_pre_routing_ipv6.
+ * Replicate the checks that IPv4 does on packet reception.
  * Set skb->dev to the bridge device (i.e. parent of the
  * receiving device) to make netfilter happy, the REDIRECT
  * target in particular.  Save the original destination IP
=2D * address to be able to detect DNAT afterwards.
=2D */
+ * address to be able to detect DNAT afterwards. */
 static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff **=
pskb,
    const struct net_device *in, const struct net_device *out,
    int (*okfn)(struct sk_buff *))
@@ -259,25 +358,39 @@ static unsigned int br_nf_pre_routing(un
 	__u32 len;
 	struct sk_buff *skb =3D *pskb;
 	struct nf_bridge_info *nf_bridge;
+	struct vlan_ethhdr *hdr =3D (struct vlan_ethhdr *)
+				   ((*pskb)->mac.ethernet);
+
+	if (skb->protocol =3D=3D __constant_htons(ETH_P_IPV6) || IS_VLAN_IPV6) {
+#ifdef CONFIG_SYSCTL
+		if (!brnf_call_ip6tables)
+			return NF_ACCEPT;
+#endif
+		if ((skb =3D skb_share_check(*pskb, GFP_ATOMIC)) =3D=3D NULL)
+			goto out;
=20
+		if (skb->protocol =3D=3D __constant_htons(ETH_P_8021Q)) {
+			skb_pull(skb, VLAN_HLEN);
+			(skb)->nh.raw +=3D VLAN_HLEN;
+		}
+		return br_nf_pre_routing_ipv6(hook, skb, in, out, okfn);
+	}
 #ifdef CONFIG_SYSCTL
 	if (!brnf_call_iptables)
 		return NF_ACCEPT;
 #endif
=20
=2D	if (skb->protocol !=3D __constant_htons(ETH_P_IP)) {
=2D		struct vlan_ethhdr *hdr =3D (struct vlan_ethhdr *)
=2D					  ((*pskb)->mac.ethernet);
+	if (skb->protocol !=3D __constant_htons(ETH_P_IP) && !IS_VLAN_IP)
+		return NF_ACCEPT;
=20
=2D		if (!IS_VLAN_IP)
=2D			return NF_ACCEPT;
=2D		if ((skb =3D skb_share_check(*pskb, GFP_ATOMIC)) =3D=3D NULL)
=2D			goto out;
=2D		skb_pull(*pskb, VLAN_HLEN);
=2D		(*pskb)->nh.raw +=3D VLAN_HLEN;
=2D	} else if ((skb =3D skb_share_check(*pskb, GFP_ATOMIC)) =3D=3D NULL)
+	if ((skb =3D skb_share_check(*pskb, GFP_ATOMIC)) =3D=3D NULL)
 		goto out;
=20
+	if (skb->protocol =3D=3D __constant_htons(ETH_P_8021Q)) {
+		skb_pull(skb, VLAN_HLEN);
+		(skb)->nh.raw +=3D VLAN_HLEN;
+	}
+
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 		goto inhdr_error;
=20
@@ -305,17 +418,9 @@ static unsigned int br_nf_pre_routing(un
 #ifdef CONFIG_NETFILTER_DEBUG
 	skb->nf_debug ^=3D (1 << NF_IP_PRE_ROUTING);
 #endif
=2D 	if ((nf_bridge =3D nf_bridge_alloc(skb)) =3D=3D NULL)
+	if ((nf_bridge =3D nf_bridge_alloc(skb)) =3D=3D NULL)
 		return NF_DROP;
=2D
=2D	if (skb->pkt_type =3D=3D PACKET_OTHERHOST) {
=2D		skb->pkt_type =3D PACKET_HOST;
=2D		nf_bridge->mask |=3D BRNF_PKT_TYPE;
=2D	}
=2D
=2D	nf_bridge->mask |=3D BRNF_NF_BRIDGE_PREROUTING;
=2D	nf_bridge->physindev =3D skb->dev;
=2D	skb->dev =3D bridge_parent(skb->dev);
+	setup_pre_routing(skb);
 	store_orig_dstaddr(skb);
=20
 	NF_HOOK(PF_INET, NF_IP_PRE_ROUTING, skb, skb->dev, NULL,
@@ -336,8 +441,7 @@ out:
  * packet would pass through PRE_ROUTING again (which already
  * took place when the packet entered the bridge), but we
  * register an IPv4 PRE_ROUTING 'sabotage' hook that will
=2D * prevent this from happening.
=2D */
+ * prevent this from happening. */
 static unsigned int br_nf_local_in(unsigned int hook, struct sk_buff **psk=
b,
    const struct net_device *in, const struct net_device *out,
    int (*okfn)(struct sk_buff *))
@@ -364,7 +468,7 @@ static int br_nf_forward_finish(struct s
 	skb->nf_debug ^=3D (1 << NF_BR_FORWARD);
 #endif
=20
=2D	if (skb->protocol =3D=3D __constant_htons(ETH_P_IP) || IS_VLAN_IP) {
+	if (skb->protocol !=3D __constant_htons(ETH_P_ARP) && !IS_VLAN_ARP) {
 		in =3D nf_bridge->physindev;
 		if (nf_bridge->mask & BRNF_PKT_TYPE) {
 			skb->pkt_type =3D PACKET_OTHERHOST;
@@ -385,9 +489,8 @@ static int br_nf_forward_finish(struct s
 /* This is the 'purely bridged' case.  For IP, we pass the packet to
  * netfilter with indev and outdev set to the bridge device,
  * but we are still able to filter on the 'real' indev/outdev
=2D * because of the ipt_physdev.c module. For ARP, indev and outdev are the
=2D * bridge ports.
=2D */
+ * because of the physdev module. For ARP, indev and outdev are the
+ * bridge ports. */
 static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff **p=
skb,
    const struct net_device *in, const struct net_device *out,
    int (*okfn)(struct sk_buff *))
@@ -395,15 +498,17 @@ static unsigned int br_nf_forward_ip(uns
 	struct sk_buff *skb =3D *pskb;
 	struct nf_bridge_info *nf_bridge;
 	struct vlan_ethhdr *hdr =3D (struct vlan_ethhdr *)(skb->mac.ethernet);
+	int pf;
=20
=2D#ifdef CONFIG_SYSCTL
 	if (!skb->nf_bridge)
 		return NF_ACCEPT;
=2D#endif
=20
=2D	if (skb->protocol !=3D __constant_htons(ETH_P_IP)) {
=2D		if (!IS_VLAN_IP)
=2D			return NF_ACCEPT;
+	if (skb->protocol =3D=3D __constant_htons(ETH_P_IP) || IS_VLAN_IP)
+		pf =3D PF_INET;
+	else
+		pf =3D PF_INET6;
+
+	if (skb->protocol =3D=3D __constant_htons(ETH_P_8021Q)) {
 		skb_pull(*pskb, VLAN_HLEN);
 		(*pskb)->nh.raw +=3D VLAN_HLEN;
 	}
@@ -421,7 +526,7 @@ static unsigned int br_nf_forward_ip(uns
 	nf_bridge->mask |=3D BRNF_BRIDGED;
 	nf_bridge->physoutdev =3D skb->dev;
=20
=2D	NF_HOOK(PF_INET, NF_IP_FORWARD, skb, bridge_parent(in),
+	NF_HOOK(pf, NF_IP_FORWARD, skb, bridge_parent(in),
 		bridge_parent(out), br_nf_forward_finish);
=20
 	return NF_STOLEN;
@@ -483,11 +588,10 @@ static int br_nf_local_out_finish(struct
 	return 0;
 }
=20
=2D
 /* This function sees both locally originated IP packets and forwarded
  * IP packets (in both cases the destination device is a bridge
  * device). It also sees bridged-and-DNAT'ed packets.
=2D * To be able to filter on the physical bridge devices (with the ipt_phy=
sdev.c
+ * To be able to filter on the physical bridge devices (with the physdev
  * module), we steal packets destined to a bridge device away from the
  * PF_INET/FORWARD and PF_INET/OUTPUT hook functions, and give them back l=
ater,
  * when we have determined the real output device. This is done in here.
@@ -501,45 +605,44 @@ static int br_nf_local_out_finish(struct
  * this packet before, and so the packet was locally originated. We fake
  * the PF_INET/LOCAL_OUT hook.
  * Finally, if nf_bridge->physindev isn't NULL, then the packet was IP rou=
ted,
=2D * so we fake the PF_INET/FORWARD hook. ipv4_sabotage_out() makes sure
+ * so we fake the PF_INET/FORWARD hook. ip_sabotage_out() makes sure
  * even routed packets that didn't arrive on a bridge interface have their
=2D * nf_bridge->physindev set.
=2D */
=2D
+ * nf_bridge->physindev set. */
 static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff **ps=
kb,
    const struct net_device *in, const struct net_device *out,
=2D   int (*_okfn)(struct sk_buff *))
+   int (*okfn)(struct sk_buff *))
 {
=2D	int (*okfn)(struct sk_buff *skb);
=2D	struct net_device *realindev;
+	struct net_device *realindev, *realoutdev;
 	struct sk_buff *skb =3D *pskb;
 	struct nf_bridge_info *nf_bridge;
 	struct vlan_ethhdr *hdr =3D (struct vlan_ethhdr *)(skb->mac.ethernet);
+	int pf;
=20
=2D#ifdef CONFIG_SYSCTL
 	if (!skb->nf_bridge)
 		return NF_ACCEPT;
=2D#endif
=20
=2D	if (skb->protocol !=3D __constant_htons(ETH_P_IP) && !IS_VLAN_IP)
=2D		return NF_ACCEPT;
+	if (skb->protocol =3D=3D __constant_htons(ETH_P_IP) || IS_VLAN_IP)
+		pf =3D PF_INET;
+	else
+		pf =3D PF_INET6;
=20
+#ifdef CONFIG_NETFILTER_DEBUG
 	/* Sometimes we get packets with NULL ->dst here (for example,
=2D	 * running a dhcp client daemon triggers this).
=2D	 */
=2D	if (skb->dst =3D=3D NULL)
+	 * running a dhcp client daemon triggers this). This should now
+	 * be fixed, but let's keep the check around. */
+	if (skb->dst =3D=3D NULL) {
+		printk(KERN_CRIT "br_netfilter: skb->dst =3D=3D NULL.");
 		return NF_ACCEPT;
+	}
+#endif
=20
 	nf_bridge =3D skb->nf_bridge;
 	nf_bridge->physoutdev =3D skb->dev;
 	realindev =3D nf_bridge->physindev;
=20
 	/* Bridged, take PF_BRIDGE/FORWARD.
=2D	 * (see big note in front of br_nf_pre_routing_finish)
=2D	 */
+	 * (see big note in front of br_nf_pre_routing_finish) */
 	if (nf_bridge->mask & BRNF_BRIDGED_DNAT) {
=2D		okfn =3D br_forward_finish;
=2D
 		if (nf_bridge->mask & BRNF_PKT_TYPE) {
 			skb->pkt_type =3D PACKET_OTHERHOST;
 			nf_bridge->mask ^=3D BRNF_PKT_TYPE;
@@ -550,41 +653,41 @@ static unsigned int br_nf_local_out(unsi
 		}
=20
 		NF_HOOK(PF_BRIDGE, NF_BR_FORWARD, skb, realindev,
=2D			skb->dev, okfn);
=2D	} else {
=2D		struct net_device *realoutdev =3D bridge_parent(skb->dev);
+			skb->dev, br_forward_finish);
+		goto out;
+	}
+	realoutdev =3D bridge_parent(skb->dev);
=20
 #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
=2D		/* iptables should match -o br0.x */
=2D		if (nf_bridge->netoutdev)
=2D			realoutdev =3D nf_bridge->netoutdev;
+	/* iptables should match -o br0.x */
+	if (nf_bridge->netoutdev)
+		realoutdev =3D nf_bridge->netoutdev;
 #endif
=2D		okfn =3D br_nf_local_out_finish;
=2D		if (skb->protocol =3D=3D __constant_htons(ETH_P_8021Q)) {
=2D			skb_pull(skb, VLAN_HLEN);
=2D			(*pskb)->nh.raw +=3D VLAN_HLEN;
=2D		}
=2D		/* IP forwarded traffic has a physindev, locally
=2D		 * generated traffic hasn't.
=2D		 */
=2D		if (realindev !=3D NULL) {
=2D			if (((nf_bridge->mask & BRNF_DONT_TAKE_PARENT) =3D=3D 0) &&
=2D			    has_bridge_parent(realindev))
=2D				realindev =3D bridge_parent(realindev);
=2D			NF_HOOK_THRESH(PF_INET, NF_IP_FORWARD, skb, realindev,
=2D				       realoutdev, okfn,
=2D				       NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD + 1);
=2D		} else {
+	if (skb->protocol =3D=3D __constant_htons(ETH_P_8021Q)) {
+		skb_pull(skb, VLAN_HLEN);
+		(*pskb)->nh.raw +=3D VLAN_HLEN;
+	}
+	/* IP forwarded traffic has a physindev, locally
+	 * generated traffic hasn't. */
+	if (realindev !=3D NULL) {
+		if (!(nf_bridge->mask & BRNF_DONT_TAKE_PARENT) &&
+		    has_bridge_parent(realindev))
+			realindev =3D bridge_parent(realindev);
+
+		NF_HOOK_THRESH(pf, NF_IP_FORWARD, skb, realindev,
+			       realoutdev, br_nf_local_out_finish,
+			       NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD + 1);
+	} else {
 #ifdef CONFIG_NETFILTER_DEBUG
=2D			skb->nf_debug ^=3D (1 << NF_IP_LOCAL_OUT);
+		skb->nf_debug ^=3D (1 << NF_IP_LOCAL_OUT);
 #endif
=20
=2D			NF_HOOK_THRESH(PF_INET, NF_IP_LOCAL_OUT, skb, realindev,
=2D				       realoutdev, okfn,
=2D				       NF_IP_PRI_BRIDGE_SABOTAGE_LOCAL_OUT + 1);
=2D		}
+		NF_HOOK_THRESH(pf, NF_IP_LOCAL_OUT, skb, realindev,
+			       realoutdev, br_nf_local_out_finish,
+			       NF_IP_PRI_BRIDGE_SABOTAGE_LOCAL_OUT + 1);
 	}
=20
+out:
 	return NF_STOLEN;
 }
=20
@@ -598,6 +701,7 @@ static unsigned int br_nf_post_routing(u
 	struct nf_bridge_info *nf_bridge =3D (*pskb)->nf_bridge;
 	struct vlan_ethhdr *hdr =3D (struct vlan_ethhdr *)(skb->mac.ethernet);
 	struct net_device *realoutdev =3D bridge_parent(skb->dev);
+	int pf;
=20
 #ifdef CONFIG_NETFILTER_DEBUG
 	/* Be very paranoid. This probably won't happen anymore, but let's
@@ -609,19 +713,15 @@ static unsigned int br_nf_post_routing(u
 	}
 #endif
=20
=2D#ifdef CONFIG_SYSCTL
 	if (!nf_bridge)
 		return NF_ACCEPT;
=2D#endif
=20
=2D	if (skb->protocol !=3D __constant_htons(ETH_P_IP) && !IS_VLAN_IP)
=2D		return NF_ACCEPT;
+	if (skb->protocol =3D=3D __constant_htons(ETH_P_IP) || IS_VLAN_IP)
+		pf =3D PF_INET;
+	else
+		pf =3D PF_INET6;
=20
 #ifdef CONFIG_NETFILTER_DEBUG
=2D	/* Sometimes we get packets with NULL ->dst here (for example,
=2D	 * running a dhcp client daemon triggers this). This should now
=2D	 * be fixed, but let's keep the check around.
=2D	 */
 	if (skb->dst =3D=3D NULL) {
 		printk(KERN_CRIT "br_netfilter: skb->dst =3D=3D NULL.");
 		goto print_error;
@@ -631,8 +731,7 @@ static unsigned int br_nf_post_routing(u
 #endif
=20
 	/* We assume any code from br_dev_queue_push_xmit onwards doesn't care
=2D	 * about the value of skb->pkt_type.
=2D	 */
+	 * about the value of skb->pkt_type. */
 	if (skb->pkt_type =3D=3D PACKET_OTHERHOST) {
 		skb->pkt_type =3D PACKET_HOST;
 		nf_bridge->mask |=3D BRNF_PKT_TYPE;
@@ -649,8 +748,8 @@ static unsigned int br_nf_post_routing(u
 	if (nf_bridge->netoutdev)
 		realoutdev =3D nf_bridge->netoutdev;
 #endif
=2D	NF_HOOK(PF_INET, NF_IP_POST_ROUTING, skb, NULL,
=2D		realoutdev, br_dev_queue_push_xmit);
+	NF_HOOK(pf, NF_IP_POST_ROUTING, skb, NULL, realoutdev,
+	        br_dev_queue_push_xmit);
=20
 	return NF_STOLEN;
=20
@@ -668,12 +767,10 @@ print_error:
 }
=20
=20
=2D/* IPv4/SABOTAGE *****************************************************/
=2D
=2D/* Don't hand locally destined packets to PF_INET/PRE_ROUTING
=2D * for the second time.
=2D */
=2Dstatic unsigned int ipv4_sabotage_in(unsigned int hook, struct sk_buff *=
*pskb,
+/* IP/SABOTAGE *****************************************************/
+/* Don't hand locally destined packets to PF_INET(6)/PRE_ROUTING
+ * for the second time. */
+static unsigned int ip_sabotage_in(unsigned int hook, struct sk_buff **psk=
b,
    const struct net_device *in, const struct net_device *out,
    int (*okfn)(struct sk_buff *))
 {
@@ -686,19 +783,27 @@ static unsigned int ipv4_sabotage_in(uns
 	return NF_ACCEPT;
 }
=20
=2D/* Postpone execution of PF_INET/FORWARD, PF_INET/LOCAL_OUT
=2D * and PF_INET/POST_ROUTING until we have done the forwarding
=2D * decision in the bridge code and have determined skb->physoutdev.
=2D */
=2Dstatic unsigned int ipv4_sabotage_out(unsigned int hook, struct sk_buff =
**pskb,
+/* Postpone execution of PF_INET(6)/FORWARD, PF_INET(6)/LOCAL_OUT
+ * and PF_INET(6)/POST_ROUTING until we have done the forwarding
+ * decision in the bridge code and have determined nf_bridge->physoutdev. =
*/
+static unsigned int ip_sabotage_out(unsigned int hook, struct sk_buff **ps=
kb,
    const struct net_device *in, const struct net_device *out,
    int (*okfn)(struct sk_buff *))
 {
 	struct sk_buff *skb =3D *pskb;
=20
 #ifdef CONFIG_SYSCTL
=2D	if (!brnf_call_iptables && !skb->nf_bridge)
=2D		return NF_ACCEPT;
+	if (!skb->nf_bridge) {
+		struct vlan_ethhdr *hdr =3D
+		   (struct vlan_ethhdr *)(skb->mac.ethernet);
+
+		if (skb->protocol =3D=3D __constant_htons(ETH_P_IP) ||
+		    IS_VLAN_IP) {
+			if (!brnf_call_iptables)
+				return NF_ACCEPT;
+		} else if (!brnf_call_ip6tables)
+			return NF_ACCEPT;
+	}
 #endif
=20
 	if ((out->hard_start_xmit =3D=3D br_dev_xmit &&
@@ -721,8 +826,7 @@ static unsigned int ipv4_sabotage_out(un
 		 * will need the indev then. For a brouter, the real indev
 		 * can be a bridge port, so we make sure br_nf_local_out()
 		 * doesn't use the bridge parent of the indev by using
=2D		 * the BRNF_DONT_TAKE_PARENT mask.
=2D		 */
+		 * the BRNF_DONT_TAKE_PARENT mask. */
 		if (hook =3D=3D NF_IP_FORWARD && nf_bridge->physindev =3D=3D NULL) {
 			nf_bridge->mask &=3D BRNF_DONT_TAKE_PARENT;
 			nf_bridge->physindev =3D (struct net_device *)in;
@@ -742,8 +846,7 @@ static unsigned int ipv4_sabotage_out(un
 /* For br_nf_local_out we need (prio =3D NF_BR_PRI_FIRST), to insure that =
innocent
  * PF_BRIDGE/NF_BR_LOCAL_OUT functions don't get bridged traffic as input.
  * For br_nf_post_routing, we need (prio =3D NF_BR_PRI_LAST), because
=2D * ip_refrag() can return NF_STOLEN.
=2D */
+ * ip_refrag() can return NF_STOLEN. */
 static struct nf_hook_ops br_nf_ops[] =3D {
 	{ .hook =3D br_nf_pre_routing,=20
 	  .owner =3D THIS_MODULE,=20
@@ -775,26 +878,46 @@ static struct nf_hook_ops br_nf_ops[] =3D=20
 	  .pf =3D PF_BRIDGE,
 	  .hooknum =3D NF_BR_POST_ROUTING,
 	  .priority =3D NF_BR_PRI_LAST, },
=2D	{ .hook =3D ipv4_sabotage_in,
+	{ .hook =3D ip_sabotage_in,
 	  .owner =3D THIS_MODULE,
 	  .pf =3D PF_INET,
 	  .hooknum =3D NF_IP_PRE_ROUTING,
 	  .priority =3D NF_IP_PRI_FIRST, },
=2D	{ .hook =3D ipv4_sabotage_out,
+	{ .hook =3D ip_sabotage_in,
+	  .owner =3D THIS_MODULE,
+	  .pf =3D PF_INET6,
+	  .hooknum =3D NF_IP6_PRE_ROUTING,
+	  .priority =3D NF_IP6_PRI_FIRST, },
+	{ .hook =3D ip_sabotage_out,
 	  .owner =3D THIS_MODULE,
 	  .pf =3D PF_INET,
 	  .hooknum =3D NF_IP_FORWARD,
 	  .priority =3D NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD, },
=2D	{ .hook =3D ipv4_sabotage_out,
+	{ .hook =3D ip_sabotage_out,
+	  .owner =3D THIS_MODULE,
+	  .pf =3D PF_INET6,
+	  .hooknum =3D NF_IP6_FORWARD,
+	  .priority =3D NF_IP6_PRI_BRIDGE_SABOTAGE_FORWARD, },
+	{ .hook =3D ip_sabotage_out,
 	  .owner =3D THIS_MODULE,
 	  .pf =3D PF_INET,
 	  .hooknum =3D NF_IP_LOCAL_OUT,
 	  .priority =3D NF_IP_PRI_BRIDGE_SABOTAGE_LOCAL_OUT, },
=2D	{ .hook =3D ipv4_sabotage_out,
+	{ .hook =3D ip_sabotage_out,
+	  .owner =3D THIS_MODULE,
+	  .pf =3D PF_INET6,
+	  .hooknum =3D NF_IP6_LOCAL_OUT,
+	  .priority =3D NF_IP6_PRI_BRIDGE_SABOTAGE_LOCAL_OUT, },
+	{ .hook =3D ip_sabotage_out,
 	  .owner =3D THIS_MODULE,
 	  .pf =3D PF_INET,
 	  .hooknum =3D NF_IP_POST_ROUTING,
 	  .priority =3D NF_IP_PRI_FIRST, },
+	{ .hook =3D ip_sabotage_out,
+	  .owner =3D THIS_MODULE,
+	  .pf =3D PF_INET6,
+	  .hooknum =3D NF_IP6_POST_ROUTING,
+	  .priority =3D NF_IP6_PRI_FIRST, },
 };
=20
 #ifdef CONFIG_SYSCTL
@@ -829,6 +952,14 @@ static ctl_table brnf_table[] =3D {
 		.proc_handler	=3D &brnf_sysctl_call_tables,
 	},
 	{
+		.ctl_name	=3D NET_BRIDGE_NF_CALL_IP6TABLES,
+		.procname	=3D "bridge-nf-call-ip6tables",
+		.data		=3D &brnf_call_ip6tables,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &brnf_sysctl_call_tables,
+	},
+	{
 		.ctl_name	=3D NET_BRIDGE_NF_FILTER_VLAN_TAGGED,
 		.procname	=3D "bridge-nf-filter-vlan-tagged",
 		.data		=3D &brnf_filter_vlan_tagged,
=2D-- linux-2.6.8.1/Documentation/networking/ip-sysctl.txt.old	2004-09-01 2=
2:18:10.000000000 +0200
+++ linux-2.6.8.1/Documentation/networking/ip-sysctl.txt	2004-09-01 21:09:5=
8.000000000 +0200
@@ -837,6 +837,11 @@ bridge-nf-call-iptables - BOOLEAN
 	0 : disable this.
 	Default: 1
=20
+bridge-nf-call-ip6tables - BOOLEAN
+	1 : pass bridged IPv6 traffic to ip6tables' chains.
+	0 : disable this.
+	Default: 1
+
 bridge-nf-filter-vlan-tagged - BOOLEAN
 	1 : pass bridged vlan-tagged ARP/IP traffic to arptables/iptables.
 	0 : disable this.
