From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/9] libxt_TOS: use guided option parser
Date: Sun,  1 May 2011 13:50:24 +0200
Message-ID: <1304250630-6150-5-git-send-email-jengelh@medozas.de>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50002 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab1EALui (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 May 2011 07:50:38 -0400
In-Reply-To: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TOS.c |  137 ++++++++++++++++++++--------------------=
--------
 include/xtables.h.in   |    5 ++
 xtoptions.c            |   81 ++++++++++++++++++++++++++++
 3 files changed, 143 insertions(+), 80 deletions(-)

diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index 58ff2fc..cef5876 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -2,7 +2,7 @@
  * Shared library add-on to iptables to add TOS target support
  *
  * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
- * Contact: Jan Engelhardt <jengelh@computergmbh.de>
+ * Contact: Jan Engelhardt <jengelh@medozas.de>
  */
 #include <getopt.h>
 #include <stdbool.h>
@@ -20,20 +20,33 @@ struct ipt_tos_target_info {
 };
=20
 enum {
-	FLAG_TOS =3D 1 << 0,
+	O_SET_TOS =3D 0,
+	O_AND_TOS,
+	O_OR_TOS,
+	O_XOR_TOS,
+	F_SET_TOS =3D 1 << O_SET_TOS,
+	F_AND_TOS =3D 1 << O_AND_TOS,
+	F_OR_TOS  =3D 1 << O_OR_TOS,
+	F_XOR_TOS =3D 1 << O_XOR_TOS,
+	F_ANY     =3D F_SET_TOS | F_AND_TOS | F_OR_TOS | F_XOR_TOS,
 };
=20
-static const struct option tos_tg_opts_v0[] =3D {
-	{.name =3D "set-tos", .has_arg =3D true, .val =3D '=3D'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry tos_tg_opts_v0[] =3D {
+	{.name =3D "set-tos", .id =3D O_SET_TOS, .type =3D XTTYPE_TOSMASK,
+	 .excl =3D F_ANY, .max =3D 0xFF},
+	XTOPT_TABLEEND,
 };
=20
-static const struct option tos_tg_opts[] =3D {
-	{.name =3D "set-tos", .has_arg =3D true, .val =3D '=3D'},
-	{.name =3D "and-tos", .has_arg =3D true, .val =3D '&'},
-	{.name =3D "or-tos",  .has_arg =3D true, .val =3D '|'},
-	{.name =3D "xor-tos", .has_arg =3D true, .val =3D '^'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry tos_tg_opts[] =3D {
+	{.name =3D "set-tos", .id =3D O_SET_TOS, .type =3D XTTYPE_TOSMASK,
+	 .excl =3D F_ANY, .max =3D 0x3F},
+	{.name =3D "and-tos", .id =3D O_AND_TOS, .type =3D XTTYPE_UINT8,
+	 .excl =3D F_ANY},
+	{.name =3D "or-tos", .id =3D O_OR_TOS, .type =3D XTTYPE_UINT8,
+	 .excl =3D F_ANY},
+	{.name =3D "xor-tos", .id =3D O_XOR_TOS, .type =3D XTTYPE_UINT8,
+	 .excl =3D F_ANY},
+	XTOPT_TABLEEND,
 };
=20
 static void tos_tg_help_v0(void)
@@ -78,84 +91,48 @@ XTABLES_VERSION);
 );
 }
=20
-static int tos_tg_parse_v0(int c, char **argv, int invert, unsigned in=
t *flags,
-                           const void *entry, struct xt_entry_target *=
*target)
+static void tos_tg_parse_v0(struct xt_option_call *cb)
 {
-	struct ipt_tos_target_info *info =3D (void *)(*target)->data;
-	struct tos_value_mask tvm;
-
-	switch (c) {
-	case '=3D':
-		xtables_param_act(XTF_ONLY_ONCE, "TOS", "--set-tos", *flags & FLAG_T=
OS);
-		xtables_param_act(XTF_NO_INVERT, "TOS", "--set-tos", invert);
-		if (!tos_parse_symbolic(optarg, &tvm, 0xFF))
-			xtables_param_act(XTF_BAD_VALUE, "TOS", "--set-tos", optarg);
-		if (tvm.mask !=3D 0xFF)
-			xtables_error(PARAMETER_PROBLEM, "tos match: Your kernel "
-			           "is too old to support anything besides "
-				   "/0xFF as a mask.");
-		info->tos =3D tvm.value;
-		*flags |=3D FLAG_TOS;
-		return true;
-	}
-
-	return false;
+	struct ipt_tos_target_info *info =3D cb->data;
+
+	xtables_option_parse(cb);
+	if (cb->val.tos_mask !=3D 0xFF)
+		xtables_error(PARAMETER_PROBLEM, "tos match: Your kernel "
+		           "is too old to support anything besides "
+			   "/0xFF as a mask.");
+	info->tos =3D cb->val.tos_value;
 }
=20
-static int tos_tg_parse(int c, char **argv, int invert, unsigned int *=
flags,
-                         const void *entry, struct xt_entry_target **t=
arget)
+static void tos_tg_parse(struct xt_option_call *cb)
 {
-	struct xt_tos_target_info *info =3D (void *)(*target)->data;
-	struct tos_value_mask tvm;
-	unsigned int bits;
-
-	switch (c) {
-	case '=3D': /* --set-tos */
-		xtables_param_act(XTF_ONLY_ONCE, "TOS", "--set-tos", *flags & FLAG_T=
OS);
-		xtables_param_act(XTF_NO_INVERT, "TOS", "--set-tos", invert);
-		if (!tos_parse_symbolic(optarg, &tvm, 0x3F))
-			xtables_param_act(XTF_BAD_VALUE, "TOS", "--set-tos", optarg);
-		info->tos_value =3D tvm.value;
-		info->tos_mask  =3D tvm.mask;
-		break;
+	struct xt_tos_target_info *info =3D cb->data;
=20
-	case '&': /* --and-tos */
-		xtables_param_act(XTF_ONLY_ONCE, "TOS", "--and-tos", *flags & FLAG_T=
OS);
-		xtables_param_act(XTF_NO_INVERT, "TOS", "--and-tos", invert);
-		if (!xtables_strtoui(optarg, NULL, &bits, 0, UINT8_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "TOS", "--and-tos", optarg);
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SET_TOS:
+		info->tos_value =3D cb->val.tos_value;
+		info->tos_mask  =3D cb->val.tos_mask;
+		break;
+	case O_AND_TOS:
 		info->tos_value =3D 0;
-		info->tos_mask  =3D ~bits;
+		info->tos_mask  =3D ~cb->val.u8;
 		break;
-
-	case '|': /* --or-tos */
-		xtables_param_act(XTF_ONLY_ONCE, "TOS", "--or-tos", *flags & FLAG_TO=
S);
-		xtables_param_act(XTF_NO_INVERT, "TOS", "--or-tos", invert);
-		if (!xtables_strtoui(optarg, NULL, &bits, 0, UINT8_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "TOS", "--or-tos", optarg);
-		info->tos_value =3D bits;
-		info->tos_mask  =3D bits;
+	case O_OR_TOS:
+		info->tos_value =3D cb->val.u8;
+		info->tos_mask  =3D cb->val.u8;
 		break;
-
-	case '^': /* --xor-tos */
-		xtables_param_act(XTF_ONLY_ONCE, "TOS", "--xor-tos", *flags & FLAG_T=
OS);
-		xtables_param_act(XTF_NO_INVERT, "TOS", "--xor-tos", invert);
-		if (!xtables_strtoui(optarg, NULL, &bits, 0, UINT8_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "TOS", "--xor-tos", optarg);
-		info->tos_value =3D bits;
+	case O_XOR_TOS:
+		info->tos_value =3D cb->val.u8;
 		info->tos_mask  =3D 0;
 		break;
 	}
-
-	*flags |=3D FLAG_TOS;
-	return true;
 }
=20
-static void tos_tg_check(unsigned int flags)
+static void tos_tg_check(struct xt_fcheck_call *cb)
 {
-	if (flags =3D=3D 0)
+	if (!(cb->xflags & F_ANY))
 		xtables_error(PARAMETER_PROBLEM,
-		           "TOS: The --set-tos parameter is required");
+		           "TOS: An action is required");
 }
=20
 static void tos_tg_print_v0(const void *ip,
@@ -215,11 +192,11 @@ static struct xtables_target tos_tg_reg[] =3D {
 		.size          =3D XT_ALIGN(sizeof(struct xt_tos_target_info)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct xt_tos_target_info)),
 		.help          =3D tos_tg_help_v0,
-		.parse         =3D tos_tg_parse_v0,
-		.final_check   =3D tos_tg_check,
 		.print         =3D tos_tg_print_v0,
 		.save          =3D tos_tg_save_v0,
-		.extra_opts    =3D tos_tg_opts_v0,
+		.x6_parse      =3D tos_tg_parse_v0,
+		.x6_fcheck     =3D tos_tg_check,
+		.x6_options    =3D tos_tg_opts_v0,
 	},
 	{
 		.version       =3D XTABLES_VERSION,
@@ -229,11 +206,11 @@ static struct xtables_target tos_tg_reg[] =3D {
 		.size          =3D XT_ALIGN(sizeof(struct xt_tos_target_info)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct xt_tos_target_info)),
 		.help          =3D tos_tg_help,
-		.parse         =3D tos_tg_parse,
-		.final_check   =3D tos_tg_check,
 		.print         =3D tos_tg_print,
 		.save          =3D tos_tg_save,
-		.extra_opts    =3D tos_tg_opts,
+		.x6_parse      =3D tos_tg_parse,
+		.x6_fcheck     =3D tos_tg_check,
+		.x6_options    =3D tos_tg_opts,
 	},
 };
=20
diff --git a/include/xtables.h.in b/include/xtables.h.in
index a9a9ffa..b06ab61 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -50,6 +50,7 @@ struct in_addr;
  * %XTTYPE_UINT*:	standard integer
  * %XTTYPE_UINT*RC:	colon-separated range of standard integers
  * %XTTYPE_STRING:	arbitrary string
+ * %XTTYPE_TOSMASK:	8-bit TOS value with optional mask
  * %XTTYPE_MARKMASK32:	32-bit mark with optional mask
  * %XTTYPE_SYSLOGLEVEL:	syslog level by name or number
  * %XTTYPE_ONEHOST:	one host or address (union nf_inet_addr)
@@ -67,6 +68,7 @@ enum xt_option_type {
 	XTTYPE_UINT32RC,
 	XTTYPE_UINT64RC,
 	XTTYPE_STRING,
+	XTTYPE_TOSMASK,
 	XTTYPE_MARKMASK32,
 	XTTYPE_SYSLOGLEVEL,
 	XTTYPE_ONEHOST,
@@ -132,6 +134,9 @@ struct xt_option_call {
 		uint64_t u64, u64_range[2];
 		union nf_inet_addr inetaddr;
 		struct {
+			uint8_t tos_value, tos_mask;
+		};
+		struct {
 			uint32_t mark, mask;
 		};
 	} val;
diff --git a/xtoptions.c b/xtoptions.c
index 8478d26..69e43e9 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -19,8 +19,12 @@
 #include <string.h>
 #include <syslog.h>
 #include <arpa/inet.h>
+#include <netinet/ip.h>
 #include "xtables.h"
 #include "xshared.h"
+#ifndef IPTOS_NORMALSVC
+#	define IPTOS_NORMALSVC 0
+#endif
=20
 #define XTOPT_MKPTR(cb) \
 	((void *)((char *)(cb)->data + (cb)->entry->ptroff))
@@ -33,6 +37,10 @@ struct syslog_level {
 	uint8_t level;
 };
=20
+struct tos_value_mask {
+	uint8_t value, mask;
+};
+
 /**
  * Creates getopt options from the x6-style option map, and assigns ea=
ch a
  * getopt id.
@@ -232,6 +240,78 @@ static void xtopt_parse_string(struct xt_option_ca=
ll *cb)
 	p[z] =3D '\0';
 }
=20
+static const struct tos_symbol_info {
+	unsigned char value;
+	const char *name;
+} tos_symbol_names[] =3D {
+	{IPTOS_LOWDELAY,    "Minimize-Delay"},
+	{IPTOS_THROUGHPUT,  "Maximize-Throughput"},
+	{IPTOS_RELIABILITY, "Maximize-Reliability"},
+	{IPTOS_MINCOST,     "Minimize-Cost"},
+	{IPTOS_NORMALSVC,   "Normal-Service"},
+	{},
+};
+
+/*
+ * tos_parse_numeric - parse a string like "15/255"
+ *
+ * @str:	input string
+ * @tvm:	(value/mask) tuple
+ * @max:	maximum allowed value (must be pow(2,some_int)-1)
+ */
+static bool tos_parse_numeric(const char *str, struct xt_option_call *=
cb,
+                              unsigned int max)
+{
+	unsigned int value;
+	char *end;
+
+	xtables_strtoui(str, &end, &value, 0, max);
+	cb->val.tos_value =3D value;
+	cb->val.tos_mask  =3D max;
+
+	if (*end =3D=3D '/') {
+		const char *p =3D end + 1;
+
+		if (!xtables_strtoui(p, &end, &value, 0, max))
+			xtables_error(PARAMETER_PROBLEM, "Illegal value: \"%s\"",
+			           str);
+		cb->val.tos_mask =3D value;
+	}
+
+	if (*end !=3D '\0')
+		xtables_error(PARAMETER_PROBLEM, "Illegal value: \"%s\"", str);
+	return true;
+}
+
+/**
+ * @str:	input string
+ * @tvm:	(value/mask) tuple
+ * @def_mask:	mask to force when a symbolic name is used
+ */
+static void xtopt_parse_tosmask(struct xt_option_call *cb)
+{
+	const struct tos_symbol_info *symbol;
+	char *tmp;
+
+	if (xtables_strtoui(cb->arg, &tmp, NULL, 0, UINT8_MAX)) {
+		tos_parse_numeric(cb->arg, cb, UINT8_MAX);
+		return;
+	}
+	/*
+	 * This is our way we deal with different defaults
+	 * for different revisions.
+	 */
+	cb->val.tos_mask =3D cb->entry->max;
+	for (symbol =3D tos_symbol_names; symbol->name !=3D NULL; ++symbol)
+		if (strcasecmp(cb->arg, symbol->name) =3D=3D 0) {
+			cb->val.tos_value =3D symbol->value;
+			return;
+		}
+
+	xtables_error(PARAMETER_PROBLEM, "Symbolic name \"%s\" is unknown",
+		      cb->arg);
+}
+
 /**
  * Validate the input for being conformant to "mark[/mask]".
  */
@@ -413,6 +493,7 @@ static void (*const xtopt_subparse[])(struct xt_opt=
ion_call *) =3D {
 	[XTTYPE_UINT32RC]    =3D xtopt_parse_mint,
 	[XTTYPE_UINT64RC]    =3D xtopt_parse_mint,
 	[XTTYPE_STRING]      =3D xtopt_parse_string,
+	[XTTYPE_TOSMASK]     =3D xtopt_parse_tosmask,
 	[XTTYPE_MARKMASK32]  =3D xtopt_parse_markmask,
 	[XTTYPE_SYSLOGLEVEL] =3D xtopt_parse_sysloglevel,
 	[XTTYPE_ONEHOST]     =3D xtopt_parse_onehost,
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
