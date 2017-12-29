From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [net-next] netfilter: add segment routing header 'srh' match
Date: Fri, 29 Dec 2017 12:07:52 +0100
Message-ID: <1514545672-13827-1-git-send-email-amsalam20@gmail.com>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org, amsalam20@gmail.com
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

It allows matching packets based on Segment Routing Header
(SRH) information.
The implementation considers revision 7 of the SRH draft.
https://tools.ietf.org/html/draft-ietf-6man-segment-routing-header-07

Currently supported match options include:
(1) Next Header
(2) Hdr Ext Len
(3) Segments Left
(4) Last Entry
(5) Tag value of SRH

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 include/uapi/linux/netfilter_ipv6/ip6t_srh.h |  63 ++++++++++
 net/ipv6/netfilter/Kconfig                   |   9 ++
 net/ipv6/netfilter/Makefile                  |   1 +
 net/ipv6/netfilter/ip6t_srh.c                | 165 +++++++++++++++++++++++++++
 4 files changed, 238 insertions(+)
 create mode 100644 include/uapi/linux/netfilter_ipv6/ip6t_srh.h
 create mode 100644 net/ipv6/netfilter/ip6t_srh.c

diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_srh.h b/include/uapi/linux/netfilter_ipv6/ip6t_srh.h
new file mode 100644
index 0000000..1b5dbd8
--- /dev/null
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_srh.h
@@ -0,0 +1,63 @@
+/**
+ * Definitions for Segment Routing Header 'srh' match
+ *
+ * Author:
+ *       Ahmed Abdelsalam       <amsalam20@gmail.com>
+ */
+
+#ifndef _IP6T_SRH_H
+#define _IP6T_SRH_H
+
+#include <linux/types.h>
+#include <linux/netfilter.h>
+
+/* Values for "mt_flags" field in struct ip6t_srh */
+#define IP6T_SRH_NEXTHDR        0x0001
+#define IP6T_SRH_LEN_EQ         0x0002
+#define IP6T_SRH_LEN_GT         0x0004
+#define IP6T_SRH_LEN_LT         0x0008
+#define IP6T_SRH_SEGS_EQ        0x0010
+#define IP6T_SRH_SEGS_GT        0x0020
+#define IP6T_SRH_SEGS_LT        0x0040
+#define IP6T_SRH_LAST_EQ        0x0080
+#define IP6T_SRH_LAST_GT        0x0100
+#define IP6T_SRH_LAST_LT        0x0200
+#define IP6T_SRH_TAG            0x0400
+#define IP6T_SRH_MASK           0x07FF
+
+/* Values for "mt_invflags" field in struct ip6t_srh */
+#define IP6T_SRH_INV_NEXTHDR    0x0001
+#define IP6T_SRH_INV_LEN_EQ     0x0002
+#define IP6T_SRH_INV_LEN_GT     0x0004
+#define IP6T_SRH_INV_LEN_LT     0x0008
+#define IP6T_SRH_INV_SEGS_EQ    0x0010
+#define IP6T_SRH_INV_SEGS_GT    0x0020
+#define IP6T_SRH_INV_SEGS_LT    0x0040
+#define IP6T_SRH_INV_LAST_EQ    0x0080
+#define IP6T_SRH_INV_LAST_GT    0x0100
+#define IP6T_SRH_INV_LAST_LT    0x0200
+#define IP6T_SRH_INV_TAG        0x0400
+#define IP6T_SRH_INV_MASK       0x07FF
+
+/**
+ *      struct ip6t_srh - SRH match options
+ *      @ next_hdr: Next header field of SRH
+ *      @ hdr_len: Extension header length field of SRH
+ *      @ segs_left: Segments left field of SRH
+ *      @ last_entry: Last entry field of SRH
+ *      @ tag: Tag field of SRH
+ *      @ mt_flags: match options
+ *      @ mt_invflags: Invert the sense of match options
+ */
+
+struct ip6t_srh {
+	__u8                    next_hdr;
+	__u8                    hdr_len;
+	__u8                    segs_left;
+	__u8                    last_entry;
+	__u16                   tag;
+	__u16                   mt_flags;
+	__u16                   mt_invflags;
+};
+
+#endif /*_IP6T_SRH_H*/
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 6acb2ee..e1818eb 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -232,6 +232,15 @@ config IP6_NF_MATCH_RT
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP6_NF_MATCH_SRH
+        tristate '"srh" Segment Routing header match support'
+        depends on NETFILTER_ADVANCED
+        help
+          srh matching allows you to match packets based on the segment
+	  routing header of the packet.
+
+          To compile it as a module, choose M here.  If unsure, say N.
+
 # The targets
 config IP6_NF_TARGET_HL
 	tristate '"HL" hoplimit target support'
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index c6ee0cd..e0d51a9 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_IP6_NF_MATCH_MH) += ip6t_mh.o
 obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_hbh.o
 obj-$(CONFIG_IP6_NF_MATCH_RPFILTER) += ip6t_rpfilter.o
 obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
