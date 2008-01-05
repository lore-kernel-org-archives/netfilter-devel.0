From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 17/21] libxt_limit match, revision 1
Date: Sat, 5 Jan 2008 15:49:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801051549140.14194@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48622 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYAEOuA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:50:00 -0500
In-Reply-To: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Add support for xt_length revision 1.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libip6t_length.man       |    4 
 extensions/libipt_length.man        |    4 
 extensions/libxt_length.c           |  170 +++++++++++++++++++++++++++++++++++-
 extensions/libxt_length.man         |   18 +++
 include/linux/netfilter/xt_length.h |   18 +++
 5 files changed, 204 insertions(+), 10 deletions(-)

Index: iptables-modules/extensions/libip6t_length.man
===================================================================
--- iptables-modules.orig/extensions/libip6t_length.man
+++ /dev/null
@@ -1,4 +0,0 @@
-This module matches the length of the IPv6 payload in octets, or range of it.
-IPv6 header itself isn't counted.
-.TP
-.BR "--length " "[!] \fIlength\fP[:\fIlength\fP]"
Index: iptables-modules/extensions/libipt_length.man
===================================================================
--- iptables-modules.orig/extensions/libipt_length.man
+++ /dev/null
@@ -1,4 +0,0 @@
-This module matches the length of a packet against a specific value
-or range of values.
-.TP
-.BR "--length " "[!] \fIlength\fP[:\fIlength\fP]"
Index: iptables-modules/extensions/libxt_length.c
===================================================================
--- iptables-modules.orig/extensions/libxt_length.c
+++ iptables-modules/extensions/libxt_length.c
@@ -8,6 +8,11 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_length.h>
 
+enum {
+	F_LAYER  = 1 << 0,
+	F_LENGTH = 1 << 1,
+};
+
 /* Function which prints out usage message. */
 static void length_help(void)
 {
@@ -18,12 +23,39 @@ static void length_help(void)
 IPTABLES_VERSION);
 
 }
+
+static void length_mt_help(void)
+{
+	printf(
+"length match options:\n"
+"    --layer3          Match against layer3 frame size (e.g. IP+TCP+payload)"
+"    --layer4          Match against layer4 frame size (e.g. TCP hdr+payload)\n"
+"    --layer5          Match against layer5 frame size (e.g. TCP payload)"
+"[!] --length n[:n]    Match packet length against value or range\n"
+"                      of values (inclusive)\n"
+);
+}
   
 static const struct option length_opts[] = {
 	{ "length", 1, NULL, '1' },
 	{ }
 };
 
