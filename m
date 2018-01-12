From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [nf-next 3/3] netfilter: Add support for IPv6 segment routing 'SEG6' target
Date: Fri, 12 Jan 2018 05:39:36 +0100
Message-ID: <1515731976-6338-3-git-send-email-amsalam20@gmail.com>
References: <1515731976-6338-1-git-send-email-amsalam20@gmail.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ahmed Abdelsalam <amsalam20@gmail.com>
To: pablo@netfilter.org, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515731976-6338-1-git-send-email-amsalam20@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Service Function Chaining (SFC) is one of the main use-cases of
IPv6 Segment Routing (SRv6)[1].

The Segment Routing Header (SRH) allows including a list of segments
in the IPv6 packet. This segment list can be used to steer the packet
though a set of Virtual Network Functions (VNFS) e.g., Firewall, DPI, IDS.

The edge node (SR ingress node) classifies the traffic and consequently
includes the segment lists in the IPv6 packet.

The IPv6 segment routing 'SEG6' target supports a set of SR-specific
actions. This set of actions allows branching within a pre-defined
SRv6 SFC policy instead of the usual linear exploration of the VNF chain.

As an example, consider a service chain which includes a firewall
followed by an Intrusion Detection System. The firewall may decide
to skip the IDS for a subset of traffic that matches some conditions.

This patch implements the following SR-specific actions:
(1) go-next: is the default action of the SEG6 target. It sends packets
towards the next SID from SRH.
(2) skip-next: skips the next SID in the SRH.
(3) go-last: skips the remaining part of the segment list and send the
packet towards the last segment.

[1] https://tools.ietf.org/html/draft-clad-spring-segment-routing-service-chaining-00

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 include/uapi/linux/netfilter_ipv6/ip6t_SEG6.h |  18 ++++
 net/ipv6/netfilter/ip6t_SEG6.c                | 113 ++++++++++++++++++++++++++
 2 files changed, 131 insertions(+)
 create mode 100644 include/uapi/linux/netfilter_ipv6/ip6t_SEG6.h
 create mode 100644 net/ipv6/netfilter/ip6t_SEG6.c

diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_SEG6.h b/include/uapi/linux/netfilter_ipv6/ip6t_SEG6.h
new file mode 100644
index 0000000..38b380a
--- /dev/null
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_SEG6.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _IP6T_SEG6_H
+#define _IP6T_SEG6_H
+
+#include <linux/types.h>
+
+/* seg6 action options */
+enum ip6t_seg6_action {
+	IP6T_SEG6_GO_NEXT,
+	IP6T_SEG6_SKIP_NEXT,
+	IP6T_SEG6_GO_LAST,
+};
+
+struct ip6t_seg6_info {
+	__u32	action;	/* SEG6 action */
+};
+
+#endif /*_IP6T_SEG6_H*/
diff --git a/net/ipv6/netfilter/ip6t_SEG6.c b/net/ipv6/netfilter/ip6t_SEG6.c
new file mode 100644
index 0000000..3d326e2
--- /dev/null
+++ b/net/ipv6/netfilter/ip6t_SEG6.c
@@ -0,0 +1,113 @@
+/* IPv6 Segment Routing target module (SEG6).
+ *
+ * Author:
+ * Ahmed Abdelsalam <amsalam20@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version 2
+ *	of the License, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/gfp.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/icmpv6.h>
+#include <linux/netdevice.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_SEG6.h>
+
+#include <net/flow.h>
+#include <net/seg6.h>
+#include <net/ip6_route.h>
+
+static int seg6_go_next(struct sk_buff *skb, struct ipv6_sr_hdr *srh)
+{
+	if (srh->segments_left == 0)
+		return NF_DROP;
+	seg6_advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	seg6_lookup_nexthop(skb, NULL, 0);
+	dst_input(skb);
+	return NF_STOLEN;
+}
+
+static int seg6_skip_next(struct sk_buff *skb, struct ipv6_sr_hdr *srh)
+{
+	if (srh->segments_left < 2)
+		return NF_DROP;
+	seg6_advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	seg6_advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	seg6_lookup_nexthop(skb, NULL, 0);
+	dst_input(skb);
+	return NF_STOLEN;
+}
+
+static int seg6_go_last(struct sk_buff *skb, struct ipv6_sr_hdr *srh)
+{
+	if (srh->segments_left == 0)
+		return NF_DROP;
+	srh->segments_left = 1;
+	seg6_advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	seg6_lookup_nexthop(skb, NULL, 0);
+	dst_input(skb);
+	return NF_STOLEN;
+}
+
+static unsigned int
+seg6_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct ipv6_sr_hdr *srh;
+	const struct ip6t_seg6_info *seg6 = par->targinfo;
+
+	srh = seg6_get_srh(skb);
+	if (!srh)
+		return NF_DROP;
+
+	switch (seg6->action) {
+	case IP6T_SEG6_GO_NEXT:
+		return seg6_go_next(skb, srh);
+	case IP6T_SEG6_SKIP_NEXT:
+		return seg6_skip_next(skb, srh);
+	case IP6T_SEG6_GO_LAST:
+		return seg6_go_last(skb, srh);
+	}
+	pr_err("Unknown SEG6 action\n");
+	return NF_DROP;
+}
+
+static int seg6_check(const struct xt_tgchk_param *par)
+{
+	/**
+	 * In the future, some new action may require using this function
+	 */
+	return 0;
+}
+
+static struct xt_target seg6_tg6_reg __read_mostly = {
+	.name		= "SEG6",
+	.family		= NFPROTO_IPV6,
+	.target		= seg6_tg6,
+	.targetsize	= sizeof(struct ip6t_seg6_info),
+	.checkentry	= seg6_check,
+	.me		= THIS_MODULE
+};
+
+static int __init seg6_tg6_init(void)
+{
+	return xt_register_target(&seg6_tg6_reg);
+}
+
+static void __exit seg6_tg6_exit(void)
+{
+	xt_unregister_target(&seg6_tg6_reg);
+}
+
+module_init(seg6_tg6_init);
+module_exit(seg6_tg6_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Xtables: IPv6 Segment Routing Target (SEG6)");
+MODULE_AUTHOR("Ahmed Abdelsalam <amsalam20@gmail.com>");
-- 
2.1.4
