From: Jan Engelhardt <jengelh@medozas.de>
Subject: 1.4.3: iptables-multi needs adjustment for -static callname
Date: Tue, 24 Mar 2009 22:39:14 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903242236130.26397@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37149 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbZCXVjR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:39:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

HI,

I just noticed that one cannot call iptables-static because the multi 
handler does not know about itself.

Available through: git://dev.medozas.de/iptables plus


parent ed7925b77010dd17531ea0424b49d2b72af4add9 (v1.4.3.1-1-ged7925b)
commit cdf51d0183213c4bcac9ef4818155c1d3fbb897e
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Mar 24 22:35:10 2009 +0100

iptables-multi: support "iptables-static" as a callable name

iptables multi-purpose version: unknown applet name iptables-static

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-multi.c |    3 ++-
 iptables-multi.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/ip6tables-multi.c b/ip6tables-multi.c
index 0bcface..3313bfd 100644
--- a/ip6tables-multi.c
+++ b/ip6tables-multi.c
@@ -16,7 +16,8 @@ int main(int argc, char **argv) {
   } else {
     progname = basename(argv[0]);
 
-    if (!strcmp(progname, "ip6tables"))
+    if (!strcmp(progname, "ip6tables") ||
+        strcmp(progname, "ip6tables-static") == 0)
       return ip6tables_main(argc, argv);
     
     if (!strcmp(progname, "ip6tables-save"))
diff --git a/iptables-multi.c b/iptables-multi.c
index 7ade333..28c1737 100644
--- a/iptables-multi.c
+++ b/iptables-multi.c
@@ -17,7 +17,8 @@ int main(int argc, char **argv) {
   } else {
     progname = basename(argv[0]);
 
-    if (!strcmp(progname, "iptables"))
+    if (!strcmp(progname, "iptables") ||
+        strcmp(progname, "iptables-static") == 0)
       return iptables_main(argc, argv);
     
     if (!strcmp(progname, "iptables-save"))
-- 
# Created with git-export-patch
