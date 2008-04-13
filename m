From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 6/8] RATEEST: add manpage
Date: Sun, 13 Apr 2008 10:25:52 +0200
Message-ID: <25ede7581c626fa931005642a77d796572f3ff9f.1208075035.git.jengelh@computergmbh.de>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36092 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYDMIZ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:25:57 -0400
In-Reply-To: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <1ef315a194b6db19e54a835a0b7a77ebec71a8c7.1208075035.git.jengelh@computergmbh.de>
References: <1ef315a194b6db19e54a835a0b7a77ebec71a8c7.1208075035.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/libxt_RATEEST.c   |    5 ++---
 extensions/libxt_RATEEST.man |   11 +++++++++++
 2 files changed, 13 insertions(+), 3 deletions(-)
 create mode 100644 extensions/libxt_RATEEST.man

diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index 4f52c2e..dd7b503 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -18,12 +18,11 @@ static void
 RATEEST_help(void)
 {
 	printf(
-"RATEST target v%s options:\n"
+"RATEEST target options:\n"
 "  --rateest-name name		Rate estimator name\n"
 "  --rateest-interval sec	Rate measurement interval in seconds\n"
 "  --rateest-ewmalog value	Rate measurement averaging time constant\n"
-"\n",
-	       IPTABLES_VERSION);
+"\n");
 }
 
 enum RATEEST_options {
diff --git a/extensions/libxt_RATEEST.man b/extensions/libxt_RATEEST.man
new file mode 100644
index 0000000..6ad802c
--- /dev/null
+++ b/extensions/libxt_RATEEST.man
@@ -0,0 +1,11 @@
+The RATEEST target collects statistics, performs rate estimation calculation
+and saves the results for later evaluation using the \fBrateest\fP match.
+.TP
+\fB--rateest-name\fP \fIname\fP
+Count matched packets into the pool referred to by \fIname\fP, which is freely
+choosable.
+.TP
+\fB--rateest-interval\fP \fIamount\fP{\fBs\fP|\fBms\fP|\fBus\fP}
+Rate measurement interval, in seconds, milliseconds or microseconds.
+.TP
+\fB--rateest-ewmalog\fP \fIvalue\fP
-- 
1.5.5.rc3

