From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [PATCH] iptables: libxt_hashlimit.man: correct address
Date: Sat, 17 Aug 2013 19:08:59 -0400
Message-ID: <1376780939-12394-1-git-send-email-ljlane@debian.org>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dunimos.ljlane.net ([216.218.223.72]:44298 "EHLO
	dunimos.ljlane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3HQXJO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Aug 2013 19:09:14 -0400
Received: from localhost (localhost [127.0.0.1])
	by dunimos.ljlane.net (Postfix) with SMTP id 91DCA37A48
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Aug 2013 19:09:12 -0400 (EDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Corrects an example address with subnet mask.

http://bugs.debian.org/698393

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 extensions/libxt_hashlimit.man | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index 17cb2b0..6aac3f2 100644
--- a/extensions/libxt_hashlimit.man
+++ b/extensions/libxt_hashlimit.man
@@ -65,7 +65,7 @@ matching on source port
 matching on subnet
 "10000 packets per minute for every /28 subnet (groups of 8 addresses)
 in 10.0.0.0/8" =>
-\-s 10.0.0.8 \-\-hashlimit\-mask 28 \-\-hashlimit\-upto 10000/min
+\-s 10.0.0.0/8 \-\-hashlimit\-mask 28 \-\-hashlimit\-upto 10000/min
 .TP
 matching bytes per second
 "flows exceeding 512kbyte/s" =>
-- 
1.8.4.rc2


!DSPAM:5210029814261079811937!


