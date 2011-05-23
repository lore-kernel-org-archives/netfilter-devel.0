From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/13] doc: make usage of libxt_rateest more obvious
Date: Mon, 23 May 2011 16:39:18 +0200
Message-ID: <1306161564-4370-9-git-send-email-jengelh@medozas.de>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44633 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574Ab1EWOjf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 10:39:35 -0400
In-Reply-To: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_rateest.man |   71 +++++++++++++++++++++++++++++++++---------
 1 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
index 75303c5..42a82f3 100644
--- a/extensions/libxt_rateest.man
+++ b/extensions/libxt_rateest.man
@@ -1,34 +1,75 @@
 The rate estimator can match on estimated rates as collected by the RATEEST
 target. It supports matching on absolute bps/pps values, comparing two rate
 estimators and matching on the difference between two rate estimators.
+.PP
+For a better understanding of the available options, these are all possible
+combinations:
+.\" * Absolute:
+.IP \(bu 4
+\fBrateest\fP \fIoperator\fP \fBrateest-bps\fP
+.IP \(bu 4
+\fBrateest\fP \fIoperator\fP \fBrateest-pps\fP
+.\" * Absolute + Delta:
+.IP \(bu 4
+(\fBrateest\fP minus \fBrateest-bps1\fP) \fIoperator\fP \fBrateest-bps2\fP
+.IP \(bu 4
+(\fBrateest\fP minus \fBrateest-pps1\fP) \fIoperator\fP \fBrateest-pps2\fP
+.\" * Relative:
+.IP \(bu 4
+\fBrateest1\fP \fIoperator\fP \fBrateest2\fP \fBrateest-bps\fP(without rate!)
+.IP \(bu 4
+\fBrateest1\fP \fIoperator\fP \fBrateest2\fP \fBrateest-pps\fP(without rate!)
+.\" * Relative + Delta:
+.IP \(bu 4
+(\fBrateest1\fP minus \fBrateest-bps1\fP) \fIoperator\fP
+(\fBrateest2\fP minus \fBrateest-bps2\fP)
+.IP \(bu 4
+(\fBrateest1\fP minus \fBrateest-pps1\fP) \fIoperator\fP
+(\fBrateest2\fP minus \fBrateest-pps2\fP)
+.TP
+\fB\-\-rateest\-delta\fP
+For each estimator (either absolute or relative mode), calculate the difference
+between the estimator-determined flow rate and the static value chosen with the
+BPS/PPS options. If the flow rate is higher than the specified BPS/PPS, 0 will
+be used instead of a negative value. In other words, "max(0, rateest#_rate -
+rateest#_bps)" is used.
+.TP
+[\fB!\fP] \fB\-\-rateest\-lt\fP
+Match if rate is less than given rate/estimator.
+.TP
+[\fB!\fP] \fB\-\-rateest\-gt\fP
+Match if rate is greater than given rate/estimator.
+.TP
+[\fB!\fP] \fB\-\-rateest\-eq\fP
+Match if rate is equal to given rate/estimator.
+.PP
+In the so-called "absolute mode", only one rate estimator is used and compared
+against a static value, while in "relative mode", two rate estimators are
+compared against another.
+.TP
+\fB\-\-rateest\fP \fIname\fP
+Name of the one rate estimator for absolute mode.
 .TP
 \fB\-\-rateest1\fP \fIname\fP
-Name of the first rate estimator.
 .TP
 \fB\-\-rateest2\fP \fIname\fP
-Name of the second rate estimator (if difference is to be calculated).
+The names of the two rate estimators for relative mode.
 .TP
-\fB\-\-rateest\-delta\fP
-Compare difference(s) to given rate(s)
+\fB\-\-rateest\-bps\fP [\fIvalue\fP]
+.TP
+\fB\-\-rateest\-pps\fP [\fIvalue\fP]
 .TP
 \fB\-\-rateest\-bps1\fP [\fIvalue\fP]
 .TP
 \fB\-\-rateest\-bps2\fP [\fIvalue\fP]
-Compare bytes per second.
 .TP
 \fB\-\-rateest\-pps1\fP [\fIvalue\fP]
 .TP
 \fB\-\-rateest\-pps2\fP [\fIvalue\fP]
-Compare packets per second.
-.TP
-[\fB!\fP] \fB\-\-rateest\-lt\fP
-Match if rate is less than given rate/estimator.
-.TP
-[\fB!\fP] \fB\-\-rateest\-gt\fP
-Match if rate is greater than given rate/estimator.
-.TP
-[\fB!\fP] \fB\-\-rateest\-eq\fP
-Match if rate is equal to given rate/estimator.
+Compare the estimator(s) by bytes or packets per second, and compare against
+the chosen value. See the above bullet list for which option is to be used in
+which case. A unit suffix may be used - available ones are: bit, [kmgt]bit,
+[KMGT]ibit, Bps, [KMGT]Bps, [KMGT]iBps.
 .PP
 Example: This is what can be used to route outgoing data connections from an
 FTP server over two lines based on the available bandwidth at the time the data
-- 
1.7.3.4

