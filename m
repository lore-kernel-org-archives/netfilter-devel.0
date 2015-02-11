From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC PATCH 1/2] netfilter: refactor xt_TEE code
Date: Wed, 11 Feb 2015 19:39:03 +0100
Message-ID: <20150211183902.5040.52479.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56981 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753057AbbBKSjQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 13:39:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Refactor xt_TEE code so it can be used outside of the xtables
context (nf_tables).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/net/netfilter/ipv4/nf_tee_ipv4.h |    8 +
 include/net/netfilter/ipv6/nf_tee_ipv6.h |    8 +
 include/net/netfilter/nf_tee.h           |   20 +++
 net/ipv4/netfilter/Kconfig               |    8 +
 net/ipv4/netfilter/Makefile              |    2=20
 net/ipv4/netfilter/nf_tee_ipv4.c         |  115 +++++++++++++++
 net/ipv6/netfilter/Kconfig               |    8 +
 net/ipv6/netfilter/Makefile              |    2=20
 net/ipv6/netfilter/nf_tee_ipv6.c         |   89 ++++++++++++
 net/netfilter/Kconfig                    |    8 +
 net/netfilter/Makefile                   |    2=20
 net/netfilter/nf_tee.c                   |  115 +++++++++++++++
 net/netfilter/xt_TEE.c                   |  232 ++--------------------=
--------
 13 files changed, 400 insertions(+), 217 deletions(-)
 create mode 100644 include/net/netfilter/ipv4/nf_tee_ipv4.h
 create mode 100644 include/net/netfilter/ipv6/nf_tee_ipv6.h
 create mode 100644 include/net/netfilter/nf_tee.h
 create mode 100644 net/ipv4/netfilter/nf_tee_ipv4.c
 create mode 100644 net/ipv6/netfilter/nf_tee_ipv6.c
 create mode 100644 net/netfilter/nf_tee.c

diff --git a/include/net/netfilter/ipv4/nf_tee_ipv4.h b/include/net/net=
filter/ipv4/nf_tee_ipv4.h
new file mode 100644
index 0000000..202ad75
--- /dev/null
+++ b/include/net/netfilter/ipv4/nf_tee_ipv4.h
@@ -0,0 +1,8 @@
+#ifndef _NF_TEE_IPV4_H_
+#define _NF_TEE_IPV4_H_
+
+#include <net/netfilter/nf_tee.h>
+
+unsigned int nf_tee_ipv4(struct sk_buff *skb, const struct nf_tee *tee=
);
+
+#endif /* _NF_TEE_IPV4_H_ */
diff --git a/include/net/netfilter/ipv6/nf_tee_ipv6.h b/include/net/net=
filter/ipv6/nf_tee_ipv6.h
new file mode 100644
index 0000000..fe4c5a1
--- /dev/null
+++ b/include/net/netfilter/ipv6/nf_tee_ipv6.h
@@ -0,0 +1,8 @@
+#ifndef _NF_TEE_IPV6_H_
+#define _NF_TEE_IPV6_H_
+
+#include <net/netfilter/nf_tee.h>
+
+unsigned int nf_tee_ipv6(struct sk_buff *skb, const struct nf_tee *tee=
);
+
+#endif /* _NF_TEE_IPV6_H_ */
diff --git a/include/net/netfilter/nf_tee.h b/include/net/netfilter/nf_=
tee.h
new file mode 100644
index 0000000..2bd6d56
--- /dev/null
+++ b/include/net/netfilter/nf_tee.h
@@ -0,0 +1,20 @@
+#ifndef _NF_TEE_H_
+#define _NF_TEE_H_
+
+#include <linux/netfilter.h>
+#include <linux/if.h>
+
+struct nf_tee {
+	union nf_inet_addr	gw;
+	char			oif_str[IFNAMSIZ];
+	int			oif;
+	unsigned int		hooknum;
+	struct notifier_block	notifier;
+};
+
+struct net *nf_tee_pick_net(struct sk_buff *skb);
+struct nf_tee *nf_tee_new(union nf_inet_addr gw, const char *oif_str);
+bool nf_tee_has_notifier(const struct nf_tee *tee);
+void nf_tee_destroy(struct nf_tee *tee);
+
+#endif
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 59f883d..d71dbdf 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -36,6 +36,14 @@ config NF_CONNTRACK_PROC_COMPAT
=20
 	  If unsure, say Y.
