From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [POM-NG 3/10] Fix the ROUTE extension for 2.6.16 kernels
Date: Mon, 27 Mar 2006 14:17:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603271416200.17570@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-237918837-1143461832=:17570"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-237918837-1143461832=:17570
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

[POM-NG 3/10] Fix the ROUTE extension for 2.6.16 kernels

This patch allows the ROUTE extension to be used with 2.6.16 kernels.
It also removes additional instances of patches for older 2.6.x kernels
as per decision to keep in pom-ng only patches for the most recent kernels.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/i=
pv4/netfilter/ipt_ROUTE.c patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2=
=2E6.11/net/ipv4/netfilter/ipt_ROUTE.c
--- patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/ipv4/ne=
tfilter/ipt_ROUTE.c=092005-11-03 19:06:37.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6.11/net/ipv4/netfilt=
er/ipt_ROUTE.c=091970-01-01 01:00:00.000000000 +0100
@@ -1,463 +0,0 @@
-/*
- * This implements the ROUTE target, which enables you to setup unusual
- * routes not supported by the standard kernel routing table.
- *
- * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
- *
- * v 1.11 2004/11/23
- *
- * This software is distributed under GNU GPL v2, 1991
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
-#include <linux/netfilter_ipv4/ipt_ROUTE.h>
-#include <linux/netdevice.h>
-#include <linux/route.h>
-#include <net/ip.h>
-#include <net/route.h>
-#include <net/icmp.h>
-#include <net/checksum.h>
-
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Cedric de Launois <delaunois@info.ucl.ac.be>");
-MODULE_DESCRIPTION("iptables ROUTE target module");
-
-/* Try to route the packet according to the routing keys specified in
- * route_info. Keys are :
- *  - ifindex :=20
- *      0 if no oif preferred,=20
- *      otherwise set to the index of the desired oif
- *  - route_info->gw :
- *      0 if no gateway specified,
- *      otherwise set to the next host to which the pkt must be routed
- * If success, skb->dev is the output device to which the packet must=20
- * be sent and skb->dst is not NULL
- *
- * RETURN: -1 if an error occured
- *          1 if the packet was succesfully routed to the=20
- *            destination desired
- *          0 if the kernel routing table could not route the packet
- *            according to the keys specified
- */
-static int route(struct sk_buff *skb,
-=09=09 unsigned int ifindex,
-=09=09 const struct ipt_route_target_info *route_info)
-{
-=09int err;
-=09struct rtable *rt;
-=09struct iphdr *iph =3D skb->nh.iph;
-=09struct flowi fl =3D {
-=09=09.oif =3D ifindex,
-=09=09.nl_u =3D {
-=09=09=09.ip4_u =3D {
-=09=09=09=09.daddr =3D iph->daddr,
-=09=09=09=09.saddr =3D 0,
-=09=09=09=09.tos =3D RT_TOS(iph->tos),
-=09=09=09=09.scope =3D RT_SCOPE_UNIVERSE,
-=09=09=09}
-=09=09}=20
-=09};
-=20
-=09/* The destination address may be overloaded by the target */
-=09if (route_info->gw)
-=09=09fl.fl4_dst =3D route_info->gw;
-=20
-=09/* Trying to route the packet using the standard routing table. */
-=09if ((err =3D ip_route_output_key(&rt, &fl))) {
-=09=09if (net_ratelimit())=20
-=09=09=09DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
-=09=09return -1;
-=09}
-=20
-=09/* Drop old route. */
-=09dst_release(skb->dst);
-=09skb->dst =3D NULL;
-
-=09/* Success if no oif specified or if the oif correspond to the=20
-=09 * one desired */
-=09if (!ifindex || rt->u.dst.dev->ifindex =3D=3D ifindex) {
-=09=09skb->dst =3D &rt->u.dst;
-=09=09skb->dev =3D skb->dst->dev;
-=09=09skb->protocol =3D htons(ETH_P_IP);
-=09=09return 1;
-=09}
-=20
-=09/* The interface selected by the routing table is not the one
-=09 * specified by the user. This may happen because the dst address
-=09 * is one of our own addresses.
-=09 */
-=09if (net_ratelimit())=20
-=09=09DEBUGP("ipt_ROUTE: failed to route as desired gw=3D%u.%u.%u.%u oif=
=3D%i (got oif=3D%i)\n",=20
-=09=09       NIPQUAD(route_info->gw), ifindex, rt->u.dst.dev->ifindex);
-=20
-=09return 0;
-}
-
-
-/* Stolen from ip_finish_output2
- * PRE : skb->dev is set to the device we are leaving by
- *       skb->dst is not NULL
- * POST: the packet is sent with the link layer header pushed
- *       the packet is destroyed
- */
-static void ip_direct_send(struct sk_buff *skb)
-{
-=09struct dst_entry *dst =3D skb->dst;
-=09struct hh_cache *hh =3D dst->hh;
-=09struct net_device *dev =3D dst->dev;
-=09int hh_len =3D LL_RESERVED_SPACE(dev);
-
-=09/* Be paranoid, rather than too clever. */
-=09if (unlikely(skb_headroom(skb) < hh_len && dev->hard_header)) {
-=09=09struct sk_buff *skb2;
-
-=09=09skb2 =3D skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
-=09=09if (skb2 =3D=3D NULL) {
-=09=09=09kfree_skb(skb);
-=09=09=09return;
-=09=09}
-=09=09if (skb->sk)
-=09=09=09skb_set_owner_w(skb2, skb->sk);
-=09=09kfree_skb(skb);
-=09=09skb =3D skb2;
-=09}
-
-=09if (hh) {
-=09=09int hh_alen;
-
-=09=09read_lock_bh(&hh->hh_lock);
-=09=09hh_alen =3D HH_DATA_ALIGN(hh->hh_len);
-  =09=09memcpy(skb->data - hh_alen, hh->hh_data, hh_alen);
-=09=09read_unlock_bh(&hh->hh_lock);
-=09=09skb_push(skb, hh->hh_len);
-=09=09hh->hh_output(skb);
-=09} else if (dst->neighbour)
-=09=09dst->neighbour->output(skb);
-=09else {
-=09=09if (net_ratelimit())
-=09=09=09DEBUGP(KERN_DEBUG "ipt_ROUTE: no hdr & no neighbour cache!\n");
-=09=09kfree_skb(skb);
-=09}
-}
-
-
-/* PRE : skb->dev is set to the device we are leaving by
- * POST: - the packet is directly sent to the skb->dev device, without=20
- *         pushing the link layer header.
- *       - the packet is destroyed
- */
-static inline int dev_direct_send(struct sk_buff *skb)
-{
-=09return dev_queue_xmit(skb);
-}
-
-
-static unsigned int route_oif(const struct ipt_route_target_info *route_in=
fo,
-=09=09=09      struct sk_buff *skb)=20
-{
-=09unsigned int ifindex =3D 0;
-=09struct net_device *dev_out =3D NULL;
-
-=09/* The user set the interface name to use.
-=09 * Getting the current interface index.
-=09 */
-=09if ((dev_out =3D dev_get_by_name(route_info->oif))) {
-=09=09ifindex =3D dev_out->ifindex;
-=09} else {
-=09=09/* Unknown interface name : packet dropped */
-=09=09if (net_ratelimit())=20
-=09=09=09DEBUGP("ipt_ROUTE: oif interface %s not found\n", route_info->oif=
);
-=09=09return NF_DROP;
-=09}
-
-=09/* Trying the standard way of routing packets */
-=09switch (route(skb, ifindex, route_info)) {
-=09case 1:
-=09=09dev_put(dev_out);
-=09=09if (route_info->flags & IPT_ROUTE_CONTINUE)
-=09=09=09return IPT_CONTINUE;
-
-=09=09ip_direct_send(skb);
-=09=09return NF_STOLEN;
-
-=09case 0:
-=09=09/* Failed to send to oif. Trying the hard way */
-=09=09if (route_info->flags & IPT_ROUTE_CONTINUE)
-=09=09=09return NF_DROP;
-
-=09=09if (net_ratelimit())=20
-=09=09=09DEBUGP("ipt_ROUTE: forcing the use of %i\n",
-=09=09=09       ifindex);
-
-=09=09/* We have to force the use of an interface.
-=09=09 * This interface must be a tunnel interface since
-=09=09 * otherwise we can't guess the hw address for
-=09=09 * the packet. For a tunnel interface, no hw address
-=09=09 * is needed.
-=09=09 */
-=09=09if ((dev_out->type !=3D ARPHRD_TUNNEL)
-=09=09    && (dev_out->type !=3D ARPHRD_IPGRE)) {
-=09=09=09if (net_ratelimit())=20
-=09=09=09=09DEBUGP("ipt_ROUTE: can't guess the hw addr !\n");
-=09=09=09dev_put(dev_out);
-=09=09=09return NF_DROP;
-=09=09}
-=20
-=09=09/* Send the packet. This will also free skb
-=09=09 * Do not go through the POST_ROUTING hook because=20
-=09=09 * skb->dst is not set and because it will probably
-=09=09 * get confused by the destination IP address.
-=09=09 */
-=09=09skb->dev =3D dev_out;
-=09=09dev_direct_send(skb);
-=09=09dev_put(dev_out);
-=09=09return NF_STOLEN;
-=20
-=09default:
-=09=09/* Unexpected error */
-=09=09dev_put(dev_out);
-=09=09return NF_DROP;
-=09}
-}
-
-
-static unsigned int route_iif(const struct ipt_route_target_info *route_in=
fo,
-=09=09=09      struct sk_buff *skb)=20
-{
-=09struct net_device *dev_in =3D NULL;
-
-=09/* Getting the current interface index. */
-=09if (!(dev_in =3D dev_get_by_name(route_info->iif))) {
-=09=09if (net_ratelimit())=20
-=09=09=09DEBUGP("ipt_ROUTE: iif interface %s not found\n", route_info->iif=
);
-=09=09return NF_DROP;
-=09}
-
-=09skb->dev =3D dev_in;
-=09dst_release(skb->dst);
-=09skb->dst =3D NULL;
-
-=09netif_rx(skb);
-=09dev_put(dev_in);
-=09return NF_STOLEN;
-}
-
-
-static unsigned int route_gw(const struct ipt_route_target_info *route_inf=
o,
-=09=09=09     struct sk_buff *skb)=20
-{
-=09if (route(skb, 0, route_info)!=3D1)
-=09=09return NF_DROP;
-
-=09if (route_info->flags & IPT_ROUTE_CONTINUE)
-=09=09return IPT_CONTINUE;
-
-=09ip_direct_send(skb);
-=09return NF_STOLEN;
-}
-
-
-/* To detect and deter routed packet loopback when using the --tee option,
- * we take a page out of the raw.patch book: on the copied skb, we set up
- * a fake ->nfct entry, pointing to the local &route_tee_track. We skip
- * routing packets when we see they already have that ->nfct.
- */
-
-static struct ip_conntrack route_tee_track;
-
-static unsigned int ipt_route_target(struct sk_buff **pskb,
-=09=09=09=09     const struct net_device *in,
-=09=09=09=09     const struct net_device *out,
-=09=09=09=09     unsigned int hooknum,
-=09=09=09=09     const void *targinfo,
-=09=09=09=09     void *userinfo)
-{
-=09const struct ipt_route_target_info *route_info =3D targinfo;
-=09struct sk_buff *skb =3D *pskb;
-=09unsigned int res;
-
-=09if (skb->nfct =3D=3D &route_tee_track.ct_general) {
-=09=09/* Loopback - a packet we already routed, is to be
-=09=09 * routed another time. Avoid that, now.
-=09=09 */
-=09=09if (net_ratelimit())=20
-=09=09=09DEBUGP(KERN_DEBUG "ipt_ROUTE: loopback - DROP!\n");
-=09=09return NF_DROP;
-=09}
-
-=09/* If we are at PREROUTING or INPUT hook
-=09 * the TTL isn't decreased by the IP stack
-=09 */
-=09if (hooknum =3D=3D NF_IP_PRE_ROUTING ||
-=09    hooknum =3D=3D NF_IP_LOCAL_IN) {
-
-=09=09struct iphdr *iph =3D skb->nh.iph;
-
-=09=09if (iph->ttl <=3D 1) {
-=09=09=09struct rtable *rt;
-=09=09=09struct flowi fl =3D {
-=09=09=09=09.oif =3D 0,
-=09=09=09=09.nl_u =3D {
-=09=09=09=09=09.ip4_u =3D {
-=09=09=09=09=09=09.daddr =3D iph->daddr,
-=09=09=09=09=09=09.saddr =3D iph->saddr,
-=09=09=09=09=09=09.tos =3D RT_TOS(iph->tos),
-=09=09=09=09=09=09.scope =3D ((iph->tos & RTO_ONLINK) ?
-=09=09=09=09=09=09=09  RT_SCOPE_LINK :
-=09=09=09=09=09=09=09  RT_SCOPE_UNIVERSE)
-=09=09=09=09=09}
-=09=09=09=09}=20
-=09=09=09};
-
-=09=09=09if (ip_route_output_key(&rt, &fl)) {
-=09=09=09=09return NF_DROP;
-=09=09=09}
-
-=09=09=09if (skb->dev =3D=3D rt->u.dst.dev) {
-=09=09=09=09/* Drop old route. */
-=09=09=09=09dst_release(skb->dst);
-=09=09=09=09skb->dst =3D &rt->u.dst;
-
-=09=09=09=09/* this will traverse normal stack, and=20
-=09=09=09=09 * thus call conntrack on the icmp packet */
-=09=09=09=09icmp_send(skb, ICMP_TIME_EXCEEDED,=20
-=09=09=09=09=09  ICMP_EXC_TTL, 0);
-=09=09=09}
-
-=09=09=09return NF_DROP;
-=09=09}
-
-=09=09/*
-=09=09 * If we are at INPUT the checksum must be recalculated since
-=09=09 * the length could change as the result of a defragmentation.
-=09=09 */
-=09=09if(hooknum =3D=3D NF_IP_LOCAL_IN) {
-=09=09=09iph->ttl =3D iph->ttl - 1;
-=09=09=09iph->check =3D 0;
-=09=09=09iph->check =3D ip_fast_csum((unsigned char *)iph, iph->ihl);
-=09=09} else {
-=09=09=09ip_decrease_ttl(iph);
-=09=09}
-=09}
-
-=09if ((route_info->flags & IPT_ROUTE_TEE)) {
-=09=09/*
-=09=09 * Copy the *pskb, and route the copy. Will later return
-=09=09 * IPT_CONTINUE for the original skb, which should continue
-=09=09 * on its way as if nothing happened. The copy should be
-=09=09 * independantly delivered to the ROUTE --gw.
-=09=09 */
-=09=09skb =3D skb_copy(*pskb, GFP_ATOMIC);
-=09=09if (!skb) {
-=09=09=09if (net_ratelimit())=20
-=09=09=09=09DEBUGP(KERN_DEBUG "ipt_ROUTE: copy failed!\n");
-=09=09=09return IPT_CONTINUE;
-=09=09}
-=09}
-
-=09/* Tell conntrack to forget this packet since it may get confused=20
-=09 * when a packet is leaving with dst address =3D=3D our address.
-=09 * Good idea ? Dunno. Need advice.
-=09 *
-=09 * NEW: mark the skb with our &route_tee_track, so we avoid looping
-=09 * on any already routed packet.
-=09 */
-=09if (!(route_info->flags & IPT_ROUTE_CONTINUE)) {
-=09=09nf_conntrack_put(skb->nfct);
-=09=09skb->nfct =3D &route_tee_track.ct_general;
-=09=09skb->nfctinfo =3D IP_CT_NEW;
-=09=09nf_conntrack_get(skb->nfct);
-#ifdef CONFIG_NETFILTER_DEBUG
-=09=09skb->nf_debug =3D 0;
-#endif
-=09}
-
-=09if (route_info->oif[0] !=3D '\0') {
-=09=09res =3D route_oif(route_info, skb);
-=09} else if (route_info->iif[0] !=3D '\0') {
-=09=09res =3D route_iif(route_info, skb);
-=09} else if (route_info->gw) {
-=09=09res =3D route_gw(route_info, skb);
-=09} else {
-=09=09if (net_ratelimit())=20
-=09=09=09DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
-=09=09res =3D IPT_CONTINUE;
-=09}
-
-=09if ((route_info->flags & IPT_ROUTE_TEE))
-=09=09res =3D IPT_CONTINUE;
-
-=09return res;
-}
-
-
-static int ipt_route_checkentry(const char *tablename,
-=09=09=09=09const struct ipt_entry *e,
-=09=09=09=09void *targinfo,
-=09=09=09=09unsigned int targinfosize,
-=09=09=09=09unsigned int hook_mask)
-{
-=09if (strcmp(tablename, "mangle") !=3D 0) {
-=09=09printk("ipt_ROUTE: bad table `%s', use the `mangle' table.\n",
-=09=09       tablename);
-=09=09return 0;
-=09}
-
-=09if (hook_mask & ~(  (1 << NF_IP_PRE_ROUTING)
-=09=09=09    | (1 << NF_IP_LOCAL_IN)
-=09=09=09    | (1 << NF_IP_FORWARD)
-=09=09=09    | (1 << NF_IP_LOCAL_OUT)
-=09=09=09    | (1 << NF_IP_POST_ROUTING))) {
-=09=09printk("ipt_ROUTE: bad hook\n");
-=09=09return 0;
-=09}
-
-=09if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_route_target_info))) =
{
-=09=09printk(KERN_WARNING "ipt_ROUTE: targinfosize %u !=3D %Zu\n",
-=09=09       targinfosize,
-=09=09       IPT_ALIGN(sizeof(struct ipt_route_target_info)));
-=09=09return 0;
-=09}
-
-=09return 1;
-}
-
-
-static struct ipt_target ipt_route_reg =3D {=20
-=09.name =3D "ROUTE",
-=09.target =3D ipt_route_target,
-=09.checkentry =3D ipt_route_checkentry,
-=09.me =3D THIS_MODULE,
-};
-
-static int __init init(void)
-{
-=09/* Set up fake conntrack (stolen from raw.patch):
-=09    - to never be deleted, not in any hashes */
-=09atomic_set(&route_tee_track.ct_general.use, 1);
-=09/*  - and look it like as a confirmed connection */
-=09set_bit(IPS_CONFIRMED_BIT, &route_tee_track.status);
-=09/* Initialize fake conntrack so that NAT will skip it */
-=09route_tee_track.status |=3D IPS_NAT_DONE_MASK;
-
-=09return ipt_register_target(&ipt_route_reg);
-}
-
-
-static void __exit fini(void)
-{
-=09ipt_unregister_target(&ipt_route_reg);
-}
-
-module_init(init);
-module_exit(fini);
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/i=
pv4/netfilter/Makefile.ladd patch-o-matic-ng-20060311/patchlets/ROUTE/linux=
-2.6.11/net/ipv4/netfilter/Makefile.ladd
--- patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/ipv4/ne=
tfilter/Makefile.ladd=092004-05-06 14:41:19.000000000 +0200
+++ patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6.11/net/ipv4/netfilt=
er/Makefile.ladd=091970-01-01 01:00:00.000000000 +0100
@@ -1,2 +0,0 @@
-obj-$(CONFIG_IP_NF_TARGET_REDIRECT) +=3D ipt_REDIRECT.o
-obj-$(CONFIG_IP_NF_TARGET_ROUTE) +=3D ipt_ROUTE.o
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/i=
pv4/netfilter/Kconfig.ladd patch-o-matic-ng-20060311/patchlets/ROUTE/linux-=
2.6.11/net/ipv4/netfilter/Kconfig.ladd
--- patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/ipv4/ne=
tfilter/Kconfig.ladd=092004-05-06 14:41:19.000000000 +0200
+++ patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6.11/net/ipv4/netfilt=
er/Kconfig.ladd=091970-01-01 01:00:00.000000000 +0100
@@ -1,16 +0,0 @@
-config IP_NF_TARGET_ROUTE
-=09tristate  'ROUTE target support'
-=09depends on IP_NF_MANGLE
-=09help
-=09  This option adds a `ROUTE' target, which enables you to setup unusual
-=09  routes. For example, the ROUTE lets you route a received packet throu=
gh=20
-=09  an interface or towards a host, even if the regular destination of th=
e=20
-=09  packet is the router itself. The ROUTE target is also able to change =
the=20
-=09  incoming interface of a packet.
-=20
-=09  The target can be or not a final target. It has to be used inside the=
=20
-=09  mangle table.
-=20
-=09  If you want to compile it as a module, say M here and read
-=09  Documentation/modules.txt.  The module will be called ipt_ROUTE.o.
-=09  If unsure, say `N'.
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/i=
pv6/netfilter/Makefile.ladd patch-o-matic-ng-20060311/patchlets/ROUTE/linux=
-2.6.11/net/ipv6/netfilter/Makefile.ladd
--- patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/ipv6/ne=
tfilter/Makefile.ladd=092004-05-06 14:41:19.000000000 +0200
+++ patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6.11/net/ipv6/netfilt=
er/Makefile.ladd=091970-01-01 01:00:00.000000000 +0100
@@ -1,2 +0,0 @@
-obj-$(CONFIG_IP6_NF_TARGET_MARK) +=3D ip6t_MARK.o
-obj-$(CONFIG_IP6_NF_TARGET_ROUTE) +=3D ip6t_ROUTE.o
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/i=
pv6/netfilter/Kconfig.ladd patch-o-matic-ng-20060311/patchlets/ROUTE/linux-=
2.6.11/net/ipv6/netfilter/Kconfig.ladd
--- patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/ipv6/ne=
tfilter/Kconfig.ladd=092004-05-06 14:41:19.000000000 +0200
+++ patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6.11/net/ipv6/netfilt=
er/Kconfig.ladd=091970-01-01 01:00:00.000000000 +0100
@@ -1,12 +0,0 @@
-config IP6_NF_TARGET_ROUTE
-=09tristate '    ROUTE target support'
-=09depends on IP6_NF_MANGLE
-=09help
-=09  This option adds a `ROUTE' target, which enables you to setup unusual
-=09  routes. The ROUTE target is also able to change the incoming interfac=
e
-=09  of a packet.
-=20
-=09  The target can be or not a final target. It has to be used inside the=
=20
-=09  mangle table.
-=20
-=09  Not working as a module.
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/i=
pv6/netfilter/ip6t_ROUTE.c patch-o-matic-ng-20060311/patchlets/ROUTE/linux-=
2.6.11/net/ipv6/netfilter/ip6t_ROUTE.c
--- patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/net/ipv6/ne=
tfilter/ip6t_ROUTE.c=092005-06-27 15:31:54.000000000 +0200
+++ patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6.11/net/ipv6/netfilt=
er/ip6t_ROUTE.c=091970-01-01 01:00:00.000000000 +0100
@@ -1,308 +0,0 @@
-/*
- * This implements the ROUTE v6 target, which enables you to setup unusual
- * routes not supported by the standard kernel routing table.
- *
- * Copyright (C) 2003 Cedric de Launois <delaunois@info.ucl.ac.be>
- *
- * v 1.1 2004/11/23
- *
- * This software is distributed under GNU GPL v2, 1991
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ipv6.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter_ipv6/ip6t_ROUTE.h>
-#include <linux/netdevice.h>
-#include <net/ipv6.h>
-#include <net/ndisc.h>
-#include <net/ip6_route.h>
-#include <linux/icmpv6.h>
-
-#if 1
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
-#define NIP6(addr) \
-=09ntohs((addr).s6_addr16[0]), \
-=09ntohs((addr).s6_addr16[1]), \
-=09ntohs((addr).s6_addr16[2]), \
-=09ntohs((addr).s6_addr16[3]), \
-=09ntohs((addr).s6_addr16[4]), \
-=09ntohs((addr).s6_addr16[5]), \
-=09ntohs((addr).s6_addr16[6]), \
-=09ntohs((addr).s6_addr16[7])
-
-/* Route the packet according to the routing keys specified in
- * route_info. Keys are :
- *  - ifindex :=20
- *      0 if no oif preferred,=20
- *      otherwise set to the index of the desired oif
- *  - route_info->gw :
- *      0 if no gateway specified,
- *      otherwise set to the next host to which the pkt must be routed
- * If success, skb->dev is the output device to which the packet must=20
- * be sent and skb->dst is not NULL
- *
- * RETURN:  1 if the packet was succesfully routed to the=20
- *            destination desired
- *          0 if the kernel routing table could not route the packet
- *            according to the keys specified
- */
-static int=20
-route6(struct sk_buff *skb,
-       unsigned int ifindex,
-       const struct ip6t_route_target_info *route_info)
-{
-=09struct rt6_info *rt =3D NULL;
-=09struct ipv6hdr *ipv6h =3D skb->nh.ipv6h;
-=09struct in6_addr *gw =3D (struct in6_addr*)&route_info->gw;
-
-=09DEBUGP("ip6t_ROUTE: called with: ");
-=09DEBUGP("DST=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(ipv6h->da=
ddr));
-=09DEBUGP("GATEWAY=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(*gw))=
;
-=09DEBUGP("OUT=3D%s\n", route_info->oif);
-=20
-=09if (ipv6_addr_any(gw))
-=09=09rt =3D rt6_lookup(&ipv6h->daddr, &ipv6h->saddr, ifindex, 1);
-=09else
-=09=09rt =3D rt6_lookup(gw, &ipv6h->saddr, ifindex, 1);
-
-=09if (!rt)
-=09=09goto no_route;
-
-=09DEBUGP("ip6t_ROUTE: routing gives: ");
-=09DEBUGP("DST=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(rt->rt6i_=
dst.addr));
-=09DEBUGP("GATEWAY=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(rt->r=
t6i_gateway));
-=09DEBUGP("OUT=3D%s\n", rt->rt6i_dev->name);
-
-=09if (ifindex && rt->rt6i_dev->ifindex!=3Difindex)
-=09=09goto wrong_route;
-=20
-=09if (!rt->rt6i_nexthop) {
-=09=09DEBUGP("ip6t_ROUTE: discovering neighbour\n");
-=09=09rt->rt6i_nexthop =3D ndisc_get_neigh(rt->rt6i_dev, &rt->rt6i_dst.add=
r);
-=09}
-
-=09/* Drop old route. */
-=09dst_release(skb->dst);
-=09skb->dst =3D &rt->u.dst;
-=09skb->dev =3D rt->rt6i_dev;
-=09return 1;
-
- wrong_route:
-=09dst_release(&rt->u.dst);
- no_route:
-=09if (!net_ratelimit())
-=09=09return 0;
-
-=09printk("ip6t_ROUTE: no explicit route found ");
-=09if (ifindex)
-=09=09printk("via interface %s ", route_info->oif);
-=09if (!ipv6_addr_any(gw))
-=09=09printk("via gateway %04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x", NIP6(*=
gw));
-=09printk("\n");
-=09return 0;
-}
-
-
-/* Stolen from ip6_output_finish
- * PRE : skb->dev is set to the device we are leaving by
- *       skb->dst is not NULL
- * POST: the packet is sent with the link layer header pushed
- *       the packet is destroyed
- */
-static void ip_direct_send(struct sk_buff *skb)
-{
-=09struct dst_entry *dst =3D skb->dst;
-=09struct hh_cache *hh =3D dst->hh;
-
-=09if (hh) {
-=09=09read_lock_bh(&hh->hh_lock);
-=09=09memcpy(skb->data - 16, hh->hh_data, 16);
-=09=09read_unlock_bh(&hh->hh_lock);
-=09=09skb_push(skb, hh->hh_len);
-=09=09hh->hh_output(skb);
-=09} else if (dst->neighbour)
-=09=09dst->neighbour->output(skb);
-=09else {
-=09=09if (net_ratelimit())
-=09=09=09DEBUGP(KERN_DEBUG "ip6t_ROUTE: no hdr & no neighbour cache!\n");
-=09=09kfree_skb(skb);
-=09}
-}
-
-
-static unsigned int=20
-route6_oif(const struct ip6t_route_target_info *route_info,
-=09   struct sk_buff *skb)=20
-{
-=09unsigned int ifindex =3D 0;
-=09struct net_device *dev_out =3D NULL;
-
-=09/* The user set the interface name to use.
-=09 * Getting the current interface index.
-=09 */
-=09if ((dev_out =3D dev_get_by_name(route_info->oif))) {
-=09=09ifindex =3D dev_out->ifindex;
-=09} else {
-=09=09/* Unknown interface name : packet dropped */
-=09=09if (net_ratelimit())=20
-=09=09=09DEBUGP("ip6t_ROUTE: oif interface %s not found\n", route_info->oi=
f);
-
-=09=09if (route_info->flags & IP6T_ROUTE_CONTINUE)
-=09=09=09return IP6T_CONTINUE;
-=09=09else
-=09=09=09return NF_DROP;
-=09}
-
-=09/* Trying the standard way of routing packets */
-=09if (route6(skb, ifindex, route_info)) {
-=09=09dev_put(dev_out);
-=09=09if (route_info->flags & IP6T_ROUTE_CONTINUE)
-=09=09=09return IP6T_CONTINUE;
-=20
-=09=09ip_direct_send(skb);
-=09=09return NF_STOLEN;
-=09} else=20
-=09=09return NF_DROP;
-}
-
-
-static unsigned int=20
-route6_gw(const struct ip6t_route_target_info *route_info,
-=09  struct sk_buff *skb)=20
-{
-=09if (route6(skb, 0, route_info)) {
-=09=09if (route_info->flags & IP6T_ROUTE_CONTINUE)
-=09=09=09return IP6T_CONTINUE;
-
-=09=09ip_direct_send(skb);
-=09=09return NF_STOLEN;
-=09} else
-=09=09return NF_DROP;
-}
-
-
-static unsigned int=20
-ip6t_route_target(struct sk_buff **pskb,
-=09=09  const struct net_device *in,
-=09=09  const struct net_device *out,
-=09=09  unsigned int hooknum,
-=09=09  const void *targinfo,
-=09=09  void *userinfo)
-{
-=09const struct ip6t_route_target_info *route_info =3D targinfo;
-=09struct sk_buff *skb =3D *pskb;
-=09struct in6_addr *gw =3D (struct in6_addr*)&route_info->gw;
-=09unsigned int res;
-
-=09if (route_info->flags & IP6T_ROUTE_CONTINUE)
-=09=09goto do_it;
-
-=09/* If we are at PREROUTING or INPUT hook
-=09 * the TTL isn't decreased by the IP stack
-=09 */
-=09if (hooknum =3D=3D NF_IP6_PRE_ROUTING ||
-=09    hooknum =3D=3D NF_IP6_LOCAL_IN) {
-
-=09=09struct ipv6hdr *ipv6h =3D skb->nh.ipv6h;
-
-=09=09if (ipv6h->hop_limit <=3D 1) {
-=09=09=09/* Force OUTPUT device used as source address */
-=09=09=09skb->dev =3D skb->dst->dev;
-
-=09=09=09icmpv6_send(skb, ICMPV6_TIME_EXCEED,=20
-=09=09=09=09    ICMPV6_EXC_HOPLIMIT, 0, skb->dev);
-
-=09=09=09return NF_DROP;
-=09=09}
-
-=09=09ipv6h->hop_limit--;
-=09}
-
-=09if ((route_info->flags & IP6T_ROUTE_TEE)) {
-=09=09/*
-=09=09 * Copy the *pskb, and route the copy. Will later return
-=09=09 * IP6T_CONTINUE for the original skb, which should continue
-=09=09 * on its way as if nothing happened. The copy should be
-=09=09 * independantly delivered to the ROUTE --gw.
-=09=09 */
-=09=09skb =3D skb_copy(*pskb, GFP_ATOMIC);
-=09=09if (!skb) {
-=09=09=09if (net_ratelimit())=20
-=09=09=09=09DEBUGP(KERN_DEBUG "ip6t_ROUTE: copy failed!\n");
-=09=09=09return IP6T_CONTINUE;
-=09=09}
-=09}
-
-do_it:
-=09if (route_info->oif[0]) {
-=09=09res =3D route6_oif(route_info, skb);
-=09} else if (!ipv6_addr_any(gw)) {
-=09=09res =3D route6_gw(route_info, skb);
-=09} else {
-=09=09if (net_ratelimit())=20
-=09=09=09DEBUGP(KERN_DEBUG "ip6t_ROUTE: no parameter !\n");
-=09=09res =3D IP6T_CONTINUE;
-=09}
-
-=09if ((route_info->flags & IP6T_ROUTE_TEE))
-=09=09res =3D IP6T_CONTINUE;
-
-=09return res;
-}
-
-
-static int=20
-ip6t_route_checkentry(const char *tablename,
-=09=09      const struct ip6t_entry *e,
-=09=09      void *targinfo,
-=09=09      unsigned int targinfosize,
-=09=09      unsigned int hook_mask)
-{
-=09if (strcmp(tablename, "mangle") !=3D 0) {
-=09=09printk("ip6t_ROUTE: can only be called from \"mangle\" table.\n");
-=09=09return 0;
-=09}
-
-=09if (targinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_route_target_info))=
) {
-=09=09printk(KERN_WARNING "ip6t_ROUTE: targinfosize %u !=3D %Zu\n",
-=09=09       targinfosize,
-=09=09       IP6T_ALIGN(sizeof(struct ip6t_route_target_info)));
-=09=09return 0;
-=09}
-
-=09return 1;
-}
-
-
-static struct ip6t_target ip6t_route_reg =3D {
-=09.name       =3D "ROUTE",
-=09.target     =3D ip6t_route_target,
-=09.checkentry =3D ip6t_route_checkentry,
-=09.me         =3D THIS_MODULE
-};
-
-
-static int __init init(void)
-{
-=09printk(KERN_DEBUG "registering ipv6 ROUTE target\n");
-=09if (ip6t_register_target(&ip6t_route_reg))
-=09=09return -EINVAL;
-
-=09return 0;
-}
-
-
-static void __exit fini(void)
-{
-=09ip6t_unregister_target(&ip6t_route_reg);
-}
-
-module_init(init);
-module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/inclu=
de/linux/netfilter_ipv6/ip6t_ROUTE.h patch-o-matic-ng-20060311/patchlets/RO=
UTE/linux-2.6.11/include/linux/netfilter_ipv6/ip6t_ROUTE.h
--- patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/include/lin=
ux/netfilter_ipv6/ip6t_ROUTE.h=092004-12-14 03:58:31.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6.11/include/linux/ne=
tfilter_ipv6/ip6t_ROUTE.h=091970-01-01 01:00:00.000000000 +0100
@@ -1,23 +0,0 @@
-/* Header file for iptables ip6t_ROUTE target
- *
- * (C) 2003 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
- *
- * This software is distributed under GNU GPL v2, 1991
- */
-#ifndef _IPT_ROUTE_H_target
-#define _IPT_ROUTE_H_target
-
-#define IP6T_ROUTE_IFNAMSIZ 16
-
-struct ip6t_route_target_info {
-=09char      oif[IP6T_ROUTE_IFNAMSIZ];     /* Output Interface Name */
-=09char      iif[IP6T_ROUTE_IFNAMSIZ];     /* Input Interface Name  */
-=09u_int32_t gw[4];                        /* IPv6 address of gateway */
-=09u_int8_t  flags;
-};
-
-/* Values for "flags" field */
-#define IP6T_ROUTE_CONTINUE        0x01
-#define IP6T_ROUTE_TEE             0x02
-
-#endif /*_IP6T_ROUTE_H_target*/
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/inclu=
de/linux/netfilter_ipv4/ipt_ROUTE.h patch-o-matic-ng-20060311/patchlets/ROU=
TE/linux-2.6.11/include/linux/netfilter_ipv4/ipt_ROUTE.h
--- patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11/include/lin=
ux/netfilter_ipv4/ipt_ROUTE.h=092004-12-14 03:58:31.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6.11/include/linux/ne=
tfilter_ipv4/ipt_ROUTE.h=091970-01-01 01:00:00.000000000 +0100
@@ -1,23 +0,0 @@
-/* Header file for iptables ipt_ROUTE target
- *
- * (C) 2002 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
- *
- * This software is distributed under GNU GPL v2, 1991
- */
-#ifndef _IPT_ROUTE_H_target
-#define _IPT_ROUTE_H_target
-
-#define IPT_ROUTE_IFNAMSIZ 16
-
-struct ipt_route_target_info {
-=09char      oif[IPT_ROUTE_IFNAMSIZ];      /* Output Interface Name */
-=09char      iif[IPT_ROUTE_IFNAMSIZ];      /* Input Interface Name  */
-=09u_int32_t gw;                           /* IP address of gateway */
-=09u_int8_t  flags;
-};
-
-/* Values for "flags" field */
-#define IPT_ROUTE_CONTINUE        0x01
-#define IPT_ROUTE_TEE             0x02
-
-#endif /*_IPT_ROUTE_H_target*/
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6/net/ipv4=
/netfilter/ipt_ROUTE.c patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6/=
net/ipv4/netfilter/ipt_ROUTE.c
--- patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6/net/ipv4/netfi=
lter/ipt_ROUTE.c=092004-12-14 03:58:31.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6/net/ipv4/netfilter/=
ipt_ROUTE.c=092006-03-21 23:40:43.000000000 +0100
@@ -17,6 +17,7 @@
  #include <linux/netfilter_ipv4/ipt_ROUTE.h>
  #include <linux/netdevice.h>
  #include <linux/route.h>
+#include <linux/if_arp.h>
  #include <net/ip.h>
  #include <net/route.h>
  #include <net/icmp.h>
@@ -377,7 +378,6 @@
  =09=09skb->nfct =3D &route_tee_track.ct_general;
  =09=09skb->nfctinfo =3D IP_CT_NEW;
  =09=09nf_conntrack_get(skb->nfct);
-=09=09skb->nfcache =3D 0;
  #ifdef CONFIG_NETFILTER_DEBUG
  =09=09skb->nf_debug =3D 0;
  #endif
@@ -403,7 +403,7 @@


  static int ipt_route_checkentry(const char *tablename,
-=09=09=09=09const struct ipt_entry *e,
+=09=09=09=09const void *e,
  =09=09=09=09void *targinfo,
  =09=09=09=09unsigned int targinfosize,
  =09=09=09=09unsigned int hook_mask)
@@ -449,8 +449,7 @@
  =09/*  - and look it like as a confirmed connection */
  =09set_bit(IPS_CONFIRMED_BIT, &route_tee_track.status);
  =09/* Initialize fake conntrack so that NAT will skip it */
-=09route_tee_track.nat.info.initialized |=3D=20
-=09=09(1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
+=09route_tee_track.status |=3D IPS_NAT_DONE_MASK;

  =09return ipt_register_target(&ipt_route_reg);
  }
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6/net/ipv6=
/netfilter/Makefile.ladd patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.=
6/net/ipv6/netfilter/Makefile.ladd
--- patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6/net/ipv6/netfi=
lter/Makefile.ladd=092004-05-06 14:41:19.000000000 +0200
+++ patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6/net/ipv6/netfilter/=
Makefile.ladd=092006-03-12 02:25:38.000000000 +0100
@@ -1,2 +1,2 @@
-obj-$(CONFIG_IP6_NF_TARGET_MARK) +=3D ip6t_MARK.o
+obj-$(CONFIG_IP6_NF_TARGET_REJECT) +=3D ip6t_REJECT.o
  obj-$(CONFIG_IP6_NF_TARGET_ROUTE) +=3D ip6t_ROUTE.o
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11.patch=
 patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6.11.patch
--- patch-o-matic-ng-20060311-orig/patchlets/ROUTE/linux-2.6.11.patch=09200=
5-04-01 08:50:41.000000000 +0200
+++ patch-o-matic-ng-20060311/patchlets/ROUTE/linux-2.6.11.patch=091970-01-=
01 01:00:00.000000000 +0100
@@ -1,11 +0,0 @@
-=3D=3D=3D=3D=3D net/ipv6/ipv6_syms.c 1.22 vs edited =3D=3D=3D=3D=3D
---- 1.22/net/ipv6/ipv6_syms.c=092005-01-14 13:30:08 -08:00
-+++ edited/net/ipv6/ipv6_syms.c=092005-03-31 12:41:30 -08:00
-@@ -12,6 +12,7 @@ EXPORT_SYMBOL(icmpv6_send);
- EXPORT_SYMBOL(icmpv6_statistics);
- EXPORT_SYMBOL(icmpv6_err_convert);
- EXPORT_SYMBOL(ndisc_mc_map);
-+EXPORT_SYMBOL(nd_tbl);
- EXPORT_SYMBOL(register_inet6addr_notifier);
- EXPORT_SYMBOL(unregister_inet6addr_notifier);
- EXPORT_SYMBOL(ip6_route_output);
---187430788-237918837-1143461832=:17570
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; name=ROUTE.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0603271417120.17570@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=ROUTE.patch

W1BPTS1ORyAzLzEwXSBGaXggdGhlIFJPVVRFIGV4dGVuc2lvbiBmb3IgMi42
LjE2IGtlcm5lbHMNCg0KVGhpcyBwYXRjaCBhbGxvd3MgdGhlIFJPVVRFIGV4
dGVuc2lvbiB0byBiZSB1c2VkIHdpdGggMi42LjE2IGtlcm5lbHMuDQpJdCBh
bHNvIHJlbW92ZXMgYWRkaXRpb25hbCBpbnN0YW5jZXMgb2YgcGF0Y2hlcyBm
b3Igb2xkZXIgMi42Lngga2VybmVscw0KYXMgcGVyIGRlY2lzaW9uIHRvIGtl
ZXAgaW4gcG9tLW5nIG9ubHkgcGF0Y2hlcyBmb3IgdGhlIG1vc3QgcmVjZW50
IGtlcm5lbHMuDQoNClNpZ25lZC1vZmYtYnk6IEtyenlzenRvZiBQaW90ciBP
bGVkemtpIDxvbGVAYW5zLnBsPg0KDQpkaWZmIC1OdXIgcGF0Y2gtby1tYXRp
Yy1uZy0yMDA2MDMxMS1vcmlnL3BhdGNobGV0cy9ST1VURS9saW51eC0yLjYu
MTEvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9ST1VURS5jIHBhdGNoLW8tbWF0
aWMtbmctMjAwNjAzMTEvcGF0Y2hsZXRzL1JPVVRFL2xpbnV4LTIuNi4xMS9u
ZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X1JPVVRFLmMNCi0tLSBwYXRjaC1vLW1h
dGljLW5nLTIwMDYwMzExLW9yaWcvcGF0Y2hsZXRzL1JPVVRFL2xpbnV4LTIu
Ni4xMS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X1JPVVRFLmMJMjAwNS0xMS0w
MyAxOTowNjozNy4wMDAwMDAwMDAgKzAxMDANCisrKyBwYXRjaC1vLW1hdGlj
LW5nLTIwMDYwMzExL3BhdGNobGV0cy9ST1VURS9saW51eC0yLjYuMTEvbmV0
L2lwdjQvbmV0ZmlsdGVyL2lwdF9ST1VURS5jCTE5NzAtMDEtMDEgMDE6MDA6
MDAuMDAwMDAwMDAwICswMTAwDQpAQCAtMSw0NjMgKzAsMCBAQA0KLS8qDQot
ICogVGhpcyBpbXBsZW1lbnRzIHRoZSBST1VURSB0YXJnZXQsIHdoaWNoIGVu
YWJsZXMgeW91IHRvIHNldHVwIHVudXN1YWwNCi0gKiByb3V0ZXMgbm90IHN1
cHBvcnRlZCBieSB0aGUgc3RhbmRhcmQga2VybmVsIHJvdXRpbmcgdGFibGUu
DQotICoNCi0gKiBDb3B5cmlnaHQgKEMpIDIwMDIgQ2VkcmljIGRlIExhdW5v
aXMgPGRlbGF1bm9pc0BpbmZvLnVjbC5hYy5iZT4NCi0gKg0KLSAqIHYgMS4x
MSAyMDA0LzExLzIzDQotICoNCi0gKiBUaGlzIHNvZnR3YXJlIGlzIGRpc3Ry
aWJ1dGVkIHVuZGVyIEdOVSBHUEwgdjIsIDE5OTENCi0gKi8NCi0NCi0jaW5j
bHVkZSA8bGludXgvbW9kdWxlLmg+DQotI2luY2x1ZGUgPGxpbnV4L3NrYnVm
Zi5oPg0KLSNpbmNsdWRlIDxsaW51eC9pcC5oPg0KLSNpbmNsdWRlIDxsaW51
eC9uZXRmaWx0ZXJfaXB2NC9pcF90YWJsZXMuaD4NCi0jaW5jbHVkZSA8bGlu
dXgvbmV0ZmlsdGVyX2lwdjQvaXBfY29ubnRyYWNrLmg+DQotI2luY2x1ZGUg
PGxpbnV4L25ldGZpbHRlcl9pcHY0L2lwdF9ST1VURS5oPg0KLSNpbmNsdWRl
IDxsaW51eC9uZXRkZXZpY2UuaD4NCi0jaW5jbHVkZSA8bGludXgvcm91dGUu
aD4NCi0jaW5jbHVkZSA8bmV0L2lwLmg+DQotI2luY2x1ZGUgPG5ldC9yb3V0
ZS5oPg0KLSNpbmNsdWRlIDxuZXQvaWNtcC5oPg0KLSNpbmNsdWRlIDxuZXQv
Y2hlY2tzdW0uaD4NCi0NCi0jaWYgMA0KLSNkZWZpbmUgREVCVUdQIHByaW50
aw0KLSNlbHNlDQotI2RlZmluZSBERUJVR1AoZm9ybWF0LCBhcmdzLi4uKQ0K
LSNlbmRpZg0KLQ0KLU1PRFVMRV9MSUNFTlNFKCJHUEwiKTsNCi1NT0RVTEVf
QVVUSE9SKCJDZWRyaWMgZGUgTGF1bm9pcyA8ZGVsYXVub2lzQGluZm8udWNs
LmFjLmJlPiIpOw0KLU1PRFVMRV9ERVNDUklQVElPTigiaXB0YWJsZXMgUk9V
VEUgdGFyZ2V0IG1vZHVsZSIpOw0KLQ0KLS8qIFRyeSB0byByb3V0ZSB0aGUg
cGFja2V0IGFjY29yZGluZyB0byB0aGUgcm91dGluZyBrZXlzIHNwZWNpZmll
ZCBpbg0KLSAqIHJvdXRlX2luZm8uIEtleXMgYXJlIDoNCi0gKiAgLSBpZmlu
ZGV4IDogDQotICogICAgICAwIGlmIG5vIG9pZiBwcmVmZXJyZWQsIA0KLSAq
ICAgICAgb3RoZXJ3aXNlIHNldCB0byB0aGUgaW5kZXggb2YgdGhlIGRlc2ly
ZWQgb2lmDQotICogIC0gcm91dGVfaW5mby0+Z3cgOg0KLSAqICAgICAgMCBp
ZiBubyBnYXRld2F5IHNwZWNpZmllZCwNCi0gKiAgICAgIG90aGVyd2lzZSBz
ZXQgdG8gdGhlIG5leHQgaG9zdCB0byB3aGljaCB0aGUgcGt0IG11c3QgYmUg
cm91dGVkDQotICogSWYgc3VjY2Vzcywgc2tiLT5kZXYgaXMgdGhlIG91dHB1
dCBkZXZpY2UgdG8gd2hpY2ggdGhlIHBhY2tldCBtdXN0IA0KLSAqIGJlIHNl
bnQgYW5kIHNrYi0+ZHN0IGlzIG5vdCBOVUxMDQotICoNCi0gKiBSRVRVUk46
IC0xIGlmIGFuIGVycm9yIG9jY3VyZWQNCi0gKiAgICAgICAgICAxIGlmIHRo
ZSBwYWNrZXQgd2FzIHN1Y2Nlc2Z1bGx5IHJvdXRlZCB0byB0aGUgDQotICog
ICAgICAgICAgICBkZXN0aW5hdGlvbiBkZXNpcmVkDQotICogICAgICAgICAg
MCBpZiB0aGUga2VybmVsIHJvdXRpbmcgdGFibGUgY291bGQgbm90IHJvdXRl
IHRoZSBwYWNrZXQNCi0gKiAgICAgICAgICAgIGFjY29yZGluZyB0byB0aGUg
a2V5cyBzcGVjaWZpZWQNCi0gKi8NCi1zdGF0aWMgaW50IHJvdXRlKHN0cnVj
dCBza19idWZmICpza2IsDQotCQkgdW5zaWduZWQgaW50IGlmaW5kZXgsDQot
CQkgY29uc3Qgc3RydWN0IGlwdF9yb3V0ZV90YXJnZXRfaW5mbyAqcm91dGVf
aW5mbykNCi17DQotCWludCBlcnI7DQotCXN0cnVjdCBydGFibGUgKnJ0Ow0K
LQlzdHJ1Y3QgaXBoZHIgKmlwaCA9IHNrYi0+bmguaXBoOw0KLQlzdHJ1Y3Qg
Zmxvd2kgZmwgPSB7DQotCQkub2lmID0gaWZpbmRleCwNCi0JCS5ubF91ID0g
ew0KLQkJCS5pcDRfdSA9IHsNCi0JCQkJLmRhZGRyID0gaXBoLT5kYWRkciwN
Ci0JCQkJLnNhZGRyID0gMCwNCi0JCQkJLnRvcyA9IFJUX1RPUyhpcGgtPnRv
cyksDQotCQkJCS5zY29wZSA9IFJUX1NDT1BFX1VOSVZFUlNFLA0KLQkJCX0N
Ci0JCX0gDQotCX07DQotCQ0KLQkvKiBUaGUgZGVzdGluYXRpb24gYWRkcmVz
cyBtYXkgYmUgb3ZlcmxvYWRlZCBieSB0aGUgdGFyZ2V0ICovDQotCWlmIChy
b3V0ZV9pbmZvLT5ndykNCi0JCWZsLmZsNF9kc3QgPSByb3V0ZV9pbmZvLT5n
dzsNCi0JDQotCS8qIFRyeWluZyB0byByb3V0ZSB0aGUgcGFja2V0IHVzaW5n
IHRoZSBzdGFuZGFyZCByb3V0aW5nIHRhYmxlLiAqLw0KLQlpZiAoKGVyciA9
IGlwX3JvdXRlX291dHB1dF9rZXkoJnJ0LCAmZmwpKSkgew0KLQkJaWYgKG5l
dF9yYXRlbGltaXQoKSkgDQotCQkJREVCVUdQKCJpcHRfUk9VVEU6IGNvdWxk
bid0IHJvdXRlIHBrdCAoZXJyOiAlaSkiLGVycik7DQotCQlyZXR1cm4gLTE7
DQotCX0NCi0JDQotCS8qIERyb3Agb2xkIHJvdXRlLiAqLw0KLQlkc3RfcmVs
ZWFzZShza2ItPmRzdCk7DQotCXNrYi0+ZHN0ID0gTlVMTDsNCi0NCi0JLyog
U3VjY2VzcyBpZiBubyBvaWYgc3BlY2lmaWVkIG9yIGlmIHRoZSBvaWYgY29y
cmVzcG9uZCB0byB0aGUgDQotCSAqIG9uZSBkZXNpcmVkICovDQotCWlmICgh
aWZpbmRleCB8fCBydC0+dS5kc3QuZGV2LT5pZmluZGV4ID09IGlmaW5kZXgp
IHsNCi0JCXNrYi0+ZHN0ID0gJnJ0LT51LmRzdDsNCi0JCXNrYi0+ZGV2ID0g
c2tiLT5kc3QtPmRldjsNCi0JCXNrYi0+cHJvdG9jb2wgPSBodG9ucyhFVEhf
UF9JUCk7DQotCQlyZXR1cm4gMTsNCi0JfQ0KLQkNCi0JLyogVGhlIGludGVy
ZmFjZSBzZWxlY3RlZCBieSB0aGUgcm91dGluZyB0YWJsZSBpcyBub3QgdGhl
IG9uZQ0KLQkgKiBzcGVjaWZpZWQgYnkgdGhlIHVzZXIuIFRoaXMgbWF5IGhh
cHBlbiBiZWNhdXNlIHRoZSBkc3QgYWRkcmVzcw0KLQkgKiBpcyBvbmUgb2Yg
b3VyIG93biBhZGRyZXNzZXMuDQotCSAqLw0KLQlpZiAobmV0X3JhdGVsaW1p
dCgpKSANCi0JCURFQlVHUCgiaXB0X1JPVVRFOiBmYWlsZWQgdG8gcm91dGUg
YXMgZGVzaXJlZCBndz0ldS4ldS4ldS4ldSBvaWY9JWkgKGdvdCBvaWY9JWkp
XG4iLCANCi0JCSAgICAgICBOSVBRVUFEKHJvdXRlX2luZm8tPmd3KSwgaWZp
bmRleCwgcnQtPnUuZHN0LmRldi0+aWZpbmRleCk7DQotCQ0KLQlyZXR1cm4g
MDsNCi19DQotDQotDQotLyogU3RvbGVuIGZyb20gaXBfZmluaXNoX291dHB1
dDINCi0gKiBQUkUgOiBza2ItPmRldiBpcyBzZXQgdG8gdGhlIGRldmljZSB3
ZSBhcmUgbGVhdmluZyBieQ0KLSAqICAgICAgIHNrYi0+ZHN0IGlzIG5vdCBO
VUxMDQotICogUE9TVDogdGhlIHBhY2tldCBpcyBzZW50IHdpdGggdGhlIGxp
bmsgbGF5ZXIgaGVhZGVyIHB1c2hlZA0KLSAqICAgICAgIHRoZSBwYWNrZXQg
aXMgZGVzdHJveWVkDQotICovDQotc3RhdGljIHZvaWQgaXBfZGlyZWN0X3Nl
bmQoc3RydWN0IHNrX2J1ZmYgKnNrYikNCi17DQotCXN0cnVjdCBkc3RfZW50
cnkgKmRzdCA9IHNrYi0+ZHN0Ow0KLQlzdHJ1Y3QgaGhfY2FjaGUgKmhoID0g
ZHN0LT5oaDsNCi0Jc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IGRzdC0+ZGV2
Ow0KLQlpbnQgaGhfbGVuID0gTExfUkVTRVJWRURfU1BBQ0UoZGV2KTsNCi0N
Ci0JLyogQmUgcGFyYW5vaWQsIHJhdGhlciB0aGFuIHRvbyBjbGV2ZXIuICov
DQotCWlmICh1bmxpa2VseShza2JfaGVhZHJvb20oc2tiKSA8IGhoX2xlbiAm
JiBkZXYtPmhhcmRfaGVhZGVyKSkgew0KLQkJc3RydWN0IHNrX2J1ZmYgKnNr
YjI7DQotDQotCQlza2IyID0gc2tiX3JlYWxsb2NfaGVhZHJvb20oc2tiLCBM
TF9SRVNFUlZFRF9TUEFDRShkZXYpKTsNCi0JCWlmIChza2IyID09IE5VTEwp
IHsNCi0JCQlrZnJlZV9za2Ioc2tiKTsNCi0JCQlyZXR1cm47DQotCQl9DQot
CQlpZiAoc2tiLT5zaykNCi0JCQlza2Jfc2V0X293bmVyX3coc2tiMiwgc2ti
LT5zayk7DQotCQlrZnJlZV9za2Ioc2tiKTsNCi0JCXNrYiA9IHNrYjI7DQot
CX0NCi0NCi0JaWYgKGhoKSB7DQotCQlpbnQgaGhfYWxlbjsNCi0NCi0JCXJl
YWRfbG9ja19iaCgmaGgtPmhoX2xvY2spOw0KLQkJaGhfYWxlbiA9IEhIX0RB
VEFfQUxJR04oaGgtPmhoX2xlbik7DQotICAJCW1lbWNweShza2ItPmRhdGEg
LSBoaF9hbGVuLCBoaC0+aGhfZGF0YSwgaGhfYWxlbik7DQotCQlyZWFkX3Vu
bG9ja19iaCgmaGgtPmhoX2xvY2spOw0KLQkJc2tiX3B1c2goc2tiLCBoaC0+
aGhfbGVuKTsNCi0JCWhoLT5oaF9vdXRwdXQoc2tiKTsNCi0JfSBlbHNlIGlm
IChkc3QtPm5laWdoYm91cikNCi0JCWRzdC0+bmVpZ2hib3VyLT5vdXRwdXQo
c2tiKTsNCi0JZWxzZSB7DQotCQlpZiAobmV0X3JhdGVsaW1pdCgpKQ0KLQkJ
CURFQlVHUChLRVJOX0RFQlVHICJpcHRfUk9VVEU6IG5vIGhkciAmIG5vIG5l
aWdoYm91ciBjYWNoZSFcbiIpOw0KLQkJa2ZyZWVfc2tiKHNrYik7DQotCX0N
Ci19DQotDQotDQotLyogUFJFIDogc2tiLT5kZXYgaXMgc2V0IHRvIHRoZSBk
ZXZpY2Ugd2UgYXJlIGxlYXZpbmcgYnkNCi0gKiBQT1NUOiAtIHRoZSBwYWNr
ZXQgaXMgZGlyZWN0bHkgc2VudCB0byB0aGUgc2tiLT5kZXYgZGV2aWNlLCB3
aXRob3V0IA0KLSAqICAgICAgICAgcHVzaGluZyB0aGUgbGluayBsYXllciBo
ZWFkZXIuDQotICogICAgICAgLSB0aGUgcGFja2V0IGlzIGRlc3Ryb3llZA0K
LSAqLw0KLXN0YXRpYyBpbmxpbmUgaW50IGRldl9kaXJlY3Rfc2VuZChzdHJ1
Y3Qgc2tfYnVmZiAqc2tiKQ0KLXsNCi0JcmV0dXJuIGRldl9xdWV1ZV94bWl0
KHNrYik7DQotfQ0KLQ0KLQ0KLXN0YXRpYyB1bnNpZ25lZCBpbnQgcm91dGVf
b2lmKGNvbnN0IHN0cnVjdCBpcHRfcm91dGVfdGFyZ2V0X2luZm8gKnJvdXRl
X2luZm8sDQotCQkJICAgICAgc3RydWN0IHNrX2J1ZmYgKnNrYikgDQotew0K
LQl1bnNpZ25lZCBpbnQgaWZpbmRleCA9IDA7DQotCXN0cnVjdCBuZXRfZGV2
aWNlICpkZXZfb3V0ID0gTlVMTDsNCi0NCi0JLyogVGhlIHVzZXIgc2V0IHRo
ZSBpbnRlcmZhY2UgbmFtZSB0byB1c2UuDQotCSAqIEdldHRpbmcgdGhlIGN1
cnJlbnQgaW50ZXJmYWNlIGluZGV4Lg0KLQkgKi8NCi0JaWYgKChkZXZfb3V0
ID0gZGV2X2dldF9ieV9uYW1lKHJvdXRlX2luZm8tPm9pZikpKSB7DQotCQlp
ZmluZGV4ID0gZGV2X291dC0+aWZpbmRleDsNCi0JfSBlbHNlIHsNCi0JCS8q
IFVua25vd24gaW50ZXJmYWNlIG5hbWUgOiBwYWNrZXQgZHJvcHBlZCAqLw0K
LQkJaWYgKG5ldF9yYXRlbGltaXQoKSkgDQotCQkJREVCVUdQKCJpcHRfUk9V
VEU6IG9pZiBpbnRlcmZhY2UgJXMgbm90IGZvdW5kXG4iLCByb3V0ZV9pbmZv
LT5vaWYpOw0KLQkJcmV0dXJuIE5GX0RST1A7DQotCX0NCi0NCi0JLyogVHJ5
aW5nIHRoZSBzdGFuZGFyZCB3YXkgb2Ygcm91dGluZyBwYWNrZXRzICovDQot
CXN3aXRjaCAocm91dGUoc2tiLCBpZmluZGV4LCByb3V0ZV9pbmZvKSkgew0K
LQljYXNlIDE6DQotCQlkZXZfcHV0KGRldl9vdXQpOw0KLQkJaWYgKHJvdXRl
X2luZm8tPmZsYWdzICYgSVBUX1JPVVRFX0NPTlRJTlVFKQ0KLQkJCXJldHVy
biBJUFRfQ09OVElOVUU7DQotDQotCQlpcF9kaXJlY3Rfc2VuZChza2IpOw0K
LQkJcmV0dXJuIE5GX1NUT0xFTjsNCi0NCi0JY2FzZSAwOg0KLQkJLyogRmFp
bGVkIHRvIHNlbmQgdG8gb2lmLiBUcnlpbmcgdGhlIGhhcmQgd2F5ICovDQot
CQlpZiAocm91dGVfaW5mby0+ZmxhZ3MgJiBJUFRfUk9VVEVfQ09OVElOVUUp
DQotCQkJcmV0dXJuIE5GX0RST1A7DQotDQotCQlpZiAobmV0X3JhdGVsaW1p
dCgpKSANCi0JCQlERUJVR1AoImlwdF9ST1VURTogZm9yY2luZyB0aGUgdXNl
IG9mICVpXG4iLA0KLQkJCSAgICAgICBpZmluZGV4KTsNCi0NCi0JCS8qIFdl
IGhhdmUgdG8gZm9yY2UgdGhlIHVzZSBvZiBhbiBpbnRlcmZhY2UuDQotCQkg
KiBUaGlzIGludGVyZmFjZSBtdXN0IGJlIGEgdHVubmVsIGludGVyZmFjZSBz
aW5jZQ0KLQkJICogb3RoZXJ3aXNlIHdlIGNhbid0IGd1ZXNzIHRoZSBodyBh
ZGRyZXNzIGZvcg0KLQkJICogdGhlIHBhY2tldC4gRm9yIGEgdHVubmVsIGlu
dGVyZmFjZSwgbm8gaHcgYWRkcmVzcw0KLQkJICogaXMgbmVlZGVkLg0KLQkJ
ICovDQotCQlpZiAoKGRldl9vdXQtPnR5cGUgIT0gQVJQSFJEX1RVTk5FTCkN
Ci0JCSAgICAmJiAoZGV2X291dC0+dHlwZSAhPSBBUlBIUkRfSVBHUkUpKSB7
DQotCQkJaWYgKG5ldF9yYXRlbGltaXQoKSkgDQotCQkJCURFQlVHUCgiaXB0
X1JPVVRFOiBjYW4ndCBndWVzcyB0aGUgaHcgYWRkciAhXG4iKTsNCi0JCQlk
ZXZfcHV0KGRldl9vdXQpOw0KLQkJCXJldHVybiBORl9EUk9QOw0KLQkJfQ0K
LQkNCi0JCS8qIFNlbmQgdGhlIHBhY2tldC4gVGhpcyB3aWxsIGFsc28gZnJl
ZSBza2INCi0JCSAqIERvIG5vdCBnbyB0aHJvdWdoIHRoZSBQT1NUX1JPVVRJ
TkcgaG9vayBiZWNhdXNlIA0KLQkJICogc2tiLT5kc3QgaXMgbm90IHNldCBh
bmQgYmVjYXVzZSBpdCB3aWxsIHByb2JhYmx5DQotCQkgKiBnZXQgY29uZnVz
ZWQgYnkgdGhlIGRlc3RpbmF0aW9uIElQIGFkZHJlc3MuDQotCQkgKi8NCi0J
CXNrYi0+ZGV2ID0gZGV2X291dDsNCi0JCWRldl9kaXJlY3Rfc2VuZChza2Ip
Ow0KLQkJZGV2X3B1dChkZXZfb3V0KTsNCi0JCXJldHVybiBORl9TVE9MRU47
DQotCQkNCi0JZGVmYXVsdDoNCi0JCS8qIFVuZXhwZWN0ZWQgZXJyb3IgKi8N
Ci0JCWRldl9wdXQoZGV2X291dCk7DQotCQlyZXR1cm4gTkZfRFJPUDsNCi0J
fQ0KLX0NCi0NCi0NCi1zdGF0aWMgdW5zaWduZWQgaW50IHJvdXRlX2lpZihj
b25zdCBzdHJ1Y3QgaXB0X3JvdXRlX3RhcmdldF9pbmZvICpyb3V0ZV9pbmZv
LA0KLQkJCSAgICAgIHN0cnVjdCBza19idWZmICpza2IpIA0KLXsNCi0Jc3Ry
dWN0IG5ldF9kZXZpY2UgKmRldl9pbiA9IE5VTEw7DQotDQotCS8qIEdldHRp
bmcgdGhlIGN1cnJlbnQgaW50ZXJmYWNlIGluZGV4LiAqLw0KLQlpZiAoIShk
ZXZfaW4gPSBkZXZfZ2V0X2J5X25hbWUocm91dGVfaW5mby0+aWlmKSkpIHsN
Ci0JCWlmIChuZXRfcmF0ZWxpbWl0KCkpIA0KLQkJCURFQlVHUCgiaXB0X1JP
VVRFOiBpaWYgaW50ZXJmYWNlICVzIG5vdCBmb3VuZFxuIiwgcm91dGVfaW5m
by0+aWlmKTsNCi0JCXJldHVybiBORl9EUk9QOw0KLQl9DQotDQotCXNrYi0+
ZGV2ID0gZGV2X2luOw0KLQlkc3RfcmVsZWFzZShza2ItPmRzdCk7DQotCXNr
Yi0+ZHN0ID0gTlVMTDsNCi0NCi0JbmV0aWZfcngoc2tiKTsNCi0JZGV2X3B1
dChkZXZfaW4pOw0KLQlyZXR1cm4gTkZfU1RPTEVOOw0KLX0NCi0NCi0NCi1z
dGF0aWMgdW5zaWduZWQgaW50IHJvdXRlX2d3KGNvbnN0IHN0cnVjdCBpcHRf
cm91dGVfdGFyZ2V0X2luZm8gKnJvdXRlX2luZm8sDQotCQkJICAgICBzdHJ1
Y3Qgc2tfYnVmZiAqc2tiKSANCi17DQotCWlmIChyb3V0ZShza2IsIDAsIHJv
dXRlX2luZm8pIT0xKQ0KLQkJcmV0dXJuIE5GX0RST1A7DQotDQotCWlmIChy
b3V0ZV9pbmZvLT5mbGFncyAmIElQVF9ST1VURV9DT05USU5VRSkNCi0JCXJl
dHVybiBJUFRfQ09OVElOVUU7DQotDQotCWlwX2RpcmVjdF9zZW5kKHNrYik7
DQotCXJldHVybiBORl9TVE9MRU47DQotfQ0KLQ0KLQ0KLS8qIFRvIGRldGVj
dCBhbmQgZGV0ZXIgcm91dGVkIHBhY2tldCBsb29wYmFjayB3aGVuIHVzaW5n
IHRoZSAtLXRlZSBvcHRpb24sDQotICogd2UgdGFrZSBhIHBhZ2Ugb3V0IG9m
IHRoZSByYXcucGF0Y2ggYm9vazogb24gdGhlIGNvcGllZCBza2IsIHdlIHNl
dCB1cA0KLSAqIGEgZmFrZSAtPm5mY3QgZW50cnksIHBvaW50aW5nIHRvIHRo
ZSBsb2NhbCAmcm91dGVfdGVlX3RyYWNrLiBXZSBza2lwDQotICogcm91dGlu
ZyBwYWNrZXRzIHdoZW4gd2Ugc2VlIHRoZXkgYWxyZWFkeSBoYXZlIHRoYXQg
LT5uZmN0Lg0KLSAqLw0KLQ0KLXN0YXRpYyBzdHJ1Y3QgaXBfY29ubnRyYWNr
IHJvdXRlX3RlZV90cmFjazsNCi0NCi1zdGF0aWMgdW5zaWduZWQgaW50IGlw
dF9yb3V0ZV90YXJnZXQoc3RydWN0IHNrX2J1ZmYgKipwc2tiLA0KLQkJCQkg
ICAgIGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlICppbiwNCi0JCQkJICAgICBj
b25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqb3V0LA0KLQkJCQkgICAgIHVuc2ln
bmVkIGludCBob29rbnVtLA0KLQkJCQkgICAgIGNvbnN0IHZvaWQgKnRhcmdp
bmZvLA0KLQkJCQkgICAgIHZvaWQgKnVzZXJpbmZvKQ0KLXsNCi0JY29uc3Qg
c3RydWN0IGlwdF9yb3V0ZV90YXJnZXRfaW5mbyAqcm91dGVfaW5mbyA9IHRh
cmdpbmZvOw0KLQlzdHJ1Y3Qgc2tfYnVmZiAqc2tiID0gKnBza2I7DQotCXVu
c2lnbmVkIGludCByZXM7DQotDQotCWlmIChza2ItPm5mY3QgPT0gJnJvdXRl
X3RlZV90cmFjay5jdF9nZW5lcmFsKSB7DQotCQkvKiBMb29wYmFjayAtIGEg
cGFja2V0IHdlIGFscmVhZHkgcm91dGVkLCBpcyB0byBiZQ0KLQkJICogcm91
dGVkIGFub3RoZXIgdGltZS4gQXZvaWQgdGhhdCwgbm93Lg0KLQkJICovDQot
CQlpZiAobmV0X3JhdGVsaW1pdCgpKSANCi0JCQlERUJVR1AoS0VSTl9ERUJV
RyAiaXB0X1JPVVRFOiBsb29wYmFjayAtIERST1AhXG4iKTsNCi0JCXJldHVy
biBORl9EUk9QOw0KLQl9DQotDQotCS8qIElmIHdlIGFyZSBhdCBQUkVST1VU
SU5HIG9yIElOUFVUIGhvb2sNCi0JICogdGhlIFRUTCBpc24ndCBkZWNyZWFz
ZWQgYnkgdGhlIElQIHN0YWNrDQotCSAqLw0KLQlpZiAoaG9va251bSA9PSBO
Rl9JUF9QUkVfUk9VVElORyB8fA0KLQkgICAgaG9va251bSA9PSBORl9JUF9M
T0NBTF9JTikgew0KLQ0KLQkJc3RydWN0IGlwaGRyICppcGggPSBza2ItPm5o
LmlwaDsNCi0NCi0JCWlmIChpcGgtPnR0bCA8PSAxKSB7DQotCQkJc3RydWN0
IHJ0YWJsZSAqcnQ7DQotCQkJc3RydWN0IGZsb3dpIGZsID0gew0KLQkJCQku
b2lmID0gMCwNCi0JCQkJLm5sX3UgPSB7DQotCQkJCQkuaXA0X3UgPSB7DQot
CQkJCQkJLmRhZGRyID0gaXBoLT5kYWRkciwNCi0JCQkJCQkuc2FkZHIgPSBp
cGgtPnNhZGRyLA0KLQkJCQkJCS50b3MgPSBSVF9UT1MoaXBoLT50b3MpLA0K
LQkJCQkJCS5zY29wZSA9ICgoaXBoLT50b3MgJiBSVE9fT05MSU5LKSA/DQot
CQkJCQkJCSAgUlRfU0NPUEVfTElOSyA6DQotCQkJCQkJCSAgUlRfU0NPUEVf
VU5JVkVSU0UpDQotCQkJCQl9DQotCQkJCX0gDQotCQkJfTsNCi0NCi0JCQlp
ZiAoaXBfcm91dGVfb3V0cHV0X2tleSgmcnQsICZmbCkpIHsNCi0JCQkJcmV0
dXJuIE5GX0RST1A7DQotCQkJfQ0KLQ0KLQkJCWlmIChza2ItPmRldiA9PSBy
dC0+dS5kc3QuZGV2KSB7DQotCQkJCS8qIERyb3Agb2xkIHJvdXRlLiAqLw0K
LQkJCQlkc3RfcmVsZWFzZShza2ItPmRzdCk7DQotCQkJCXNrYi0+ZHN0ID0g
JnJ0LT51LmRzdDsNCi0NCi0JCQkJLyogdGhpcyB3aWxsIHRyYXZlcnNlIG5v
cm1hbCBzdGFjaywgYW5kIA0KLQkJCQkgKiB0aHVzIGNhbGwgY29ubnRyYWNr
IG9uIHRoZSBpY21wIHBhY2tldCAqLw0KLQkJCQlpY21wX3NlbmQoc2tiLCBJ
Q01QX1RJTUVfRVhDRUVERUQsIA0KLQkJCQkJICBJQ01QX0VYQ19UVEwsIDAp
Ow0KLQkJCX0NCi0NCi0JCQlyZXR1cm4gTkZfRFJPUDsNCi0JCX0NCi0NCi0J
CS8qDQotCQkgKiBJZiB3ZSBhcmUgYXQgSU5QVVQgdGhlIGNoZWNrc3VtIG11
c3QgYmUgcmVjYWxjdWxhdGVkIHNpbmNlDQotCQkgKiB0aGUgbGVuZ3RoIGNv
dWxkIGNoYW5nZSBhcyB0aGUgcmVzdWx0IG9mIGEgZGVmcmFnbWVudGF0aW9u
Lg0KLQkJICovDQotCQlpZihob29rbnVtID09IE5GX0lQX0xPQ0FMX0lOKSB7
DQotCQkJaXBoLT50dGwgPSBpcGgtPnR0bCAtIDE7DQotCQkJaXBoLT5jaGVj
ayA9IDA7DQotCQkJaXBoLT5jaGVjayA9IGlwX2Zhc3RfY3N1bSgodW5zaWdu
ZWQgY2hhciAqKWlwaCwgaXBoLT5paGwpOw0KLQkJfSBlbHNlIHsNCi0JCQlp
cF9kZWNyZWFzZV90dGwoaXBoKTsNCi0JCX0NCi0JfQ0KLQ0KLQlpZiAoKHJv
dXRlX2luZm8tPmZsYWdzICYgSVBUX1JPVVRFX1RFRSkpIHsNCi0JCS8qDQot
CQkgKiBDb3B5IHRoZSAqcHNrYiwgYW5kIHJvdXRlIHRoZSBjb3B5LiBXaWxs
IGxhdGVyIHJldHVybg0KLQkJICogSVBUX0NPTlRJTlVFIGZvciB0aGUgb3Jp
Z2luYWwgc2tiLCB3aGljaCBzaG91bGQgY29udGludWUNCi0JCSAqIG9uIGl0
cyB3YXkgYXMgaWYgbm90aGluZyBoYXBwZW5lZC4gVGhlIGNvcHkgc2hvdWxk
IGJlDQotCQkgKiBpbmRlcGVuZGFudGx5IGRlbGl2ZXJlZCB0byB0aGUgUk9V
VEUgLS1ndy4NCi0JCSAqLw0KLQkJc2tiID0gc2tiX2NvcHkoKnBza2IsIEdG
UF9BVE9NSUMpOw0KLQkJaWYgKCFza2IpIHsNCi0JCQlpZiAobmV0X3JhdGVs
aW1pdCgpKSANCi0JCQkJREVCVUdQKEtFUk5fREVCVUcgImlwdF9ST1VURTog
Y29weSBmYWlsZWQhXG4iKTsNCi0JCQlyZXR1cm4gSVBUX0NPTlRJTlVFOw0K
LQkJfQ0KLQl9DQotDQotCS8qIFRlbGwgY29ubnRyYWNrIHRvIGZvcmdldCB0
aGlzIHBhY2tldCBzaW5jZSBpdCBtYXkgZ2V0IGNvbmZ1c2VkIA0KLQkgKiB3
aGVuIGEgcGFja2V0IGlzIGxlYXZpbmcgd2l0aCBkc3QgYWRkcmVzcyA9PSBv
dXIgYWRkcmVzcy4NCi0JICogR29vZCBpZGVhID8gRHVubm8uIE5lZWQgYWR2
aWNlLg0KLQkgKg0KLQkgKiBORVc6IG1hcmsgdGhlIHNrYiB3aXRoIG91ciAm
cm91dGVfdGVlX3RyYWNrLCBzbyB3ZSBhdm9pZCBsb29waW5nDQotCSAqIG9u
IGFueSBhbHJlYWR5IHJvdXRlZCBwYWNrZXQuDQotCSAqLw0KLQlpZiAoIShy
b3V0ZV9pbmZvLT5mbGFncyAmIElQVF9ST1VURV9DT05USU5VRSkpIHsNCi0J
CW5mX2Nvbm50cmFja19wdXQoc2tiLT5uZmN0KTsNCi0JCXNrYi0+bmZjdCA9
ICZyb3V0ZV90ZWVfdHJhY2suY3RfZ2VuZXJhbDsNCi0JCXNrYi0+bmZjdGlu
Zm8gPSBJUF9DVF9ORVc7DQotCQluZl9jb25udHJhY2tfZ2V0KHNrYi0+bmZj
dCk7DQotI2lmZGVmIENPTkZJR19ORVRGSUxURVJfREVCVUcNCi0JCXNrYi0+
bmZfZGVidWcgPSAwOw0KLSNlbmRpZg0KLQl9DQotDQotCWlmIChyb3V0ZV9p
bmZvLT5vaWZbMF0gIT0gJ1wwJykgew0KLQkJcmVzID0gcm91dGVfb2lmKHJv
dXRlX2luZm8sIHNrYik7DQotCX0gZWxzZSBpZiAocm91dGVfaW5mby0+aWlm
WzBdICE9ICdcMCcpIHsNCi0JCXJlcyA9IHJvdXRlX2lpZihyb3V0ZV9pbmZv
LCBza2IpOw0KLQl9IGVsc2UgaWYgKHJvdXRlX2luZm8tPmd3KSB7DQotCQly
ZXMgPSByb3V0ZV9ndyhyb3V0ZV9pbmZvLCBza2IpOw0KLQl9IGVsc2Ugew0K
LQkJaWYgKG5ldF9yYXRlbGltaXQoKSkgDQotCQkJREVCVUdQKEtFUk5fREVC
VUcgImlwdF9ST1VURTogbm8gcGFyYW1ldGVyICFcbiIpOw0KLQkJcmVzID0g
SVBUX0NPTlRJTlVFOw0KLQl9DQotDQotCWlmICgocm91dGVfaW5mby0+Zmxh
Z3MgJiBJUFRfUk9VVEVfVEVFKSkNCi0JCXJlcyA9IElQVF9DT05USU5VRTsN
Ci0NCi0JcmV0dXJuIHJlczsNCi19DQotDQotDQotc3RhdGljIGludCBpcHRf
cm91dGVfY2hlY2tlbnRyeShjb25zdCBjaGFyICp0YWJsZW5hbWUsDQotCQkJ
CWNvbnN0IHN0cnVjdCBpcHRfZW50cnkgKmUsDQotCQkJCXZvaWQgKnRhcmdp
bmZvLA0KLQkJCQl1bnNpZ25lZCBpbnQgdGFyZ2luZm9zaXplLA0KLQkJCQl1
bnNpZ25lZCBpbnQgaG9va19tYXNrKQ0KLXsNCi0JaWYgKHN0cmNtcCh0YWJs
ZW5hbWUsICJtYW5nbGUiKSAhPSAwKSB7DQotCQlwcmludGsoImlwdF9ST1VU
RTogYmFkIHRhYmxlIGAlcycsIHVzZSB0aGUgYG1hbmdsZScgdGFibGUuXG4i
LA0KLQkJICAgICAgIHRhYmxlbmFtZSk7DQotCQlyZXR1cm4gMDsNCi0JfQ0K
LQ0KLQlpZiAoaG9va19tYXNrICYgfiggICgxIDw8IE5GX0lQX1BSRV9ST1VU
SU5HKQ0KLQkJCSAgICB8ICgxIDw8IE5GX0lQX0xPQ0FMX0lOKQ0KLQkJCSAg
ICB8ICgxIDw8IE5GX0lQX0ZPUldBUkQpDQotCQkJICAgIHwgKDEgPDwgTkZf
SVBfTE9DQUxfT1VUKQ0KLQkJCSAgICB8ICgxIDw8IE5GX0lQX1BPU1RfUk9V
VElORykpKSB7DQotCQlwcmludGsoImlwdF9ST1VURTogYmFkIGhvb2tcbiIp
Ow0KLQkJcmV0dXJuIDA7DQotCX0NCi0NCi0JaWYgKHRhcmdpbmZvc2l6ZSAh
PSBJUFRfQUxJR04oc2l6ZW9mKHN0cnVjdCBpcHRfcm91dGVfdGFyZ2V0X2lu
Zm8pKSkgew0KLQkJcHJpbnRrKEtFUk5fV0FSTklORyAiaXB0X1JPVVRFOiB0
YXJnaW5mb3NpemUgJXUgIT0gJVp1XG4iLA0KLQkJICAgICAgIHRhcmdpbmZv
c2l6ZSwNCi0JCSAgICAgICBJUFRfQUxJR04oc2l6ZW9mKHN0cnVjdCBpcHRf
cm91dGVfdGFyZ2V0X2luZm8pKSk7DQotCQlyZXR1cm4gMDsNCi0JfQ0KLQ0K
LQlyZXR1cm4gMTsNCi19DQotDQotDQotc3RhdGljIHN0cnVjdCBpcHRfdGFy
Z2V0IGlwdF9yb3V0ZV9yZWcgPSB7IA0KLQkubmFtZSA9ICJST1VURSIsDQot
CS50YXJnZXQgPSBpcHRfcm91dGVfdGFyZ2V0LA0KLQkuY2hlY2tlbnRyeSA9
IGlwdF9yb3V0ZV9jaGVja2VudHJ5LA0KLQkubWUgPSBUSElTX01PRFVMRSwN
Ci19Ow0KLQ0KLXN0YXRpYyBpbnQgX19pbml0IGluaXQodm9pZCkNCi17DQot
CS8qIFNldCB1cCBmYWtlIGNvbm50cmFjayAoc3RvbGVuIGZyb20gcmF3LnBh
dGNoKToNCi0JICAgIC0gdG8gbmV2ZXIgYmUgZGVsZXRlZCwgbm90IGluIGFu
eSBoYXNoZXMgKi8NCi0JYXRvbWljX3NldCgmcm91dGVfdGVlX3RyYWNrLmN0
X2dlbmVyYWwudXNlLCAxKTsNCi0JLyogIC0gYW5kIGxvb2sgaXQgbGlrZSBh
cyBhIGNvbmZpcm1lZCBjb25uZWN0aW9uICovDQotCXNldF9iaXQoSVBTX0NP
TkZJUk1FRF9CSVQsICZyb3V0ZV90ZWVfdHJhY2suc3RhdHVzKTsNCi0JLyog
SW5pdGlhbGl6ZSBmYWtlIGNvbm50cmFjayBzbyB0aGF0IE5BVCB3aWxsIHNr
aXAgaXQgKi8NCi0Jcm91dGVfdGVlX3RyYWNrLnN0YXR1cyB8PSBJUFNfTkFU
X0RPTkVfTUFTSzsNCi0NCi0JcmV0dXJuIGlwdF9yZWdpc3Rlcl90YXJnZXQo
JmlwdF9yb3V0ZV9yZWcpOw0KLX0NCi0NCi0NCi1zdGF0aWMgdm9pZCBfX2V4
aXQgZmluaSh2b2lkKQ0KLXsNCi0JaXB0X3VucmVnaXN0ZXJfdGFyZ2V0KCZp
cHRfcm91dGVfcmVnKTsNCi19DQotDQotbW9kdWxlX2luaXQoaW5pdCk7DQot
bW9kdWxlX2V4aXQoZmluaSk7DQpkaWZmIC1OdXIgcGF0Y2gtby1tYXRpYy1u
Zy0yMDA2MDMxMS1vcmlnL3BhdGNobGV0cy9ST1VURS9saW51eC0yLjYuMTEv
bmV0L2lwdjQvbmV0ZmlsdGVyL01ha2VmaWxlLmxhZGQgcGF0Y2gtby1tYXRp
Yy1uZy0yMDA2MDMxMS9wYXRjaGxldHMvUk9VVEUvbGludXgtMi42LjExL25l
dC9pcHY0L25ldGZpbHRlci9NYWtlZmlsZS5sYWRkDQotLS0gcGF0Y2gtby1t
YXRpYy1uZy0yMDA2MDMxMS1vcmlnL3BhdGNobGV0cy9ST1VURS9saW51eC0y
LjYuMTEvbmV0L2lwdjQvbmV0ZmlsdGVyL01ha2VmaWxlLmxhZGQJMjAwNC0w
NS0wNiAxNDo0MToxOS4wMDAwMDAwMDAgKzAyMDANCisrKyBwYXRjaC1vLW1h
dGljLW5nLTIwMDYwMzExL3BhdGNobGV0cy9ST1VURS9saW51eC0yLjYuMTEv
bmV0L2lwdjQvbmV0ZmlsdGVyL01ha2VmaWxlLmxhZGQJMTk3MC0wMS0wMSAw
MTowMDowMC4wMDAwMDAwMDAgKzAxMDANCkBAIC0xLDIgKzAsMCBAQA0KLW9i
ai0kKENPTkZJR19JUF9ORl9UQVJHRVRfUkVESVJFQ1QpICs9IGlwdF9SRURJ
UkVDVC5vDQotb2JqLSQoQ09ORklHX0lQX05GX1RBUkdFVF9ST1VURSkgKz0g
aXB0X1JPVVRFLm8NCmRpZmYgLU51ciBwYXRjaC1vLW1hdGljLW5nLTIwMDYw
MzExLW9yaWcvcGF0Y2hsZXRzL1JPVVRFL2xpbnV4LTIuNi4xMS9uZXQvaXB2
NC9uZXRmaWx0ZXIvS2NvbmZpZy5sYWRkIHBhdGNoLW8tbWF0aWMtbmctMjAw
NjAzMTEvcGF0Y2hsZXRzL1JPVVRFL2xpbnV4LTIuNi4xMS9uZXQvaXB2NC9u
ZXRmaWx0ZXIvS2NvbmZpZy5sYWRkDQotLS0gcGF0Y2gtby1tYXRpYy1uZy0y
MDA2MDMxMS1vcmlnL3BhdGNobGV0cy9ST1VURS9saW51eC0yLjYuMTEvbmV0
L2lwdjQvbmV0ZmlsdGVyL0tjb25maWcubGFkZAkyMDA0LTA1LTA2IDE0OjQx
OjE5LjAwMDAwMDAwMCArMDIwMA0KKysrIHBhdGNoLW8tbWF0aWMtbmctMjAw
NjAzMTEvcGF0Y2hsZXRzL1JPVVRFL2xpbnV4LTIuNi4xMS9uZXQvaXB2NC9u
ZXRmaWx0ZXIvS2NvbmZpZy5sYWRkCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAw
MDAwMDAwICswMTAwDQpAQCAtMSwxNiArMCwwIEBADQotY29uZmlnIElQX05G
X1RBUkdFVF9ST1VURQ0KLQl0cmlzdGF0ZSAgJ1JPVVRFIHRhcmdldCBzdXBw
b3J0Jw0KLQlkZXBlbmRzIG9uIElQX05GX01BTkdMRQ0KLQloZWxwDQotCSAg
VGhpcyBvcHRpb24gYWRkcyBhIGBST1VURScgdGFyZ2V0LCB3aGljaCBlbmFi
bGVzIHlvdSB0byBzZXR1cCB1bnVzdWFsDQotCSAgcm91dGVzLiBGb3IgZXhh
bXBsZSwgdGhlIFJPVVRFIGxldHMgeW91IHJvdXRlIGEgcmVjZWl2ZWQgcGFj
a2V0IHRocm91Z2ggDQotCSAgYW4gaW50ZXJmYWNlIG9yIHRvd2FyZHMgYSBo
b3N0LCBldmVuIGlmIHRoZSByZWd1bGFyIGRlc3RpbmF0aW9uIG9mIHRoZSAN
Ci0JICBwYWNrZXQgaXMgdGhlIHJvdXRlciBpdHNlbGYuIFRoZSBST1VURSB0
YXJnZXQgaXMgYWxzbyBhYmxlIHRvIGNoYW5nZSB0aGUgDQotCSAgaW5jb21p
bmcgaW50ZXJmYWNlIG9mIGEgcGFja2V0Lg0KLQkNCi0JICBUaGUgdGFyZ2V0
IGNhbiBiZSBvciBub3QgYSBmaW5hbCB0YXJnZXQuIEl0IGhhcyB0byBiZSB1
c2VkIGluc2lkZSB0aGUgDQotCSAgbWFuZ2xlIHRhYmxlLg0KLQkgIA0KLQkg
IElmIHlvdSB3YW50IHRvIGNvbXBpbGUgaXQgYXMgYSBtb2R1bGUsIHNheSBN
IGhlcmUgYW5kIHJlYWQNCi0JICBEb2N1bWVudGF0aW9uL21vZHVsZXMudHh0
LiAgVGhlIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCBpcHRfUk9VVEUuby4NCi0J
ICBJZiB1bnN1cmUsIHNheSBgTicuDQpkaWZmIC1OdXIgcGF0Y2gtby1tYXRp
Yy1uZy0yMDA2MDMxMS1vcmlnL3BhdGNobGV0cy9ST1VURS9saW51eC0yLjYu
MTEvbmV0L2lwdjYvbmV0ZmlsdGVyL01ha2VmaWxlLmxhZGQgcGF0Y2gtby1t
YXRpYy1uZy0yMDA2MDMxMS9wYXRjaGxldHMvUk9VVEUvbGludXgtMi42LjEx
L25ldC9pcHY2L25ldGZpbHRlci9NYWtlZmlsZS5sYWRkDQotLS0gcGF0Y2gt
by1tYXRpYy1uZy0yMDA2MDMxMS1vcmlnL3BhdGNobGV0cy9ST1VURS9saW51
eC0yLjYuMTEvbmV0L2lwdjYvbmV0ZmlsdGVyL01ha2VmaWxlLmxhZGQJMjAw
NC0wNS0wNiAxNDo0MToxOS4wMDAwMDAwMDAgKzAyMDANCisrKyBwYXRjaC1v
LW1hdGljLW5nLTIwMDYwMzExL3BhdGNobGV0cy9ST1VURS9saW51eC0yLjYu
MTEvbmV0L2lwdjYvbmV0ZmlsdGVyL01ha2VmaWxlLmxhZGQJMTk3MC0wMS0w
MSAwMTowMDowMC4wMDAwMDAwMDAgKzAxMDANCkBAIC0xLDIgKzAsMCBAQA0K
LW9iai0kKENPTkZJR19JUDZfTkZfVEFSR0VUX01BUkspICs9IGlwNnRfTUFS
Sy5vDQotb2JqLSQoQ09ORklHX0lQNl9ORl9UQVJHRVRfUk9VVEUpICs9IGlw
NnRfUk9VVEUubw0KZGlmZiAtTnVyIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAz
MTEtb3JpZy9wYXRjaGxldHMvUk9VVEUvbGludXgtMi42LjExL25ldC9pcHY2
L25ldGZpbHRlci9LY29uZmlnLmxhZGQgcGF0Y2gtby1tYXRpYy1uZy0yMDA2
MDMxMS9wYXRjaGxldHMvUk9VVEUvbGludXgtMi42LjExL25ldC9pcHY2L25l
dGZpbHRlci9LY29uZmlnLmxhZGQNCi0tLSBwYXRjaC1vLW1hdGljLW5nLTIw
MDYwMzExLW9yaWcvcGF0Y2hsZXRzL1JPVVRFL2xpbnV4LTIuNi4xMS9uZXQv
aXB2Ni9uZXRmaWx0ZXIvS2NvbmZpZy5sYWRkCTIwMDQtMDUtMDYgMTQ6NDE6
MTkuMDAwMDAwMDAwICswMjAwDQorKysgcGF0Y2gtby1tYXRpYy1uZy0yMDA2
MDMxMS9wYXRjaGxldHMvUk9VVEUvbGludXgtMi42LjExL25ldC9pcHY2L25l
dGZpbHRlci9LY29uZmlnLmxhZGQJMTk3MC0wMS0wMSAwMTowMDowMC4wMDAw
MDAwMDAgKzAxMDANCkBAIC0xLDEyICswLDAgQEANCi1jb25maWcgSVA2X05G
X1RBUkdFVF9ST1VURQ0KLQl0cmlzdGF0ZSAnICAgIFJPVVRFIHRhcmdldCBz
dXBwb3J0Jw0KLQlkZXBlbmRzIG9uIElQNl9ORl9NQU5HTEUNCi0JaGVscA0K
LQkgIFRoaXMgb3B0aW9uIGFkZHMgYSBgUk9VVEUnIHRhcmdldCwgd2hpY2gg
ZW5hYmxlcyB5b3UgdG8gc2V0dXAgdW51c3VhbA0KLQkgIHJvdXRlcy4gVGhl
IFJPVVRFIHRhcmdldCBpcyBhbHNvIGFibGUgdG8gY2hhbmdlIHRoZSBpbmNv
bWluZyBpbnRlcmZhY2UNCi0JICBvZiBhIHBhY2tldC4NCi0JDQotCSAgVGhl
IHRhcmdldCBjYW4gYmUgb3Igbm90IGEgZmluYWwgdGFyZ2V0LiBJdCBoYXMg
dG8gYmUgdXNlZCBpbnNpZGUgdGhlIA0KLQkgIG1hbmdsZSB0YWJsZS4NCi0J
ICANCi0JICBOb3Qgd29ya2luZyBhcyBhIG1vZHVsZS4NCmRpZmYgLU51ciBw
YXRjaC1vLW1hdGljLW5nLTIwMDYwMzExLW9yaWcvcGF0Y2hsZXRzL1JPVVRF
L2xpbnV4LTIuNi4xMS9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dF9ST1VURS5j
IHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEvcGF0Y2hsZXRzL1JPVVRFL2xp
bnV4LTIuNi4xMS9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dF9ST1VURS5jDQot
LS0gcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDMxMS1vcmlnL3BhdGNobGV0cy9S
T1VURS9saW51eC0yLjYuMTEvbmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfUk9V
VEUuYwkyMDA1LTA2LTI3IDE1OjMxOjU0LjAwMDAwMDAwMCArMDIwMA0KKysr
IHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEvcGF0Y2hsZXRzL1JPVVRFL2xp
bnV4LTIuNi4xMS9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dF9ST1VURS5jCTE5
NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQpAQCAtMSwzMDgg
KzAsMCBAQA0KLS8qDQotICogVGhpcyBpbXBsZW1lbnRzIHRoZSBST1VURSB2
NiB0YXJnZXQsIHdoaWNoIGVuYWJsZXMgeW91IHRvIHNldHVwIHVudXN1YWwN
Ci0gKiByb3V0ZXMgbm90IHN1cHBvcnRlZCBieSB0aGUgc3RhbmRhcmQga2Vy
bmVsIHJvdXRpbmcgdGFibGUuDQotICoNCi0gKiBDb3B5cmlnaHQgKEMpIDIw
MDMgQ2VkcmljIGRlIExhdW5vaXMgPGRlbGF1bm9pc0BpbmZvLnVjbC5hYy5i
ZT4NCi0gKg0KLSAqIHYgMS4xIDIwMDQvMTEvMjMNCi0gKg0KLSAqIFRoaXMg
c29mdHdhcmUgaXMgZGlzdHJpYnV0ZWQgdW5kZXIgR05VIEdQTCB2MiwgMTk5
MQ0KLSAqLw0KLQ0KLSNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCi0jaW5j
bHVkZSA8bGludXgvc2tidWZmLmg+DQotI2luY2x1ZGUgPGxpbnV4L2lwdjYu
aD4NCi0jaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2X3RhYmxl
cy5oPg0KLSNpbmNsdWRlIDxsaW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X1JP
VVRFLmg+DQotI2luY2x1ZGUgPGxpbnV4L25ldGRldmljZS5oPg0KLSNpbmNs
dWRlIDxuZXQvaXB2Ni5oPg0KLSNpbmNsdWRlIDxuZXQvbmRpc2MuaD4NCi0j
aW5jbHVkZSA8bmV0L2lwNl9yb3V0ZS5oPg0KLSNpbmNsdWRlIDxsaW51eC9p
Y21wdjYuaD4NCi0NCi0jaWYgMQ0KLSNkZWZpbmUgREVCVUdQIHByaW50aw0K
LSNlbHNlDQotI2RlZmluZSBERUJVR1AoZm9ybWF0LCBhcmdzLi4uKQ0KLSNl
bmRpZg0KLQ0KLSNkZWZpbmUgTklQNihhZGRyKSBcDQotCW50b2hzKChhZGRy
KS5zNl9hZGRyMTZbMF0pLCBcDQotCW50b2hzKChhZGRyKS5zNl9hZGRyMTZb
MV0pLCBcDQotCW50b2hzKChhZGRyKS5zNl9hZGRyMTZbMl0pLCBcDQotCW50
b2hzKChhZGRyKS5zNl9hZGRyMTZbM10pLCBcDQotCW50b2hzKChhZGRyKS5z
Nl9hZGRyMTZbNF0pLCBcDQotCW50b2hzKChhZGRyKS5zNl9hZGRyMTZbNV0p
LCBcDQotCW50b2hzKChhZGRyKS5zNl9hZGRyMTZbNl0pLCBcDQotCW50b2hz
KChhZGRyKS5zNl9hZGRyMTZbN10pDQotDQotLyogUm91dGUgdGhlIHBhY2tl
dCBhY2NvcmRpbmcgdG8gdGhlIHJvdXRpbmcga2V5cyBzcGVjaWZpZWQgaW4N
Ci0gKiByb3V0ZV9pbmZvLiBLZXlzIGFyZSA6DQotICogIC0gaWZpbmRleCA6
IA0KLSAqICAgICAgMCBpZiBubyBvaWYgcHJlZmVycmVkLCANCi0gKiAgICAg
IG90aGVyd2lzZSBzZXQgdG8gdGhlIGluZGV4IG9mIHRoZSBkZXNpcmVkIG9p
Zg0KLSAqICAtIHJvdXRlX2luZm8tPmd3IDoNCi0gKiAgICAgIDAgaWYgbm8g
Z2F0ZXdheSBzcGVjaWZpZWQsDQotICogICAgICBvdGhlcndpc2Ugc2V0IHRv
IHRoZSBuZXh0IGhvc3QgdG8gd2hpY2ggdGhlIHBrdCBtdXN0IGJlIHJvdXRl
ZA0KLSAqIElmIHN1Y2Nlc3MsIHNrYi0+ZGV2IGlzIHRoZSBvdXRwdXQgZGV2
aWNlIHRvIHdoaWNoIHRoZSBwYWNrZXQgbXVzdCANCi0gKiBiZSBzZW50IGFu
ZCBza2ItPmRzdCBpcyBub3QgTlVMTA0KLSAqDQotICogUkVUVVJOOiAgMSBp
ZiB0aGUgcGFja2V0IHdhcyBzdWNjZXNmdWxseSByb3V0ZWQgdG8gdGhlIA0K
LSAqICAgICAgICAgICAgZGVzdGluYXRpb24gZGVzaXJlZA0KLSAqICAgICAg
ICAgIDAgaWYgdGhlIGtlcm5lbCByb3V0aW5nIHRhYmxlIGNvdWxkIG5vdCBy
b3V0ZSB0aGUgcGFja2V0DQotICogICAgICAgICAgICBhY2NvcmRpbmcgdG8g
dGhlIGtleXMgc3BlY2lmaWVkDQotICovDQotc3RhdGljIGludCANCi1yb3V0
ZTYoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCi0gICAgICAgdW5zaWduZWQgaW50
IGlmaW5kZXgsDQotICAgICAgIGNvbnN0IHN0cnVjdCBpcDZ0X3JvdXRlX3Rh
cmdldF9pbmZvICpyb3V0ZV9pbmZvKQ0KLXsNCi0Jc3RydWN0IHJ0Nl9pbmZv
ICpydCA9IE5VTEw7DQotCXN0cnVjdCBpcHY2aGRyICppcHY2aCA9IHNrYi0+
bmguaXB2Nmg7DQotCXN0cnVjdCBpbjZfYWRkciAqZ3cgPSAoc3RydWN0IGlu
Nl9hZGRyKikmcm91dGVfaW5mby0+Z3c7DQotDQotCURFQlVHUCgiaXA2dF9S
T1VURTogY2FsbGVkIHdpdGg6ICIpOw0KLQlERUJVR1AoIkRTVD0lMDR4OiUw
NHg6JTA0eDolMDR4OiUwNHg6JTA0eDolMDR4OiUwNHggIiwgTklQNihpcHY2
aC0+ZGFkZHIpKTsNCi0JREVCVUdQKCJHQVRFV0FZPSUwNHg6JTA0eDolMDR4
OiUwNHg6JTA0eDolMDR4OiUwNHg6JTA0eCAiLCBOSVA2KCpndykpOw0KLQlE
RUJVR1AoIk9VVD0lc1xuIiwgcm91dGVfaW5mby0+b2lmKTsNCi0JDQotCWlm
IChpcHY2X2FkZHJfYW55KGd3KSkNCi0JCXJ0ID0gcnQ2X2xvb2t1cCgmaXB2
NmgtPmRhZGRyLCAmaXB2NmgtPnNhZGRyLCBpZmluZGV4LCAxKTsNCi0JZWxz
ZQ0KLQkJcnQgPSBydDZfbG9va3VwKGd3LCAmaXB2NmgtPnNhZGRyLCBpZmlu
ZGV4LCAxKTsNCi0NCi0JaWYgKCFydCkNCi0JCWdvdG8gbm9fcm91dGU7DQot
DQotCURFQlVHUCgiaXA2dF9ST1VURTogcm91dGluZyBnaXZlczogIik7DQot
CURFQlVHUCgiRFNUPSUwNHg6JTA0eDolMDR4OiUwNHg6JTA0eDolMDR4OiUw
NHg6JTA0eCAiLCBOSVA2KHJ0LT5ydDZpX2RzdC5hZGRyKSk7DQotCURFQlVH
UCgiR0FURVdBWT0lMDR4OiUwNHg6JTA0eDolMDR4OiUwNHg6JTA0eDolMDR4
OiUwNHggIiwgTklQNihydC0+cnQ2aV9nYXRld2F5KSk7DQotCURFQlVHUCgi
T1VUPSVzXG4iLCBydC0+cnQ2aV9kZXYtPm5hbWUpOw0KLQ0KLQlpZiAoaWZp
bmRleCAmJiBydC0+cnQ2aV9kZXYtPmlmaW5kZXghPWlmaW5kZXgpDQotCQln
b3RvIHdyb25nX3JvdXRlOw0KLQkNCi0JaWYgKCFydC0+cnQ2aV9uZXh0aG9w
KSB7DQotCQlERUJVR1AoImlwNnRfUk9VVEU6IGRpc2NvdmVyaW5nIG5laWdo
Ym91clxuIik7DQotCQlydC0+cnQ2aV9uZXh0aG9wID0gbmRpc2NfZ2V0X25l
aWdoKHJ0LT5ydDZpX2RldiwgJnJ0LT5ydDZpX2RzdC5hZGRyKTsNCi0JfQ0K
LQ0KLQkvKiBEcm9wIG9sZCByb3V0ZS4gKi8NCi0JZHN0X3JlbGVhc2Uoc2ti
LT5kc3QpOw0KLQlza2ItPmRzdCA9ICZydC0+dS5kc3Q7DQotCXNrYi0+ZGV2
ID0gcnQtPnJ0NmlfZGV2Ow0KLQlyZXR1cm4gMTsNCi0NCi0gd3Jvbmdfcm91
dGU6DQotCWRzdF9yZWxlYXNlKCZydC0+dS5kc3QpOw0KLSBub19yb3V0ZToN
Ci0JaWYgKCFuZXRfcmF0ZWxpbWl0KCkpDQotCQlyZXR1cm4gMDsNCi0NCi0J
cHJpbnRrKCJpcDZ0X1JPVVRFOiBubyBleHBsaWNpdCByb3V0ZSBmb3VuZCAi
KTsNCi0JaWYgKGlmaW5kZXgpDQotCQlwcmludGsoInZpYSBpbnRlcmZhY2Ug
JXMgIiwgcm91dGVfaW5mby0+b2lmKTsNCi0JaWYgKCFpcHY2X2FkZHJfYW55
KGd3KSkNCi0JCXByaW50aygidmlhIGdhdGV3YXkgJTA0eDolMDR4OiUwNHg6
JTA0eDolMDR4OiUwNHg6JTA0eDolMDR4IiwgTklQNigqZ3cpKTsNCi0JcHJp
bnRrKCJcbiIpOw0KLQlyZXR1cm4gMDsNCi19DQotDQotDQotLyogU3RvbGVu
IGZyb20gaXA2X291dHB1dF9maW5pc2gNCi0gKiBQUkUgOiBza2ItPmRldiBp
cyBzZXQgdG8gdGhlIGRldmljZSB3ZSBhcmUgbGVhdmluZyBieQ0KLSAqICAg
ICAgIHNrYi0+ZHN0IGlzIG5vdCBOVUxMDQotICogUE9TVDogdGhlIHBhY2tl
dCBpcyBzZW50IHdpdGggdGhlIGxpbmsgbGF5ZXIgaGVhZGVyIHB1c2hlZA0K
LSAqICAgICAgIHRoZSBwYWNrZXQgaXMgZGVzdHJveWVkDQotICovDQotc3Rh
dGljIHZvaWQgaXBfZGlyZWN0X3NlbmQoc3RydWN0IHNrX2J1ZmYgKnNrYikN
Ci17DQotCXN0cnVjdCBkc3RfZW50cnkgKmRzdCA9IHNrYi0+ZHN0Ow0KLQlz
dHJ1Y3QgaGhfY2FjaGUgKmhoID0gZHN0LT5oaDsNCi0NCi0JaWYgKGhoKSB7
DQotCQlyZWFkX2xvY2tfYmgoJmhoLT5oaF9sb2NrKTsNCi0JCW1lbWNweShz
a2ItPmRhdGEgLSAxNiwgaGgtPmhoX2RhdGEsIDE2KTsNCi0JCXJlYWRfdW5s
b2NrX2JoKCZoaC0+aGhfbG9jayk7DQotCQlza2JfcHVzaChza2IsIGhoLT5o
aF9sZW4pOw0KLQkJaGgtPmhoX291dHB1dChza2IpOw0KLQl9IGVsc2UgaWYg
KGRzdC0+bmVpZ2hib3VyKQ0KLQkJZHN0LT5uZWlnaGJvdXItPm91dHB1dChz
a2IpOw0KLQllbHNlIHsNCi0JCWlmIChuZXRfcmF0ZWxpbWl0KCkpDQotCQkJ
REVCVUdQKEtFUk5fREVCVUcgImlwNnRfUk9VVEU6IG5vIGhkciAmIG5vIG5l
aWdoYm91ciBjYWNoZSFcbiIpOw0KLQkJa2ZyZWVfc2tiKHNrYik7DQotCX0N
Ci19DQotDQotDQotc3RhdGljIHVuc2lnbmVkIGludCANCi1yb3V0ZTZfb2lm
KGNvbnN0IHN0cnVjdCBpcDZ0X3JvdXRlX3RhcmdldF9pbmZvICpyb3V0ZV9p
bmZvLA0KLQkgICBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKSANCi17DQotCXVuc2ln
bmVkIGludCBpZmluZGV4ID0gMDsNCi0Jc3RydWN0IG5ldF9kZXZpY2UgKmRl
dl9vdXQgPSBOVUxMOw0KLQ0KLQkvKiBUaGUgdXNlciBzZXQgdGhlIGludGVy
ZmFjZSBuYW1lIHRvIHVzZS4NCi0JICogR2V0dGluZyB0aGUgY3VycmVudCBp
bnRlcmZhY2UgaW5kZXguDQotCSAqLw0KLQlpZiAoKGRldl9vdXQgPSBkZXZf
Z2V0X2J5X25hbWUocm91dGVfaW5mby0+b2lmKSkpIHsNCi0JCWlmaW5kZXgg
PSBkZXZfb3V0LT5pZmluZGV4Ow0KLQl9IGVsc2Ugew0KLQkJLyogVW5rbm93
biBpbnRlcmZhY2UgbmFtZSA6IHBhY2tldCBkcm9wcGVkICovDQotCQlpZiAo
bmV0X3JhdGVsaW1pdCgpKSANCi0JCQlERUJVR1AoImlwNnRfUk9VVEU6IG9p
ZiBpbnRlcmZhY2UgJXMgbm90IGZvdW5kXG4iLCByb3V0ZV9pbmZvLT5vaWYp
Ow0KLQ0KLQkJaWYgKHJvdXRlX2luZm8tPmZsYWdzICYgSVA2VF9ST1VURV9D
T05USU5VRSkNCi0JCQlyZXR1cm4gSVA2VF9DT05USU5VRTsNCi0JCWVsc2UN
Ci0JCQlyZXR1cm4gTkZfRFJPUDsNCi0JfQ0KLQ0KLQkvKiBUcnlpbmcgdGhl
IHN0YW5kYXJkIHdheSBvZiByb3V0aW5nIHBhY2tldHMgKi8NCi0JaWYgKHJv
dXRlNihza2IsIGlmaW5kZXgsIHJvdXRlX2luZm8pKSB7DQotCQlkZXZfcHV0
KGRldl9vdXQpOw0KLQkJaWYgKHJvdXRlX2luZm8tPmZsYWdzICYgSVA2VF9S
T1VURV9DT05USU5VRSkNCi0JCQlyZXR1cm4gSVA2VF9DT05USU5VRTsNCi0J
CQ0KLQkJaXBfZGlyZWN0X3NlbmQoc2tiKTsNCi0JCXJldHVybiBORl9TVE9M
RU47DQotCX0gZWxzZSANCi0JCXJldHVybiBORl9EUk9QOw0KLX0NCi0NCi0N
Ci1zdGF0aWMgdW5zaWduZWQgaW50IA0KLXJvdXRlNl9ndyhjb25zdCBzdHJ1
Y3QgaXA2dF9yb3V0ZV90YXJnZXRfaW5mbyAqcm91dGVfaW5mbywNCi0JICBz
dHJ1Y3Qgc2tfYnVmZiAqc2tiKSANCi17DQotCWlmIChyb3V0ZTYoc2tiLCAw
LCByb3V0ZV9pbmZvKSkgew0KLQkJaWYgKHJvdXRlX2luZm8tPmZsYWdzICYg
SVA2VF9ST1VURV9DT05USU5VRSkNCi0JCQlyZXR1cm4gSVA2VF9DT05USU5V
RTsNCi0NCi0JCWlwX2RpcmVjdF9zZW5kKHNrYik7DQotCQlyZXR1cm4gTkZf
U1RPTEVOOw0KLQl9IGVsc2UNCi0JCXJldHVybiBORl9EUk9QOw0KLX0NCi0N
Ci0NCi1zdGF0aWMgdW5zaWduZWQgaW50IA0KLWlwNnRfcm91dGVfdGFyZ2V0
KHN0cnVjdCBza19idWZmICoqcHNrYiwNCi0JCSAgY29uc3Qgc3RydWN0IG5l
dF9kZXZpY2UgKmluLA0KLQkJICBjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAq
b3V0LA0KLQkJICB1bnNpZ25lZCBpbnQgaG9va251bSwNCi0JCSAgY29uc3Qg
dm9pZCAqdGFyZ2luZm8sDQotCQkgIHZvaWQgKnVzZXJpbmZvKQ0KLXsNCi0J
Y29uc3Qgc3RydWN0IGlwNnRfcm91dGVfdGFyZ2V0X2luZm8gKnJvdXRlX2lu
Zm8gPSB0YXJnaW5mbzsNCi0Jc3RydWN0IHNrX2J1ZmYgKnNrYiA9ICpwc2ti
Ow0KLQlzdHJ1Y3QgaW42X2FkZHIgKmd3ID0gKHN0cnVjdCBpbjZfYWRkciop
JnJvdXRlX2luZm8tPmd3Ow0KLQl1bnNpZ25lZCBpbnQgcmVzOw0KLQ0KLQlp
ZiAocm91dGVfaW5mby0+ZmxhZ3MgJiBJUDZUX1JPVVRFX0NPTlRJTlVFKQ0K
LQkJZ290byBkb19pdDsNCi0NCi0JLyogSWYgd2UgYXJlIGF0IFBSRVJPVVRJ
Tkcgb3IgSU5QVVQgaG9vaw0KLQkgKiB0aGUgVFRMIGlzbid0IGRlY3JlYXNl
ZCBieSB0aGUgSVAgc3RhY2sNCi0JICovDQotCWlmIChob29rbnVtID09IE5G
X0lQNl9QUkVfUk9VVElORyB8fA0KLQkgICAgaG9va251bSA9PSBORl9JUDZf
TE9DQUxfSU4pIHsNCi0NCi0JCXN0cnVjdCBpcHY2aGRyICppcHY2aCA9IHNr
Yi0+bmguaXB2Nmg7DQotDQotCQlpZiAoaXB2NmgtPmhvcF9saW1pdCA8PSAx
KSB7DQotCQkJLyogRm9yY2UgT1VUUFVUIGRldmljZSB1c2VkIGFzIHNvdXJj
ZSBhZGRyZXNzICovDQotCQkJc2tiLT5kZXYgPSBza2ItPmRzdC0+ZGV2Ow0K
LQ0KLQkJCWljbXB2Nl9zZW5kKHNrYiwgSUNNUFY2X1RJTUVfRVhDRUVELCAN
Ci0JCQkJICAgIElDTVBWNl9FWENfSE9QTElNSVQsIDAsIHNrYi0+ZGV2KTsN
Ci0NCi0JCQlyZXR1cm4gTkZfRFJPUDsNCi0JCX0NCi0NCi0JCWlwdjZoLT5o
b3BfbGltaXQtLTsNCi0JfQ0KLQ0KLQlpZiAoKHJvdXRlX2luZm8tPmZsYWdz
ICYgSVA2VF9ST1VURV9URUUpKSB7DQotCQkvKg0KLQkJICogQ29weSB0aGUg
KnBza2IsIGFuZCByb3V0ZSB0aGUgY29weS4gV2lsbCBsYXRlciByZXR1cm4N
Ci0JCSAqIElQNlRfQ09OVElOVUUgZm9yIHRoZSBvcmlnaW5hbCBza2IsIHdo
aWNoIHNob3VsZCBjb250aW51ZQ0KLQkJICogb24gaXRzIHdheSBhcyBpZiBu
b3RoaW5nIGhhcHBlbmVkLiBUaGUgY29weSBzaG91bGQgYmUNCi0JCSAqIGlu
ZGVwZW5kYW50bHkgZGVsaXZlcmVkIHRvIHRoZSBST1VURSAtLWd3Lg0KLQkJ
ICovDQotCQlza2IgPSBza2JfY29weSgqcHNrYiwgR0ZQX0FUT01JQyk7DQot
CQlpZiAoIXNrYikgew0KLQkJCWlmIChuZXRfcmF0ZWxpbWl0KCkpIA0KLQkJ
CQlERUJVR1AoS0VSTl9ERUJVRyAiaXA2dF9ST1VURTogY29weSBmYWlsZWQh
XG4iKTsNCi0JCQlyZXR1cm4gSVA2VF9DT05USU5VRTsNCi0JCX0NCi0JfQ0K
LQ0KLWRvX2l0Og0KLQlpZiAocm91dGVfaW5mby0+b2lmWzBdKSB7DQotCQly
ZXMgPSByb3V0ZTZfb2lmKHJvdXRlX2luZm8sIHNrYik7DQotCX0gZWxzZSBp
ZiAoIWlwdjZfYWRkcl9hbnkoZ3cpKSB7DQotCQlyZXMgPSByb3V0ZTZfZ3co
cm91dGVfaW5mbywgc2tiKTsNCi0JfSBlbHNlIHsNCi0JCWlmIChuZXRfcmF0
ZWxpbWl0KCkpIA0KLQkJCURFQlVHUChLRVJOX0RFQlVHICJpcDZ0X1JPVVRF
OiBubyBwYXJhbWV0ZXIgIVxuIik7DQotCQlyZXMgPSBJUDZUX0NPTlRJTlVF
Ow0KLQl9DQotDQotCWlmICgocm91dGVfaW5mby0+ZmxhZ3MgJiBJUDZUX1JP
VVRFX1RFRSkpDQotCQlyZXMgPSBJUDZUX0NPTlRJTlVFOw0KLQ0KLQlyZXR1
cm4gcmVzOw0KLX0NCi0NCi0NCi1zdGF0aWMgaW50IA0KLWlwNnRfcm91dGVf
Y2hlY2tlbnRyeShjb25zdCBjaGFyICp0YWJsZW5hbWUsDQotCQkgICAgICBj
b25zdCBzdHJ1Y3QgaXA2dF9lbnRyeSAqZSwNCi0JCSAgICAgIHZvaWQgKnRh
cmdpbmZvLA0KLQkJICAgICAgdW5zaWduZWQgaW50IHRhcmdpbmZvc2l6ZSwN
Ci0JCSAgICAgIHVuc2lnbmVkIGludCBob29rX21hc2spDQotew0KLQlpZiAo
c3RyY21wKHRhYmxlbmFtZSwgIm1hbmdsZSIpICE9IDApIHsNCi0JCXByaW50
aygiaXA2dF9ST1VURTogY2FuIG9ubHkgYmUgY2FsbGVkIGZyb20gXCJtYW5n
bGVcIiB0YWJsZS5cbiIpOw0KLQkJcmV0dXJuIDA7DQotCX0NCi0NCi0JaWYg
KHRhcmdpbmZvc2l6ZSAhPSBJUDZUX0FMSUdOKHNpemVvZihzdHJ1Y3QgaXA2
dF9yb3V0ZV90YXJnZXRfaW5mbykpKSB7DQotCQlwcmludGsoS0VSTl9XQVJO
SU5HICJpcDZ0X1JPVVRFOiB0YXJnaW5mb3NpemUgJXUgIT0gJVp1XG4iLA0K
LQkJICAgICAgIHRhcmdpbmZvc2l6ZSwNCi0JCSAgICAgICBJUDZUX0FMSUdO
KHNpemVvZihzdHJ1Y3QgaXA2dF9yb3V0ZV90YXJnZXRfaW5mbykpKTsNCi0J
CXJldHVybiAwOw0KLQl9DQotDQotCXJldHVybiAxOw0KLX0NCi0NCi0NCi1z
dGF0aWMgc3RydWN0IGlwNnRfdGFyZ2V0IGlwNnRfcm91dGVfcmVnID0gew0K
LQkubmFtZSAgICAgICA9ICJST1VURSIsDQotCS50YXJnZXQgICAgID0gaXA2
dF9yb3V0ZV90YXJnZXQsDQotCS5jaGVja2VudHJ5ID0gaXA2dF9yb3V0ZV9j
aGVja2VudHJ5LA0KLQkubWUgICAgICAgICA9IFRISVNfTU9EVUxFDQotfTsN
Ci0NCi0NCi1zdGF0aWMgaW50IF9faW5pdCBpbml0KHZvaWQpDQotew0KLQlw
cmludGsoS0VSTl9ERUJVRyAicmVnaXN0ZXJpbmcgaXB2NiBST1VURSB0YXJn
ZXRcbiIpOw0KLQlpZiAoaXA2dF9yZWdpc3Rlcl90YXJnZXQoJmlwNnRfcm91
dGVfcmVnKSkNCi0JCXJldHVybiAtRUlOVkFMOw0KLQ0KLQlyZXR1cm4gMDsN
Ci19DQotDQotDQotc3RhdGljIHZvaWQgX19leGl0IGZpbmkodm9pZCkNCi17
DQotCWlwNnRfdW5yZWdpc3Rlcl90YXJnZXQoJmlwNnRfcm91dGVfcmVnKTsN
Ci19DQotDQotbW9kdWxlX2luaXQoaW5pdCk7DQotbW9kdWxlX2V4aXQoZmlu
aSk7DQotTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KZGlmZiAtTnVyIHBhdGNo
LW8tbWF0aWMtbmctMjAwNjAzMTEtb3JpZy9wYXRjaGxldHMvUk9VVEUvbGlu
dXgtMi42LjExL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9S
T1VURS5oIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEvcGF0Y2hsZXRzL1JP
VVRFL2xpbnV4LTIuNi4xMS9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY2
L2lwNnRfUk9VVEUuaA0KLS0tIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEt
b3JpZy9wYXRjaGxldHMvUk9VVEUvbGludXgtMi42LjExL2luY2x1ZGUvbGlu
dXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9ST1VURS5oCTIwMDQtMTItMTQgMDM6
NTg6MzEuMDAwMDAwMDAwICswMTAwDQorKysgcGF0Y2gtby1tYXRpYy1uZy0y
MDA2MDMxMS9wYXRjaGxldHMvUk9VVEUvbGludXgtMi42LjExL2luY2x1ZGUv
bGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9ST1VURS5oCTE5NzAtMDEtMDEg
MDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQpAQCAtMSwyMyArMCwwIEBADQot
LyogSGVhZGVyIGZpbGUgZm9yIGlwdGFibGVzIGlwNnRfUk9VVEUgdGFyZ2V0
DQotICoNCi0gKiAoQykgMjAwMyBieSBD6WRyaWMgZGUgTGF1bm9pcyA8ZGVs
YXVub2lzQGluZm8udWNsLmFjLmJlPg0KLSAqDQotICogVGhpcyBzb2Z0d2Fy
ZSBpcyBkaXN0cmlidXRlZCB1bmRlciBHTlUgR1BMIHYyLCAxOTkxDQotICov
DQotI2lmbmRlZiBfSVBUX1JPVVRFX0hfdGFyZ2V0DQotI2RlZmluZSBfSVBU
X1JPVVRFX0hfdGFyZ2V0DQotDQotI2RlZmluZSBJUDZUX1JPVVRFX0lGTkFN
U0laIDE2DQotDQotc3RydWN0IGlwNnRfcm91dGVfdGFyZ2V0X2luZm8gew0K
LQljaGFyICAgICAgb2lmW0lQNlRfUk9VVEVfSUZOQU1TSVpdOyAgICAgLyog
T3V0cHV0IEludGVyZmFjZSBOYW1lICovDQotCWNoYXIgICAgICBpaWZbSVA2
VF9ST1VURV9JRk5BTVNJWl07ICAgICAvKiBJbnB1dCBJbnRlcmZhY2UgTmFt
ZSAgKi8NCi0JdV9pbnQzMl90IGd3WzRdOyAgICAgICAgICAgICAgICAgICAg
ICAgIC8qIElQdjYgYWRkcmVzcyBvZiBnYXRld2F5ICovDQotCXVfaW50OF90
ICBmbGFnczsNCi19Ow0KLQ0KLS8qIFZhbHVlcyBmb3IgImZsYWdzIiBmaWVs
ZCAqLw0KLSNkZWZpbmUgSVA2VF9ST1VURV9DT05USU5VRSAgICAgICAgMHgw
MQ0KLSNkZWZpbmUgSVA2VF9ST1VURV9URUUgICAgICAgICAgICAgMHgwMg0K
LQ0KLSNlbmRpZiAvKl9JUDZUX1JPVVRFX0hfdGFyZ2V0Ki8NCmRpZmYgLU51
ciBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzExLW9yaWcvcGF0Y2hsZXRzL1JP
VVRFL2xpbnV4LTIuNi4xMS9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY0
L2lwdF9ST1VURS5oIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEvcGF0Y2hs
ZXRzL1JPVVRFL2xpbnV4LTIuNi4xMS9pbmNsdWRlL2xpbnV4L25ldGZpbHRl
cl9pcHY0L2lwdF9ST1VURS5oDQotLS0gcGF0Y2gtby1tYXRpYy1uZy0yMDA2
MDMxMS1vcmlnL3BhdGNobGV0cy9ST1VURS9saW51eC0yLjYuMTEvaW5jbHVk
ZS9saW51eC9uZXRmaWx0ZXJfaXB2NC9pcHRfUk9VVEUuaAkyMDA0LTEyLTE0
IDAzOjU4OjMxLjAwMDAwMDAwMCArMDEwMA0KKysrIHBhdGNoLW8tbWF0aWMt
bmctMjAwNjAzMTEvcGF0Y2hsZXRzL1JPVVRFL2xpbnV4LTIuNi4xMS9pbmNs
dWRlL2xpbnV4L25ldGZpbHRlcl9pcHY0L2lwdF9ST1VURS5oCTE5NzAtMDEt
MDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQpAQCAtMSwyMyArMCwwIEBA
DQotLyogSGVhZGVyIGZpbGUgZm9yIGlwdGFibGVzIGlwdF9ST1VURSB0YXJn
ZXQNCi0gKg0KLSAqIChDKSAyMDAyIGJ5IEPpZHJpYyBkZSBMYXVub2lzIDxk
ZWxhdW5vaXNAaW5mby51Y2wuYWMuYmU+DQotICoNCi0gKiBUaGlzIHNvZnR3
YXJlIGlzIGRpc3RyaWJ1dGVkIHVuZGVyIEdOVSBHUEwgdjIsIDE5OTENCi0g
Ki8NCi0jaWZuZGVmIF9JUFRfUk9VVEVfSF90YXJnZXQNCi0jZGVmaW5lIF9J
UFRfUk9VVEVfSF90YXJnZXQNCi0NCi0jZGVmaW5lIElQVF9ST1VURV9JRk5B
TVNJWiAxNg0KLQ0KLXN0cnVjdCBpcHRfcm91dGVfdGFyZ2V0X2luZm8gew0K
LQljaGFyICAgICAgb2lmW0lQVF9ST1VURV9JRk5BTVNJWl07ICAgICAgLyog
T3V0cHV0IEludGVyZmFjZSBOYW1lICovDQotCWNoYXIgICAgICBpaWZbSVBU
X1JPVVRFX0lGTkFNU0laXTsgICAgICAvKiBJbnB1dCBJbnRlcmZhY2UgTmFt
ZSAgKi8NCi0JdV9pbnQzMl90IGd3OyAgICAgICAgICAgICAgICAgICAgICAg
ICAgIC8qIElQIGFkZHJlc3Mgb2YgZ2F0ZXdheSAqLw0KLQl1X2ludDhfdCAg
ZmxhZ3M7DQotfTsNCi0NCi0vKiBWYWx1ZXMgZm9yICJmbGFncyIgZmllbGQg
Ki8NCi0jZGVmaW5lIElQVF9ST1VURV9DT05USU5VRSAgICAgICAgMHgwMQ0K
LSNkZWZpbmUgSVBUX1JPVVRFX1RFRSAgICAgICAgICAgICAweDAyDQotDQot
I2VuZGlmIC8qX0lQVF9ST1VURV9IX3RhcmdldCovDQpkaWZmIC1OdXIgcGF0
Y2gtby1tYXRpYy1uZy0yMDA2MDMxMS1vcmlnL3BhdGNobGV0cy9ST1VURS9s
aW51eC0yLjYvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9ST1VURS5jIHBhdGNo
LW8tbWF0aWMtbmctMjAwNjAzMTEvcGF0Y2hsZXRzL1JPVVRFL2xpbnV4LTIu
Ni9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X1JPVVRFLmMNCi0tLSBwYXRjaC1v
LW1hdGljLW5nLTIwMDYwMzExLW9yaWcvcGF0Y2hsZXRzL1JPVVRFL2xpbnV4
LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X1JPVVRFLmMJMjAwNC0xMi0x
NCAwMzo1ODozMS4wMDAwMDAwMDAgKzAxMDANCisrKyBwYXRjaC1vLW1hdGlj
LW5nLTIwMDYwMzExL3BhdGNobGV0cy9ST1VURS9saW51eC0yLjYvbmV0L2lw
djQvbmV0ZmlsdGVyL2lwdF9ST1VURS5jCTIwMDYtMDMtMjEgMjM6NDA6NDMu
MDAwMDAwMDAwICswMTAwDQpAQCAtMTcsNiArMTcsNyBAQA0KICNpbmNsdWRl
IDxsaW51eC9uZXRmaWx0ZXJfaXB2NC9pcHRfUk9VVEUuaD4NCiAjaW5jbHVk
ZSA8bGludXgvbmV0ZGV2aWNlLmg+DQogI2luY2x1ZGUgPGxpbnV4L3JvdXRl
Lmg+DQorI2luY2x1ZGUgPGxpbnV4L2lmX2FycC5oPg0KICNpbmNsdWRlIDxu
ZXQvaXAuaD4NCiAjaW5jbHVkZSA8bmV0L3JvdXRlLmg+DQogI2luY2x1ZGUg
PG5ldC9pY21wLmg+DQpAQCAtMzc3LDcgKzM3OCw2IEBADQogCQlza2ItPm5m
Y3QgPSAmcm91dGVfdGVlX3RyYWNrLmN0X2dlbmVyYWw7DQogCQlza2ItPm5m
Y3RpbmZvID0gSVBfQ1RfTkVXOw0KIAkJbmZfY29ubnRyYWNrX2dldChza2It
Pm5mY3QpOw0KLQkJc2tiLT5uZmNhY2hlID0gMDsNCiAjaWZkZWYgQ09ORklH
X05FVEZJTFRFUl9ERUJVRw0KIAkJc2tiLT5uZl9kZWJ1ZyA9IDA7DQogI2Vu
ZGlmDQpAQCAtNDAzLDcgKzQwMyw3IEBADQogDQogDQogc3RhdGljIGludCBp
cHRfcm91dGVfY2hlY2tlbnRyeShjb25zdCBjaGFyICp0YWJsZW5hbWUsDQot
CQkJCWNvbnN0IHN0cnVjdCBpcHRfZW50cnkgKmUsDQorCQkJCWNvbnN0IHZv
aWQgKmUsDQogCQkJCXZvaWQgKnRhcmdpbmZvLA0KIAkJCQl1bnNpZ25lZCBp
bnQgdGFyZ2luZm9zaXplLA0KIAkJCQl1bnNpZ25lZCBpbnQgaG9va19tYXNr
KQ0KQEAgLTQ0OSw4ICs0NDksNyBAQA0KIAkvKiAgLSBhbmQgbG9vayBpdCBs
aWtlIGFzIGEgY29uZmlybWVkIGNvbm5lY3Rpb24gKi8NCiAJc2V0X2JpdChJ
UFNfQ09ORklSTUVEX0JJVCwgJnJvdXRlX3RlZV90cmFjay5zdGF0dXMpOw0K
IAkvKiBJbml0aWFsaXplIGZha2UgY29ubnRyYWNrIHNvIHRoYXQgTkFUIHdp
bGwgc2tpcCBpdCAqLw0KLQlyb3V0ZV90ZWVfdHJhY2submF0LmluZm8uaW5p
dGlhbGl6ZWQgfD0gDQotCQkoMSA8PCBJUF9OQVRfTUFOSVBfU1JDKSB8ICgx
IDw8IElQX05BVF9NQU5JUF9EU1QpOw0KKwlyb3V0ZV90ZWVfdHJhY2suc3Rh
dHVzIHw9IElQU19OQVRfRE9ORV9NQVNLOw0KIA0KIAlyZXR1cm4gaXB0X3Jl
Z2lzdGVyX3RhcmdldCgmaXB0X3JvdXRlX3JlZyk7DQogfQ0KZGlmZiAtTnVy
IHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEtb3JpZy9wYXRjaGxldHMvUk9V
VEUvbGludXgtMi42L25ldC9pcHY2L25ldGZpbHRlci9NYWtlZmlsZS5sYWRk
IHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEvcGF0Y2hsZXRzL1JPVVRFL2xp
bnV4LTIuNi9uZXQvaXB2Ni9uZXRmaWx0ZXIvTWFrZWZpbGUubGFkZA0KLS0t
IHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEtb3JpZy9wYXRjaGxldHMvUk9V
VEUvbGludXgtMi42L25ldC9pcHY2L25ldGZpbHRlci9NYWtlZmlsZS5sYWRk
CTIwMDQtMDUtMDYgMTQ6NDE6MTkuMDAwMDAwMDAwICswMjAwDQorKysgcGF0
Y2gtby1tYXRpYy1uZy0yMDA2MDMxMS9wYXRjaGxldHMvUk9VVEUvbGludXgt
Mi42L25ldC9pcHY2L25ldGZpbHRlci9NYWtlZmlsZS5sYWRkCTIwMDYtMDMt
MTIgMDI6MjU6MzguMDAwMDAwMDAwICswMTAwDQpAQCAtMSwyICsxLDIgQEAN
Ci1vYmotJChDT05GSUdfSVA2X05GX1RBUkdFVF9NQVJLKSArPSBpcDZ0X01B
Uksubw0KK29iai0kKENPTkZJR19JUDZfTkZfVEFSR0VUX1JFSkVDVCkgKz0g
aXA2dF9SRUpFQ1Qubw0KIG9iai0kKENPTkZJR19JUDZfTkZfVEFSR0VUX1JP
VVRFKSArPSBpcDZ0X1JPVVRFLm8NCmRpZmYgLU51ciBwYXRjaC1vLW1hdGlj
LW5nLTIwMDYwMzExLW9yaWcvcGF0Y2hsZXRzL1JPVVRFL2xpbnV4LTIuNi4x
MS5wYXRjaCBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzExL3BhdGNobGV0cy9S
T1VURS9saW51eC0yLjYuMTEucGF0Y2gNCi0tLSBwYXRjaC1vLW1hdGljLW5n
LTIwMDYwMzExLW9yaWcvcGF0Y2hsZXRzL1JPVVRFL2xpbnV4LTIuNi4xMS5w
YXRjaAkyMDA1LTA0LTAxIDA4OjUwOjQxLjAwMDAwMDAwMCArMDIwMA0KKysr
IHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEvcGF0Y2hsZXRzL1JPVVRFL2xp
bnV4LTIuNi4xMS5wYXRjaAkxOTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAwMDAw
MCArMDEwMA0KQEAgLTEsMTEgKzAsMCBAQA0KLT09PT09IG5ldC9pcHY2L2lw
djZfc3ltcy5jIDEuMjIgdnMgZWRpdGVkID09PT09DQotLS0tIDEuMjIvbmV0
L2lwdjYvaXB2Nl9zeW1zLmMJMjAwNS0wMS0xNCAxMzozMDowOCAtMDg6MDAN
Ci0rKysgZWRpdGVkL25ldC9pcHY2L2lwdjZfc3ltcy5jCTIwMDUtMDMtMzEg
MTI6NDE6MzAgLTA4OjAwDQotQEAgLTEyLDYgKzEyLDcgQEAgRVhQT1JUX1NZ
TUJPTChpY21wdjZfc2VuZCk7DQotIEVYUE9SVF9TWU1CT0woaWNtcHY2X3N0
YXRpc3RpY3MpOw0KLSBFWFBPUlRfU1lNQk9MKGljbXB2Nl9lcnJfY29udmVy
dCk7DQotIEVYUE9SVF9TWU1CT0wobmRpc2NfbWNfbWFwKTsNCi0rRVhQT1JU
X1NZTUJPTChuZF90YmwpOw0KLSBFWFBPUlRfU1lNQk9MKHJlZ2lzdGVyX2lu
ZXQ2YWRkcl9ub3RpZmllcik7DQotIEVYUE9SVF9TWU1CT0wodW5yZWdpc3Rl
cl9pbmV0NmFkZHJfbm90aWZpZXIpOw0KLSBFWFBPUlRfU1lNQk9MKGlwNl9y
b3V0ZV9vdXRwdXQpOw0K

---187430788-237918837-1143461832=:17570--
