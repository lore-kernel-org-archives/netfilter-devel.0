From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [PATCH] iptables: libxt_recent.{c,man} dead URL
Date: Fri, 23 Aug 2013 16:55:55 -0400
Message-ID: <1377291355-17515-1-git-send-email-ljlane@debian.org>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ankh.ljlane.net ([71.19.149.249]:40660 "EHLO ankh.ljlane.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab3HWUz5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:55:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove it.

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 extensions/libxt_recent.c   | 2 +-
 extensions/libxt_recent.man | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index b3510d9..e1801f1 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -104,7 +104,7 @@ static void recent_help(void)
 "    --rsource                   Match/Save the source address of each packet in the recent list table (default).\n"
 "    --rdest                     Match/Save the destination address of each packet in the recent list table.\n"
 "    --mask netmask              Netmask that will be applied to this recent list.\n"
-"xt_recent by: Stephen Frost <sfrost@snowman.net>.  http://snowman.net/projects/ipt_recent/\n");
+"xt_recent by: Stephen Frost <sfrost@snowman.net>.\n");
 }
 
 enum {
diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index d9bd5d2..419be25 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -73,9 +73,6 @@ iptables \-A FORWARD \-m recent \-\-name badguy \-\-rcheck \-\-seconds 60 \-j DR
 .IP
 iptables \-A FORWARD \-p tcp \-i eth0 \-\-dport 139 \-m recent \-\-name badguy \-\-set \-j DROP
 .PP
-Steve's ipt_recent website (http://snowman.net/projects/ipt_recent/) also has
-some examples of usage.
-.PP
 \fB/proc/net/xt_recent/*\fP are the current lists of addresses and information
 about each entry of each list.
 .PP
-- 
1.8.4.rc3

