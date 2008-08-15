From: Jan Engelhardt <jengelh@medozas.de>
Subject: src: use regular includes
Date: Fri, 15 Aug 2008 18:57:08 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808151856510.26696@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33909 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYHOW5J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:57:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 75ab89c10914d48739409cc1a6264b2f907b22be
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Aug 15 18:54:04 2008 -0400

src: use regular includes

iptables ships with all header files and prioritized its own include
directory over /usr/include/linux, so just use the normal brackets.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_policy.c   |    2 +-
 extensions/libipt_CLUSTERIP.c |    2 +-
 extensions/libipt_SAME.c      |    2 +-
 extensions/libipt_ULOG.c      |    2 +-
 extensions/libipt_policy.c    |    2 +-
 extensions/libxt_connlimit.c  |    2 +-
 extensions/libxt_limit.c      |    2 +-
 extensions/libxt_multiport.c  |    3 +--
 extensions/libxt_u32.c        |    2 +-
 9 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index eaf861e..09dc5cc 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -14,7 +14,7 @@
 #include <ip6tables.h>
 
 #include <linux/netfilter_ipv6/ip6_tables.h>
-#include "../include/linux/netfilter_ipv6/ip6t_policy.h"
+#include <linux/netfilter_ipv6/ip6t_policy.h>
 
 /*
  * HACK: global pointer to current matchinfo for making
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index a0f3406..6a2c8da 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -17,7 +17,7 @@
 
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include "../include/linux/netfilter_ipv4/ipt_CLUSTERIP.h"
+#include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
 
 static void CLUSTERIP_help(void)
 {
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 3154797..c0aef9f 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -8,7 +8,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
 /* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter_ipv4/ipt_SAME.h"
+#include <linux/netfilter_ipv4/ipt_SAME.h>
 
 /* Function which prints out usage message. */
 static void SAME_help(void)
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index d2b464f..33c26ec 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -18,7 +18,7 @@
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 /* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter_ipv4/ipt_ULOG.h"
+#include <linux/netfilter_ipv4/ipt_ULOG.h>
 
 
 static void print_groups(unsigned int gmask)
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index 71e95dd..fc55fac 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -13,7 +13,7 @@
 #include <iptables.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include "../include/linux/netfilter_ipv4/ipt_policy.h"
+#include <linux/netfilter_ipv4/ipt_policy.h>
 
 /*
  * HACK: global pointer to current matchinfo for making
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 3474ce5..7a2fb45 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -6,7 +6,7 @@
 #include <stddef.h>
 #include <getopt.h>
 #include <iptables.h>
-#include "../include/linux/netfilter/xt_connlimit.h"
+#include <linux/netfilter/xt_connlimit.h>
 
 static void connlimit_help(void)
 {
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 424635a..a519a1a 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -12,7 +12,7 @@
 #include <stddef.h>
 #include <linux/netfilter/x_tables.h>
 /* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter/xt_limit.h"
+#include <linux/netfilter/xt_limit.h>
 
 #define XT_LIMIT_AVG	"3/hour"
 #define XT_LIMIT_BURST	5
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 3c2ece1..6efd642 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -8,8 +8,7 @@
 #include <xtables.h>
 #include <libiptc/libiptc.h>
 #include <libiptc/libip6tc.h>
-/* To ensure that iptables compiles with an old kernel */
-#include "../include/linux/netfilter/xt_multiport.h"
+#include <linux/netfilter/xt_multiport.h>
 
 /* Function which prints out usage message. */
 static void multiport_help(void)
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 3a5cdad..77245ab 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -20,7 +20,7 @@
 #include <string.h>
 
 #include <xtables.h>
-#include "../include/linux/netfilter/xt_u32.h"
+#include <linux/netfilter/xt_u32.h>
 
 static const struct option u32_opts[] = {
 	{"u32", 1, NULL, 'u'},
