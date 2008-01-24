From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [IPTABLES]: libxt_owner: UID/GID range support
Date: Fri, 25 Jan 2008 00:41:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801250040460.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41602 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbYAXXln (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:41:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

UID/GID range support for libxt_owner

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libxt_owner.c           |   68 +++++++++++++++++++++++++------------
 include/linux/netfilter/xt_owner.h |    4 +-
 2 files changed, 49 insertions(+), 23 deletions(-)

Index: iptables/extensions/libxt_owner.c
===================================================================
--- iptables.orig/extensions/libxt_owner.c
+++ iptables/extensions/libxt_owner.c
@@ -67,9 +67,9 @@ static void owner_mt_help(void)
 {
 	printf(
 "owner match options:\n"
-"[!] --uid-owner userid     Match local UID\n"
-"[!] --gid-owner groupid    Match local GID\n"
-"[!] --socket-exists        Match if socket exists\n"
+"[!] --uid-owner userid[-userid]      Match local UID\n"
+"[!] --gid-owner groupid[-groupid]    Match local GID\n"
+"[!] --socket-exists                  Match if socket exists\n"
 "\n");
 }
 
@@ -243,40 +243,58 @@ owner_mt6_parse_v0(int c, char **argv, i
 	return false;
 }
 
+static void owner_parse_range(const char *s, unsigned int *from,
+                              unsigned int *to, const char *opt)
+{
+	char *end;
+
+	/* 4294967295 is reserved, so subtract one from ~0 */
+	if (!strtonum(s, &end, from, 0, (~(uid_t)0) - 1))
+		param_act(P_BAD_VALUE, "owner", opt, s);
+	*to = *from;
+	if (*end == '-' || *end == ':')
+		if (!strtonum(end + 1, &end, to, 0, (~(uid_t)0) - 1))
+			param_act(P_BAD_VALUE, "owner", opt, s);
+	if (*end != '\0')
+		param_act(P_BAD_VALUE, "owner", opt, s);
+}
+
 static int owner_mt_parse(int c, char **argv, int invert, unsigned int *flags,
                           const void *entry, struct xt_entry_match **match)
 {
 	struct xt_owner_match_info *info = (void *)(*match)->data;
 	struct passwd *pwd;
 	struct group *grp;
-	unsigned int id;
+	unsigned int from, to;
 
 	switch (c) {
 	case 'u':
 		param_act(P_ONLY_ONCE, "owner", "--uid-owner",
 		          *flags & FLAG_UID_OWNER);
 		if ((pwd = getpwnam(optarg)) != NULL)
-			id = pwd->pw_uid;
-		else if (!strtonum(optarg, NULL, &id, 0, ~(uid_t)0))
-			param_act(P_BAD_VALUE, "owner", "--uid-owner", optarg);
+			from = to = pwd->pw_uid;
+		else
+			owner_parse_range(optarg, &from, &to, "--uid-owner");
 		if (invert)
 			info->invert |= XT_OWNER_UID;
-		info->match |= XT_OWNER_UID;
-		info->uid    = id;
-		*flags      |= FLAG_UID_OWNER;
+		info->match  |= XT_OWNER_UID;
+		info->uid_min = from;
+		info->uid_max = to;
+		*flags       |= FLAG_UID_OWNER;
 		return true;
 
 	case 'g':
 		param_act(P_ONLY_ONCE, "owner", "--gid-owner",
 		          *flags & FLAG_GID_OWNER);
 		if ((grp = getgrnam(optarg)) != NULL)
-			id = grp->gr_gid;
-		else if (!strtonum(optarg, NULL, &id, 0, ~(gid_t)0))
-			param_act(P_BAD_VALUE, "owner", "--gid-owner", optarg);
+			from = to = grp->gr_gid;
+		else
+			owner_parse_range(optarg, &from, &to, "--gid-owner");
 		if (invert)
 			info->invert |= XT_OWNER_GID;
-		info->match |= XT_OWNER_GID;
-		info->gid    = id;
+		info->match  |= XT_OWNER_GID;
+		info->gid_min = from;
+		info->gid_max = to;
 		*flags      |= FLAG_GID_OWNER;
 		return true;
 
@@ -409,27 +427,35 @@ owner_mt_print_item(const struct xt_owne
 
 	switch (info->match & flag) {
 	case XT_OWNER_UID:
-		if (!numeric) {
-			const struct passwd *pwd = getpwuid(info->uid);
+		if (info->uid_min != info->uid_max) {
+			printf("%u-%u ", (unsigned int)info->uid_min,
+			       (unsigned int)info->uid_max);
+			break;
+		} else if (!numeric) {
+			const struct passwd *pwd = getpwuid(info->uid_min);
 
 			if (pwd != NULL && pwd->pw_name != NULL) {
 				printf("%s ", pwd->pw_name);
 				break;
 			}
 		}
-		printf("%u ", (unsigned int)info->uid);
+		printf("%u ", (unsigned int)info->uid_min);
 		break;
 
 	case XT_OWNER_GID:
-		if (!numeric) {
-			const struct group *grp = getgrgid(info->gid);
+		if (info->gid_min != info->gid_max) {
+			printf("%u-%u ", (unsigned int)info->gid_min,
+			       (unsigned int)info->gid_max);
+			break;
+		} else if (!numeric) {
+			const struct group *grp = getgrgid(info->gid_min);
 
 			if (grp != NULL && grp->gr_name != NULL) {
 				printf("%s ", grp->gr_name);
 				break;
 			}
 		}
-		printf("%u ", (unsigned int)info->gid);
+		printf("%u ", (unsigned int)info->gid_min);
 		break;
 	}
 }
Index: iptables/include/linux/netfilter/xt_owner.h
===================================================================
--- iptables.orig/include/linux/netfilter/xt_owner.h
+++ iptables/include/linux/netfilter/xt_owner.h
@@ -8,8 +8,8 @@ enum {
 };
 
 struct xt_owner_match_info {
-	u_int32_t uid;
-	u_int32_t gid;
+	u_int32_t uid_min, uid_max;
+	u_int32_t gid_min, gid_max;
 	u_int8_t match, invert;
 };
 
