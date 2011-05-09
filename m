From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/13] libxt_statistic: streamline and document possible placement of negation
Date: Mon,  9 May 2011 11:37:06 +0200
Message-ID: <1304933832-16412-9-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51681 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1EIJhY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:24 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_statistic.c   |   15 ++++++++-------
 extensions/libxt_statistic.man |    4 ++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index b4171b1..bce83fa 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -15,9 +15,9 @@ static void statistic_help(void)
 "statistic match options:\n"
 " --mode mode                    Match mode (random, nth)\n"
 " random mode:\n"
-" --probability p		 Probability\n"
+"[!] --probability p		 Probability\n"
 " nth mode:\n"
-" --every n			 Match every nth packet\n"
+"[!] --every n			 Match every nth packet\n"
 " --packet p			 Initial counter value (0 <= p <= n-1, default 0)\n");
 }
 
@@ -125,16 +125,17 @@ static void statistic_check(unsigned int flags)
 
 static void print_match(const struct xt_statistic_info *info, char *prefix)
 {
-	if (info->flags & XT_STATISTIC_INVERT)
-		printf(" !");
-
 	switch (info->mode) {
 	case XT_STATISTIC_MODE_RANDOM:
-		printf( "%smode random %sprobability %f", prefix, prefix,
+		printf(" %smode random%s %sprobability %f", prefix,
+		       (info->flags & XT_STATISTIC_INVERT) ? " !" : "",
+		       prefix,
 		       1.0 * info->u.random.probability / 0x80000000);
 		break;
 	case XT_STATISTIC_MODE_NTH:
-		printf(" %smode nth %severy %u", prefix, prefix,
+		printf(" %smode nth%s %severy %u", prefix,
+		       (info->flags & XT_STATISTIC_INVERT) ? " !" : "",
+		       prefix,
 		       info->u.nth.every + 1);
 		if (info->u.nth.packet)
 			printf(" %spacket %u", prefix, info->u.nth.packet);
diff --git a/extensions/libxt_statistic.man b/extensions/libxt_statistic.man
index 8fc3b29..4947daf 100644
--- a/extensions/libxt_statistic.man
+++ b/extensions/libxt_statistic.man
@@ -11,13 +11,13 @@ Set the matching mode of the matching rule, supported modes are
 and
 .B nth. 
 .TP
-\fB\-\-probability\fP \fIp\fP
+[\fB!\fP] \fB\-\-probability\fP \fIp\fP
 Set the probability from 0 to 1 for a packet to be randomly
 matched. It works only with the
 .B random
 mode.
 .TP
-\fB\-\-every\fP \fIn\fP
+[\fB!\fP] \fB\-\-every\fP \fIn\fP
 Match one packet every nth packet. It works only with the
 .B nth
 mode (see also the 
-- 
1.7.1

