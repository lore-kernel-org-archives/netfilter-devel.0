From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: IPT [PATCH 1/4] libxt_owner
Date: Sun, 25 Nov 2007 20:07:51 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711252007320.9477@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38197 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbXKYTHx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 14:07:53 -0500
In-Reply-To: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Import libxt_owner into iptables


libxt_owner merges libipt_owner and libip6t_owner, and adds support
for the new xt_owner kernel module.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 Delete libipt_owner.c
 Delete libip6t_owner.c

 extensions/Makefile                |    6=20
 extensions/libip6t_owner.c         |  240 --------------
 extensions/libipt_owner.c          |  241 ---------------
 extensions/libipt_owner.man        |   28 -
 extensions/libxt_owner.c           |  593 ++++++++++++++++++++++++++++=
+++++++++
 extensions/libxt_owner.man         |   16=20
 include/linux/netfilter/xt_owner.h |   16=20
 7 files changed, 628 insertions(+), 512 deletions(-)

Index: iptables-modules/extensions/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/extensions/Makefile
+++ iptables-modules/extensions/Makefile
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
Index: iptables-modules/extensions/libip6t_owner.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/extensions/libip6t_owner.c
+++ /dev/null
@@ -1,240 +0,0 @@
-/* Shared library add-on to iptables to add OWNER matching support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <pwd.h>
-#include <grp.h>
-
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6t_owner.h>
-
-/* Function which prints out usage message. */
-static void owner_help(void)
-{
-#ifdef IP6T_OWNER_COMM
-	printf(
-"OWNER match v%s options:\n"
-"[!] --uid-owner userid     Match local uid\n"
-"[!] --gid-owner groupid    Match local gid\n"
-"[!] --pid-owner processid  Match local pid\n"
-"[!] --sid-owner sessionid  Match local sid\n"
-"[!] --cmd-owner name       Match local command name\n"
-"\n",
-IPTABLES_VERSION);
-#else
-	printf(
-"OWNER match v%s options:\n"
-"[!] --uid-owner userid     Match local uid\n"
-"[!] --gid-owner groupid    Match local gid\n"
-"[!] --pid-owner processid  Match local pid\n"
-"[!] --sid-owner sessionid  Match local sid\n"
-"\n",
-IPTABLES_VERSION);
-#endif /* IP6T_OWNER_COMM */
-}
-
-static const struct option owner_opts[] =3D {
-	{ "uid-owner", 1, NULL, '1' },
-	{ "gid-owner", 1, NULL, '2' },
-	{ "pid-owner", 1, NULL, '3' },
-	{ "sid-owner", 1, NULL, '4' },
-#ifdef IP6T_OWNER_COMM
-	{ "cmd-owner", 1, NULL, '5' },
-#endif
-	{ }
-};
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int owner_parse(int c, char **argv, int invert, unsigned int *f=
lags,
-                       const void *entry, struct xt_entry_match **matc=
h)
-{
-	struct ip6t_owner_info *ownerinfo =3D (struct ip6t_owner_info *)(*mat=
ch)->data;
-
-	switch (c) {
-		char *end;
-		struct passwd *pwd;
-		struct group *grp;
-	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
-
-		if ((pwd =3D getpwnam(optarg)))
-			ownerinfo->uid =3D pwd->pw_uid;
-		else {
-			ownerinfo->uid =3D strtoul(optarg, &end, 0);
-			if (*end !=3D '\0' || end =3D=3D optarg)
-				exit_error(PARAMETER_PROBLEM, "Bad OWNER UID value `%s'", optarg);
-		}
-		if (invert)
-			ownerinfo->invert |=3D IP6T_OWNER_UID;
-		ownerinfo->match |=3D IP6T_OWNER_UID;
-		*flags =3D 1;
-		break;
-
-	case '2':
-		check_inverse(optarg, &invert, &optind, 0);
-		if ((grp =3D getgrnam(optarg)))
-			ownerinfo->gid =3D grp->gr_gid;
-		else {
-			ownerinfo->gid =3D strtoul(optarg, &end, 0);
-			if (*end !=3D '\0' || end =3D=3D optarg)
-				exit_error(PARAMETER_PROBLEM, "Bad OWNER GID value `%s'", optarg);
-		}
-		if (invert)
-			ownerinfo->invert |=3D IP6T_OWNER_GID;
-		ownerinfo->match |=3D IP6T_OWNER_GID;
-		*flags =3D 1;
-		break;
-
-	case '3':
-		check_inverse(optarg, &invert, &optind, 0);
-		ownerinfo->pid =3D strtoul(optarg, &end, 0);
-		if (*end !=3D '\0' || end =3D=3D optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad OWNER PID value `%s'", optarg);
-		if (invert)
-			ownerinfo->invert |=3D IP6T_OWNER_PID;
-		ownerinfo->match |=3D IP6T_OWNER_PID;
-		*flags =3D 1;
-		break;
-
-	case '4':
-		check_inverse(optarg, &invert, &optind, 0);
-		ownerinfo->sid =3D strtoul(optarg, &end, 0);
-		if (*end !=3D '\0' || end =3D=3D optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad OWNER SID value `%s'", optarg);
-		if (invert)
-			ownerinfo->invert |=3D IP6T_OWNER_SID;
-		ownerinfo->match |=3D IP6T_OWNER_SID;
-		*flags =3D 1;
-		break;
-
-#ifdef IP6T_OWNER_COMM
-	case '5':
-		check_inverse(optarg, &invert, &optind, 0);
-		if(strlen(optarg) > sizeof(ownerinfo->comm))
-			exit_error(PARAMETER_PROBLEM, "OWNER CMD `%s' too long, max %d char=
acters", optarg, sizeof(ownerinfo->comm));
-	=09
-		strncpy(ownerinfo->comm, optarg, sizeof(ownerinfo->comm));
-		ownerinfo->comm[sizeof(ownerinfo->comm)-1] =3D '\0';
-
-		if (invert)
-			ownerinfo->invert |=3D IP6T_OWNER_COMM;
-		ownerinfo->match |=3D IP6T_OWNER_COMM;
-		*flags =3D 1;
-		break;
-#endif
-	=09
-	default:
-		return 0;
-	}
-	return 1;
-}
-
-static void
-print_item(struct ip6t_owner_info *info, u_int8_t flag, int numeric, c=
har *label)
-{
-	if(info->match & flag) {
-
-		if (info->invert & flag)
-			printf("! ");
-
-		printf(label);
-
-		switch(info->match & flag) {
-		case IP6T_OWNER_UID:
-			if(!numeric) {
-				struct passwd *pwd =3D getpwuid(info->uid);
-
-				if(pwd && pwd->pw_name) {
-					printf("%s ", pwd->pw_name);
-					break;
-				}
-				/* FALLTHROUGH */
-			}
-			printf("%u ", info->uid);
-			break;
-		case IP6T_OWNER_GID:
-			if(!numeric) {
-				struct group *grp =3D getgrgid(info->gid);
-
-				if(grp && grp->gr_name) {
-					printf("%s ", grp->gr_name);
-					break;
-				}
-				/* FALLTHROUGH */
-			}
-			printf("%u ", info->gid);
-			break;
-		case IP6T_OWNER_PID:
-			printf("%u ", info->pid);
-			break;
-		case IP6T_OWNER_SID:
-			printf("%u ", info->sid);
-			break;
-#ifdef IP6T_OWNER_COMM
-		case IP6T_OWNER_COMM:
-			printf("%.*s ", (int)sizeof(info->comm), info->comm);
-			break;
-#endif
-		default:
-			break;
-		}
-	}
-}
-
-/* Final check; must have specified --own. */
-static void owner_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "OWNER match: You must specify one or more options");
-}
-
-/* Prints out the matchinfo. */
-static void owner_print(const void *ip, const struct xt_entry_match *m=
atch,
-                        int numeric)
-{
-	struct ip6t_owner_info *info =3D (struct ip6t_owner_info *)match->dat=
a;
-
-	print_item(info, IP6T_OWNER_UID, numeric, "OWNER UID match ");
-	print_item(info, IP6T_OWNER_GID, numeric, "OWNER GID match ");
-	print_item(info, IP6T_OWNER_PID, numeric, "OWNER PID match ");
-	print_item(info, IP6T_OWNER_SID, numeric, "OWNER SID match ");
-#ifdef IP6T_OWNER_COMM
-	print_item(info, IP6T_OWNER_COMM, numeric, "OWNER CMD match ");
-#endif
-}
-
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void owner_save(const void *ip, const struct xt_entry_match *ma=
tch)
-{
-	struct ip6t_owner_info *info =3D (struct ip6t_owner_info *)match->dat=
a;
-
-	print_item(info, IP6T_OWNER_UID, 0, "--uid-owner ");
-	print_item(info, IP6T_OWNER_GID, 0, "--gid-owner ");
-	print_item(info, IP6T_OWNER_PID, 0, "--pid-owner ");
-	print_item(info, IP6T_OWNER_SID, 0, "--sid-owner ");
-#ifdef IP6T_OWNER_COMM
-	print_item(info, IP6T_OWNER_COMM, 0, "--cmd-owner ");
-#endif
-}
-
-static struct ip6tables_match owner_match6 =3D {
-	.name 		=3D "owner",
-	.version	=3D IPTABLES_VERSION,
-	.size		=3D IP6T_ALIGN(sizeof(struct ip6t_owner_info)),
-	.userspacesize	=3D IP6T_ALIGN(sizeof(struct ip6t_owner_info)),
-	.help		=3D owner_help,
-	.parse		=3D owner_parse,
-	.final_check	=3D owner_check,
-	.print		=3D owner_print,
-	.save		=3D owner_save,
-	.extra_opts	=3D owner_opts,
-};
-
-void _init(void)
-{
-	register_match6(&owner_match6);
-}
Index: iptables-modules/extensions/libipt_owner.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/extensions/libipt_owner.c
+++ /dev/null
@@ -1,241 +0,0 @@
-/* Shared library add-on to iptables to add OWNER matching support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <pwd.h>
-#include <grp.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_owner.h>
-
-/* Function which prints out usage message. */
-static void owner_help(void)
-{
-#ifdef IPT_OWNER_COMM
-	printf(
-"OWNER match v%s options:\n"
-"[!] --uid-owner userid     Match local uid\n"
-"[!] --gid-owner groupid    Match local gid\n"
-"[!] --pid-owner processid  Match local pid\n"
-"[!] --sid-owner sessionid  Match local sid\n"
-"[!] --cmd-owner name       Match local command name\n"
-"NOTE: pid, sid and command matching are broken on SMP\n"
-"\n",
-IPTABLES_VERSION);
-#else
-	printf(
-"OWNER match v%s options:\n"
-"[!] --uid-owner userid     Match local uid\n"
-"[!] --gid-owner groupid    Match local gid\n"
-"[!] --pid-owner processid  Match local pid\n"
-"[!] --sid-owner sessionid  Match local sid\n"
-"NOTE: pid and sid matching are broken on SMP\n"
-"\n",
-IPTABLES_VERSION);
-#endif /* IPT_OWNER_COMM */
-}
-
-static const struct option owner_opts[] =3D {
-	{ "uid-owner", 1, NULL, '1' },
-	{ "gid-owner", 1, NULL, '2' },
-	{ "pid-owner", 1, NULL, '3' },
-	{ "sid-owner", 1, NULL, '4' },
-#ifdef IPT_OWNER_COMM
-	{ "cmd-owner", 1, NULL, '5' },
-#endif
-	{ }
-};
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int owner_parse(int c, char **argv, int invert, unsigned int *f=
lags,
-                       const void *entry, struct xt_entry_match **matc=
h)
-{
-	struct ipt_owner_info *ownerinfo =3D (struct ipt_owner_info *)(*match=
)->data;
-
-	switch (c) {
-		char *end;
-		struct passwd *pwd;
-		struct group *grp;
-	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
-		if ((pwd =3D getpwnam(optarg)))
-			ownerinfo->uid =3D pwd->pw_uid;
-		else {
-			ownerinfo->uid =3D strtoul(optarg, &end, 0);
-			if (*end !=3D '\0' || end =3D=3D optarg)
-				exit_error(PARAMETER_PROBLEM, "Bad OWNER UID value `%s'", optarg);
-		}
-		if (invert)
-			ownerinfo->invert |=3D IPT_OWNER_UID;
-		ownerinfo->match |=3D IPT_OWNER_UID;
-		*flags =3D 1;
-		break;
-
-	case '2':
-		check_inverse(optarg, &invert, &optind, 0);
-		if ((grp =3D getgrnam(optarg)))
-			ownerinfo->gid =3D grp->gr_gid;
-		else {
-			ownerinfo->gid =3D strtoul(optarg, &end, 0);
-			if (*end !=3D '\0' || end =3D=3D optarg)
-				exit_error(PARAMETER_PROBLEM, "Bad OWNER GID value `%s'", optarg);
-		}
-		if (invert)
-			ownerinfo->invert |=3D IPT_OWNER_GID;
-		ownerinfo->match |=3D IPT_OWNER_GID;
-		*flags =3D 1;
-		break;
-
-	case '3':
-		check_inverse(optarg, &invert, &optind, 0);
-		ownerinfo->pid =3D strtoul(optarg, &end, 0);
-		if (*end !=3D '\0' || end =3D=3D optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad OWNER PID value `%s'", optarg);
-		if (invert)
-			ownerinfo->invert |=3D IPT_OWNER_PID;
-		ownerinfo->match |=3D IPT_OWNER_PID;
-		*flags =3D 1;
-		break;
-
-	case '4':
-		check_inverse(optarg, &invert, &optind, 0);
-		ownerinfo->sid =3D strtoul(optarg, &end, 0);
-		if (*end !=3D '\0' || end =3D=3D optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad OWNER SID value `%s'", optarg);
-		if (invert)
-			ownerinfo->invert |=3D IPT_OWNER_SID;
-		ownerinfo->match |=3D IPT_OWNER_SID;
-		*flags =3D 1;
-		break;
-
-#ifdef IPT_OWNER_COMM
-	case '5':
-		check_inverse(optarg, &invert, &optind, 0);
-		if(strlen(optarg) > sizeof(ownerinfo->comm))
-			exit_error(PARAMETER_PROBLEM, "OWNER CMD `%s' too long, max %u char=
acters", optarg, (unsigned int)sizeof(ownerinfo->comm));
-
-		strncpy(ownerinfo->comm, optarg, sizeof(ownerinfo->comm));
-		ownerinfo->comm[sizeof(ownerinfo->comm)-1] =3D '\0';
-
-		if (invert)
-			ownerinfo->invert |=3D IPT_OWNER_COMM;
-		ownerinfo->match |=3D IPT_OWNER_COMM;
-		*flags =3D 1;
-		break;
-#endif
-
-	default:
-		return 0;
-	}
-	return 1;
-}
-
-static void
-print_item(struct ipt_owner_info *info, u_int8_t flag, int numeric, ch=
ar *label)
-{
-	if(info->match & flag) {
-
-		if (info->invert & flag)
-			printf("! ");
-
-		printf(label);
-
-		switch(info->match & flag) {
-		case IPT_OWNER_UID:
-			if(!numeric) {
-				struct passwd *pwd =3D getpwuid(info->uid);
-
-				if(pwd && pwd->pw_name) {
-					printf("%s ", pwd->pw_name);
-					break;
-				}
-				/* FALLTHROUGH */
-			}
-			printf("%u ", info->uid);
-			break;
-		case IPT_OWNER_GID:
-			if(!numeric) {
-				struct group *grp =3D getgrgid(info->gid);
-
-				if(grp && grp->gr_name) {
-					printf("%s ", grp->gr_name);
-					break;
-				}
-				/* FALLTHROUGH */
-			}
-			printf("%u ", info->gid);
-			break;
-		case IPT_OWNER_PID:
-			printf("%u ", info->pid);
-			break;
-		case IPT_OWNER_SID:
-			printf("%u ", info->sid);
-			break;
-#ifdef IPT_OWNER_COMM
-		case IPT_OWNER_COMM:
-			printf("%.*s ", (int)sizeof(info->comm), info->comm);
-			break;
-#endif
-		default:
-			break;
-		}
-	}
-}
-
-/* Final check; must have specified --own. */
-static void owner_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "OWNER match: You must specify one or more options");
-}
-
-/* Prints out the matchinfo. */
-static void owner_print(const void *ip, const struct xt_entry_match *m=
atch,
-                        int numeric)
-{
-	struct ipt_owner_info *info =3D (struct ipt_owner_info *)match->data;
-
-	print_item(info, IPT_OWNER_UID, numeric, "OWNER UID match ");
-	print_item(info, IPT_OWNER_GID, numeric, "OWNER GID match ");
-	print_item(info, IPT_OWNER_PID, numeric, "OWNER PID match ");
-	print_item(info, IPT_OWNER_SID, numeric, "OWNER SID match ");
-#ifdef IPT_OWNER_COMM
-	print_item(info, IPT_OWNER_COMM, numeric, "OWNER CMD match ");
-#endif
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void owner_save(const void *ip, const struct xt_entry_match *ma=
tch)
-{
-	struct ipt_owner_info *info =3D (struct ipt_owner_info *)match->data;
-
-	print_item(info, IPT_OWNER_UID, 0, "--uid-owner ");
-	print_item(info, IPT_OWNER_GID, 0, "--gid-owner ");
-	print_item(info, IPT_OWNER_PID, 0, "--pid-owner ");
-	print_item(info, IPT_OWNER_SID, 0, "--sid-owner ");
-#ifdef IPT_OWNER_COMM
-	print_item(info, IPT_OWNER_COMM, 0, "--cmd-owner ");
-#endif
-}
-
-static struct iptables_match owner_match =3D {
-	.name		=3D "owner",
-	.version	=3D IPTABLES_VERSION,
-	.size		=3D IPT_ALIGN(sizeof(struct ipt_owner_info)),
-	.userspacesize	=3D IPT_ALIGN(sizeof(struct ipt_owner_info)),
-	.help		=3D owner_help,
-	.parse		=3D owner_parse,
-	.final_check	=3D owner_check,
-	.print		=3D owner_print,
-	.save		=3D owner_save,
-	.extra_opts	=3D owner_opts,
-};
-
-void _init(void)
-{
-	register_match(&owner_match);
-}
Index: iptables-modules/extensions/libipt_owner.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/extensions/libipt_owner.man
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
Index: iptables-modules/extensions/libxt_owner.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_owner.c
@@ -0,0 +1,593 @@
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
+"owner match v%s options:\n"
+"[!] --uid-owner userid       Match local UID\n"
+"[!] --gid-owner groupid      Match local GID\n"
+"[!] --pid-owner processid    Match local PID\n"
+"[!] --sid-owner sessionid    Match local SID\n"
+"[!] --cmd-owner name         Match local command name\n"
+"NOTE: PID, SID and command matching are broken on SMP\n"
+"\n",
+IPTABLES_VERSION);
+#else
+	printf(
+"owner match v%s options:\n"
+"[!] --uid-owner userid       Match local UID\n"
+"[!] --gid-owner groupid      Match local GID\n"
+"[!] --pid-owner processid    Match local PID\n"
+"[!] --sid-owner sessionid    Match local SID\n"
+"NOTE: PID and SID matching are broken on SMP\n"
+"\n",
+IPTABLES_VERSION);
+#endif /* IPT_OWNER_COMM */
+}
+
+static void owner_mt6_help_v0(void)
+{
+	printf(
+"owner match v%s options:\n"
+"[!] --uid-owner userid       Match local UID\n"
+"[!] --gid-owner groupid      Match local GID\n"
+"[!] --pid-owner processid    Match local PID\n"
+"[!] --sid-owner sessionid    Match local SID\n"
+"NOTE: PID and SID matching are broken on SMP\n"
+"\n",
+IPTABLES_VERSION);
+}
+
+static void owner_mt_help(void)
+{
+	printf(
+"owner match v%s options:\n"
+"[!] --uid-owner userid     Match local UID\n"
+"[!] --gid-owner groupid    Match local GID\n"
+"[!] --socket-exists        Match if socket exists\n"
+"\n",
+IPTABLES_VERSION);
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
+	struct ipt_owner_info *ownerinfo =3D (void *)(*match)->data;
+	struct passwd *pwd;
+	struct group *grp;
+	unsigned int id;
+
+	switch (c) {
+	case 'u':
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((pwd =3D getpwnam(optarg)) !=3D NULL)
+			ownerinfo->uid =3D pwd->pw_uid;
+		else if (string_to_number(optarg, 0, UINT_MAX, &id) < 0)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "bad UID value \"%s\"", optarg);
+		if (invert)
+			ownerinfo->invert |=3D IPT_OWNER_UID;
+		ownerinfo->match |=3D IPT_OWNER_UID;
+		ownerinfo->uid    =3D id;
+		*flags |=3D FLAG_UID_OWNER;
+		return true;
+
+	case 'g':
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((grp =3D getgrnam(optarg)) !=3D NULL)
+			ownerinfo->gid =3D grp->gr_gid;
+		else if (string_to_number(optarg, 0, UINT_MAX, &id) < 0)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "bad GID value \"%s\"", optarg);
+		if (invert)
+			ownerinfo->invert |=3D IPT_OWNER_GID;
+		ownerinfo->match |=3D IPT_OWNER_GID;
+		ownerinfo->gid    =3D id;
+		*flags |=3D FLAG_GID_OWNER;
+		return true;
+
+	case 'p':
+		check_inverse(optarg, &invert, &optind, 0);
+		if (string_to_number(optarg, 0, UINT_MAX, &id) < 0)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "bad PID value \"%s\"", optarg);
+		if (invert)
+			ownerinfo->invert |=3D IPT_OWNER_PID;
+		ownerinfo->match |=3D IPT_OWNER_PID;
+		ownerinfo->pid    =3D id;
+		*flags |=3D FLAG_PID_OWNER;
+		return true;
+
+	case 's':
+		check_inverse(optarg, &invert, &optind, 0);
+		if (string_to_number(optarg, 0, UINT_MAX, &id) < 0)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "bad SID value \"%s\"", optarg);
+		if (invert)
+			ownerinfo->invert |=3D IPT_OWNER_SID;
+		ownerinfo->match |=3D IPT_OWNER_SID;
+		ownerinfo->sid    =3D id;
+		*flags |=3D FLAG_SID_OWNER;
+		return true;
+
+#ifdef IPT_OWNER_COMM
+	case 'c':
+		check_inverse(optarg, &invert, &optind, 0);
+		if (strlen(optarg) > sizeof(ownerinfo->comm))
+			exit_error(PARAMETER_PROBLEM, "owner match: command "
+			           "\"%s\" too long, max. %u characters",
+			           optarg, (unsigned int)sizeof(ownerinfo->comm));
+
+		ownerinfo->comm[sizeof(ownerinfo->comm)-1] =3D '\0';
+		strncpy(ownerinfo->comm, optarg, sizeof(ownerinfo->comm));
+
+		if (invert)
+			ownerinfo->invert |=3D IPT_OWNER_COMM;
+		ownerinfo->match |=3D IPT_OWNER_COMM;
+		*flags |=3D FLAG_COMM;
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
+	struct ip6t_owner_info *ownerinfo =3D (void *)(*match)->data;
+	struct passwd *pwd;
+	struct group *grp;
+	unsigned int id;
+
+	switch (c) {
+	case 'u':
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((pwd =3D getpwnam(optarg)) !=3D NULL)
+			ownerinfo->uid =3D pwd->pw_uid;
+		else if (string_to_number(optarg, 0, UINT_MAX, &id) < 0)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "bad UID value \"%s\"", optarg);
+		if (invert)
+			ownerinfo->invert |=3D IP6T_OWNER_UID;
+		ownerinfo->match |=3D IP6T_OWNER_UID;
+		ownerinfo->uid    =3D id;
+		*flags |=3D FLAG_UID_OWNER;
+		return true;
+
+	case 'g':
+		check_inverse(optarg, &invert, &optind, 0);
+		if ((grp =3D getgrnam(optarg)) !=3D NULL)
+			ownerinfo->gid =3D grp->gr_gid;
+		else if (string_to_number(optarg, 0, UINT_MAX, &id) < 0)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "bad GID value \"%s\"", optarg);
+		if (invert)
+			ownerinfo->invert |=3D IP6T_OWNER_GID;
+		ownerinfo->match |=3D IP6T_OWNER_GID;
+		ownerinfo->gid    =3D id;
+		*flags |=3D FLAG_GID_OWNER;
+		return true;
+
+	case 'p':
+		check_inverse(optarg, &invert, &optind, 0);
+		if (string_to_number(optarg, 0, UINT_MAX, &id) < 0)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "bad PID value \"%s\"", optarg);
+		if (invert)
+			ownerinfo->invert |=3D IP6T_OWNER_PID;
+		ownerinfo->match |=3D IP6T_OWNER_PID;
+		ownerinfo->pid    =3D id;
+		*flags |=3D FLAG_PID_OWNER;
+		return true;
+
+	case 's':
+		check_inverse(optarg, &invert, &optind, 0);
+		if (string_to_number(optarg, 0, UINT_MAX, &id) < 0)
+			exit_error(PARAMETER_PROBLEM, "owner match: "
+			           "bad SID value \"%s\"", optarg);
+		if (invert)
+			ownerinfo->invert |=3D IP6T_OWNER_SID;
+		ownerinfo->match |=3D IP6T_OWNER_SID;
+		ownerinfo->sid    =3D id;
+		*flags |=3D FLAG_SID_OWNER;
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
+
+	case 'k':
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
+	}
+	return false;
+}
+
+static void owner_mt_check(unsigned int flags)
+{
+	if (flags =3D=3D 0)
+		exit_error(PARAMETER_PROBLEM,
+			   "owner match: One or more parameters are required");
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
+	.family        =3D AF_INET,
+	.revision      =3D 0,
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
+	.family        =3D AF_INET6,
+	.revision      =3D 0,
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
