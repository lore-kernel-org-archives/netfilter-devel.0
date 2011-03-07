From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] libxt_addrtype: ipv6 support
Date: Mon,  7 Mar 2011 22:30:06 +0100
Message-ID: <1299533406-1375-2-git-send-email-fw@strlen.de>
References: <1299533406-1375-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35865 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055Ab1CGVf7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:35:59 -0500
In-Reply-To: <1299533406-1375-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fwestphal@astaro.com>

Fairly straightforward from userspace view.
Use XT_ADDRTYE_UNSPEC etc. instead of relying on RTN_* values from
rtnetlink.h.

XT_ADDRTYPE_ values .. match the shifted RTN_ ones, so this change is
compatible.

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 extensions/libxt_addrtype.c |  195 ++++++++++++++++++++++++++-----------------
 1 files changed, 118 insertions(+), 77 deletions(-)

diff --git a/extensions/libxt_addrtype.c b/extensions/libxt_addrtype.c
index a592f0d..14be638 100644
--- a/extensions/libxt_addrtype.c
+++ b/extensions/libxt_addrtype.c
@@ -8,31 +8,38 @@
 #include <getopt.h>
 #include <xtables.h>
 
-#include <linux/netfilter_ipv4/ipt_addrtype.h>
-
-/* from linux/rtnetlink.h, must match order of enumeration */
-static const char *const rtn_names[] = {
-	"UNSPEC",
-	"UNICAST",
-	"LOCAL",
-	"BROADCAST",
-	"ANYCAST",
-	"MULTICAST",
-	"BLACKHOLE",
-	"UNREACHABLE",
-	"PROHIBIT",
-	"THROW",
-	"NAT",
-	"XRESOLVE",
-	NULL
+#include <linux/netfilter/xt_addrtype.h>
+
+#define __stringify_1(x...)     #x
+#define __stringify(x...)       __stringify_1(x)
+#define NAME_MASK(x)		{ __stringify(x), XT_ADDRTYPE_ ## x, }
+
+static struct {
+	const char *name;
+	uint32_t maskbit;
+} rtn_names[] = {
+	NAME_MASK(UNSPEC),
+	NAME_MASK(UNICAST),
+	NAME_MASK(LOCAL),
+	NAME_MASK(BROADCAST),
+	NAME_MASK(ANYCAST),
+	NAME_MASK(MULTICAST),
+	NAME_MASK(BLACKHOLE),
+	NAME_MASK(UNREACHABLE),
+	NAME_MASK(PROHIBIT),
+	NAME_MASK(THROW),
+	NAME_MASK(NAT),
+	NAME_MASK(XRESOLVE),
+
+	{ NULL, 0 }
 };
 
 static void addrtype_help_types(void)
 {
 	int i;
 
-	for (i = 0; rtn_names[i]; i++)
-		printf("                                %s\n", rtn_names[i]);
+	for (i = 0; rtn_names[i].name; i++)
+		printf("                                %s\n", rtn_names[i].name);
 }
 
 static void addrtype_help_v0(void)
@@ -56,18 +63,38 @@ static void addrtype_help_v1(void)
 "     --limit-iface-out          Match only on the packet's incoming device\n"
 "\n"
 "Valid types:           \n");
+}
+
+static void addrtype_help4_v1(void)
+{
+	addrtype_help_v1();
 	addrtype_help_types();
 }
 
