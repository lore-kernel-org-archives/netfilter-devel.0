From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH RFC 3/3] ip6t_rpf: initial version
Date: Fri, 26 Aug 2011 11:58:58 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108261157120.19453@frira.zrqbmnf.qr>
References: <1314350465-19598-1-git-send-email-fw@strlen.de> <1314350465-19598-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38538 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab1HZJ7B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:59:01 -0400
In-Reply-To: <1314350465-19598-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-08-26 11:21, Florian Westphal wrote:

>compile tested only.
>Differs significantly from ipv4 version, as the oif will
>not be used as flow key (we use the iif).
>
>Also, multicast probably needs special handling, too.
>---
> net/ipv6/netfilter/Kconfig         |   10 +++
> net/ipv6/netfilter/Makefile        |    1 +
> net/ipv6/netfilter/ip6t_rpfilter.c |  116 ++++++++++++++++++++++++++++++++++++
> 3 files changed, 127 insertions(+), 0 deletions(-)
> create mode 100644 net/ipv6/netfilter/ip6t_rpfilter.c
>
>diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
>index 4484648..49ec98b 100644
>--- a/net/ipv6/netfilter/Kconfig
>+++ b/net/ipv6/netfilter/Kconfig
>@@ -125,6 +125,16 @@ config IP6_NF_MATCH_MH
> 
> 	  To compile it as a module, choose M here.  If unsure, say N.
> 
>+config IP6_NF_MATCH_RPFILTER
>+	tristate '"rpfilter" reverse path filter match support'
>+	depends on NETFILTER_ADVANCED
>+	---help---
>+	  This option allows you to match packets whose replies would
>+	  go out via the interface the packet came in.
>+
>+	  To compile it as a module, choose M here.  If unsure, say N.
>+	  The module will be called ip6t_rpfilter.
>+
> config IP6_NF_MATCH_RT
> 	tristate '"rt" Routing header match support'
> 	depends on NETFILTER_ADVANCED
>diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
>index abfee91..2eaed96 100644
>--- a/net/ipv6/netfilter/Makefile
>+++ b/net/ipv6/netfilter/Makefile
>@@ -27,6 +27,7 @@ obj-$(CONFIG_IP6_NF_MATCH_FRAG) += ip6t_frag.o
> obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) += ip6t_ipv6header.o
> obj-$(CONFIG_IP6_NF_MATCH_MH) += ip6t_mh.o
> obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_hbh.o
>+obj-$(CONFIG_IP6_NF_MATCH_RPFILTER) += ip6t_rpfilter.o
> obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
> 
> # targets
>diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
>new file mode 100644
>index 0000000..bc5075d
>--- /dev/null
>+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
>@@ -0,0 +1,116 @@
>+/*
>+ *  Copyright (c) 2011 Florian Westphal <fw@strlen.de>
>+ *
>+ *  This program is free software; you can redistribute it and/or modify
>+ *  it under the terms of the GNU General Public License version 2 as
>+ *  published by the Free Software Foundation.
>+ */
>+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>+#include <linux/module.h>
>+#include <linux/skbuff.h>
>+#include <linux/netdevice.h>
>+#include <linux/route.h>
>+#include <net/dsfield.h>
>+#include <net/ip6_fib.h>
>+#include <net/ip6_route.h>
>+
>+#include <linux/netfilter/xt_rpfilter.h>
>+#include <linux/netfilter/x_tables.h>
>+
>+MODULE_LICENSE("GPL");
>+MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
>+MODULE_DESCRIPTION("Xtables: IPv6 reverse path filter match");
>+
>+/* don't try to find route from mcast/bcast/zeronet */
>+static bool rpfilter_addr_unicast(const struct in6_addr *addr)
>+{
>+	int addr_type = ipv6_addr_type(addr);
>+	return addr_type & IPV6_ADDR_UNICAST;
>+}
>+
>+static bool rpfilter_lookup_reverse6(const struct sk_buff *skb,
>+				     const struct net_device *dev, u8 flags)
>+{
>+	struct rt6_info *rt;
>+	struct dst_entry *dst;
>+	bool ret = false;
>+	struct ipv6hdr *iph = ipv6_hdr(skb);
>+	struct flowi6 fl6 = {
>+		.flowi6_oif = dev->ifindex,
>+		.daddr = iph->daddr,
>+		.flowi6_proto = iph->nexthdr,
>+	};
>+
>+	fl6.flowlabel = ipv6_get_dsfield(iph);
>+	fl6.flowi6_mark = flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;

This looks weird. In xt_rpfilter, you used

+        .flowlabel = (* (__be32 *) iph) & IPV6_FLOWINFO_MASK,

and now you are copying the traffic class into the flowlabel instead.
