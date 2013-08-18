From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [PATCH] iptables: libip(6)t_REJECT.man default icmp types
Date: Sun, 18 Aug 2013 19:41:40 -0400
Message-ID: <1376869300-9146-1-git-send-email-ljlane@debian.org>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dunimos.ljlane.net ([216.218.223.72]:44604 "EHLO
	dunimos.ljlane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab3HRXlu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Aug 2013 19:41:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Laurence J. Lane" <ljlane@debian.org>

The extension man page shows "port-unreach" and "port-unreachable" as
default icmpi6 and icomp reject-with types. Either and variations work
fine for writing rules, but they are displayed as "icmp6-port-unreachable"
and "icmp-port-unreachable". Let's make that consistent.

http://bugs.debian.org/644819

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 extensions/libip6t_REJECT.man | 7 +++----
 extensions/libipt_REJECT.man  | 6 +++---
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.man
index 2d09e05..0030a51 100644
--- a/extensions/libip6t_REJECT.man
+++ b/extensions/libip6t_REJECT.man
@@ -18,10 +18,9 @@ The type given can be
 \fBicmp6\-adm\-prohibited\fP,
 \fBadm\-prohibited\fP,
 \fBicmp6\-addr\-unreachable\fP,
-\fBaddr\-unreach\fP,
-\fBicmp6\-port\-unreachable\fP or
-\fBport\-unreach\fP
-which return the appropriate ICMPv6 error message (\fBport\-unreach\fP is
+\fBaddr\-unreach\fP, or
+\fBicmp6\-port\-unreachable\fP,
+which return the appropriate ICMPv6 error message (\fBicmp6\-port\-unreachable\fP is
 the default). Finally, the option
 \fBtcp\-reset\fP
 can be used on rules which only match the TCP protocol: this causes a
diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
index c419a85..926da03 100644
--- a/extensions/libipt_REJECT.man
+++ b/extensions/libipt_REJECT.man
@@ -18,9 +18,9 @@ The type given can be
 \fBicmp\-port\-unreachable\fP,
 \fBicmp\-proto\-unreachable\fP,
 \fBicmp\-net\-prohibited\fP,
-\fBicmp\-host\-prohibited\fP or
-\fBicmp\-admin\-prohibited\fP (*)
-which return the appropriate ICMP error message (\fBport\-unreachable\fP is
+\fBicmp\-host\-prohibited\fP, or
+\fBicmp\-admin\-prohibited\fP (*),
+which return the appropriate ICMP error message (\fBicmp\-port\-unreachable\fP is
 the default).  The option
 \fBtcp\-reset\fP
 can be used on rules which only match the TCP protocol: this causes a
-- 
1.8.1.2

