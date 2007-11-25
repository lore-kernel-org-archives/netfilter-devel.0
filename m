From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 4/4] iptables: libxt_owner
Date: Sun, 25 Nov 2007 02:15:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711250214160.25644@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711250204360.25644@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711250206430.25644@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55407 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbXKYBQA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Nov 2007 20:16:00 -0500
In-Reply-To: <Pine.LNX.4.64.0711250206430.25644@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Just when you thought everything worked, string_to_number() bites.
I misinterpreted its return value. Update below.

=3D=3D=3DPatch begins here=3D=3D=3D

Import libxt_owner


libxt_owner merges libipt_owner and libip6t_owner, and adds support
for the new xt_owner kernel module.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/Makefile                |    6 -
 extensions/libipt_owner.man        |   28 ----
 extensions/libxt_owner.c           |  218 ++++++++++++++++++++++++++++=
+++++++++
 extensions/libxt_owner.man         |   25 ++++
 include/linux/netfilter/xt_owner.h |   17 ++
 5 files changed, 263 insertions(+), 31 deletions(-)

Index: iptables/extensions/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/Makefile
+++ iptables/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this ipta=
bles
 # package (HW)
 #
-PF_EXT_SLIB:=3Dah addrtype conntrack ecn icmp iprange owner policy rea=
lm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETM=
AP REDIRECT REJECT SAME SNAT TOS TTL ULOG
-PF6_EXT_SLIB:=3Dah dst eui64 frag hbh hl icmp6 ipv6header mh owner pol=
icy rt HL LOG REJECT
-PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp has=
hlimit helper length limit mac mark multiport physdev pkttype quota sct=
p state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONN=
MARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PF_EXT_SLIB:=3Dah addrtype conntrack ecn icmp iprange policy realm rec=
ent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP RED=
IRECT REJECT SAME SNAT TOS TTL ULOG
+PF6_EXT_SLIB:=3Dah dst eui64 frag hbh hl icmp6 ipv6header mh policy rt=
 HL LOG REJECT
+PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp has=
hlimit helper length limit mac mark multiport owner physdev pkttype quo=
ta sctp state statistic standard string tcp tcpmss time u32 udp CLASSIF=
Y CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
=20
 PF_EXT_SELINUX_SLIB:=3D
 PF6_EXT_SELINUX_SLIB:=3D
Index: iptables/extensions/libipt_owner.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/libipt_owner.man
+++ /dev/null
@@ -1,28 +0,0 @@
-This module attempts to match various characteristics of the packet
-creator, for locally-generated packets.  It is only valid in the
-.B OUTPUT
-chain, and even this some packets (such as ICMP ping responses) may
-have no owner, and hence never match.
-.TP
-.BI "--uid-owner " "userid"
-Matches if the packet was created by a process with the given
-effective user id.
-.TP
-.BI "--gid-owner " "groupid"
-Matches if the packet was created by a process with the given
-effective group id.
-.TP
-.BI "--pid-owner " "processid"
-Matches if the packet was created by a process with the given
-process id.
-.TP
-.BI "--sid-owner " "sessionid"
-Matches if the packet was created by a process in the given session
-group.
-.TP
-.BI "--cmd-owner " "name"
-Matches if the packet was created by a process with the given command =
name.
-(this option is present only if iptables was compiled under a kernel
-supporting this feature)
-.TP
-.B NOTE: pid, sid and command matching are broken on SMP
Index: iptables/extensions/libxt_owner.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/libxt_owner.c
@@ -0,0 +1,218 @@
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
+
+enum {
+	FLAG_UID_OWNER     =3D 1 << 0,
+	FLAG_GID_OWNER     =3D 1 << 1,
+	FLAG_SOCKET_EXISTS =3D 1 << 2,
+	FLAG_FILP_EXISTS   =3D 1 << 3,
+};
+
+static void owner_mt_help(void)
+{
+	printf(
+"owner match v%s options:\n"
+"[!] --uid-owner userid     Match local UID\n"
+"[!] --gid-owner groupid    Match local GID\n"
+"[!] --socket-exists        Match if socket exists\n"
+"[!] --filp-exists          Match if filp exists\n"
+"\n",
+IPTABLES_VERSION);
+}
+
+static const struct option owner_mt_opts[] =3D {
+	{.name =3D "uid-owner",     .has_arg =3D true,  .val =3D 'u'},
+	{.name =3D "gid-owner",     .has_arg =3D true,  .val =3D 'g'},
+	{.name =3D "socket-exists", .has_arg =3D false, .val =3D 's'},
+	{.name =3D "filp-exists",   .has_arg =3D false, .val =3D 'f'},
+	{},
+};
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
+	case 's':
+		if (*flags & FLAG_SOCKET_EXISTS)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "--socket-exists may only be given once");
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->invert |=3D XT_OWNER_SOCKET;
+		info->match |=3D XT_OWNER_SOCKET;
+		*flags |=3D FLAG_SOCKET_EXISTS;
+		return true;
+
+	case 'f':
+		if (*flags & FLAG_FILP_EXISTS)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "--filp-exists may only be given once");
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->invert |=3D XT_OWNER_FILP;
+		info->match |=3D XT_OWNER_FILP;
+		*flags |=3D FLAG_FILP_EXISTS;
+		return true;
+
+	case 'u':
+		if (*flags & FLAG_UID_OWNER)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "--uid-owner may only be given once");
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((pwd =3D getpwnam(optarg)) !=3D NULL) {
+			info->uid =3D pwd->pw_uid;
+		} else {
+			if (string_to_number(optarg, 0, UINT_MAX, &id) < 0)
+				exit_error(PARAMETER_PROBLEM, "owner match: "
+				           "Invalid value for --uid-owner "
+				           "parameter: %s", optarg);
+			info->uid =3D id;
+		}
+		if (invert)
+			info->invert |=3D XT_OWNER_UID;
+		info->match |=3D XT_OWNER_UID;
+		*flags |=3D FLAG_UID_OWNER;
+		return true;
+
+	case 'g':
+		if (*flags & FLAG_GID_OWNER)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "--gid-owner may only be given once");
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((grp =3D getgrnam(optarg)) !=3D NULL) {
+			info->gid =3D grp->gr_gid;
+		} else {
+			if (string_to_number(optarg, 0, UINT_MAX, &id) < 0)
+				exit_error(PARAMETER_PROBLEM, "owner match: "
+				           "Invalid value for --gid-owner "
+				           "parameter: %s", optarg);
+			info->gid =3D id;
+		}
+		if (invert)
+			info->invert |=3D XT_OWNER_GID;
+		info->match |=3D XT_OWNER_GID;
+		*flags |=3D FLAG_GID_OWNER;
+		return true;
+	}
+	return false;
+}
+
+static void owner_mt_print_item(const struct xt_owner_match_info *info=
,
+                                u_int8_t flag, int numeric, const char=
 *label)
