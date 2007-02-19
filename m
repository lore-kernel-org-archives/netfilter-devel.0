From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [RFC][PATCH][IPTABLES]: suppress the error of modprobe
Date: Mon, 19 Feb 2007 14:08:42 +0900 (JST)
Message-ID: <200702190508.l1J58hob024437@toshiba.co.jp>
References: <936822.57379.qm@web53605.mail.yahoo.com>
	<87mz3ia5ex.fsf@newton.gmurray.org.uk>
	<200702130747.l1D7lBbI027909@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: graham@gmurray.org.uk, netfilter@lists.netfilter.org, casfre@gmail.com
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200702130747.l1D7lBbI027909@toshiba.co.jp>
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


Hi, all,

Freitas Freitas and Harvey Muller reported that iptables 1.3.7 prints
"FATAL: module ip_tables not found" when ip_tables is built in the
kernel.

I found that is because iptables always tries to load ip_tables.ko before
getting the revision supported by kernel.

To suppress that, the following patch ignores the error message by modprobe
ONLY when checking revision. Instead, load_iptables_ko() tries to load
ip_tables.ko if all prior tries has failed.

Usually I don't like ignoring error message because that hides
the unexpected bugs. But do_command() can print the same error message
as ever, so I think it's not so bad in this case.

The alternative solution I thought about were as follows.

- compatible_revision() issues IPT_SO_* to check that kernel has
  ip_tables.ko or not. I think this is too much.
- compatible_revision() tries to load ip_tables.ko only when it has failed
  to get the revision from kernel at first time. It retries in that case.
  This doesn't fix issue because the 2.4 kernel with built-in ip_tables.ko
  still prints 'Fatal: ...'

developers, how do you think ?


Index: include/ip6tables.h
===================================================================
--- include/ip6tables.h	(revision 6759)
+++ include/ip6tables.h	(working copy)
@@ -174,7 +174,7 @@
 extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *), int verbose, int builtinstoo, ip6tc_handle_t *handle);
 extern int flush_entries(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
 extern int delete_chain(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
-extern int ip6tables_insmod(const char *modname, const char *modprobe);
-extern int load_ip6tables_ko(const char *modprobe);
+extern int ip6tables_insmod(const char *modname, const char *modprobe, int quit);
+extern int load_ip6tables_ko(const char *modprobe, int quit);
 
 #endif /*_IP6TABLES_USER_H*/
Index: include/iptables_common.h
===================================================================
--- include/iptables_common.h	(revision 6759)
+++ include/iptables_common.h	(working copy)
@@ -27,8 +27,8 @@
 			    unsigned long long int, 
 			    unsigned long long int,
 			    unsigned long long *);
-extern int iptables_insmod(const char *modname, const char *modprobe);
-extern int load_iptables_ko(const char *modprobe);
+extern int iptables_insmod(const char *modname, const char *modprobe, int quit);
+extern int load_iptables_ko(const char *modprobe, int quit);
 void exit_error(enum exittype, char *, ...)__attribute__((noreturn,
 							  format(printf,2,3)));
 extern const char *program_name, *program_version;
Index: iptables.c
===================================================================
--- iptables.c	(revision 6759)
+++ iptables.c	(working copy)
@@ -1149,7 +1149,7 @@
 		exit(1);
 	}
 
-	load_iptables_ko(modprobe);
+	load_iptables_ko(modprobe, 1);
 
 	strcpy(rev.name, name);
 	rev.revision = revision;
@@ -1813,10 +1813,10 @@
 	return NULL;
 }
 
-int iptables_insmod(const char *modname, const char *modprobe)
+int iptables_insmod(const char *modname, const char *modprobe, int quit)
 {
 	char *buf = NULL;
-	char *argv[3];
+	char *argv[4];
 	int status;
 
 	/* If they don't explicitly set it, read out of kernel */
@@ -1831,7 +1831,13 @@
 	case 0:
 		argv[0] = (char *)modprobe;
 		argv[1] = (char *)modname;
-		argv[2] = NULL;
+		if (quit) {
+			argv[2] = "-q";
+			argv[3] = NULL;
+		} else {
+			argv[2] = NULL;
+			argv[3] = NULL;
+		}
 		execv(argv[0], argv);
 
 		/* not usually reached */
@@ -1849,14 +1855,14 @@
 	return -1;
 }
 
