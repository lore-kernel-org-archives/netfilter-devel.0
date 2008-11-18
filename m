From: Jan Engelhardt <jengelh@medozas.de>
Subject: src: remove inclusion of iptables.h
Date: Tue, 18 Nov 2008 19:31:45 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811181931161.2316@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56706 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYKRSbr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:31:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 4ea9c024eee8b8bf7167b450ce2317ce7c620d08
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Nov 18 19:28:53 2008 +0100

src: remove inclusion of iptables.h

iptables.h and ip6tables.h only include declarations internal to
iptables (specifically iptables.c and ip6tables.c), as most of the
public API has been moved to xtables.h a few months ago.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_HL.c         |    2 +-
 extensions/libip6t_LOG.c        |    2 +-
 extensions/libip6t_REJECT.c     |    2 +-
 extensions/libip6t_ah.c         |    2 +-
 extensions/libip6t_dst.c        |    2 +-
 extensions/libip6t_eui64.c      |    2 +-
 extensions/libip6t_frag.c       |    2 +-
 extensions/libip6t_hbh.c        |    2 +-
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |    2 +-
 extensions/libip6t_ipv6header.c |    2 +-
 extensions/libip6t_mh.c         |    2 +-
 extensions/libip6t_policy.c     |    2 +-
 extensions/libip6t_rt.c         |    2 +-
 extensions/libipt_CLUSTERIP.c   |    2 +-
 extensions/libipt_DNAT.c        |    1 +
 extensions/libipt_ECN.c         |    2 +-
 extensions/libipt_LOG.c         |    2 +-
 extensions/libipt_MASQUERADE.c  |    2 +-
 extensions/libipt_MIRROR.c      |    2 +-
 extensions/libipt_NETMAP.c      |    2 +-
 extensions/libipt_REDIRECT.c    |    2 +-
 extensions/libipt_REJECT.c      |    2 +-
 extensions/libipt_SAME.c        |    2 +-
 extensions/libipt_SET.c         |    2 +-
 extensions/libipt_SNAT.c        |    1 +
 extensions/libipt_TTL.c         |    2 +-
 extensions/libipt_ULOG.c        |    2 +-
 extensions/libipt_addrtype.c    |    2 +-
 extensions/libipt_ah.c          |    2 +-
 extensions/libipt_ecn.c         |    2 +-
 extensions/libipt_icmp.c        |    2 +-
 extensions/libipt_policy.c      |    2 +-
 extensions/libipt_realm.c       |    2 +-
 extensions/libipt_set.c         |    2 +-
 extensions/libipt_ttl.c         |    2 +-
 extensions/libipt_unclean.c     |    2 +-
 extensions/libxt_TPROXY.c       |    1 -
 extensions/libxt_connlimit.c    |    2 +-
 extensions/libxt_conntrack.c    |    1 -
 40 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index b806428..92266e4 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -9,7 +9,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <ip6tables.h>
+#include <xtables.h>
 
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_HL.h>
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index b75d806..40a551f 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <syslog.h>
 #include <getopt.h>
-#include <ip6tables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_LOG.h>
 
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 9c6fe7a..0e21202 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -9,7 +9,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <ip6tables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_REJECT.h>
 
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 9f7cfab..6a3e784 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <errno.h>
-#include <ip6tables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_ah.h>
 
 static void ah_help(void)
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index dabca0d..17e8780 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <errno.h>
-#include <ip6tables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_opts.h>
 #include <sys/types.h>
 #include <sys/socket.h>
diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index 4caa66a..c92c868 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -9,7 +9,7 @@
 #else
 #include <linux/if_ether.h>
 #endif