+static void addrtype_help6_v1(void)
+{
+	int i;
+	addrtype_help_v1();
+
+	for (i = 0; rtn_names[i].name ; i++) {
+		if (rtn_names[i].maskbit == XT_ADDRTYPE_BROADCAST ||
+		    rtn_names[i].maskbit == XT_ADDRTYPE_BLACKHOLE)
+			continue;
+		if (rtn_names[i].maskbit == XT_ADDRTYPE_PROHIBIT)
+			break;
+
+		printf("                                %s\n", rtn_names[i].name);
+	}
+}
+
 static int
 parse_type(const char *name, size_t len, uint16_t *mask)
 {
 	int i;
 
-	for (i = 0; rtn_names[i]; i++)
-		if (strncasecmp(name, rtn_names[i], len) == 0) {
-			/* build up bitmask for kernel module */
-			*mask |= (1 << i);
+	for (i = 0; rtn_names[i].name; i++)
+		if (strncasecmp(name, rtn_names[i].name, len) == 0) {
+			*mask |= rtn_names[i].maskbit;
 			return 1;
 		}
 
@@ -88,42 +115,42 @@ static void parse_types(const char *arg, uint16_t *mask)
 	if (strlen(arg) == 0 || !parse_type(arg, strlen(arg), mask))
 		xtables_error(PARAMETER_PROBLEM, "addrtype: bad type \"%s\"", arg);
 }
-	
-#define IPT_ADDRTYPE_OPT_SRCTYPE	0x1
-#define IPT_ADDRTYPE_OPT_DSTTYPE	0x2
-#define IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN		0x4
-#define IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT	0x8
+
+#define XT_ADDRTYPE_OPT_SRCTYPE	0x1
+#define XT_ADDRTYPE_OPT_DSTTYPE	0x2
+#define XT_ADDRTYPE_OPT_LIMIT_IFACE_IN		0x4
+#define XT_ADDRTYPE_OPT_LIMIT_IFACE_OUT	0x8
 
 static int
 addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
-	struct ipt_addrtype_info *info =
-		(struct ipt_addrtype_info *) (*match)->data;
+	struct xt_addrtype_info *info =
+		(struct xt_addrtype_info *) (*match)->data;
 
 	switch (c) {
 	case '1':
-		if (*flags&IPT_ADDRTYPE_OPT_SRCTYPE)
+		if (*flags&XT_ADDRTYPE_OPT_SRCTYPE)
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_types(optarg, &info->source);
 		if (invert)
 			info->invert_source = 1;
-		*flags |= IPT_ADDRTYPE_OPT_SRCTYPE;
+		*flags |= XT_ADDRTYPE_OPT_SRCTYPE;
 		break;
 	case '2':
-		if (*flags&IPT_ADDRTYPE_OPT_DSTTYPE)
+		if (*flags&XT_ADDRTYPE_OPT_DSTTYPE)
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_types(optarg, &info->dest);
 		if (invert)
 			info->invert_dest = 1;
-		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
+		*flags |= XT_ADDRTYPE_OPT_DSTTYPE;
 		break;
 	}
-	
+
 	return 1;
 }
 
@@ -131,43 +158,43 @@ static int
 addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
-	struct ipt_addrtype_info_v1 *info =
-		(struct ipt_addrtype_info_v1 *) (*match)->data;
+	struct xt_addrtype_info_v1 *info =
+		(struct xt_addrtype_info_v1 *) (*match)->data;
 
 	switch (c) {
 	case '1':
-		if (*flags & IPT_ADDRTYPE_OPT_SRCTYPE)
+		if (*flags & XT_ADDRTYPE_OPT_SRCTYPE)
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_types(optarg, &info->source);
 		if (invert)
-			info->flags |= IPT_ADDRTYPE_INVERT_SOURCE;
-		*flags |= IPT_ADDRTYPE_OPT_SRCTYPE;
+			info->flags |= XT_ADDRTYPE_INVERT_SOURCE;
+		*flags |= XT_ADDRTYPE_OPT_SRCTYPE;
 		break;
 	case '2':
-		if (*flags & IPT_ADDRTYPE_OPT_DSTTYPE)
+		if (*flags & XT_ADDRTYPE_OPT_DSTTYPE)
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_types(optarg, &info->dest);
 		if (invert)
-			info->flags |= IPT_ADDRTYPE_INVERT_DEST;
-		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
+			info->flags |= XT_ADDRTYPE_INVERT_DEST;
+		*flags |= XT_ADDRTYPE_OPT_DSTTYPE;
 		break;
 	case '3':
-		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN)
+		if (*flags & XT_ADDRTYPE_OPT_LIMIT_IFACE_IN)
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify limit-iface-in twice");
-		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_IN;
-		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN;
+		info->flags |= XT_ADDRTYPE_LIMIT_IFACE_IN;
+		*flags |= XT_ADDRTYPE_OPT_LIMIT_IFACE_IN;
 		break;
 	case '4':
-		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
+		if (*flags & XT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify limit-iface-out twice");
-		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_OUT;
-		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT;
+		info->flags |= XT_ADDRTYPE_LIMIT_IFACE_OUT;
+		*flags |= XT_ADDRTYPE_OPT_LIMIT_IFACE_OUT;
 		break;
 	}
 	
