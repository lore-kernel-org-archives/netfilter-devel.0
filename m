From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [iptables] extensions: add support for 'srh' match
Date: Fri, 29 Dec 2017 12:08:25 +0100
Message-ID: <1514545705-13868-1-git-send-email-amsalam20@gmail.com>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org, amsalam20@gmail.com
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds a new exetension to iptables to supprt 'srh' match
The implementation considers revision 7 of the SRH draft.
https://tools.ietf.org/html/draft-ietf-6man-segment-routing-header-07

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 extensions/libip6t_srh.c                | 283 ++++++++++++++++++++++++++++++++
 include/linux/netfilter_ipv6/ip6t_srh.h |  63 +++++++
 2 files changed, 346 insertions(+)
 create mode 100644 extensions/libip6t_srh.c
 create mode 100644 include/linux/netfilter_ipv6/ip6t_srh.h

diff --git a/extensions/libip6t_srh.c b/extensions/libip6t_srh.c
new file mode 100644
index 0000000..fd92ba1
--- /dev/null
+++ b/extensions/libip6t_srh.c
@@ -0,0 +1,283 @@
+/**
+ * Segment Routing Header 'srh' match extension
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
+"[!] --srh-next-hdr     next-hdr        Next Header value of SRH\n"
+"[!] --srh-len-eq       hdr_len         Hdr Ext Len value of SRH\n"
+"[!] --srh-len-gt       hdr_len         Hdr Ext Len value of SRH\n"
+"[!] --srh-len-lt       hdr_len         Hdr Ext Len value of SRH\n"
+"[!] --srh-segs-eq      segs_left       Segments Left value of SRH\n"
+"[!] --srh-segs-gt      segs_left       Segments Left value of SRH\n"
+"[!] --srh-segs-lt      segs_left       Segments Left value of SRH\n"
+"[!] --srh-last-eq      last_entry      Last Entry value of SRH\n"
+"[!] --srh-last-gt      last_entry      Last Entry value of SRH\n"
+"[!] --srh-last-lt      last_entry      Last Entry value of SRH\n"
+"[!] --srh-tag          tag             Tag value of SRH\n");
+}
+
+#define s struct ip6t_srh
+static const struct xt_option_entry srh_opts[] = {
+	{ .name = "srh-next-hdr", .id = O_SRH_NEXTHDR, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, next_hdr)},
+	{ .name = "srh-len-eq",	.id = O_SRH_LEN_EQ, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, hdr_len)},
+	{ .name = "srh-len-gt", .id = O_SRH_LEN_GT, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, hdr_len)},
+	{ .name = "srh-len-lt", .id = O_SRH_LEN_LT, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, hdr_len)},
+	{ .name = "srh-segs-eq", .id = O_SRH_SEGS_EQ, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, segs_left)},
+	{ .name = "srh-segs-gt", .id = O_SRH_SEGS_GT, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, segs_left)},
+	{ .name = "srh-segs-lt", .id = O_SRH_SEGS_LT, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, segs_left)},
+	{ .name = "srh-last-eq", .id = O_SRH_LAST_EQ, .type = XTTYPE_UINT8,
+	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, last_entry)},
+	{ .name = "srh-last-gt", .id = O_SRH_LAST_GT, .type = XTTYPE_UINT8,
+	flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, last_entry)},
+	{ .name = "srh-last-lt", .id = O_SRH_LAST_LT, .type = XTTYPE_UINT8,
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
+static const char *pinv(bool invert)
+{
+	const char *inv = invert ? "!" : " ";
+	return inv;
+}
+
+static void srh_print(const void *ip, const struct xt_entry_match *match,
+			int numeric)
+{
+	const struct ip6t_srh *srhinfo = (struct ip6t_srh *)match->data;
+
+	printf(" srh ");
+
+	if (srhinfo->mt_flags & IP6T_SRH_NEXTHDR)
+		printf("next-hdr %s=%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_NEXTHDR),
+			srhinfo->next_hdr);
+
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_EQ)
+		printf("hdr-len %s=%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LEN_EQ),
+			srhinfo->hdr_len);
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_GT)
+		printf("hdr-len %s>%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LEN_GT),
+			srhinfo->hdr_len);
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_LT)
+		printf("hdr-len %s<%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LEN_LT),
+			srhinfo->hdr_len);
+
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_EQ)
+		printf("segs-left %s=%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_EQ),
+			srhinfo->segs_left);
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_GT)
+		printf("segs-left %s>%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_GT),
+			srhinfo->segs_left);
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_LT)
+		printf("segs-left %s<%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_LT),
+			srhinfo->segs_left);
+
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_EQ)
+		printf("last-entry %s=%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LAST_EQ),
+			srhinfo->last_entry);
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_GT)
+		printf("last-entry %s>%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LAST_GT),
+			srhinfo->last_entry);
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_LT)
+		printf("last-entry %s<%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LAST_LT),
+			srhinfo->last_entry);
+
+	if (srhinfo->mt_flags  & IP6T_SRH_TAG)
+		printf("tag %s=%d ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_TAG),
+			srhinfo->tag);
+
+}
+
+static void srh_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct ip6t_srh *srhinfo = (struct ip6t_srh *)match->data;
+
+	printf(" srh ");
+
+	if (srhinfo->mt_flags & IP6T_SRH_NEXTHDR)
+		printf("next-hdr %s=%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_NEXTHDR),
+			srhinfo->next_hdr);
+
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_EQ)
+		printf("hdr-len %s=%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LEN_EQ),
+			srhinfo->hdr_len);
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_GT)
+		printf("hdr-len %s>%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LEN_GT),
+			srhinfo->hdr_len);
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_LT)
+		printf("hdr-len %s<%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LEN_LT),
+			srhinfo->hdr_len);
+
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_EQ)
+		printf("segs-left %s=%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_EQ),
+			srhinfo->segs_left);
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_GT)
+		printf("segs-left %s>%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_GT),
+			srhinfo->segs_left);
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_LT)
+		printf("segs-left %s<%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_SEGS_LT),
+			srhinfo->segs_left);
+
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_EQ)
+		printf("last-entry %s=%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LAST_EQ),
+			srhinfo->last_entry);
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_GT)
+		printf("last-entry %s>%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LAST_GT),
+			srhinfo->last_entry);
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_LT)
+		printf("last-entry %s<%d  ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_LAST_LT),
+			srhinfo->last_entry);
+
+	if (srhinfo->mt_flags  & IP6T_SRH_TAG)
+		printf("tag %s=%d ",
+			pinv(srhinfo->mt_invflags & IP6T_SRH_INV_TAG),
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
diff --git a/include/linux/netfilter_ipv6/ip6t_srh.h b/include/linux/netfilter_ipv6/ip6t_srh.h
new file mode 100644
index 0000000..bc27197
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_srh.h
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
-- 
2.1.4
