From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [IPTABLES]: libxt_conntrack revision 1
Date: Thu, 24 Jan 2008 23:38:53 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801242338190.12676@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801242337480.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38107 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbYAXWiz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:38:55 -0500
In-Reply-To: <Pine.LNX.4.64.0801242337480.12676@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for xt_conntrack match revision 1.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libxt_conntrack.c   |  575 ++++++++++++++++++++++++++++++++=
++++++++-
 extensions/libxt_conntrack.man |   18 -
 2 files changed, 576 insertions(+), 17 deletions(-)

Index: iptables/extensions/libxt_conntrack.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/libxt_conntrack.c
+++ iptables/extensions/libxt_conntrack.c
@@ -1,10 +1,17 @@
-/* Shared library add-on to iptables for conntrack matching support.
- * GPL (C) 2001  Marc Boucher (marc@mbsi.ca).
+/*
+ *	libxt_conntrack
+ *	Shared library add-on to iptables for conntrack matching support.
+ *
+ *	GPL (C) 2001  Marc Boucher (marc@mbsi.ca).
+ *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
+ *	Jan Engelhardt <jengelh@computergmbh.de>
  */
-
+#include <sys/socket.h>
+#include <sys/types.h>
 #include <ctype.h>
 #include <getopt.h>
 #include <netdb.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -13,6 +20,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/xt_conntrack.h>
 #include <linux/netfilter/nf_conntrack_common.h>
+#include <arpa/inet.h>
=20
 /* Function which prints out usage message. */
 static void conntrack_mt_help(void)
@@ -27,14 +35,20 @@ static void conntrack_mt_help(void)
 "[!] --ctreplsrc address[/mask]\n"
 "[!] --ctrepldst address[/mask]\n"
 "                               Original/Reply source/destination addr=
ess\n"
+"[!] --ctorigsrcport port\n"
+"[!] --ctorigdstport port\n"
+"[!] --ctreplsrcport port\n"
+"[!] --ctrepldstport port\n"
+"                               TCP/UDP/SCTP orig./reply source/destin=
ation port\n"
 "[!] --ctstatus {NONE|EXPECTED|SEEN_REPLY|ASSURED|CONFIRMED}[,...]\n"
 "                               Status(es) to match\n"
 "[!] --ctexpire time[:time]     Match remaining lifetime in seconds ag=
ainst\n"
 "                               value or range of values (inclusive)\n=
"
+"    --ctdir {ORIGINAL|REPLY}   Flow direction of packet\n"
 "\n");
 }
