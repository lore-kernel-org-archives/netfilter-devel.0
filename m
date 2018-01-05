From: Colin Zeidler <czeidler@solananetworks.com>
Subject: [PATCH] netfilter: add encapsulated packet mirroring target
Date: Fri, 5 Jan 2018 16:09:45 -0500
Message-ID: <f41b0832-926a-baad-d83c-59511d734a45@solananetworks.com>
References: <37898685-1b0a-91a1-df6a-45656bf2c03f@solananetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail736.megamailservers.com ([69.49.98.46]:39392 "EHLO
        mail125c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750980AbeAEVkE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jan 2018 16:40:04 -0500
Received: from [192.168.1.107] (69-196-152-194.dsl.teksavvy.com [69.196.152.194])
        (authenticated bits=0)
        by mail125c7.megamailservers.com (8.14.9/8.13.1) with ESMTP id w05L9jun021534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <netfilter-devel@vger.kernel.org>; Fri, 5 Jan 2018 16:09:46 -0500
In-Reply-To: <37898685-1b0a-91a1-df6a-45656bf2c03f@solananetworks.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Users may want to monitor the traffic of multiple remote systems at a
single location while both filtering to monitor only certain traffic, and
preserving the original packet.

This extension for iptables/xtables add the ability to clone and encapsulate
any packet matched with iptables, and send it to a specified remote destination.

Signed-off-by: Colin Zeidler <czeidler@solananetworks.com>
---
 include/uapi/linux/netfilter/xt_RMIRROR.h |  16 ++
 net/netfilter/Kconfig                     |   9 ++
 net/netfilter/Makefile                    |   1 +
 net/netfilter/xt_RMIRROR.c                | 246 ++++++++++++++++++++++++++++++
 4 files changed, 272 insertions(+)
 create mode 100644 include/uapi/linux/netfilter/xt_RMIRROR.h
 create mode 100644 net/netfilter/xt_RMIRROR.c

diff --git a/include/uapi/linux/netfilter/xt_RMIRROR.h b/include/uapi/linux/netfilter/xt_RMIRROR.h
new file mode 100644
index 0000000..479bf33
--- /dev/null
+++ b/include/uapi/linux/netfilter/xt_RMIRROR.h
@@ -0,0 +1,16 @@
+/*
+ * Author Colin Zeidler <czeidler@solananetworks.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, as published by the Free Software Foundation.
+ */
+#ifndef _LINUX_NETFILTER_XT_RMIRROR_H
+#define _LINUX_NETFILTER_XT_RMIRROR_H
+
+struct xt_rmirror_tginfo {
+	union nf_inet_addr dst;
+	unsigned int len;
+};
+
+#endif /* _LINUX_NETFILTER_XT_RMIRROR_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e4a13cc..e7455c5 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -945,6 +945,15 @@ config NETFILTER_XT_TARGET_REDIRECT
 
 	To compile it as a module, choose M here. If unsure, say N.
 
+config NETFILTER_XT_TARGET_RMIRROR
+	tristate '"RMIRROR" - packet mirroring over GRE'
+	depends on NETFILTER_ADVANCED
+	depends on !NF_CONNTRACK || NF_CONNTRACK
+	select NF_DUP_IPV4
+	---help---
+	This option adds a "RMIRROR" target which can clone a packet and
+	encapsulate the clone in a GRE tunnel to a remote destination.
+
 config NETFILTER_XT_TARGET_TEE
 	tristate '"TEE" - packet cloning to alternate destination'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f78ed24..12805ad 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -132,6 +132,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_REDIRECT) += xt_REDIRECT.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_RMIRROR) += xt_RMIRROR.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
