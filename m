From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 3/12]: move common functions fw_malloc and fw_calloc to
 xtables.c
Date: Thu, 30 Nov 2006 18:49:28 +0900 (JST)
Message-ID: <200611300949.kAU9nTFm001669@toshiba.co.jp>
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
 include/xtables.h |    3 +++
 ip6tables.c       |   25 +------------------------
 iptables.c        |   25 +------------------------
 xtables.c         |   26 ++++++++++++++++++++++++++
 4 files changed, 31 insertions(+), 48 deletions(-)

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
index 9b1370a..9054462 100644
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
@@ -487,30 +488,6 @@ check_inverse(const char option[], int *
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
index 7d8771d..13d4786 100644
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
@@ -577,30 +578,6 @@ check_inverse(const char option[], int *
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
index cc4d218..a018d90 100644
--- a/xtables.c
+++ b/xtables.c
@@ -16,4 +16,30 @@
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
+	if ((p = calloc(count, size)) == NULL)
+		exit_error(OTHER_PROBLEM, "calloc failed");
+
+	return p;
+}
+
+void *fw_malloc(size_t size)
+{
+	void *p;
+
+	if ((p = malloc(size)) == NULL)
+		exit_error(OTHER_PROBLEM, "malloc failed");
+
+	return p;
+}
-- 
1.4.4
