From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [PATCH v2] iptables: libxt_string.man add example
Date: Fri, 23 Aug 2013 16:55:22 -0400
Message-ID: <1377291322-17456-1-git-send-email-ljlane@debian.org>
References: <CA+0KVf1g3KXXkFDDpWq3YVGRQKU7Wat+gEiuE6x-9ozka2vdyA@mail.gmail.com>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ankh.ljlane.net ([71.19.149.249]:40658 "EHLO ankh.ljlane.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799Ab3HWUzf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:55:35 -0400
In-Reply-To: <CA+0KVf1g3KXXkFDDpWq3YVGRQKU7Wat+gEiuE6x-9ozka2vdyA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Show use of hex pattern delimeters.

http://bugs.debian.org/699904

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 extensions/libxt_string.man | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index b6b271d..ab395b2 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -16,3 +16,9 @@ Matches the given pattern.
 .TP
 [\fB!\fP] \fB\-\-hex\-string\fP \fIpattern\fP
 Matches the given pattern in hex notation.
+.TP
+Example: log HTTP GET requests for /test using string and hex string patterns
+.IP
+iptables \-A INPUT \-p tcp \-\-dport 80 \-m string \-\-algo bm \-\-string 'GET /test' \-j LOG
+.IP
+iptables \-A INPUT \-p tcp \-\-dport 80 \-m string \-\-algo bm \-\-hex\-string '|474554202F74657374|' \-j LOG
-- 
1.8.4.rc3

