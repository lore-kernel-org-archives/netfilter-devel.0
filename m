From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Refuse multiple --to args in [DS]NAT
Date: Sun, 4 Sep 2005 12:40:42 -0700
Message-ID: <20050904194042.GA11196@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Kernels higher than 2.6.10 don't support multiple --to arguments in
DNAT and SNAT targets.  At present, the error is somewhat vague:

# iptables -t nat -A foo -j SNAT --to 1.2.3.4 --to 2.3.4.5
iptables: Invalid argument

But if we want current iptables to work with kernels <= 2.6.10, we
cannot simply disallow this in all cases.

So the below patch adds kernel version checking to iptables, and
utilizes it in [DS]NAT.  Now, users will see a more informative error:

# iptables -t nat -A foo -j SNAT --to 1.2.3.4 --to 2.3.4.5
iptables v1.3.3: Multiple --to-source not supported

This generic infrastructure (shamelessly lifted from procps btw) may
come in handy in the future for other changes.

This fixes bugzilla #367.

Phil



--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-multiple_to

diff -ru ipt-orig/extensions/libipt_DNAT.c ipt-new/extensions/libipt_DNAT.c
--- ipt-orig/extensions/libipt_DNAT.c	2005-07-22 05:13:50.000000000 -0700
+++ ipt-new/extensions/libipt_DNAT.c	2005-09-04 10:46:28.000000000 -0700
@@ -155,6 +155,13 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-destination");
 
+		if (*flags) {
+			if (!kernel_version)
+				get_kernel_version();
+			if (kernel_version > LINUX_VERSION(2, 6, 10))
+				exit_error(PARAMETER_PROBLEM,
+					   "Multiple --to-destination not supported");
+		}
 		*target = parse_to(optarg, portok, info);
 		*flags = 1;
 		return 1;
diff -ru ipt-orig/extensions/libipt_SNAT.c ipt-new/extensions/libipt_SNAT.c
--- ipt-orig/extensions/libipt_SNAT.c	2005-07-22 05:13:50.000000000 -0700
+++ ipt-new/extensions/libipt_SNAT.c	2005-09-04 12:28:07.000000000 -0700
@@ -155,6 +155,13 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-source");
 
+		if (*flags) {
+			if (!kernel_version)
+				get_kernel_version();
+			if (kernel_version > LINUX_VERSION(2, 6, 10))
+				exit_error(PARAMETER_PROBLEM,
+					   "Multiple --to-source not supported");
+		}
 		*target = parse_to(optarg, portok, info);
 		*flags = 1;
 		return 1;
diff -ru ipt-orig/include/iptables.h ipt-new/include/iptables.h
--- ipt-orig/include/iptables.h	2005-07-04 15:11:28.000000000 -0700
+++ ipt-new/include/iptables.h	2005-09-04 10:31:43.000000000 -0700
@@ -175,4 +175,13 @@
 			iptc_handle_t *handle);
 extern int for_each_chain(int (*fn)(const ipt_chainlabel, int, iptc_handle_t *),
 		int verbose, int builtinstoo, iptc_handle_t *handle);
+
+/* kernel revision handling */
+extern int kernel_version;
+extern void get_kernel_version(void);
+#define LINUX_VERSION(x,y,z)	(0x10000*(x) + 0x100*(y) + z)
+#define LINUX_VERSION_MAJOR(x)	(((x)>>16) & 0xFF)
+#define LINUX_VERSION_MINOR(x)	(((x)>> 8) & 0xFF)
+#define LINUX_VERSION_PATCH(x)	( (x)      & 0xFF)
+
 #endif /*_IPTABLES_USER_H*/
diff -ru ipt-orig/iptables.c ipt-new/iptables.c
--- ipt-orig/iptables.c	2005-07-29 06:06:45.000000000 -0700
+++ ipt-new/iptables.c	2005-09-04 10:38:19.000000000 -0700
@@ -39,6 +39,7 @@
 #include <iptables.h>
 #include <fcntl.h>
 #include <sys/wait.h>
+#include <sys/utsname.h>
 
 #ifndef TRUE
 #define TRUE 1
@@ -193,6 +194,8 @@
 const char *program_name;
 char *lib_dir;
 
+int kernel_version;
+
 /* Keeping track of external matches and targets: linked lists.  */
 struct iptables_match *iptables_matches = NULL;
 struct iptables_target *iptables_targets = NULL;
@@ -1804,6 +1807,21 @@
 	name[IPT_FUNCTION_MAXNAMELEN - 1] = revision;
 }
 
+void
+get_kernel_version(void) {
+	static struct utsname uts;
+	int x = 0, y = 0, z = 0;
+
+	if (uname(&uts) == -1) {
+		fprintf(stderr, "Unable to retrieve kernel version.\n");
+		free_opts(1);
+		exit(1); 
+	}
+
+	sscanf(uts.release, "%d.%d.%d", &x, &y, &z);
+	kernel_version = LINUX_VERSION(x, y, z);
+}
+
 int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 {
 	struct ipt_entry fw, *e = NULL;

--GvXjxJ+pjyke8COw--
