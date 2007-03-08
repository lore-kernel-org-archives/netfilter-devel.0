From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH] chaostables
Date: Thu, 8 Mar 2007 07:35:05 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: kaber@trash.net
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932451AbXCHGgI@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello netfilter-devel,


I would like to submit chaostables (v0.5_svn23) for inclusion. Primary=20
use is to detect, spoof and slowdown various sorts of port scans.
Implementation details can be found at http://jengelh.hopto.org/p/chaos=
tables/

If you have any comments or suggestions, do not hestitate to=20
let me know.


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---

 include/linux/netfilter/x_tables.h    |    2=20
 include/linux/netfilter/xt_CHAOS.h    |   14 +
 include/linux/netfilter/xt_portscan.h |    8 +
 net/netfilter/Kconfig                 |   12 +
 net/netfilter/Makefile                |    3=20
 net/netfilter/x_tables.c              |   12 +
 net/netfilter/xt_CHAOS.c              |  184 +++++++++++++++++++++++
 net/netfilter/xt_DELUDE.c             |  259 +++++++++++++++++++++++++=
+++++++
 net/netfilter/xt_portscan.c           |  271 +++++++++++++++++++++++++=
+++++++++
 9 files changed, 765 insertions(+)

Index: linux-2.6.21-rc3/include/linux/netfilter/x_tables.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.21-rc3.orig/include/linux/netfilter/x_tables.h
+++ linux-2.6.21-rc3/include/linux/netfilter/x_tables.h
@@ -292,6 +292,8 @@ extern struct xt_table_info *xt_replace_
 					      int *error);
=20
 extern struct xt_match *xt_find_match(int af, const char *name, u8 rev=
ision);
+extern struct xt_match *xt_request_find_match(int af, const char *name=
,
+						u8 revision);
 extern struct xt_target *xt_find_target(int af, const char *name, u8 r=
evision);
 extern struct xt_target *xt_request_find_target(int af, const char *na=
me,=20
 						u8 revision);
Index: linux-2.6.21-rc3/include/linux/netfilter/xt_CHAOS.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.21-rc3/include/linux/netfilter/xt_CHAOS.h
@@ -0,0 +1,14 @@
+#ifndef _LINUX_XT_CHAOS_H
+#define _LINUX_XT_CHAOS_H 1
+
+enum xt_chaos_variant {
+	XTCHAOS_NORMAL,
+	XTCHAOS_TARPIT,
+	XTCHAOS_DELUDE,
+};
+
+struct xt_chaos_info {
+	enum xt_chaos_variant variant;
+};
+
+#endif /* _LINUX_XT_CHAOS_H */
Index: linux-2.6.21-rc3/include/linux/netfilter/xt_portscan.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.21-rc3/include/linux/netfilter/xt_portscan.h
@@ -0,0 +1,8 @@
+#ifndef _LINUX_XT_PORTSCAN_H
+#define _LINUX_XT_PORTSCAN_H 1
+
+struct xt_portscan_info {
+	unsigned int match_stealth, match_syn, match_cn, match_gr;
+};
+
+#endif /* _LINUX_XT_PORTSCAN_H */
Index: linux-2.6.21-rc3/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.21-rc3.orig/net/netfilter/Kconfig
+++ linux-2.6.21-rc3/net/netfilter/Kconfig
@@ -286,6 +286,14 @@ config NETFILTER_XTABLES
=20
 # alphabetically ordered list of targets
=20
+config NETFILTER_XT_TARGET_CHAOS
+	tristate '"CHAOS" target support'
+	depends on NETFILTER_XTABLES
+
+config NETFILTER_XT_TARGET_DELUDE
+	tristate '"DELUDE" target support'
+	depends on NETFILTER_XTABLES
+
 config NETFILTER_XT_TARGET_CLASSIFY
 	tristate '"CLASSIFY" target support'
 	depends on NETFILTER_XTABLES
@@ -562,6 +570,10 @@ config NETFILTER_XT_MATCH_POLICY
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_MATCH_PORTSCAN
+	tristate '"portscan" match support'
+	depends on NETFILTER_XTABLES && NF_CONNTRACK
+
 config NETFILTER_XT_MATCH_MULTIPORT
 	tristate "Multiple port match support"
 	depends on NETFILTER_XTABLES
