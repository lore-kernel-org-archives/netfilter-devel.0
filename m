From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [iptables PATCH] docs: use generic syslog reference in libxt_LOG.man
Date: Fri,  6 Sep 2013 17:46:00 -0400
Message-ID: <1378503960-16261-1-git-send-email-ljlane@debian.org>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ankh.ljlane.net ([71.19.149.249]:46606 "EHLO ankh.ljlane.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab3IFVqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:46:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fedora, ArchLinux, Ubuntu, and Debian, at the least, use
alternative syslog daemons by default these days. Let's make
the syslog reference generic.

Reference: http://bugs.debian.org/567564

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 extensions/libxt_LOG.man | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_LOG.man b/extensions/libxt_LOG.man
index 6d3a83a..354edf4 100644
--- a/extensions/libxt_LOG.man
+++ b/extensions/libxt_LOG.man
@@ -1,10 +1,8 @@
 Turn on kernel logging of matching packets.  When this option is set
 for a rule, the Linux kernel will print some information on all
 matching packets (like most IP/IPv6 header fields) via the kernel log
-(where it can be read with
-.I dmesg
-or
-.IR syslogd (8)).
+(where it can be read with \fIdmesg(1)\fP or read in the syslog).
+.PP
 This is a "non-terminating target", i.e. rule traversal continues at
 the next rule.  So if you want to LOG the packets you refuse, use two
 separate rules with the same matching criteria, first using target LOG
-- 
1.8.4.rc3

