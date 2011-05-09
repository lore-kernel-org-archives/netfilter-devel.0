From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/17] libxt_owner: use guided option parser
Date: Mon,  9 May 2011 21:55:04 +0200
Message-ID: <1304970912-11520-11-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49359 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab1EITz1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:27 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_owner.c |  288 +++++++++++++++++++-------------------=
--------
 1 files changed, 117 insertions(+), 171 deletions(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index f930cf4..b60f907 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -4,16 +4,11 @@
  *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
  *	Jan Engelhardt <jengelh@computergmbh.de>
  */
-#include <getopt.h>
 #include <grp.h>
-#include <netdb.h>
 #include <pwd.h>
 #include <stdbool.h>
 #include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
 #include <limits.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_owner.h>
=20
@@ -55,12 +50,12 @@ struct ip6t_owner_info {
  */
=20
 enum {
-	FLAG_UID_OWNER     =3D 1 << 0,
-	FLAG_GID_OWNER     =3D 1 << 1,
-	FLAG_SOCKET_EXISTS =3D 1 << 2,
-	FLAG_PID_OWNER     =3D 1 << 3,
-	FLAG_SID_OWNER     =3D 1 << 4,
-	FLAG_COMM          =3D 1 << 5,
+	O_USER =3D 0,
+	O_GROUP,
+	O_SOCK_EXISTS,
+	O_PROCESS,
+	O_SESSION,
+	O_COMM,
 };
=20
 static void owner_mt_help_v0(void)
@@ -95,170 +90,134 @@ static void owner_mt_help(void)
 "[!] --socket-exists                  Match if socket exists\n");
 }
=20
-static const struct option owner_mt_opts_v0[] =3D {
-	{.name =3D "uid-owner", .has_arg =3D true, .val =3D 'u'},
-	{.name =3D "gid-owner", .has_arg =3D true, .val =3D 'g'},
-	{.name =3D "pid-owner", .has_arg =3D true, .val =3D 'p'},
-	{.name =3D "sid-owner", .has_arg =3D true, .val =3D 's'},
-	{.name =3D "cmd-owner", .has_arg =3D true, .val =3D 'c'},
-	XT_GETOPT_TABLEEND,
+#define s struct ipt_owner_info
+static const struct xt_option_entry owner_mt_opts_v0[] =3D {
+	{.name =3D "uid-owner", .id =3D O_USER, .type =3D XTTYPE_STRING,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "gid-owner", .id =3D O_GROUP, .type =3D XTTYPE_STRING,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "pid-owner", .id =3D O_PROCESS, .type =3D XTTYPE_UINT32,
+	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, pid),
+	 .max =3D INT_MAX},
+	{.name =3D "sid-owner", .id =3D O_SESSION, .type =3D XTTYPE_UINT32,
+	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, sid),
+	 .max =3D INT_MAX},
+	{.name =3D "cmd-owner", .id =3D O_COMM, .type =3D XTTYPE_STRING,
+	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, comm)},
+	XTOPT_TABLEEND,
 };
-
-static const struct option owner_mt6_opts_v0[] =3D {
-	{.name =3D "uid-owner", .has_arg =3D true, .val =3D 'u'},
-	{.name =3D "gid-owner", .has_arg =3D true, .val =3D 'g'},
-	{.name =3D "pid-owner", .has_arg =3D true, .val =3D 'p'},
-	{.name =3D "sid-owner", .has_arg =3D true, .val =3D 's'},
-	XT_GETOPT_TABLEEND,
+#undef s
+
+#define s struct ip6t_owner_info
+static const struct xt_option_entry owner_mt6_opts_v0[] =3D {
+	{.name =3D "uid-owner", .id =3D O_USER, .type =3D XTTYPE_STRING,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "gid-owner", .id =3D O_GROUP, .type =3D XTTYPE_STRING,
+	 .flags =3D XTOPT_INVERT},
+	{.name =3D "pid-owner", .id =3D O_PROCESS, .type =3D XTTYPE_UINT32,
+	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, pid),
+	 .max =3D INT_MAX},
+	{.name =3D "sid-owner", .id =3D O_SESSION, .type =3D XTTYPE_UINT32,
+	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, sid),
+	 .max =3D INT_MAX},
+	XTOPT_TABLEEND,
 };
