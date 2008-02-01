From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [10/10] [IPTABLES]: Split code into libxt_socket
Date: Fri, 1 Feb 2008 01:30:11 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802010129560.4864@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38783 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbYBAAaN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:30:13 -0500
In-Reply-To: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Split out the new code into libxt_socket.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libxt_owner.c            |  182 ---------------------------=
--
 extensions/libxt_owner.man          |   19 ---
 extensions/libxt_socket.c           |  220 +++++++++++++++++++++++++++=
+++++++++
 extensions/libxt_socket.man         |   19 +++
 include/linux/netfilter/xt_owner.h  |   16 --
 include/linux/netfilter/xt_socket.h |   16 ++
 6 files changed, 255 insertions(+), 217 deletions(-)

Index: iptables/extensions/libxt_owner.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/libxt_owner.c
+++ iptables/extensions/libxt_owner.c
@@ -14,7 +14,6 @@
 #include <string.h>
=20
 #include <xtables.h>
-#include <linux/netfilter/xt_owner.h>
 #include <linux/netfilter_ipv4/ipt_owner.h>
 #include <linux/netfilter_ipv6/ip6t_owner.h>
=20
@@ -63,16 +62,6 @@ static void owner_mt6_help_v0(void)
 "\n");
 }
=20
-static void owner_mt_help(void)
-{
-	printf(
-"owner match options:\n"
-"[!] --uid-owner userid[-userid]      Match local UID\n"
-"[!] --gid-owner groupid[-groupid]    Match local GID\n"
-"[!] --socket-exists                  Match if socket exists\n"
-"\n");
-}
-
 static const struct option owner_mt_opts_v0[] =3D {
 	{.name =3D "uid-owner", .has_arg =3D true, .val =3D 'u'},
 	{.name =3D "gid-owner", .has_arg =3D true, .val =3D 'g'},
@@ -92,13 +81,6 @@ static const struct option owner_mt6_opt
 	{},
 };
=20
-static const struct option owner_mt_opts[] =3D {
-	{.name =3D "uid-owner",     .has_arg =3D true,  .val =3D 'u'},
-	{.name =3D "gid-owner",     .has_arg =3D true,  .val =3D 'g'},
-	{.name =3D "socket-exists", .has_arg =3D false, .val =3D 'k'},
-	{},
-};
-
 static int
 owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
@@ -243,74 +225,6 @@ owner_mt6_parse_v0(int c, char **argv, i
 	return false;
 }
