From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 17/17] libxt_conntrack: use guided option parser
Date: Mon,  9 May 2011 21:55:11 +0200
Message-ID: <1304970912-11520-18-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49385 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab1EITzg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:36 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |  670 ++++++++++++++--------------------=
--------
 1 files changed, 219 insertions(+), 451 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.=
c
index 8312d04..2fb3644 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -6,21 +6,14 @@
  *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
  *	Jan Engelhardt <jengelh@computergmbh.de>
  */
-#include <sys/socket.h>
-#include <sys/types.h>
-#include <ctype.h>
-#include <getopt.h>
-#include <netdb.h>
 #include <stdbool.h>
-#include <stddef.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <xtables.h>
-#include <linux/netfilter.h>
 #include <linux/netfilter/xt_conntrack.h>
 #include <linux/netfilter/nf_conntrack_common.h>
-#include <arpa/inet.h>
=20
 struct ip_conntrack_old_tuple {
 	struct {
@@ -55,6 +48,22 @@ struct xt_conntrack_info {
 	uint8_t invflags;
 };
=20
+enum {
+	O_CTSTATE =3D 0,
+	O_CTPROTO,
+	O_CTORIGSRC,
+	O_CTORIGDST,
+	O_CTREPLSRC,
+	O_CTREPLDST,
+	O_CTORIGSRCPORT,
+	O_CTORIGDSTPORT,
+	O_CTREPLSRCPORT,
+	O_CTREPLDSTPORT,
+	O_CTSTATUS,
+	O_CTEXPIRE,
+	O_CTDIR,
+};
+
 static void conntrack_mt_help(void)
 {
 	printf(
@@ -79,34 +88,59 @@ static void conntrack_mt_help(void)
 "    --ctdir {ORIGINAL|REPLY}   Flow direction of packet\n");
 }
=20
-static const struct option conntrack_mt_opts_v0[] =3D {
-	{.name =3D "ctstate",   .has_arg =3D true, .val =3D '1'},
-	{.name =3D "ctproto",   .has_arg =3D true, .val =3D '2'},
-	{.name =3D "ctorigsrc", .has_arg =3D true, .val =3D '3'},
-	{.name =3D "ctorigdst", .has_arg =3D true, .val =3D '4'},
-	{.name =3D "ctreplsrc", .has_arg =3D true, .val =3D '5'},
-	{.name =3D "ctrepldst", .has_arg =3D true, .val =3D '6'},
-	{.name =3D "ctstatus",  .has_arg =3D true, .val =3D '7'},
-	{.name =3D "ctexpire",  .has_arg =3D true, .val =3D '8'},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_conntrack_info /* for v0 */
+static const struct xt_option_entry conntrack_mt_opts_v0[] =3D {
+	{.name =3D "ctstate", .id =3D O_CTSTATE, .type =3D XTTYPE_STRING,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctproto", .id =3D O_CTPROTO, .type =3D XTTYPE_PROTOCOL,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctorigsrc", .id =3D O_CTORIGSRC, .type =3D XTTYPE_HOST,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctorigdst", .id =3D O_CTORIGDST, .type =3D XTTYPE_HOST,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctreplsrc", .id =3D O_CTREPLSRC, .type =3D XTTYPE_HOST,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctrepldst", .id =3D O_CTREPLDST, .type =3D XTTYPE_HOST,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctstatus", .id =3D O_CTSTATUS, .type =3D XTTYPE_STRING,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctexpire", .id =3D O_CTEXPIRE, .type =3D XTTYPE_UINT32RC,
+	 .flags =3D XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
-
-static const struct option conntrack_mt_opts[] =3D {
-	{.name =3D "ctstate",       .has_arg =3D true, .val =3D '1'},
-	{.name =3D "ctproto",       .has_arg =3D true, .val =3D '2'},
-	{.name =3D "ctorigsrc",     .has_arg =3D true, .val =3D '3'},
-	{.name =3D "ctorigdst",     .has_arg =3D true, .val =3D '4'},
-	{.name =3D "ctreplsrc",     .has_arg =3D true, .val =3D '5'},
-	{.name =3D "ctrepldst",     .has_arg =3D true, .val =3D '6'},
-	{.name =3D "ctstatus",      .has_arg =3D true, .val =3D '7'},
-	{.name =3D "ctexpire",      .has_arg =3D true, .val =3D '8'},
-	{.name =3D "ctorigsrcport", .has_arg =3D true, .val =3D 'a'},
-	{.name =3D "ctorigdstport", .has_arg =3D true, .val =3D 'b'},
-	{.name =3D "ctreplsrcport", .has_arg =3D true, .val =3D 'c'},
-	{.name =3D "ctrepldstport", .has_arg =3D true, .val =3D 'd'},
-	{.name =3D "ctdir",         .has_arg =3D true, .val =3D 'e'},
-	{.name =3D NULL},
+#undef s
+
+#define s struct xt_conntrack_mtinfo3 /* for v1-v3 */
+/* We exploit the fact that v1-v3 share the same layout */
+static const struct xt_option_entry conntrack_mt_opts[] =3D {
+	{.name =3D "ctstate", .id =3D O_CTSTATE, .type =3D XTTYPE_STRING,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctproto", .id =3D O_CTPROTO, .type =3D XTTYPE_PROTOCOL,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctorigsrc", .id =3D O_CTORIGSRC, .type =3D XTTYPE_HOSTMAS=
K,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctorigdst", .id =3D O_CTORIGDST, .type =3D XTTYPE_HOSTMAS=
K,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctreplsrc", .id =3D O_CTREPLSRC, .type =3D XTTYPE_HOSTMAS=
K,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctrepldst", .id =3D O_CTREPLDST, .type =3D XTTYPE_HOSTMAS=
K,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctstatus", .id =3D O_CTSTATUS, .type =3D XTTYPE_STRING,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctexpire", .id =3D O_CTEXPIRE, .type =3D XTTYPE_UINT32RC,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctorigsrcport", .id =3D O_CTORIGSRCPORT, .type =3D XTTYPE=
_PORTRC,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctorigdstport", .id =3D O_CTORIGDSTPORT, .type =3D XTTYPE=
_PORTRC,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctreplsrcport", .id =3D O_CTREPLSRCPORT, .type =3D XTTYPE=
_PORTRC,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctrepldstport", .id =3D O_CTREPLDSTPORT, .type =3D XTTYPE=
_PORTRC,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "ctdir", .id =3D O_CTDIR, .type =3D XTTYPE_STRING},
+	XTOPT_TABLEEND,
 };
+#undef s
=20
 static int
 parse_state(const char *state, size_t len, struct xt_conntrack_info *s=
info)
@@ -320,39 +354,21 @@ conntrack_ps_expires(struct xt_conntrack_mtinfo3 =
*info, const char *s)
 	info->expires_max =3D max;
 }
=20
-static int conntrack_parse(int c, char **argv, int invert, unsigned in=
t *flags,
-                           const void *entry, struct xt_entry_match **=
match)
+static void conntrack_parse(struct xt_option_call *cb)
 {
-	struct xt_conntrack_info *sinfo =3D (void *)(*match)->data;
-	char *protocol =3D NULL;
-	unsigned int naddrs =3D 0;
-	struct in_addr *addrs =3D NULL;
+	struct xt_conntrack_info *sinfo =3D cb->data;
=20
-
-	switch (c) {
-	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		parse_states(optarg, sinfo);
-		if (invert) {
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_CTSTATE:
+		parse_states(cb->arg, sinfo);
+		if (cb->invert)
 			sinfo->invflags |=3D XT_CONNTRACK_STATE;
-		}
-		sinfo->flags |=3D XT_CONNTRACK_STATE;
 		break;
-
-	case '2':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		if(invert)
+	case O_CTPROTO:
+		if (cb->invert)
 			sinfo->invflags |=3D XT_CONNTRACK_PROTO;
-
-		/* Canonicalize into lower case */
-		for (protocol =3D optarg; *protocol; protocol++)
-			*protocol =3D tolower(*protocol);
-
-		protocol =3D optarg;
-		sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum =3D
-			xtables_parse_protocol(protocol);
+		sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum =3D cb->val.protocol;
=20
 		if (sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum =3D=3D 0
 		    && (sinfo->invflags & XT_INV_PROTO))
@@ -361,390 +377,151 @@ static int conntrack_parse(int c, char **argv, =
int invert, unsigned int *flags,
=20
 		sinfo->flags |=3D XT_CONNTRACK_PROTO;
 		break;
-
-	case '3':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		if (invert)
+	case O_CTORIGSRC:
+		if (cb->invert)
 			sinfo->invflags |=3D XT_CONNTRACK_ORIGSRC;
-
-		xtables_ipparse_any(optarg, &addrs,
-					&sinfo->sipmsk[IP_CT_DIR_ORIGINAL],
-					&naddrs);
-		if(naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-				"multiple IP addresses not allowed");
-
-		if(naddrs =3D=3D 1) {
-			sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip =3D addrs[0].s_addr;
-		}
-
+		sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip =3D cb->val.haddr.ip;
 		sinfo->flags |=3D XT_CONNTRACK_ORIGSRC;
 		break;
-
-	case '4':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		if (invert)
+	case O_CTORIGDST:
+		if (cb->invert)
 			sinfo->invflags |=3D XT_CONNTRACK_ORIGDST;
-
-		xtables_ipparse_any(optarg, &addrs,
-					&sinfo->dipmsk[IP_CT_DIR_ORIGINAL],
-					&naddrs);
-		if(naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-				"multiple IP addresses not allowed");
-
-		if(naddrs =3D=3D 1) {
-			sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip =3D addrs[0].s_addr;
-		}
-
+		sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip =3D cb->val.haddr.ip;
 		sinfo->flags |=3D XT_CONNTRACK_ORIGDST;
 		break;
-
-	case '5':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		if (invert)
+	case O_CTREPLSRC:
+		if (cb->invert)
 			sinfo->invflags |=3D XT_CONNTRACK_REPLSRC;
-
-		xtables_ipparse_any(optarg, &addrs,
-					&sinfo->sipmsk[IP_CT_DIR_REPLY],
-					&naddrs);
-		if(naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-				"multiple IP addresses not allowed");
-
-		if(naddrs =3D=3D 1) {
-			sinfo->tuple[IP_CT_DIR_REPLY].src.ip =3D addrs[0].s_addr;
-		}
-
+		sinfo->tuple[IP_CT_DIR_REPLY].src.ip =3D cb->val.haddr.ip;
 		sinfo->flags |=3D XT_CONNTRACK_REPLSRC;
 		break;
-
-	case '6':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		if (invert)
+	case O_CTREPLDST:
+		if (cb->invert)
 			sinfo->invflags |=3D XT_CONNTRACK_REPLDST;
-
-		xtables_ipparse_any(optarg, &addrs,
-					&sinfo->dipmsk[IP_CT_DIR_REPLY],
-					&naddrs);
-		if(naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-				"multiple IP addresses not allowed");
-
-		if(naddrs =3D=3D 1) {
-			sinfo->tuple[IP_CT_DIR_REPLY].dst.ip =3D addrs[0].s_addr;
-		}
-
+		sinfo->tuple[IP_CT_DIR_REPLY].dst.ip =3D cb->val.haddr.ip;
 		sinfo->flags |=3D XT_CONNTRACK_REPLDST;
 		break;
-
-	case '7':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		parse_statuses(optarg, sinfo);
-		if (invert) {
+	case O_CTSTATUS:
+		parse_statuses(cb->arg, sinfo);
+		if (cb->invert)
 			sinfo->invflags |=3D XT_CONNTRACK_STATUS;
-		}
 		sinfo->flags |=3D XT_CONNTRACK_STATUS;
 		break;
-
-	case '8':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		parse_expires(optarg, sinfo);
-		if (invert) {
+	case O_CTEXPIRE:
+		parse_expires(cb->arg, sinfo);
+		if (cb->invert)
 			sinfo->invflags |=3D XT_CONNTRACK_EXPIRES;
-		}
 		sinfo->flags |=3D XT_CONNTRACK_EXPIRES;
 		break;
 	}
-
-	*flags =3D sinfo->flags;
-	return 1;
 }
=20
-static void
-ct_parse_ports(const char *param, const char *str,
-	       u_int16_t *port_low, u_int16_t *port_high)
+static void conntrack_mt_parse(struct xt_option_call *cb, uint8_t rev)
 {
-	unsigned int port;
-	char *buf, *cp;
+	struct xt_conntrack_mtinfo3 *info =3D cb->data;
=20
-	buf =3D strdup(str);
-	cp =3D strchr(buf, ':');
-	if (cp !=3D NULL)
-		*cp =3D '\0';
-
-	if (!xtables_strtoui(buf, NULL, &port, 0, UINT16_MAX))
-		xtables_param_act(XTF_BAD_VALUE, "conntrack", param, buf);
-
-	if (port_high =3D=3D NULL) {
-		/* revision 0-2 do not support ranges */
-		if (cp !=3D NULL)
-			xtables_error(PARAMETER_PROBLEM, "conntrack: "
-				      "port ranges not supported");
-
-		*port_low =3D htons(port);
-	} else {
-		*port_low =3D port;
-
-		if (cp !=3D NULL) {
-			if (!xtables_strtoui(cp + 1, NULL, &port, 0, UINT16_MAX))
-				xtables_param_act(XTF_BAD_VALUE, "conntrack", param, buf);
-
-			*port_high =3D port;
-			if (*port_low > *port_high)
-				xtables_error(PARAMETER_PROBLEM,
-					      "invalid portrange (min > max)");
-		} else
-			*port_high =3D port;
-	}
-
-	free(buf);
-}
-
-
-static int
-conntrack_mt_parse(int c, bool invert, unsigned int *flags,
-                   struct xt_conntrack_mtinfo3 *info, bool v3)
-{
-	char *p;
-
-	switch (c) {
-	case '1': /* --ctstate */
-		conntrack_ps_states(info, optarg);
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_CTSTATE:
+		conntrack_ps_states(info, cb->arg);
 		info->match_flags |=3D XT_CONNTRACK_STATE;
-		if (invert)
+		if (cb->invert)
 			info->invert_flags |=3D XT_CONNTRACK_STATE;
 		break;
-
-	case '2': /* --ctproto */
-		/* Canonicalize into lower case */
-		for (p =3D optarg; *p !=3D '\0'; ++p)
-			*p =3D tolower(*p);
-		info->l4proto =3D xtables_parse_protocol(optarg);
-
+	case O_CTPROTO:
+		info->l4proto =3D cb->val.protocol;
 		if (info->l4proto =3D=3D 0 && (info->invert_flags & XT_INV_PROTO))
 			xtables_error(PARAMETER_PROBLEM, "conntrack: rule would "
 			           "never match protocol");
=20
 		info->match_flags |=3D XT_CONNTRACK_PROTO;
-		if (invert)
+		if (cb->invert)
 			info->invert_flags |=3D XT_CONNTRACK_PROTO;
 		break;
-
-	case '7': /* --ctstatus */
-		conntrack_ps_statuses(info, optarg);
+	case O_CTORIGSRC:
+		info->origsrc_addr =3D cb->val.haddr;
+		info->origsrc_mask =3D cb->val.hmask;
+		info->match_flags |=3D XT_CONNTRACK_ORIGSRC;
+		if (cb->invert)
+			info->invert_flags |=3D XT_CONNTRACK_ORIGSRC;
+		break;
+	case O_CTORIGDST:
+		info->origdst_addr =3D cb->val.haddr;
+		info->origdst_mask =3D cb->val.hmask;
+		info->match_flags |=3D XT_CONNTRACK_ORIGDST;
+		if (cb->invert)
+			info->invert_flags |=3D XT_CONNTRACK_ORIGDST;
+		break;
+	case O_CTREPLSRC:
+		info->replsrc_addr =3D cb->val.haddr;
+		info->replsrc_mask =3D cb->val.hmask;
+		info->match_flags |=3D XT_CONNTRACK_REPLSRC;
+		if (cb->invert)
+			info->invert_flags |=3D XT_CONNTRACK_REPLSRC;
+		break;
+	case O_CTREPLDST:
+		info->repldst_addr =3D cb->val.haddr;
+		info->repldst_mask =3D cb->val.hmask;
+		info->match_flags |=3D XT_CONNTRACK_REPLDST;
+		if (cb->invert)
+			info->invert_flags |=3D XT_CONNTRACK_REPLDST;
+		break;
+	case O_CTSTATUS:
+		conntrack_ps_statuses(info, cb->arg);
 		info->match_flags |=3D XT_CONNTRACK_STATUS;
-		if (invert)
+		if (cb->invert)
 			info->invert_flags |=3D XT_CONNTRACK_STATUS;
 		break;
-
-	case '8': /* --ctexpire */
-		conntrack_ps_expires(info, optarg);
+	case O_CTEXPIRE:
+		conntrack_ps_expires(info, cb->arg);
 		info->match_flags |=3D XT_CONNTRACK_EXPIRES;
-		if (invert)
+		if (cb->invert)
 			info->invert_flags |=3D XT_CONNTRACK_EXPIRES;
 		break;
-
-	case 'a': /* --ctorigsrcport */
-		ct_parse_ports("--ctorigsrcport", optarg,
-			       &info->origsrc_port,
-			       v3 ? &info->origsrc_port_high : NULL);
-
+	case O_CTORIGSRCPORT:
+		info->origsrc_port =3D cb->val.port_range[0];
+		info->origsrc_port =3D (cb->nvals =3D=3D 2) ? cb->val.port_range[1] =
:
+		                     cb->val.port_range[0];
 		info->match_flags |=3D XT_CONNTRACK_ORIGSRC_PORT;
-		if (invert)
+		if (cb->invert)
 			info->invert_flags |=3D XT_CONNTRACK_ORIGSRC_PORT;
 		break;
-
-	case 'b': /* --ctorigdstport */
-		ct_parse_ports("--ctorigdstport", optarg,
-			       &info->origdst_port,
-			       v3 ? &info->origdst_port_high : NULL);
-
+	case O_CTORIGDSTPORT:
+		info->origdst_port =3D cb->val.port_range[0];
+		info->origdst_port =3D (cb->nvals =3D=3D 2) ? cb->val.port_range[1] =
:
+		                     cb->val.port_range[0];
 		info->match_flags |=3D XT_CONNTRACK_ORIGDST_PORT;
-		if (invert)
+		if (cb->invert)
 			info->invert_flags |=3D XT_CONNTRACK_ORIGDST_PORT;
 		break;
-
-	case 'c': /* --ctreplsrcport */
-		ct_parse_ports("--ctreplsrcport", optarg,
-			       &info->replsrc_port,
-			       v3 ? &info->replsrc_port_high : NULL);
-
+	case O_CTREPLSRCPORT:
+		info->replsrc_port =3D cb->val.port_range[0];
+		info->replsrc_port =3D (cb->nvals =3D=3D 2) ? cb->val.port_range[1] =
:
+		                     cb->val.port_range[0];
 		info->match_flags |=3D XT_CONNTRACK_REPLSRC_PORT;
-		if (invert)
+		if (cb->invert)
 			info->invert_flags |=3D XT_CONNTRACK_REPLSRC_PORT;
 		break;
-
-	case 'd': /* --ctrepldstport */
-		ct_parse_ports("--ctrepldstport", optarg,
-			       &info->repldst_port,
-			       v3 ? &info->repldst_port_high : NULL);
-
+	case O_CTREPLDSTPORT:
+		info->repldst_port =3D cb->val.port_range[0];
+		info->repldst_port =3D (cb->nvals =3D=3D 2) ? cb->val.port_range[1] =
:
+		                     cb->val.port_range[0];
 		info->match_flags |=3D XT_CONNTRACK_REPLDST_PORT;
-		if (invert)
+		if (cb->invert)
 			info->invert_flags |=3D XT_CONNTRACK_REPLDST_PORT;
 		break;
-
-	case 'e': /* --ctdir */
-		xtables_param_act(XTF_NO_INVERT, "conntrack", "--ctdir", invert);
-		if (strcasecmp(optarg, "ORIGINAL") =3D=3D 0) {
+	case O_CTDIR:
+		if (strcasecmp(cb->arg, "ORIGINAL") =3D=3D 0) {
 			info->match_flags  |=3D XT_CONNTRACK_DIRECTION;
 			info->invert_flags &=3D ~XT_CONNTRACK_DIRECTION;
-		} else if (strcasecmp(optarg, "REPLY") =3D=3D 0) {
+		} else if (strcasecmp(cb->arg, "REPLY") =3D=3D 0) {
 			info->match_flags  |=3D XT_CONNTRACK_DIRECTION;
 			info->invert_flags |=3D XT_CONNTRACK_DIRECTION;
 		} else {
-			xtables_param_act(XTF_BAD_VALUE, "conntrack", "--ctdir", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "conntrack", "--ctdir", cb->arg);
 		}
 		break;
 	}
-
-	*flags =3D info->match_flags;
-	return true;
-}
-
-static int
-conntrack_mt4_parse(int c, bool invert, unsigned int *flags,
-                    struct xt_conntrack_mtinfo3 *info, bool v3)
-{
-	struct in_addr *addr =3D NULL;
-	unsigned int naddrs =3D 0;
-
-	switch (c) {
-	case '3': /* --ctorigsrc */
-		xtables_ipparse_any(optarg, &addr, &info->origsrc_mask.in,
-		                        &naddrs);
-		if (naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs =3D=3D 1)
-			memcpy(&info->origsrc_addr.in, addr, sizeof(*addr));
-		info->match_flags |=3D XT_CONNTRACK_ORIGSRC;
-		if (invert)
-			info->invert_flags |=3D XT_CONNTRACK_ORIGSRC;
-		break;
-
-	case '4': /* --ctorigdst */
-		xtables_ipparse_any(optarg, &addr, &info->origdst_mask.in,
-		                        &naddrs);
-		if (naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs =3D=3D 1)
-			memcpy(&info->origdst_addr.in, addr, sizeof(*addr));
-		info->match_flags |=3D XT_CONNTRACK_ORIGDST;
-		if (invert)
-			info->invert_flags |=3D XT_CONNTRACK_ORIGDST;
-		break;
-
-	case '5': /* --ctreplsrc */
-		xtables_ipparse_any(optarg, &addr, &info->replsrc_mask.in,
-		                        &naddrs);
-		if (naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs =3D=3D 1)
-			memcpy(&info->replsrc_addr.in, addr, sizeof(*addr));
-		info->match_flags |=3D XT_CONNTRACK_REPLSRC;
-		if (invert)
-			info->invert_flags |=3D XT_CONNTRACK_REPLSRC;
-		break;
-
-	case '6': /* --ctrepldst */
-		xtables_ipparse_any(optarg, &addr, &info->repldst_mask.in,
-		                        &naddrs);
-		if (naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs =3D=3D 1)
-			memcpy(&info->repldst_addr.in, addr, sizeof(*addr));
-		info->match_flags |=3D XT_CONNTRACK_REPLDST;
-		if (invert)
-			info->invert_flags |=3D XT_CONNTRACK_REPLDST;
-		break;
-
-
-	default:
-		return conntrack_mt_parse(c, invert, flags, info, v3);
-	}
-
-	*flags =3D info->match_flags;
-	return true;
-}
-
-static int
-conntrack_mt6_parse(int c, bool invert, unsigned int *flags,
-                    struct xt_conntrack_mtinfo3 *info, bool v3)
-{
-	struct in6_addr *addr =3D NULL;
-	unsigned int naddrs =3D 0;
-
-	switch (c) {
-	case '3': /* --ctorigsrc */
-		xtables_ip6parse_any(optarg, &addr,
-		                         &info->origsrc_mask.in6, &naddrs);
-		if (naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs =3D=3D 1)
-			memcpy(&info->origsrc_addr.in6, addr, sizeof(*addr));
-		info->match_flags |=3D XT_CONNTRACK_ORIGSRC;
-		if (invert)
-			info->invert_flags |=3D XT_CONNTRACK_ORIGSRC;
-		break;
-
-	case '4': /* --ctorigdst */
-		xtables_ip6parse_any(optarg, &addr,
-		                         &info->origdst_mask.in6, &naddrs);
-		if (naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs =3D=3D 1)
-			memcpy(&info->origdst_addr.in, addr, sizeof(*addr));
-		info->match_flags |=3D XT_CONNTRACK_ORIGDST;
-		if (invert)
-			info->invert_flags |=3D XT_CONNTRACK_ORIGDST;
-		break;
-
-	case '5': /* --ctreplsrc */
-		xtables_ip6parse_any(optarg, &addr,
-		                         &info->replsrc_mask.in6, &naddrs);
-		if (naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs =3D=3D 1)
-			memcpy(&info->replsrc_addr.in, addr, sizeof(*addr));
-		info->match_flags |=3D XT_CONNTRACK_REPLSRC;
-		if (invert)
-			info->invert_flags |=3D XT_CONNTRACK_REPLSRC;
-		break;
-
-	case '6': /* --ctrepldst */
-		xtables_ip6parse_any(optarg, &addr,
-		                         &info->repldst_mask.in6, &naddrs);
-		if (naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs =3D=3D 1)
-			memcpy(&info->repldst_addr.in, addr, sizeof(*addr));
-		info->match_flags |=3D XT_CONNTRACK_REPLDST;
-		if (invert)
-			info->invert_flags |=3D XT_CONNTRACK_REPLDST;
-		break;
-
-
-	default:
-		return conntrack_mt_parse(c, invert, flags, info, v3);
-	}
-
-	*flags =3D info->match_flags;
-	return true;
 }
=20
 #define cinfo_transform(r, l) \
@@ -754,65 +531,56 @@ conntrack_mt6_parse(int c, bool invert, unsigned =
int *flags,
 		(r)->status_mask =3D (l)->status_mask; \
 	} while (false);
=20
-static int
-conntrack1_mt4_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
-                     const void *entry, struct xt_entry_match **match)
+static void conntrack1_mt_parse(struct xt_option_call *cb)
 {
-	struct xt_conntrack_mtinfo1 *info =3D (void *)(*match)->data;
+	struct xt_conntrack_mtinfo1 *info =3D cb->data;
 	struct xt_conntrack_mtinfo3 up;
=20
+	memset(&up, 0, sizeof(up));
 	cinfo_transform(&up, info);
-	if (!conntrack_mt4_parse(c, invert, flags, &up, false))
-		return false;
-	cinfo_transform(info, &up);
-	return true;
-}
-
-static int
-conntrack1_mt6_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
-                     const void *entry, struct xt_entry_match **match)
-{
-	struct xt_conntrack_mtinfo1 *info =3D (void *)(*match)->data;
-	struct xt_conntrack_mtinfo3 up;
-
-	cinfo_transform(&up, info);
-	if (!conntrack_mt6_parse(c, invert, flags, &up, false))
-		return false;
+	cb->data =3D &up;
+	conntrack_mt_parse(cb, 3);
+	if (up.origsrc_port !=3D up.origsrc_port_high ||
+	    up.origdst_port !=3D up.origdst_port_high ||
+	    up.replsrc_port !=3D up.replsrc_port_high ||
+	    up.repldst_port !=3D up.repldst_port_high)
+		xtables_error(PARAMETER_PROBLEM,
+			"connlimit rev 1 does not support port ranges");
 	cinfo_transform(info, &up);
-	return true;
+	cb->data =3D info;
 }
=20
-static int
-conntrack2_mt4_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
-                     const void *entry, struct xt_entry_match **match)
+static void conntrack2_mt_parse(struct xt_option_call *cb)
 {
-	return conntrack_mt4_parse(c, invert, flags, (void *)(*match)->data, =
false);
-}
+#define cinfo2_transform(r, l) \
+		memcpy((r), (l), offsetof(typeof(*(l)), sizeof(*info));
=20
-static int
-conntrack2_mt6_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
-                     const void *entry, struct xt_entry_match **match)
-{
-	return conntrack_mt6_parse(c, invert, flags, (void *)(*match)->data, =
false);
-}
+	struct xt_conntrack_mtinfo2 *info =3D cb->data;
+	struct xt_conntrack_mtinfo3 up;
=20
-static int
-conntrack3_mt4_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
-                     const void *entry, struct xt_entry_match **match)
-{
-	return conntrack_mt4_parse(c, invert, flags, (void *)(*match)->data, =
true);
+	memset(&up, 0, sizeof(up));
+	memcpy(&up, info, sizeof(*info));
+	cb->data =3D &up;
+	conntrack_mt_parse(cb, 3);
+	if (up.origsrc_port !=3D up.origsrc_port_high ||
+	    up.origdst_port !=3D up.origdst_port_high ||
+	    up.replsrc_port !=3D up.replsrc_port_high ||
+	    up.repldst_port !=3D up.repldst_port_high)
+		xtables_error(PARAMETER_PROBLEM,
+			"connlimit rev 2 does not support port ranges");
+	memcpy(info, &up, sizeof(*info));
+	cb->data =3D info;
+#undef cinfo2_transform
 }
=20
-static int
-conntrack3_mt6_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
-                     const void *entry, struct xt_entry_match **match)
+static void conntrack3_mt_parse(struct xt_option_call *cb)
 {
-	return conntrack_mt6_parse(c, invert, flags, (void *)(*match)->data, =
true);
+	conntrack_mt_parse(cb, 3);
 }
=20
-static void conntrack_mt_check(unsigned int flags)
+static void conntrack_mt_check(struct xt_fcheck_call *cb)
 {
-	if (flags =3D=3D 0)
+	if (cb->xflags =3D=3D 0)
 		xtables_error(PARAMETER_PROBLEM, "conntrack: At least one option "
 		           "is required");
 }
@@ -1259,11 +1027,11 @@ static struct xtables_match conntrack_mt_reg[] =
=3D {
 		.size          =3D XT_ALIGN(sizeof(struct xt_conntrack_info)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct xt_conntrack_info)),
 		.help          =3D conntrack_mt_help,
-		.parse         =3D conntrack_parse,
-		.final_check   =3D conntrack_mt_check,
+		.x6_parse      =3D conntrack_parse,
+		.x6_fcheck     =3D conntrack_mt_check,
 		.print         =3D conntrack_print,
 		.save          =3D conntrack_save,
-		.extra_opts    =3D conntrack_mt_opts_v0,
+		.x6_options    =3D conntrack_mt_opts_v0,
 	},
 	{
 		.version       =3D XTABLES_VERSION,
@@ -1273,11 +1041,11 @@ static struct xtables_match conntrack_mt_reg[] =
=3D {
 		.size          =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 		.help          =3D conntrack_mt_help,
-		.parse         =3D conntrack1_mt4_parse,
-		.final_check   =3D conntrack_mt_check,
+		.x6_parse      =3D conntrack1_mt_parse,
+		.x6_fcheck     =3D conntrack_mt_check,
 		.print         =3D conntrack1_mt4_print,
 		.save          =3D conntrack1_mt4_save,
-		.extra_opts    =3D conntrack_mt_opts,
+		.x6_options    =3D conntrack_mt_opts,
 	},
 	{
 		.version       =3D XTABLES_VERSION,
@@ -1287,11 +1055,11 @@ static struct xtables_match conntrack_mt_reg[] =
=3D {
 		.size          =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 		.help          =3D conntrack_mt_help,
-		.parse         =3D conntrack1_mt6_parse,
-		.final_check   =3D conntrack_mt_check,
+		.x6_parse      =3D conntrack1_mt_parse,
+		.x6_fcheck     =3D conntrack_mt_check,
 		.print         =3D conntrack1_mt6_print,
 		.save          =3D conntrack1_mt6_save,
-		.extra_opts    =3D conntrack_mt_opts,
+		.x6_options    =3D conntrack_mt_opts,
 	},
 	{
 		.version       =3D XTABLES_VERSION,
@@ -1301,11 +1069,11 @@ static struct xtables_match conntrack_mt_reg[] =
=3D {
 		.size          =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
 		.help          =3D conntrack_mt_help,
-		.parse         =3D conntrack2_mt4_parse,
-		.final_check   =3D conntrack_mt_check,
+		.x6_parse      =3D conntrack2_mt_parse,
+		.x6_fcheck     =3D conntrack_mt_check,
 		.print         =3D conntrack2_mt_print,
 		.save          =3D conntrack2_mt_save,
-		.extra_opts    =3D conntrack_mt_opts,
+		.x6_options    =3D conntrack_mt_opts,
 	},
 	{
 		.version       =3D XTABLES_VERSION,
@@ -1315,11 +1083,11 @@ static struct xtables_match conntrack_mt_reg[] =
=3D {
 		.size          =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
 		.help          =3D conntrack_mt_help,
-		.parse         =3D conntrack2_mt6_parse,
-		.final_check   =3D conntrack_mt_check,
+		.x6_parse      =3D conntrack2_mt_parse,
+		.x6_fcheck     =3D conntrack_mt_check,
 		.print         =3D conntrack2_mt6_print,
 		.save          =3D conntrack2_mt6_save,
-		.extra_opts    =3D conntrack_mt_opts,
+		.x6_options    =3D conntrack_mt_opts,
 	},
 	{
 		.version       =3D XTABLES_VERSION,
@@ -1329,11 +1097,11 @@ static struct xtables_match conntrack_mt_reg[] =
=3D {
 		.size          =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
 		.help          =3D conntrack_mt_help,
-		.parse         =3D conntrack3_mt4_parse,
-		.final_check   =3D conntrack_mt_check,
+		.x6_parse      =3D conntrack3_mt_parse,
+		.x6_fcheck     =3D conntrack_mt_check,
 		.print         =3D conntrack3_mt_print,
 		.save          =3D conntrack3_mt_save,
-		.extra_opts    =3D conntrack_mt_opts,
+		.x6_options    =3D conntrack_mt_opts,
 	},
 	{
 		.version       =3D XTABLES_VERSION,
@@ -1343,11 +1111,11 @@ static struct xtables_match conntrack_mt_reg[] =
=3D {
 		.size          =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
 		.help          =3D conntrack_mt_help,
-		.parse         =3D conntrack3_mt6_parse,
-		.final_check   =3D conntrack_mt_check,
+		.x6_parse      =3D conntrack3_mt_parse,
+		.x6_fcheck     =3D conntrack_mt_check,
 		.print         =3D conntrack3_mt6_print,
 		.save          =3D conntrack3_mt6_save,
-		.extra_opts    =3D conntrack_mt_opts,
+		.x6_options    =3D conntrack_mt_opts,
 	},
 };
=20
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
