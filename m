From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 4/12]: moves ip[6]tables_insmod() to xtables.c as
 xtables_insmod()
Date: Thu, 30 Nov 2006 18:49:46 +0900 (JST)
Message-ID: <200611300949.kAU9nmRU018715@toshiba.co.jp>
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
 include/ip6tables.h       |    1 -
 include/iptables_common.h |    1 -
 include/xtables.h         |    3 ++
 ip6tables-restore.c       |    3 +-
 ip6tables.c               |   75 +-----------------------------------------
 iptables-restore.c        |    3 +-
 iptables.c                |   75 +-----------------------------------------
 xtables.c                 |   80 ++++++++++++++++++++++++++++++++++++++++++++-
 8 files changed, 88 insertions(+), 153 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 7907f66..1448df4 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -171,7 +171,6 @@ extern void parse_interface(const char *
 extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *), int verbose, int builtinstoo, ip6tc_handle_t *handle);
 extern int flush_entries(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
 extern int delete_chain(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
-extern int ip6tables_insmod(const char *modname, const char *modprobe);
 extern int load_ip6tables_ko(const char *modprobe);
 
 #endif /*_IP6TABLES_USER_H*/
diff --git a/include/iptables_common.h b/include/iptables_common.h
index 6f7e429..08c0553 100644
--- a/include/iptables_common.h
+++ b/include/iptables_common.h
@@ -27,7 +27,6 @@ extern int string_to_number_ll(const cha
 			    unsigned long long int, 
 			    unsigned long long int,
 			    unsigned long long *);
-extern int iptables_insmod(const char *modname, const char *modprobe);
 extern int load_iptables_ko(const char *modprobe);
 void exit_error(enum exittype, char *, ...)__attribute__((noreturn,
 							  format(printf,2,3)));
diff --git a/include/xtables.h b/include/xtables.h
index 6ef13fe..af142ee 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -4,4 +4,7 @@
 extern void *fw_calloc(size_t count, size_t size);
 extern void *fw_malloc(size_t size);
 
+extern const char *modprobe;
+extern int xtables_insmod(const char *modname, const char *modprobe);
+
 #endif /* _XTABLES_H */
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 06d7ce8..4ecdfe0 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -16,6 +16,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include "ip6tables.h"
+#include "xtables.h"
 #include "libiptc/libip6tc.h"
 
 #ifdef DEBUG
@@ -62,7 +63,7 @@ ip6tc_handle_t create_handle(const char
 
 	if (!handle) {
 		/* try to insmod the module if iptc_init failed */
-		ip6tables_insmod("ip6_tables", modprobe);
+		xtables_insmod("ip6_tables", modprobe);
 		handle = ip6tc_init(tablename);
 	}
 
diff --git a/ip6tables.c b/ip6tables.c
index 9054462..2866b3e 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -31,7 +31,6 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <dlfcn.h>
 #include <ctype.h>
 #include <stdarg.h>
 #include <limits.h>
@@ -40,7 +39,6 @@
 #include <arpa/inet.h>
 #include <unistd.h>
 #include <fcntl.h>
-#include <sys/wait.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 
@@ -51,10 +49,6 @@
 #define FALSE 0
 #endif
 
-#ifndef PROC_SYS_MODPROBE
-#define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
-#endif
-
 #define FMT_NUMERIC	0x0001
 #define FMT_NOCOUNTS	0x0002
 #define FMT_KILOMEGAGIGA 0x0004
@@ -193,9 +187,6 @@ const char *program_version;
 const char *program_name;
 char *lib_dir;
 
-/* the path to command to load kernel module */
-const char *modprobe = NULL;
-
 /* Keeping track of external matches and targets: linked lists.  */
 struct ip6tables_match *ip6tables_matches = NULL;
 struct ip6tables_target *ip6tables_targets = NULL;
@@ -1694,77 +1685,13 @@ list_entries(const ip6t_chainlabel chain
 	return found;
 }
 
-static char *get_modprobe(void)
-{
-	int procfile;
-	char *ret;
-
-#define PROCFILE_BUFSIZ 1024
-	procfile = open(PROC_SYS_MODPROBE, O_RDONLY);
-	if (procfile < 0)
-		return NULL;
-
-	ret = malloc(PROCFILE_BUFSIZ);
-	if (ret) {
-		memset(ret, 0, PROCFILE_BUFSIZ);
-		switch (read(procfile, ret, PROCFILE_BUFSIZ)) {
-		case -1: goto fail;
-		case PROCFILE_BUFSIZ: goto fail; /* Partial read.  Wierd */
-		}
-		if (ret[strlen(ret)-1]=='\n') 
-			ret[strlen(ret)-1]=0;
-		close(procfile);
-		return ret;
-	}
- fail:
-	free(ret);
-	close(procfile);
-	return NULL;
-}
-
-int ip6tables_insmod(const char *modname, const char *modprobe)
-{
-	char *buf = NULL;
-	char *argv[3];
-	int status;
-
-	/* If they don't explicitly set it, read out of kernel */
-	if (!modprobe) {
-		buf = get_modprobe();
-		if (!buf)
-			return -1;
-		modprobe = buf;
-	}
-
-	switch (fork()) {
-	case 0:
-		argv[0] = (char *)modprobe;
-		argv[1] = (char *)modname;
-		argv[2] = NULL;
-		execv(argv[0], argv);
-
-		/* not usually reached */
-		exit(1);
-	case -1:
-		return -1;
-
-	default: /* parent */
-		wait(&status);
-	}
-
-	free(buf);
-	if (WIFEXITED(status) && WEXITSTATUS(status) == 0)
-		return 0;
-	return -1;
-}
-
 int load_ip6tables_ko(const char *modprobe)
 {
 	static int loaded = 0;
 	static int ret = -1;
 
 	if (!loaded) {
-		ret = ip6tables_insmod("ip6_tables", modprobe);
+		ret = xtables_insmod("ip6_tables", modprobe);
 		loaded = 1;
 	}
 
diff --git a/iptables-restore.c b/iptables-restore.c
index e03fb7b..e1c7c32 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include "iptables.h"
+#include "xtables.h"
 #include "libiptc/libiptc.h"
 
 #ifdef DEBUG
@@ -59,7 +60,7 @@ iptc_handle_t create_handle(const char *
 
 	if (!handle) {
 		/* try to insmod the module if iptc_init failed */
-		iptables_insmod("ip_tables", modprobe);
+		xtables_insmod("ip_tables", modprobe);
 		handle = iptc_init(tablename);
 	}
 
diff --git a/iptables.c b/iptables.c
index 13d4786..e377574 100644
--- a/iptables.c
+++ b/iptables.c
@@ -31,7 +31,6 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <dlfcn.h>
 #include <ctype.h>
 #include <stdarg.h>
 #include <limits.h>
@@ -39,7 +38,6 @@
 #include <iptables.h>
 #include <xtables.h>
 #include <fcntl.h>
-#include <sys/wait.h>
 #include <sys/utsname.h>
 
 #ifndef TRUE
@@ -49,10 +47,6 @@
 #define FALSE 0
 #endif
 
-#ifndef PROC_SYS_MODPROBE
-#define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
-#endif
-
 #define FMT_NUMERIC	0x0001
 #define FMT_NOCOUNTS	0x0002
 #define FMT_KILOMEGAGIGA 0x0004
@@ -197,9 +191,6 @@ char *lib_dir;
 
 int kernel_version;
 
-/* the path to command to load kernel module */
-const char *modprobe = NULL;
-
 /* Keeping track of external matches and targets: linked lists.  */
 struct iptables_match *iptables_matches = NULL;
 struct iptables_target *iptables_targets = NULL;
@@ -1761,77 +1752,13 @@ list_entries(const ipt_chainlabel chain,
 	return found;
 }
 
-static char *get_modprobe(void)
-{
-	int procfile;
-	char *ret;
-
-#define PROCFILE_BUFSIZ	1024
-	procfile = open(PROC_SYS_MODPROBE, O_RDONLY);
-	if (procfile < 0)
-		return NULL;
-
-	ret = (char *) malloc(PROCFILE_BUFSIZ);
-	if (ret) {
-		memset(ret, 0, PROCFILE_BUFSIZ);
-		switch (read(procfile, ret, PROCFILE_BUFSIZ)) {
-		case -1: goto fail;
-		case PROCFILE_BUFSIZ: goto fail; /* Partial read.  Wierd */
-		}
-		if (ret[strlen(ret)-1]=='\n') 
-			ret[strlen(ret)-1]=0;
-		close(procfile);
-		return ret;
-	}
- fail:
-	free(ret);
-	close(procfile);
-	return NULL;
-}
-
-int iptables_insmod(const char *modname, const char *modprobe)
-{
-	char *buf = NULL;
-	char *argv[3];
-	int status;
-
-	/* If they don't explicitly set it, read out of kernel */
-	if (!modprobe) {
-		buf = get_modprobe();
-		if (!buf)
-			return -1;
-		modprobe = buf;
-	}
-
-	switch (fork()) {
-	case 0:
-		argv[0] = (char *)modprobe;
-		argv[1] = (char *)modname;
-		argv[2] = NULL;
-		execv(argv[0], argv);
-
-		/* not usually reached */
-		exit(1);
-	case -1:
-		return -1;
-
-	default: /* parent */
-		wait(&status);
-	}
-
-	free(buf);
-	if (WIFEXITED(status) && WEXITSTATUS(status) == 0)
-		return 0;
-	return -1;
-}
-
 int load_iptables_ko(const char *modprobe)
 {
 	static int loaded = 0;
 	static int ret = -1;
 
 	if (!loaded) {
-		ret = iptables_insmod("ip_tables", NULL);
+		ret = xtables_insmod("ip_tables", NULL);
 		loaded = 1;
 	}
 
diff --git a/xtables.c b/xtables.c
index a018d90..42bef53 100644
--- a/xtables.c
+++ b/xtables.c
@@ -16,14 +16,27 @@
  *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-
+#include <dlfcn.h>
 #include <errno.h>
+#include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/wait.h>
 
 #include <iptables_common.h>
 #include <xtables.h>
 
+#ifndef PROC_SYS_MODPROBE
+#define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
+#endif
+
+/* the path to command to load kernel module */
+const char *modprobe = NULL;
+
 void *fw_calloc(size_t count, size_t size)
 {
 	void *p;
@@ -43,3 +56,68 @@ void *fw_malloc(size_t size)
 
 	return p;
 }
+
+static char *get_modprobe(void)
+{
+	int procfile;
+	char *ret;
+
+#define PROCFILE_BUFSIZ	1024
+	procfile = open(PROC_SYS_MODPROBE, O_RDONLY);
+	if (procfile < 0)
+		return NULL;
+
+	ret = (char *) malloc(PROCFILE_BUFSIZ);
+	if (ret) {
+		memset(ret, 0, PROCFILE_BUFSIZ);
+		switch (read(procfile, ret, PROCFILE_BUFSIZ)) {
+		case -1: goto fail;
+		case PROCFILE_BUFSIZ: goto fail; /* Partial read.  Wierd */
+		}
+		if (ret[strlen(ret)-1]=='\n') 
+			ret[strlen(ret)-1]=0;
+		close(procfile);
+		return ret;
+	}
+ fail:
+	free(ret);
+	close(procfile);
+	return NULL;
+}
+
+int xtables_insmod(const char *modname, const char *modprobe)
+{
+	char *buf = NULL;
+	char *argv[3];
+	int status;
+
+	/* If they don't explicitly set it, read out of kernel */
+	if (!modprobe) {
+		buf = get_modprobe();
+		if (!buf)
+			return -1;
+		modprobe = buf;
+	}
+
+	switch (fork()) {
+	case 0:
+		argv[0] = (char *)modprobe;
+		argv[1] = (char *)modname;
+		argv[2] = NULL;
+		execv(argv[0], argv);
+
+		/* not usually reached */
+		exit(1);
+	case -1:
+		return -1;
+
+	default: /* parent */
+		wait(&status);
+	}
+
+	free(buf);
+	if (WIFEXITED(status) && WEXITSTATUS(status) == 0)
+		return 0;
+	return -1;
+}
+
-- 
1.4.4
