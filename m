From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 13/43] Moves declarations in iptables_common.h to xtables.h.
Date: Sun, 15 Jul 2007 02:23:57 +0900 (JST)
Message-ID: <200707141723.l6EHNw7L022961@toshiba.co.jp>
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
 extensions/libipt_dscp_helper.c |    3 +--
 include/ip6tables.h             |    1 -
 include/iptables.h              |    1 -
 include/iptables_common.h       |   36 ------------------------------------
 include/xtables.h               |   31 +++++++++++++++++++++++++++++++
 xtables.c                       |    1 -
 6 files changed, 32 insertions(+), 41 deletions(-)
 delete mode 100644 include/iptables_common.h

diff --git a/extensions/libipt_dscp_helper.c b/extensions/libipt_dscp_helper.c
index 31adb6c..fb68bb9 100644
--- a/extensions/libipt_dscp_helper.c
+++ b/extensions/libipt_dscp_helper.c
@@ -11,8 +11,7 @@
 
 #include <stdio.h>
 #include <string.h>
-#include <iptables_common.h>
-
+#include <xtables.h>
 
 
 static struct ds_class
diff --git a/include/ip6tables.h b/include/ip6tables.h
index b0de395..4a511b7 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -3,7 +3,6 @@
 
 #include <xtables.h>
 
-#include "iptables_common.h"
 #include "libiptc/libip6tc.h"
 
 #ifndef IP6T_LIB_DIR
diff --git a/include/iptables.h b/include/iptables.h
index 83b7363..91a93c3 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -2,7 +2,6 @@
 #define _IPTABLES_USER_H
 
 #include "xtables.h"
-#include "iptables_common.h"
 #include "libiptc/libiptc.h"
 
 #ifndef IPT_LIB_DIR
diff --git a/include/iptables_common.h b/include/iptables_common.h
deleted file mode 100644
index cf8a4ba..0000000
--- a/include/iptables_common.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _IPTABLES_COMMON_H
-#define _IPTABLES_COMMON_H
-/* Shared definitions between ipv4 and ipv6. */
-
-enum exittype {
-	OTHER_PROBLEM = 1,
-	PARAMETER_PROBLEM,
-	VERSION_PROBLEM,
-	RESOURCE_PROBLEM
-};
-
-/* this is a special 64bit data type that is 8-byte aligned */
-#define aligned_u64 unsigned long long __attribute__((aligned(8)))
-
-extern void exit_printhelp() __attribute__((noreturn));
-extern void exit_tryhelp(int) __attribute__((noreturn));
-int check_inverse(const char option[], int *invert, int *optind, int argc);
-void exit_error(enum exittype, char *, ...)__attribute__((noreturn,
-							  format(printf,2,3)));
-extern const char *program_name, *program_version;
-
-#define _init __attribute__((constructor)) my_init
-#ifdef NO_SHARED_LIBS
-# ifdef _INIT
-#  undef _init
-#  define _init _INIT
-# endif
-  extern void init_extensions(void);
-#endif
-
-#define __be32	u_int32_t
-#define __le32	u_int32_t
-#define __be16	u_int16_t
-#define __le16	u_int16_t
-
-#endif /*_IPTABLES_COMMON_H*/
diff --git a/include/xtables.h b/include/xtables.h
index 43de25c..231f514 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -211,4 +211,35 @@ extern u_int16_t parse_port(const char *port, const char *proto);
 extern void
 parse_interface(const char *arg, char *vianame, unsigned char *mask);
 
+enum exittype {
+	OTHER_PROBLEM = 1,
+	PARAMETER_PROBLEM,
+	VERSION_PROBLEM,
+	RESOURCE_PROBLEM
+};
+
+/* this is a special 64bit data type that is 8-byte aligned */
+#define aligned_u64 unsigned long long __attribute__((aligned(8)))
+
+extern void exit_printhelp() __attribute__((noreturn));
+extern void exit_tryhelp(int) __attribute__((noreturn));
+int check_inverse(const char option[], int *invert, int *optind, int argc);
+void exit_error(enum exittype, char *, ...)__attribute__((noreturn,
+							  format(printf,2,3)));
+extern const char *program_name, *program_version;
+
+#define _init __attribute__((constructor)) my_init
+#ifdef NO_SHARED_LIBS
+# ifdef _INIT
+#  undef _init
+#  define _init _INIT
+# endif
+  extern void init_extensions(void);
+#endif
+
+#define __be32	u_int32_t
+#define __le32	u_int32_t
+#define __be16	u_int16_t
+#define __le16	u_int16_t
+
 #endif /* _XTABLES_H */
diff --git a/xtables.c b/xtables.c
index ea5633e..baee483 100644
--- a/xtables.c
+++ b/xtables.c
@@ -29,7 +29,6 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 
-#include <iptables_common.h>
 #include <xtables.h>
 
 #define NPROTO	255
-- 
1.5.2.2
