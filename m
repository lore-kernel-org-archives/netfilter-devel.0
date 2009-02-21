From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/6] extensions: remove unwanted/add needed includes for IPv4 exts
Date: Sat, 21 Feb 2009 04:18:03 +0100
Message-ID: <1235186284-31661-6-git-send-email-jengelh@medozas.de>
References: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, hadi@cyberus.ca
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37818 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbZBUDSI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:18:08 -0500
In-Reply-To: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Most touched files do not use anything from ip_tables.h, so
remove that #include. multiport instead, does need it (ipt_entry).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_CLUSTERIP.c |    1 -
 extensions/libipt_DNAT.c      |    2 +-
 extensions/libipt_ECN.c       |    1 -
 extensions/libipt_LOG.c       |    1 -
 extensions/libipt_MIRROR.c    |    1 -
 extensions/libipt_NETMAP.c    |    1 -
 extensions/libipt_REJECT.c    |    1 -
 extensions/libipt_SAME.c      |    1 -
 extensions/libipt_SET.c       |    1 -
 extensions/libipt_TTL.c       |    1 -
 extensions/libipt_ULOG.c      |    1 -
 extensions/libipt_addrtype.c  |    1 -
 extensions/libipt_ecn.c       |    1 -
 extensions/libipt_policy.c    |    1 -
 extensions/libipt_ttl.c       |    1 -
 extensions/libxt_multiport.c  |    1 +
 16 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index 2bb2292..279aacf 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -16,7 +16,6 @@
 #endif
 
 #include <xtables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
 
 static void CLUSTERIP_help(void)
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index a3e1462..f0a2369 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <iptables.h>
+#include <iptables.h> /* get_kernel_version */
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
 
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index b107d16..bf1f8a5 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -14,7 +14,6 @@
 #include <getopt.h>
 
 #include <xtables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ECN.h>
 
 static void ECN_help(void)
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 4da412c..ebcb574 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -6,7 +6,6 @@
 #include <syslog.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_LOG.h>
 
 #define LOG_DEFAULT_LEVEL LOG_WARNING
diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
index 3a3a85d..81964dd 100644
--- a/extensions/libipt_MIRROR.c
+++ b/extensions/libipt_MIRROR.c
@@ -5,7 +5,6 @@
 #include <getopt.h>
 
 #include <xtables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 
 static void MIRROR_help(void)
 {
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index b1d79ce..f718d2c 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -8,7 +8,6 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
 
 #define MODULENAME "NETMAP"
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 98d8dcb..5b23f54 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -7,7 +7,6 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
 #include <linux/version.h>
 
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 444a520..dabdb3f 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -5,7 +5,6 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
 /* For 64bit kernel / 32bit userspace */
 #include <linux/netfilter_ipv4/ipt_SAME.h>
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index e9bdab4..5da41a0 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -17,7 +17,6 @@
 #include <ctype.h>
 
 #include <xtables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_set.h>
 #include <linux/netfilter_ipv4/ipt_set.h>
 #include "libipt_set.h"
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 2501877..0e2be0b 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -11,7 +11,6 @@
 #include <getopt.h>
 #include <xtables.h>
 
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_TTL.h>
 
 #define IPT_TTL_USED	1
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 9633a87..3fa91f2 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -16,7 +16,6 @@
 #include <syslog.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 /* For 64bit kernel / 32bit userspace */
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
 
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index 22b35d4..ecd51b5 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -8,7 +8,6 @@
 #include <getopt.h>
 #include <xtables.h>
 
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_addrtype.h>
 
 /* from linux/rtnetlink.h, must match order of enumeration */
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 0f8849d..3ee190e 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -13,7 +13,6 @@
 #include <getopt.h>
 
 #include <xtables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ecn.h>
 
 static void ecn_help(void)
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index 964c19a..1271fba 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -12,7 +12,6 @@
 #include <arpa/inet.h>
 #include <xtables.h>
 
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_policy.h>
 
 /*
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 67f0b1a..019a556 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -11,7 +11,6 @@
 #include <getopt.h>
 #include <xtables.h>
 
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ttl.h>
 
 static void ttl_help(void)
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 5700f8a..54b9e2c 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -8,6 +8,7 @@
 #include <xtables.h>
 #include <libiptc/libiptc.h>
 #include <libiptc/libip6tc.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/xt_multiport.h>
 
-- 
1.6.1.3

