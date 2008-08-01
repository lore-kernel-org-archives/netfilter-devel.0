From: Jan Engelhardt <jengelh@medozas.de>
Subject: src: remove dependency on libiptc headers
Date: Fri, 1 Aug 2008 09:04:33 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808010903020.31124@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38575 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbYHANEf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:04:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(patch 1/2)
commit 88496da7062bb0a2c07685a5b1968fc2ecf6d887
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Aug 1 09:02:26 2008 -0400

src: remove dependency on libiptc headers

xtables.h does not need really need libxtc.h, and we can drop it from 
the install as it is internal-only.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TCPOPTSTRIP.c |    1 +
 extensions/libxt_hashlimit.c   |    1 +
 extensions/libxt_time.c        |    1 +
 extensions/tos_values.c        |    1 +
 include/ip6tables.h            |    4 ++--
 include/iptables.h             |    5 +++--
 include/libiptc/libxtc.h       |    2 --
 include/xtables.h.in           |   11 +++++++----
 xtables.c                      |    1 +
 9 files changed, 17 insertions(+), 10 deletions(-)

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
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 4ce73e9..51cb67d 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -1,11 +1,12 @@
 #ifndef _XTABLES_H
 #define _XTABLES_H
 
+#include <sys/socket.h> /* PF_* */
 #include <sys/types.h>
+#include <stdbool.h>
+#include <net/if.h>
 #include <linux/types.h>
 #include <linux/netfilter/x_tables.h>
-#include <libiptc/libxtc.h>
-#include <stdbool.h>
 
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
@@ -22,12 +23,14 @@
 
 #define XTABLES_API_VERSION(x,y,z)    (0x10000*(x) + 0x100*(y) + z)
 
+struct in_addr;
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
 	struct xtables_match *next;
 
-	xt_chainlabel name;
+	const char *name;
 
 	/* Revision of match (0 by default). */
 	u_int8_t revision;
@@ -83,7 +86,7 @@ struct xtables_target
 {
 	struct xtables_target *next;
 
-	xt_chainlabel name;
+	const char *name;
 
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

