From: Massimiliano Hofer <max@nucleus.it>
Subject: patch for iptables
Date: Tue, 22 Aug 2006 16:34:13 +0200
Message-ID: <200608221634.13559.max@nucleus.it>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_lXx6Et5mEz5t2Qo"
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

--Boundary-00=_lXx6Et5mEz5t2Qo
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
I was so careful testing my new version of condition for binary compatiblity 
that I didnt't notice it breaks recompilation of the userspace utilities. :)

Here is a patch that uses the new include for the XT version. While I was at 
it, I updated the sanity checks in order to match the module ones.

One caveat: I break compatibility with older kernels that don't have XT. 
What's the policy for backward compatibility in iptables? Shall I put a few 
#ifdefs?

-- 
Saluti,
   Massimiliano Hofer

--Boundary-00=_lXx6Et5mEz5t2Qo
Content-Type: text/x-diff; charset="us-ascii";
	name="iptables-1.3.5-20060820-xt_condition.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="iptables-1.3.5-20060820-xt_condition.patch"

diff -Nru iptables-1.3.5-20060820.orig/extensions/.condition-test iptables-1.3.5-20060820/extensions/.condition-test
--- iptables-1.3.5-20060820.orig/extensions/.condition-test	2006-08-21 02:22:24.000000000 +0200
+++ iptables-1.3.5-20060820/extensions/.condition-test	2006-08-21 02:39:15.000000000 +0200
@@ -1,3 +1,3 @@
 #!/bin/sh
 # True if condition is applied.
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h ] && echo condition
+[ -f $KERNEL_DIR/include/linux/netfilter/xt_condition.h ] && echo condition
diff -Nru iptables-1.3.5-20060820.orig/extensions/.condition-test6 iptables-1.3.5-20060820/extensions/.condition-test6
--- iptables-1.3.5-20060820.orig/extensions/.condition-test6	2006-08-21 02:22:25.000000000 +0200
+++ iptables-1.3.5-20060820/extensions/.condition-test6	2006-08-21 02:39:27.000000000 +0200
@@ -1,3 +1,3 @@
 #!/bin/sh
 # True if condition6 is applied.
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_condition.h ] && echo condition
+[ -f $KERNEL_DIR/include/linux/netfilter/xt_condition.h ] && echo condition
diff -Nru iptables-1.3.5-20060820.orig/extensions/libip6t_condition.c iptables-1.3.5-20060820/extensions/libip6t_condition.c
--- iptables-1.3.5-20060820.orig/extensions/libip6t_condition.c	2006-08-21 02:22:25.000000000 +0200
+++ iptables-1.3.5-20060820/extensions/libip6t_condition.c	2006-08-21 03:24:13.000000000 +0200
@@ -5,8 +5,7 @@
 #include <getopt.h>
 #include <ip6tables.h>
 
-#include<linux/netfilter_ipv6/ip6_tables.h>
-#include<linux/netfilter_ipv6/ip6t_condition.h>
+#include<linux/netfilter/xt_condition.h>
 
 
 static void
