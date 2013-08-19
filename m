From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [PATCH] iptables: iptables-xm1.1 correct man section
Date: Mon, 19 Aug 2013 12:54:35 -0400
Message-ID: <1376931275-10763-1-git-send-email-ljlane@debian.org>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dunimos.ljlane.net ([216.218.223.72]:44772 "EHLO
	dunimos.ljlane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3HSQyr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:54:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Laurence J. Lane" <ljlane@debian.org>

iptables-xml.8 was moved to iptables-xm1.1.

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 iptables/iptables-xml.1 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/iptables-xml.1 b/iptables/iptables-xml.1
index 048c2cb..70b2c1f 100644
--- a/iptables/iptables-xml.1
+++ b/iptables/iptables-xml.1
@@ -1,4 +1,4 @@
-.TH IPTABLES-XML 8 "Jul 16, 2007" "" ""
+.TH IPTABLES-XML 1 "Jul 16, 2007" "" ""
 .\"
 .\" Man page written by Sam Liddicott <azez@ufomechanic.net>
 .\" It is based on the iptables-save man page.
-- 
1.8.1.2

