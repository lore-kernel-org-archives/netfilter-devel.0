From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [nf-next] netfilter: Add support for inner IPv6 packet match
Date: Thu, 18 Jan 2018 16:13:25 +0100
Message-ID: <1516288405-4582-2-git-send-email-amsalam20@gmail.com>
References: <1516288405-4582-1-git-send-email-amsalam20@gmail.com>
Cc: netdev@vger.kernel.org, kadlec@blackhole.kfki.hu,
        uznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, amsalam20@gmail.com
To: pablo@netfilter.org, davem@davemloft.net, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1516288405-4582-1-git-send-email-amsalam20@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

As described in the SRv6 network programming document [1], the SRv6
information can be added to a packet in two different modes, insert or encap.

As shown below, you can see the original IPv6 packet and how it is carried in
the two different encapsulation modes.

In the insert mode the SRH header is inserted in the original IPv6 packet,
immediately after the IPv6 header and before the transport level header.
The original IPv6 header is modified, in particular the IPv6 destination
address is replaced with the IPv6 address of the first segment in the
segment list, while the original IPv6 destination address is carried in
the SRH header [2] as the last segment of the segment list.

In the encap mode the original IPv6 packet is carried as the inner packet
of an IPv6-in-IPv6 encapsulated packet. The outer IPv6 packet carries the
SRH header with the segment list.

In case of SRv6 encapsulated packets, we should be able to match the
source and destination address of the original packet since they
represent the end-to-end information.

This patch supports matching source and destination addresses of inner
IPv6 packets. It works for SRv6 and IP6IP6 encapsualted packets.

Original IPv6 packet
+-------------+--------------------+
| IPv6 header |       payload      |
+-------------+--------------------+

SRv6 packet - insert mode
+-------------+---------+--------------------+
| IPv6 header |   SRH   |       payload      |
+-------------+---------+--------------------+

SRv6 packet - encap mode
+-------------+---------+-------------+--------------------+
| IPv6 header |   SRH   | IPv6 header |       payload      |
+-------------+---------+-------------+--------------------+

[1] https://tools.ietf.org/html/draft-filsfils-spring-srv6-network-programming-03
[2] https://tools.ietf.org/html/draft-ietf-6man-segment-routing-header-07

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 include/uapi/linux/netfilter_ipv6/ip6t_inner6.h |  21 ++++
 net/ipv6/netfilter/Kconfig                      |  10 ++
 net/ipv6/netfilter/Makefile                     |   1 +
 net/ipv6/netfilter/ip6t_inner6.c                | 156 ++++++++++++++++++++++++
 4 files changed, 188 insertions(+)
 create mode 100644 include/uapi/linux/netfilter_ipv6/ip6t_inner6.h
 create mode 100644 net/ipv6/netfilter/ip6t_inner6.c

diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_inner6.h b/include/uapi/linux/netfilter_ipv6/ip6t_inner6.h
new file mode 100644
index 0000000..7017fa4
--- /dev/null
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_inner6.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _IP6T_INNER6_H
+#define _IP6T_INNER6_H
+
+#include <linux/types.h>
+#include <linux/netfilter.h>
+
+/* Values for "invflags" field in struct ip6t_inner6 */
+#define IP6T_INNER6_INV_SRC	0x01
+#define IP6T_INNER6_INV_DST	0x02
+#define IP6T_INNER6_INV_MASK	0x03
+
+struct ip6t_inner6 {
+	/* Source and destination addr of inner IPv6 packet */
+	struct in6_addr inner_src, inner_dst;
+	/* Mask for src and dest addr of inner IPv6 packet */
+	struct in6_addr inner_smsk, inner_dmsk;
+	__u8		invflags;
+};
+
+#endif /*_IP6T_INNER6_H*/
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 4a634b7..58ed2c9 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -250,6 +250,16 @@ config IP6_NF_MATCH_SRH
 
           To compile it as a module, choose M here.  If unsure, say N.
 
+config IP6_NF_MATCH_INNER6
+        tristate '"inner6" Inner IPv6 packet match support'
+        depends on NETFILTER_ADVANCED
+        help
+	  inner6 matching allows you to match the source and destination
+	  address of inner IPv6 packet. It works for both SRv6 and IP6IP6
+	  encapsulated packets.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 # The targets
 config IP6_NF_TARGET_HL
 	tristate '"HL" hoplimit target support'
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index d984057..40e332a 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_hbh.o
 obj-$(CONFIG_IP6_NF_MATCH_RPFILTER) += ip6t_rpfilter.o
 obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
 obj-$(CONFIG_IP6_NF_MATCH_SRH) += ip6t_srh.o
+obj-$(CONFIG_IP6_NF_MATCH_INNER6) += ip6t_inner6.o
 
 # targets
 obj-$(CONFIG_IP6_NF_TARGET_MASQUERADE) += ip6t_MASQUERADE.o
