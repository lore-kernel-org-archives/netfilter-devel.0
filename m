From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] libxt_addrtype: rename from libipt_addrtype
Date: Mon,  5 Sep 2011 20:24:38 +0200
Message-ID: <1315247081-12131-2-git-send-email-jengelh@medozas.de>
References: <1315247081-12131-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33388 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab1IESYq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:24:46 -0400
In-Reply-To: <1315247081-12131-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_addrtype.c   |  308 ----------------------------------------
 extensions/libipt_addrtype.man |   69 ---------
 extensions/libxt_addrtype.c    |  308 ++++++++++++++++++++++++++++++++++++++++
 extensions/libxt_addrtype.man  |   69 +++++++++
 4 files changed, 377 insertions(+), 377 deletions(-)
 delete mode 100644 extensions/libipt_addrtype.c
 delete mode 100644 extensions/libipt_addrtype.man
 create mode 100644 extensions/libxt_addrtype.c
 create mode 100644 extensions/libxt_addrtype.man

diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
deleted file mode 100644
index 3dec626..0000000
--- a/extensions/libipt_addrtype.c
+++ /dev/null
@@ -1,308 +0,0 @@
-/* Shared library add-on to iptables to add addrtype matching support 
- * 
- * This program is released under the terms of GNU GPL */
-#include <stdio.h>
-#include <string.h>
-#include <xtables.h>
-#include <linux/netfilter_ipv4/ipt_addrtype.h>
-
-enum {
-	O_SRC_TYPE = 0,
-	O_DST_TYPE,
-	O_LIMIT_IFACE_IN,
-	O_LIMIT_IFACE_OUT,
-	F_SRC_TYPE        = 1 << O_SRC_TYPE,
-	F_DST_TYPE        = 1 << O_DST_TYPE,
-	F_LIMIT_IFACE_IN  = 1 << O_LIMIT_IFACE_IN,
-	F_LIMIT_IFACE_OUT = 1 << O_LIMIT_IFACE_OUT,
-};
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
-};
-
-static void addrtype_help_types(void)
-{
-	int i;
-
-	for (i = 0; rtn_names[i]; i++)
-		printf("                                %s\n", rtn_names[i]);
-}
-
-static void addrtype_help_v0(void)
-{
-	printf(
-"Address type match options:\n"
-" [!] --src-type type[,...]      Match source address type\n"
-" [!] --dst-type type[,...]      Match destination address type\n"
-"\n"
-"Valid types:           \n");
-	addrtype_help_types();
-}
-
-static void addrtype_help_v1(void)
-{
-	printf(
-"Address type match options:\n"
-" [!] --src-type type[,...]      Match source address type\n"
-" [!] --dst-type type[,...]      Match destination address type\n"
-"     --limit-iface-in           Match only on the packet's incoming device\n"
-"     --limit-iface-out          Match only on the packet's incoming device\n"
-"\n"
-"Valid types:           \n");
-	addrtype_help_types();
-}
-
-static int
-parse_type(const char *name, size_t len, uint16_t *mask)
-{
-	int i;
-
-	for (i = 0; rtn_names[i]; i++)
-		if (strncasecmp(name, rtn_names[i], len) == 0) {
-			/* build up bitmask for kernel module */
-			*mask |= (1 << i);
-			return 1;
-		}
-
-	return 0;
-}
-
-static void parse_types(const char *arg, uint16_t *mask)
-{
-	const char *comma;
-
-	while ((comma = strchr(arg, ',')) != NULL) {
-		if (comma == arg || !parse_type(arg, comma-arg, mask))
-			xtables_error(PARAMETER_PROBLEM,
-			           "addrtype: bad type `%s'", arg);
-		arg = comma + 1;
-	}
-
-	if (strlen(arg) == 0 || !parse_type(arg, strlen(arg), mask))
-		xtables_error(PARAMETER_PROBLEM, "addrtype: bad type \"%s\"", arg);
-}
-	
-static void addrtype_parse_v0(struct xt_option_call *cb)
-{
-	struct ipt_addrtype_info *info = cb->data;
-
-	xtables_option_parse(cb);
-	switch (cb->entry->id) {
-	case O_SRC_TYPE:
-		parse_types(cb->arg, &info->source);
-		if (cb->invert)
-			info->invert_source = 1;
-		break;
-	case O_DST_TYPE:
-		parse_types(cb->arg, &info->dest);
-		if (cb->invert)
-			info->invert_dest = 1;
-		break;
-	}
-}
-
-static void addrtype_parse_v1(struct xt_option_call *cb)
-{
-	struct ipt_addrtype_info_v1 *info = cb->data;
-
-	xtables_option_parse(cb);
-	switch (cb->entry->id) {
-	case O_SRC_TYPE:
-		parse_types(cb->arg, &info->source);
-		if (cb->invert)
-			info->flags |= IPT_ADDRTYPE_INVERT_SOURCE;
-		break;
-	case O_DST_TYPE:
-		parse_types(cb->arg, &info->dest);
-		if (cb->invert)
-			info->flags |= IPT_ADDRTYPE_INVERT_DEST;
-		break;
-	case O_LIMIT_IFACE_IN:
-		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_IN;
-		break;
-	case O_LIMIT_IFACE_OUT:
-		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_OUT;
-		break;
-	}
-}
-
-static void addrtype_check(struct xt_fcheck_call *cb)
-{
-	if (!(cb->xflags & (F_SRC_TYPE | F_DST_TYPE)))
-		xtables_error(PARAMETER_PROBLEM,
-			   "addrtype: you must specify --src-type or --dst-type");
-}
-
-static void print_types(uint16_t mask)
-{
-	const char *sep = "";
-	int i;
-
-	for (i = 0; rtn_names[i]; i++)
-		if (mask & (1 << i)) {
-			printf("%s%s", sep, rtn_names[i]);
-			sep = ",";
-		}
-}
-
-static void addrtype_print_v0(const void *ip, const struct xt_entry_match *match,
-                              int numeric)
-{
-	const struct ipt_addrtype_info *info = 
-		(struct ipt_addrtype_info *) match->data;
-
-	printf(" ADDRTYPE match");
-	if (info->source) {
-		printf(" src-type ");
-		if (info->invert_source)
-			printf("!");
-		print_types(info->source);
-	}
-	if (info->dest) {
-		printf(" dst-type");
-		if (info->invert_dest)
-			printf("!");
-		print_types(info->dest);
-	}
-}
-
-static void addrtype_print_v1(const void *ip, const struct xt_entry_match *match,
-                              int numeric)
-{
-	const struct ipt_addrtype_info_v1 *info = 
-		(struct ipt_addrtype_info_v1 *) match->data;
-
-	printf(" ADDRTYPE match");
-	if (info->source) {
-		printf(" src-type ");
-		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
-			printf("!");
-		print_types(info->source);
-	}
-	if (info->dest) {
-		printf(" dst-type ");
-		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
-			printf("!");
-		print_types(info->dest);
-	}
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
-		printf(" limit-in");
-	}
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
-		printf(" limit-out");
-	}
-}
-
-static void addrtype_save_v0(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ipt_addrtype_info *info =
-		(struct ipt_addrtype_info *) match->data;
-
-	if (info->source) {
-		if (info->invert_source)
-			printf(" !");
-		printf(" --src-type ");
-		print_types(info->source);
-	}
-	if (info->dest) {
-		if (info->invert_dest)
-			printf(" !");
-		printf(" --dst-type ");
-		print_types(info->dest);
-	}
-}
-
-static void addrtype_save_v1(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ipt_addrtype_info_v1 *info =
-		(struct ipt_addrtype_info_v1 *) match->data;
-
-	if (info->source) {
-		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
-			printf(" !");
-		printf(" --src-type ");
-		print_types(info->source);
-	}
-	if (info->dest) {
-		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
-			printf(" !");
-		printf(" --dst-type ");
-		print_types(info->dest);
-	}
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
-		printf(" --limit-iface-in");
-	}
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
-		printf(" --limit-iface-out");
-	}
-}
-
-static const struct xt_option_entry addrtype_opts_v0[] = {
-	{.name = "src-type", .id = O_SRC_TYPE, .type = XTTYPE_STRING,
-	 .flags = XTOPT_INVERT},
-	{.name = "dst-type", .id = O_DST_TYPE, .type = XTTYPE_STRING,
-	 .flags = XTOPT_INVERT},
-	XTOPT_TABLEEND,
-};
-
-static const struct xt_option_entry addrtype_opts_v1[] = {
-	{.name = "src-type", .id = O_SRC_TYPE, .type = XTTYPE_STRING,
-	 .flags = XTOPT_INVERT},
-	{.name = "dst-type", .id = O_DST_TYPE, .type = XTTYPE_STRING,
-	 .flags = XTOPT_INVERT},
-	{.name = "limit-iface-in", .id = O_LIMIT_IFACE_IN,
-	 .type = XTTYPE_NONE, .excl = F_LIMIT_IFACE_OUT},
-	{.name = "limit-iface-out", .id = O_LIMIT_IFACE_OUT,
-	 .type = XTTYPE_NONE, .excl = F_LIMIT_IFACE_IN},
-	XTOPT_TABLEEND,
-};
-
-static struct xtables_match addrtype_mt_reg[] = {
-	{
-		.name          = "addrtype",
-		.version       = XTABLES_VERSION,
-		.family        = NFPROTO_IPV4,
-		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
-		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
-		.help          = addrtype_help_v0,
-		.print         = addrtype_print_v0,
-		.save          = addrtype_save_v0,
-		.x6_parse      = addrtype_parse_v0,
-		.x6_fcheck     = addrtype_check,
-		.x6_options    = addrtype_opts_v0,
-	},
-	{
-		.name          = "addrtype",
-		.revision      = 1,
-		.version       = XTABLES_VERSION,
-		.family        = NFPROTO_IPV4,
-		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
-		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
-		.help          = addrtype_help_v1,
-		.print         = addrtype_print_v1,
-		.save          = addrtype_save_v1,
-		.x6_parse      = addrtype_parse_v1,
-		.x6_fcheck     = addrtype_check,
-		.x6_options    = addrtype_opts_v1,
-	},
-};
-
-
-void _init(void) 
-{
-	xtables_register_matches(addrtype_mt_reg, ARRAY_SIZE(addrtype_mt_reg));
-}
diff --git a/extensions/libipt_addrtype.man b/extensions/libipt_addrtype.man
deleted file mode 100644
index 16fd9df..0000000
--- a/extensions/libipt_addrtype.man
+++ /dev/null
@@ -1,69 +0,0 @@
-This module matches packets based on their 
-.B address type.
-Address types are used within the kernel networking stack and categorize
-addresses into various groups.  The exact definition of that group depends on the specific layer three protocol.
-.PP
-The following address types are possible:
-.TP
-.BI "UNSPEC"
-an unspecified address (i.e. 0.0.0.0)
-.TP
-.BI "UNICAST"
-an unicast address
-.TP
-.BI "LOCAL"
-a local address
-.TP
-.BI "BROADCAST"
-a broadcast address
-.TP
-.BI "ANYCAST"
-an anycast packet
-.TP
-.BI "MULTICAST"
-a multicast address
-.TP
-.BI "BLACKHOLE"
-a blackhole address
-.TP
-.BI "UNREACHABLE"
-an unreachable address
-.TP
-.BI "PROHIBIT"
-a prohibited address
-.TP
-.BI "THROW"
-FIXME
-.TP
-.BI "NAT"
-FIXME
-.TP
-.BI "XRESOLVE"
-.TP
-[\fB!\fP] \fB\-\-src\-type\fP \fItype\fP
-Matches if the source address is of given type
-.TP
-[\fB!\fP] \fB\-\-dst\-type\fP \fItype\fP
-Matches if the destination address is of given type
-.TP
-.BI "\-\-limit\-iface\-in"
-The address type checking can be limited to the interface the packet is coming
-in. This option is only valid in the
-.BR PREROUTING ,
-.B INPUT
-and
-.B FORWARD
-chains. It cannot be specified with the
-\fB\-\-limit\-iface\-out\fP
-option.
-.TP
-\fB\-\-limit\-iface\-out\fP
-The address type checking can be limited to the interface the packet is going
-out. This option is only valid in the
-.BR POSTROUTING ,
-.B OUTPUT
-and
-.B FORWARD
-chains. It cannot be specified with the
-\fB\-\-limit\-iface\-in\fP
-option.
diff --git a/extensions/libxt_addrtype.c b/extensions/libxt_addrtype.c
new file mode 100644
index 0000000..3dec626
--- /dev/null
+++ b/extensions/libxt_addrtype.c
@@ -0,0 +1,308 @@
+/* Shared library add-on to iptables to add addrtype matching support 
+ * 
+ * This program is released under the terms of GNU GPL */
+#include <stdio.h>
+#include <string.h>
+#include <xtables.h>
+#include <linux/netfilter_ipv4/ipt_addrtype.h>
+
+enum {
+	O_SRC_TYPE = 0,
+	O_DST_TYPE,
+	O_LIMIT_IFACE_IN,
+	O_LIMIT_IFACE_OUT,
+	F_SRC_TYPE        = 1 << O_SRC_TYPE,
+	F_DST_TYPE        = 1 << O_DST_TYPE,
+	F_LIMIT_IFACE_IN  = 1 << O_LIMIT_IFACE_IN,
+	F_LIMIT_IFACE_OUT = 1 << O_LIMIT_IFACE_OUT,
+};
+
+/* from linux/rtnetlink.h, must match order of enumeration */
+static const char *const rtn_names[] = {
+	"UNSPEC",
+	"UNICAST",
+	"LOCAL",
+	"BROADCAST",
+	"ANYCAST",
+	"MULTICAST",
+	"BLACKHOLE",
+	"UNREACHABLE",
+	"PROHIBIT",
+	"THROW",
+	"NAT",
+	"XRESOLVE",
+	NULL
+};
+
+static void addrtype_help_types(void)
+{
+	int i;
+
+	for (i = 0; rtn_names[i]; i++)
+		printf("                                %s\n", rtn_names[i]);
+}
+
+static void addrtype_help_v0(void)
+{
+	printf(
+"Address type match options:\n"
+" [!] --src-type type[,...]      Match source address type\n"
+" [!] --dst-type type[,...]      Match destination address type\n"
+"\n"
+"Valid types:           \n");
+	addrtype_help_types();
+}
+
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
+static int
+parse_type(const char *name, size_t len, uint16_t *mask)
+{
+	int i;
+
+	for (i = 0; rtn_names[i]; i++)
+		if (strncasecmp(name, rtn_names[i], len) == 0) {
+			/* build up bitmask for kernel module */
+			*mask |= (1 << i);
+			return 1;
+		}
+
+	return 0;
+}
+
+static void parse_types(const char *arg, uint16_t *mask)
+{
+	const char *comma;
+
+	while ((comma = strchr(arg, ',')) != NULL) {
+		if (comma == arg || !parse_type(arg, comma-arg, mask))
+			xtables_error(PARAMETER_PROBLEM,
+			           "addrtype: bad type `%s'", arg);
+		arg = comma + 1;
+	}
+
+	if (strlen(arg) == 0 || !parse_type(arg, strlen(arg), mask))
+		xtables_error(PARAMETER_PROBLEM, "addrtype: bad type \"%s\"", arg);
+}
+	
+static void addrtype_parse_v0(struct xt_option_call *cb)
+{
+	struct ipt_addrtype_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SRC_TYPE:
+		parse_types(cb->arg, &info->source);
+		if (cb->invert)
+			info->invert_source = 1;
+		break;
+	case O_DST_TYPE:
+		parse_types(cb->arg, &info->dest);
+		if (cb->invert)
+			info->invert_dest = 1;
+		break;
+	}
+}
+
+static void addrtype_parse_v1(struct xt_option_call *cb)
+{
+	struct ipt_addrtype_info_v1 *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SRC_TYPE:
+		parse_types(cb->arg, &info->source);
+		if (cb->invert)
+			info->flags |= IPT_ADDRTYPE_INVERT_SOURCE;
+		break;
+	case O_DST_TYPE:
+		parse_types(cb->arg, &info->dest);
+		if (cb->invert)
+			info->flags |= IPT_ADDRTYPE_INVERT_DEST;
+		break;
+	case O_LIMIT_IFACE_IN:
+		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_IN;
+		break;
+	case O_LIMIT_IFACE_OUT:
+		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_OUT;
+		break;
+	}
+}
+
+static void addrtype_check(struct xt_fcheck_call *cb)
+{
+	if (!(cb->xflags & (F_SRC_TYPE | F_DST_TYPE)))
+		xtables_error(PARAMETER_PROBLEM,
+			   "addrtype: you must specify --src-type or --dst-type");
+}
+
+static void print_types(uint16_t mask)
+{
+	const char *sep = "";
+	int i;
+
+	for (i = 0; rtn_names[i]; i++)
+		if (mask & (1 << i)) {
+			printf("%s%s", sep, rtn_names[i]);
+			sep = ",";
+		}
+}
+
+static void addrtype_print_v0(const void *ip, const struct xt_entry_match *match,
+                              int numeric)
+{
+	const struct ipt_addrtype_info *info = 
+		(struct ipt_addrtype_info *) match->data;
+
+	printf(" ADDRTYPE match");
+	if (info->source) {
+		printf(" src-type ");
+		if (info->invert_source)
+			printf("!");
+		print_types(info->source);
+	}
+	if (info->dest) {
+		printf(" dst-type");
+		if (info->invert_dest)
+			printf("!");
+		print_types(info->dest);
+	}
+}
+
+static void addrtype_print_v1(const void *ip, const struct xt_entry_match *match,
+                              int numeric)
+{
+	const struct ipt_addrtype_info_v1 *info = 
+		(struct ipt_addrtype_info_v1 *) match->data;
+
+	printf(" ADDRTYPE match");
+	if (info->source) {
+		printf(" src-type ");
+		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
+			printf("!");
+		print_types(info->source);
+	}
+	if (info->dest) {
+		printf(" dst-type ");
+		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
+			printf("!");
+		print_types(info->dest);
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
+		printf(" limit-in");
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printf(" limit-out");
+	}
+}
+
+static void addrtype_save_v0(const void *ip, const struct xt_entry_match *match)
+{
+	const struct ipt_addrtype_info *info =
+		(struct ipt_addrtype_info *) match->data;
+
+	if (info->source) {
+		if (info->invert_source)
+			printf(" !");
+		printf(" --src-type ");
+		print_types(info->source);
+	}
+	if (info->dest) {
+		if (info->invert_dest)
+			printf(" !");
+		printf(" --dst-type ");
+		print_types(info->dest);
+	}
+}
+
+static void addrtype_save_v1(const void *ip, const struct xt_entry_match *match)
+{
+	const struct ipt_addrtype_info_v1 *info =
+		(struct ipt_addrtype_info_v1 *) match->data;
+
+	if (info->source) {
+		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
+			printf(" !");
+		printf(" --src-type ");
+		print_types(info->source);
+	}
+	if (info->dest) {
+		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
+			printf(" !");
+		printf(" --dst-type ");
+		print_types(info->dest);
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
+		printf(" --limit-iface-in");
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printf(" --limit-iface-out");
+	}
+}
+
+static const struct xt_option_entry addrtype_opts_v0[] = {
+	{.name = "src-type", .id = O_SRC_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "dst-type", .id = O_DST_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	XTOPT_TABLEEND,
+};
+
+static const struct xt_option_entry addrtype_opts_v1[] = {
+	{.name = "src-type", .id = O_SRC_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "dst-type", .id = O_DST_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "limit-iface-in", .id = O_LIMIT_IFACE_IN,
+	 .type = XTTYPE_NONE, .excl = F_LIMIT_IFACE_OUT},
+	{.name = "limit-iface-out", .id = O_LIMIT_IFACE_OUT,
+	 .type = XTTYPE_NONE, .excl = F_LIMIT_IFACE_IN},
+	XTOPT_TABLEEND,
+};
+
+static struct xtables_match addrtype_mt_reg[] = {
+	{
+		.name          = "addrtype",
+		.version       = XTABLES_VERSION,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
+		.help          = addrtype_help_v0,
+		.print         = addrtype_print_v0,
+		.save          = addrtype_save_v0,
+		.x6_parse      = addrtype_parse_v0,
+		.x6_fcheck     = addrtype_check,
+		.x6_options    = addrtype_opts_v0,
+	},
+	{
+		.name          = "addrtype",
+		.revision      = 1,
+		.version       = XTABLES_VERSION,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
+		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
+		.help          = addrtype_help_v1,
+		.print         = addrtype_print_v1,
+		.save          = addrtype_save_v1,
+		.x6_parse      = addrtype_parse_v1,
+		.x6_fcheck     = addrtype_check,
+		.x6_options    = addrtype_opts_v1,
+	},
+};
+
+
+void _init(void) 
+{
+	xtables_register_matches(addrtype_mt_reg, ARRAY_SIZE(addrtype_mt_reg));
+}
diff --git a/extensions/libxt_addrtype.man b/extensions/libxt_addrtype.man
new file mode 100644
index 0000000..16fd9df
--- /dev/null
+++ b/extensions/libxt_addrtype.man
@@ -0,0 +1,69 @@
+This module matches packets based on their 
+.B address type.
+Address types are used within the kernel networking stack and categorize
+addresses into various groups.  The exact definition of that group depends on the specific layer three protocol.
+.PP
+The following address types are possible:
+.TP
+.BI "UNSPEC"
+an unspecified address (i.e. 0.0.0.0)
+.TP
+.BI "UNICAST"
+an unicast address
+.TP
+.BI "LOCAL"
+a local address
+.TP
+.BI "BROADCAST"
+a broadcast address
+.TP
+.BI "ANYCAST"
+an anycast packet
+.TP
+.BI "MULTICAST"
+a multicast address
+.TP
+.BI "BLACKHOLE"
+a blackhole address
+.TP
+.BI "UNREACHABLE"
+an unreachable address
+.TP
+.BI "PROHIBIT"
+a prohibited address
+.TP
+.BI "THROW"
+FIXME
+.TP
+.BI "NAT"
+FIXME
+.TP
+.BI "XRESOLVE"
+.TP
+[\fB!\fP] \fB\-\-src\-type\fP \fItype\fP
+Matches if the source address is of given type
+.TP
+[\fB!\fP] \fB\-\-dst\-type\fP \fItype\fP
+Matches if the destination address is of given type
+.TP
+.BI "\-\-limit\-iface\-in"
+The address type checking can be limited to the interface the packet is coming
+in. This option is only valid in the
+.BR PREROUTING ,
+.B INPUT
+and
+.B FORWARD
+chains. It cannot be specified with the
+\fB\-\-limit\-iface\-out\fP
+option.
+.TP
+\fB\-\-limit\-iface\-out\fP
+The address type checking can be limited to the interface the packet is going
+out. This option is only valid in the
+.BR POSTROUTING ,
+.B OUTPUT
+and
+.B FORWARD
+chains. It cannot be specified with the
+\fB\-\-limit\-iface\-in\fP
+option.
-- 
1.7.3.4

