From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 4/11] libxt_owner match
Date: Sat, 22 Dec 2007 03:45:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220344460.8607@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712220342260.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56607 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXLVCpG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:45:06 -0500
In-Reply-To: <Pine.LNX.4.64.0712220342260.8607@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Import libxt_owner into iptables


libxt_owner merges libipt_owner and libip6t_owner, and adds support
for the new xt_owner match v1.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 Delete libipt_owner.c
 Delete libip6t_owner.c

 extensions/Makefile                |    3=20
 extensions/libxt_owner.c           |  582 ++++++++++++++++++++++++++++=
+++++++++
 extensions/libxt_owner.man         |   16 +
 include/linux/netfilter/xt_owner.h |   16 +
 4 files changed, 615 insertions(+), 2 deletions(-)

Index: iptables-modules/extensions/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/extensions/Makefile
+++ iptables-modules/extensions/Makefile
@@ -26,7 +26,6 @@ a +=3D conntrack
 a +=3D ecn
 a +=3D icmp
 a +=3D iprange
-a +=3D owner
 a +=3D policy
 a +=3D realm
 a +=3D recent
@@ -47,7 +46,6 @@ a +=3D hl
 a +=3D icmp6
 a +=3D ipv6header
 a +=3D mh
-a +=3D owner
 a +=3D policy
 a +=3D rt
 PF6_EXT_SLIB :=3D ${a}
@@ -75,6 +73,7 @@ a +=3D limit
 a +=3D mac
 a +=3D mark
 a +=3D multiport
+a +=3D owner
 a +=3D physdev
 a +=3D pkttype
 a +=3D quota