=20
-static const struct option conntrack_mt_opts[] =3D {
+static const struct option conntrack_mt_opts_v0[] =3D {
 	{.name =3D "ctstate",   .has_arg =3D true, .val =3D '1'},
 	{.name =3D "ctproto",   .has_arg =3D true, .val =3D '2'},
 	{.name =3D "ctorigsrc", .has_arg =3D true, .val =3D '3'},
@@ -46,6 +60,23 @@ static const struct option conntrack_mt_
 	{},
 };
=20
+static const struct option conntrack_mt_opts[] =3D {
+	{.name =3D "ctstate",       .has_arg =3D true, .val =3D '1'},
+	{.name =3D "ctproto",       .has_arg =3D true, .val =3D '2'},
+	{.name =3D "ctorigsrc",     .has_arg =3D true, .val =3D '3'},
+	{.name =3D "ctorigdst",     .has_arg =3D true, .val =3D '4'},
+	{.name =3D "ctreplsrc",     .has_arg =3D true, .val =3D '5'},
+	{.name =3D "ctrepldst",     .has_arg =3D true, .val =3D '6'},
+	{.name =3D "ctstatus",      .has_arg =3D true, .val =3D '7'},
+	{.name =3D "ctexpire",      .has_arg =3D true, .val =3D '8'},
+	{.name =3D "ctorigsrcport", .has_arg =3D true, .val =3D 'a'},
+	{.name =3D "ctorigdstport", .has_arg =3D true, .val =3D 'b'},
+	{.name =3D "ctreplsrcport", .has_arg =3D true, .val =3D 'c'},
+	{.name =3D "ctrepldstport", .has_arg =3D true, .val =3D 'd'},
+	{.name =3D "ctdir",         .has_arg =3D true, .val =3D 'e'},
+	{},
+};
+
 static int
 parse_state(const char *state, size_t strlen, struct xt_conntrack_info=
 *sinfo)
 {
@@ -83,6 +114,45 @@ parse_states(const char *arg, struct xt_
 		exit_error(PARAMETER_PROBLEM, "Bad ctstate `%s'", arg);
 }
=20
+static bool
+conntrack_ps_state(struct xt_conntrack_mtinfo1 *info, const char *stat=
e,
+                   size_t z)
+{
+	if (strncasecmp(state, "INVALID", z) =3D=3D 0)
+		info->state_mask |=3D XT_CONNTRACK_STATE_INVALID;
+	else if (strncasecmp(state, "NEW", z) =3D=3D 0)
+		info->state_mask |=3D XT_CONNTRACK_STATE_BIT(IP_CT_NEW);
+	else if (strncasecmp(state, "ESTABLISHED", z) =3D=3D 0)
+		info->state_mask |=3D XT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED);
+	else if (strncasecmp(state, "RELATED", z) =3D=3D 0)
+		info->state_mask |=3D XT_CONNTRACK_STATE_BIT(IP_CT_RELATED);
+	else if (strncasecmp(state, "UNTRACKED", z) =3D=3D 0)
+		info->state_mask |=3D XT_CONNTRACK_STATE_UNTRACKED;
+	else if (strncasecmp(state, "SNAT", z) =3D=3D 0)
+		info->state_mask |=3D XT_CONNTRACK_STATE_SNAT;
+	else if (strncasecmp(state, "DNAT", z) =3D=3D 0)
+		info->state_mask |=3D XT_CONNTRACK_STATE_DNAT;
+	else
+		return false;
+	return true;
+}
+
+static void
+conntrack_ps_states(struct xt_conntrack_mtinfo1 *info, const char *arg=
)
+{
+	const char *comma;
+
+	while ((comma =3D strchr(arg, ',')) !=3D NULL) {
+		if (comma =3D=3D arg || !conntrack_ps_state(info, arg, comma - arg))
+			exit_error(PARAMETER_PROBLEM,
+			           "Bad ctstate \"%s\"", arg);
+		arg =3D comma + 1;
+	}
+
+	if (strlen(arg) =3D=3D 0 || !conntrack_ps_state(info, arg, strlen(arg=
)))
+		exit_error(PARAMETER_PROBLEM, "Bad ctstate \"%s\"", arg);
+}
+
 static int
 parse_status(const char *status, size_t strlen, struct xt_conntrack_in=
fo *sinfo)
 {
@@ -96,7 +166,7 @@ parse_status(const char *status, size_t=20
 		sinfo->statusmask |=3D IPS_ASSURED;
 #ifdef IPS_CONFIRMED
 	else if (strncasecmp(status, "CONFIRMED", strlen) =3D=3D 0)
-		sinfo->stausmask |=3D IPS_CONFIRMED;
+		sinfo->statusmask |=3D IPS_CONFIRMED;
 #endif
 	else
 		return 0;
@@ -118,6 +188,41 @@ parse_statuses(const char *arg, struct x
 		exit_error(PARAMETER_PROBLEM, "Bad ctstatus `%s'", arg);
 }
=20
+static bool
+conntrack_ps_status(struct xt_conntrack_mtinfo1 *info, const char *sta=
tus,
+                    size_t z)
+{
+	if (strncasecmp(status, "NONE", z) =3D=3D 0)
+		info->status_mask |=3D 0;
+	else if (strncasecmp(status, "EXPECTED", z) =3D=3D 0)
+		info->status_mask |=3D IPS_EXPECTED;
+	else if (strncasecmp(status, "SEEN_REPLY", z) =3D=3D 0)
+		info->status_mask |=3D IPS_SEEN_REPLY;
+	else if (strncasecmp(status, "ASSURED", z) =3D=3D 0)
+		info->status_mask |=3D IPS_ASSURED;
+	else if (strncasecmp(status, "CONFIRMED", z) =3D=3D 0)
+		info->status_mask |=3D IPS_CONFIRMED;
+	else
+		return false;
+	return true;
+}
+
+static void
+conntrack_ps_statuses(struct xt_conntrack_mtinfo1 *info, const char *a=
rg)
+{
+	const char *comma;
+
+	while ((comma =3D strchr(arg, ',')) !=3D NULL) {
+		if (comma =3D=3D arg || !conntrack_ps_status(info, arg, comma - arg)=
)
+			exit_error(PARAMETER_PROBLEM,
+			           "Bad ctstatus \"%s\"", arg);
+		arg =3D comma + 1;
+	}
+
+	if (strlen(arg) =3D=3D 0 || !conntrack_ps_status(info, arg, strlen(ar=
g)))
+		exit_error(PARAMETER_PROBLEM, "Bad ctstatus \"%s\"", arg);
+}
+
 static unsigned long
 parse_expire(const char *s)
 {
@@ -138,7 +243,8 @@ parse_expires(const char *s, struct xt_c
=20
 	buffer =3D strdup(s);
 	if ((cp =3D strchr(buffer, ':')) =3D=3D NULL)
-		sinfo->expires_min =3D sinfo->expires_max =3D parse_expire(buffer);
+		sinfo->expires_min =3D sinfo->expires_max =3D
+			parse_expire(buffer);
 	else {
 		*cp =3D '\0';
 		cp++;
@@ -154,6 +260,30 @@ parse_expires(const char *s, struct xt_c
 		           "range value `%lu'", sinfo->expires_min, sinfo->expires_m=
ax);
 }
=20
+static void
+conntrack_ps_expires(struct xt_conntrack_mtinfo1 *info, const char *s)
+{
+	unsigned int min, max;
+	char *end;
+
+	if (!strtonum(s, &end, &min, 0, ~0))
+		param_act(P_BAD_VALUE, "conntrack", "--expires", s);
+	max =3D min;
+	if (*end =3D=3D ':')
+		if (!strtonum(s, &end, &max, 0, ~0U))
+			param_act(P_BAD_VALUE, "conntrack", "--expires", s);
+	if (*end !=3D '\0')
+		param_act(P_BAD_VALUE, "conntrack", "--expires", s);
+
+	if (min > max)
+		exit_error(PARAMETER_PROBLEM,
+		           "expire min. range value \"%u\" greater than max. "
+		           "range value \"%u\"", min, max);
+
+	info->expires_min =3D min;
+	info->expires_max =3D max;
+}
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int conntrack_parse(int c, char **argv, int invert, unsigned in=
t *flags,
@@ -305,10 +435,257 @@ static int conntrack_parse(int c, char *
 	return 1;
 }
=20
+static int
+conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags=
,
+                   struct xt_entry_match **match)
+{
+	struct xt_conntrack_mtinfo1 *info =3D (void *)(*match)->data;
+	unsigned int port;
+	char *p;
+
+	switch (c) {
+	case '1': /* --ctstate */
+		conntrack_ps_states(info, optarg);
+		info->match_flags |=3D XT_CONNTRACK_STATE;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_STATE;
+		break;
+
+	case '2': /* --ctproto */
+		/* Canonicalize into lower case */
+		for (p =3D optarg; *p !=3D '\0'; ++p)
+			*p =3D tolower(*p);
+		info->l4proto =3D parse_protocol(optarg);
+
+		if (info->l4proto =3D=3D 0 && (info->invert_flags & XT_INV_PROTO))
+			exit_error(PARAMETER_PROBLEM, "conntrack: rule would "
+			           "never match protocol");
+
+		info->match_flags |=3D XT_CONNTRACK_PROTO;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_PROTO;
+		break;
+
+	case '7': /* --ctstatus */
+		conntrack_ps_statuses(info, optarg);
+		info->match_flags |=3D XT_CONNTRACK_STATUS;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_STATUS;
+		break;
+
+	case '8': /* --ctexpire */
+		conntrack_ps_expires(info, optarg);
+		info->match_flags |=3D XT_CONNTRACK_EXPIRES;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_EXPIRES;
+		break;
+
+	case 'a': /* --ctorigsrcport */
+		if (!strtonum(optarg, NULL, &port, 0, ~(u_int16_t)0))
+			param_act(P_BAD_VALUE, "conntrack",
+			          "--ctorigsrcport", optarg);
+		info->match_flags |=3D XT_CONNTRACK_ORIGSRC_PORT;
+		info->origsrc_port =3D htons(port);
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_ORIGSRC_PORT;
+		break;
+
+	case 'b': /* --ctorigdstport */
+		if (!strtonum(optarg, NULL, &port, 0, ~(u_int16_t)0))
+			param_act(P_BAD_VALUE, "conntrack",
+			          "--ctorigdstport", optarg);
+		info->match_flags |=3D XT_CONNTRACK_ORIGDST_PORT;
+		info->origdst_port =3D htons(port);
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_ORIGDST_PORT;
+		break;
+
+	case 'c': /* --ctreplsrcport */
+		if (!strtonum(optarg, NULL, &port, 0, ~(u_int16_t)0))
+			param_act(P_BAD_VALUE, "conntrack",
+			          "--ctreplsrcport", optarg);
+		info->match_flags |=3D XT_CONNTRACK_REPLSRC_PORT;
+		info->replsrc_port =3D htons(port);
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_REPLSRC_PORT;
+		break;
+
+	case 'd': /* --ctrepldstport */
+		if (!strtonum(optarg, NULL, &port, 0, ~(u_int16_t)0))
+			param_act(P_BAD_VALUE, "conntrack",
+			          "--ctrepldstport", optarg);
+		info->match_flags |=3D XT_CONNTRACK_REPLDST_PORT;
+		info->repldst_port =3D htons(port);
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_REPLDST_PORT;
+		break;
+
+	case 'e': /* --ctdir */
+		param_act(P_NO_INVERT, "conntrack", "--ctdir", invert);
+		if (strcasecmp(optarg, "ORIGINAL") =3D=3D 0) {
+			info->match_flags  |=3D XT_CONNTRACK_DIRECTION;
+			info->invert_flags &=3D ~XT_CONNTRACK_DIRECTION;
+		} else if (strcasecmp(optarg, "REPLY") =3D=3D 0) {
+			info->match_flags  |=3D XT_CONNTRACK_DIRECTION;
+			info->invert_flags |=3D XT_CONNTRACK_DIRECTION;
+		} else {
+			param_act(P_BAD_VALUE, "conntrack", "--ctdir", optarg);
+		}
+		break;
+
+	default:
+		return false;
+	}
+
+	*flags =3D info->match_flags;
+	return true;
+}
+
+static int
+conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flag=
s,
+                    const void *entry, struct xt_entry_match **match)
+{
+	struct xt_conntrack_mtinfo1 *info =3D (void *)(*match)->data;
+	struct in_addr *addr =3D NULL;
+	unsigned int naddrs =3D 0;
+
+	switch (c) {
+	case '3': /* --ctorigsrc */
+		ipparse_hostnetworkmask(optarg, &addr, &info->origsrc_mask.in,
+		                        &naddrs);
+		if (naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "multiple IP addresses not allowed");
+		if (naddrs =3D=3D 1)
+			memcpy(&info->origsrc_addr.in, addr, sizeof(*addr));
+		info->match_flags |=3D XT_CONNTRACK_ORIGSRC;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_ORIGSRC;
+		break;
+
+	case '4': /* --ctorigdst */
+		ipparse_hostnetworkmask(optarg, &addr, &info->origdst_mask.in,
+		                        &naddrs);
+		if (naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "multiple IP addresses not allowed");
+		if (naddrs =3D=3D 1)
+			memcpy(&info->origdst_addr.in, addr, sizeof(*addr));
+		info->match_flags |=3D XT_CONNTRACK_ORIGDST;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_ORIGDST;
+		break;
+
+	case '5': /* --ctreplsrc */
+		ipparse_hostnetworkmask(optarg, &addr, &info->replsrc_mask.in,
+		                        &naddrs);
+		if (naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "multiple IP addresses not allowed");
+		if (naddrs =3D=3D 1)
+			memcpy(&info->replsrc_addr.in, addr, sizeof(*addr));
+		info->match_flags |=3D XT_CONNTRACK_REPLSRC;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_REPLSRC;
+		break;
+
+	case '6': /* --ctrepldst */
+		ipparse_hostnetworkmask(optarg, &addr, &info->repldst_mask.in,
+		                        &naddrs);
+		if (naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "multiple IP addresses not allowed");
+		if (naddrs =3D=3D 1)
+			memcpy(&info->repldst_addr.in, addr, sizeof(*addr));
+		info->match_flags |=3D XT_CONNTRACK_REPLDST;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_REPLDST;
+		break;
+
+
+	default:
+		return conntrack_mt_parse(c, argv, invert, flags, match);
+	}
+
+	*flags =3D info->match_flags;
+	return true;
+}
+
+static int
+conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flag=
s,
+                    const void *entry, struct xt_entry_match **match)
+{
+	struct xt_conntrack_mtinfo1 *info =3D (void *)(*match)->data;
+	struct in6_addr *addr =3D NULL;
+	unsigned int naddrs =3D 0;
+
+	switch (c) {
+	case '3': /* --ctorigsrc */
+		ip6parse_hostnetworkmask(optarg, &addr,
+		                         &info->origsrc_mask.in6, &naddrs);
+		if (naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "multiple IP addresses not allowed");
+		if (naddrs =3D=3D 1)
+			memcpy(&info->origsrc_addr.in6, addr, sizeof(*addr));
+		info->match_flags |=3D XT_CONNTRACK_ORIGSRC;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_ORIGSRC;
+		break;
+
+	case '4': /* --ctorigdst */
+		ip6parse_hostnetworkmask(optarg, &addr,
+		                         &info->origdst_mask.in6, &naddrs);
+		if (naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "multiple IP addresses not allowed");
+		if (naddrs =3D=3D 1)
+			memcpy(&info->origdst_addr.in, addr, sizeof(*addr));
+		info->match_flags |=3D XT_CONNTRACK_ORIGDST;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_ORIGDST;
+		break;
+
+	case '5': /* --ctreplsrc */
+		ip6parse_hostnetworkmask(optarg, &addr,
+		                         &info->replsrc_mask.in6, &naddrs);
+		if (naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "multiple IP addresses not allowed");
+		if (naddrs =3D=3D 1)
+			memcpy(&info->replsrc_addr.in, addr, sizeof(*addr));
+		info->match_flags |=3D XT_CONNTRACK_REPLSRC;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_REPLSRC;
+		break;
+
+	case '6': /* --ctrepldst */
+		ip6parse_hostnetworkmask(optarg, &addr,
+		                         &info->repldst_mask.in6, &naddrs);
+		if (naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "multiple IP addresses not allowed");
+		if (naddrs =3D=3D 1)
+			memcpy(&info->repldst_addr.in, addr, sizeof(*addr));
+		info->match_flags |=3D XT_CONNTRACK_REPLDST;
+		if (invert)
+			info->invert_flags |=3D XT_CONNTRACK_REPLDST;
+		break;
+
+
+	default:
+		return conntrack_mt_parse(c, argv, invert, flags, match);
+	}
+
+	*flags =3D info->match_flags;
+	return true;
+}
+
 static void conntrack_mt_check(unsigned int flags)
 {
 	if (flags =3D=3D 0)
-		exit_error(PARAMETER_PROBLEM, "You must specify one or more options"=
);
+		exit_error(PARAMETER_PROBLEM, "conntrack: At least one option "
+		           "is required");
 }
=20
 static void
@@ -364,20 +741,37 @@ print_status(unsigned int statusmask)
 		printf("%sASSURED", sep);
 		sep =3D ",";
 	}
-#ifdef IPS_CONFIRMED
 	if (statusmask & IPS_CONFIRMED) {
 		printf("%sCONFIRMED", sep);
-		sep =3D",";
-	}
-#endif
-	if (statusmask =3D=3D 0) {
-		printf("%sNONE", sep);
 		sep =3D ",";
 	}
+	if (statusmask =3D=3D 0)
+		printf("%sNONE", sep);
 	printf(" ");
 }
=20
 static void
+conntrack_dump_addr(const union nf_inet_addr *addr,
+                    const union nf_inet_addr *mask,
+                    unsigned int family, bool numeric)
+{
+	if (family =3D=3D AF_INET) {
+		if (!numeric && addr->ip =3D=3D 0) {
+			printf("anywhere ");
+			return;
+		}
+		printf("%s ", ipaddr_to_anyname(&addr->in));
+	} else if (family =3D=3D AF_INET6) {
+		if (!numeric && addr->ip6[0] =3D=3D 0 && addr->ip6[1] =3D=3D 0 &&
+		    addr->ip6[2] =3D=3D 0 && addr->ip6[3] =3D=3D 0) {
+			printf("anywhere ");
+			return;
+		}
+		printf("%s ", ip6addr_to_anyname(&addr->in6));
+	}
+}
+
+static void
 print_addr(struct in_addr *addr, struct in_addr *mask, int inv, int nu=
meric)
 {
 	char buf[BUFSIZ];
@@ -484,6 +878,103 @@ matchinfo_print(const void *ip, const st
 	}
 }
=20
+static void
+conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *pr=
efix,
+               unsigned int family, bool numeric)
+{
+	if (info->match_flags & XT_CONNTRACK_STATE) {
+		if (info->invert_flags & XT_CONNTRACK_STATE)
+			printf("! ");
+		printf("%sctstate ", prefix);
+		print_state(info->state_mask);
+	}
+
+	if (info->match_flags & XT_CONNTRACK_PROTO) {
+		if (info->invert_flags & XT_CONNTRACK_PROTO)
+			printf("! ");
+		printf("%sctproto %u ", prefix, info->l4proto);
+	}
+
+	if (info->match_flags & XT_CONNTRACK_ORIGSRC) {
+		if (info->invert_flags & XT_CONNTRACK_PROTO)
+			printf("! ");
+		printf("%sctorigsrc ", prefix);
+		conntrack_dump_addr(&info->origsrc_addr, &info->origsrc_mask,
+		                    family, numeric);
+	}
+
+	if (info->match_flags & XT_CONNTRACK_ORIGDST) {
+		if (info->invert_flags & XT_CONNTRACK_PROTO)
+			printf("! ");
+		printf("%sctorigdst ", prefix);
+		conntrack_dump_addr(&info->origdst_addr, &info->origdst_mask,
+		                    family, numeric);
+	}
+
+	if (info->match_flags & XT_CONNTRACK_REPLSRC) {
+		if (info->invert_flags & XT_CONNTRACK_PROTO)
+			printf("! ");
+		printf("%sctreplsrc ", prefix);
+		conntrack_dump_addr(&info->replsrc_addr, &info->replsrc_mask,
+		                    family, numeric);
+	}
+
+	if (info->match_flags & XT_CONNTRACK_REPLDST) {
+		if (info->invert_flags & XT_CONNTRACK_PROTO)
+			printf("! ");
+		printf("%sctrepldst ", prefix);
+		conntrack_dump_addr(&info->repldst_addr, &info->repldst_mask,
+		                    family, numeric);
+	}
+
+	if (info->match_flags & XT_CONNTRACK_ORIGSRC_PORT) {
+		if (info->invert_flags & XT_CONNTRACK_ORIGSRC_PORT)
+			printf("! ");
+		printf("%sctorigsrcport %u ", prefix,
+		       ntohs(info->origsrc_port));
+	}
+
+	if (info->match_flags & XT_CONNTRACK_ORIGDST_PORT) {
+		if (info->invert_flags & XT_CONNTRACK_ORIGDST_PORT)
+			printf("! ");
+		printf("%sctorigdstport %u ", prefix,
+		       ntohs(info->origdst_port));
+	}
+
+	if (info->match_flags & XT_CONNTRACK_REPLSRC_PORT) {
+		if (info->invert_flags & XT_CONNTRACK_REPLSRC_PORT)
+			printf("! ");
+		printf("%sctreplsrcport %u ", prefix,
+		       ntohs(info->replsrc_port));
+	}
+
+	if (info->match_flags & XT_CONNTRACK_REPLDST_PORT) {
+		if (info->invert_flags & XT_CONNTRACK_REPLDST_PORT)
+			printf("! ");
+		printf("%sctrepldstport %u ", prefix,
+		       ntohs(info->repldst_port));
+	}
+
+	if (info->match_flags & XT_CONNTRACK_STATUS) {
+		if (info->invert_flags & XT_CONNTRACK_STATUS)
+			printf("! ");
+		printf("%sctstatus ", prefix);
+		print_status(info->status_mask);
+	}
+
+	if (info->match_flags & XT_CONNTRACK_EXPIRES) {
+		if (info->invert_flags & XT_CONNTRACK_EXPIRES)
+			printf("! ");
+		printf("%sctexpire ", prefix);
+
+		if (info->expires_max =3D=3D info->expires_min)
+			printf("%u ", (unsigned int)info->expires_min);
+		else
+			printf("%u:%u ", (unsigned int)info->expires_min,
+			       (unsigned int)info->expires_max);
+	}
+}
+
 /* Prints out the matchinfo. */
 static void conntrack_print(const void *ip, const struct xt_entry_matc=
h *match,
                             int numeric)