Index: linux-2.6.21-rc3/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.21-rc3.orig/net/netfilter/Makefile
+++ linux-2.6.21-rc3/net/netfilter/Makefile
@@ -37,8 +37,10 @@ obj-$(CONFIG_NF_CONNTRACK_TFTP) +=3D nf_co
 obj-$(CONFIG_NETFILTER_XTABLES) +=3D x_tables.o xt_tcpudp.o
=20
 # targets
+obj-$(CONFIG_NETFILTER_XT_TARGET_CHAOS) +=3D xt_CHAOS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) +=3D xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNMARK) +=3D xt_CONNMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_DELUDE) +=3D xt_DELUDE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) +=3D xt_DSCP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) +=3D xt_MARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) +=3D xt_NFQUEUE.o
@@ -63,6 +65,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) +=3D=20
 obj-$(CONFIG_NETFILTER_XT_MATCH_MARK) +=3D xt_mark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MULTIPORT) +=3D xt_multiport.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) +=3D xt_policy.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_PORTSCAN) +=3D xt_portscan.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) +=3D xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) +=3D xt_quota.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) +=3D xt_realm.o
Index: linux-2.6.21-rc3/net/netfilter/x_tables.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.21-rc3.orig/net/netfilter/x_tables.c
+++ linux-2.6.21-rc3/net/netfilter/x_tables.c
@@ -206,6 +206,18 @@ struct xt_match *xt_find_match(int af, c
 }
 EXPORT_SYMBOL(xt_find_match);
