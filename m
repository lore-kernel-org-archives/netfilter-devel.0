From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] libxt_addrtype: add support for revision 1
Date: Mon,  5 Sep 2011 20:24:39 +0200
Message-ID: <1315247081-12131-3-git-send-email-jengelh@medozas.de>
References: <1315247081-12131-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33389 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab1IESYt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:24:49 -0400
In-Reply-To: <1315247081-12131-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rev 1 was added to the kernel in commit v2.6.39-rc1~468^2~10^2~1 but
there was no corresponding iptables patch so far.

Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_addrtype.c           |   56 ++++++++++++++-------------------
 include/linux/netfilter/xt_addrtype.h |   44 ++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 32 deletions(-)
 create mode 100644 include/linux/netfilter/xt_addrtype.h

diff --git a/extensions/libxt_addrtype.c b/extensions/libxt_addrtype.c
index 3dec626..59072b3 100644
--- a/extensions/libxt_addrtype.c
+++ b/extensions/libxt_addrtype.c
@@ -4,7 +4,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <xtables.h>
-#include <linux/netfilter_ipv4/ipt_addrtype.h>
+#include <linux/netfilter/xt_addrtype.h>
 
 enum {
 	O_SRC_TYPE = 0,
@@ -98,7 +98,7 @@ static void parse_types(const char *arg, uint16_t *mask)
 	
 static void addrtype_parse_v0(struct xt_option_call *cb)
 {
-	struct ipt_addrtype_info *info = cb->data;
+	struct xt_addrtype_info *info = cb->data;
 
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
@@ -117,25 +117,25 @@ static void addrtype_parse_v0(struct xt_option_call *cb)
 
 static void addrtype_parse_v1(struct xt_option_call *cb)
 {
-	struct ipt_addrtype_info_v1 *info = cb->data;
+	struct xt_addrtype_info_v1 *info = cb->data;
 
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_SRC_TYPE:
 		parse_types(cb->arg, &info->source);
 		if (cb->invert)
-			info->flags |= IPT_ADDRTYPE_INVERT_SOURCE;
+			info->flags |= XT_ADDRTYPE_INVERT_SOURCE;
 		break;
 	case O_DST_TYPE:
 		parse_types(cb->arg, &info->dest);
 		if (cb->invert)
-			info->flags |= IPT_ADDRTYPE_INVERT_DEST;
+			info->flags |= XT_ADDRTYPE_INVERT_DEST;
 		break;
 	case O_LIMIT_IFACE_IN:
-		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_IN;
+		info->flags |= XT_ADDRTYPE_LIMIT_IFACE_IN;
 		break;
 	case O_LIMIT_IFACE_OUT:
-		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_OUT;
+		info->flags |= XT_ADDRTYPE_LIMIT_IFACE_OUT;
 		break;
 	}
 }
@@ -162,8 +162,7 @@ static void print_types(uint16_t mask)
 static void addrtype_print_v0(const void *ip, const struct xt_entry_match *match,
                               int numeric)
 {
-	const struct ipt_addrtype_info *info = 
-		(struct ipt_addrtype_info *) match->data;
+	const struct xt_addrtype_info *info = (const void *)match->data;
 
 	printf(" ADDRTYPE match");
 	if (info->source) {
@@ -183,34 +182,30 @@ static void addrtype_print_v0(const void *ip, const struct xt_entry_match *match
 static void addrtype_print_v1(const void *ip, const struct xt_entry_match *match,
                               int numeric)
 {
-	const struct ipt_addrtype_info_v1 *info = 
-		(struct ipt_addrtype_info_v1 *) match->data;
+	const struct xt_addrtype_info_v1 *info = (const void *)match->data;
 
 	printf(" ADDRTYPE match");
 	if (info->source) {
 		printf(" src-type ");
-		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
+		if (info->flags & XT_ADDRTYPE_INVERT_SOURCE)
 			printf("!");
 		print_types(info->source);
 	}
 	if (info->dest) {
 		printf(" dst-type ");
-		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
+		if (info->flags & XT_ADDRTYPE_INVERT_DEST)
 			printf("!");
 		print_types(info->dest);
 	}
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN)
 		printf(" limit-in");
-	}
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT)
 		printf(" limit-out");
-	}
 }
 
 static void addrtype_save_v0(const void *ip, const struct xt_entry_match *match)
 {
-	const struct ipt_addrtype_info *info =
-		(struct ipt_addrtype_info *) match->data;
+	const struct xt_addrtype_info *info = (const void *)match->data;
 
 	if (info->source) {
 		if (info->invert_source)
@@ -228,27 +223,24 @@ static void addrtype_save_v0(const void *ip, const struct xt_entry_match *match)
 
 static void addrtype_save_v1(const void *ip, const struct xt_entry_match *match)
 {
-	const struct ipt_addrtype_info_v1 *info =
-		(struct ipt_addrtype_info_v1 *) match->data;
+	const struct xt_addrtype_info_v1 *info = (const void *)match->data;
 
 	if (info->source) {
-		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
+		if (info->flags & XT_ADDRTYPE_INVERT_SOURCE)
 			printf(" !");
 		printf(" --src-type ");
 		print_types(info->source);
 	}
 	if (info->dest) {
-		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
+		if (info->flags & XT_ADDRTYPE_INVERT_DEST)
 			printf(" !");
 		printf(" --dst-type ");
 		print_types(info->dest);
 	}
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN)
 		printf(" --limit-iface-in");
-	}
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT)
 		printf(" --limit-iface-out");
