From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 7/12]: move IPPROTO_* and IP[6]T_LIB_DIR definitions to
 xtables.h
Date: Thu, 30 Nov 2006 18:50:54 +0900 (JST)
Message-ID: <200611300950.kAU9ouVA002848@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


---
 include/ip6tables.h |    9 +--------
 include/iptables.h  |    9 +--------
 include/xtables.h   |   11 +++++++++++
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index f6da0b2..b0de395 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -7,14 +7,7 @@
 #include "libiptc/libip6tc.h"
 
 #ifndef IP6T_LIB_DIR
-#define IP6T_LIB_DIR "/usr/local/lib/iptables"
-#endif
-
-#ifndef IPPROTO_SCTP
-#define IPPROTO_SCTP 132
-#endif
-#ifndef IPPROTO_DCCP
-#define IPPROTO_DCCP 33
+#define IP6T_LIB_DIR XT_LIB_DIR
 #endif
 
 #ifndef IP6T_SO_GET_REVISION_MATCH /* Old kernel source. */
diff --git a/include/iptables.h b/include/iptables.h
index 3b365ae..83b7363 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -6,14 +6,7 @@
 #include "libiptc/libiptc.h"
 
 #ifndef IPT_LIB_DIR
-#define IPT_LIB_DIR "/usr/local/lib/iptables"
-#endif
-
-#ifndef IPPROTO_SCTP
-#define IPPROTO_SCTP 132
-#endif
-#ifndef IPPROTO_DCCP
-#define IPPROTO_DCCP 33
+#define IPT_LIB_DIR XT_LIB_DIR
 #endif
 
 #ifndef IPT_SO_GET_REVISION_MATCH /* Old kernel source. */
diff --git a/include/xtables.h b/include/xtables.h
index e9caf4d..178ffa6 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -5,6 +5,17 @@
 #include <linux/netfilter/x_tables.h>
 #include <libiptc/libxtc.h>
 
+#ifndef XT_LIB_DIR
+#define XT_LIB_DIR "/usr/local/lib/iptables"
+#endif
+
+#ifndef IPPROTO_SCTP
+#define IPPROTO_SCTP 132
+#endif
+#ifndef IPPROTO_DCCP
+#define IPPROTO_DCCP 33
+#endif
+
 /* protocol family dependent informations */
 struct pfinfo {
 	/* protocol family number */
-- 
1.4.4