+obj-$(CONFIG_IP6_NF_MATCH_SRH) += ip6t_srh.o
 
 # targets
 obj-$(CONFIG_IP6_NF_TARGET_MASQUERADE) += ip6t_MASQUERADE.o
diff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c
new file mode 100644
index 0000000..75e41dc9
--- /dev/null
+++ b/net/ipv6/netfilter/ip6t_srh.c
@@ -0,0 +1,165 @@
+/*
+ * Kernel module to match Segment Routing Header (SRH) parameters.
+ *
+ * Author:
+ * Ahmed Abdelsalam <amsalam20@gmail.com>
+ *
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
+#include <linux/netfilter_ipv6/ip6t_srh.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Xtables: IPv6 Segment Routing Header match");
+MODULE_AUTHOR("Ahmed Abdelsalam  <amsalam20@gmail.com>");
+
+/* Test a struct->mt_invflags and a boolean for inequality */
+#define NF_SRH_INVF(ptr, flag, boolean)	\
+	((boolean) ^ !!((ptr)->mt_invflags & (flag)))
+
+static bool srh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct ip6t_srh *srhinfo = par->matchinfo;
+	struct ipv6_sr_hdr *srh;
+	struct ipv6_sr_hdr _srh;
+	int hdrlen, srhoff = 0;
+
+	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
+		return false;
+
+	srh = skb_header_pointer(skb, srhoff, sizeof(_srh), &_srh);
+
+	if (!srh)
+		return false;
+
+	hdrlen = ipv6_optlen(srh);
+	if (skb->len - srhoff < hdrlen)
+		return false;
+
+	if (srh->type != IPV6_SRCRT_TYPE_4)
+		return false;
+
+	if (srh->segments_left > srh->first_segment)
+		return false;
+
+	/* Next Header matching */
+	if (srhinfo->mt_flags & IP6T_SRH_NEXTHDR)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NEXTHDR,
+				!(srh->nexthdr == srhinfo->next_hdr)))
+			return false;
+
+	/* Header Extension Length matching */
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_EQ)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LEN_EQ,
+				!(srh->hdrlen == srhinfo->hdr_len)))
+			return false;
+
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_GT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LEN_GT,
+				!(srh->hdrlen > srhinfo->hdr_len)))
+			return false;
+
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_LT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LEN_LT,
+				!(srh->hdrlen < srhinfo->hdr_len)))
+			return false;
+
+	/* Segments Left matching */
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_EQ)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_SEGS_EQ,
+				!(srh->segments_left == srhinfo->segs_left)))
+			return false;
+
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_GT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_SEGS_GT,
+				!(srh->segments_left > srhinfo->segs_left)))
+			return false;
+
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_LT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_SEGS_LT,
+				!(srh->segments_left < srhinfo->segs_left)))
+			return false;
+
+	/**
+	 * Last Entry matching
+	 * Last_Entry field was introduced in revision 6 of the SRH draft.
+	 * It was called First_Segment in the previous revision
+	 */
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_EQ)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LAST_EQ,
+				!(srh->first_segment == srhinfo->last_entry)))
+			return false;
+
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_GT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LAST_GT,
+				!(srh->first_segment > srhinfo->last_entry)))
+			return false;
+
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_LT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LAST_LT,
+				!(srh->first_segment < srhinfo->last_entry)))
+			return false;
+
+	/**
+	 * Tag matchig
+	 * Tag field was introduced in revision 6 of the SRH draft.
+	 */
+	if (srhinfo->mt_flags & IP6T_SRH_TAG)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_TAG,
+				!(srh->tag == srhinfo->tag)))
+			return false;
+	return true;
+}
+
+static int srh_mt6_check(const struct xt_mtchk_param *par)
+{
+	const struct ip6t_srh *srhinfo = par->matchinfo;
+
+	if (srhinfo->mt_flags & ~IP6T_SRH_MASK) {
+		pr_debug("unknown srh match flags  %X\n", srhinfo->mt_flags);
+		return -EINVAL;
+	}
+
+	if (srhinfo->mt_invflags & ~IP6T_SRH_INV_MASK) {
+		pr_debug("unknown srh invflags %X\n", srhinfo->mt_invflags);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct xt_match srh_mt6_reg __read_mostly = {
+	.name		= "srh",
+	.family		= NFPROTO_IPV6,
+	.match		= srh_mt6,
+	.matchsize	= sizeof(struct ip6t_srh),
+	.checkentry	= srh_mt6_check,
+	.me		= THIS_MODULE,
+};
+
+static int __init srh_mt6_init(void)
+{
+	return xt_register_match(&srh_mt6_reg);
+}
+
+static void __exit srh_mt6_exit(void)
+{
+	xt_unregister_match(&srh_mt6_reg);
+}
+
+module_init(srh_mt6_init);
+module_exit(srh_mt6_exit);
-- 
2.1.4