-int load_iptables_ko(const char *modprobe)
+int load_iptables_ko(const char *modprobe, int quit)
 {
 	static int loaded = 0;
 	static int ret = -1;
 
 	if (!loaded) {
-		ret = iptables_insmod("ip_tables", NULL);
-		loaded = 1;
+		ret = iptables_insmod("ip_tables", NULL, quit);
+		loaded = (ret == 0);
 	}
 
 	return ret;
@@ -2442,7 +2448,7 @@
 		*handle = iptc_init(*table);
 
 	/* try to insmod the module if iptc_init failed */
-	if (!*handle && load_iptables_ko(modprobe) != -1)
+	if (!*handle && load_iptables_ko(modprobe, 0) != -1)
 		*handle = iptc_init(*table);
 
 	if (!*handle)
Index: ip6tables-restore.c
===================================================================
--- ip6tables-restore.c	(revision 6759)
+++ ip6tables-restore.c	(working copy)
@@ -62,7 +62,7 @@
 
 	if (!handle) {
 		/* try to insmod the module if iptc_init failed */
-		ip6tables_insmod("ip6_tables", modprobe);
+		ip6tables_insmod("ip6_tables", modprobe, 1);
 		handle = ip6tc_init(tablename);
 	}
 
Index: iptables-restore.c
===================================================================
--- iptables-restore.c	(revision 6759)
+++ iptables-restore.c	(working copy)
@@ -59,7 +59,7 @@
 
 	if (!handle) {
 		/* try to insmod the module if iptc_init failed */
-		iptables_insmod("ip_tables", modprobe);
+		iptables_insmod("ip_tables", modprobe, 0);
 		handle = iptc_init(tablename);
 	}
 
Index: ip6tables.c
===================================================================
--- ip6tables.c	(revision 6759)
+++ ip6tables.c	(working copy)
@@ -1126,7 +1126,7 @@
 	strcpy(rev.name, name);
 	rev.revision = revision;
 
-	load_ip6tables_ko(modprobe);
+	load_ip6tables_ko(modprobe, 1);
 
 	max_rev = getsockopt(sockfd, IPPROTO_IPV6, opt, &rev, &s);
 	if (max_rev < 0) {
@@ -1751,10 +1751,10 @@
 	return NULL;
 }
 
-int ip6tables_insmod(const char *modname, const char *modprobe)
+int ip6tables_insmod(const char *modname, const char *modprobe, int quit)
 {
 	char *buf = NULL;
-	char *argv[3];
+	char *argv[4];
 	int status;
 
 	/* If they don't explicitly set it, read out of kernel */
@@ -1769,7 +1769,13 @@
 	case 0:
 		argv[0] = (char *)modprobe;
 		argv[1] = (char *)modname;
-		argv[2] = NULL;
+		if (quit) {
+			argv[2] = "-q";
+			argv[3] = NULL;
+		} else {
+			argv[2] = NULL;
+			argv[3] = NULL;
+		}
 		execv(argv[0], argv);
 
 		/* not usually reached */
@@ -1787,14 +1793,14 @@
 	return -1;
 }
 
-int load_ip6tables_ko(const char *modprobe)
+int load_ip6tables_ko(const char *modprobe, int quit)
 {
 	static int loaded = 0;
 	static int ret = -1;
 
 	if (!loaded) {
-		ret = ip6tables_insmod("ip6_tables", modprobe);
-		loaded = 1;
+		ret = ip6tables_insmod("ip6_tables", modprobe, quit);
+		loaded = (ret == 0);
 	}
 
 	return ret;
@@ -2355,7 +2361,7 @@
 		*handle = ip6tc_init(*table);
 
 	/* try to insmod the module if iptc_init failed */
-	if (!*handle && load_ip6tables_ko(modprobe) != -1)
+	if (!*handle && load_ip6tables_ko(modprobe, 0) != -1)
 		*handle = ip6tc_init(*table);
 
 	if (!*handle)
