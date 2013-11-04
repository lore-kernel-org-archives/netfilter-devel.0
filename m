From: James Chapman <jchapman@katalix.com>
Subject: [PATCH] netfilter: introduce l2tp match extension
Date: Mon,  4 Nov 2013 16:36:20 +0000
Message-ID: <1383582980-26317-1-git-send-email-jchapman@katalix.com>
Cc: James Chapman <jchapman@katalix.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from katalix.com ([82.103.140.233]:43626 "EHLO bert.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3KDQp7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:45:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce an xtables add-on for matching L2TP packets. Supports L2TPv2
and L2TPv3 over IPv4 and IPv6. As well as filtering on L2TP tunnel-id
and session-id, the filtering decision can also include the L2TP
packet type (control or data), protocol version (2 or 3) and
encapsulation type (UDP or IP).

The most common use for this will likely be to filter L2TP data
packets of individual L2TP tunnels or sessions. While a u32 match can
be used, the L2TP protocol headers are such that field offsets differ
depending on bits set in the header, making rules for matching generic
L2TP connections cumbersome. This match extension takes care of all
that.

An iptables patch will be submitted separately.

Signed-off-by: James Chapman <jchapman@katalix.com>
---
:000000 100644 0000000... ba0a3ed... A	include/uapi/linux/netfilter/xt_l2tp.h
:100644 100644 48acec1... 12daddc... M	net/netfilter/Kconfig
:100644 100644 394483b... 564bf35... M	net/netfilter/Makefile
:000000 100644 0000000... f7804ca... A	net/netfilter/xt_l2tp.c
 include/uapi/linux/netfilter/xt_l2tp.h |   36 ++++
 net/netfilter/Kconfig                  |   10 +
 net/netfilter/Makefile                 |    1 +
 net/netfilter/xt_l2tp.c                |  312 ++++++++++++++++++++++++++++++++
 4 files changed, 359 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_l2tp.h b/include/uapi/linux/netfilter/xt_l2tp.h
new file mode 100644
index 0000000..ba0a3ed
--- /dev/null
+++ b/include/uapi/linux/netfilter/xt_l2tp.h
@@ -0,0 +1,36 @@
+#ifndef _LINUX_NETFILTER_XT_L2TP_H
+#define _LINUX_NETFILTER_XT_L2TP_H
+
+#include <linux/types.h>
+
+enum xt_l2tp_encap {
+	XT_L2TP_ENCAP_UDP,
+	XT_L2TP_ENCAP_IP,
+};
+
+enum xt_l2tp_type {
+	XT_L2TP_TYPE_CONTROL,
+	XT_L2TP_TYPE_DATA,
+};
+
+/* L2TP matching stuff */
+struct xt_l2tp_info {
+	__u32 tid;			/* tunnel id */
+	__u32 sid;			/* session id */
+	__u8 version;			/* L2TP protocol version */
+	__u8 encap;			/* L2TP encapsulation type */
+	__u8 type;			/* L2TP packet type */
+	__u8 flags;			/* which fields to match */
+};
+
+enum {
+	XT_L2TP_TID	= (1 << 0),	/* match L2TP tunnel id */
+	XT_L2TP_SID	= (1 << 1),	/* match L2TP session id */
+	XT_L2TP_VERSION	= (1 << 2),	/* match L2TP protocol version */
+	XT_L2TP_ENCAP	= (1 << 3),	/* match L2TP encapsulation type */
+	XT_L2TP_TYPE	= (1 << 4),	/* match L2TP packet type */
+};
+
+
+#endif /* _LINUX_NETFILTER_XT_L2TP_H */
+
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 48acec1..12daddc 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1055,6 +1055,16 @@ config NETFILTER_XT_MATCH_IPVS
 
 	  If unsure, say N.
 
+config NETFILTER_XT_MATCH_L2TP
+	tristate '"l2tp" match support'
+	depends on NETFILTER_ADVANCED
+	default L2TP
+	---help---
+	This option adds an "L2TP" match, which allows you to match against
+	L2TP protocol header fields.
+
+	To compile it as a module, choose M here. If unsure, say N.
+
 config NETFILTER_XT_MATCH_LENGTH
 	tristate '"length" match support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 394483b..564bf35 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -135,6 +135,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HL) += xt_hl.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_IPRANGE) += xt_iprange.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_IPVS) += xt_ipvs.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_L2TP) += xt_l2tp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) += xt_length.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) += xt_limit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) += xt_mac.o
diff --git a/net/netfilter/xt_l2tp.c b/net/netfilter/xt_l2tp.c
new file mode 100644
index 0000000..f7804ca
--- /dev/null
+++ b/net/netfilter/xt_l2tp.c
@@ -0,0 +1,312 @@
+/* Kernel module to match L2TP header parameters. */
+
+/* (C) 2013      James Chapman <jchapman@katalix.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/if_ether.h>
+#include <net/ip.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#include <net/udp.h>
+#include <linux/l2tp.h>
+
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
+#include <linux/netfilter/xt_l2tp.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
+MODULE_DESCRIPTION("Xtables: L2TP header match");
+MODULE_ALIAS("ipt_l2tp");
+MODULE_ALIAS("ip6t_l2tp");
+
+/* The L2TP fields that can be matched */
+struct l2tp_data {
+	u32 tid;
+	u32 sid;
+	u8 type;
+	u8 version;
+	u8 encap;
+};
+
+static bool l2tp_match(const struct xt_l2tp_info *info, struct l2tp_data *data)
+{
+	pr_devel("%s: tid=%08x/%08x sid=%08x/%08x type=%d/%d encap=%d/%d ver=%d/%d\n",
+		 __func__,
+		 data->tid, (info->flags & XT_L2TP_TID) ? info->tid : 0,
+		 data->sid, (info->flags & XT_L2TP_SID) ? info->sid : 0,
+		 data->type, (info->flags & XT_L2TP_TYPE) ? info->type : 0,
+		 data->encap, (info->flags & XT_L2TP_ENCAP) ? info->encap : 0,
+		 data->version,
+		 (info->flags & XT_L2TP_VERSION) ? info->version : 0);
+
+	if (info->flags & XT_L2TP_TYPE)
+		if (info->type != data->type)
+			return false;
+
+	if (info->flags & XT_L2TP_ENCAP)
+		if (info->encap != data->encap)
+			return false;
+
+	if (info->flags & XT_L2TP_VERSION)
+		if (info->version != data->version)
+			return false;
+
+	/* Check tid only for L2TPv3 control or any L2TPv2 packets */
+	if ((info->flags & XT_L2TP_TID) &&
+	    ((data->type == XT_L2TP_TYPE_CONTROL) || (data->version == 2)))
+		if (info->tid != data->tid)
+			return false;
+
+	/* Check sid only for L2TP data packets */
+	if ((info->flags & XT_L2TP_SID) &&
+	    (data->type == XT_L2TP_TYPE_DATA))
+		if (info->sid != data->sid)
+			return false;
+
+	pr_devel("%s: match\n", __func__);
+
+	return true;
+}
+
+/* Parse L2TP header fields when UDP encapsulation is used. Handles
+ * L2TPv2 and L2TPv3.
+ *
+ * L2TPv2:
+ *  0                   1                   2                   3
+ *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |T|L|x|x|S|x|O|P|x|x|x|x|  Ver  |          Length (opt)         |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |           Tunnel ID           |           Session ID          |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |             Ns (opt)          |             Nr (opt)          |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |      Offset Size (opt)        |    Offset pad... (opt)
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * L2TPv3 control packets:
+ *  0                   1                   2                   3
+ *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |T|L|x|x|S|x|x|x|x|x|x|x|  Ver  |             Length            |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                     Control Connection ID                     |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |               Ns              |               Nr              |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * L2TPv3 data packets:
+ *  0                   1                   2                   3
+ *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |T|x|x|x|x|x|x|x|x|x|x|x|  Ver  |          Reserved             |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                           Session ID                          |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |               Cookie (optional, maximum 64 bits)...
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *                                                                 |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ */
+static bool l2tp_udp_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_l2tp_info *info = par->matchinfo;
+	int uhlen = sizeof(struct udphdr);
+	int offs = par->thoff + uhlen;
+	bool ret;
+	__be16 l2tp_flags;
+	__be32 v3_id;
+	__be16 v2_tid;
+	__be16 v2_sid;
+	u16 flags;
+	struct l2tp_data data = { 0, };
+
+	/* We need to read 8 bytes beyond the UDP header */
+	if (skb_headlen(skb) < (offs + 8))
+		return false;
+
+	/* Extract L2TP header fields. This is different for L2TPv2
+	 * (rfc2661) and L2TPv3 (rfc3931).
+	 */
+	if (skb_copy_bits(skb, offs, &l2tp_flags, sizeof(l2tp_flags)) < 0)
+		BUG();
+	flags = ntohs(l2tp_flags);
+	if (flags & 0x8000)
+		data.type = XT_L2TP_TYPE_CONTROL;
+	else
+		data.type = XT_L2TP_TYPE_DATA;
+	data.version = (u8) flags & 0x000f;
+	data.encap = XT_L2TP_ENCAP_UDP;
+	if (data.version == 3) {
+		if (skb_copy_bits(skb, offs + 4, &v3_id, sizeof(v3_id)) < 0)
+			BUG();
+		if (data.type == XT_L2TP_TYPE_CONTROL)
+			data.tid = ntohl(v3_id);
+		else
+			data.sid = ntohl(v3_id);
+	} else if (data.version == 2) {
+		if (flags & 0x4000)
+			offs += 2;
+		if (skb_copy_bits(skb, offs + 2, &v2_tid, sizeof(v2_tid)) < 0)
+			BUG();
+		data.tid = (u32) ntohs(v2_tid);
+		if (skb_copy_bits(skb, offs + 4, &v2_sid, sizeof(v2_sid)) < 0)
+			BUG();
+		data.sid = (u32) ntohs(v2_sid);
+	} else
+		return false;
+
+	ret = l2tp_match(info, &data);
+
+	return ret;
+}
+
+/* Parse L2TP header fields when IP encapsulation (no UDP header).
+ *
+ * L2TPv3 control packets:
+ *  0                   1                   2                   3
+ *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                      (32 bits of zeros)                       |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |T|L|x|x|S|x|x|x|x|x|x|x|  Ver  |             Length            |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                     Control Connection ID                     |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |               Ns              |               Nr              |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * L2TPv3 data packets:
+ *  0                   1                   2                   3
+ *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                           Session ID                          |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |               Cookie (optional, maximum 64 bits)...
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *                                                                 |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ */
+static bool l2tp_ip_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_l2tp_info *info = par->matchinfo;
+	bool ret;
+	__be32 v3_tid;
+	__be32 v3_sid;
+	struct l2tp_data data = { 0, };
+
+	/* We need to read 4 bytes beyond the IP header */
+	if (skb_headlen(skb) < (par->thoff + 4))
+		return false;
+
+	/* Extract L2TP header fields. This is simpler than the UDP
+	 * case because we don't need to handle L2TPv2 here - IP encap
+	 * is not used in L2TPv2.
+	 */
+	if (skb_copy_bits(skb, par->thoff, &v3_sid, sizeof(v3_sid)) < 0)
+		BUG();
+	data.sid = ntohl(v3_sid);
+	if (v3_sid == 0) {
+		data.type = XT_L2TP_TYPE_CONTROL;
+		if (skb_headlen(skb) < (par->thoff + 12))
+			return false;
+		if (skb_copy_bits(skb, par->thoff + 8, &v3_tid,
+				  sizeof(v3_tid)) < 0)
+			BUG();
+		data.tid = ntohl(v3_tid);
+	} else
+		data.type = XT_L2TP_TYPE_DATA;
+
+	data.version = 3;
+	data.encap = XT_L2TP_ENCAP_IP;
+
+	ret = l2tp_match(info, &data);
+
+	return ret;
+}
+
+static bool l2tp_mt_common(const struct sk_buff *skb, struct xt_action_param *par, u8 ipproto)
+{
+	bool ret;
+
+	/* The L2TP header is different depending on whether UDP or IP
+	 * encapsulation is used.
+	 */
+	switch (ipproto) {
+	case IPPROTO_UDP:
+		ret = l2tp_udp_mt(skb, par);
+		break;
+	case IPPROTO_L2TP:
+		ret = l2tp_ip_mt(skb, par);
+		break;
+	default:
+		return false;
+	}
+
+	return ret;
+}
+
+static bool l2tp_mt4(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	struct iphdr *iph = ip_hdr(skb);
+	u8 ipproto = iph->protocol;
+
+	return l2tp_mt_common(skb, par, ipproto);
+}
+
+static bool l2tp_mt6(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	u8 ipproto = ip6h->nexthdr;
+
+	return l2tp_mt_common(skb, par, ipproto);
+}
+
+static struct xt_match l2tp_mt_reg[] __read_mostly = {
+	{
+		.name      = "l2tp",
+		.revision  = 0,
+		.family    = NFPROTO_IPV4,
+		.match     = l2tp_mt4,
+		.matchsize = XT_ALIGN(sizeof(struct xt_l2tp_info)),
+		.hooks     = ((1 << NF_INET_PRE_ROUTING) |
+			      (1 << NF_INET_LOCAL_IN) |
+			      (1 << NF_INET_LOCAL_OUT) |
+			      (1 << NF_INET_FORWARD)),
+		.me        = THIS_MODULE,
+	},
+	{
+		.name      = "l2tp",
+		.revision  = 0,
+		.family    = NFPROTO_IPV6,
+		.match     = l2tp_mt6,
+		.matchsize = XT_ALIGN(sizeof(struct xt_l2tp_info)),
+		.hooks     = ((1 << NF_INET_PRE_ROUTING) |
+			      (1 << NF_INET_LOCAL_IN) |
+			      (1 << NF_INET_LOCAL_OUT) |
+			      (1 << NF_INET_FORWARD)),
+		.me        = THIS_MODULE,
+	},
+};
+
+static int __init l2tp_mt_init(void)
+{
+	return xt_register_matches(&l2tp_mt_reg[0], ARRAY_SIZE(l2tp_mt_reg));
+}
+
+static void __exit l2tp_mt_exit(void)
+{
+	xt_unregister_matches(&l2tp_mt_reg[0], ARRAY_SIZE(l2tp_mt_reg));
+}
+
+module_init(l2tp_mt_init);
+module_exit(l2tp_mt_exit);
-- 
1.7.0.4

