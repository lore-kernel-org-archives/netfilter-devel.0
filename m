From: bryanh@giraffe-data.com (Bryan Henderson)
Subject: variable IPT_LIB_DIR
Date: Sun, 30 May 2004 21:30:47 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E1BUXtH-0001e8-00@giraffe.giraffe-data.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I don't like hardcoded file paths in programs, so I added to Iptables
the ability take the IPT_LIB_DIR value (where Iptables looks for its
dynamically loaded code) from an environment variable.

Here it is, in case it can be useful to others.

The handling of the pathological out-of-memory condition probably
needs work.  It wasn't immediately obvious what the right response is,
so I punted.

-- 
Bryan Henderson                                    Phone 408-621-2000
San Jose, California



diff --rec --unif iptables-1.2.9/iptables.c iptables/iptables.c
--- iptables-1.2.9/iptables.c	Sat Jun 14 22:39:35 2003
+++ iptables/iptables.c	Tue May 25 03:24:11 2004
@@ -25,6 +25,7 @@
  *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define _GNU_SOURCE
 #include <getopt.h>
 #include <string.h>
 #include <netdb.h>
@@ -238,6 +239,16 @@
 	{ "all", 0 },
 };
 
+
+static const char * ipt_lib_dir;
+
+static void
+read_environment(void) {
+    ipt_lib_dir = getenv("IPTABLES_LIB_DIR");
+    if (ipt_lib_dir == NULL)
+        ipt_lib_dir = IPT_LIB_DIR;
+}
+
 static char *
 proto_to_name(u_int8_t proto, int nolookup)
 {
@@ -658,6 +669,19 @@
 	}
 }
 
+static void *
+dlopen_lib(const char * const name) {
+
+    void * handle;
+    char *path;
+    asprintf(&path, "%s/libipt_%s.so", ipt_lib_dir, name);
+    if (path == NULL)
+        exit_error(PARAMETER_PROBLEM, "out of memory");
+    handle = dlopen(path, RTLD_NOW);
+    free(path);
+    return handle;
+}
+
 struct iptables_match *
 find_match(const char *name, enum ipt_tryload tryload)
 {
@@ -670,10 +694,7 @@
 
 #ifndef NO_SHARED_LIBS
 	if (!ptr && tryload != DONT_LOAD) {
-		char path[sizeof(IPT_LIB_DIR) + sizeof("/libipt_.so")
-			 + strlen(name)];
-		sprintf(path, IPT_LIB_DIR "/libipt_%s.so", name);
-		if (dlopen(path, RTLD_NOW)) {
+        if (dlopen_lib(name)) {
 			/* Found library.  If it didn't register itself,
 			   maybe they specified target as match. */
 			ptr = find_match(name, DONT_LOAD);
@@ -946,10 +967,7 @@
 
 #ifndef NO_SHARED_LIBS
 	if (!ptr && tryload != DONT_LOAD) {
-		char path[sizeof(IPT_LIB_DIR) + sizeof("/libipt_.so")
-			 + strlen(name)];
-		sprintf(path, IPT_LIB_DIR "/libipt_%s.so", name);
-		if (dlopen(path, RTLD_NOW)) {
+		if (dlopen_lib(name)) {
 			/* Found library.  If it didn't register itself,
 			   maybe they specified match as a target. */
 			ptr = find_target(name, DONT_LOAD);
@@ -1668,6 +1686,8 @@
 	char *protocol = NULL;
 	const char *modprobe = NULL;
 	int proto_used = 0;
+
+    read_environment();
 
 	memset(&fw, 0, sizeof(fw));
 
