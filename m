From: kaber@trash.net
Subject: [PATCH 7/7] extensions: add NPT extension
Date: Thu,  9 Aug 2012 22:11:13 +0200
Message-ID: <1344543073-11660-8-git-send-email-kaber@trash.net>
References: <1344543073-11660-1-git-send-email-kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65354 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2HIUXf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:23:35 -0400
Received: from gw.localnet (localhost [127.0.0.1])
	by stinky.trash.net (Postfix) with ESMTP id 1B0A2B2C65
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Aug 2012 22:11:17 +0200 (MEST)
In-Reply-To: <1344543073-11660-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Add extensions for the SNPT and DNPT stateless IPv6-to-IPv6 Network Prefix
Translation targets.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 extensions/libip6t_DNPT.c               |   71 +++++++++++++++++++++++++++++++
 extensions/libip6t_SNPT.c               |   71 +++++++++++++++++++++++++++++++
 include/linux/netfilter_ipv6/ip6t_NPT.h |   16 +++++++
 3 files changed, 158 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libip6t_DNPT.c
 create mode 100644 extensions/libip6t_SNPT.c
 create mode 100644 include/linux/netfilter_ipv6/ip6t_NPT.h

diff --git a/extensions/libip6t_DNPT.c b/extensions/libip6t_DNPT.c
new file mode 100644
index 0000000..9e4dc5c
--- /dev/null
+++ b/extensions/libip6t_DNPT.c
@@ -0,0 +1,71 @@
+#include <stdio.h>
+#include <xtables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_NPT.h>
+
+enum {
+	O_SRC_PFX	= 1 << 0,
+	O_DST_PFX	= 1 << 1,
+};
+
+static const struct xt_option_entry SNPT_options[] = {
+	{ .name = "src-pfx", .id = O_SRC_PFX, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_MAND },
+	{ .name = "dst-pfx", .id = O_DST_PFX, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_MAND },
+	{ }
+};
+
+static void SNPT_help(void)
+{
+	printf("SNPT target options:"
+	       "\n"
+	       " --src-pfx prefix/length\n"
+	       " --dst-pfx prefix/length\n"
+	       "\n");
+}
+
+static void SNPT_parse(struct xt_option_call *cb)
+{
+	struct ip6t_npt_tginfo *npt = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SRC_PFX:
+		npt->src_pfx = cb->val.haddr;
+		npt->src_pfx_len = cb->val.hlen;
+		break;
+	case O_DST_PFX:
+		npt->dst_pfx = cb->val.haddr;
+		npt->dst_pfx_len = cb->val.hlen;
+		break;
+	}
+}
+
+static void SNPT_print(const void *ip, const struct xt_entry_target *target,
+		       int numeric)
+{
+	const struct ip6t_npt_tginfo *npt = (const void *)target->data;
+
+	printf("src-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->src_pfx.in6),
+				 npt->src_pfx_len);
+	printf("dst-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->dst_pfx.in6),
+				 npt->dst_pfx_len);
+}
+
+static struct xtables_target snpt_tg_reg = {
+	.name		= "DNPT",
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_IPV6,
+	.size		= XT_ALIGN(sizeof(struct ip6t_npt_tginfo)),
+	.userspacesize	= offsetof(struct ip6t_npt_tginfo, adjustment),
+	.help		= SNPT_help,
+	.x6_parse	= SNPT_parse,
+	.print		= SNPT_print,
+	.x6_options	= SNPT_options,
+};
+
+void _init(void)
+{
+	xtables_register_target(&snpt_tg_reg);
+}
diff --git a/extensions/libip6t_SNPT.c b/extensions/libip6t_SNPT.c
new file mode 100644
index 0000000..26a86c5
--- /dev/null
+++ b/extensions/libip6t_SNPT.c
@@ -0,0 +1,71 @@
+#include <stdio.h>
+#include <xtables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_NPT.h>
+
+enum {
+	O_SRC_PFX	= 1 << 0,
+	O_DST_PFX	= 1 << 1,
+};
+
+static const struct xt_option_entry SNPT_options[] = {
+	{ .name = "src-pfx", .id = O_SRC_PFX, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_MAND },
+	{ .name = "dst-pfx", .id = O_DST_PFX, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_MAND },
+	{ }
+};
+
+static void SNPT_help(void)
+{
+	printf("SNPT target options:"
+	       "\n"
+	       " --src-pfx prefix/length\n"
+	       " --dst-pfx prefix/length\n"
+	       "\n");
+}
+
+static void SNPT_parse(struct xt_option_call *cb)
+{
+	struct ip6t_npt_tginfo *npt = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SRC_PFX:
+		npt->src_pfx = cb->val.haddr;
+		npt->src_pfx_len = cb->val.hlen;
+		break;
+	case O_DST_PFX:
+		npt->dst_pfx = cb->val.haddr;
+		npt->dst_pfx_len = cb->val.hlen;
+		break;
+	}
+}
+
+static void SNPT_print(const void *ip, const struct xt_entry_target *target,
+		       int numeric)
+{
+	const struct ip6t_npt_tginfo *npt = (const void *)target->data;
+
+	printf("src-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->src_pfx.in6),
+				 npt->src_pfx_len);
+	printf("dst-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->dst_pfx.in6),
+				 npt->dst_pfx_len);
+}
+
+static struct xtables_target snpt_tg_reg = {
+	.name		= "SNPT",
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_IPV6,
+	.size		= XT_ALIGN(sizeof(struct ip6t_npt_tginfo)),
+	.userspacesize	= offsetof(struct ip6t_npt_tginfo, adjustment),
+	.help		= SNPT_help,
+	.x6_parse	= SNPT_parse,
+	.print		= SNPT_print,
+	.x6_options	= SNPT_options,
+};
+
+void _init(void)
+{
+	xtables_register_target(&snpt_tg_reg);
+}
diff --git a/include/linux/netfilter_ipv6/ip6t_NPT.h b/include/linux/netfilter_ipv6/ip6t_NPT.h
new file mode 100644
index 0000000..f763355
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_NPT.h
@@ -0,0 +1,16 @@
+#ifndef __NETFILTER_IP6T_NPT
+#define __NETFILTER_IP6T_NPT
+
+#include <linux/types.h>
+#include <linux/netfilter.h>
+
+struct ip6t_npt_tginfo {
+	union nf_inet_addr	src_pfx;
+	union nf_inet_addr	dst_pfx;
+	__u8			src_pfx_len;
+	__u8			dst_pfx_len;
+	/* Used internally by the kernel */
+	__sum16			adjustment;
+};
+
+#endif /* __NETFILTER_IP6T_NPT */
-- 
1.7.1