=20
-static void owner_parse_range(const char *s, unsigned int *from,
-                              unsigned int *to, const char *opt)
-{
-	char *end;
-
-	/* 4294967295 is reserved, so subtract one from ~0 */
-	if (!strtonum(s, &end, from, 0, (~(uid_t)0) - 1))
-		param_act(P_BAD_VALUE, "owner", opt, s);
-	*to =3D *from;
-	if (*end =3D=3D '-' || *end =3D=3D ':')
-		if (!strtonum(end + 1, &end, to, 0, (~(uid_t)0) - 1))
-			param_act(P_BAD_VALUE, "owner", opt, s);
-	if (*end !=3D '\0')
-		param_act(P_BAD_VALUE, "owner", opt, s);
-}
-
-static int owner_mt_parse(int c, char **argv, int invert, unsigned int=
 *flags,
-                          const void *entry, struct xt_entry_match **m=
atch)
-{
-	struct xt_owner_match_info *info =3D (void *)(*match)->data;
-	struct passwd *pwd;
-	struct group *grp;
-	unsigned int from, to;
-
-	switch (c) {
-	case 'u':
-		param_act(P_ONLY_ONCE, "owner", "--uid-owner",
-		          *flags & FLAG_UID_OWNER);
-		if ((pwd =3D getpwnam(optarg)) !=3D NULL)
-			from =3D to =3D pwd->pw_uid;
-		else
-			owner_parse_range(optarg, &from, &to, "--uid-owner");
-		if (invert)
-			info->invert |=3D XT_OWNER_UID;
-		info->match  |=3D XT_OWNER_UID;
-		info->uid_min =3D from;
-		info->uid_max =3D to;
-		*flags       |=3D FLAG_UID_OWNER;
-		return true;
-
-	case 'g':
-		param_act(P_ONLY_ONCE, "owner", "--gid-owner",
-		          *flags & FLAG_GID_OWNER);
-		if ((grp =3D getgrnam(optarg)) !=3D NULL)
-			from =3D to =3D grp->gr_gid;
-		else
-			owner_parse_range(optarg, &from, &to, "--gid-owner");
-		if (invert)
-			info->invert |=3D XT_OWNER_GID;
-		info->match  |=3D XT_OWNER_GID;
-		info->gid_min =3D from;
-		info->gid_max =3D to;
-		*flags      |=3D FLAG_GID_OWNER;
-		return true;
-
-	case 'k':
-		param_act(P_ONLY_ONCE, "owner", "--socket-exists",
-		          *flags & FLAG_SOCKET_EXISTS);
-		if (invert)
-			info->invert |=3D XT_OWNER_SOCKET;
-		info->match |=3D XT_OWNER_SOCKET;
-		*flags |=3D FLAG_SOCKET_EXISTS;
-		return true;
-
-	}
-	return false;
-}
-
 static void owner_mt_check(unsigned int flags)
 {
 	if (flags =3D=3D 0)
@@ -416,51 +330,6 @@ owner_mt6_print_item_v0(const struct ip6
 }
=20
 static void
-owner_mt_print_item(const struct xt_owner_match_info *info, const char=
 *label,
-                    u_int8_t flag, bool numeric)
-{
-	if (!(info->match & flag))
-		return;
-	if (info->invert & flag)
-		printf("! ");
-	printf(label);
-
-	switch (info->match & flag) {
-	case XT_OWNER_UID:
-		if (info->uid_min !=3D info->uid_max) {
-			printf("%u-%u ", (unsigned int)info->uid_min,
-			       (unsigned int)info->uid_max);
-			break;
-		} else if (!numeric) {
-			const struct passwd *pwd =3D getpwuid(info->uid_min);
-
-			if (pwd !=3D NULL && pwd->pw_name !=3D NULL) {
-				printf("%s ", pwd->pw_name);
-				break;
-			}
-		}
-		printf("%u ", (unsigned int)info->uid_min);
-		break;
-
-	case XT_OWNER_GID:
-		if (info->gid_min !=3D info->gid_max) {
-			printf("%u-%u ", (unsigned int)info->gid_min,
-			       (unsigned int)info->gid_max);
-			break;
-		} else if (!numeric) {
-			const struct group *grp =3D getgrgid(info->gid_min);
-
-			if (grp !=3D NULL && grp->gr_name !=3D NULL) {
-				printf("%s ", grp->gr_name);
-				break;
-			}
-		}
-		printf("%u ", (unsigned int)info->gid_min);
-		break;
-	}
-}
-
-static void
 owner_mt_print_v0(const void *ip, const struct xt_entry_match *match,
                   int numeric)
 {
@@ -487,16 +356,6 @@ owner_mt6_print_v0(const void *ip, const
 	owner_mt6_print_item_v0(info, "owner SID match ", IPT_OWNER_SID, nume=
ric);
 }
=20
-static void owner_mt_print(const void *ip, const struct xt_entry_match=
 *match,
-                           int numeric)
-{
-	const struct xt_owner_match_info *info =3D (void *)match->data;
-
-	owner_mt_print_item(info, "owner socket exists ", XT_OWNER_SOCKET, nu=
meric);
-	owner_mt_print_item(info, "owner UID match ",     XT_OWNER_UID,    nu=
meric);
-	owner_mt_print_item(info, "owner GID match ",     XT_OWNER_GID,    nu=
meric);
-}
-
 static void
 owner_mt_save_v0(const void *ip, const struct xt_entry_match *match)
 {
@@ -522,15 +381,6 @@ owner_mt6_save_v0(const void *ip, const=20
 	owner_mt6_print_item_v0(info, "owner SID match ", IPT_OWNER_SID, true=
);
 }
=20
-static void owner_mt_save(const void *ip, const struct xt_entry_match =
*match)
-{
-	const struct xt_owner_match_info *info =3D (void *)match->data;
-
-	owner_mt_print_item(info, "--socket-exists ", XT_OWNER_SOCKET, false)=
;
-	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,    false)=
;
-	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    false)=
;
-}
-
 static struct xtables_match owner_mt_reg_v0 =3D {
 	.version       =3D IPTABLES_VERSION,
 	.name          =3D "owner",
@@ -561,41 +411,9 @@ static struct xtables_match owner_mt6_re
 	.extra_opts    =3D owner_mt6_opts_v0,
 };
=20
-static struct xtables_match owner_mt_reg =3D {
-	.version       =3D IPTABLES_VERSION,
-	.name          =3D "owner",
-	.revision      =3D 1,
-	.family        =3D AF_INET,
-	.size          =3D XT_ALIGN(sizeof(struct xt_owner_match_info)),
-	.userspacesize =3D XT_ALIGN(sizeof(struct xt_owner_match_info)),
-	.help          =3D owner_mt_help,
-	.parse         =3D owner_mt_parse,
-	.final_check   =3D owner_mt_check,
-	.print         =3D owner_mt_print,
-	.save          =3D owner_mt_save,
-	.extra_opts    =3D owner_mt_opts,
-};
-
-static struct xtables_match owner_mt6_reg =3D {
-	.version       =3D IPTABLES_VERSION,
-	.name          =3D "owner",
-	.revision      =3D 1,
-	.family        =3D AF_INET6,
-	.size          =3D XT_ALIGN(sizeof(struct xt_owner_match_info)),
-	.userspacesize =3D XT_ALIGN(sizeof(struct xt_owner_match_info)),
-	.help          =3D owner_mt_help,
-	.parse         =3D owner_mt_parse,
-	.final_check   =3D owner_mt_check,
-	.print         =3D owner_mt_print,
-	.save          =3D owner_mt_save,
-	.extra_opts    =3D owner_mt_opts,
-};
-
 void _init(void);
 void _init(void)
 {
 	xtables_register_match(&owner_mt_reg_v0);
 	xtables_register_match(&owner_mt6_reg_v0);
-	xtables_register_match(&owner_mt_reg);
-	xtables_register_match(&owner_mt6_reg);
 }
Index: iptables/extensions/libxt_owner.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/libxt_owner.man
+++ /dev/null
@@ -1,19 +0,0 @@
-This module attempts to match various characteristics of the packet cr=
eator,
-for locally generated packets. This match is only valid in the OUTPUT =
and
-POSTROUTING chains. Forwarded packets do not have any socket associate=
d with
-them. Packets from kernel threads do have a socket, but usually no own=
er.
-.TP
-\fB--uid-owner\fR \fIusername\fR
-.TP
-\fB--uid-owner\fR \fIuserid\fR[\fB-\fR\fIuserid\fR]
-Matches if the packet socket's file structure (if it has one) is owned=
 by the
-given user. You may also specify a numerical UID, or an UID range.
-.TP
-\fB--gid-owner\fR \fIgroupname\fR
-.TP
-\fB--gid-owner\fR \fIgroupid\fR[\fB-\fR\fIgroupid\fR]
-Matches if the packet socket's file structure is owned by the given gr=
oup.
-You may also specify a numerical GID, or a GID range.
-.TP
-\fB--socket-exists\fR
-Matches if the packet is associated with a socket.
Index: iptables/extensions/libxt_socket.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/libxt_socket.c
@@ -0,0 +1,220 @@
+/*
+ *	libxt_socket - iptables addon for xt_socket
+ *
+ *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
+ *	Jan Engelhardt <jengelh@computergmbh.de>
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
+#include <linux/netfilter/xt_socket.h>
+
+enum {
+	FLAG_UID_OWNER     =3D 1 << 0,
+	FLAG_GID_OWNER     =3D 1 << 1,
+	FLAG_SOCKET_EXISTS =3D 1 << 2,
+};
+
+static void socket_mt_help(void)
+{
+	printf(
+"owner match options:\n"
+"[!] --uid-owner userid[-userid]      Match local UID\n"
+"[!] --gid-owner groupid[-groupid]    Match local GID\n"
+"[!] --socket-exists                  Match if socket exists\n"
+"\n");
+}
+
+static const struct option socket_mt_opts[] =3D {
+	{.name =3D "uid-owner",     .has_arg =3D true,  .val =3D 'u'},
+	{.name =3D "gid-owner",     .has_arg =3D true,  .val =3D 'g'},
+	{.name =3D "socket-exists", .has_arg =3D false, .val =3D 'k'},
+	{},
+};
+
+static void owner_parse_range(const char *s, unsigned int *from,
+                              unsigned int *to, const char *opt)
+{
+	char *end;
+
+	/* 4294967295 is reserved, so subtract one from ~0 */
+	if (!strtonum(s, &end, from, 0, (~(uid_t)0) - 1))
+		param_act(P_BAD_VALUE, "owner", opt, s);
+	*to =3D *from;
+	if (*end =3D=3D '-' || *end =3D=3D ':')
+		if (!strtonum(end + 1, &end, to, 0, (~(uid_t)0) - 1))
+			param_act(P_BAD_VALUE, "owner", opt, s);
+	if (*end !=3D '\0')
+		param_act(P_BAD_VALUE, "owner", opt, s);
+}
+
+static int socket_mt_parse(int c, char **argv, int invert, unsigned in=
t *flags,
+                           const void *entry, struct xt_entry_match **=
match)
+{
+	struct xt_socket_mtinfo *info =3D (void *)(*match)->data;
+	struct passwd *pwd;
+	struct group *grp;
+	unsigned int from, to;
+
+	switch (c) {
+	case 'u':
+		param_act(P_ONLY_ONCE, "owner", "--uid-owner",
+		          *flags & FLAG_UID_OWNER);
+		if ((pwd =3D getpwnam(optarg)) !=3D NULL)
+			from =3D to =3D pwd->pw_uid;
+		else
+			owner_parse_range(optarg, &from, &to, "--uid-owner");
+		if (invert)
+			info->invert |=3D XT_SOCKET_UID;
+		info->match  |=3D XT_SOCKET_UID;
+		info->uid_min =3D from;
+		info->uid_max =3D to;
+		*flags       |=3D FLAG_UID_OWNER;
+		return true;
+
+	case 'g':
+		param_act(P_ONLY_ONCE, "owner", "--gid-owner",
+		          *flags & FLAG_GID_OWNER);
+		if ((grp =3D getgrnam(optarg)) !=3D NULL)
+			from =3D to =3D grp->gr_gid;
+		else
+			owner_parse_range(optarg, &from, &to, "--gid-owner");
+		if (invert)
+			info->invert |=3D XT_SOCKET_GID;
+		info->match  |=3D XT_SOCKET_GID;
+		info->gid_min =3D from;
+		info->gid_max =3D to;
+		*flags      |=3D FLAG_GID_OWNER;
+		return true;
+
+	case 'k':
+		param_act(P_ONLY_ONCE, "owner", "--socket-exists",
+		          *flags & FLAG_SOCKET_EXISTS);
+		if (invert)
+			info->invert |=3D XT_SOCKET_EXISTS;
+		info->match |=3D XT_SOCKET_EXISTS;
+		*flags |=3D FLAG_SOCKET_EXISTS;
+		return true;
+
+	}
+	return false;
+}
+
+static void socket_mt_check(unsigned int flags)
+{
+	if (flags =3D=3D 0)
+		exit_error(PARAMETER_PROBLEM, "owner: At least one of "
+		           "--uid-owner, --gid-owner or --socket-exists "
+		           "is required");
+}
+
+static void
+socket_mt_print_item(const struct xt_socket_mtinfo *info, const char *=
label,
+                     u_int8_t flag, bool numeric)
+{
+	if (!(info->match & flag))
+		return;
+	if (info->invert & flag)
+		printf("! ");
+	printf(label);
+
+	switch (info->match & flag) {
+	case XT_SOCKET_UID:
+		if (info->uid_min !=3D info->uid_max) {
+			printf("%u-%u ", (unsigned int)info->uid_min,
+			       (unsigned int)info->uid_max);
+			break;
+		} else if (!numeric) {
+			const struct passwd *pwd =3D getpwuid(info->uid_min);
+
+			if (pwd !=3D NULL && pwd->pw_name !=3D NULL) {
+				printf("%s ", pwd->pw_name);
+				break;
+			}
+		}
+		printf("%u ", (unsigned int)info->uid_min);
+		break;
+
+	case XT_SOCKET_GID:
+		if (info->gid_min !=3D info->gid_max) {
+			printf("%u-%u ", (unsigned int)info->gid_min,
+			       (unsigned int)info->gid_max);
+			break;
+		} else if (!numeric) {
+			const struct group *grp =3D getgrgid(info->gid_min);
+
+			if (grp !=3D NULL && grp->gr_name !=3D NULL) {
+				printf("%s ", grp->gr_name);
+				break;
+			}
+		}
+		printf("%u ", (unsigned int)info->gid_min);
+		break;
+	}
+}
+
+static void socket_mt_print(const void *ip, const struct xt_entry_matc=
h *match,
+                            int numeric)
+{
+	const struct xt_socket_mtinfo *info =3D (void *)match->data;
+
+	socket_mt_print_item(info, "owner socket exists ",
+	                     XT_SOCKET_EXISTS, numeric);
+	socket_mt_print_item(info, "owner UID match ",
+	                     XT_SOCKET_UID, numeric);
+	socket_mt_print_item(info, "owner GID match ",
+	                     XT_SOCKET_GID, numeric);
+}
+
+static void socket_mt_save(const void *ip, const struct xt_entry_match=
 *match)
