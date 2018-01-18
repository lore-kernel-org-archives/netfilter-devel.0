From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [iptables] extensions: add support for inner IPv6 packet 'inner6' match
Date: Thu, 18 Jan 2018 16:13:24 +0100
Message-ID: <1516288405-4582-1-git-send-email-amsalam20@gmail.com>
Cc: netdev@vger.kernel.org, kadlec@blackhole.kfki.hu,
        uznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, amsalam20@gmail.com
To: pablo@netfilter.org, davem@davemloft.net, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34983 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932549AbeARPNh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jan 2018 10:13:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new exetension to iptables to inner IPv6
packet 'inner6' match.

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 extensions/libip6t_inner6.c                | 111 +++++++++++++++++++++++++++++
 extensions/libip6t_inner6.t                |   4 ++
 include/linux/netfilter_ipv6/ip6t_inner6.h |  20 ++++++
 3 files changed, 135 insertions(+)
 create mode 100644 extensions/libip6t_inner6.c
 create mode 100644 extensions/libip6t_inner6.t
 create mode 100644 include/linux/netfilter_ipv6/ip6t_inner6.h

diff --git a/extensions/libip6t_inner6.c b/extensions/libip6t_inner6.c
new file mode 100644
index 0000000..096a913
--- /dev/null
+++ b/extensions/libip6t_inner6.c
@@ -0,0 +1,111 @@
+/* Shared library to add inner IPv6 packet matching support.
+ *
+ * Author:
+ *       Ahmed Abdelsalam       <amsalam20@gmail.com>
+ */
+
+#include <stdio.h>
+#include <xtables.h>
+#include <linux/netfilter_ipv6/ip6t_inner6.h>
+#include <string.h>
+
+/* inner6 command-line options */
+enum {
+	O_INNER6_SRC,
+	O_INNER6_DST,
+};
+
+static void inner6_help(void)
+{
+	printf(
+"srh match options:\n"
+"[!] --inner6-src	ip6_addr[/mask]	Source address of inner IPv6 packet\n"
+"[!] --inner6-dst	ip6_addr[/mask]	Destination address of inner IPv6 packet\n");
+}
+
+#define s struct ip6t_inner6
+static const struct xt_option_entry inner6_opts[] = {
+	{ .name = "inner6-src", .id = O_INNER6_SRC, .type = XTTYPE_HOSTMASK,
+	.flags = XTOPT_INVERT},
+	{ .name = "inner6-dst", .id = O_INNER6_DST, .type = XTTYPE_HOSTMASK,
+	.flags = XTOPT_INVERT},
+	{ }
+};
+#undef s
+
+static void inner6_init(struct xt_entry_match *m)
+{
+	struct ip6t_inner6 *inner6info = (void *)m->data;
+
+	inner6info->invflags = 0;
+}
+
+static void inner6_parse(struct xt_option_call *cb)
+{
+	struct ip6t_inner6 *inner6info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_INNER6_SRC:
+		inner6info->inner_src = cb->val.haddr.in6;
+		inner6info->inner_smsk = cb->val.hmask.in6;
+		if (cb->invert)
+			inner6info->invflags |= IP6T_INNER6_INV_SRC;
+		break;
+	case O_INNER6_DST:
+		inner6info->inner_dst = cb->val.haddr.in6;
+		inner6info->inner_dmsk = cb->val.hmask.in6;
+		if (cb->invert)
+			inner6info->invflags |= IP6T_INNER6_INV_DST;
+		break;
+	}
+}
+
+static void inner6_print(const void *ip, const struct xt_entry_match *match,
+			int numeric)
+{
+	const struct ip6t_inner6 *inner6info = (struct ip6t_inner6 *)match->data;
+
+	printf(" inner6 inner6-src %s %s/%u",
+		inner6info->invflags & IP6T_INNER6_INV_SRC ? "!" : "",
+		xtables_ip6addr_to_numeric(&inner6info->inner_src),
+		xtables_ip6mask_to_cidr(&inner6info->inner_smsk));
+	 printf(" inner6-dst %s %s/%u",
+		inner6info->invflags & IP6T_INNER6_INV_DST ? "!" : "",
+		xtables_ip6addr_to_numeric(&inner6info->inner_dst),
+		xtables_ip6mask_to_cidr(&inner6info->inner_dmsk));
+}
+
+static void inner6_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct ip6t_inner6 *inner6info = (struct ip6t_inner6 *)match->data;
+
+	printf("%s --inner6-src %s/%u",
+		inner6info->invflags & IP6T_INNER6_INV_SRC ? " !" : "",
+		xtables_ip6addr_to_numeric(&inner6info->inner_src),
+		xtables_ip6mask_to_cidr(&inner6info->inner_smsk));
+	 printf("%s --inner6-dst %s/%u",
+		inner6info->invflags & IP6T_INNER6_INV_DST ? " !" : "",
+		xtables_ip6addr_to_numeric(&inner6info->inner_dst),
+		xtables_ip6mask_to_cidr(&inner6info->inner_dmsk));
+}
+
+static struct xtables_match inner6_mt6_reg = {
+	.name          = "inner6",
+	.version       = XTABLES_VERSION,
+	.family        = NFPROTO_IPV6,
+	.size          = XT_ALIGN(sizeof(struct ip6t_inner6)),
+	.userspacesize = XT_ALIGN(sizeof(struct ip6t_inner6)),
+	.help          = inner6_help,
+	.init          = inner6_init,
+	.print         = inner6_print,
+	.save          = inner6_save,
+	.x6_parse      = inner6_parse,
+	.x6_options    = inner6_opts,
+};
+
+void
+_init(void)
+{
+	xtables_register_match(&inner6_mt6_reg);
+}
diff --git a/extensions/libip6t_inner6.t b/extensions/libip6t_inner6.t
new file mode 100644
index 0000000..d3d33a5
--- /dev/null
+++ b/extensions/libip6t_inner6.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+-m inner6 --inner6-src a::2/64 --inner6-dst b::2/64;=;OK
+-m inner6 ! --inner6-src fc00:1::/64 ! --inner6-dst fc00:2::/64;=;OK
+-m inner6;=;OK
diff --git a/include/linux/netfilter_ipv6/ip6t_inner6.h b/include/linux/netfilter_ipv6/ip6t_inner6.h
new file mode 100644
index 0000000..f55b9f5
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_inner6.h
@@ -0,0 +1,20 @@
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
-- 
2.1.4

