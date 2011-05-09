From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/13] libxt_statistic: increase precision on create and dump
Date: Mon,  9 May 2011 11:37:07 +0200
Message-ID: <1304933832-16412-10-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51684 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab1EIJhY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:24 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, libxt_statistic only dumps the probability with a
granularity of 1/1000000. Assuming only stuffed packets with 1440
bytes payload, this would match approximately every 1.341 GB, which is
pretty low for a high-volume router. Trying to match any larger
interval than that (e.g. 2 GB) will cause libxt_statistic to output
"--probability 0.000000", and when restored, will cause it to never
match again.

Bump the dump precision to what xt_statistic can really do, and adjust
the manpage to include a word about it.

Furthermore, employ explicit rounding when reading the argument from
the command line, because the previous implicit conversion would use
truncation, which is not very exact.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_statistic.c   |    7 ++++---
 extensions/libxt_statistic.man |    7 +++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index bce83fa..f13cdba 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -1,3 +1,4 @@
+#include <math.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
@@ -62,11 +63,11 @@ statistic_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '2':
 		if (*flags & 0x2)
 			xtables_error(PARAMETER_PROBLEM, "double --probability");
-		prob = atof(optarg);
+		prob = strtod(optarg, NULL);
 		if (prob < 0 || prob > 1)
 			xtables_error(PARAMETER_PROBLEM,
 				   "--probability must be between 0 and 1");
-		info->u.random.probability = 0x80000000 * prob;
+		info->u.random.probability = lround(0x80000000 * prob);
 		*flags |= 0x2;
 		break;
 	case '3':
@@ -127,7 +128,7 @@ static void print_match(const struct xt_statistic_info *info, char *prefix)
 {
 	switch (info->mode) {
 	case XT_STATISTIC_MODE_RANDOM:
-		printf(" %smode random%s %sprobability %f", prefix,
+		printf(" %smode random%s %sprobability %.11f", prefix,
 		       (info->flags & XT_STATISTIC_INVERT) ? " !" : "",
 		       prefix,
 		       1.0 * info->u.random.probability / 0x80000000);
diff --git a/extensions/libxt_statistic.man b/extensions/libxt_statistic.man
index 4947daf..47182bf 100644
--- a/extensions/libxt_statistic.man
+++ b/extensions/libxt_statistic.man
@@ -12,10 +12,9 @@ and
 .B nth. 
 .TP
 [\fB!\fP] \fB\-\-probability\fP \fIp\fP
-Set the probability from 0 to 1 for a packet to be randomly
-matched. It works only with the
-.B random
-mode.
+Set the probability for a packet to be randomly matched. It only works with the
+\fBrandom\fP mode. \fIp\fP must be within 0.0 and 1.0. The supported
+granularity is in 1/2147483648th increments.
 .TP
 [\fB!\fP] \fB\-\-every\fP \fIn\fP
 Match one packet every nth packet. It works only with the
-- 
1.7.1

