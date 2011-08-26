From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] libxt_string: escape the escaping char too
Date: Fri, 26 Aug 2011 15:15:14 +0200
Message-ID: <1314364516-7875-5-git-send-email-jengelh@medozas.de>
References: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41491 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab1HZNR6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:17:58 -0400
In-Reply-To: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugzilla.netfilter.org/show_bug.cgi?id=740
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_string.c |    2 +-
 tests/options-most.rules  |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 472035f..fb15980 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -242,7 +242,7 @@ print_string(const char *str, const unsigned short int len)
 	unsigned int i;
 	printf(" \"");
 	for (i=0; i < len; i++) {
-		if (str[i] == '\"')  /* escape any embedded quotes */
+		if (str[i] == '\"' || str[i] == '\\')
 			putchar('\\');
 		printf("%c", (unsigned char) str[i]);
 	}
diff --git a/tests/options-most.rules b/tests/options-most.rules
index e54eb12..ae28b82 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -128,6 +128,10 @@
 -A matches
 -A matches -m statistic --mode nth ! --every 5 --packet 2
 -A matches
+-A matches -m string --hex-string "action=|5C22|http|3A|" --algo bm
+-A matches
+-A matches -m string --hex-string "action=|5C|http|3A|" --algo bm
+-A matches
 -A matches -m time --timestart 01:02:03 --timestop 04:05:06 --monthdays 1,2,3,4,5 --weekdays Mon,Fri,Sun --datestart 2001-02-03T04:05:06 --datestop 2012-09-08T09:06:05 --localtz
 -A matches
 -A matches -m time --timestart 01:02:03 --timestop 04:05:06 --monthdays 1,2,3,4,5 --weekdays Mon,Fri,Sun --datestart 2001-02-03T04:05:06 --datestop 2012-09-08T09:06:05 --kerneltz
-- 
1.7.3.4