diff --git a/net/netfilter/xt_RMIRROR.c b/net/netfilter/xt_RMIRROR.c
new file mode 100644
index 0000000..09d9d49
--- /dev/null
+++ b/net/netfilter/xt_RMIRROR.c
@@ -0,0 +1,246 @@
+/*
+ * Author Colin Zeidler <czeidler@solananetworks.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, as published by the Free Software Foundation.
+ */
+#include <linux/version.h>
+#include <linux/ip.h>
+#include <linux/inetdevice.h>
+#include <linux/skbuff.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/percpu.h>
+#include <linux/route.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netdevice.h>
+#include <net/ip.h>
+#include <net/gre.h>
+#include <net/checksum.h>
+#include <net/route.h>
+#include <net/neighbour.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/if_ether.h>
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#define WITH_CONNTRACK 1
+#include <net/netfilter/nf_conntrack.h>
+#endif
+
+#include <linux/netfilter/xt_RMIRROR.h>
+
+static DEFINE_PER_CPU(bool, rmirror_active);
+
+struct rmirror_hdr {
+	struct iphdr ip;
+	struct gre_base_hdr gre;
+};
+
+static struct rmirror_hdr new_rmirror = {
+	.ip = {
+		.version  = 4,
+		.ihl	  = 5,
+		.tos	  = 0,
+		.frag_off = 0,
+		.ttl	  = 0xff,
+		.protocol = 0x2F, // GRE
+	},
+	.gre = {
+		.flags	  = 0,
+		.protocol = htons(0x6558),
+	},
+};
+
+static const char zeromac[6] = { 0, 0, 0, 0, 0, 0};
+
+/* Apply routing information to skb,
+ * so it can be sent with ip_local_out()
+ *
+ * Based on net/netfilter/xt_TEE.c, tee_tg_route4
+ */
+bool rmirror_tg_route4(struct sk_buff *skb, __be32 ip)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	struct net *net = &init_net;
+	struct rtable *rt;
+	struct flowi4 fl4;
+
+	memset(&fl4, 0, sizeof(fl4));
+
+	fl4.daddr = ip;
+	fl4.flowi4_tos = RT_TOS(iph->tos);
+	fl4.flowi4_scope = RT_SCOPE_UNIVERSE;
+	fl4.flowi4_flags = FLOWI_FLAG_KNOWN_NH;
+	rt = ip_route_output_key(net, &fl4);
+	if (IS_ERR(rt))
+		return false;
+
+	skb_dst_drop(skb);
+	skb_dst_set(skb, &rt->dst);
+	skb->dev = rt->dst.dev;
+	skb->protocol = htons(ETH_P_TEB);
+	return true;
+}
+
+/* Create new skb that encapsulates data of original
+ * skb with GRE
+ */
+bool encap_packet4(struct sk_buff *skb, const struct xt_rmirror_tginfo *info)
+{
+	struct rmirror_hdr *rmh;
+	struct iphdr *iph;
+	struct ethhdr *ehdr;
+	struct ethhdr *datamac;
+	bool mac_needed = false;
+
+	/* add extra size as we include MAC Header and IP Header */
+	int extra_header = sizeof(new_rmirror);
+
+	/* If the skb did not have a mac header, i.e. new outgoing skb
+	 * create the mac header for the skb we cloned
+	 * as if it had progressed through the stack
+	 */
+	if (!skb_mac_header_was_set(skb)) {
+		if (!skb->dev) {
+			iph = ip_hdr(skb);
+			rmirror_tg_route4(skb, iph->daddr);
+		}
+		if (skb->dev) {
+			dev_hard_header(skb,
+				skb->dev,
+				ETH_P_IP,
+				&zeromac,
+				NULL,
+				skb->len);
+			mac_needed = true;
+		}
+
+		if (skb_headroom(skb) < extra_header)
+			pskb_expand_head(skb, extra_header, 0, GFP_ATOMIC);
+	} else if (skb_mac_header_was_set(skb)) {
+		ehdr = eth_hdr(skb);
+		extra_header = extra_header + sizeof(*ehdr);
+		if (skb_headroom(skb) < extra_header)
+			pskb_expand_head(skb, extra_header, 0, GFP_ATOMIC);
+		datamac = (struct ethhdr *)skb_push(skb, sizeof(*ehdr));
+		memcpy(datamac, ehdr, sizeof(*ehdr));
+	}
+
+	skb->encapsulation = 1;
+
+	skb_reset_inner_headers(skb);
+
+	rmh = (struct rmirror_hdr *)skb_push(skb, sizeof(*rmh));
+	memcpy(rmh, &new_rmirror, sizeof(*rmh));
+
+	if (info->len > 0)
+		skb_trim(skb, sizeof(*rmh) + info->len);
+
+	iph = &rmh->ip;
+	iph->daddr = info->dst.ip;
+	iph->tot_len = htons(skb->len);
+	__ip_select_ident(&init_net, iph, 1);
+	ip_send_check(iph);
+	skb_reset_network_header(skb);
+
+	return mac_needed;
+}
+
+unsigned int rmirror_tg4(struct sk_buff *skb,
+		const struct xt_action_param *par
+		)
+{
+	const struct xt_rmirror_tginfo *info = par->targinfo;
+	struct dst_entry *inner_dst;
+	__be32 inner_daddr;
+	bool mac_needed;
+
+	if (__this_cpu_read(rmirror_active))
+		return XT_CONTINUE;
+
+	skb = skb_clone(skb, GFP_ATOMIC);
+#ifdef WITH_CONNTRACK
+	nf_reset(skb);
+	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+#endif //WITH CONNTRACK
+	inner_daddr = ip_hdr(skb)->daddr;
+
+	mac_needed = encap_packet4(skb, info);
+
+	if (mac_needed)
+		inner_dst = skb_dst(skb);
+
+	// Send the cloned skb
+	if (rmirror_tg_route4(skb, info->dst.ip)) {
+		// set saddr based on output device
+		struct in_device *idev = rcu_dereference(skb->dev->ip_ptr);
+		struct iphdr *iph = ip_hdr(skb);
+
+		iph->saddr = idev->ifa_list->ifa_address;
+
+		if (mac_needed) {
+			struct neighbour *n;
+			struct ethhdr *inner_eh;
+
+			inner_eh = (struct ethhdr *)((char *)iph + sizeof(new_rmirror));
+			n = dst_neigh_lookup(inner_dst, &inner_daddr);
+			if (n)
+				memcpy(inner_eh->h_dest,
+					n->ha,
+					sizeof(char) * 6);
+			else
+				memcpy(inner_eh->h_dest,
+					zeromac,
+					sizeof(char) * 6);
+		}
+
+		__this_cpu_write(rmirror_active, true);
+		ip_local_out(&init_net, skb->sk, skb);
+		__this_cpu_write(rmirror_active, false);
+	} else {
+		kfree_skb(skb);
+	}
+
+	return XT_CONTINUE;
+}
+
+static int rmirror_tg_check(const struct xt_tgchk_param *par)
+{
+	struct xt_rmirror_tginfo *info = par->targinfo;
+
+	return 0;
+}
+
+static struct xt_target rmirror_tg_reg[] __read_mostly = {
+	{
+		.name		= "RMIRROR",
+		.revision	= 0,
+		.family		= NFPROTO_IPV4,
+		.target		= rmirror_tg4,
+		.targetsize = sizeof(struct xt_rmirror_tginfo),
+		.checkentry = rmirror_tg_check,
+		.me			= THIS_MODULE,
+	},
+};
+
+static int __init rmirror_tg_init(void)
+{
+	return xt_register_targets(rmirror_tg_reg, ARRAY_SIZE(rmirror_tg_reg));
+}
+
+static void __exit rmirror_tg_exit(void)
+{
+	xt_unregister_targets(rmirror_tg_reg, ARRAY_SIZE(rmirror_tg_reg));
+}
+
+module_init(rmirror_tg_init);
+module_exit(rmirror_tg_exit);
+
+MODULE_ALIAS("ipt_RMIRROR");
+
+MODULE_AUTHOR("Colin Zeidler, czeidler@solananetworks.com");
+MODULE_DESCRIPTION("Xtables: clone and send packet with GRE");
+MODULE_LICENSE("GPL");
+
-- 
2.1.4