+static const struct option length_mt_opts[] = {
+	{.name = "layer3",   .has_arg = false, .val = '3'},
+	{.name = "layer4",   .has_arg = false, .val = '4'},
+	{.name = "layer5",   .has_arg = false, .val = '5'},
+	{.name = "length",   .has_arg = true,  .val = '='},
+	{},
+};
+
+static void length_mt_init(struct xt_entry_match *match)
+{
+	struct xt_length_mtinfo1 *info = (void *)match->data;
+
+	info->flags = XT_LENGTH_LAYER3;
+}
+
 static u_int16_t
 parse_length(const char *s)
 {
@@ -71,7 +103,7 @@ length_parse(int c, char **argv, int inv
 
 	switch (c) {
 		case '1':
-			if (*flags)
+			if (*flags & F_LAYER)
 				exit_error(PARAMETER_PROBLEM,
 				           "length: `--length' may only be "
 				           "specified once");
@@ -79,7 +111,7 @@ length_parse(int c, char **argv, int inv
 			parse_lengths(argv[optind-1], info);
 			if (invert)
 				info->invert = 1;
-			*flags = 1;
+			*flags |= F_LAYER;
 			break;
 			
 		default:
@@ -88,6 +120,53 @@ length_parse(int c, char **argv, int inv
 	return 1;
 }
 
+static int length_mt_parse(int c, char **argv, int invert, unsigned int *flags,
+                           const void *entry, struct xt_entry_match **match)
+{
+	struct xt_length_mtinfo1 *info = (void *)(*match)->data;
+	unsigned int from, to;
+	char *end;
+
+	switch (c) {
+	case '3': /* --layer3 */
+		param_act(P_ONLY_ONCE, "length", "--layer*", *flags & F_LAYER);
+		info->flags &= ~(XT_LENGTH_LAYER4 | XT_LENGTH_LAYER5);
+		info->flags |= XT_LENGTH_LAYER3;
+		*flags |= F_LAYER;
+		return true;
+	case '4': /* --layer4 */
+		param_act(P_ONLY_ONCE, "length", "--layer*", *flags & F_LAYER);
+		info->flags &= ~(XT_LENGTH_LAYER3 | XT_LENGTH_LAYER5);
+		info->flags |= XT_LENGTH_LAYER4;
+		*flags |= F_LAYER;
+		return true;
+	case '5': /* --layer5 */
+		param_act(P_ONLY_ONCE, "length", "--layer*", *flags & F_LAYER);
+		info->flags &= ~(XT_LENGTH_LAYER3 | XT_LENGTH_LAYER4);
+		info->flags |= XT_LENGTH_LAYER5;
+		*flags |= F_LAYER;
+		return true;
+	case '=': /* --length */
+		param_act(P_ONLY_ONCE, "length", "--length", *flags & F_LENGTH);
+		if (invert)
+			info->flags |= XT_LENGTH_INVERT;
+		if (!strtonum(optarg, &end, &from, 0, ~0U))
+			param_act(P_BAD_VALUE, "length", "--length", optarg);
+		to = from;
+		if (*end == ':')
+			if (!strtonum(end + 1, &end, &to, 0, ~0U))
+				param_act(P_BAD_VALUE, "length",
+				          "--length", optarg);
+		if (*end != '\0')
+			param_act(P_BAD_VALUE, "length", "--length", optarg);
+		info->min = from;
+		info->max = to;
+		*flags |= F_LENGTH;
+		return true;
+	}
+	return false;
+}
+
 /* Final check; must have specified --length. */
 static void length_check(unsigned int flags)
 {
@@ -96,6 +175,16 @@ static void length_check(unsigned int fl
 			   "length: You must specify `--length'");
 }
 
+static void length_mt_check(unsigned int flags)
+{
+	if (!(flags & F_LENGTH))
+		exit_error(PARAMETER_PROBLEM,
+		           "length: You must specify \"--length\"");
+	if (!(flags & F_LAYER))
+		fprintf(stderr, "iptables: length match: Defaulting to "
+		        "--layer3. Consider specifying it explicitly.\n");
+}
+
 /* Common match printing code. */
 static void
 print_length(struct xt_length_info *info)
@@ -117,6 +206,27 @@ length_print(const void *ip, const struc
 	print_length((struct xt_length_info *)match->data);
 }
 
+static void length_mt_print(const void *ip, const struct xt_entry_match *match,
+                            int numeric)
+{
+	const struct xt_length_mtinfo1 *info = (const void *)match->data;
+
+	if (info->flags & XT_LENGTH_LAYER3)
+		printf("layer3 ");
+	else if (info->flags & XT_LENGTH_LAYER4)
+		printf("layer4 ");
+	else if (info->flags & XT_LENGTH_LAYER5)
+		printf("layer5 ");
+	printf("length ");
+	if (info->flags & XT_LENGTH_INVERT)
+		printf("! ");
+	if (info->min == info->max)
+		printf("%u ", (unsigned int)info->min);
+	else
+		printf("%u-%u ", (unsigned int)info->min,
+		       (unsigned int)info->max);
+}
+
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void length_save(const void *ip, const struct xt_entry_match *match)
 {
@@ -124,10 +234,31 @@ static void length_save(const void *ip, 
 	print_length((struct xt_length_info *)match->data);
 }
 
+static void length_mt_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_length_mtinfo1 *info = (const void *)match->data;
+
+	if (info->flags & XT_LENGTH_LAYER3)
+		printf("--layer3 ");
+	else if (info->flags & XT_LENGTH_LAYER4)
+		printf("--layer4 ");
+	else if (info->flags & XT_LENGTH_LAYER5)
+		printf("--layer5 ");
+	if (info->flags & XT_LENGTH_INVERT)
+		printf("! ");
+	printf("--length ");
+	if (info->min == info->max)
+		printf("%u ", (unsigned int)info->min);
+	else
+		printf("%u:%u ", (unsigned int)info->min,
+		       (unsigned int)info->max);
+}
+
 static struct xtables_match length_match = {
 	.family		= AF_INET,
 	.name		= "length",
 	.version	= IPTABLES_VERSION,
+	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_length_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_length_info)),
 	.help		= length_help,
@@ -142,6 +273,7 @@ static struct xtables_match length_match
 	.family		= AF_INET6,
 	.name		= "length",
 	.version	= IPTABLES_VERSION,
+	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_length_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_length_info)),
 	.help		= length_help,
@@ -152,8 +284,42 @@ static struct xtables_match length_match
 	.extra_opts	= length_opts,
 };
 