diff --git a/net/ipv6/netfilter/ip6t_inner6.c b/net/ipv6/netfilter/ip6t_inner6.c
new file mode 100644
index 0000000..391fd7e
--- /dev/null
+++ b/net/ipv6/netfilter/ip6t_inner6.c
@@ -0,0 +1,156 @@
+/* Kernel module to match inner IPv6 packet parameters. */
+
+/* Author:
+ * Ahmed Abdelsalam <amsalam20@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version 2
+ *	of the License, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <linux/types.h>
+#include <net/ipv6.h>
+#include <net/seg6.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv6/ip6t_inner6.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+/* Test a struct->invflags and a boolean for inequality */
+#define NF_INNER6_INVF(ptr, flag, boolean)	\
+	((boolean) ^ !!((ptr)->invflags & (flag)))
+
+static inline bool
+inner6_mt_encap(const struct sk_buff *skb, int innoff,
+		const struct ip6t_inner6 *inner6info)
+{
+	const struct ipv6hdr *inner_hdr;
+	struct ipv6hdr _inner_hdr;
+
+	inner_hdr = skb_header_pointer(skb, innoff,
+				       sizeof(_inner_hdr), &_inner_hdr);
+	if (!inner_hdr)
+		return false;
+	if (NF_INNER6_INVF(inner6info, IP6T_INNER6_INV_SRC,
+			   ipv6_masked_addr_cmp(&inner_hdr->saddr,
+						&inner6info->inner_smsk,
+						&inner6info->inner_src)) ||
+	    NF_INNER6_INVF(inner6info, IP6T_INNER6_INV_DST,
+			   ipv6_masked_addr_cmp(&inner_hdr->daddr,
+						&inner6info->inner_dmsk,
+						&inner6info->inner_dst)))
+		return false;
+	return true;
+}
+
+static inline bool
+inner6_mt_insert(const struct sk_buff *skb,
+		 int srhoff, const struct ip6t_inner6 *inner6info)
+{
+	const struct ipv6_sr_hdr *srh;
+	struct ipv6_sr_hdr _srh;
+	struct in6_addr _daddr;
+	const struct in6_addr *daddr;
+	int hdrlen;
+
+	srh = skb_header_pointer(skb, srhoff, sizeof(_srh), &_srh);
+	if (!srh)
+		return false;
+	hdrlen = ipv6_optlen(srh);
+	if (skb->len - srhoff < hdrlen)
+		return false;
+	if (srh->type != IPV6_SRCRT_TYPE_4)
+		return false;
+	if (srh->segments_left > srh->first_segment)
+		return false;
+	daddr = skb_header_pointer(skb, srhoff + sizeof(struct ipv6_sr_hdr),
+				   sizeof(_daddr), &_daddr);
+	WARN_ON(!daddr);
+	if (NF_INNER6_INVF(inner6info, IP6T_INNER6_INV_SRC,
+			   ipv6_masked_addr_cmp(&ipv6_hdr(skb)->saddr,
+						&inner6info->inner_smsk,
+						&inner6info->inner_src)) ||
+	    NF_INNER6_INVF(inner6info, IP6T_INNER6_INV_DST,
+			   ipv6_masked_addr_cmp(daddr,
+						&inner6info->inner_dmsk,
+						&inner6info->inner_dst)))
+		return false;
+	return true;
+}
+
+static inline bool
+inner_match(const struct sk_buff *skb, int srhoff,
+	    int innoff, int encap, const struct ip6t_inner6 *inner6info)
+{
+	if (encap)
+		return inner6_mt_encap(skb, innoff, inner6info);
+	return inner6_mt_insert(skb, srhoff, inner6info);
+}
+
+static inline bool
+sr6_pre_processor(const struct sk_buff *skb,
+		  int *innoff, int *srhoff, int *encap)
+{
+	if (ipv6_find_hdr(skb, innoff, IPPROTO_IPV6,
+			  NULL, NULL) == IPPROTO_IPV6){
+		*encap = 1;
+		return true;
+	}
+	if (ipv6_find_hdr(skb, srhoff, IPPROTO_ROUTING,
+			  NULL, NULL) == IPPROTO_ROUTING)
+		return true;
+	return false;
+}
+
+static bool inner6_mt6(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	int innoff = 0, srhoff = 0, encap = 0;
+	const struct ip6t_inner6 *inner6info = par->matchinfo;
+
+	if (!sr6_pre_processor(skb, &innoff, &srhoff, &encap))
+		return false;
+	if (!inner_match(skb, srhoff, innoff, encap, inner6info))
+		return false;
+	return true;
+}
+
+static int inner6_mt6_check(const struct xt_mtchk_param *par)
+{
+	const struct ip6t_inner6 *inner6info = par->matchinfo;
+
+	if (inner6info->invflags & ~IP6T_INNER6_INV_MASK) {
+		pr_err("unknown inner6 invflags %X\n", inner6info->invflags);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct xt_match inner6_mt6_reg __read_mostly = {
+	.name		= "inner6",
+	.family		= NFPROTO_IPV6,
+	.match		= inner6_mt6,
+	.matchsize	= sizeof(struct ip6t_inner6),
+	.checkentry	= inner6_mt6_check,
+	.me		= THIS_MODULE,
+};
+
+static int __init inner6_mt6_init(void)
+{
+	return xt_register_match(&inner6_mt6_reg);
+}
+
+static void __exit inner6_mt6_exit(void)
+{
+	xt_unregister_match(&inner6_mt6_reg);
+}
+module_init(inner6_mt6_init);
+module_exit(inner6_mt6_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Xtables: Inner IPv6 packet match");
+MODULE_AUTHOR("Ahmed Abdelsalam <amsalam20@gmail.com>");
-- 
2.1.4
