From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/9] doc: rateest options can be optional
Date: Sun, 27 Feb 2011 02:31:14 +0100
Message-ID: <1298770280-7652-5-git-send-email-jengelh@medozas.de>
References: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52519 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1B0Bbb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 20:31:31 -0500
In-Reply-To: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_rateest.man |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
index de064af..75303c5 100644
--- a/extensions/libxt_rateest.man
+++ b/extensions/libxt_rateest.man
@@ -11,14 +11,14 @@ Name of the second rate estimator (if difference is to be calculated).
 \fB\-\-rateest\-delta\fP
 Compare difference(s) to given rate(s)
 .TP
-\fB\-\-rateest\-bps1\fP \fIvalue\fP
+\fB\-\-rateest\-bps1\fP [\fIvalue\fP]
 .TP
-\fB\-\-rateest\-bps2\fP \fIvalue\fP
+\fB\-\-rateest\-bps2\fP [\fIvalue\fP]
 Compare bytes per second.
 .TP
-\fB\-\-rateest\-pps1\fP \fIvalue\fP
+\fB\-\-rateest\-pps1\fP [\fIvalue\fP]
 .TP
-\fB\-\-rateest\-pps2\fP \fIvalue\fP
+\fB\-\-rateest\-pps2\fP [\fIvalue\fP]
 Compare packets per second.
 .TP
 [\fB!\fP] \fB\-\-rateest\-lt\fP
-- 
1.7.1