+static struct xtables_match length_mt_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "length",
+	.revision       = 1,
+	.family         = AF_INET,
+	.size           = XT_ALIGN(sizeof(struct xt_length_mtinfo1)),
+	.userspacesize  = XT_ALIGN(sizeof(struct xt_length_mtinfo1)),
+	.init           = length_mt_init,
+	.help           = length_mt_help,
+	.parse          = length_mt_parse,
+	.final_check    = length_mt_check,
+	.print          = length_mt_print,
+	.save           = length_mt_save,
+	.extra_opts     = length_mt_opts,
+};
+
+static struct xtables_match length_mt6_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "length",
+	.revision       = 1,
+	.family         = AF_INET6,
+	.size           = XT_ALIGN(sizeof(struct xt_length_mtinfo1)),
+	.userspacesize  = XT_ALIGN(sizeof(struct xt_length_mtinfo1)),
+	.init           = length_mt_init,
+	.help           = length_mt_help,
+	.parse          = length_mt_parse,
+	.final_check    = length_mt_check,
+	.print          = length_mt_print,
+	.save           = length_mt_save,
+	.extra_opts     = length_mt_opts,
+};
+
 void _init(void)
 {
 	xtables_register_match(&length_match);
 	xtables_register_match(&length_match6);
+	xtables_register_match(&length_mt_reg);
+	xtables_register_match(&length_mt6_reg);
 }
Index: iptables-modules/extensions/libxt_length.man
===================================================================
--- /dev/null
+++ iptables-modules/extensions/libxt_length.man
@@ -0,0 +1,18 @@
+This module matches the length of a packet against a specific value or range of
+values.
+.TP
+[\fB!\fR] \fB--length\fR \fIlength\fR[\fB:\fR\fIlength\fR]
+Match exact length or length range.
+.TP
+\fB--layer3\fR
+Match the layer3 frame size (e.g. IPv4/v6 header plus payload).
+.TP
+\fB--layer4\fR
+Match the layer4 frame size (e.g. TCP/UDP header plus payload).
+.TP
+\fB--layer5\fR
+Match the layer5 frame size (e.g. TCP/UDP payload, often called layer7).
+.PP
+If no --layer* option is given, --layer3 is assumed by default. Note that using
+--layer5 may not match a packet if it is not one of the recognized types
+(currently TCP, UDP, UDPLite, ICMP, AH and ESP) or which has no 5th layer.
Index: iptables-modules/include/linux/netfilter/xt_length.h
===================================================================
--- iptables-modules.orig/include/linux/netfilter/xt_length.h
+++ iptables-modules/include/linux/netfilter/xt_length.h
@@ -6,4 +6,22 @@ struct xt_length_info {
     u_int8_t	invert;
 };
 
+enum {
+	XT_LENGTH_INVERT = 1 << 0,
+
+	/* IP header plus payload */
+	XT_LENGTH_LAYER3 = 1 << 3,
+
+	/* TCP/UDP/etc. header plus payload */
+	XT_LENGTH_LAYER4 = 1 << 4,
+
+	/* TCP/UDP/etc. payload */
+	XT_LENGTH_LAYER5 = 1 << 5,
+};
+
+struct xt_length_mtinfo1 {
+	u_int32_t min, max;
+	u_int16_t flags;
+};
+
 #endif /*_XT_LENGTH_H*/
