From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 14/17] libxt_limit: use guided option parser
Date: Mon,  9 May 2011 21:55:08 +0200
Message-ID: <1304970912-11520-15-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49373 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab1EITzc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:32 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_limit.c |   53 ++++++++++++++++++--------------------=
-------
 1 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index c4ba58b..b15b02f 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -3,20 +3,21 @@
  * J=C3=A9r=C3=B4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
  * Herv=C3=A9 Eychenne    <rv@wallfire.org>
  */
-#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
-#include <stddef.h>
 #include <linux/netfilter/x_tables.h>
-/* For 64bit kernel / 32bit userspace */
 #include <linux/netfilter/xt_limit.h>
=20
 #define XT_LIMIT_AVG	"3/hour"
 #define XT_LIMIT_BURST	5
=20
+enum {
+	O_LIMIT =3D 0,
+	O_BURST,
+};
+
 static void limit_help(void)
 {
 	printf(
@@ -28,10 +29,12 @@ static void limit_help(void)
 XT_LIMIT_BURST);
 }
=20
-static const struct option limit_opts[] =3D {
-	{.name =3D "limit",       .has_arg =3D true, .val =3D '%'},
-	{.name =3D "limit-burst", .has_arg =3D true, .val =3D '$'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry limit_opts[] =3D {
+	{.name =3D "limit", .id =3D O_LIMIT, .type =3D XTTYPE_STRING},
+	{.name =3D "limit-burst", .id =3D O_BURST, .type =3D XTTYPE_UINT32,
+	 .flags =3D XTOPT_PUT, XTOPT_POINTER(struct xt_rateinfo, burst),
+	 .min =3D 0, .max =3D 10000},
+	XTOPT_TABLEEND,
 };
=20
 static
@@ -85,35 +88,21 @@ static void limit_init(struct xt_entry_match *m)
 			   "Sorry: burst too large for that avg rate.\n");
 */
=20
-static int
-limit_parse(int c, char **argv, int invert, unsigned int *flags,
-            const void *entry, struct xt_entry_match **match)
+static void limit_parse(struct xt_option_call *cb)
 {
-	struct xt_rateinfo *r =3D (struct xt_rateinfo *)(*match)->data;
-	unsigned int num;
-
-	switch(c) {
-	case '%':
-		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv)) break;
-		if (!parse_rate(optarg, &r->avg))
-			xtables_error(PARAMETER_PROBLEM,
-				   "bad rate `%s'", optarg);
-		break;
+	struct xt_rateinfo *r =3D cb->data;
=20
-	case '$':
-		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv)) break;
-		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_LIMIT:
+		if (!parse_rate(cb->arg, &r->avg))
 			xtables_error(PARAMETER_PROBLEM,
-				   "bad --limit-burst `%s'", optarg);
-		r->burst =3D num;
+				   "bad rate \"%s\"'", cb->arg);
 		break;
 	}
-
-	if (invert)
+	if (cb->invert)
 		xtables_error(PARAMETER_PROBLEM,
 			   "limit does not support invert");
-
-	return 1;
 }
=20
 static const struct rates
@@ -162,10 +151,10 @@ static struct xtables_match limit_match =3D {
 	.userspacesize	=3D offsetof(struct xt_rateinfo, prev),
 	.help		=3D limit_help,
 	.init		=3D limit_init,
-	.parse		=3D limit_parse,
+	.x6_parse	=3D limit_parse,
 	.print		=3D limit_print,
 	.save		=3D limit_save,
-	.extra_opts	=3D limit_opts,
+	.x6_options	=3D limit_opts,
 };
=20
 void _init(void)
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
