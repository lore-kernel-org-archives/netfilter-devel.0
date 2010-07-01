From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH] extensions: libxt_rateest: fix typo in the man page
Date: Thu,  1 Jul 2010 14:58:10 +0300
Message-ID: <1277985490-26117-1-git-send-email-luciano.coelho@nokia.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:53236 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0GAL6c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:58:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There were a few typos in some options in the rateest match section of the
man page: --rateest1-bps should be --rateest-bps1 and so on.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 extensions/libxt_rateest.man |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
index 24c0673..de064af 100644
--- a/extensions/libxt_rateest.man
+++ b/extensions/libxt_rateest.man
@@ -11,14 +11,14 @@ Name of the second rate estimator (if difference is to be calculated).
 \fB\-\-rateest\-delta\fP
 Compare difference(s) to given rate(s)
 .TP
-\fB\-\-rateest1\-bps\fP \fIvalue\fP
+\fB\-\-rateest\-bps1\fP \fIvalue\fP
 .TP
-\fB\-\-rateest2\-bps\fP \fIvalue\fP
+\fB\-\-rateest\-bps2\fP \fIvalue\fP
 Compare bytes per second.
 .TP
-\fB\-\-rateest1\-pps\fP \fIvalue\fP
+\fB\-\-rateest\-pps1\fP \fIvalue\fP
 .TP
-\fB\-\-rateest2\-pps\fP \fIvalue\fP
+\fB\-\-rateest\-pps2\fP \fIvalue\fP
 Compare packets per second.
 .TP
 [\fB!\fP] \fB\-\-rateest\-lt\fP
-- 
1.7.0.4