+{
+	const struct xt_socket_mtinfo *info =3D (void *)match->data;
+
+	socket_mt_print_item(info, "--socket-exists ", XT_SOCKET_EXISTS, fals=
e);
+	socket_mt_print_item(info, "--uid-owner",      XT_SOCKET_UID,    fals=
e);
+	socket_mt_print_item(info, "--gid-owner",      XT_SOCKET_GID,    fals=
e);
+}
+
+static struct xtables_match socket_mt_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "socket",
+	.revision      =3D 0,
+	.family        =3D AF_INET,
+	.size          =3D XT_ALIGN(sizeof(struct xt_socket_mtinfo)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_socket_mtinfo)),
+	.help          =3D socket_mt_help,
+	.parse         =3D socket_mt_parse,
+	.final_check   =3D socket_mt_check,
+	.print         =3D socket_mt_print,
+	.save          =3D socket_mt_save,
+	.extra_opts    =3D socket_mt_opts,
+};
+
+static struct xtables_match socket_mt6_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "socket",
+	.revision      =3D 0,
+	.family        =3D AF_INET6,
+	.size          =3D XT_ALIGN(sizeof(struct xt_socket_mtinfo)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_socket_mtinfo)),
+	.help          =3D socket_mt_help,
+	.parse         =3D socket_mt_parse,
+	.final_check   =3D socket_mt_check,
+	.print         =3D socket_mt_print,
+	.save          =3D socket_mt_save,
+	.extra_opts    =3D socket_mt_opts,
+};
+
+void _init(void);
+void _init(void)
+{
+	xtables_register_match(&socket_mt_reg);
+	xtables_register_match(&socket_mt6_reg);
+}
Index: iptables/extensions/libxt_socket.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/libxt_socket.man
@@ -0,0 +1,19 @@
+This module attempts to match various characteristics of the packet cr=
eator,
+for locally generated packets. This match is currently only valid in t=
he OUTPUT
+and POSTROUTING chains. Forwarded packets do not have any socket assoc=
iated
+with them. Packets from kernel threads do have a socket, but usually n=
o owner.
+.TP
+\fB--uid-owner\fR \fIusername\fR
+.TP
+\fB--uid-owner\fR \fIuserid\fR[\fB-\fR\fIuserid\fR]
+Matches if the packet socket's file structure (if it has one) is owned=
 by the