Index: iptables-modules/extensions/libxt_owner.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_owner.c
@@ -0,0 +1,582 @@
+/*
+ * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
+ * Contact: Jan Engelhardt <jengelh@computergmbh.de>
+ */
+#include <getopt.h>
+#include <grp.h>
+#include <netdb.h>
+#include <pwd.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_owner.h>
+#include <linux/netfilter_ipv4/ipt_owner.h>
+#include <linux/netfilter_ipv6/ip6t_owner.h>
+
+enum {
+	FLAG_UID_OWNER     =3D 1 << 0,
+	FLAG_GID_OWNER     =3D 1 << 1,
+	FLAG_SOCKET_EXISTS =3D 1 << 2,
+	FLAG_PID_OWNER     =3D 1 << 3,
+	FLAG_SID_OWNER     =3D 1 << 4,
+	FLAG_COMM          =3D 1 << 5,
+};
+
+static void owner_mt_help_v0(void)
+{
+#ifdef IPT_OWNER_COMM
+	printf(
+"owner match options:\n"
+"[!] --uid-owner userid       Match local UID\n"
+"[!] --gid-owner groupid      Match local GID\n"
+"[!] --pid-owner processid    Match local PID\n"
+"[!] --sid-owner sessionid    Match local SID\n"
+"[!] --cmd-owner name         Match local command name\n"
+"NOTE: PID, SID and command matching are broken on SMP\n"
+"\n");
+#else
+	printf(
+"owner match options:\n"
+"[!] --uid-owner userid       Match local UID\n"
+"[!] --gid-owner groupid      Match local GID\n"
+"[!] --pid-owner processid    Match local PID\n"
+"[!] --sid-owner sessionid    Match local SID\n"
+"NOTE: PID and SID matching are broken on SMP\n"
+"\n");
+#endif /* IPT_OWNER_COMM */
+}
+
+static void owner_mt6_help_v0(void)
+{
+	printf(
+"owner match options:\n"
+"[!] --uid-owner userid       Match local UID\n"
+"[!] --gid-owner groupid      Match local GID\n"
+"[!] --pid-owner processid    Match local PID\n"
+"[!] --sid-owner sessionid    Match local SID\n"
+"NOTE: PID and SID matching are broken on SMP\n"
+"\n");
+}
+
+static void owner_mt_help(void)
+{
+	printf(
+"owner match options:\n"
+"[!] --uid-owner userid     Match local UID\n"
+"[!] --gid-owner groupid    Match local GID\n"
+"[!] --socket-exists        Match if socket exists\n"
+"\n");
+}
+
+static const struct option owner_mt_opts_v0[] =3D {
+	{.name =3D "uid-owner", .has_arg =3D true, .val =3D 'u'},
+	{.name =3D "gid-owner", .has_arg =3D true, .val =3D 'g'},
+	{.name =3D "pid-owner", .has_arg =3D true, .val =3D 'p'},
+	{.name =3D "sid-owner", .has_arg =3D true, .val =3D 's'},
+#ifdef IPT_OWNER_COMM
+	{.name =3D "cmd-owner", .has_arg =3D true, .val =3D 'c'},
+#endif
+	{},
+};
+
+static const struct option owner_mt6_opts_v0[] =3D {
+	{.name =3D "uid-owner", .has_arg =3D true, .val =3D 'u'},
+	{.name =3D "gid-owner", .has_arg =3D true, .val =3D 'g'},
+	{.name =3D "pid-owner", .has_arg =3D true, .val =3D 'p'},
+	{.name =3D "sid-owner", .has_arg =3D true, .val =3D 's'},
+	{},
+};
+
+static const struct option owner_mt_opts[] =3D {
+	{.name =3D "uid-owner",     .has_arg =3D true,  .val =3D 'u'},
+	{.name =3D "gid-owner",     .has_arg =3D true,  .val =3D 'g'},
+	{.name =3D "socket-exists", .has_arg =3D false, .val =3D 'k'},
+	{},
+};
+
+static int
+owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_match **match)
+{
+	struct ipt_owner_info *info =3D (void *)(*match)->data;
+	struct passwd *pwd;
+	struct group *grp;
+	unsigned int id;
+
+	switch (c) {
+	case 'u':
+		param_act(P_ONLY_ONCE, "owner", "--uid-owner", *flags & FLAG_UID_OWN=
ER);
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((pwd =3D getpwnam(optarg)) !=3D NULL)
+			id =3D pwd->pw_uid;
+		else if (!strtonum(optarg, NULL, &id, 0, ~(uid_t)0))
+			param_act(P_BAD_VALUE, "owner", "--uid-owner", optarg);
+		if (invert)
+			info->invert |=3D IPT_OWNER_UID;
+		info->match |=3D IPT_OWNER_UID;
+		info->uid    =3D id;
+		*flags      |=3D FLAG_UID_OWNER;
+		return true;
+
+	case 'g':
+		param_act(P_ONLY_ONCE, "owner", "--gid-owner", *flags & FLAG_GID_OWN=
ER);
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((grp =3D getgrnam(optarg)) !=3D NULL)
+			id =3D grp->gr_gid;
+		else if (!strtonum(optarg, NULL, &id, 0, ~(gid_t)0))
+			param_act(P_BAD_VALUE, "owner", "--gid-owner", optarg);
+		if (invert)
+			info->invert |=3D IPT_OWNER_GID;
+		info->match |=3D IPT_OWNER_GID;
+		info->gid    =3D id;
+		*flags      |=3D FLAG_GID_OWNER;
+		return true;
+
+	case 'p':
+		param_act(P_ONLY_ONCE, "owner", "--pid-owner", *flags & FLAG_PID_OWN=
ER);
+		check_inverse(optarg, &invert, &optind, 0);
+		if (!strtonum(optarg, NULL, &id, 0, INT_MAX))
+			param_act(P_BAD_VALUE, "owner", "--pid-owner", optarg);
+		if (invert)
+			info->invert |=3D IPT_OWNER_PID;
+		info->match |=3D IPT_OWNER_PID;
+		info->pid    =3D id;
+		*flags      |=3D FLAG_PID_OWNER;
+		return true;
+
+	case 's':
+		param_act(P_ONLY_ONCE, "owner", "--sid-owner", *flags & FLAG_SID_OWN=
ER);
+		check_inverse(optarg, &invert, &optind, 0);
+		if (!strtonum(optarg, NULL, &id, 0, INT_MAX))
+			param_act(P_BAD_VALUE, "owner", "--sid-value", optarg);
+		if (invert)
+			info->invert |=3D IPT_OWNER_SID;
+		info->match |=3D IPT_OWNER_SID;
+		info->sid    =3D id;
+		*flags      |=3D FLAG_SID_OWNER;
+		return true;
+
+#ifdef IPT_OWNER_COMM
+	case 'c':
+		param_act(P_ONLY_ONCE, "owner", "--cmd-owner", *flags & FLAG_COMM);
+		check_inverse(optarg, &invert, &optind, 0);
+		if (strlen(optarg) > sizeof(info->comm))
+			exit_error(PARAMETER_PROBLEM, "owner match: command "
+			           "\"%s\" too long, max. %zu characters",
+			           optarg, sizeof(info->comm));
+
+		info->comm[sizeof(info->comm)-1] =3D '\0';
+		strncpy(info->comm, optarg, sizeof(info->comm));
+
+		if (invert)
+			info->invert |=3D IPT_OWNER_COMM;
+		info->match |=3D IPT_OWNER_COMM;
+		*flags      |=3D FLAG_COMM;
+		return true;
+#endif
+	}
+	return false;
+}
+
+static int
+owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags=
,
+                   const void *entry, struct xt_entry_match **match)
+{
+	struct ip6t_owner_info *info =3D (void *)(*match)->data;
+	struct passwd *pwd;
+	struct group *grp;
+	unsigned int id;
+
+	switch (c) {
+	case 'u':
+		param_act(P_ONLY_ONCE, "owner", "--uid-owner",
+		          *flags & FLAG_UID_OWNER);
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((pwd =3D getpwnam(optarg)) !=3D NULL)
+			id =3D pwd->pw_uid;
+		else if (!strtonum(optarg, NULL, &id, 0, ~(uid_t)0))
+			param_act(P_BAD_VALUE, "owner", "--uid-owner", optarg);
+		if (invert)
+			info->invert |=3D IP6T_OWNER_UID;
+		info->match |=3D IP6T_OWNER_UID;
+		info->uid    =3D id;
+		*flags      |=3D FLAG_UID_OWNER;
+		return true;
+
+	case 'g':
+		param_act(P_ONLY_ONCE, "owner", "--gid-owner",
+		          *flags & FLAG_GID_OWNER);
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((grp =3D getgrnam(optarg)) !=3D NULL)
+			id =3D grp->gr_gid;
+		else if (!strtonum(optarg, NULL, &id, 0, ~(gid_t)0))
+			param_act(P_BAD_VALUE, "owner", "--gid-owner", optarg);
+		if (invert)
+			info->invert |=3D IP6T_OWNER_GID;
+		info->match |=3D IP6T_OWNER_GID;
+		info->gid    =3D id;
+		*flags      |=3D FLAG_GID_OWNER;
+		return true;
+
+	case 'p':
+		param_act(P_ONLY_ONCE, "owner", "--pid-owner",
+		          *flags & FLAG_PID_OWNER);
+		check_inverse(optarg, &invert, &optind, 0);
+		if (!strtonum(optarg, NULL, &id, 0, INT_MAX))
+			param_act(P_BAD_VALUE, "owner", "--pid-owner", optarg);
+		if (invert)
+			info->invert |=3D IP6T_OWNER_PID;
+		info->match |=3D IP6T_OWNER_PID;
+		info->pid    =3D id;
+		*flags      |=3D FLAG_PID_OWNER;
+		return true;
+
+	case 's':
+		param_act(P_ONLY_ONCE, "owner", "--sid-owner",
+		          *flags & FLAG_SID_OWNER);
+		check_inverse(optarg, &invert, &optind, 0);
+		if (!strtonum(optarg, NULL, &id, 0, INT_MAX))
+			param_act(P_BAD_VALUE, "owner", "--sid-owner", optarg);
+		if (invert)
+			info->invert |=3D IP6T_OWNER_SID;
+		info->match |=3D IP6T_OWNER_SID;
+		info->sid    =3D id;
+		*flags      |=3D FLAG_SID_OWNER;
+		return true;
+	}
+	return false;
+}
+
+static int owner_mt_parse(int c, char **argv, int invert, unsigned int=
 *flags,
+                          const void *entry, struct xt_entry_match **m=
atch)
+{
+	struct xt_owner_match_info *info =3D (void *)(*match)->data;
+	struct passwd *pwd;
+	struct group *grp;
+	unsigned int id;
+
+	switch (c) {
+	case 'u':
+		param_act(P_ONLY_ONCE, "owner", "--uid-owner",
+		          *flags & FLAG_UID_OWNER);
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((pwd =3D getpwnam(optarg)) !=3D NULL)
+			id =3D pwd->pw_uid;
+		else if (!strtonum(optarg, NULL, &id, 0, ~(uid_t)0))
+			param_act(P_BAD_VALUE, "owner", "--uid-owner", optarg);
+		if (invert)
+			info->invert |=3D XT_OWNER_UID;
+		info->match |=3D XT_OWNER_UID;
+		info->uid    =3D id;
+		*flags      |=3D FLAG_UID_OWNER;
+		return true;
+
+	case 'g':
+		param_act(P_ONLY_ONCE, "owner", "--gid-owner",
+		          *flags & FLAG_GID_OWNER);
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((grp =3D getgrnam(optarg)) !=3D NULL)
+			id =3D grp->gr_gid;
+		else if (!strtonum(optarg, NULL, &id, 0, ~(gid_t)0))
+			param_invalid("owner", "--gid-owner", optarg);
+		if (invert)
+			info->invert |=3D XT_OWNER_GID;
+		info->match |=3D XT_OWNER_GID;
+		info->gid    =3D id;
+		*flags      |=3D FLAG_GID_OWNER;
+		return true;
+
+	case 'k':
+		param_act(P_ONLY_ONCE, "owner", "--socket-exists",
+		          *flags & FLAG_SOCKET_EXISTS);
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->invert |=3D XT_OWNER_SOCKET;
+		info->match |=3D XT_OWNER_SOCKET;
+		*flags |=3D FLAG_SOCKET_EXISTS;
+		return true;
+
+	}
+	return false;
+}
+
+static void owner_mt_check(unsigned int flags)
+{
+	if (flags =3D=3D 0)
+		param_act(P_NEED_MATCH, "owner");
+}
+
+static void
+owner_mt_print_item_v0(const struct ipt_owner_info *info, const char *=
label,
+                       u_int8_t flag, bool numeric)
+{
+	if (!(info->match & flag))
+		return;
+	if (info->invert & flag)
+		printf("! ");
+	printf(label);
+
+	switch (info->match & flag) {
+	case IPT_OWNER_UID:
+		if (!numeric) {
+			struct passwd *pwd =3D getpwuid(info->uid);
+
+			if (pwd !=3D NULL && pwd->pw_name !=3D NULL) {
+				printf("%s ", pwd->pw_name);
+				break;
+			}
+		}
+		printf("%u ", (unsigned int)info->uid);
+		break;
+
+	case IPT_OWNER_GID:
+		if (!numeric) {
+			struct group *grp =3D getgrgid(info->gid);
+
+			if (grp !=3D NULL && grp->gr_name !=3D NULL) {
+				printf("%s ", grp->gr_name);
+				break;
+			}
+		}
+		printf("%u ", (unsigned int)info->gid);
+		break;
+
+	case IPT_OWNER_PID:
+		printf("%u ", (unsigned int)info->pid);
+		break;
+
+	case IPT_OWNER_SID:
+		printf("%u ", (unsigned int)info->sid);
+		break;
+
+#ifdef IPT_OWNER_COMM
+	case IPT_OWNER_COMM:
+		printf("%.*s ", (int)sizeof(info->comm), info->comm);
+		break;
+#endif
+	}
+}
+
+static void
+owner_mt6_print_item_v0(const struct ip6t_owner_info *info, const char=
 *label,
+                        u_int8_t flag, bool numeric)
+{
+	if (!(info->match & flag))
+		return;
+	if (info->invert & flag)
+		printf("! ");
+	printf(label);
+
+	switch (info->match & flag) {
+	case IP6T_OWNER_UID:
+		if (!numeric) {
+			struct passwd *pwd =3D getpwuid(info->uid);
+
+			if (pwd !=3D NULL && pwd->pw_name !=3D NULL) {
+				printf("%s ", pwd->pw_name);
+				break;
+			}
+		}
+		printf("%u ", (unsigned int)info->uid);
+		break;
+
+	case IP6T_OWNER_GID:
+		if (!numeric) {
+			struct group *grp =3D getgrgid(info->gid);
+
+			if (grp !=3D NULL && grp->gr_name !=3D NULL) {
+				printf("%s ", grp->gr_name);
+				break;
+			}
+		}
+		printf("%u ", (unsigned int)info->gid);
+		break;
+
+	case IP6T_OWNER_PID:
+		printf("%u ", (unsigned int)info->pid);
+		break;
+
+	case IP6T_OWNER_SID:
+		printf("%u ", (unsigned int)info->sid);
+		break;
+	}
+}
+
+static void
+owner_mt_print_item(const struct xt_owner_match_info *info, const char=
 *label,
+                    u_int8_t flag, bool numeric)
+{
+	if (!(info->match & flag))
+		return;
+	if (info->invert & flag)
+		printf("! ");
+	printf(label);
+
+	switch (info->match & flag) {
+	case XT_OWNER_UID:
+		if (!numeric) {
+			const struct passwd *pwd =3D getpwuid(info->uid);
+
+			if (pwd !=3D NULL && pwd->pw_name !=3D NULL) {
+				printf("%s ", pwd->pw_name);
+				break;
+			}
+		}
+		printf("%u ", (unsigned int)info->uid);
+		break;
+
+	case XT_OWNER_GID:
+		if (!numeric) {
+			const struct group *grp =3D getgrgid(info->gid);
+
+			if (grp !=3D NULL && grp->gr_name !=3D NULL) {
+				printf("%s ", grp->gr_name);
+				break;
+			}
+		}
+		printf("%u ", (unsigned int)info->gid);
+		break;
+	}
+}
+
+static void
+owner_mt_print_v0(const void *ip, const struct xt_entry_match *match,
+                  int numeric)
+{
+	const struct ipt_owner_info *info =3D (void *)match->data;
+
+	owner_mt_print_item_v0(info, "owner UID match ", IPT_OWNER_UID, numer=
ic);
+	owner_mt_print_item_v0(info, "owner GID match ", IPT_OWNER_GID, numer=
ic);
+	owner_mt_print_item_v0(info, "owner PID match ", IPT_OWNER_PID, numer=
ic);
+	owner_mt_print_item_v0(info, "owner SID match ", IPT_OWNER_SID, numer=
ic);
+#ifdef IPT_OWNER_COMM
+	owner_mt_print_item_v0(info, "owner CMD match ", IPT_OWNER_COMM, nume=
ric);
+#endif
+}
+
+static void
+owner_mt6_print_v0(const void *ip, const struct xt_entry_match *match,
+                   int numeric)
+{
+	const struct ip6t_owner_info *info =3D (void *)match->data;
+
+	owner_mt6_print_item_v0(info, "owner UID match ", IPT_OWNER_UID, nume=
ric);
+	owner_mt6_print_item_v0(info, "owner GID match ", IPT_OWNER_GID, nume=
ric);
+	owner_mt6_print_item_v0(info, "owner PID match ", IPT_OWNER_PID, nume=
ric);
+	owner_mt6_print_item_v0(info, "owner SID match ", IPT_OWNER_SID, nume=
ric);
+}
+
+static void owner_mt_print(const void *ip, const struct xt_entry_match=
 *match,
+                           int numeric)
+{
+	const struct xt_owner_match_info *info =3D (void *)match->data;
+
+	owner_mt_print_item(info, "owner socket exists ", XT_OWNER_SOCKET, nu=
meric);
+	owner_mt_print_item(info, "owner UID match ",     XT_OWNER_UID,    nu=
meric);
+	owner_mt_print_item(info, "owner GID match ",     XT_OWNER_GID,    nu=
meric);
+}
+
+static void
+owner_mt_save_v0(const void *ip, const struct xt_entry_match *match)
+{
+	const struct ipt_owner_info *info =3D (void *)match->data;
+
+	owner_mt_print_item_v0(info, "owner UID match ", IPT_OWNER_UID, true)=
;
+	owner_mt_print_item_v0(info, "owner GID match ", IPT_OWNER_GID, true)=
;
+	owner_mt_print_item_v0(info, "owner PID match ", IPT_OWNER_PID, true)=
;
+	owner_mt_print_item_v0(info, "owner SID match ", IPT_OWNER_SID, true)=
;
+#ifdef IPT_OWNER_COMM
+	owner_mt_print_item_v0(info, "owner CMD match ", IPT_OWNER_COMM, true=
);
+#endif
+}
+
+static void
+owner_mt6_save_v0(const void *ip, const struct xt_entry_match *match)
+{
+	const struct ip6t_owner_info *info =3D (void *)match->data;
+
+	owner_mt6_print_item_v0(info, "owner UID match ", IPT_OWNER_UID, true=
);
+	owner_mt6_print_item_v0(info, "owner GID match ", IPT_OWNER_GID, true=
);
+	owner_mt6_print_item_v0(info, "owner PID match ", IPT_OWNER_PID, true=
);
+	owner_mt6_print_item_v0(info, "owner SID match ", IPT_OWNER_SID, true=
);
+}
+
+static void owner_mt_save(const void *ip, const struct xt_entry_match =
*match)
+{
+	const struct xt_owner_match_info *info =3D (void *)match->data;
+
+	owner_mt_print_item(info, "--socket-exists ", XT_OWNER_SOCKET, false)=
;
+	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,    false)=
;
+	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    false)=
;
+}
+
+static struct xtables_match owner_mt_reg_v0 =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "owner",
+	.revision      =3D 0,
+	.family        =3D AF_INET,
+	.size          =3D XT_ALIGN(sizeof(struct ipt_owner_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct ipt_owner_info)),
+	.help          =3D owner_mt_help_v0,
+	.parse         =3D owner_mt_parse_v0,
+	.final_check   =3D owner_mt_check,
+	.print         =3D owner_mt_print_v0,
+	.save          =3D owner_mt_save_v0,
+	.extra_opts    =3D owner_mt_opts_v0,
+};
+
+static struct xtables_match owner_mt6_reg_v0 =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "owner",
+	.revision      =3D 0,
+	.family        =3D AF_INET6,
+	.size          =3D XT_ALIGN(sizeof(struct ip6t_owner_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct ip6t_owner_info)),
+	.help          =3D owner_mt6_help_v0,
+	.parse         =3D owner_mt6_parse_v0,
+	.final_check   =3D owner_mt_check,
+	.print         =3D owner_mt6_print_v0,
+	.save          =3D owner_mt6_save_v0,
+	.extra_opts    =3D owner_mt6_opts_v0,
+};
+
+static struct xtables_match owner_mt_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "owner",
+	.revision      =3D 1,
+	.family        =3D AF_INET,
+	.size          =3D XT_ALIGN(sizeof(struct xt_owner_match_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_owner_match_info)),
+	.help          =3D owner_mt_help,
+	.parse         =3D owner_mt_parse,
+	.final_check   =3D owner_mt_check,
+	.print         =3D owner_mt_print,
+	.save          =3D owner_mt_save,
+	.extra_opts    =3D owner_mt_opts,
+};
+
+static struct xtables_match owner_mt6_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "owner",
+	.revision      =3D 1,
+	.family        =3D AF_INET6,
+	.size          =3D XT_ALIGN(sizeof(struct xt_owner_match_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_owner_match_info)),
+	.help          =3D owner_mt_help,
+	.parse         =3D owner_mt_parse,
+	.final_check   =3D owner_mt_check,
+	.print         =3D owner_mt_print,
+	.save          =3D owner_mt_save,
+	.extra_opts    =3D owner_mt_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&owner_mt_reg_v0);
+	xtables_register_match(&owner_mt6_reg_v0);
+	xtables_register_match(&owner_mt_reg);
+	xtables_register_match(&owner_mt6_reg);
+}
Index: iptables-modules/extensions/libxt_owner.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_owner.man
@@ -0,0 +1,16 @@
+This module attempts to match various characteristics of the packet cr=
eator,
+for locally generated packets. This match is only valid in the OUTPUT =
and
+POSTROUTING chains. Forwarded packets do not have any socket associate=
d with
+them. Packets from kernel threads do have a socket, but usually no own=
er.
+.TP
+\fB--uid-owner\fR \fIuserid\fR
+Matches if the packet socket's file structure (if it has one) is owned=
 by the
+given user ID. A user name may be specified in place of \fIuserid\fR, =
in which
+case iptables will try to look it up.
+.TP
+\fB--gid-owner\fR \fIgroupid\fR
+Matches if the packet socket's file structure is owned by the given gr=
oup ID.
+A group name may be specified in place of \fIgroupid\fR.
+.TP
+\fB--socket-exists\fR
+Matches if the packet is associated with a socket.
Index: iptables-modules/include/linux/netfilter/xt_owner.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/include/linux/netfilter/xt_owner.h
@@ -0,0 +1,16 @@
+#ifndef _XT_OWNER_MATCH_H
+#define _XT_OWNER_MATCH_H
+
+enum {
+	XT_OWNER_UID    =3D 1 << 0,
+	XT_OWNER_GID    =3D 1 << 1,
+	XT_OWNER_SOCKET =3D 1 << 2,
+};
+
+struct xt_owner_match_info {
+	u_int32_t uid;
+	u_int32_t gid;
+	u_int8_t match, invert;
+};
+
+#endif /* _XT_OWNER_MATCH_H */
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
