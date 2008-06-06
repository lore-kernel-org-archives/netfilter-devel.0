From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH] addrtype match: added revision 1
Date: Fri,  6 Jun 2008 14:01:50 +0200
Message-ID: <1212753710-22423-1-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:59654 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752633AbYFFMWQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:22:16 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id AA76D39D319
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Jun 2008 14:01:52 +0200 (CEST)
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In revision 1 address type checking can be limited to either the incoming
or outgoing interface depending on the current chain. In the FORWARD chain
only one of them is allowed at the same time.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 extensions/libipt_addrtype.c                |  188 ++++++++++++++++++++++++--
 extensions/libipt_addrtype.man              |   34 +++++-
 include/linux/netfilter_ipv4/ipt_addrtype.h |   14 ++
 3 files changed, 220 insertions(+), 16 deletions(-)

diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index 9611c39..97ad804 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -36,7 +36,7 @@ static void addrtype_help_types(void)
 		printf("                                %s\n", rtn_names[i]);
 }
 
-static void addrtype_help(void)
+static void addrtype_help_v0(void)
 {
 	printf(
 "Address type match options:\n"
@@ -47,6 +47,19 @@ static void addrtype_help(void)
 	addrtype_help_types();
 }
 
+static void addrtype_help_v1(void)
+{
+	printf(
+"Address type match options:\n"
+" [!] --src-type type[,...]      Match source address type\n"
+" [!] --dst-type type[,...]      Match destination address type\n"
+"     --limit-iface-in           Match only on the packet's incoming device\n"
+"     --limit-iface-out          Match only on the packet's incoming device\n"
+"\n"
+"Valid types:           \n");
+	addrtype_help_types();
+}
+
 static int
 parse_type(const char *name, size_t len, u_int16_t *mask)
 {
@@ -79,10 +92,12 @@ static void parse_types(const char *arg, u_int16_t *mask)
 	
 #define IPT_ADDRTYPE_OPT_SRCTYPE	0x1
 #define IPT_ADDRTYPE_OPT_DSTTYPE	0x2
+#define IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN		0x4
+#define IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT	0x8
 
 static int
-addrtype_parse(int c, char **argv, int invert, unsigned int *flags,
-               const void *entry, struct xt_entry_match **match)
+addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_addrtype_info *info =
 		(struct ipt_addrtype_info *) (*match)->data;
@@ -115,11 +130,72 @@ addrtype_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static void addrtype_check(unsigned int flags)
+static int
+addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_match **match)
+{
+	struct ipt_addrtype_info_v1 *info =
+		(struct ipt_addrtype_info_v1 *) (*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & IPT_ADDRTYPE_OPT_SRCTYPE)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify src-type twice");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_types(argv[optind-1], &info->source);
+		if (invert)
+			info->flags |= IPT_ADDRTYPE_INVERT_SOURCE;
+		*flags |= IPT_ADDRTYPE_OPT_SRCTYPE;
+		break;
+	case '2':
+		if (*flags & IPT_ADDRTYPE_OPT_DSTTYPE)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify dst-type twice");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_types(argv[optind-1], &info->dest);
+		if (invert)
+			info->flags |= IPT_ADDRTYPE_INVERT_DEST;
+		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
+		break;
+	case '3':
+		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify limit-iface-in twice");
+		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_IN;
+		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN;
+		break;
+	case '4':
+		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify limit-iface-out twice");
+		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_OUT;
+		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT;
+		break;
+	default:
+		return 0;
+	}
+	
+	return 1;
+}
+
+static void addrtype_check_v0(unsigned int flags)
+{
+	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
+		exit_error(PARAMETER_PROBLEM,
+			   "addrtype: you must specify --src-type or --dst-type");
+}
+
+static void addrtype_check_v1(unsigned int flags)
 {
 	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
 		exit_error(PARAMETER_PROBLEM,
 			   "addrtype: you must specify --src-type or --dst-type");
+	if (flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN &&
+	    flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
+		exit_error(PARAMETER_PROBLEM,
+			   "addrtype: you can't specify both --limit-iface-in "
+			   "and --limit-iface-out");
 }
 
 static void print_types(u_int16_t mask)
@@ -136,8 +212,8 @@ static void print_types(u_int16_t mask)
 	printf(" ");
 }
 
-static void addrtype_print(const void *ip, const struct xt_entry_match *match,
-                           int numeric)
+static void addrtype_print_v0(const void *ip, const struct xt_entry_match *match,
+                              int numeric)
 {
 	const struct ipt_addrtype_info *info = 
 		(struct ipt_addrtype_info *) match->data;
@@ -157,7 +233,34 @@ static void addrtype_print(const void *ip, const struct xt_entry_match *match,
 	}
 }
 
