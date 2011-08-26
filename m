From: Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC 1/3] netfilter: add reverse path filter match
Date: Fri, 26 Aug 2011 11:21:03 +0200
Message-ID: <1314350465-19598-2-git-send-email-fw@strlen.de>
References: <1314350465-19598-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33899 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab1HZJKk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:10:40 -0400
In-Reply-To: <1314350465-19598-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

More flexible replacement for the reverse path filter
built into the ipv4 network stack; also supports ipv6.

Unlike the current builtin ipv4 rpfilter, packets subject to ipsec
transformation are not automatically excluded; if you want this
combine with policy match.

---
 include/linux/netfilter/xt_rpfilter.h |   21 ++++
 net/netfilter/Kconfig                 |   10 ++
 net/netfilter/Makefile                |    1 +
 net/netfilter/xt_rpfilter.c           |  175 +++++++++++++++++++++++++++++++++
 4 files changed, 207 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_rpfilter.h
 create mode 100644 net/netfilter/xt_rpfilter.c

diff --git a/include/linux/netfilter/xt_rpfilter.h b/include/linux/netfilter/xt_rpfilter.h
new file mode 100644
index 0000000..8d2d3f8
--- /dev/null
+++ b/include/linux/netfilter/xt_rpfilter.h
@@ -0,0 +1,21 @@
+#ifndef _XT_RPATH_H
+#define _XT_RPATH_H
+
+#include <linux/types.h>
+
+enum {
+	XT_RPFILTER_LOOSE = 1 << 0,
+	XT_RPFILTER_VALID_MARK = 1 << 1,
+	XT_RPFILTER_ACCEPT_LOCAL = 1 << 2,
+#ifdef __KERNEL__
+	XT_RPFILTER_OPTION_MASK = XT_RPFILTER_LOOSE |
+				  XT_RPFILTER_VALID_MARK |
+				  XT_RPFILTER_ACCEPT_LOCAL,
+#endif
+};
+
+struct xt_rpfilter_info {
+	__u8 flags;
+};
+
+#endif
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 32bff6d..2e746e5 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -881,6 +881,16 @@ config NETFILTER_XT_MATCH_MULTIPORT
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_RPFILTER
+	tristate '"rpfilter" reverse path filter match support'
+	depends on NETFILTER_ADVANCED
+	---help---
+	  This option allows you to match packets whose replies would
+	  go out via the interface the packet came in.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+	  The module will be called xt_rpfilter.
+
 config NETFILTER_XT_MATCH_OSF
 	tristate '"osf" Passive OS fingerprint match'
 	depends on NETFILTER_ADVANCED && NETFILTER_NETLINK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 1a02853..c69d9fb 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -90,6 +90,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) += xt_length.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) += xt_limit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) += xt_mac.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MULTIPORT) += xt_multiport.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_RPFILTER) += xt_rpfilter.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_OSF) += xt_osf.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_OWNER) += xt_owner.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