-	}
 }
 
 static const struct xt_option_entry addrtype_opts_v0[] = {
@@ -276,8 +268,8 @@ static struct xtables_match addrtype_mt_reg[] = {
 		.name          = "addrtype",
 		.version       = XTABLES_VERSION,
 		.family        = NFPROTO_IPV4,
-		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
-		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
+		.size          = XT_ALIGN(sizeof(struct xt_addrtype_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_addrtype_info)),
 		.help          = addrtype_help_v0,
 		.print         = addrtype_print_v0,
 		.save          = addrtype_save_v0,
@@ -289,9 +281,9 @@ static struct xtables_match addrtype_mt_reg[] = {
 		.name          = "addrtype",
 		.revision      = 1,
 		.version       = XTABLES_VERSION,
-		.family        = NFPROTO_IPV4,
-		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
-		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
+		.family        = NFPROTO_UNSPEC,
+		.size          = XT_ALIGN(sizeof(struct xt_addrtype_info_v1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_addrtype_info_v1)),
 		.help          = addrtype_help_v1,
 		.print         = addrtype_print_v1,
 		.save          = addrtype_save_v1,
diff --git a/include/linux/netfilter/xt_addrtype.h b/include/linux/netfilter/xt_addrtype.h
new file mode 100644
index 0000000..b156baa
--- /dev/null
+++ b/include/linux/netfilter/xt_addrtype.h
@@ -0,0 +1,44 @@
+#ifndef _XT_ADDRTYPE_H
+#define _XT_ADDRTYPE_H
+
+#include <linux/types.h>
+
+enum {
+	XT_ADDRTYPE_INVERT_SOURCE	= 0x0001,
+	XT_ADDRTYPE_INVERT_DEST		= 0x0002,
+	XT_ADDRTYPE_LIMIT_IFACE_IN	= 0x0004,
+	XT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
+};
+
+
+/* rtn_type enum values from rtnetlink.h, but shifted */
+enum {
+	XT_ADDRTYPE_UNSPEC = 1 << 0,
+	XT_ADDRTYPE_UNICAST = 1 << 1,	/* 1 << RTN_UNICAST */
+	XT_ADDRTYPE_LOCAL  = 1 << 2,	/* 1 << RTN_LOCAL, etc */
+	XT_ADDRTYPE_BROADCAST = 1 << 3,
+	XT_ADDRTYPE_ANYCAST = 1 << 4,
+	XT_ADDRTYPE_MULTICAST = 1 << 5,
+	XT_ADDRTYPE_BLACKHOLE = 1 << 6,
+	XT_ADDRTYPE_UNREACHABLE = 1 << 7,
+	XT_ADDRTYPE_PROHIBIT = 1 << 8,
+	XT_ADDRTYPE_THROW = 1 << 9,
+	XT_ADDRTYPE_NAT = 1 << 10,
+	XT_ADDRTYPE_XRESOLVE = 1 << 11,
+};
+
+struct xt_addrtype_info_v1 {
+	__u16	source;		/* source-type mask */
+	__u16	dest;		/* dest-type mask */
+	__u32	flags;
+};
+
+/* revision 0 */
+struct xt_addrtype_info {
+	__u16	source;		/* source-type mask */
+	__u16	dest;		/* dest-type mask */
+	__u32	invert_source;
+	__u32	invert_dest;
+};
+
+#endif
-- 
1.7.3.4