+#undef s
=20
-static const struct option owner_mt_opts[] =3D {
-	{.name =3D "uid-owner",     .has_arg =3D true,  .val =3D 'u'},
-	{.name =3D "gid-owner",     .has_arg =3D true,  .val =3D 'g'},
-	{.name =3D "socket-exists", .has_arg =3D false, .val =3D 'k'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry owner_mt_opts[] =3D {
+	{.name =3D "uid-owner", .id =3D O_USER, .type =3D XTTYPE_STRING},
+	{.name =3D "gid-owner", .id =3D O_GROUP, .type =3D XTTYPE_STRING},
+	{.name =3D "socket-exists", .id =3D O_SOCK_EXISTS, .type =3D XTTYPE_N=
ONE},
+	XTOPT_TABLEEND,
 };
=20
-static int
-owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
-                  const void *entry, struct xt_entry_match **match)
+static void owner_mt_parse_v0(struct xt_option_call *cb)
 {
-	struct ipt_owner_info *info =3D (void *)(*match)->data;
+	struct ipt_owner_info *info =3D cb->data;
 	struct passwd *pwd;
 	struct group *grp;
 	unsigned int id;
=20
-	switch (c) {
-	case 'u':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--uid-owner", *flags & FL=
AG_UID_OWNER);
-		if ((pwd =3D getpwnam(optarg)) !=3D NULL)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_USER:
+		if ((pwd =3D getpwnam(cb->arg)) !=3D NULL)
 			id =3D pwd->pw_uid;
-		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
-			xtables_param_act(XTF_BAD_VALUE, "owner", "--uid-owner", optarg);
-		if (invert)
+		else if (!xtables_strtoui(cb->arg, NULL, &id, 0, UINT32_MAX - 1))
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--uid-owner", cb->arg);
+		if (cb->invert)
 			info->invert |=3D IPT_OWNER_UID;
 		info->match |=3D IPT_OWNER_UID;
 		info->uid    =3D id;
-		*flags      |=3D FLAG_UID_OWNER;
-		return true;
-
-	case 'g':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--gid-owner", *flags & FL=
AG_GID_OWNER);
-		if ((grp =3D getgrnam(optarg)) !=3D NULL)
+		break;
+	case O_GROUP:
+		if ((grp =3D getgrnam(cb->arg)) !=3D NULL)
 			id =3D grp->gr_gid;
-		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
-			xtables_param_act(XTF_BAD_VALUE, "owner", "--gid-owner", optarg);
-		if (invert)
+		else if (!xtables_strtoui(cb->arg, NULL, &id, 0, UINT32_MAX - 1))
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--gid-owner", cb->arg);
+		if (cb->invert)
 			info->invert |=3D IPT_OWNER_GID;
 		info->match |=3D IPT_OWNER_GID;
 		info->gid    =3D id;
-		*flags      |=3D FLAG_GID_OWNER;
-		return true;
-
-	case 'p':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--pid-owner", *flags & FL=
AG_PID_OWNER);
-		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "owner", "--pid-owner", optarg);
-		if (invert)
+		break;
+	case O_PROCESS:
+		if (cb->invert)
 			info->invert |=3D IPT_OWNER_PID;
 		info->match |=3D IPT_OWNER_PID;
-		info->pid    =3D id;
-		*flags      |=3D FLAG_PID_OWNER;
-		return true;
-
-	case 's':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--sid-owner", *flags & FL=
AG_SID_OWNER);
-		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "owner", "--sid-value", optarg);
-		if (invert)
+		break;
+	case O_SESSION:
+		if (cb->invert)
 			info->invert |=3D IPT_OWNER_SID;
 		info->match |=3D IPT_OWNER_SID;
-		info->sid    =3D id;
-		*flags      |=3D FLAG_SID_OWNER;
-		return true;
-
-	case 'c':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--cmd-owner", *flags & FL=
AG_COMM);
-		if (strlen(optarg) > sizeof(info->comm))
-			xtables_error(PARAMETER_PROBLEM, "owner match: command "
-			           "\"%s\" too long, max. %zu characters",
-			           optarg, sizeof(info->comm));
-
-		info->comm[sizeof(info->comm)-1] =3D '\0';
-		strncpy(info->comm, optarg, sizeof(info->comm));
-
-		if (invert)
+		break;
+	case O_COMM:
+		if (cb->invert)
 			info->invert |=3D IPT_OWNER_COMM;
 		info->match |=3D IPT_OWNER_COMM;
-		*flags      |=3D FLAG_COMM;
-		return true;
+		break;
 	}