=20
+config NF_TEE_IPV4
+	tristate "Netfilter IPv4 packet cloning to alternate destination"
+	depends on !NF_CONNTRACK || NF_CONNTRACK
+	depends on NF_TEE
+	help
+	  This optiones enables the nf_tee_ipv4 engine, which can clone a
+	  packet and this clone be rerouted to another nexthop.
+
 config NF_LOG_ARP
 	tristate "ARP packet logging"
 	default m if NETFILTER_ADVANCED=3Dn
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 7fe6c70..6b492de 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -70,3 +70,5 @@ obj-$(CONFIG_IP_NF_ARP_MANGLE) +=3D arpt_mangle.o
=20
 # just filtering instance of ARP tables for now
 obj-$(CONFIG_IP_NF_ARPFILTER) +=3D arptable_filter.o
+
+obj-$(CONFIG_NF_TEE_IPV4) +=3D nf_tee_ipv4.o
diff --git a/net/ipv4/netfilter/nf_tee_ipv4.c b/net/ipv4/netfilter/nf_t=
ee_ipv4.c
new file mode 100644
index 0000000..5fe94b2
--- /dev/null
+++ b/net/ipv4/netfilter/nf_tee_ipv4.c
@@ -0,0 +1,115 @@
+/*
+ *	"TEE" target extension for Xtables
+ *	Copyright =C2=A9 Sebastian Cla=C3=9Fen, 2007
+ *	Jan Engelhardt, 2007-2010
+ *
+ *	based on ipt_ROUTE.c from C=C3=A9dric de Launois
+ *	<delaunois@info.ucl.be>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	version 2 or later, as published by the Free Software Foundation.
+ */
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/route.h>
+#include <linux/skbuff.h>
+#include <net/checksum.h>
+#include <net/icmp.h>
+#include <net/ip.h>
+#include <net/route.h>
+#include <net/netfilter/nf_tee.h>
+#include <net/netfilter/ipv4/nf_tee_ipv4.h>
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#	define WITH_CONNTRACK 1
+#	include <net/netfilter/nf_conntrack.h>
+#endif
+
+static DEFINE_PER_CPU(bool, tee_active);
+
+static bool nf_tee_ipv4_route(struct sk_buff *skb, const struct nf_tee=
 *tee)
