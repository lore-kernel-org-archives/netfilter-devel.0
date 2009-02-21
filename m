From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/6] extensions: remove unwanted/add needed includes for IPv6 exts
Date: Sat, 21 Feb 2009 04:18:02 +0100
Message-ID: <1235186284-31661-5-git-send-email-jengelh@medozas.de>
References: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, hadi@cyberus.ca
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37810 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZBUDSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:18:06 -0500
In-Reply-To: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Most touched files do not use anything from ip6_tables.h, so
remove that #include. multiport instead, does need it (ip6t_entry).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_HL.c         |    3 +--
 extensions/libip6t_LOG.c        |    1 -
 extensions/libip6t_REJECT.c     |    1 -
 extensions/libip6t_hl.c         |    1 -
 extensions/libip6t_ipv6header.c |    1 -
 extensions/libip6t_mh.c         |    1 -
 extensions/libip6t_policy.c     |    3 +--
 extensions/libxt_multiport.c    |    1 +
 8 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index ee117f1..12d8e72 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -5,13 +5,12 @@
  * This program is distributed under the terms of GNU GPL
  */
 
+#include <getopt.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 
-#include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_HL.h>
 
 #define IP6T_HL_USED	1
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index c6bf2a7..390cb97 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -6,7 +6,6 @@
 #include <syslog.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_LOG.h>
 
 #ifndef IP6T_LOG_UID	/* Old kernel */
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 94013ec..527f595 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -10,7 +10,6 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_REJECT.h>
 
 struct reject_names {
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 2280e03..9252c3d 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -12,7 +12,6 @@
 #include <getopt.h>
 #include <xtables.h>
 
-#include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_hl.h>
 
 static void hl_help(void)
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 296bd5f..479b313 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -13,7 +13,6 @@ on whether they contain certain headers */
 #include <netdb.h>
 #include <sys/types.h>
 
-#include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_ipv6header.h>
 
 /* This maybe required 
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index f476c93..9711f76 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -17,7 +17,6 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_mh.h>
 
 struct mh_name {
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 70f320f..0016da2 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -11,8 +11,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <xtables.h>
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <libiptc/libip6tc.h>
 #include <linux/netfilter_ipv6/ip6t_policy.h>
 
 /*
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 8141441..5700f8a 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -8,6 +8,7 @@
 #include <xtables.h>
 #include <libiptc/libiptc.h>
 #include <libiptc/libip6tc.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/xt_multiport.h>
 
 /* Function which prints out usage message. */
-- 
1.6.1.3