-	return false;
 }
=20
-static int
-owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags=
,
-                   const void *entry, struct xt_entry_match **match)
+static void owner_mt6_parse_v0(struct xt_option_call *cb)
 {
-	struct ip6t_owner_info *info =3D (void *)(*match)->data;
+	struct ip6t_owner_info *info =3D cb->data;
 	struct passwd *pwd;
 	struct group *grp;
 	unsigned int id;
=20
-	switch (c) {
-	case 'u':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--uid-owner",
-		          *flags & FLAG_UID_OWNER);
-		if ((pwd =3D getpwnam(optarg)) !=3D NULL)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_USER:
+		if ((pwd =3D getpwnam(cb->arg)) !=3D NULL)
 			id =3D pwd->pw_uid;
-		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
-			xtables_param_act(XTF_BAD_VALUE, "owner", "--uid-owner", optarg);
-		if (invert)
+		else if (!xtables_strtoui(cb->arg, NULL, &id, 0, UINT32_MAX - 1))
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--uid-owner", cb->arg);
+		if (cb->invert)
 			info->invert |=3D IP6T_OWNER_UID;
 		info->match |=3D IP6T_OWNER_UID;
 		info->uid    =3D id;
-		*flags      |=3D FLAG_UID_OWNER;
-		return true;
-
-	case 'g':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--gid-owner",
-		          *flags & FLAG_GID_OWNER);
-		if ((grp =3D getgrnam(optarg)) !=3D NULL)
+		break;
+	case O_GROUP:
+		if ((grp =3D getgrnam(cb->arg)) !=3D NULL)
 			id =3D grp->gr_gid;
-		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
-			xtables_param_act(XTF_BAD_VALUE, "owner", "--gid-owner", optarg);
-		if (invert)
+		else if (!xtables_strtoui(cb->arg, NULL, &id, 0, UINT32_MAX - 1))
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--gid-owner", cb->arg);
+		if (cb->invert)
 			info->invert |=3D IP6T_OWNER_GID;
 		info->match |=3D IP6T_OWNER_GID;
 		info->gid    =3D id;
-		*flags      |=3D FLAG_GID_OWNER;
-		return true;
-
-	case 'p':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--pid-owner",
-		          *flags & FLAG_PID_OWNER);
-		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "owner", "--pid-owner", optarg);
-		if (invert)
+		break;
+	case O_PROCESS:
+		if (cb->invert)
 			info->invert |=3D IP6T_OWNER_PID;
 		info->match |=3D IP6T_OWNER_PID;
-		info->pid    =3D id;
-		*flags      |=3D FLAG_PID_OWNER;
-		return true;
-
-	case 's':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--sid-owner",
-		          *flags & FLAG_SID_OWNER);
-		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "owner", "--sid-owner", optarg);
-		if (invert)
+		break;
+	case O_SESSION:
+		if (cb->invert)
 			info->invert |=3D IP6T_OWNER_SID;
 		info->match |=3D IP6T_OWNER_SID;
-		info->sid    =3D id;
-		*flags      |=3D FLAG_SID_OWNER;
-		return true;
+		break;
 	}
-	return false;
 }