@@ -491,12 +982,38 @@ static void conntrack_print(const void *
 	matchinfo_print(ip, match, numeric, "");
 }
=20
+static void
+conntrack_mt_print(const void *ip, const struct xt_entry_match *match,
+                   int numeric)
+{
+	conntrack_dump((const void *)match->data, "", AF_INET, numeric);
+}
+
+static void
+conntrack_mt6_print(const void *ip, const struct xt_entry_match *match=
,
+                    int numeric)
+{
+	conntrack_dump((const void *)match->data, "", AF_INET6, numeric);
+}
+
 /* Saves the matchinfo in parsable form to stdout. */
 static void conntrack_save(const void *ip, const struct xt_entry_match=
 *match)
 {
 	matchinfo_print(ip, match, 1, "--");
 }
=20
+static void conntrack_mt_save(const void *ip,
+                              const struct xt_entry_match *match)
+{
+	conntrack_dump((const void *)match->data, "--", AF_INET, true);
+}
+
+static void conntrack_mt6_save(const void *ip,
+                               const struct xt_entry_match *match)
+{
+	conntrack_dump((const void *)match->data, "--", AF_INET6, true);
+}
+
 static struct xtables_match conntrack_match =3D {
 	.version       =3D IPTABLES_VERSION,
 	.name          =3D "conntrack",
@@ -509,10 +1026,42 @@ static struct xtables_match conntrack_ma
 	.final_check   =3D conntrack_mt_check,
 	.print         =3D conntrack_print,
 	.save          =3D conntrack_save,
+	.extra_opts    =3D conntrack_mt_opts_v0,
+};
+
+static struct xtables_match conntrack_mt_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "conntrack",
+	.revision      =3D 1,
+	.family        =3D AF_INET,
+	.size          =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
+	.help          =3D conntrack_mt_help,
+	.parse         =3D conntrack_mt4_parse,
+	.final_check   =3D conntrack_mt_check,
+	.print         =3D conntrack_mt_print,
+	.save          =3D conntrack_mt_save,
+	.extra_opts    =3D conntrack_mt_opts,
+};
+
+static struct xtables_match conntrack_mt6_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "conntrack",
+	.revision      =3D 1,
+	.family        =3D AF_INET6,
+	.size          =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
+	.help          =3D conntrack_mt_help,
+	.parse         =3D conntrack_mt6_parse,
+	.final_check   =3D conntrack_mt_check,
+	.print         =3D conntrack_mt6_print,
+	.save          =3D conntrack_mt6_save,
 	.extra_opts    =3D conntrack_mt_opts,
 };
