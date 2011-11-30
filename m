From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH] iptables: libxt_recent: Add support for --reap option
Date: Wed, 30 Nov 2011 11:44:54 -0700
Message-ID: <1322678694-23472-1-git-send-email-tim.gardner@canonical.com>
Cc: Tim Gardner <tim.gardner@canonical.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1793 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1K3TTi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:19:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support for the reap option was merged in the kernel as of 2.6.35.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 extensions/libxt_recent.c   |   15 +++++++++++++++
 extensions/libxt_recent.man |    4 ++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 1e1a111..a81375d 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -10,6 +10,7 @@ enum {
 	O_UPDATE,
 	O_REMOVE,
 	O_SECONDS,
+	O_REAP,
 	O_HITCOUNT,
 	O_RTTL,
 	O_NAME,
@@ -34,6 +35,7 @@ static const struct xt_option_entry recent_opts[] = {
 	 .excl = F_ANY_OP, .flags = XTOPT_INVERT},
 	{.name = "seconds", .id = O_SECONDS, .type = XTTYPE_UINT32,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, seconds)},
+	{.name = "reap", .id = O_REAP, .type = XTTYPE_NONE},
 	{.name = "hitcount", .id = O_HITCOUNT, .type = XTTYPE_UINT32,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, hit_count)},
 	{.name = "rttl", .id = O_RTTL, .type = XTTYPE_NONE,
@@ -57,6 +59,8 @@ static void recent_help(void)
 "    --seconds seconds           For check and update commands above.\n"
 "                                Specifies that the match will only occur if source address last seen within\n"
 "                                the last 'seconds' seconds.\n"
+"    --reap                      Purge entries older then 'seconds'.\n"
+"                                Can only be used in conjunction with the seconds option.\n"
 "    --hitcount hits             For check and update commands above.\n"
 "                                Specifies that the match will only occur if source address seen hits times.\n"
 "                                May be used in conjunction with the seconds option.\n"
@@ -117,15 +121,24 @@ static void recent_parse(struct xt_option_call *cb)
 	case O_RDEST:
 		info->side = XT_RECENT_DEST;
 		break;
+	case O_REAP:
+		info->check_set |= XT_RECENT_REAP;
+		break;
 	}
 }
 
 static void recent_check(struct xt_fcheck_call *cb)
 {
+	struct xt_recent_mtinfo *info = cb->data;
+
 	if (!(cb->xflags & F_ANY_OP))
 		xtables_error(PARAMETER_PROBLEM,
 			"recent: you must specify one of `--set', `--rcheck' "
 			"`--update' or `--remove'");
+
+	if ((info->check_set & XT_RECENT_REAP) && !info->seconds)
+		xtables_error(PARAMETER_PROBLEM,
+			"recent: you must specify `--seconds' with `--reap'");
 }
 
 static void recent_print(const void *ip, const struct xt_entry_match *match,
@@ -146,6 +159,7 @@ static void recent_print(const void *ip, const struct xt_entry_match *match,
 	if (info->check_set & XT_RECENT_REMOVE)
 		printf(" REMOVE");
 	if(info->seconds) printf(" seconds: %d", info->seconds);
+	if(info->check_set & XT_RECENT_REAP) printf(" reap");
 	if(info->hit_count) printf(" hit_count: %d", info->hit_count);
 	if (info->check_set & XT_RECENT_TTL)
 		printf(" TTL-Match");
@@ -172,6 +186,7 @@ static void recent_save(const void *ip, const struct xt_entry_match *match)
 	if (info->check_set & XT_RECENT_REMOVE)
 		printf(" --remove");
 	if(info->seconds) printf(" --seconds %d", info->seconds);
+	if(info->check_set & XT_RECENT_REAP) printf(" --reap");
 	if(info->hit_count) printf(" --hitcount %d", info->hit_count);
 	if (info->check_set & XT_RECENT_TTL)
 		printf(" --rttl");
diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 0392c2c..0d57e33 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -41,6 +41,10 @@ This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 \fB\-\-update\fP. When used, this will narrow the match to only happen when the
 address is in the list and was seen within the last given number of seconds.
 .TP
+\fB\-\-reap\fP \fIreap\fP
+This option can only be used in conjunction with \fB\-\-seconds\fP.
+When used, this will cause entries older then 'seconds' to be purged.
+.TP
 \fB\-\-hitcount\fP \fIhits\fP
 This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 \fB\-\-update\fP. When used, this will narrow the match to only happen when the
-- 
1.7.0.4

