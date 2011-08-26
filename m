From: Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC 2/3] netfilter: add ipv4 reverse path filter match
Date: Fri, 26 Aug 2011 11:21:04 +0200
Message-ID: <1314350465-19598-3-git-send-email-fw@strlen.de>
References: <1314350465-19598-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33900 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570Ab1HZJKk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:10:40 -0400
In-Reply-To: <1314350465-19598-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This tries to mimic behaviour of fib_validate_source.

main drawback:
- additional fib lookup to get oif (used as flow key in reverse lookup)
- no result caching so far

Other issues:
- can't use FORWARD chain because by the time FORWARD is invoked
  ipv4 forward path may have already sent icmp messages is response
  to to-be-discarded-via-rpfilter packets
- using it in PREROUTING may do the wrong thing (e.g. when using
  policy routing via mangle PREROUTING)
---
 net/ipv4/netfilter/Kconfig        |   10 ++
 net/ipv4/netfilter/Makefile       |    1 +
 net/ipv4/netfilter/ipt_rpfilter.c |  172 +++++++++++++++++++++++++++++++++++++
 3 files changed, 183 insertions(+), 0 deletions(-)
 create mode 100644 net/ipv4/netfilter/ipt_rpfilter.c

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1dfc18a..ef8c1ab 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -82,6 +82,16 @@ config IP_NF_MATCH_ECN
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_MATCH_RPFILTER
+	tristate '"rpfilter" reverse path filter match support'
+	depends on NETFILTER_ADVANCED
+	---help---
+	  This option allows you to match packets whose replies would
+	  go out via the interface the packet came in.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+	  The module will be called ipt_rpfilter.
+
 config IP_NF_MATCH_TTL
 	tristate '"ttl" match support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index dca2082..123dd88 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_IP_NF_SECURITY) += iptable_security.o
 # matches
 obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
+obj-$(CONFIG_IP_NF_MATCH_RPFILTER) += ipt_rpfilter.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_CLUSTERIP) += ipt_CLUSTERIP.o
diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
new file mode 100644
index 0000000..889f705
--- /dev/null
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -0,0 +1,172 @@
+/*
+ *  Copyright (c) 2011 Florian Westphal <fw@strlen.de>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ * based on fib_frontend.c; Author: Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/ip.h>
+#include <net/ip_fib.h>
+#include <net/route.h>
+
+#include <linux/netfilter/xt_rpfilter.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
+MODULE_DESCRIPTION("iptables: ipv4 reverse path filter match");
+
+/* don't try to find route from mcast/bcast/zeronet */
+static __be32 rpfilter_get_saddr(__be32 addr)
+{
+	if (ipv4_is_multicast(addr) || ipv4_is_lbcast(addr) ||
+	    ipv4_is_zeronet(addr))
+		return 0;
+	return addr;
+}
+
+static bool rpfilter_lookup_reverse(struct flowi4 *fl4,
+				const struct net_device *dev, u8 flags)
+{
+	struct fib_result res;
+	bool dev_match;
+	struct net *net = dev_net(dev);
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+	int ret;
+#endif
+	if (fib_lookup(net, fl4, &res))
+		return false;
+
+	if (res.type != RTN_UNICAST) {
+		if (res.type != RTN_LOCAL || !(flags & XT_RPFILTER_ACCEPT_LOCAL))
+			return false;
+	}
+	dev_match = false;
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+	for (ret = 0; ret < res.fi->fib_nhs; ret++) {
+		struct fib_nh *nh = &res.fi->fib_nh[ret];
+
+		if (nh->nh_dev == dev) {
+			dev_match = true;
+			break;
+		}
+	}
+#else
+	if (FIB_RES_DEV(res) == dev)
+		dev_match = true;
+#endif
+	if (dev_match || flags & XT_RPFILTER_LOOSE)
+		return FIB_RES_NH(res).nh_scope <= RT_SCOPE_HOST;
+	return dev_match;
+}
+
+static bool rpfilter_lookup(struct flowi4 *fl4, const struct net_device *dev,
+				const struct xt_rpfilter_info *info)
+{
+	int err, oif;
+	struct fib_result res;
+	struct net *net;
+	__be32 addr;
+
+	if (ipv4_is_multicast(fl4->daddr)) {
+		if (ipv4_is_zeronet(fl4->saddr))
+			return ipv4_is_local_multicast(fl4->daddr);
+		oif = 0;
+		goto validate;
+	}
+
+	net = dev_net(dev);
+	err = fib_lookup(net, fl4, &res);
+	if (err)
+		return false;
+
+	switch (res.type) {
+	case RTN_BROADCAST:
+		if (ipv4_is_zeronet(fl4->saddr))
+			return true;
+		oif = 0;
+		break;
+	case RTN_LOCAL:
+		oif = net->loopback_dev->ifindex;
+		break;
+	default:
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+		if (res.fi && res.fi->fib_nhs > 1)
+			fib_select_multipath(&res);
+#endif
+		oif = FIB_RES_OIF(res);
+		break;
+	}
+
+ validate:
+	addr = fl4->saddr;
+	fl4->saddr = rpfilter_get_saddr(fl4->daddr);
+	fl4->daddr = addr;
+	fl4->flowi4_iif = oif;
+	if (!(info->flags & XT_RPFILTER_VALID_MARK))
+		fl4->flowi4_mark = 0;
+	return rpfilter_lookup_reverse(fl4, dev, info->flags);
+}
+
+static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_rpfilter_info *info;
+	const struct iphdr *iph;
+	struct flowi4 flow;
+
+	if (par->in->flags & IFF_LOOPBACK)
+		return true;
+
+	iph = ip_hdr(skb);
+	info = par->matchinfo;
+
+	flow.flowi4_oif = 0;
+	flow.flowi4_iif = par->in->ifindex;
+	flow.flowi4_mark = skb->mark;
+	flow.flowi4_tos = RT_TOS(iph->tos);
+	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
+	flow.daddr = iph->daddr;
+	flow.saddr = iph->saddr;
+
+	return rpfilter_lookup(&flow, par->in, info);
+}
+
+static int rpfilter_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_rpfilter_info *info = par->matchinfo;
+	unsigned int options = ~XT_RPFILTER_OPTION_MASK;
+	if (info->flags & options) {
+		pr_info("unknown options encountered");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct xt_match rpfilter_mt_reg __read_mostly = {
+	.name		= "rpfilter",
+	.family		= NFPROTO_IPV4,
+	.checkentry	= rpfilter_check,
+	.match		= rpfilter_mt,
+	.matchsize	= sizeof(struct xt_rpfilter_info),
+	.hooks		= (1 << NF_INET_PRE_ROUTING),
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