=20
+struct xt_match *xt_request_find_match(int af, const char *name, u8 re=
vision)
+{
+	struct xt_match *match;
+
+	match =3D try_then_request_module(xt_find_match(af, name, revision),
+					"%st_%s", xt_prefix[af], name);
+	if(IS_ERR(match) || match =3D=3D NULL)
+		return NULL;
+	return match;
+}
+EXPORT_SYMBOL_GPL(xt_request_find_match);
+
 /* Find target, grabs ref.  Returns ERR_PTR() on error. */
 struct xt_target *xt_find_target(int af, const char *name, u8 revision=
)
 {
Index: linux-2.6.21-rc3/net/netfilter/xt_CHAOS.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.21-rc3/net/netfilter/xt_CHAOS.c
@@ -0,0 +1,184 @@
+/*
+	CHAOS target for netfilter
+
+	Copyright =C2=A9 Jan Engelhardt <jengelh [at] gmx de>, 2006 - 2007
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License version 2 as
+	published by the Free Software Foundation.
+*/
+#include <linux/icmp.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/stat.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+#include <linux/netfilter_ipv4/ipt_REJECT.h>
+#include <net/ip.h>
+#include <linux/netfilter/xt_CHAOS.h>
+#define PFX KBUILD_MODNAME ": "
+
+/* Module parameters */
+static unsigned int reject_percentage =3D ~0U * .01;
+static unsigned int delude_percentage =3D ~0U * .0101;
+module_param(reject_percentage, uint, S_IRUGO | S_IWUSR);
+module_param(delude_percentage, uint, S_IRUGO | S_IWUSR);
+
+/* References to other matches/targets */
+static struct xt_match *xm_tcp;
+static struct xt_target *xt_delude, *xt_reject, *xt_tarpit;
+
+static int have_delude, have_tarpit;
+
+/* Static data for other matches/targets */
+static const struct ipt_reject_info reject_params =3D {
+	.with =3D ICMP_HOST_UNREACH,
+};
+
+static const struct xt_tcp tcp_params =3D {
+	.spts =3D {0, ~0},
+	.dpts =3D {0, ~0},
+};
+
+/* CHAOS functions */
+static void xt_chaos_total(const struct xt_chaos_info *info,
+    struct sk_buff **pskb, const struct net_device *in,
+    const struct net_device *out, unsigned int hooknum)
+{
+	const int protoff =3D 4 * (*pskb)->nh.iph->ihl;
+	const int offset  =3D ntohs((*pskb)->nh.iph->frag_off) & IP_OFFSET;
+	const struct xt_target *destiny;
+	int hotdrop =3D 0, ret;
+
+	ret =3D xm_tcp->match(*pskb, in, out, xm_tcp, &tcp_params,
+	                    offset, protoff, &hotdrop);
+	if(!ret || hotdrop || (unsigned int)net_random() > delude_percentage)
+		return;
+
+	destiny =3D (info->variant =3D=3D XTCHAOS_TARPIT) ? xt_tarpit : xt_de=
lude;
+	destiny->target(pskb, in, out, hooknum, destiny, NULL);
+	return;
+}
+
+static unsigned int xt_chaos_target(struct sk_buff **pskb,
+    const struct net_device *in, const struct net_device *out,
+    unsigned int hooknum, const struct xt_target *target, const void *=
targinfo)
+{
+	/* Equivalent to:
+	 * -A chaos -m statistic --mode random --probability \
+	 *         $reject_percentage -j REJECT --reject-with host-unreach;
+	 * -A chaos -m statistic --mode random --probability \
+	 *         $delude_percentage -j DELUDE;
+	 * -A chaos -j DROP;
+	 */
+	const struct xt_chaos_info *info =3D targinfo;
+
+	if((unsigned int)net_random() <=3D reject_percentage)
+		return xt_reject->target(pskb, in, out, hooknum, target,
+		       &reject_params);
+
+	/* TARPIT/DELUDE may not be called from the OUTPUT chain */
+	if((*pskb)->nh.iph->protocol =3D=3D IPPROTO_TCP &&
+	  info->variant !=3D XTCHAOS_NORMAL && hooknum !=3D NF_IP_LOCAL_OUT)
+		xt_chaos_total(info, pskb, in, out, hooknum);
+
+	return NF_DROP;
+}
+
+static int xt_chaos_checkentry(const char *tablename, const void *entr=
y,
+    const struct xt_target *target, void *targinfo, unsigned int hook_=
mask)
+{
+	const struct xt_chaos_info *info =3D targinfo;
+	if(info->variant =3D=3D XTCHAOS_DELUDE && !have_delude) {
+		printk(KERN_WARNING PFX "Error: Cannot use --delude when "
+		       "DELUDE module not available\n");
+		return 0;
+	}
+	if(info->variant =3D=3D XTCHAOS_TARPIT && !have_tarpit) {
+		printk(KERN_WARNING PFX "Error: Cannot use --tarpit when "
+		       "TARPIT module not available\n");
+		return 0;
+	}
+	return 1;
+}
+
+static struct xt_target xt_chaos_info =3D {
+	.name       =3D "CHAOS",
+	.target     =3D xt_chaos_target,
+	.checkentry =3D xt_chaos_checkentry,
+	.table      =3D "filter",
+	.targetsize =3D sizeof(struct xt_chaos_info),
+	.hooks      =3D (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD) |
+	              (1 << NF_IP_LOCAL_OUT),
+	.family     =3D AF_INET,
+	.me         =3D THIS_MODULE,
+};
+
+static int __init xt_chaos_init(void)
+{
+	int ret =3D -EINVAL;
+
+	xm_tcp =3D xt_request_find_match(AF_INET, "tcp", 0);
+	if(xm_tcp =3D=3D NULL) {
+		printk(KERN_WARNING PFX "Error: Could not find or load "
+		       "\"tcp\" match\n");
+		return -EINVAL;
+	}
+
+	xt_reject =3D xt_request_find_target(AF_INET, "REJECT", 0);
+	if(xt_reject =3D=3D NULL) {
+		printk(KERN_WARNING PFX "Error: Could not find or load "
+		       "\"REJECT\" target\n");
+		goto out2;
+	}
+
+	xt_tarpit   =3D xt_request_find_target(AF_INET, "TARPIT", 0);
+	have_tarpit =3D xt_tarpit !=3D NULL;
+	if(!have_tarpit)
+		printk(KERN_WARNING PFX "Warning: Could not find or load "
+		       "\"TARPIT\" target\n");
+
+	xt_delude   =3D xt_request_find_target(AF_INET, "DELUDE", 0);
+	have_delude =3D xt_delude !=3D NULL;
+	if(!have_delude)
+		printk(KERN_WARNING PFX "Warning: Could not find or load "
+		       "\"DELUDE\" target\n");
+
+	if((ret =3D xt_register_target(&xt_chaos_info)) !=3D 0) {
+		printk(KERN_WARNING PFX "xt_register_target returned "
+		       "error %d\n", ret);
+		goto out3;
+	}
+
+	return 0;
+
+ out3:
+ 	if(have_delude)
+ 		module_put(xt_delude->me);
+	if(have_tarpit)
+		module_put(xt_tarpit->me);
+	module_put(xt_reject->me);
+ out2:
+	module_put(xm_tcp->me);
+	return ret;
+}
+
+static void __exit xt_chaos_exit(void)
+{
+	xt_unregister_target(&xt_chaos_info);
+	module_put(xm_tcp->me);
+	module_put(xt_reject->me);
+	if(have_delude)
+		module_put(xt_delude->me);
+	if(have_tarpit)
+		module_put(xt_tarpit->me);
+	return;
+}
+
+module_init(xt_chaos_init);
+module_exit(xt_chaos_exit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@gmx.de>");
+MODULE_DESCRIPTION("netfilter CHAOS target");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_CHAOS");
Index: linux-2.6.21-rc3/net/netfilter/xt_DELUDE.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.21-rc3/net/netfilter/xt_DELUDE.c
@@ -0,0 +1,259 @@
+/*
+	DELUDE target
+	Copyright =C2=A9 Jan Engelhardt <jengelh [at] gmx de>, 2007
+
+	Based upon linux-2.6.18.5/net/ipv4/netfilter/ipt_REJECT.c:
+	(C) 1999-2001 Paul `Rusty' Russell
+	(C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License version 2 as
+	published by the Free Software Foundation.
+*/
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <linux/icmp.h>
+#include <net/icmp.h>
+#include <net/ip.h>
+#include <net/tcp.h>
+#include <net/route.h>
+#include <net/dst.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#ifdef CONFIG_BRIDGE_NETFILTER
+#	include <linux/netfilter_bridge.h>
+#endif
+#define PFX KBUILD_MODNAME ": "
+
+static inline struct rtable *route_reverse(struct sk_buff *skb,
+					   struct tcphdr *tcph, int hook)
+{
+	struct iphdr *iph =3D skb->nh.iph;
+	struct dst_entry *odst;
+	struct flowi fl =3D {};
+	struct rtable *rt;
+
+	/* We don't require ip forwarding to be enabled to be able to
+	 * send a RST reply for bridged traffic. */
+	if (hook !=3D NF_IP_FORWARD
+#ifdef CONFIG_BRIDGE_NETFILTER
+	    || (skb->nf_bridge && skb->nf_bridge->mask & BRNF_BRIDGED)
+#endif
+	   ) {
+		fl.nl_u.ip4_u.daddr =3D iph->saddr;
+		if (hook =3D=3D NF_IP_LOCAL_IN)
+			fl.nl_u.ip4_u.saddr =3D iph->daddr;
+		fl.nl_u.ip4_u.tos =3D RT_TOS(iph->tos);
+
+		if (ip_route_output_key(&rt, &fl) !=3D 0)
+			return NULL;
+	} else {
+		/* non-local src, find valid iif to satisfy
+		 * rp-filter when calling ip_route_input. */
+		fl.nl_u.ip4_u.daddr =3D iph->daddr;
+		if (ip_route_output_key(&rt, &fl) !=3D 0)
+			return NULL;
+
+		odst =3D skb->dst;
+		if (ip_route_input(skb, iph->saddr, iph->daddr,
+		                   RT_TOS(iph->tos), rt->u.dst.dev) !=3D 0) {
+			dst_release(&rt->u.dst);
+			return NULL;
+		}
+		dst_release(&rt->u.dst);
+		rt =3D (struct rtable *)skb->dst;
+		skb->dst =3D odst;
+
+		fl.nl_u.ip4_u.daddr =3D iph->saddr;
+		fl.nl_u.ip4_u.saddr =3D iph->daddr;
+		fl.nl_u.ip4_u.tos =3D RT_TOS(iph->tos);
+	}
+
+	if (rt->u.dst.error) {
+		dst_release(&rt->u.dst);
+		return NULL;
+	}
+
+	fl.proto =3D IPPROTO_TCP;
+	fl.fl_ip_sport =3D tcph->dest;
+	fl.fl_ip_dport =3D tcph->source;
+
+	xfrm_lookup((struct dst_entry **)&rt, &fl, NULL, 0);
+
+	return rt;
+}
+
+static void send_reset(struct sk_buff *oldskb, int hook)
+{
+	struct sk_buff *nskb;
+	struct iphdr *iph =3D oldskb->nh.iph;
+	struct tcphdr _otcph, *oth, *tcph;
+	struct rtable *rt;
+	u_int16_t tmp_port;
+	u_int32_t tmp_addr;
+	int hh_len;
+
+	/* IP header checks: fragment. */
+	if (oldskb->nh.iph->frag_off & htons(IP_OFFSET))
+		return;
+
+	oth =3D skb_header_pointer(oldskb, oldskb->nh.iph->ihl * 4,
+				 sizeof(_otcph), &_otcph);
+	if (oth =3D=3D NULL)
+ 		return;
+
+	/* DELUDE only answers SYN. */
+	if(!oth->syn || oth->ack || oth->fin || oth->rst)
+		return;
+
+	/* Check checksum */
+	if (nf_ip_checksum(oldskb, hook, iph->ihl * 4, IPPROTO_TCP))
+		return;
+
+	if ((rt =3D route_reverse(oldskb, oth, hook)) =3D=3D NULL)
+		return;
+
+	hh_len =3D LL_RESERVED_SPACE(rt->u.dst.dev);
+
+	/* We need a linear, writeable skb.  We also need to expand
+	   headroom in case hh_len of incoming interface < hh_len of
+	   outgoing interface */
+	nskb =3D skb_copy_expand(oldskb, hh_len, skb_tailroom(oldskb),
+			       GFP_ATOMIC);
+	if (!nskb) {
+		dst_release(&rt->u.dst);
+		return;
+	}
+
+	dst_release(nskb->dst);
+	nskb->dst =3D &rt->u.dst;
+
+	/* This packet will not be the same as the other: clear nf fields */
+	nf_reset(nskb);
+	nskb->mark =3D 0;
+	skb_init_secmark(nskb);
+
+	skb_shinfo(nskb)->gso_size =3D 0;
+	skb_shinfo(nskb)->gso_segs =3D 0;
+	skb_shinfo(nskb)->gso_type =3D 0;
+
+	tcph =3D (struct tcphdr *)((u_int32_t*)nskb->nh.iph + nskb->nh.iph->i=
hl);
+
+	/* Swap source and dest */
+	tmp_addr =3D nskb->nh.iph->saddr;
+	nskb->nh.iph->saddr =3D nskb->nh.iph->daddr;
+	nskb->nh.iph->daddr =3D tmp_addr;
+	tmp_port =3D tcph->source;
+	tcph->source =3D tcph->dest;
+	tcph->dest =3D tmp_port;
+
+	/* Truncate to length (no data) */
+	tcph->doff =3D sizeof(struct tcphdr)/4;
+	skb_trim(nskb, nskb->nh.iph->ihl*4 + sizeof(struct tcphdr));
+	nskb->nh.iph->tot_len =3D htons(nskb->len);
+
+	tcph->seq =3D oth->ack_seq;
+	tcph->ack_seq =3D 0;
+
+	/* Reset flags */
+	((u_int8_t *)tcph)[13] =3D 0;
+	tcph->syn =3D tcph->ack =3D 1;
+
+	tcph->window =3D 0;
+	tcph->urg_ptr =3D 0;
+
+	/* Adjust TCP checksum */
+	tcph->check =3D 0;
+	tcph->check =3D tcp_v4_check(sizeof(struct tcphdr),
+				   nskb->nh.iph->saddr,
+				   nskb->nh.iph->daddr,
+				   csum_partial((char *)tcph,
+						sizeof(struct tcphdr), 0));
+
+	/* Adjust IP TTL, DF */
+	nskb->nh.iph->ttl =3D dst_metric(nskb->dst, RTAX_HOPLIMIT);
+	/* Set DF, id =3D 0 */
+	nskb->nh.iph->frag_off =3D htons(IP_DF);
+	nskb->nh.iph->id =3D 0;
+
+	/* Adjust IP checksum */
+	nskb->nh.iph->check =3D 0;
+	nskb->nh.iph->check =3D ip_fast_csum((unsigned char *)nskb->nh.iph,
+					   nskb->nh.iph->ihl);
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
+	return;
+}
+
+static unsigned int xt_delude_target(struct sk_buff **pskb,
+    const struct net_device *in, const struct net_device *out,
+    unsigned int hooknum, const struct xt_target *target, const void *=
targinfo
+#ifdef HAVE_TARGUSERINFO
+    ,
+    void *userinfo
+#endif
+    )
+{
+	/* WARNING: This code causes reentry within iptables.
+	   This means that the iptables jump stack is now crap.  We
+	   must return an absolute verdict. --RR */
+	send_reset(*pskb, hooknum);
+	return NF_DROP;
+}
+
+static int xt_delude_check(const char *tablename, const void *e_void,
+    const struct xt_target *target, void *targinfo,
+#ifdef HAVE_TARGINFOSIZE
+    unsigned int targinfosize,
+#endif
+    unsigned int hook_mask)
+{
+	if(hook_mask & ~((1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD))) {
+		printk(KERN_WARNING PFX "DELUDE may not be used in chains "
+		       "other than INPUT and FORWARD\n");
+		return 0;
+	}
+	return 1;
+}
+
+static struct xt_target xt_delude_info =3D {
+	.name       =3D "DELUDE",
+	.target     =3D xt_delude_target,
+	.checkentry =3D xt_delude_check,
+	.table      =3D "filter",
+	.hooks      =3D (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD) |
+	              (1 << NF_IP_LOCAL_OUT),
+	.proto      =3D IPPROTO_TCP,
+	.family     =3D AF_INET,
+	.me         =3D THIS_MODULE,
+};
+
+static int __init xt_delude_init(void)
+{
+	return xt_register_target(&xt_delude_info);
+}
+
+static void __exit xt_delude_exit(void)
+{
+	xt_unregister_target(&xt_delude_info);
+}
+
+module_init(xt_delude_init);
+module_exit(xt_delude_exit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@gmx.de>");
+MODULE_DESCRIPTION("netfilter DELUDE target");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_DELUDE");
Index: linux-2.6.21-rc3/net/netfilter/xt_portscan.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.21-rc3/net/netfilter/xt_portscan.c
@@ -0,0 +1,271 @@
+/*
+	portscan match for netfilter
+
+	Written by Jan Engelhardt, 2006 - 2007
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License version 2 as
+	published by the Free Software Foundation.
+*/
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/skbuff.h>
+#include <linux/stat.h>
+#include <linux/tcp.h>
+#include <linux/types.h>
+#include <linux/version.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+#include <linux/netfilter/xt_portscan.h>
+#include <net/netfilter/nf_nat_rule.h>
+#define PFX KBUILD_MODNAME ": "
+
+enum {
+	TCP_FLAGS_ALL3 =3D TCP_FLAG_FIN | TCP_FLAG_RST | TCP_FLAG_SYN,
+	TCP_FLAGS_ALL4 =3D TCP_FLAGS_ALL3 | TCP_FLAG_ACK,
+	TCP_FLAGS_ALL6 =3D TCP_FLAGS_ALL4 | TCP_FLAG_PSH | TCP_FLAG_URG,
+};
+
+/* Module parameters */
+static unsigned int
+	connmark_mask =3D ~0,
+	packet_mask   =3D ~0,
+	mark_seen     =3D 0x9,
+	mark_synrcv   =3D 0x1,
+	mark_closed   =3D 0x2,
+	mark_synscan  =3D 0x3,
+	mark_estab1   =3D 0x4,
+	mark_estab2   =3D 0x5,
+	mark_cnscan   =3D 0x6,
+	mark_grscan   =3D 0x7,
+	mark_valid    =3D 0x8;
+
+module_param(connmark_mask, uint, S_IRUGO | S_IWUSR);
+module_param(packet_mask,   uint, S_IRUGO | S_IWUSR);
+module_param(mark_seen,     uint, S_IRUGO | S_IWUSR);
+module_param(mark_synrcv,   uint, S_IRUGO | S_IWUSR);
+module_param(mark_closed,   uint, S_IRUGO | S_IWUSR);
+module_param(mark_synscan,  uint, S_IRUGO | S_IWUSR);
+module_param(mark_estab1,   uint, S_IRUGO | S_IWUSR);
+module_param(mark_estab2,   uint, S_IRUGO | S_IWUSR);
+module_param(mark_cnscan,   uint, S_IRUGO | S_IWUSR);
+module_param(mark_grscan,   uint, S_IRUGO | S_IWUSR);
+module_param(mark_valid,    uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(connmark_mask, "only set specified bits in connection=
 mark");
+MODULE_PARM_DESC(packet_mask,   "only set specified bits in packet mar=
k");
+MODULE_PARM_DESC(mark_seen,     "nfmark value for packet-seen state");
+MODULE_PARM_DESC(mark_synrcv,   "connmark value for SYN Received state=
");
+MODULE_PARM_DESC(mark_closed,   "connmark value for closed state");
+MODULE_PARM_DESC(mark_synscan,  "connmark value for SYN Scan state");
+MODULE_PARM_DESC(mark_estab1,   "connmark value for Established-1 stat=
e");
+MODULE_PARM_DESC(mark_estab2,   "connmark value for Established-2 stat=
e");
+MODULE_PARM_DESC(mark_cnscan,   "connmark value for Connect Scan state=
");
+MODULE_PARM_DESC(mark_grscan,   "connmark value for Grab Scan state");
+MODULE_PARM_DESC(mark_valid,    "connmark value for Valid state");
+
+/* TCP flag functions */
+static inline int tflg_ack4(const struct tcphdr *th)
+{
+	return (tcp_flag_word(th) & TCP_FLAGS_ALL4) =3D=3D TCP_FLAG_ACK;
+}
+
+static inline int tflg_ack6(const struct tcphdr *th)
+{
+	return (tcp_flag_word(th) & TCP_FLAGS_ALL6) =3D=3D TCP_FLAG_ACK;
+}
+
+static inline int tflg_fin(const struct tcphdr *th)
+{
+	return (tcp_flag_word(th) & TCP_FLAGS_ALL3) =3D=3D TCP_FLAG_FIN;
+}
+
+static inline int tflg_rst(const struct tcphdr *th)
+{
+	return (tcp_flag_word(th) & TCP_FLAGS_ALL3) =3D=3D TCP_FLAG_RST;
+}
+
+static inline int tflg_rstack(const struct tcphdr *th)
+{
+	return (tcp_flag_word(th) & TCP_FLAGS_ALL4) =3D=3D
+	       (TCP_FLAG_ACK | TCP_FLAG_RST);
+}
+
+static inline int tflg_syn(const struct tcphdr *th)
+{
+	return (tcp_flag_word(th) & TCP_FLAGS_ALL4) =3D=3D TCP_FLAG_SYN;
+}
+
+static inline int tflg_synack(const struct tcphdr *th)
+{
+	return (tcp_flag_word(th) & TCP_FLAGS_ALL4) =3D=3D
+	       (TCP_FLAG_SYN | TCP_FLAG_ACK);
+}
+
+/* portscan functions */
+static inline int xt_portscan_stealth(const struct tcphdr *th)
+{
+	/*
+	 * "Connection refused" replies to our own probes must not be matched=
=2E
+	 */
+	if(tflg_rstack(th))
+		return 0;
+
+	if(tflg_rst(th) && printk_ratelimit()) {
+		printk(KERN_WARNING PFX "Warning: Pure RST received\n");
+		return 0;
+	}
+
+	/*
+	 * -p tcp ! --syn -m conntrack --ctstate INVALID: Looking for non-sta=
rt
+	 * packets that are not associated with any connection -- this will
+	 * match most scan types (NULL, XMAS, FIN) and ridiculous flag
+	 * combinations (SYN-RST, SYN-FIN, SYN-FIN-RST, FIN-RST, etc.).
+	 */
+	return !tflg_syn(th);
+}
+
+static inline int xt_portscan_full(int mark, enum ip_conntrack_info ct=
state,
+    int loopback, const struct tcphdr *tcph, int payload_len)
+{
+	if(mark =3D=3D mark_estab2) {
+		/*
+		 * -m connmark --mark $ESTAB2
+		 */
+		if(tflg_ack4(tcph) && payload_len =3D=3D 0)
+			return mark; /* keep mark */
+		else if(tflg_rst(tcph) || tflg_fin(tcph))
+			return mark_grscan;
+		else
+			return mark_valid;
+	} else if(mark =3D=3D mark_estab1) {
+		/*
+		 * -m connmark --mark $ESTAB1
+		 */
+		if(tflg_rst(tcph) || tflg_fin(tcph))
+			return mark_cnscan;
+		else if(!loopback && tflg_ack4(tcph) && payload_len =3D=3D 0)
+			return mark_estab2;
+		else
+			return mark_valid;
+	} else if(mark =3D=3D mark_synrcv) {
+		/*
+		 * -m connmark --mark $SYN
+		 */
+		if(loopback && tflg_synack(tcph))
+			return mark; /* keep mark */
+		else if(loopback && tflg_rstack(tcph))
+			return mark_closed;
+		else if(tflg_ack6(tcph))
+			return mark_estab1;
+		else
+			return mark_synscan;
+	} else if(ctstate =3D=3D IP_CT_NEW && tflg_syn(tcph)) {
+		/*
+		 * -p tcp --syn --ctstate NEW
+		 */
+		return mark_synrcv;
+	}
+	return mark;
+}
+
+static int xt_portscan_match(const struct sk_buff *skb,
+    const struct net_device *in, const struct net_device *out,
+    const struct xt_match *match, const void *matchinfo, int offset,
+    unsigned int protoff, int *hotdrop)
+{
+	const struct xt_portscan_info *info =3D matchinfo;
+	enum ip_conntrack_info ctstate;
+	struct ip_conntrack *ctdata;
+	const struct tcphdr *tcph;
+	struct tcphdr tcph_buf;
+
+	tcph =3D skb_header_pointer(skb, protoff, sizeof(tcph_buf), &tcph_buf=
);
+	if(tcph =3D=3D NULL)
+		return 0;
+
+	/* Check for invalid packets: -m conntrack --ctstate INVALID */
+	if((ctdata =3D ip_conntrack_get(skb, &ctstate)) =3D=3D NULL) {
+		if(info->match_stealth)
+			return xt_portscan_stealth(tcph);
+		/*
+		 * If @ctdata is NULL, we cannot match the other scan
+		 * types, return.
+		 */
+		return 0;
+	}
+
+	/*
+	 * If -m portscan was previously applied to this packet, the rules we
+	 * simulate must not be run through again. And for speedup, do not ca=
ll
+	 * it either when the connection is already VALID.
+	 */
+	if((ctdata->mark & connmark_mask) =3D=3D mark_valid ||
+	  (skb->mark & packet_mask) !=3D mark_seen)
+	{
+		unsigned int n;
+		n =3D xt_portscan_full(ctdata->mark & connmark_mask, ctstate,
+		    in =3D=3D &loopback_dev, tcph,
+		    skb->len - protoff - 4 * tcph->doff);
+
+		ctdata->mark =3D (ctdata->mark & ~connmark_mask) | n;
+		((struct sk_buff *)skb)->mark =3D
+			(skb->mark & ~packet_mask) | mark_seen;
+	}
+
+	return (info->match_syn && ctdata->mark =3D=3D mark_synscan) ||
+	       (info->match_cn && ctdata->mark =3D=3D mark_cnscan) ||
+	       (info->match_gr && ctdata->mark =3D=3D mark_grscan);
+}
+
+static int xt_portscan_checkentry(const char *tablename, const void *e=
ntry,
+    const struct xt_match *match, void *matchinfo,
+#ifdef HAVE_MATCHINFOSIZE
+    unsigned int matchinfosize,
+#endif
+    unsigned int hook_mask)
+{
+	const struct xt_portscan_info *info =3D matchinfo;
+#ifdef HAVE_MATCHINFOSIZE
+	if(matchinfosize !=3D XT_ALIGN(sizeof(struct xt_portscan_info))) {
+		printk(KERN_WARNING PFX "matchinfosize %u !=3D %Zu\n",
+		       matchinfosize,
+		       XT_ALIGN(sizeof(struct xt_portscan_info)));
+		return 0;
+	}
+#endif
+	if((info->match_stealth & ~1) || (info->match_syn & ~1) ||
+	  (info->match_cn & ~1) || (info->match_gr & ~1)) {
+		printk(KERN_WARNING PFX "Invalid flags\n");
+		return 0;
+	}
+	return 1;
+}
+
+static struct xt_match xt_portscan =3D {
+	.name       =3D "portscan",
+	.match      =3D xt_portscan_match,
+	.checkentry =3D xt_portscan_checkentry,
+	.matchsize  =3D sizeof(struct xt_portscan_info),
+	.proto      =3D IPPROTO_TCP,
+	.family     =3D AF_INET,
+	.me         =3D THIS_MODULE,
+};
+
+static int __init xt_portscan_init(void)
+{
+	return xt_register_match(&xt_portscan);
+}
+
+static void __exit xt_portscan_exit(void)
+{
+	xt_unregister_match(&xt_portscan);
+	return;
+}
+
+module_init(xt_portscan_init);
+module_exit(xt_portscan_exit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@gmx.de>");
+MODULE_DESCRIPTION("netfilter portscan match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_portscan");
#<EOF>