@@ -176,18 +203,18 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 
 static void addrtype_check_v0(unsigned int flags)
 {
-	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
+	if (!(flags & (XT_ADDRTYPE_OPT_SRCTYPE|XT_ADDRTYPE_OPT_DSTTYPE)))
 		xtables_error(PARAMETER_PROBLEM,
 			   "addrtype: you must specify --src-type or --dst-type");
 }
 
 static void addrtype_check_v1(unsigned int flags)
 {
-	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
+	if (!(flags & (XT_ADDRTYPE_OPT_SRCTYPE|XT_ADDRTYPE_OPT_DSTTYPE)))
 		xtables_error(PARAMETER_PROBLEM,
 			   "addrtype: you must specify --src-type or --dst-type");
-	if (flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN &&
-	    flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
+	if (flags & XT_ADDRTYPE_OPT_LIMIT_IFACE_IN &&
+	    flags & XT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
 		xtables_error(PARAMETER_PROBLEM,
 			   "addrtype: you can't specify both --limit-iface-in "
 			   "and --limit-iface-out");
@@ -198,9 +225,9 @@ static void print_types(uint16_t mask)
 	const char *sep = "";
 	int i;
 
-	for (i = 0; rtn_names[i]; i++)
-		if (mask & (1 << i)) {
-			printf("%s%s", sep, rtn_names[i]);
+	for (i = 0; rtn_names[i].name; i++)
+		if (mask & rtn_names[i].maskbit) {
+			printf("%s%s", sep, rtn_names[i].name);
 			sep = ",";
 		}
 }
@@ -208,8 +235,8 @@ static void print_types(uint16_t mask)
 static void addrtype_print_v0(const void *ip, const struct xt_entry_match *match,
                               int numeric)
 {
-	const struct ipt_addrtype_info *info = 
-		(struct ipt_addrtype_info *) match->data;
+	const struct xt_addrtype_info *info =
+		(struct xt_addrtype_info *) match->data;
 
 	printf(" ADDRTYPE match");
 	if (info->source) {
@@ -229,34 +256,34 @@ static void addrtype_print_v0(const void *ip, const struct xt_entry_match *match
 static void addrtype_print_v1(const void *ip, const struct xt_entry_match *match,
                               int numeric)
 {
-	const struct ipt_addrtype_info_v1 *info = 
-		(struct ipt_addrtype_info_v1 *) match->data;
+	const struct xt_addrtype_info_v1 *info =
+		(struct xt_addrtype_info_v1 *) match->data;
 
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
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN) {
 		printf(" limit-in");
 	}
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) {
 		printf(" limit-out");
 	}
 }
 
 static void addrtype_save_v0(const void *ip, const struct xt_entry_match *match)
 {
-	const struct ipt_addrtype_info *info =
-		(struct ipt_addrtype_info *) match->data;
+	const struct xt_addrtype_info *info =
+		(struct xt_addrtype_info *) match->data;
 
 	if (info->source) {
 		if (info->invert_source)
@@ -274,25 +301,25 @@ static void addrtype_save_v0(const void *ip, const struct xt_entry_match *match)
 
 static void addrtype_save_v1(const void *ip, const struct xt_entry_match *match)
 {
-	const struct ipt_addrtype_info_v1 *info =
-		(struct ipt_addrtype_info_v1 *) match->data;
+	const struct xt_addrtype_info_v1 *info =
+		(struct xt_addrtype_info_v1 *) match->data;
 
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
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN) {
 		printf(" --limit-iface-in");
 	}
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) {
 		printf(" --limit-iface-out");
 	}
 }
@@ -322,8 +349,8 @@ static struct xtables_match addrtype_mt_reg[] = {
 		.name          = "addrtype",
 		.version       = XTABLES_VERSION,
 		.family        = NFPROTO_IPV4,
-		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
-		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
+		.size          = XT_ALIGN(sizeof(struct xt_addrtype_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_addrtype_info)),
 		.help          = addrtype_help_v0,
 		.parse         = addrtype_parse_v0,
 		.final_check   = addrtype_check_v0,
@@ -336,9 +363,23 @@ static struct xtables_match addrtype_mt_reg[] = {
 		.revision      = 1,
 		.version       = XTABLES_VERSION,
 		.family        = NFPROTO_IPV4,
-		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
-		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
-		.help          = addrtype_help_v1,
+		.size          = XT_ALIGN(sizeof(struct xt_addrtype_info_v1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_addrtype_info_v1)),
+		.help          = addrtype_help4_v1,
+		.parse         = addrtype_parse_v1,
+		.final_check   = addrtype_check_v1,
+		.print         = addrtype_print_v1,
+		.save          = addrtype_save_v1,
+		.extra_opts    = addrtype_opts_v1,
+	},
+	{
+		.name          = "addrtype",
+		.revision      = 1,
+		.version       = XTABLES_VERSION,
+		.family        = NFPROTO_IPV6,
+		.size          = XT_ALIGN(sizeof(struct xt_addrtype_info_v1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_addrtype_info_v1)),
+		.help          = addrtype_help6_v1,
 		.parse         = addrtype_parse_v1,
 		.final_check   = addrtype_check_v1,
 		.print         = addrtype_print_v1,
-- 
1.7.3.4