-#include <ip6tables.h>
+#include <xtables.h>
 
 static void eui64_help(void)
 {
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 1a6e3be..1f8f801 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <errno.h>
-#include <ip6tables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_frag.h>
 
 static void frag_help(void)
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index e07955f..ce79af9 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <errno.h>
-#include <ip6tables.h>
+#include <xtables.h>
 /*#include <linux/in6.h>*/
 #include <linux/netfilter_ipv6/ip6t_opts.h>
 #include <sys/types.h>
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 1046b2e..f683dc7 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -10,7 +10,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <getopt.h>
-#include <ip6tables.h>
+#include <xtables.h>
 
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_hl.h>
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 2b3bd68..b87538f 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -4,7 +4,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <ip6tables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
 struct icmpv6_names {
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 63c60bf..e114451 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -5,7 +5,7 @@ on whether they contain certain headers */
  * Rewritten by: Andras Kis-Szabo <kisza@sch.bme.hu> */
 
 #include <getopt.h>
-#include <ip6tables.h>
+#include <xtables.h>
 #include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 305fadb..e76d7c3 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -16,7 +16,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <ip6tables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_mh.h>
 
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 92e6d0d..357cbea 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -10,8 +10,8 @@
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
+#include <xtables.h>
 #include <ip6tables.h>
-
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_policy.h>
 
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 25e410c..c1f72af 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <errno.h>
-#include <ip6tables.h>
+#include <xtables.h>
 /*#include <linux/in6.h>*/
 #include <linux/netfilter_ipv6/ip6t_rt.h>
 #include <sys/types.h>
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index 7e73b9e..4718496 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -15,7 +15,7 @@
 #include <linux/if_ether.h>
 #endif
 
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
 
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index da99b7f..e884b03 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -4,6 +4,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
+#include <xtables.h>
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 1336bb9..e9312f0 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -13,7 +13,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ECN.h>
 
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index d4f5e46..668b565 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <syslog.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_LOG.h>
 
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index ffbff58..1f93294 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -4,7 +4,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
 
diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
index 1322f59..3a3a85d 100644
--- a/extensions/libipt_MIRROR.c
+++ b/extensions/libipt_MIRROR.c
@@ -4,7 +4,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 
 static void MIRROR_help(void)
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 85334bc..f6c688d 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -7,7 +7,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
 
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 79e4731..64ab737 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -4,7 +4,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
 
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 2aeb6df..ef404e6 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -6,7 +6,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
 #include <linux/version.h>
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 51507eb..6cb09af 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -4,7 +4,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
 /* For 64bit kernel / 32bit userspace */
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index 7bf3510..7ec0c31 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -16,7 +16,7 @@
 #include <getopt.h>
 #include <ctype.h>
 
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_set.h>
 #include <linux/netfilter_ipv4/ipt_set.h>
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index fbd2a80..8c28c0e 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -4,6 +4,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
+#include <xtables.h>
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 7939dac..7647f2f 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -9,7 +9,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_TTL.h>
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 8c191d0..d73a3f6 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -15,7 +15,7 @@
 #include <stdlib.h>
 #include <syslog.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 /* For 64bit kernel / 32bit userspace */
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index e0de799..3c83a01 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -6,7 +6,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_addrtype.h>
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index b308053..5084332 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <errno.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ipt_ah.h>
 
 static void ah_help(void)
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 30eaec2..72353d5 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -12,7 +12,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ecn.h>
 
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 314a122..d0b7bb3 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -4,7 +4,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 
 /* special hack for icmp-type 'any': 
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index 0268685..9c70182 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -10,7 +10,7 @@
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
-#include <iptables.h>
+#include <xtables.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_policy.h>
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 3812853..5af2fd4 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -11,7 +11,7 @@
 #else
 #include <linux/if_ether.h>
 #endif
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ipt_realm.h>
 
 static void realm_help(void)
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 8aa4d1e..9bdb007 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -17,7 +17,7 @@
 #include <ctype.h>
 #include <errno.h>
 
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter_ipv4/ipt_set.h>
 #include "libipt_set.h"
 
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index cd93ca0..055c92e 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -9,7 +9,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ttl.h>
diff --git a/extensions/libipt_unclean.c b/extensions/libipt_unclean.c
index 50a3ec3..93d9013 100644
--- a/extensions/libipt_unclean.c
+++ b/extensions/libipt_unclean.c
@@ -2,7 +2,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 
 static void unclean_help(void)
 {
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index d4b5c0a..deb214f 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -10,7 +10,6 @@
 #include <stdlib.h>
 #include <limits.h>
 
-#include <iptables.h>
 #include <xtables.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_TPROXY.h>
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 65de193..117222a 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <stddef.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter/xt_connlimit.h>
 
 static void connlimit_help(void)
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 3cec9dd..e918c1e 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -15,7 +15,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <iptables.h>
 #include <xtables.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/xt_conntrack.h>

