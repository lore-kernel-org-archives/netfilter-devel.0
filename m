From: timg@tpi.com (Tim Gardner)
Subject: iptables pull request, Added --reap switch logic and man page update
Date: Wed,  3 Mar 2010 14:08:19 -0700 (MST)
Message-ID: <20100303210819.30257F897F@sepang.rtg.net>
Cc: coreteam@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3667 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab0CCVIa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:08:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This pull request is somewhat dependent on acceptence of the patch in

http://www.spinics.net/lists/netfilter-devel/msg12072.html

After all, it doesn't make sense until the kernel has support for --reap.

------------------------

The following changes since commit cf7e42ffbb624c27591f6d55606bdccd358c7785:
  Patrick McHardy (1):
        iptables 1.4.7

are available in the git repository at:

  git://kernel.ubuntu.com/rtg/iptables xt_recent

Tim Gardner (1):
      xt_recent: Added XT_REAP logic and man page documentation

 extensions/libxt_recent.c           |   20 ++++++++++++++++++++
 extensions/libxt_recent.man         |    5 +++++
 include/linux/netfilter/xt_recent.h |    4 ++++
 3 files changed, 29 insertions(+), 0 deletions(-)

>From e7e41cc2a0cb742d5bfd45c93be732f2351a372b Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Mon, 1 Mar 2010 19:00:29 -0700
Subject: [PATCH] xt_recent: Added XT_REAP logic and man page documentation

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 extensions/libxt_recent.c           |   20 ++++++++++++++++++++
 extensions/libxt_recent.man         |    5 +++++
 include/linux/netfilter/xt_recent.h |    4 ++++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 4ac32f7..7e3d280 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -19,6 +19,7 @@ static const struct option recent_opts[] = {
 	{ .name = "name",     .has_arg = 1, .val = 208 },
 	{ .name = "rsource",  .has_arg = 0, .val = 209 },
 	{ .name = "rdest",    .has_arg = 0, .val = 210 },
+	{ .name = "reap",     .has_arg = 0, .val = 211 },
 	{ .name = NULL }
 };
 
@@ -36,6 +37,7 @@ static void recent_help(void)
 "    --hitcount hits             For check and update commands above.\n"
 "                                Specifies that the match will only occur if source address seen hits times.\n"
 "                                May be used in conjunction with the seconds option.\n"
+"    --reap                      Remove entries that have expired. Can only be used with --seconds\n"
 "    --rttl                      For check and update commands above.\n"
 "                                Specifies that the match will only occur if the source address and the TTL\n"
 "                                match between this packet and the one which was set.\n"
@@ -62,6 +64,8 @@ static void recent_init(struct xt_entry_match *match)
 	(XT_RECENT_SET | XT_RECENT_CHECK | \
 	XT_RECENT_UPDATE | XT_RECENT_REMOVE)
 
+#define XT_RECENT_SECONDS 1 << 31
+
 static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
@@ -103,6 +107,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		case 204:
 			info->seconds = atoi(optarg);
+			*flags |= XT_RECENT_SECONDS;
 			break;
 
 		case 205:
@@ -138,6 +143,11 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 			info->side = XT_RECENT_DEST;
 			break;
 
+		case 211:
+			info->check_set |= XT_RECENT_REAP;
+			*flags |= XT_RECENT_REAP;
+			break;
+
 		default:
 			return 0;
 	}
@@ -156,6 +166,12 @@ static void recent_check(unsigned int flags)
 		xtables_error(PARAMETER_PROBLEM,
 		           "recent: --rttl may only be used with --rcheck or "
 		           "--update");
+	if ((flags & XT_RECENT_REAP) &&
+	    ((flags & (XT_RECENT_SET | XT_RECENT_REMOVE)) ||
+	    (!(flags & XT_RECENT_SECONDS))))
+		xtables_error(PARAMETER_PROBLEM,
+		           "recent: --reap may only be used with --rcheck or "
+		           "--update and --seconds");
 }
 
 static void recent_print(const void *ip, const struct xt_entry_match *match,
@@ -184,6 +200,8 @@ static void recent_print(const void *ip, const struct xt_entry_match *match,
 		printf("side: source ");
 	if (info->side == XT_RECENT_DEST)
 		printf("side: dest");
+	if (info->check_set & XT_RECENT_REAP)
+		printf("reap ");
 }
 
 static void recent_save(const void *ip, const struct xt_entry_match *match)
@@ -210,6 +228,8 @@ static void recent_save(const void *ip, const struct xt_entry_match *match)
 		printf("--rsource ");
 	if (info->side == XT_RECENT_DEST)
 		printf("--rdest ");
+	if (info->check_set & XT_RECENT_REAP)
+		printf("--reap ");
 }
 
 static struct xtables_match recent_mt_reg = {
diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 532c328..26e4fb9 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -41,6 +41,11 @@ This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 \fB\-\-update\fP. When used, this will narrow the match to only happen when the
 address is in the list and was seen within the last given number of seconds.
 .TP
+\fB\-\-reap\fP \fIreap\fP
+This option must be used in conjunction with \fB\-\-seconds\fP. When used, this
+will remove entries with the most recent timestamp older then \fB\-\-seconds\fP
+since the last packet was received.
+.TP
 \fB\-\-hitcount\fP \fIhits\fP
 This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 \fB\-\-update\fP. When used, this will narrow the match to only happen when the
diff --git a/include/linux/netfilter/xt_recent.h b/include/linux/netfilter/xt_recent.h
index d2c2766..bba990e 100644
--- a/include/linux/netfilter/xt_recent.h
+++ b/include/linux/netfilter/xt_recent.h
@@ -9,6 +9,7 @@ enum {
 	XT_RECENT_UPDATE   = 1 << 2,
 	XT_RECENT_REMOVE   = 1 << 3,
 	XT_RECENT_TTL      = 1 << 4,
+	XT_RECENT_REAP     = 1 << 5,
 
 	XT_RECENT_SOURCE   = 0,
 	XT_RECENT_DEST     = 1,
@@ -16,6 +17,9 @@ enum {
 	XT_RECENT_NAME_LEN = 200,
 };
 
+/* Only allowed with --rcheck and --update */
+#define XT_RECENT_MODIFIERS (XT_RECENT_TTL|XT_RECENT_REAP)
+
 struct xt_recent_mtinfo {
 	__u32 seconds;
 	__u32 hit_count;
-- 
1.7.0

