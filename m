From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 28/28] libxt_u32: use guided option parser
Date: Tue, 12 Apr 2011 16:23:43 +0200
Message-ID: <1302618224-9449-29-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54710 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503Ab1DLOYR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:17 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_u32.c |   39 +++++++++++++++++----------------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 7f102d4..0df28a8 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -10,22 +10,21 @@
  * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
  * Contact: <jengelh@computergmbh.de>
  */
-#include <sys/types.h>
 #include <ctype.h>
 #include <errno.h>
-#include <getopt.h>
-#include <netdb.h>
-#include <stdbool.h>
+#include <stdint.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <string.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_u32.h>
=20
-static const struct option u32_opts[] =3D {
-	{.name =3D "u32", .has_arg =3D true, .val =3D 'u'},
-	XT_GETOPT_TABLEEND,
+enum {
+	O_U32 =3D 0,
+};
+
+static const struct xt_option_entry u32_opts[] =3D {
+	{.name =3D "u32", .id =3D O_U32, .type =3D XTTYPE_STRING},
+	XTOPT_TABLEEND,
 };
=20
 static void u32_help(void)
@@ -86,7 +85,7 @@ static void u32_dump(const struct xt_u32 *data)
 }
=20
 /* string_to_number() is not quite what we need here ... */
-static uint32_t parse_number(char **s, int pos)
+static uint32_t parse_number(const char **s, int pos)
 {
 	uint32_t number;
 	char *end;
@@ -103,20 +102,16 @@ static uint32_t parse_number(char **s, int pos)
 	return number;
 }
=20
-static int u32_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
-		     const void *entry, struct xt_entry_match **match)
+static void u32_parse(struct xt_option_call *cb)
 {
-	struct xt_u32 *data =3D (void *)(*match)->data;
+	struct xt_u32 *data =3D cb->data;
 	unsigned int testind =3D 0, locind =3D 0, valind =3D 0;
 	struct xt_u32_test *ct =3D &data->tests[testind]; /* current test */
-	char *arg =3D optarg; /* the argument string */
-	char *start =3D arg;
+	const char *arg =3D cb->arg; /* the argument string */
+	const char *start =3D cb->arg;
 	int state =3D 0;
=20
-	if (c !=3D 'u')
-		return 0;
-
-	data->invert =3D invert;
+	data->invert =3D cb->invert;
=20
 	/*
 	 * states:
@@ -145,7 +140,7 @@ static int u32_parse(int c, char **argv, int invert=
, unsigned int *flags,
 				xtables_error(PARAMETER_PROBLEM,
 				           "u32: at char %u: too many \"&&\"s",
 				           (unsigned int)(arg - start));
-			return 1;
+			return;
 		}
=20
 		if (state =3D=3D 0) {
@@ -274,10 +269,10 @@ static struct xtables_match u32_match =3D {
 	.size          =3D XT_ALIGN(sizeof(struct xt_u32)),
 	.userspacesize =3D XT_ALIGN(sizeof(struct xt_u32)),
 	.help          =3D u32_help,
-	.parse         =3D u32_parse,
 	.print         =3D u32_print,
 	.save          =3D u32_save,
-	.extra_opts    =3D u32_opts,
+	.x6_parse      =3D u32_parse,
+	.x6_options    =3D u32_opts,
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