+given user. You may also specify a numerical UID, or an UID range.
+.TP
+\fB--gid-owner\fR \fIgroupname\fR
+.TP
+\fB--gid-owner\fR \fIgroupid\fR[\fB-\fR\fIgroupid\fR]
+Matches if the packet socket's file structure is owned by the given gr=
oup.
+You may also specify a numerical GID, or a GID range.
+.TP
+\fB--socket-exists\fR
+Matches if the packet is associated with a socket.
Index: iptables/include/linux/netfilter/xt_owner.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/include/linux/netfilter/xt_owner.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _XT_OWNER_MATCH_H
-#define _XT_OWNER_MATCH_H
-
-enum {
-	XT_OWNER_UID    =3D 1 << 0,
-	XT_OWNER_GID    =3D 1 << 1,
-	XT_OWNER_SOCKET =3D 1 << 2,
-};
-
-struct xt_owner_match_info {
-	u_int32_t uid_min, uid_max;
-	u_int32_t gid_min, gid_max;
-	u_int8_t match, invert;
-};
-
-#endif /* _XT_OWNER_MATCH_H */
Index: iptables/include/linux/netfilter/xt_socket.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/include/linux/netfilter/xt_socket.h
@@ -0,0 +1,16 @@
+#ifndef _XT_SOCKET_MATCH_H
+#define _XT_SOCKET_MATCH_H
+
+enum {
+	XT_SOCKET_UID    =3D 1 << 0,
+	XT_SOCKET_GID    =3D 1 << 1,
+	XT_SOCKET_EXISTS =3D 1 << 2,
+};
+
+struct xt_socket_mtinfo {
+	u_int32_t uid_min, uid_max;
+	u_int32_t gid_min, gid_max;
+	u_int8_t match, invert;
+};
+
+#endif /* _XT_SOCKET_MATCH_H */
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
