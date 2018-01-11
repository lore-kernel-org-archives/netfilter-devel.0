From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [iptables v2] extensions: add support for 'srh' match
Date: Thu, 11 Jan 2018 18:12:41 +0100
Message-ID: <1515690761-4836-1-git-send-email-amsalam20@gmail.com>
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, amsalam20@gmail.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36749 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbeAKRMu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 12:12:50 -0500
Received: by mail-wm0-f67.google.com with SMTP id b76so6877397wmg.1
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2018 09:12:49 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new exetension to iptables to supprt 'srh' match
The implementation considers revision 7 of the SRH draft.
https://tools.ietf.org/html/draft-ietf-6man-segment-routing-header-07

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 extensions/libip6t_srh.c                | 242 ++++++++++++++++++++++++++++++++
 extensions/libip6t_srh.t                |  26 ++++
 include/linux/netfilter_ipv6/ip6t_srh.h |  56 ++++++++
 3 files changed, 324 insertions(+)
 create mode 100644 extensions/libip6t_srh.c
 create mode 100644 extensions/libip6t_srh.t
 create mode 100644 include/linux/netfilter_ipv6/ip6t_srh.h

diff --git a/extensions/libip6t_srh.c b/extensions/libip6t_srh.c
new file mode 100644
index 0000000..ac0ae08
--- /dev/null
+++ b/extensions/libip6t_srh.c
@@ -0,0 +1,242 @@
+/* Shared library to add Segment Routing Header (SRH) matching support.
+ *
+ * Author:
+ *       Ahmed Abdelsalam       <amsalam20@gmail.com>
+ */
+
+#include <stdio.h>
+#include <xtables.h>
+#include <linux/netfilter_ipv6/ip6t_srh.h>
+#include <string.h>
+
+/* srh command-line options */
+enum {
+	O_SRH_NEXTHDR,
+	O_SRH_LEN_EQ,
+	O_SRH_LEN_GT,
+	O_SRH_LEN_LT,
+	O_SRH_SEGS_EQ,
+	O_SRH_SEGS_GT,
+	O_SRH_SEGS_LT,
+	O_SRH_LAST_EQ,
+	O_SRH_LAST_GT,
+	O_SRH_LAST_LT,
+	O_SRH_TAG,
+};
+
+static void srh_help(void)
+{
+	printf(
+"srh match options:\n"
+"[!] --srh-next-hdr		next-hdr        Next Header value of SRH\n"
+"[!] --srh-hdr-len-eq		hdr_len         Hdr Ext Len value of SRH\n"
+"[!] --srh-hdr-len-gt		hdr_len         Hdr Ext Len value of SRH\n"
+"[!] --srh-hdr-len-lt		hdr_len         Hdr Ext Len value of SRH\n"
+"[!] --srh-segs-left-eq		segs_left       Segments Left value of SRH\n"
+"[!] --srh-segs-left-gt		segs_left       Segments Left value of SRH\n"
+"[!] --srh-segs-left-lt		segs_left       Segments Left value of SRH\n"
+"[!] --srh-last-entry-eq 	last_entry      Last Entry value of SRH\n"
+"[!] --srh-last-entry-gt 	last_entry      Last Entry value of SRH\n"
+"[!] --srh-last-entry-lt 	last_entry      Last Entry value of SRH\n"
+"[!] --srh-tag			tag             Tag value of SRH\n");
+}
+
+#define s struct ip6t_srh
+static const struct xt_option_entry srh_opts[] = {
+	{ .name = "srh-next-hdr", .id = O_SRH_NEXTHDR, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, next_hdr)},
+	{ .name = "srh-hdr-len-eq", .id = O_SRH_LEN_EQ, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, hdr_len)},
+	{ .name = "srh-hdr-len-gt", .id = O_SRH_LEN_GT, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, hdr_len)},
+	{ .name = "srh-hdr-len-lt", .id = O_SRH_LEN_LT, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, hdr_len)},
+	{ .name = "srh-segs-left-eq", .id = O_SRH_SEGS_EQ, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, segs_left)},
+	{ .name = "srh-segs-left-gt", .id = O_SRH_SEGS_GT, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, segs_left)},
+	{ .name = "srh-segs-left-lt", .id = O_SRH_SEGS_LT, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, segs_left)},
+	{ .name = "srh-last-entry-eq", .id = O_SRH_LAST_EQ, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, last_entry)},
+	{ .name = "srh-last-entry-gt", .id = O_SRH_LAST_GT, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, last_entry)},
+	{ .name = "srh-last-entry-lt", .id = O_SRH_LAST_LT, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, last_entry)},
+	{ .name = "srh-tag", .id = O_SRH_TAG, .type = XTTYPE_UINT16,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, tag)},
+	{ }
+};
+#undef s
+
+static void srh_init(struct xt_entry_match *m)
+{
+	struct ip6t_srh *srhinfo = (void *)m->data;
+
+	srhinfo->mt_flags = 0;
+	srhinfo->mt_invflags = 0;
+}
+
+static void srh_parse(struct xt_option_call *cb)
+{
+	struct ip6t_srh *srhinfo = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SRH_NEXTHDR:
+		srhinfo->mt_flags |= IP6T_SRH_NEXTHDR;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_NEXTHDR;
+		break;
+	case O_SRH_LEN_EQ:
+		srhinfo->mt_flags |= IP6T_SRH_LEN_EQ;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_LEN_EQ;
+		break;
+	case O_SRH_LEN_GT:
+		srhinfo->mt_flags |= IP6T_SRH_LEN_GT;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_LEN_GT;
+		break;
+	case O_SRH_LEN_LT:
+		srhinfo->mt_flags |= IP6T_SRH_LEN_LT;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_LEN_LT;
+		break;
+	case O_SRH_SEGS_EQ:
+		srhinfo->mt_flags |= IP6T_SRH_SEGS_EQ;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_SEGS_EQ;
+		break;
+	case O_SRH_SEGS_GT:
+		srhinfo->mt_flags |= IP6T_SRH_SEGS_GT;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_SEGS_GT;
+		break;
+	case O_SRH_SEGS_LT:
+		srhinfo->mt_flags |= IP6T_SRH_SEGS_LT;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_SEGS_LT;
+		break;
+	case O_SRH_LAST_EQ:
+		srhinfo->mt_flags |= IP6T_SRH_LAST_EQ;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_LAST_EQ;
+		break;
+	case O_SRH_LAST_GT:
+		srhinfo->mt_flags |= IP6T_SRH_LAST_GT;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_LAST_GT;
+		break;
+	case O_SRH_LAST_LT:
+		srhinfo->mt_flags |= IP6T_SRH_LAST_LT;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_LAST_LT;
+		break;
+	case O_SRH_TAG:
+		srhinfo->mt_flags |= IP6T_SRH_TAG;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_TAG;
+		break;
+	}
+}
+
+static void srh_print(const void *ip, const struct xt_entry_match *match,
+			int numeric)
+{
+	const struct ip6t_srh *srhinfo = (struct ip6t_srh *)match->data;
+
+	printf(" srh");
+	if (srhinfo->mt_flags & IP6T_SRH_NEXTHDR)
+		printf(" next-hdr:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_NEXTHDR ? "!" : "",
+			srhinfo->next_hdr);
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_EQ)
+		printf(" hdr-len-eq:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_LEN_EQ ? "!" : "",
+			srhinfo->hdr_len);
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_GT)
+		printf(" hdr-len-gt:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_LEN_GT ? "!" : "",
+			srhinfo->hdr_len);
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_LT)
+		printf(" hdr-len-lt:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_LEN_LT ? "!" : "",
+			srhinfo->hdr_len);
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_EQ)
+		printf(" segs-left-eq:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_EQ ? "!" : "",
+			srhinfo->segs_left);
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_GT)
+		printf(" segs-left-gt:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_GT ? "!" : "",
+			srhinfo->segs_left);
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_LT)
+		printf(" segs-left-lt:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_LT ? "!" : "",
+			srhinfo->segs_left);
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_EQ)
+		printf(" last-entry-eq:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_LAST_EQ ? "!" : "",
+			srhinfo->last_entry);
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_GT)
+		printf(" last-entry-gt:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_LAST_GT ? "!" : "",
+			srhinfo->last_entry);
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_LT)
+		printf(" last-entry-lt:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_LAST_LT ? "!" : "",
+			srhinfo->last_entry);
+	if (srhinfo->mt_flags & IP6T_SRH_TAG)
+		printf(" tag:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_TAG ? "!" : "",
+			srhinfo->tag);
+}
+
+static void srh_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct ip6t_srh *srhinfo = (struct ip6t_srh *)match->data;
+
+	if (srhinfo->mt_flags & IP6T_SRH_NEXTHDR)
+		printf("%s --srh-next-hdr %u", (srhinfo->mt_invflags & IP6T_SRH_INV_NEXTHDR) ? " !" : "",
+			srhinfo->next_hdr);
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_EQ)
+		printf("%s --srh-hdr-len-eq %u", (srhinfo->mt_invflags & IP6T_SRH_INV_LEN_EQ) ? " !" : "",
+			srhinfo->hdr_len);
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_GT)
+		printf("%s --srh-hdr-len-gt %u", (srhinfo->mt_invflags & IP6T_SRH_INV_LEN_GT) ? " !" : "",
+			srhinfo->hdr_len);
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_LT)
+		printf("%s --srh-hdr-len-lt %u", (srhinfo->mt_invflags & IP6T_SRH_INV_LEN_LT) ? " !" : "",
+			srhinfo->hdr_len);
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_EQ)
+		printf("%s --srh-segs-left-eq %u", (srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_EQ) ? " !" : "",
+			srhinfo->segs_left);
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_GT)
+		printf("%s --srh-segs-left-gt %u", (srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_GT) ? " !" : "",
+			srhinfo->segs_left);
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_LT)
+		printf("%s --srh-segs-left-lt %u", (srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_LT) ? " !" : "",
+			srhinfo->segs_left);
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_EQ)
+		printf("%s --srh-last-entry-eq %u", (srhinfo->mt_invflags & IP6T_SRH_INV_LAST_EQ) ? " !" : "",
+			srhinfo->last_entry);
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_GT)
+		printf("%s --srh-last-entry-gt %u", (srhinfo->mt_invflags & IP6T_SRH_INV_LAST_GT) ? " !" : "",
+			srhinfo->last_entry);
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_LT)
+		printf("%s --srh-last-entry-lt %u", (srhinfo->mt_invflags & IP6T_SRH_INV_LAST_LT) ? " !" : "",
+			srhinfo->last_entry);
+	if (srhinfo->mt_flags & IP6T_SRH_TAG)
+		printf("%s --srh-tag %u", (srhinfo->mt_invflags & IP6T_SRH_INV_TAG) ? " !" : "",
+			srhinfo->tag);
+}
+
+static struct xtables_match srh_mt6_reg = {
+	.name          = "srh",
+	.version       = XTABLES_VERSION,
+	.family        = NFPROTO_IPV6,
+	.size          = XT_ALIGN(sizeof(struct ip6t_srh)),
+	.userspacesize = XT_ALIGN(sizeof(struct ip6t_srh)),
+	.help          = srh_help,
+	.init          = srh_init,
+	.print         = srh_print,
+	.save          = srh_save,
+	.x6_parse      = srh_parse,
+	.x6_options    = srh_opts,
+};
+
+void
+_init(void)
+{
+	xtables_register_match(&srh_mt6_reg);
+}
diff --git a/extensions/libip6t_srh.t b/extensions/libip6t_srh.t
new file mode 100644
index 0000000..08897d5
--- /dev/null
+++ b/extensions/libip6t_srh.t
@@ -0,0 +1,26 @@
+:INPUT,FORWARD,OUTPUT
+-m srh --srh-next-hdr 17;=;OK
+-m srh --srh-hdr-len-eq 8;=;OK
+-m srh --srh-hdr-len-gt 8;=;OK
+-m srh --srh-hdr-len-lt 8;=;OK
+-m srh --srh-segs-left-eq 1;=;OK
+-m srh --srh-segs-left-gt 1;=;OK
+-m srh --srh-segs-left-lt 1;=;OK
+-m srh --srh-last-entry-eq 4;=;OK
+-m srh --srh-last-entry-gt 4;=;OK
+-m srh --srh-last-entry-lt 4;=;OK
+-m srh --srh-tag 0;=;OK
+-m srh ! --srh-next-hdr 17;=;OK
+-m srh ! --srh-hdr-len-eq 8;=;OK
+-m srh ! --srh-hdr-len-gt 8;=;OK
+-m srh ! --srh-hdr-len-lt 8;=;OK
+-m srh ! --srh-segs-left-eq 1;=;OK
+-m srh ! --srh-segs-left-gt 1;=;OK
+-m srh ! --srh-segs-left-lt 1;=;OK
+-m srh ! --srh-last-entry-eq 4;=;OK
+-m srh ! --srh-last-entry-gt 4;=;OK
+-m srh ! --srh-last-entry-lt 4;=;OK
+-m srh ! --srh-tag 0;=;OK
+-m srh --srh-next-hdr 17 --srh-segs-left-eq 1 --srh-last-entry-eq 4 --srh-tag 0;=;OK
+-m srh ! --srh-next-hdr 17 ! --srh-segs-left-eq 0 --srh-tag 0;=;OK
+-m srh;=;OK
diff --git a/include/linux/netfilter_ipv6/ip6t_srh.h b/include/linux/netfilter_ipv6/ip6t_srh.h
new file mode 100644
index 0000000..087efa1
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_srh.h
@@ -0,0 +1,56 @@
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
-- 
2.1.4

