From: Jan Engelhardt <jengelh@medozas.de>
Subject: src: remove dependency on libiptc headers
Date: Wed, 30 Jul 2008 09:19:41 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0807300839010.6568@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33909 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYG3NTn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:19:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 8219a9d65fe583de06c2ff4e84d1ea299955184b
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Jul 30 08:36:33 2008 -0400

src: remove dependency on libiptc headers

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TCPOPTSTRIP.c         |    1 +
 extensions/libxt_hashlimit.c           |    1 +
 extensions/libxt_time.c                |    1 +
 extensions/tos_values.c                |    1 +
 include/ip6tables.h                    |    4 ++--
 include/iptables.h                     |    5 +++--
 include/libiptc/libxtc.h               |    2 --
 include/linux/netfilter/xt_RATEEST.h   |    2 ++
 include/linux/netfilter/xt_hashlimit.h |    4 ++--
 include/linux/netfilter/xt_physdev.h   |    8 ++++----
 include/linux/netfilter/xt_rateest.h   |    4 ++--
 include/xtables.h.in                   |    8 +++++---
 xtables.c                              |    1 +
 13 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index bd74e37..a00c82b 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <xtables.h>
+#include <netinet/tcp.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_TCPOPTSTRIP.h>
 #ifndef TCPOPT_MD5SIG
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 2f6b3fc..1f34fb9 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -11,6 +11,7 @@
  * Error corections by nmalykh@bilim.com (22.01.2005)
  */
 #include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 97bb0d3..f2bb51f 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -12,6 +12,7 @@
 #include <sys/types.h>
 #include <getopt.h>
 #include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
diff --git a/extensions/tos_values.c b/extensions/tos_values.c
index 4c0b0bc..0ab784d 100644
--- a/extensions/tos_values.c
+++ b/extensions/tos_values.c
@@ -1,6 +1,7 @@
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
+#include <linux/ip.h>
 
 struct tos_value_mask {
 	uint8_t value, mask;
diff --git a/include/ip6tables.h b/include/ip6tables.h
index 077fee9..dfbc9b2 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -1,9 +1,9 @@
 #ifndef _IP6TABLES_USER_H
 #define _IP6TABLES_USER_H
 
+#include <netinet/ip.h>
 #include <xtables.h>
-
-#include "libiptc/libip6tc.h"
+#include <libiptc/libip6tc.h>
 
 #ifndef IP6T_SO_GET_REVISION_MATCH /* Old kernel source. */
 #define IP6T_SO_GET_REVISION_MATCH	68
diff --git a/include/iptables.h b/include/iptables.h
index ecc7168..99e8e1e 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -1,8 +1,9 @@
 #ifndef _IPTABLES_USER_H
 #define _IPTABLES_USER_H
 
-#include "xtables.h"
-#include "libiptc/libiptc.h"
+#include <netinet/ip.h>
+#include <xtables.h>
+#include <libiptc/libiptc.h>
 
 #ifndef IPT_SO_GET_REVISION_MATCH /* Old kernel source. */
 #define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
diff --git a/include/libiptc/libxtc.h b/include/libiptc/libxtc.h
index 031afb5..3701018 100644
--- a/include/libiptc/libxtc.h
+++ b/include/libiptc/libxtc.h
@@ -20,8 +20,6 @@ extern "C" {
 #define XT_ALIGN(s) (((s) + ((XT_MIN_ALIGN)-1)) & ~((XT_MIN_ALIGN)-1))
 #endif
 
-typedef char xt_chainlabel[32];
-
 #define XTC_LABEL_ACCEPT  "ACCEPT"
 #define XTC_LABEL_DROP    "DROP"
 #define XTC_LABEL_QUEUE   "QUEUE"
diff --git a/include/linux/netfilter/xt_RATEEST.h b/include/linux/netfilter/xt_RATEEST.h
index f79e313..59b0257 100644
--- a/include/linux/netfilter/xt_RATEEST.h
+++ b/include/linux/netfilter/xt_RATEEST.h
@@ -1,6 +1,8 @@
 #ifndef _XT_RATEEST_TARGET_H
 #define _XT_RATEEST_TARGET_H
 
+#include <linux/if.h>
+
 struct xt_rateest_target_info {
 	char			name[IFNAMSIZ];
 	int8_t			interval;
diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
index 51b18d8..7e44c57 100644
--- a/include/linux/netfilter/xt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -30,7 +30,7 @@ struct hashlimit_cfg {
 };
 
 struct xt_hashlimit_info {
-	char name [IFNAMSIZ];		/* name */
+	char name[16];		/* name */
 	struct hashlimit_cfg cfg;
 
 	/* Used internally by the kernel */
@@ -56,7 +56,7 @@ struct hashlimit_cfg1 {
 };
 
 struct xt_hashlimit_mtinfo1 {
-	char name[IFNAMSIZ];
+	char name[16];
 	struct hashlimit_cfg1 cfg;
 
 	/* Used internally by the kernel */
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter/xt_physdev.h
index 9d33619..3500a50 100644
--- a/include/linux/netfilter/xt_physdev.h
+++ b/include/linux/netfilter/xt_physdev.h
@@ -10,10 +10,10 @@
 #define XT_PHYSDEV_OP_MASK		(0x20 - 1)
 
 struct xt_physdev_info {
-	char physindev[IFNAMSIZ];
-	char in_mask[IFNAMSIZ];
-	char physoutdev[IFNAMSIZ];
-	char out_mask[IFNAMSIZ];
+	char physindev[16];
+	char in_mask[16];
+	char physoutdev[16];
+	char out_mask[16];
 	u_int8_t invert;
 	u_int8_t bitmask;
 };
diff --git a/include/linux/netfilter/xt_rateest.h b/include/linux/netfilter/xt_rateest.h
index 2010cb7..4f7c071 100644
--- a/include/linux/netfilter/xt_rateest.h
+++ b/include/linux/netfilter/xt_rateest.h
@@ -18,8 +18,8 @@ enum xt_rateest_match_mode {
 };
 
 struct xt_rateest_match_info {
-	char			name1[IFNAMSIZ];
-	char			name2[IFNAMSIZ];
+	char			name1[16];
+	char			name2[16];
 	u_int16_t		flags;
 	u_int16_t		mode;
 	u_int32_t		bps1;
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 4ce73e9..9dc91d4 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -1,10 +1,10 @@
 #ifndef _XTABLES_H
 #define _XTABLES_H
 
+#include <sys/socket.h> /* PF_* */
 #include <sys/types.h>
 #include <linux/types.h>
 #include <linux/netfilter/x_tables.h>
-#include <libiptc/libxtc.h>
 #include <stdbool.h>
 
 #ifndef IPPROTO_SCTP
@@ -22,12 +22,14 @@
 
 #define XTABLES_API_VERSION(x,y,z)    (0x10000*(x) + 0x100*(y) + z)
 
+struct in_addr;
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
 	struct xtables_match *next;
 
-	xt_chainlabel name;
+	char name[32];
 
 	/* Revision of match (0 by default). */
 	u_int8_t revision;
@@ -83,7 +85,7 @@ struct xtables_target
 {
 	struct xtables_target *next;
 
-	xt_chainlabel name;
+	char name[32];
 
 	/* Revision of target (0 by default). */
 	u_int8_t revision;
diff --git a/xtables.c b/xtables.c
index a97bdaa..abdd283 100644
--- a/xtables.c
+++ b/xtables.c
@@ -32,6 +32,7 @@
 #include <arpa/inet.h>
 
 #include <xtables.h>
+#include <libiptc/libxtc.h>
 
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>

