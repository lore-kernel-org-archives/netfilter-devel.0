From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 21/28] libxt_TCPOPTSTRIP: use guided option parser
Date: Tue, 12 Apr 2011 16:23:36 +0200
Message-ID: <1302618224-9449-22-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54684 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380Ab1DLOYJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:09 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TCPOPTSTRIP.c |   46 ++++++++++----------------------=
-------
 1 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTST=
RIP.c
index 338a311..43320d1 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -4,21 +4,17 @@
  * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
  * Jan Engelhardt <jengelh@computergmbh.de>
  */
-#include <getopt.h>
-#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
-#include <stdlib.h>
 #include <xtables.h>
 #include <netinet/tcp.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_TCPOPTSTRIP.h>
 #ifndef TCPOPT_MD5SIG
 #	define TCPOPT_MD5SIG 19
 #endif
=20
 enum {
-	FLAG_STRIP =3D 1 << 0,
+	O_STRIP_OPTION =3D 0,
 };
=20
 struct tcp_optionmap {
@@ -26,9 +22,9 @@ struct tcp_optionmap {
 	const unsigned int option;
 };
=20
-static const struct option tcpoptstrip_tg_opts[] =3D {
-	{.name =3D "strip-options", .has_arg =3D true, .val =3D 's'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry tcpoptstrip_tg_opts[] =3D {
+	{.name =3D "strip-options", .id =3D O_STRIP_OPTION, .type =3D XTTYPE_=
STRING},
+	XTOPT_TABLEEND,
 };
=20
 static const struct tcp_optionmap tcp_optionmap[] =3D {
@@ -56,7 +52,8 @@ static void tcpoptstrip_tg_help(void)
 		printf("    %-14s    strip \"%s\" option\n", w->name, w->desc);
 }
=20
-static void parse_list(struct xt_tcpoptstrip_target_info *info, char *=
arg)
+static void
+parse_list(struct xt_tcpoptstrip_target_info *info, const char *arg)
 {
 	unsigned int option;
 	char *p;
@@ -94,30 +91,12 @@ static void parse_list(struct xt_tcpoptstrip_target=
_info *info, char *arg)
 	}
 }
=20
-static int tcpoptstrip_tg_parse(int c, char **argv, int invert,
-                                unsigned int *flags, const void *entry=
,
-                                struct xt_entry_target **target)
+static void tcpoptstrip_tg_parse(struct xt_option_call *cb)
 {
-	struct xt_tcpoptstrip_target_info *info =3D (void *)(*target)->data;
-
-	switch (c) {
-	case 's':
-		if (*flags & FLAG_STRIP)
-			xtables_error(PARAMETER_PROBLEM,
-			           "You can specify --strip-options only once");
-		parse_list(info, optarg);
-		*flags |=3D FLAG_STRIP;
-		return true;
-	}
-
-	return false;
-}
+	struct xt_tcpoptstrip_target_info *info =3D cb->data;
=20
-static void tcpoptstrip_tg_check(unsigned int flags)
-{
-	if (flags =3D=3D 0)
-		xtables_error(PARAMETER_PROBLEM,
-		           "TCPOPTSTRIP: --strip-options parameter required");
+	xtables_option_parse(cb);
+	parse_list(info, cb->arg);
 }
=20
 static void
@@ -176,11 +155,10 @@ static struct xtables_target tcpoptstrip_tg_reg =3D=
 {
 	.size          =3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)=
),
 	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)=
),
 	.help          =3D tcpoptstrip_tg_help,
-	.parse         =3D tcpoptstrip_tg_parse,
-	.final_check   =3D tcpoptstrip_tg_check,
 	.print         =3D tcpoptstrip_tg_print,
 	.save          =3D tcpoptstrip_tg_save,
-	.extra_opts    =3D tcpoptstrip_tg_opts,
+	.x6_parse      =3D tcpoptstrip_tg_parse,
+	.x6_options    =3D tcpoptstrip_tg_opts,
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
