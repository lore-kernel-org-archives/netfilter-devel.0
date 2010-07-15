From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH iptables-next] extensions: libxt_IDLETIMER: use xtables_param_act when checking options
Date: Thu, 15 Jul 2010 18:05:31 +0300
Message-ID: <1279206331-6921-1-git-send-email-luciano.coelho@nokia.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33394 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453Ab0GOPGG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:06:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch changes custom error messages for illegal options into the
default iptables messages, by using xtables_param_act().

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 extensions/libxt_IDLETIMER.c   |   15 ++++++---------
 extensions/libxt_IDLETIMER.man |    3 ++-
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_IDLETIMER.c b/extensions/libxt_IDLETIMER.c
index 565f8e3..c931d0e 100644
--- a/extensions/libxt_IDLETIMER.c
+++ b/extensions/libxt_IDLETIMER.c
@@ -60,23 +60,20 @@ static int idletimer_tg_parse(int c, char **argv, int invert,
 
 	switch (c) {
 	case 't':
-		if (*flags & IDLETIMER_TG_OPT_TIMEOUT)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Cannot specify timeout more than once");
+		xtables_param_act(XTF_ONLY_ONCE, "IDLETIMER", "--timeout",
+				  *flags & IDLETIMER_TG_OPT_TIMEOUT);
 
 		info->timeout = atoi(optarg);
 		*flags |= IDLETIMER_TG_OPT_TIMEOUT;
 		break;
 
 	case 'l':
-		if (*flags & IDLETIMER_TG_OPT_LABEL)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Cannot specify label more than once");
+		xtables_param_act(XTF_ONLY_ONCE, "IDLETIMER", "--label",
+				  *flags & IDLETIMER_TG_OPT_TIMEOUT);
 
 		if (strlen(optarg) > MAX_IDLETIMER_LABEL_SIZE - 1)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Maximum label length is %u for --label",
-				      MAX_IDLETIMER_LABEL_SIZE - 1);
+			xtables_param_act(XTF_BAD_VALUE, "IDLETIMER", "--label",
+					 optarg);
 
 		strcpy(info->label, optarg);
 		*flags |= IDLETIMER_TG_OPT_LABEL;
diff --git a/extensions/libxt_IDLETIMER.man b/extensions/libxt_IDLETIMER.man
index 3266a44..e3c91ce 100644
--- a/extensions/libxt_IDLETIMER.man
+++ b/extensions/libxt_IDLETIMER.man
@@ -16,4 +16,5 @@ userspace, which can then decide what to do (eg. disconnect to save power).
 This is the time in seconds that will trigger the notification.
 .TP
 \fB\-\-label\fP \fIstring\fP
-This is a unique identifier for the timer.
+This is a unique identifier for the timer.  The maximum length for the
+label string is 27 characters.
-- 
1.7.0.4

