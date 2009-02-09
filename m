From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/16] libxt_owner: use correct UID/GID boundaries
Date: Mon,  9 Feb 2009 18:34:47 +0100
Message-ID: <1234200900-5964-4-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51463 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbZBIRfC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:02 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-1 is a reserved number (chown uses it to denote "do not change"),
so the maximum libxt_owner should permit is up to UINT32_MAX-1.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_owner.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 4cd173e..c8677a8 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -110,7 +110,7 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "owner", "--uid-owner", *flags & FLAG_UID_OWNER);
 		if ((pwd = getpwnam(optarg)) != NULL)
 			id = pwd->pw_uid;
-		else if (!strtonum(optarg, NULL, &id, 0, ~(uid_t)0))
+		else if (!strtonum(optarg, NULL, &id, 0, UINT32_MAX - 1))
 			param_act(P_BAD_VALUE, "owner", "--uid-owner", optarg);
 		if (invert)
 			info->invert |= IPT_OWNER_UID;
@@ -123,7 +123,7 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "owner", "--gid-owner", *flags & FLAG_GID_OWNER);
 		if ((grp = getgrnam(optarg)) != NULL)
 			id = grp->gr_gid;
-		else if (!strtonum(optarg, NULL, &id, 0, ~(gid_t)0))
+		else if (!strtonum(optarg, NULL, &id, 0, UINT32_MAX - 1))
 			param_act(P_BAD_VALUE, "owner", "--gid-owner", optarg);
 		if (invert)
 			info->invert |= IPT_OWNER_GID;
@@ -190,7 +190,7 @@ owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		          *flags & FLAG_UID_OWNER);
 		if ((pwd = getpwnam(optarg)) != NULL)
 			id = pwd->pw_uid;
-		else if (!strtonum(optarg, NULL, &id, 0, ~(uid_t)0))
+		else if (!strtonum(optarg, NULL, &id, 0, UINT32_MAX - 1))
 			param_act(P_BAD_VALUE, "owner", "--uid-owner", optarg);
 		if (invert)
 			info->invert |= IP6T_OWNER_UID;
@@ -204,7 +204,7 @@ owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		          *flags & FLAG_GID_OWNER);
 		if ((grp = getgrnam(optarg)) != NULL)
 			id = grp->gr_gid;
-		else if (!strtonum(optarg, NULL, &id, 0, ~(gid_t)0))
+		else if (!strtonum(optarg, NULL, &id, 0, UINT32_MAX - 1))
 			param_act(P_BAD_VALUE, "owner", "--gid-owner", optarg);
 		if (invert)
 			info->invert |= IP6T_OWNER_GID;
@@ -245,12 +245,12 @@ static void owner_parse_range(const char *s, unsigned int *from,
 {
 	char *end;
 
-	/* 4294967295 is reserved, so subtract one from ~0 */
-	if (!strtonum(s, &end, from, 0, (~(uid_t)0) - 1))
+	/* -1 is reversed, so the max is one less than that. */
+	if (!strtonum(s, &end, from, 0, UINT32_MAX - 1))
 		param_act(P_BAD_VALUE, "owner", opt, s);
 	*to = *from;
 	if (*end == '-' || *end == ':')
-		if (!strtonum(end + 1, &end, to, 0, (~(uid_t)0) - 1))
+		if (!strtonum(end + 1, &end, to, 0, UINT32_MAX - 1))
 			param_act(P_BAD_VALUE, "owner", opt, s);
 	if (*end != '\0')
 		param_act(P_BAD_VALUE, "owner", opt, s);
-- 
1.6.1.2