=20
 void _init(void)
 {
 	xtables_register_match(&conntrack_match);
+	xtables_register_match(&conntrack_mt_reg);
+	xtables_register_match(&conntrack_mt6_reg);
 }
Index: iptables/extensions/libxt_conntrack.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/libxt_conntrack.man
+++ iptables/extensions/libxt_conntrack.man
@@ -9,16 +9,22 @@ Possible states are listed below.
 Layer-4 protocol to match (by number or name)
 .TP
 [\fB!\fR] \fB--ctorigsrc\fR \fIaddress\fR[\fB/\fR\fImask\fR]
-Match against original source address
 .TP
 [\fB!\fR] \fB--ctorigdst\fR \fIaddress\fR[\fB/\fR\fImask\fR]
-Match against original destination address
 .TP
 [\fB!\fR] \fB--ctreplsrc\fR \fIaddress\fR[\fB/\fR\fImask\fR]
-Match against reply source address
 .TP
 [\fB!\fR] \fB--ctrepldst\fR \fIaddress\fR[\fB/\fR\fImask\fR]
-Match against reply destination address
+Match against original/reply source/destination address
+.TP
+[\fB!\fR] \fB--ctorigsrcport\fR \fIport\fR
+.TP
+[\fB!\fR] \fB--ctorigdstport\fR \fIport\fR
+.TP
+[\fB!\fR] \fB--ctreplsrcport\fR \fIport\fR
+.TP
+[\fB!\fR] \fB--ctrepldstport\fR \fIport\fR
+Match against original/reply source/destination port (TCP/UDP/etc.) or=
 GRE key.
 .TP
 [\fB!\fR] \fB--ctstatus\fR \fIstatelist\fR
 \fIstatuslist\fR is a comma separated list of the connection statuses =
to match.
@@ -27,6 +33,10 @@ Possible statuses are listed below.
 [\fB!\fR] \fB--ctexpire\fR \fItime\fR[\fB:\fR\fItime\fR]
 Match remaining lifetime in seconds against given value or range of va=
lues
 (inclusive)
+.TP
+\fB--ctdir\fR {\fBORIGINAL\fR|\fBREPLY\fR}
+Match packets that are flowing in the specified direction. If this fla=
g is not
+specified at all, matches packets in both directions.
 .PP
 States for \fB--ctstate\fR:
 .TP
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
