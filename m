From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: [PATCH] New 'ROUTE' target - cvs patch
Date: 11 Jun 2002 17:40:14 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023810014.3124.63.camel@descartes>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi again,

Sorry, I didn't include the ROUTE target patch straight in the body of
my last message.

It should be better now... apologies...

C=E9dric


diff -Nru netfilter.orig/userspace/extensions/.ROUTE-test
netfilter/userspace/extensions/.ROUTE-test
--- netfilter.orig/userspace/extensions/.ROUTE-test     Thu Jan  1
01:00:00 1970
+++ netfilter/userspace/extensions/.ROUTE-test  Tue Jun 11 14:06:52 2002
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_ROUTE.c ] && echo ROUTE
diff -Nru netfilter.orig/userspace/extensions/Makefile
netfilter/userspace/extensions/Makefile
--- netfilter.orig/userspace/extensions/Makefile        Wed May 29
17:11:49 2002
+++ netfilter/userspace/extensions/Makefile     Tue Jun 11 14:06:20 2002
@@ -1,6 +1,6 @@
 #! /usr/bin/make
=20
-PF_EXT_SLIB:=3Dah conntrack dscp ecn esp icmp length limit mac mark
multiport owner pkttype standard state tcp tcpmss tos ttl udp unclean
DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT
TCPMSS TOS ULOG
+PF_EXT_SLIB:=3Dah conntrack dscp ecn esp icmp length limit mac mark
multiport owner pkttype standard state tcp tcpmss tos ttl udp unclean
DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT
TCPMSS TOS ULOG ROUTE
 PF6_EXT_SLIB:=3Deui64 icmpv6 length limit mac mark multiport owner
standard tcp udp LOG MARK
=20
 # The following may not be present, but compile them anyway.