=20
 static void owner_parse_range(const char *s, unsigned int *from,
@@ -277,61 +236,48 @@ static void owner_parse_range(const char *s, unsi=
gned int *from,
 		xtables_param_act(XTF_BAD_VALUE, "owner", opt, s);
 }
=20
-static int owner_mt_parse(int c, char **argv, int invert, unsigned int=
 *flags,
-                          const void *entry, struct xt_entry_match **m=
atch)
+static void owner_mt_parse(struct xt_option_call *cb)
 {
-	struct xt_owner_match_info *info =3D (void *)(*match)->data;
+	struct xt_owner_match_info *info =3D cb->data;
 	struct passwd *pwd;
 	struct group *grp;
 	unsigned int from, to;
=20
-	switch (c) {
-	case 'u':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--uid-owner",
-		          *flags & FLAG_UID_OWNER);
-		if ((pwd =3D getpwnam(optarg)) !=3D NULL)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_USER:
+		if ((pwd =3D getpwnam(cb->arg)) !=3D NULL)
 			from =3D to =3D pwd->pw_uid;
 		else
-			owner_parse_range(optarg, &from, &to, "--uid-owner");
-		if (invert)
+			owner_parse_range(cb->arg, &from, &to, "--uid-owner");
+		if (cb->invert)
 			info->invert |=3D XT_OWNER_UID;
 		info->match  |=3D XT_OWNER_UID;
 		info->uid_min =3D from;
 		info->uid_max =3D to;
-		*flags       |=3D FLAG_UID_OWNER;
-		return true;
-
-	case 'g':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--gid-owner",
-		          *flags & FLAG_GID_OWNER);
-		if ((grp =3D getgrnam(optarg)) !=3D NULL)
+		break;
+	case O_GROUP:
+		if ((grp =3D getgrnam(cb->arg)) !=3D NULL)
 			from =3D to =3D grp->gr_gid;
 		else
-			owner_parse_range(optarg, &from, &to, "--gid-owner");
-		if (invert)
+			owner_parse_range(cb->arg, &from, &to, "--gid-owner");
+		if (cb->invert)
 			info->invert |=3D XT_OWNER_GID;
 		info->match  |=3D XT_OWNER_GID;
 		info->gid_min =3D from;
 		info->gid_max =3D to;
-		*flags      |=3D FLAG_GID_OWNER;
-		return true;
-
-	case 'k':
-		xtables_param_act(XTF_ONLY_ONCE, "owner", "--socket-exists",
-		          *flags & FLAG_SOCKET_EXISTS);
-		if (invert)
+		break;
+	case O_SOCK_EXISTS:
+		if (cb->invert)
 			info->invert |=3D XT_OWNER_SOCKET;
 		info->match |=3D XT_OWNER_SOCKET;
-		*flags |=3D FLAG_SOCKET_EXISTS;
-		return true;
-
+		break;
 	}
-	return false;
 }
=20
-static void owner_mt_check(unsigned int flags)
+static void owner_mt_check(struct xt_fcheck_call *cb)
 {
-	if (flags =3D=3D 0)
+	if (cb->xflags =3D=3D 0)
 		xtables_error(PARAMETER_PROBLEM, "owner: At least one of "
 		           "--uid-owner, --gid-owner or --socket-exists "
 		           "is required");
@@ -552,11 +498,11 @@ static struct xtables_match owner_mt_reg[] =3D {
 		.size          =3D XT_ALIGN(sizeof(struct ipt_owner_info)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct ipt_owner_info)),
 		.help          =3D owner_mt_help_v0,
-		.parse         =3D owner_mt_parse_v0,
-		.final_check   =3D owner_mt_check,
+		.x6_parse      =3D owner_mt_parse_v0,
+		.x6_fcheck     =3D owner_mt_check,
 		.print         =3D owner_mt_print_v0,
 		.save          =3D owner_mt_save_v0,
-		.extra_opts    =3D owner_mt_opts_v0,
+		.x6_options    =3D owner_mt_opts_v0,
 	},
 	{
 		.version       =3D XTABLES_VERSION,
@@ -566,11 +512,11 @@ static struct xtables_match owner_mt_reg[] =3D {
 		.size          =3D XT_ALIGN(sizeof(struct ip6t_owner_info)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct ip6t_owner_info)),
 		.help          =3D owner_mt6_help_v0,
-		.parse         =3D owner_mt6_parse_v0,
-		.final_check   =3D owner_mt_check,
+		.x6_parse      =3D owner_mt6_parse_v0,
+		.x6_fcheck     =3D owner_mt_check,
 		.print         =3D owner_mt6_print_v0,
 		.save          =3D owner_mt6_save_v0,
-		.extra_opts    =3D owner_mt6_opts_v0,
+		.x6_options    =3D owner_mt6_opts_v0,
 	},
 	{
 		.version       =3D XTABLES_VERSION,
@@ -580,11 +526,11 @@ static struct xtables_match owner_mt_reg[] =3D {
 		.size          =3D XT_ALIGN(sizeof(struct xt_owner_match_info)),
 		.userspacesize =3D XT_ALIGN(sizeof(struct xt_owner_match_info)),
 		.help          =3D owner_mt_help,
-		.parse         =3D owner_mt_parse,
-		.final_check   =3D owner_mt_check,
+		.x6_parse      =3D owner_mt_parse,
+		.x6_fcheck     =3D owner_mt_check,
 		.print         =3D owner_mt_print,
 		.save          =3D owner_mt_save,
-		.extra_opts    =3D owner_mt_opts,
+		.x6_options    =3D owner_mt_opts,
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
