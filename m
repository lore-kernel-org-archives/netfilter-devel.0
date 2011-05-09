From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/13] libxt_owner: remove ifdef IPT_COMM_OWNER
Date: Mon,  9 May 2011 11:37:03 +0200
Message-ID: <1304933832-16412-6-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51664 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab1EIJhU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:20 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ever since we keep a copy of the header files anyway, IPT_COMM_OWNER
is always available.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_owner.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 5cc7b7a..f930cf4 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -65,7 +65,6 @@ enum {
 
 static void owner_mt_help_v0(void)
 {
-#ifdef IPT_OWNER_COMM
 	printf(
 "owner match options:\n"
 "[!] --uid-owner userid       Match local UID\n"
@@ -74,15 +73,6 @@ static void owner_mt_help_v0(void)
 "[!] --sid-owner sessionid    Match local SID\n"
 "[!] --cmd-owner name         Match local command name\n"
 "NOTE: PID, SID and command matching are broken on SMP\n");
-#else
-	printf(
-"owner match options:\n"
-"[!] --uid-owner userid       Match local UID\n"
-"[!] --gid-owner groupid      Match local GID\n"
-"[!] --pid-owner processid    Match local PID\n"
-"[!] --sid-owner sessionid    Match local SID\n"
-"NOTE: PID and SID matching are broken on SMP\n");
-#endif /* IPT_OWNER_COMM */
 }
 
 static void owner_mt6_help_v0(void)
@@ -110,9 +100,7 @@ static const struct option owner_mt_opts_v0[] = {
 	{.name = "gid-owner", .has_arg = true, .val = 'g'},
 	{.name = "pid-owner", .has_arg = true, .val = 'p'},
 	{.name = "sid-owner", .has_arg = true, .val = 's'},
-#ifdef IPT_OWNER_COMM
 	{.name = "cmd-owner", .has_arg = true, .val = 'c'},
-#endif
 	XT_GETOPT_TABLEEND,
 };
 
@@ -189,7 +177,6 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		*flags      |= FLAG_SID_OWNER;
 		return true;
 
-#ifdef IPT_OWNER_COMM
 	case 'c':
 		xtables_param_act(XTF_ONLY_ONCE, "owner", "--cmd-owner", *flags & FLAG_COMM);
 		if (strlen(optarg) > sizeof(info->comm))
@@ -205,7 +192,6 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		info->match |= IPT_OWNER_COMM;
 		*flags      |= FLAG_COMM;
 		return true;
-#endif
 	}
 	return false;
 }
@@ -394,11 +380,9 @@ owner_mt_print_item_v0(const struct ipt_owner_info *info, const char *label,
 		printf(" %u", (unsigned int)info->sid);
 		break;
 
-#ifdef IPT_OWNER_COMM
 	case IPT_OWNER_COMM:
 		printf(" %.*s", (int)sizeof(info->comm), info->comm);
 		break;
-#endif
 	}
 }
 
@@ -502,9 +486,7 @@ owner_mt_print_v0(const void *ip, const struct xt_entry_match *match,
 	owner_mt_print_item_v0(info, "owner GID match", IPT_OWNER_GID, numeric);
 	owner_mt_print_item_v0(info, "owner PID match", IPT_OWNER_PID, numeric);
 	owner_mt_print_item_v0(info, "owner SID match", IPT_OWNER_SID, numeric);
-#ifdef IPT_OWNER_COMM
 	owner_mt_print_item_v0(info, "owner CMD match", IPT_OWNER_COMM, numeric);
-#endif
 }
 
 static void
@@ -538,9 +520,7 @@ owner_mt_save_v0(const void *ip, const struct xt_entry_match *match)
 	owner_mt_print_item_v0(info, "--gid-owner", IPT_OWNER_GID, true);
 	owner_mt_print_item_v0(info, "--pid-owner", IPT_OWNER_PID, true);
 	owner_mt_print_item_v0(info, "--sid-owner", IPT_OWNER_SID, true);
-#ifdef IPT_OWNER_COMM
 	owner_mt_print_item_v0(info, "--cmd-owner", IPT_OWNER_COMM, true);
-#endif
 }
 
 static void
-- 
1.7.1