+{
+	const struct iphdr *iph =3D ip_hdr(skb);
+	struct net *net =3D nf_tee_pick_net(skb);
+	struct rtable *rt;
+	struct flowi4 fl4;
+
+	memset(&fl4, 0, sizeof(fl4));
+	if (nf_tee_has_notifier(tee)) {
+		if (tee->oif =3D=3D -1)
+			return false;
+
+		fl4.flowi4_oif =3D tee->oif;
+	}
+	fl4.daddr =3D tee->gw.ip;
+	fl4.flowi4_tos =3D RT_TOS(iph->tos);
+	fl4.flowi4_scope =3D RT_SCOPE_UNIVERSE;
+	fl4.flowi4_flags =3D FLOWI_FLAG_KNOWN_NH;
+	rt =3D ip_route_output_key(net, &fl4);
+	if (IS_ERR(rt))
+		return false;
+
+	skb_dst_drop(skb);
+	skb_dst_set(skb, &rt->dst);
+	skb->dev      =3D rt->dst.dev;
+	skb->protocol =3D htons(ETH_P_IP);
+	return true;
+}
+
+unsigned int nf_tee_ipv4(struct sk_buff *skb, const struct nf_tee *tee=
)
+{
+	struct iphdr *iph;
+
+	if (__this_cpu_read(tee_active))
+		return XT_CONTINUE;
+	/*
+	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE f=
or
+	 * the original skb, which should continue on its way as if nothing h=
as
+	 * happened. The copy should be independently delivered to the TEE
+	 * --gateway.
+	 */
+	skb =3D pskb_copy(skb, GFP_ATOMIC);
+	if (skb =3D=3D NULL)
+		return XT_CONTINUE;
+
+#ifdef WITH_CONNTRACK
+	/* Avoid counting cloned packets towards the original connection. */
+	nf_conntrack_put(skb->nfct);
+	skb->nfct     =3D &nf_ct_untracked_get()->ct_general;
+	skb->nfctinfo =3D IP_CT_NEW;
+	nf_conntrack_get(skb->nfct);
+#endif
+	/*
+	 * If we are in PREROUTING/INPUT, the checksum must be recalculated
+	 * since the length could have changed as a result of defragmentation=
=2E
+	 *
+	 * We also decrease the TTL to mitigate potential TEE loops
+	 * between two hosts.
+	 *
+	 * Set %IP_DF so that the original source is notified of a potentiall=
y
+	 * decreased MTU on the clone route. IPv6 does this too.
+	 */
+	iph =3D ip_hdr(skb);
+	iph->frag_off |=3D htons(IP_DF);
+	if (tee->hooknum =3D=3D NF_INET_PRE_ROUTING ||
+	    tee->hooknum =3D=3D NF_INET_LOCAL_IN)
+		--iph->ttl;
+	ip_send_check(iph);
+
+	if (nf_tee_ipv4_route(skb, tee)) {
+		__this_cpu_write(tee_active, true);
+		ip_local_out(skb);
+		__this_cpu_write(tee_active, false);
+	} else {
+		kfree_skb(skb);
+	}
+	return XT_CONTINUE;
+}
+EXPORT_SYMBOL_GPL(nf_tee_ipv4);
+
+MODULE_AUTHOR("Sebastian Cla=C3=9Fen <sebastian.classen@freenet.ag>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
+MODULE_DESCRIPTION("nf_tee_ipv4: Reroute IPv4 packet copy");
+MODULE_LICENSE("GPL");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index a069822..fefd1bb 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -55,6 +55,14 @@ config NF_LOG_IPV6
 	default m if NETFILTER_ADVANCED=3Dn
 	select NF_LOG_COMMON
=20
+config NF_TEE_IPV6
+	tristate "Netfilter IPv6 packet cloning to alternate destination"
+	depends on !NF_CONNTRACK || NF_CONNTRACK
+	depends on NF_TEE
+	help
+	  This optiones enables the nf_tee_ipv6 engine, which can clone a
+	  packet and this clone be rerouted to another nexthop.
+
 config NF_NAT_IPV6
 	tristate "IPv6 NAT"
 	depends on NF_CONNTRACK_IPV6
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index c36e0a5..b3a2946 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -30,6 +30,8 @@ obj-$(CONFIG_NF_LOG_IPV6) +=3D nf_log_ipv6.o
 # reject
 obj-$(CONFIG_NF_REJECT_IPV6) +=3D nf_reject_ipv6.o
=20
+obj-$(CONFIG_NF_TEE_IPV6) +=3D nf_tee_ipv6.o
+
 # nf_tables
 obj-$(CONFIG_NF_TABLES_IPV6) +=3D nf_tables_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV6) +=3D nft_chain_route_ipv6.o
