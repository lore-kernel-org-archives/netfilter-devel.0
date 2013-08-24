From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [PATCH v4] iptables: libxt_string.man add examples
Date: Sat, 24 Aug 2013 17:44:35 -0400
Message-ID: <1377380675-21440-1-git-send-email-ljlane@debian.org>
References: <1377380275-21297-1-git-send-email-ljlane@debian.org>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ankh.ljlane.net ([71.19.149.249]:40769 "EHLO ankh.ljlane.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab3HXVoj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Aug 2013 17:44:39 -0400
In-Reply-To: <1377380275-21297-1-git-send-email-ljlane@debian.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add usage examples for string and hex string patterns.

Reference: http://bugs.debian.org/699904
Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 extensions/libxt_string.man | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index b6b271d..78cfafb 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -16,3 +16,13 @@ Matches the given pattern.
 .TP
 [\fB!\fP] \fB\-\-hex\-string\fP \fIpattern\fP
 Matches the given pattern in hex notation.
+.TP
+Examples:
+.IP
+# The string pattern can be used for simple text characaters.
+.br
+iptables \-A INPUT \-p tcp \-\-dport 80 \-m string \-\-algo bm \-\-string 'GET /index.html' \-j LOG
+.IP
+# The hex string pattern can be used for non-printable characaters, like |0D 0A| or |0D0A|.
+.br
+iptables \-p udp \-\-dport 53 \-m string \-\-algo bm \-\-from 40 \-\-to 57 \-\-hex\-string '|03|www|09|netfilter|03|org|00|'  \-j LOG
-- 
1.8.4.rc3