diff -Nru netfilter.orig/userspace/extensions/libipt_ROUTE.c
netfilter/userspace/extensions/libipt_ROUTE.c
--- netfilter.orig/userspace/extensions/libipt_ROUTE.c  Thu Jan  1
01:00:00 1970
+++ netfilter/userspace/extensions/libipt_ROUTE.c       Fri Jun  7
12:51:15 2002
@@ -0,0 +1,142 @@
+/* Shared library add-on to iptables to add ROUTE target support.
+ * Author : C=E9dric de Launois, <delaunois@info.ucl.ac.be>
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_ROUTE.h>
+#include <net/if.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+       printf(
+"ROUTE target v%s options:\n"
+"  --iface   name                Send this packet directly through
iface name.\n"
+"  --ifindex index               Send this packet directly through
iface index.\n"
+"\n",
+NETFILTER_VERSION);
+}
+
+static struct option opts[] =3D {
+       { "iface", 1, 0, '1' },
+       { "ifindex", 1, 0, '2' },
+       { 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct ipt_entry_target *t, unsigned int *nfcache)
+{
+}
+
+#define IPT_ROUTE_OPT_IF    0x01
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      struct ipt_entry_target **target)
+{
+       struct ipt_route_target_info *route_info =3D=20
+               (struct ipt_route_target_info*)(*target)->data;
+
+       unsigned int if_index;
+
+       switch (c) {
+               char *end;
+       case '1':
+               if (*flags & IPT_ROUTE_OPT_IF)
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Can't specify --iface or --ifindex
twice");
+
+               if (check_inverse(optarg, &invert))
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Unexpected `!' after --iface");
+
+               if ((if_index =3D if_nametoindex(optarg))=3D=3D0)
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Unknown interface name %s", optarg);
+
+               route_info->if_index =3D if_index;
+               *flags |=3D IPT_ROUTE_OPT_IF;
+               break;
+
+       case '2':
+               if (*flags & IPT_ROUTE_OPT_IF)
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Can't specify --iface or --ifindex
twice");
+
+               if (check_inverse(optarg, &invert))
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Unexpected `!' after --ifindex");
+
+               route_info->if_index =3D strtoul(optarg, &end, 0);
+
+               if (*end !=3D '\0' || end =3D=3D optarg)
+                       exit_error(PARAMETER_PROBLEM, "Bad ROUTE ifindex
`%s'", optarg);
+
+               *flags |=3D IPT_ROUTE_OPT_IF;
+               break;
+
+       default:
+               return 0;
+       }
+
+       return 1;
+}
+
+static void
+final_check(unsigned int flags)
+{
+       if (!flags)
+               exit_error(PARAMETER_PROBLEM,
+                          "ROUTE target: Parameter --iface is
required");
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+       const struct ipt_route_target_info *route_info
+               =3D (const struct ipt_route_target_info *)target->data;
+
+       printf("ROUTE ");
+
+       if (route_info->if_index !=3D 0) {
+               char buf[IF_NAMESIZE];
+               printf("iface %s(%d) ",
+                      if_indextoname(route_info->if_index, buf),
+                      route_info->if_index);
+       }
+}
+
+static
+struct iptables_target route
+=3D { NULL,
+    "ROUTE",
+    NETFILTER_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_route_target_info)),
+    IPT_ALIGN(sizeof(struct ipt_route_target_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    NULL, /* save */
+    opts
+};
+
+void _init(void)
+{
+       register_target(&route);
+}
diff -Nru
netfilter.orig/userspace/include/linux/netfilter_ipv4/ipt_ROUTE.h
netfilter/userspace/include/linux/netfilter_ipv4/ipt_ROUTE.h
--- netfilter.orig/userspace/include/linux/netfilter_ipv4/ipt_ROUTE.h =20
Thu Jan  1 01:00:00 1970
+++ netfilter/userspace/include/linux/netfilter_ipv4/ipt_ROUTE.h      =20
Tue Jun  4 12:34:01 2002
@@ -0,0 +1,8 @@
+#ifndef _IPT_ROUTE_H_target
+#define _IPT_ROUTE_H_target
+
+struct ipt_route_target_info {
+       unsigned int if_index;
+};
+
+#endif /*_IPT_ROUTE_H_target*/
diff -Nru netfilter.orig/userspace/patch-o-matic/pending/ROUTE.patch
netfilter/userspace/patch-o-matic/pending/ROUTE.patch
--- netfilter.orig/userspace/patch-o-matic/pending/ROUTE.patch  Thu Jan=20
1 01:00:00 1970
+++ netfilter/userspace/patch-o-matic/pending/ROUTE.patch       Tue Jun
11 12:32:19 2002
@@ -0,0 +1,263 @@
+diff -Nru linux/include/linux/netfilter_ipv4/ipt_ROUTE.h
linux-new/include/linux/netfilter_ipv4/ipt_ROUTE.h
+--- linux/include/linux/netfilter_ipv4/ipt_ROUTE.h     Thu Jan  1
01:00:00 1970
++++ linux-new/include/linux/netfilter_ipv4/ipt_ROUTE.h Mon Jun 10
09:21:41 2002
+@@ -0,0 +1,8 @@
++#ifndef _IPT_ROUTE_H_target
++#define _IPT_ROUTE_H_target
++
++struct ipt_route_target_info {
++      unsigned int if_index;
++};
++
++#endif /*_IPT_ROUTE_H_target*/
+diff -Nru linux/net/ipv4/netfilter/ipt_ROUTE.c
linux-new/net/ipv4/netfilter/ipt_ROUTE.c
+--- linux/net/ipv4/netfilter/ipt_ROUTE.c       Thu Jan  1 01:00:00 1970
++++ linux-new/net/ipv4/netfilter/ipt_ROUTE.c   Mon Jun 10 10:41:30 2002
+@@ -0,0 +1,247 @@
++/*
++ * This is a module which is used for rerouting packets without
modifying them.
++ * This module is particularly useful when the dst IP is one of our
own IP=20
++ * addresses. Packet with those addresses are locally delivered and
++ * cannot be forwarded using the standard routing mechanisms.
++ *
++ * This module can reroute packets to the interface selected by the
user.
++ * Example :
++ *
++ * iptables -A PREROUTING -i eth0 -p tcp --dport 8000:8200 -j ROUTE
--iface eth1
++ *
++ * i.e. the module reroute tcp packets coming from eth0 with dsp port
8000-8200=20
++ * towards iface eth1.
++ *
++ * The rerouting is used by i.e. RSIP protocol when RSAP-IP method is=20
++ * selected.
++ *
++ * Based on code from: ipt_MIRROR.c and various sources.
++ *
++ * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
++ *
++ * This program is free software; you can redistribute it and/or
modify it
++ * under the terms of the GNU General Public License as published by
the
++ * Free Software Foundation; either version 2 of the License, or (at
your
++ * option) any later version.
++ *
++ * This program is distributed in the hope that it will be useful, but
++ * WITHOUT ANY WARRANTY; without even the implied warranty of
++ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
++ * General Public License for more details.
++ *
++ * You should have received a copy of the GNU General Public License
++ * along with this program; if not, write to the Free Software
Foundation,
++ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
++ *
++ */
++
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/ip.h>
++#include <linux/netfilter_ipv4/ip_tables.h>
++#include <linux/netfilter_ipv4/ipt_ROUTE.h>
++#include <linux/netdevice.h>
++#include <linux/route.h>
++#include <net/ip.h>
++#include <net/icmp.h>
++
++
++/* PRE : skb is the packet and ifindex is the interface index through
which=20
++ *       the packet should be rerouted
++ * POST: skb->dev is the output device towards which the packet is
rerouted
++ *       returns 0 if the packet could not be rerouted
++ *       returns 1 and skb->dst is not NULL if a regular route has
been found
++ *       in the routing table
++ *       returns 2 and skb->dst is NULL otherwise
++ */
++static int route(struct sk_buff *skb, unsigned int ifindex)
++{
++      int err;
++        struct iphdr *iph =3D skb->nh.iph;
++      struct rtable *rt;
++      struct rt_key key =3D {=20
++              dst:iph->daddr,
++              src:0,
++              oif:ifindex,=20
++              tos:RT_TOS(iph->tos)=20
++      };
++
++      nf_conntrack_put(skb->nfct);
++      skb->nfct =3D NULL;
++
++      /* Trying to route the packet with the standard routing table.
*/
++      if ((err =3D ip_route_output_key(&rt, &key))) {
++              printk("ipt_ROUTE couldn't route pkt (err: %i)",err);
++              return 0;
++      }
++
++      /* Drop old device. */
++      if (skb->dev) {
++              dev_put(skb->dev);
++              skb->dev =3D NULL;
++      }
++
++      /* Check if the interface we are leaving by is the same as the
++         * one we requested.
++       */
++      if (rt->u.dst.dev->ifindex =3D=3D ifindex) {
++              /* Drop old route. */
++              dst_release(skb->dst);
++              skb->dst =3D &rt->u.dst;
++              skb->dev =3D skb->dst->dev;
++              return 1;
++      }
++      /* The interface selected by the routing table is not the one
++       * specified by the user. This may happen because the dst
address
++       * is one of our own addresses. This module makes it possible to
++       * reroute such packets by forcing the device to use.
++       * This is useful i.e. to the RSIP protocol (RFC3102).
++       */
++      if ((skb->dev =3D dev_get_by_index(ifindex)) !=3D NULL) {
++              /* Drop old route. */
++              dst_release(skb->dst);
++              skb->dst =3D NULL;
++              return 2;
++      }
++
++      return 0;
++}
++
++
++/* PRE : skb->dev is set to the device we are leaving by
++ * POST: - if skb->dst is not NULL, then the packet is sent with the
++ *         link layer header pushed
++ *       - if skb->dst is NULL, then the packet is directly sent to
++ *         the skb->dev device, without pushing the link layer header.
++ *         This should be only used for tunnel interfaces, for which
++ *         link layer headers are automatically generated.
++ */
++static void ip_direct_send(struct sk_buff *skb)
++{
++      struct dst_entry *dst =3D skb->dst;
++      struct hh_cache *hh;
++
++      if (!dst) {
++              dev_queue_xmit(skb);
++              return;
++      }
++
++      hh =3D dst->hh;
++      if (hh) {
++              read_lock_bh(&hh->hh_lock);
++              memcpy(skb->data - 16, hh->hh_data, 16);
++              read_unlock_bh(&hh->hh_lock);
++              skb_push(skb, hh->hh_len);
++              hh->hh_output(skb);
++      } else if (dst->neighbour)
++              dst->neighbour->output(skb);
++      else {
++              printk(KERN_DEBUG "khm in MIRROR\n");
++              kfree_skb(skb);
++      }
++}
++
++
++static unsigned int ipt_route_target(struct sk_buff **pskb,
++                                    unsigned int hooknum,
++                                    const struct net_device *in,
++                                    const struct net_device *out,
++                                    const void *targinfo,
++                                    void *userinfo)
++{
++      const struct ipt_route_target_info *route_info =3D targinfo;
++
++      printk("RCV from IN=3D%s OUT=3D%s PROTO=3D%u \n",
++             in ? in->name : "",
++             out ? out->name : "",
++             (*pskb)->protocol);
++
++      /* If we are not at FORWARD hook
++       * the TTL isn't decreased by the IP stack
++       */
++      if (hooknum !=3D NF_IP_FORWARD) {
++              struct iphdr *iph =3D (*pskb)->nh.iph;
++
++              if (iph->ttl <=3D 1) {
++                      struct rtable *rt;
++
++                      if (ip_route_output(&rt, iph->saddr, iph->daddr,
++                                          RT_TOS(iph->tos) | RTO_CONN,
++                                          0)) {
++                              return NF_DROP;
++                      }
++
++                      if ((*pskb)->dev =3D=3D rt->u.dst.dev) {
++                              /* Drop old route. */
++                              dst_release((*pskb)->dst);
++                              (*pskb)->dst =3D &rt->u.dst;
++
++                              /* this will traverse normal stack, and=20
++                               * thus call conntrack on the icmp
packet */
++                              icmp_send(*pskb, ICMP_TIME_EXCEEDED,=20
++                                        ICMP_EXC_TTL, 0);
++                      }
++
++                      return NF_DROP;
++              }
++
++              ip_decrease_ttl(iph);
++      }
++
++
++      if (route(*pskb, route_info->if_index)) {
++
++              ip_direct_send(*pskb);
++
++              return NF_STOLEN;
++      }
++
++      return NF_DROP;
++}
++
++
++static int ipt_route_checkentry(const char *tablename,
++                               const struct ipt_entry *e,
++                               void *targinfo,
++                               unsigned int targinfosize,
++                               unsigned int hook_mask)
++{
++      /* Only working on PRE_ROUTING */
++      if (hook_mask & ~(1 << NF_IP_PRE_ROUTING)) {
++              printk("ROUTE: bad hook\n");
++              return 0;
++      }
++
++      if (targinfosize !=3D IPT_ALIGN(sizeof(struct
ipt_route_target_info))) {
++              printk(KERN_WARNING "ROUTE: targinfosize %u !=3D %Zu\n",
++                     targinfosize,
++                     IPT_ALIGN(sizeof(struct ipt_route_target_info)));
++              return 0;
++      }
++
++      return 1;
++}
++
++
++static struct ipt_target ipt_route_reg
++=3D { { NULL, NULL }, "ROUTE", ipt_route_target, ipt_route_checkentry,
NULL,
++    THIS_MODULE };
++
++
++static int __init init(void)
++{
++      if (ipt_register_target(&ipt_route_reg))
++              return -EINVAL;
++
++      return 0;
++}
++
++
++static void __exit fini(void)
++{
++      ipt_unregister_target(&ipt_route_reg);
++}
++
++module_init(init);
++module_exit(fini);
++MODULE_LICENSE("GPL");
diff -Nru
netfilter.orig/userspace/patch-o-matic/pending/ROUTE.patch.config.in
netfilter/userspace/patch-o-matic/pending/ROUTE.patch.config.in
---
netfilter.orig/userspace/patch-o-matic/pending/ROUTE.patch.config.in       =
 Thu Jan  1 01:00:00 1970