diff --git a/net/ipv6/netfilter/nf_tee_ipv6.c b/net/ipv6/netfilter/nf_t=
ee_ipv6.c
new file mode 100644
index 0000000..4b95cdd
--- /dev/null
+++ b/net/ipv6/netfilter/nf_tee_ipv6.c
@@ -0,0 +1,89 @@
+/*
+ *	"TEE" target extension for Xtables
+ *	Copyright =C2=A9 Sebastian Cla=C3=9Fen, 2007
+ *	Jan Engelhardt, 2007-2010
+ *
+ *	based on ipt_ROUTE.c from C=C3=A9dric de Launois
+ *	<delaunois@info.ucl.be>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	version 2 or later, as published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/skbuff.h>
+#include <net/ipv6.h>
+#include <net/ip6_route.h>
+#include <net/netfilter/nf_tee.h>
+#include <net/netfilter/ipv6/nf_tee_ipv6.h>
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#	define WITH_CONNTRACK 1
+#	include <net/netfilter/nf_conntrack.h>
+#endif
+
+static DEFINE_PER_CPU(bool, tee_active);
+
+static bool nf_tee_ipv6_route(struct sk_buff *skb, const struct nf_tee=
 *tee)
+{
+	const struct ipv6hdr *iph =3D ipv6_hdr(skb);
+	struct net *net =3D nf_tee_pick_net(skb);
+	struct dst_entry *dst;
+	struct flowi6 fl6;
+
+	memset(&fl6, 0, sizeof(fl6));
+	if (nf_tee_has_notifier(tee)) {
+		if (tee->oif =3D=3D -1)
+			return false;
+		fl6.flowi6_oif =3D tee->oif;
+	}
+	fl6.daddr =3D tee->gw.in6;
+	fl6.flowlabel =3D ((iph->flow_lbl[0] & 0xF) << 16) |
+			 (iph->flow_lbl[1] << 8) | iph->flow_lbl[2];
+	dst =3D ip6_route_output(net, NULL, &fl6);
+	if (dst->error) {
+		dst_release(dst);
+		return false;
+	}
+	skb_dst_drop(skb);
+	skb_dst_set(skb, dst);
+	skb->dev      =3D dst->dev;
+	skb->protocol =3D htons(ETH_P_IPV6);
+	return true;
+}
+
+unsigned int nf_tee_ipv6(struct sk_buff *skb, const struct nf_tee *tee=
)
+{
+	if (__this_cpu_read(tee_active))
+		return XT_CONTINUE;
+	skb =3D pskb_copy(skb, GFP_ATOMIC);
+	if (skb =3D=3D NULL)
+		return XT_CONTINUE;
+
+#ifdef WITH_CONNTRACK
+	nf_conntrack_put(skb->nfct);
+	skb->nfct     =3D &nf_ct_untracked_get()->ct_general;
+	skb->nfctinfo =3D IP_CT_NEW;
+	nf_conntrack_get(skb->nfct);
+#endif
+	if (tee->hooknum =3D=3D NF_INET_PRE_ROUTING ||
+	    tee->hooknum =3D=3D NF_INET_LOCAL_IN) {
+		struct ipv6hdr *iph =3D ipv6_hdr(skb);
+		--iph->hop_limit;
+	}
+	if (nf_tee_ipv6_route(skb, tee)) {
+		__this_cpu_write(tee_active, true);
+		ip6_local_out(skb);
+		__this_cpu_write(tee_active, false);
+	} else {
+		kfree_skb(skb);
+	}
+	return XT_CONTINUE;
+}
+EXPORT_SYMBOL_GPL(nf_tee_ipv6);
+
+MODULE_AUTHOR("Sebastian Cla=C3=9Fen <sebastian.classen@freenet.ag>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
+MODULE_DESCRIPTION("nf_tee_ipv6: Reroute IPv6 packet copy");
+MODULE_LICENSE("GPL");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index b02660f..f0a0712 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -562,6 +562,13 @@ config NFT_COMPAT
 	  x_tables match/target extensions over the nf_tables
 	  framework.
=20
+config NF_TEE
+	tristate "Netfilter nf_tee module"
+	help
+	  This module is the core nf_tee engine, which allows you
+	  to copy and redirect packets to another gateway.
+
+
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
 	default m if NETFILTER_ADVANCED=3Dn
@@ -863,6 +870,7 @@ config NETFILTER_XT_TARGET_REDIRECT
 config NETFILTER_XT_TARGET_TEE
 	tristate '"TEE" - packet cloning to alternate destination'
 	depends on NETFILTER_ADVANCED
+	depends on NF_TEE_IPV4 || NF_TEE_IPV6
 	depends on (IPV6 || IPV6=3Dn)
 	depends on !NF_CONNTRACK || NF_CONNTRACK
 	---help---
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 89f73a9..0cd2f03 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -47,6 +47,8 @@ obj-$(CONFIG_NF_CONNTRACK_TFTP) +=3D nf_conntrack_tft=
p.o
 nf_nat-y	:=3D nf_nat_core.o nf_nat_proto_unknown.o nf_nat_proto_common=
=2Eo \
 		   nf_nat_proto_udp.o nf_nat_proto_tcp.o nf_nat_helper.o
=20
+obj-$(CONFIG_NF_TEE) +=3D nf_tee.o
+
 # generic transport layer logging
 obj-$(CONFIG_NF_LOG_COMMON) +=3D nf_log_common.o
=20
diff --git a/net/netfilter/nf_tee.c b/net/netfilter/nf_tee.c
new file mode 100644
index 0000000..4560ecc
--- /dev/null
+++ b/net/netfilter/nf_tee.c
@@ -0,0 +1,115 @@
+/*
+ *	"TEE" target extension for Xtables
+ *	Copyright =C2=A9 Sebastian Cla=C3=9Fen, 2007
+ *	Jan Engelhardt, 2007-2010
+ *
+ *	based on ipt_ROUTE.c from C=C3=A9dric de Launois
+ *	<delaunois@info.ucl.be>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	version 2 or later, as published by the Free Software Foundation.
+ */
+
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/skbuff.h>
+#include <linux/notifier.h>
+#include <linux/netdevice.h>
+#include <net/net_namespace.h>
+#include <net/dst.h>
+#include <net/netfilter/nf_tee.h>
+
+struct net *nf_tee_pick_net(struct sk_buff *skb)
+{
+#ifdef CONFIG_NET_NS
+	const struct dst_entry *dst;
+
+	if (skb->dev !=3D NULL)
+		return dev_net(skb->dev);
+	dst =3D skb_dst(skb);
+	if (dst !=3D NULL && dst->dev !=3D NULL)
+		return dev_net(dst->dev);
+#endif
+	return &init_net;
+}
+EXPORT_SYMBOL_GPL(nf_tee_pick_net);
+
+static int
+nf_tee_netdev_event(struct notifier_block *this, unsigned long event,
+		    void *ptr)
+{
+	struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
+	struct nf_tee *tee;
+
+	tee =3D container_of(this, struct nf_tee, notifier);
+	switch (event) {
+	case NETDEV_REGISTER:
+		if (!strcmp(dev->name, tee->oif_str))
+			tee->oif =3D dev->ifindex;
+		break;
+	case NETDEV_UNREGISTER:
+		if (dev->ifindex =3D=3D tee->oif)
+			tee->oif =3D -1;
+		break;
+	case NETDEV_CHANGENAME:
+		if (!strcmp(dev->name, tee->oif_str))
+			tee->oif =3D dev->ifindex;
+		else if (dev->ifindex =3D=3D tee->oif)
+			tee->oif =3D -1;
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static const union nf_inet_addr tee_zero_address;
+
+struct nf_tee *nf_tee_new(union nf_inet_addr gw, const char *oif_str)
+{
+	struct nf_tee *tee;
+
+	/* 0.0.0.0 and :: not allowed */
+	if (memcmp(&gw, &tee_zero_address,
+		   sizeof(tee_zero_address)) =3D=3D 0)
+		return ERR_PTR(-EINVAL);
+
+	tee =3D kzalloc(sizeof(struct nf_tee), GFP_KERNEL);
+	if (tee =3D=3D NULL)
+		return ERR_PTR(-ENOMEM);
+
+	if (oif_str && oif_str[0]) {
+		if (oif_str[sizeof(tee->oif_str) - 1] !=3D '\0')
+			return ERR_PTR(-EINVAL);
+
+		memcpy(tee->oif_str, oif_str, sizeof(tee->oif_str));
+		tee->oif =3D -1;
+		tee->notifier.notifier_call =3D nf_tee_netdev_event;
+		register_netdevice_notifier(&tee->notifier);
+	}
+
+	tee->gw	=3D gw;
+	return tee;
+}
+EXPORT_SYMBOL_GPL(nf_tee_new);
+
+bool nf_tee_has_notifier(const struct nf_tee *tee)
+{
+	return (tee->notifier.notifier_call =3D=3D nf_tee_netdev_event);
+}
+EXPORT_SYMBOL_GPL(nf_tee_has_notifier);
+
+void nf_tee_destroy(struct nf_tee *tee)
+{
+	if (nf_tee_has_notifier(tee))
+		unregister_netdevice_notifier(&tee->notifier);
+
+	kfree(tee);
+}
+EXPORT_SYMBOL_GPL(nf_tee_destroy);
+
+MODULE_AUTHOR("Sebastian Cla=C3=9Fen <sebastian.classen@freenet.ag>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
+MODULE_DESCRIPTION("nf_tee: Reroute packet copy");
+MODULE_LICENSE("GPL");
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 292934d..98bde0f 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -10,247 +10,48 @@
  *	modify it under the terms of the GNU General Public License
  *	version 2 or later, as published by the Free Software Foundation.
  */
-#include <linux/ip.h>
 #include <linux/module.h>
-#include <linux/percpu.h>
-#include <linux/route.h>
 #include <linux/skbuff.h>
-#include <linux/notifier.h>
-#include <net/checksum.h>
-#include <net/icmp.h>
-#include <net/ip.h>
-#include <net/ipv6.h>
-#include <net/ip6_route.h>
-#include <net/route.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_TEE.h>
-
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-#	define WITH_CONNTRACK 1
-#	include <net/netfilter/nf_conntrack.h>
-#endif
-
-struct xt_tee_priv {
-	struct notifier_block	notifier;
-	struct xt_tee_tginfo	*tginfo;
-	int			oif;
-};
-
-static const union nf_inet_addr tee_zero_address;
-static DEFINE_PER_CPU(bool, tee_active);
-
-static struct net *pick_net(struct sk_buff *skb)
-{
-#ifdef CONFIG_NET_NS
-	const struct dst_entry *dst;
-
-	if (skb->dev !=3D NULL)
-		return dev_net(skb->dev);
-	dst =3D skb_dst(skb);
-	if (dst !=3D NULL && dst->dev !=3D NULL)
-		return dev_net(dst->dev);
-#endif
-	return &init_net;
-}
-
-static bool
-tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
-{
-	const struct iphdr *iph =3D ip_hdr(skb);
-	struct net *net =3D pick_net(skb);
-	struct rtable *rt;
-	struct flowi4 fl4;
-
-	memset(&fl4, 0, sizeof(fl4));
-	if (info->priv) {
-		if (info->priv->oif =3D=3D -1)
-			return false;
-		fl4.flowi4_oif =3D info->priv->oif;
-	}
-	fl4.daddr =3D info->gw.ip;
-	fl4.flowi4_tos =3D RT_TOS(iph->tos);
-	fl4.flowi4_scope =3D RT_SCOPE_UNIVERSE;
-	fl4.flowi4_flags =3D FLOWI_FLAG_KNOWN_NH;
-	rt =3D ip_route_output_key(net, &fl4);
-	if (IS_ERR(rt))
-		return false;
-
-	skb_dst_drop(skb);
-	skb_dst_set(skb, &rt->dst);
-	skb->dev      =3D rt->dst.dev;
-	skb->protocol =3D htons(ETH_P_IP);
-	return true;
-}
+#include <net/netfilter/nf_tee.h>
+#include <net/netfilter/ipv4/nf_tee_ipv4.h>
+#include <net/netfilter/ipv6/nf_tee_ipv6.h>
=20
 static unsigned int
 tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tee_tginfo *info =3D par->targinfo;
-	struct iphdr *iph;
+	struct nf_tee *tee =3D (struct nf_tee *)info->priv;
=20
-	if (__this_cpu_read(tee_active))
-		return XT_CONTINUE;
-	/*
-	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE f=
or
-	 * the original skb, which should continue on its way as if nothing h=
as
-	 * happened. The copy should be independently delivered to the TEE
-	 * --gateway.
-	 */
-	skb =3D pskb_copy(skb, GFP_ATOMIC);
-	if (skb =3D=3D NULL)
-		return XT_CONTINUE;
+	tee->hooknum =3D par->hooknum;
=20
-#ifdef WITH_CONNTRACK
-	/* Avoid counting cloned packets towards the original connection. */
-	nf_conntrack_put(skb->nfct);
-	skb->nfct     =3D &nf_ct_untracked_get()->ct_general;
-	skb->nfctinfo =3D IP_CT_NEW;
-	nf_conntrack_get(skb->nfct);
-#endif
-	/*
-	 * If we are in PREROUTING/INPUT, the checksum must be recalculated
-	 * since the length could have changed as a result of defragmentation=
=2E
-	 *
-	 * We also decrease the TTL to mitigate potential TEE loops
-	 * between two hosts.
-	 *
-	 * Set %IP_DF so that the original source is notified of a potentiall=
y
-	 * decreased MTU on the clone route. IPv6 does this too.
-	 */
-	iph =3D ip_hdr(skb);
-	iph->frag_off |=3D htons(IP_DF);
-	if (par->hooknum =3D=3D NF_INET_PRE_ROUTING ||
-	    par->hooknum =3D=3D NF_INET_LOCAL_IN)
-		--iph->ttl;
-	ip_send_check(iph);
-
-	if (tee_tg_route4(skb, info)) {
-		__this_cpu_write(tee_active, true);
-		ip_local_out(skb);
-		__this_cpu_write(tee_active, false);
-	} else {
-		kfree_skb(skb);
-	}
-	return XT_CONTINUE;
+	return nf_tee_ipv4(skb, tee);
 }
=20
 #if IS_ENABLED(CONFIG_IPV6)
-static bool
-tee_tg_route6(struct sk_buff *skb, const struct xt_tee_tginfo *info)
-{
-	const struct ipv6hdr *iph =3D ipv6_hdr(skb);
-	struct net *net =3D pick_net(skb);
-	struct dst_entry *dst;
-	struct flowi6 fl6;
-
-	memset(&fl6, 0, sizeof(fl6));
-	if (info->priv) {
-		if (info->priv->oif =3D=3D -1)
-			return false;
-		fl6.flowi6_oif =3D info->priv->oif;
-	}
-	fl6.daddr =3D info->gw.in6;
-	fl6.flowlabel =3D ((iph->flow_lbl[0] & 0xF) << 16) |
-			   (iph->flow_lbl[1] << 8) | iph->flow_lbl[2];
-	dst =3D ip6_route_output(net, NULL, &fl6);
-	if (dst->error) {
-		dst_release(dst);
-		return false;
-	}
-	skb_dst_drop(skb);
-	skb_dst_set(skb, dst);
-	skb->dev      =3D dst->dev;
-	skb->protocol =3D htons(ETH_P_IPV6);
-	return true;
-}
-
 static unsigned int
 tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tee_tginfo *info =3D par->targinfo;
+	struct nf_tee *tee =3D (struct nf_tee *)info->priv;
=20
-	if (__this_cpu_read(tee_active))
-		return XT_CONTINUE;
-	skb =3D pskb_copy(skb, GFP_ATOMIC);
-	if (skb =3D=3D NULL)
-		return XT_CONTINUE;
+	tee->hooknum =3D par->hooknum;
=20
-#ifdef WITH_CONNTRACK
-	nf_conntrack_put(skb->nfct);
-	skb->nfct     =3D &nf_ct_untracked_get()->ct_general;
-	skb->nfctinfo =3D IP_CT_NEW;
-	nf_conntrack_get(skb->nfct);
-#endif
-	if (par->hooknum =3D=3D NF_INET_PRE_ROUTING ||
-	    par->hooknum =3D=3D NF_INET_LOCAL_IN) {
-		struct ipv6hdr *iph =3D ipv6_hdr(skb);
-		--iph->hop_limit;
-	}
-	if (tee_tg_route6(skb, info)) {
-		__this_cpu_write(tee_active, true);
-		ip6_local_out(skb);
-		__this_cpu_write(tee_active, false);
-	} else {
-		kfree_skb(skb);
-	}
-	return XT_CONTINUE;
+	return nf_tee_ipv6(skb, tee);
 }
 #endif
=20
-static int tee_netdev_event(struct notifier_block *this, unsigned long=
 event,
-			    void *ptr)
-{
-	struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
-	struct xt_tee_priv *priv;
-
-	priv =3D container_of(this, struct xt_tee_priv, notifier);
-	switch (event) {
-	case NETDEV_REGISTER:
-		if (!strcmp(dev->name, priv->tginfo->oif))
-			priv->oif =3D dev->ifindex;
-		break;
-	case NETDEV_UNREGISTER:
-		if (dev->ifindex =3D=3D priv->oif)
-			priv->oif =3D -1;
-		break;
-	case NETDEV_CHANGENAME:
-		if (!strcmp(dev->name, priv->tginfo->oif))
-			priv->oif =3D dev->ifindex;
-		else if (dev->ifindex =3D=3D priv->oif)
-			priv->oif =3D -1;
-		break;
-	}
-
-	return NOTIFY_DONE;
-}
-
 static int tee_tg_check(const struct xt_tgchk_param *par)
 {
 	struct xt_tee_tginfo *info =3D par->targinfo;
-	struct xt_tee_priv *priv;
-
-	/* 0.0.0.0 and :: not allowed */
-	if (memcmp(&info->gw, &tee_zero_address,
-		   sizeof(tee_zero_address)) =3D=3D 0)
-		return -EINVAL;
-
-	if (info->oif[0]) {
-		if (info->oif[sizeof(info->oif)-1] !=3D '\0')
-			return -EINVAL;
-
-		priv =3D kzalloc(sizeof(*priv), GFP_KERNEL);
-		if (priv =3D=3D NULL)
-			return -ENOMEM;
-
-		priv->tginfo  =3D info;
-		priv->oif     =3D -1;
-		priv->notifier.notifier_call =3D tee_netdev_event;
-		info->priv    =3D priv;
+	struct nf_tee *tee;
=20
-		register_netdevice_notifier(&priv->notifier);
-	} else
-		info->priv =3D NULL;
+	tee =3D nf_tee_new(info->gw, info->oif);
+	if (IS_ERR(tee))
+		return PTR_ERR(tee);
=20
+	info->priv =3D (struct xt_tee_priv *)tee;
 	return 0;
 }
=20
@@ -258,10 +59,7 @@ static void tee_tg_destroy(const struct xt_tgdtor_p=
aram *par)
 {
 	struct xt_tee_tginfo *info =3D par->targinfo;
=20
-	if (info->priv) {
-		unregister_netdevice_notifier(&info->priv->notifier);
-		kfree(info->priv);
-	}
+	nf_tee_destroy((struct nf_tee *)info->priv);
 }
=20
 static struct xt_target tee_tg_reg[] __read_mostly =3D {

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