+{
+	if (!(info->match & flag))
+		return;
+
+	if (info->invert & flag)
+		printf("! ");
+
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
+static void owner_mt_check(unsigned int flags)
+{
+	if (flags =3D=3D 0)
+		exit_error(PARAMETER_PROBLEM,
+			   "owner match: One or more parameters are required");
+}
+
+static void owner_mt_print(const void *ip, const struct xt_entry_match=
 *match,
+                           int numeric)
+{
+	const struct xt_owner_match_info *info =3D (void *)match->data;
+
+	owner_mt_print_item(info, XT_OWNER_SOCKET, numeric, "OWNER socket exi=
sts ");
+	owner_mt_print_item(info, XT_OWNER_FILP,   numeric, "OWNER filp exist=
s ");
+	owner_mt_print_item(info, XT_OWNER_UID,    numeric, "OWNER UID match =
");
+	owner_mt_print_item(info, XT_OWNER_GID,    numeric, "OWNER GID match =
");
+}
+
+static void owner_mt_save(const void *ip, const struct xt_entry_match =
*match)
+{
+	const struct xt_owner_match_info *info =3D (void *)match->data;
+
+	owner_mt_print_item(info, XT_OWNER_SOCKET, false, "--socket-exists ")=
;
+	owner_mt_print_item(info, XT_OWNER_FILP,   false, "--filp-exists ");
+	owner_mt_print_item(info, XT_OWNER_UID,    false, "--uid-owner ");
+	owner_mt_print_item(info, XT_OWNER_GID,    false, "--gid-owner ");
+}
+
+static struct xtables_match owner_mt_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "owner",
+	.family        =3D AF_INET,
+	.revision      =3D 1,
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
+	.family        =3D AF_INET6,
+	.revision      =3D 1,
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
+	xtables_register_match(&owner_mt_reg);
+	xtables_register_match(&owner_mt6_reg);
+}
Index: iptables/extensions/libxt_owner.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/libxt_owner.man
@@ -0,0 +1,25 @@
+This module attempts to match various characteristics of the packet cr=
eator,
+for locally generated packets. This match is only valid in the OUTPUT =
and
+POSTROUTING chains. Even then, some packets do not have a socket or fi=
lp (see
+below) associated.
+
+Forwarded packets, which will hit POSTROUTING too, do not have any soc=
ket
+associated with them. Packets originating from kernel space, e.g. ICMP
+responses and packets from kernel threads or daemons (nfsd, network
+filesystems) have a socket, but often no filp associated with them.
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
+.TP
+\fB--filp-exists\fR
+Matches if the packet is associated with a socket and also a 'file' st=
ructure
+(filp).
Index: iptables/include/linux/netfilter/xt_owner.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/include/linux/netfilter/xt_owner.h
@@ -0,0 +1,17 @@
+#ifndef _XT_OWNER_MATCH_H
+#define _XT_OWNER_MATCH_H
+
+enum {
+	XT_OWNER_UID    =3D 1 << 0,
+	XT_OWNER_GID    =3D 1 << 1,
+	XT_OWNER_SOCKET =3D 1 << 2,
+	XT_OWNER_FILE   =3D 1 << 3,
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
