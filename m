From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 02/43] Moves common fw_malloc() and fw_calloc() to xtables.c
Date: Sun, 15 Jul 2007 02:21:53 +0900 (JST)
Message-ID: <200707141721.l6EHLrQF025146@toshiba.co.jp>
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
 include/xtables.h |    3 +++
 ip6tables.c       |   25 +------------------------
 iptables.c        |   25 +------------------------
 xtables.c         |   30 ++++++++++++++++++++++++++++++
 4 files changed, 35 insertions(+), 48 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index eed1dff..6ef13fe 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -1,4 +1,7 @@
 #ifndef _XTABLES_H
 #define _XTABLES_H
 
+extern void *fw_calloc(size_t count, size_t size);
+extern void *fw_malloc(size_t size);
+
 #endif /* _XTABLES_H */
diff --git a/ip6tables.c b/ip6tables.c
index 6b2766b..a096b79 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -36,6 +36,7 @@
 #include <stdarg.h>
 #include <limits.h>
 #include <ip6tables.h>
+#include <xtables.h>
 #include <arpa/inet.h>
 #include <unistd.h>
 #include <fcntl.h>
@@ -494,30 +495,6 @@ check_inverse(const char option[], int *invert, int *optind, int argc)
 	return FALSE;
 }
 
-static void *
-fw_calloc(size_t count, size_t size)
-{
-	void *p;
-
-	if ((p = calloc(count, size)) == NULL) {
-		perror("ip6tables: calloc failed");
-		exit(1);
-	}
-	return p;
-}
-
-static void *
-fw_malloc(size_t size)
-{
-	void *p;
-
-	if ((p = malloc(size)) == NULL) {
-		perror("ip6tables: malloc failed");
-		exit(1);
-	}
-	return p;
-}
-
 static char *
 addr_to_numeric(const struct in6_addr *addrp)
 {
diff --git a/iptables.c b/iptables.c
index 83b0c82..166016e 100644
--- a/iptables.c
+++ b/iptables.c
@@ -37,6 +37,7 @@
 #include <limits.h>
 #include <unistd.h>
 #include <iptables.h>
+#include <xtables.h>
 #include <fcntl.h>
 #include <sys/wait.h>
 #include <sys/utsname.h>
@@ -579,30 +580,6 @@ check_inverse(const char option[], int *invert, int *optind, int argc)
 	return FALSE;
 }
 
-static void *
-fw_calloc(size_t count, size_t size)
-{
-	void *p;
-
-	if ((p = calloc(count, size)) == NULL) {
-		perror("iptables: calloc failed");
-		exit(1);
-	}
-	return p;
-}
-
-static void *
-fw_malloc(size_t size)
-{
-	void *p;
-
-	if ((p = malloc(size)) == NULL) {
-		perror("iptables: malloc failed");
-		exit(1);
-	}
-	return p;
-}
-
 static struct in_addr *
 host_to_addr(const char *name, unsigned int *naddr)
 {
diff --git a/xtables.c b/xtables.c
index cc4d218..667656a 100644
--- a/xtables.c
+++ b/xtables.c
@@ -16,4 +16,34 @@
  *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <iptables_common.h>
 #include <xtables.h>
+
+void *fw_calloc(size_t count, size_t size)
+{
+	void *p;
+
+	if ((p = calloc(count, size)) == NULL) {
+		perror("ip[6]tables: calloc failed");
+		exit(1);
+	}
+
+	return p;
+}
+
+void *fw_malloc(size_t size)
+{
+	void *p;
+
+	if ((p = malloc(size)) == NULL) {
+		perror("ip[6]tables: malloc failed");
+		exit(1);
+	}
+
+	return p;
+}
-- 
1.5.2.2
