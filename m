From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 06/43] move IPPROTO_* and IP[6]T_LIB_DIR definitions to
 xtables.h
Date: Sun, 15 Jul 2007 02:22:35 +0900 (JST)
Message-ID: <200707141722.l6EHMaKA022932@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
 include/ip6tables.h |   12 +-----------
 include/iptables.h  |   12 +-----------
 include/xtables.h   |   14 ++++++++++++++
 3 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 90e3283..b0de395 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -7,17 +7,7 @@
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
-#endif
-#ifndef IPPROTO_UDPLITE
-#define IPPROTO_UDPLITE 136
+#define IP6T_LIB_DIR XT_LIB_DIR
 #endif
 
 #ifndef IP6T_SO_GET_REVISION_MATCH /* Old kernel source. */
diff --git a/include/iptables.h b/include/iptables.h
index 1f92977..83b7363 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -6,17 +6,7 @@
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
-#endif
-#ifndef IPPROTO_UDPLITE
-#define IPPROTO_UDPLITE	136
+#define IPT_LIB_DIR XT_LIB_DIR
 #endif
 
 #ifndef IPT_SO_GET_REVISION_MATCH /* Old kernel source. */
diff --git a/include/xtables.h b/include/xtables.h
index 5ae3001..43de25c 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -5,6 +5,20 @@
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
+#ifndef IPPROTO_UDPLITE
+#define IPPROTO_UDPLITE	136
+#endif
+
 /* protocol family dependent informations */
 struct afinfo {
 	/* protocol family */
-- 
1.5.2.2