diff --git a/net/netfilter/xt_rpfilter.c b/net/netfilter/xt_rpfilter.c
new file mode 100644
index 0000000..edb6e8e
--- /dev/null
+++ b/net/netfilter/xt_rpfilter.c
@@ -0,0 +1,175 @@
+/*
+ *  Copyright (c) 2011 Florian Westphal <fw@strlen.de>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/ip.h>
+#include <net/route.h>
+
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+#include <net/ipv6.h>
+#include <net/ip6_route.h>
+#include <net/ip6_fib.h>
+#endif
+
+#include <linux/netfilter/xt_rpfilter.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
+MODULE_DESCRIPTION("Xtables: reverse path filter match");
+MODULE_ALIAS("ipt_rpfilter");
+MODULE_ALIAS("ip6t_rpfilter");
+
+static bool rpfilter_lookup(struct net *net, u8 nfproto, struct dst_entry **dst,
+			 struct flowi *flow)
+{
+	const struct nf_afinfo *afinfo;
+	int route_err;
+	bool strict = nfproto == NFPROTO_IPV6;
+
+	rcu_read_lock();
+
+	afinfo = nf_get_afinfo(nfproto);
+	if (afinfo != NULL)
+		route_err = afinfo->route(net, dst, flow, strict);
+	else
+		route_err = 1;
+
+	rcu_read_unlock();
+
+	return route_err == 0;
+}
+
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+static struct dst_entry* rpfilter_mt6(struct net *net,
+				const struct sk_buff *skb, u32 mark)
+{
+	const struct ipv6hdr *iph = ipv6_hdr(skb);
+	struct rt6_info *rt;
+	struct flowi6 flow = {
+		.daddr = iph->daddr,
+		.saddr = iph->saddr,
+		.flowi6_proto = iph->nexthdr,
+		.flowlabel = (* (__be32 *) iph) & IPV6_FLOWINFO_MASK,
+		.flowi6_mark = mark,
+		.flowi6_flags = FLOWI_FLAG_ANYSRC,
+	};
+
+	if (rpfilter_lookup(net, NFPROTO_IPV6,
+			 (struct dst_entry **)&rt, flowi6_to_flowi(&flow)))
+		return &rt->dst;
+	return NULL;
+}
+#endif
+
+static __be32 rpfilter_get_saddr(__be32 addr)
+{
+	if (ipv4_is_multicast(addr) ||
+	    ipv4_is_lbcast(addr) ||
+	    ipv4_is_zeronet(addr))
+		return 0;
+	return addr;
+}
+
+static struct dst_entry* rpfilter_mt4(const struct sk_buff *skb,
+			      const struct net_device *indev, u32 mark)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	struct flowi4 flow;
+	struct rtable *rt;
+	__be32 daddr = iph->saddr;
+	__be32 saddr = rpfilter_get_saddr(iph->daddr);
+
+	flowi4_init_output(&flow, 0, mark, RT_TOS(iph->tos), RT_SCOPE_UNIVERSE,
+			   iph->protocol, FLOWI_FLAG_ANYSRC, daddr, saddr, 0, 0);
+
+	printk(KERN_INFO "got saddr %pI4, daddr %pI4 on dev %s\n",&iph->saddr,&iph->daddr,indev->name);
+	if (rpfilter_lookup(dev_net(indev), NFPROTO_IPV4,
+			 (struct dst_entry **)&rt, flowi4_to_flowi(&flow))) {
+		printk(KERN_INFO "found rt->rt_iif %d, %d flags 0x%x\n", rt->rt_iif, rt->rt_oif, rt->rt_flags);
+		return &rt->dst;
+	}
+	return NULL;
+}
+
+static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_rpfilter_info *info;
+	struct dst_entry *dst;
+	bool matches;
+	u32 mark;
+	struct net *net;
+
+	if (par->in->flags & IFF_LOOPBACK)
+		return true;
+
+	info = par->matchinfo;
+	net = dev_net(par->in);
+	mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
+
+	switch (par->family) {
+	case NFPROTO_IPV4:
+		dst = rpfilter_mt4(skb, par->in, mark);
+		break;
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+	case NFPROTO_IPV6:
+		dst = rpfilter_mt6(net, skb, mark);
+		break;
+#endif
+	default:
+		return false;
+	}
+
+	matches = false;
+	if (dst) {
+		bool loose = info->flags & XT_RPFILTER_LOOSE;
+		printk("got dest->dev %p, %s\n", dst->dev, dst->dev ? dst->dev->name : "(null)");
+		matches = loose ? dst->dev : dst->dev == par->in;
+		dst_release(dst);
+	} else
+		printk("no result\n");
+	return matches;
+}
+
+static int rpfilter_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_rpfilter_info *info = par->matchinfo;
+	unsigned int options = ~XT_RPFILTER_OPTION_MASK;
+
+	if (info->flags & options) {
+		pr_info("unknown options encountered");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct xt_match rpfilter_mt_reg __read_mostly = {
+	.name		= "rpfilter",
+	.family		= NFPROTO_UNSPEC,
+	.checkentry	= rpfilter_check,
+	.match		= rpfilter_mt,
+	.matchsize	= sizeof(struct xt_rpfilter_info),
+	.hooks		= 1 << NF_INET_PRE_ROUTING,
+	.me		= THIS_MODULE
+};
+
+static int __init rpfilter_mt_init(void)
+{
+	return xt_register_match(&rpfilter_mt_reg);
+}
+
+static void __exit rpfilter_mt_exit(void)
+{
+	xt_unregister_match(&rpfilter_mt_reg);
+}
+
+module_init(rpfilter_mt_init);
+module_exit(rpfilter_mt_exit);
-- 
1.7.3.4