-static void addrtype_save(const void *ip, const struct xt_entry_match *match)
+static void addrtype_print_v1(const void *ip, const struct xt_entry_match *match,
+                              int numeric)
+{
+	const struct ipt_addrtype_info_v1 *info = 
+		(struct ipt_addrtype_info_v1 *) match->data;
+
+	printf("ADDRTYPE match ");
+	if (info->source) {
+		printf("src-type ");
+		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
+			printf("!");
+		print_types(info->source);
+	}
+	if (info->dest) {
+		printf("dst-type ");
+		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
+			printf("!");
+		print_types(info->dest);
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
+		printf("limit-in ");
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printf("limit-out ");
+	}
+}
+
+static void addrtype_save_v0(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_addrtype_info *info =
 		(struct ipt_addrtype_info *) match->data;
@@ -176,28 +279,83 @@ static void addrtype_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
+static void addrtype_save_v1(const void *ip, const struct xt_entry_match *match)
+{
+	const struct ipt_addrtype_info_v1 *info =
+		(struct ipt_addrtype_info_v1 *) match->data;
+
+	if (info->source) {
+		printf("--src-type ");
+		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
+			printf("! ");
+		print_types(info->source);
+	}
+	if (info->dest) {
+		printf("--dst-type ");
+		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
+			printf("! ");
+		print_types(info->dest);
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
+		printf("--limit-iface-in ");
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printf("--limit-iface-out ");
+	}
+}
+
 static const struct option addrtype_opts[] = {
 	{ "src-type", 1, NULL, '1' },
 	{ "dst-type", 1, NULL, '2' },
 	{ .name = NULL }
 };
 
-static struct xtables_match addrtype_mt_reg = {
+static const struct option addrtype_opts_v0[] = {
+	{ "src-type", 1, NULL, '1' },
+	{ "dst-type", 1, NULL, '2' },
+	{ .name = NULL }
+};
+
+static const struct option addrtype_opts_v1[] = {
+	{ "src-type", 1, NULL, '1' },
+	{ "dst-type", 1, NULL, '2' },
+	{ "limit-iface-in", 0, NULL, '3' },
+	{ "limit-iface-out", 0, NULL, '4' },
+	{ .name = NULL }
+};
+
+static struct xtables_match addrtype_mt_reg_v0 = {
 	.name 		= "addrtype",
 	.version 	= XTABLES_VERSION,
 	.family		= PF_INET,
 	.size 		= XT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_addrtype_info)),
-	.help 		= addrtype_help,
-	.parse 		= addrtype_parse,
-	.final_check 	= addrtype_check,
-	.print 		= addrtype_print,
-	.save 		= addrtype_save,
-	.extra_opts 	= addrtype_opts,
+	.help 		= addrtype_help_v0,
+	.parse 		= addrtype_parse_v0,
+	.final_check 	= addrtype_check_v0,
+	.print 		= addrtype_print_v0,
+	.save 		= addrtype_save_v0,
+	.extra_opts 	= addrtype_opts_v0,
+};
+
+static struct xtables_match addrtype_mt_reg_v1 = {
+	.name 		= "addrtype",
+	.version 	= XTABLES_VERSION,
+	.family		= PF_INET,
+	.size 		= XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
+	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
+	.help 		= addrtype_help_v1,
+	.parse 		= addrtype_parse_v1,
+	.final_check 	= addrtype_check_v1,
+	.print 		= addrtype_print_v1,
+	.save 		= addrtype_save_v1,
+	.extra_opts 	= addrtype_opts_v1,
+	.revision	= 1,
 };
 
 
 void _init(void) 
 {
-	xtables_register_match(&addrtype_mt_reg);
+	xtables_register_match(&addrtype_mt_reg_v0);
+	xtables_register_match(&addrtype_mt_reg_v1);
 }
diff --git a/extensions/libipt_addrtype.man b/extensions/libipt_addrtype.man
index 2c3bbab..af5e648 100644
--- a/extensions/libipt_addrtype.man
+++ b/extensions/libipt_addrtype.man
@@ -7,31 +7,63 @@ The following address types are possible:
 .TP
 .BI "UNSPEC"
 an unspecified address (i.e. 0.0.0.0)
+.TP
 .BI "UNICAST"
 an unicast address
+.TP
 .BI "LOCAL"
 a local address
+.TP
 .BI "BROADCAST"
 a broadcast address
+.TP
 .BI "ANYCAST"
 an anycast packet
+.TP
 .BI "MULTICAST"
 a multicast address
+.TP
 .BI "BLACKHOLE"
 a blackhole address
+.TP
 .BI "UNREACHABLE"
 an unreachable address
+.TP
 .BI "PROHIBIT"
 a prohibited address
+.TP
 .BI "THROW"
 FIXME
+.TP
 .BI "NAT"
 FIXME
+.TP
 .BI "XRESOLVE"
-FIXME
 .TP
 .BI "--src-type " "type"
 Matches if the source address is of given type
 .TP
 .BI "--dst-type " "type"
 Matches if the destination address is of given type
+.TP
+.BI "--limit-iface-in"
+The address type checking can be limited to the interface the packet is coming
+in. This option is only valid in the
+.BR PREROUTING ,
+.B INPUT
+and
+.B FORWARD
+chains. It cannot be specified with the
+.B "--limit-iface-out"
+option.
+.TP
+.BI "--limit-iface-out"
+The address type checiking can be limited to the interface the packet is going
+out. This option is only valid in the
+.BR POSTROUTING ,
+.B OUTPUT
+and
+.B FORWARD
+chains. It cannot be specified with the
+.B --limit-iface-in
+option.
diff --git a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/netfilter_ipv4/ipt_addrtype.h
index 166ed01..446de6a 100644
--- a/include/linux/netfilter_ipv4/ipt_addrtype.h
+++ b/include/linux/netfilter_ipv4/ipt_addrtype.h
@@ -1,6 +1,20 @@
 #ifndef _IPT_ADDRTYPE_H
 #define _IPT_ADDRTYPE_H
 
+enum {
+	IPT_ADDRTYPE_INVERT_SOURCE	= 0x0001,
+	IPT_ADDRTYPE_INVERT_DEST	= 0x0002,
+	IPT_ADDRTYPE_LIMIT_IFACE_IN	= 0x0004,
+	IPT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
+};
+
+struct ipt_addrtype_info_v1 {
+	u_int16_t	source;		/* source-type mask */
+	u_int16_t	dest;		/* dest-type mask */
+	u_int32_t	flags;
+};
+
+/* revision 0 */
 struct ipt_addrtype_info {
 	u_int16_t	source;		/* source-type mask */
 	u_int16_t	dest;		/* dest-type mask */
-- 
1.5.4.3