+++ netfilter/userspace/patch-o-matic/pending/ROUTE.patch.config.in   =20
Tue Jun 11 12:43:07 2002
@@ -0,0 +1,2 @@
+  dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG
$CONFIG_IP_NF_IPTABLES
+  dep_tristate '  ROUTE target support' CONFIG_IP_NF_TARGET_ROUTE
$CONFIG_IP_NF_IPTABLES
diff -Nru
netfilter.orig/userspace/patch-o-matic/pending/ROUTE.patch.configure.help n=
etfilter/userspace/patch-o-matic/pending/ROUTE.patch.configure.help
---
netfilter.orig/userspace/patch-o-matic/pending/ROUTE.patch.configure.help  =
 Thu Jan  1 01:00:00 1970
+++
netfilter/userspace/patch-o-matic/pending/ROUTE.patch.configure.help       =
 Tue Jun 11 12:58:58 2002
@@ -0,0 +1,16 @@
+CONFIG_IP_NF_TARGET_LOG
+ROUTE target support
+CONFIG_IP_NF_TARGET_ROUTE
+  This option adds a `ROUTE' target, which allows you to directly route
+  a received packet through a specified interface, even and especially
+  if the packet IP address is one of the router itself. Those packets=20
+  are locally delivered and cannot be forwarded to another computer=20
+  using the standard routing mechanisms.
+
+  This target is particularly useful if you intend to use RSIP protocol
+  (RFC3102, RFC3103).
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
+
+=20
diff -Nru
netfilter.orig/userspace/patch-o-matic/pending/ROUTE.patch.help
netfilter/userspace/patch-o-matic/pending/ROUTE.patch.help
--- netfilter.orig/userspace/patch-o-matic/pending/ROUTE.patch.help   =20
Thu Jan  1 01:00:00 1970
+++ netfilter/userspace/patch-o-matic/pending/ROUTE.patch.help  Tue Jun
11 13:01:27 2002
@@ -0,0 +1,13 @@
+Author: C=E9dric de Launois <delaunois@info.ucl.ac.be>
+Status: In Development/Works for me
+ =20
+  This option adds a `ROUTE' target, which allows you to directly route
+  a received packet through a specified interface, even and especially
+  if the packet IP address is one of the router itself. Those packets=20
+  are locally delivered and cannot be forwarded to another computer=20
+  using the standard routing mechanisms.
+
+  This target is particularly useful if you intend to use RSIP protocol
+  (RFC3102, RFC3103).
+
+=20
diff -Nru
netfilter.orig/userspace/patch-o-matic/pending/ROUTE.patch.makefile
netfilter/userspace/patch-o-matic/pending/ROUTE.patch.makefile
--- netfilter.orig/userspace/patch-o-matic/pending/ROUTE.patch.makefile
Thu Jan  1 01:00:00 1970
+++ netfilter/userspace/patch-o-matic/pending/ROUTE.patch.makefile    =20
Tue Jun 11 13:03:27 2002
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_TARGET_REDIRECT) +=3D ipt_REDIRECT.o
+obj-$(CONFIG_IP_NF_TARGET_ROUTE) +=3D ipt_ROUTE.o