@@ -29,8 +28,12 @@
       const struct ip6t_entry *entry, unsigned int *nfcache,
       struct ip6t_entry_match **match)
 {
-	struct condition6_info *info =
-	    (struct condition6_info *) (*match)->data;
+	static const char * const forbidden_names[]={ "", ".", ".." };
+	const char *name;
+	int i;
+
+	struct condition_info *info =
+	    (struct condition_info *) (*match)->data;
 
 	if (c == 'X') {
 		if (*flags)
@@ -39,12 +42,26 @@
 
 		check_inverse(optarg, &invert, &optind, 0);
 
-		if (strlen(argv[optind - 1]) < CONDITION6_NAME_LEN)
-			strcpy(info->name, argv[optind - 1]);
-		else
+		name = argv[optind - 1];
+		/* We don't want a '/' in a proc file name. */
+		for (i=0; i < CONDITION_NAME_LEN && name[i] != '\0'; i++)
+			if (name[i] == '/')
+				exit_error(PARAMETER_PROBLEM,
+					   "Can't have a '/' in a condition name");
+
+		/* We can't handle file names longer than CONDITION_NAME_LEN and */
+		/* we want a NULL terminated string. */
+		if (i == CONDITION_NAME_LEN)
 			exit_error(PARAMETER_PROBLEM,
 				   "File name too long");
 
+		/* We don't want certain reserved names. */
+		for (i=0; i < sizeof(forbidden_names)/sizeof(char *); i++)
+			if(strcmp(name, forbidden_names[i])==0)
+				exit_error(PARAMETER_PROBLEM,
+					   "Forbidden condition name");
+
+		strcpy(info->name, name);
 		info->invert = invert;
 		*flags = 1;
 		return 1;
@@ -67,8 +84,8 @@
 print(const struct ip6t_ip6 *ip,
 		  const struct ip6t_entry_match *match, int numeric)
 {
-	const struct condition6_info *info =
-	    (const struct condition6_info *) match->data;
+	const struct condition_info *info =
+	    (const struct condition_info *) match->data;
 
 	printf("condition %s%s ", (info->invert) ? "!" : "", info->name);
 }
@@ -78,8 +95,8 @@
 save(const struct ip6t_ip6 *ip,
 		 const struct ip6t_entry_match *match)
 {
-	const struct condition6_info *info =
-	    (const struct condition6_info *) match->data;
+	const struct condition_info *info =
+	    (const struct condition_info *) match->data;
 
 	printf("--condition %s\"%s\" ", (info->invert) ? "! " : "", info->name);
 }
@@ -88,8 +105,8 @@
 static struct ip6tables_match condition = {
 	.name = "condition",
 	.version = IPTABLES_VERSION,
-	.size = IP6T_ALIGN(sizeof(struct condition6_info)),
-	.userspacesize = IP6T_ALIGN(sizeof(struct condition6_info)),
+	.size = IP6T_ALIGN(sizeof(struct condition_info)),
+	.userspacesize = IP6T_ALIGN(sizeof(struct condition_info)),
 	.help = &help,
 	.parse = &parse,
 	.final_check = &final_check,
diff -Nru iptables-1.3.5-20060820.orig/extensions/libipt_condition.c iptables-1.3.5-20060820/extensions/libipt_condition.c
--- iptables-1.3.5-20060820.orig/extensions/libipt_condition.c	2006-08-21 02:22:24.000000000 +0200
+++ iptables-1.3.5-20060820/extensions/libipt_condition.c	2006-08-21 03:18:01.000000000 +0200
@@ -5,8 +5,7 @@
 #include <getopt.h>
 #include <iptables.h>
 
-#include<linux/netfilter_ipv4/ip_tables.h>
-#include<linux/netfilter_ipv4/ipt_condition.h>
+#include<linux/netfilter/xt_condition.h>
 
 
 static void
@@ -29,6 +28,10 @@
       const struct ipt_entry *entry, unsigned int *nfcache,
       struct ipt_entry_match **match)
 {
+	static const char * const forbidden_names[]={ "", ".", ".." };
+	const char *name;
+	int i;
+
 	struct condition_info *info =
 	    (struct condition_info *) (*match)->data;
 
@@ -39,12 +42,26 @@
 
 		check_inverse(optarg, &invert, &optind, 0);
 
-		if (strlen(argv[optind - 1]) < CONDITION_NAME_LEN)
-			strcpy(info->name, argv[optind - 1]);
-		else
+		name = argv[optind - 1];
+		/* We don't want a '/' in a proc file name. */
+		for (i=0; i < CONDITION_NAME_LEN && name[i] != '\0'; i++)
+			if (name[i] == '/')
+				exit_error(PARAMETER_PROBLEM,
+					   "Can't have a '/' in a condition name");
+
+		/* We can't handle file names longer than CONDITION_NAME_LEN and */
+		/* we want a NULL terminated string. */
+		if (i == CONDITION_NAME_LEN)
 			exit_error(PARAMETER_PROBLEM,
 				   "File name too long");
 
+		/* We don't want certain reserved names. */
+		for (i=0; i < sizeof(forbidden_names)/sizeof(char *); i++)
+			if(strcmp(name, forbidden_names[i])==0)
+				exit_error(PARAMETER_PROBLEM,
+					   "Forbidden condition name");
+
+		strcpy(info->name, name);
 		info->invert = invert;
 		*flags = 1;
 		return 1;
diff -Nru iptables-1.3.5-20060820.orig/include/linux/netfilter/xt_condition.h iptables-1.3.5-20060820/include/linux/netfilter/xt_condition.h
--- iptables-1.3.5-20060820.orig/include/linux/netfilter/xt_condition.h	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.5-20060820/include/linux/netfilter/xt_condition.h	2006-08-21 02:37:54.000000000 +0200
@@ -0,0 +1,11 @@
+#ifndef _XT_CONDITION_H
+#define _XT_CONDITION_H
+
+#define CONDITION_NAME_LEN  32
+
+struct condition_info {
+	char name[CONDITION_NAME_LEN];
+	int  invert;
+};
+
+#endif /* _XT_CONDITION_H */

--Boundary-00=_lXx6Et5mEz5t2Qo--
