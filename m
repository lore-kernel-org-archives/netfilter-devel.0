From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [PATCH] iptables: libxt_string.man add example
Date: Fri, 23 Aug 2013 02:41:25 -0400
Message-ID: <1377240085-15466-1-git-send-email-ljlane@debian.org>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ankh.ljlane.net ([71.19.149.249]:40617 "EHLO ankh.ljlane.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab3HWGla (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Aug 2013 02:41:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Show delimeters for hex string pattern.

http://bugs.debian.org/699904

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 extensions/libxt_string.man | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index b6b271d..ebea1d3 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -16,3 +16,10 @@ Matches the given pattern.
 .TP
 [\fB!\fP] \fB\-\-hex\-string\fP \fIpattern\fP
 Matches the given pattern in hex notation.
+.TP
+Example:
+.PP
+   Log HTTP GET requests for /test:
+.PP
+   iptables \-A INPUT \-p tcp \-\-dport 80 \-m string \-\-algo bm \-\-string 'GET /test' \-j LOG
+   iptables \-A INPUT \-p tcp \-\-dport 80 \-m string \-\-algo bm \-\-hex\-string '|474554202F74657374|' \-j LOG
-- 
1.8.4.rc3

