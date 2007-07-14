From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: iptables 1.3.7 doesn't properly test for condition patch
Date: Sun, 15 Jul 2007 00:17:49 +0200
Message-ID: <200707150017.50497.max@nucleus.it>
References: <bgel53lion8nqn77p455vughf1071fgple@4ax.com>
	<Pine.LNX.4.61.0705292230480.11140@yvahk01.tjqt.qr>
	<465D9778.1090005@netfilter.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_OuUmGYVQYmHE8IS"
Cc: Netfilter Mailing List <netfilter@lists.netfilter.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Andrew Schulman <andrex@alumni.utexas.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <465D9778.1090005@netfilter.org>
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

--Boundary-00=_OuUmGYVQYmHE8IS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 30 May 2007, Pablo Neira Ayuso wrote:

> Jan Engelhardt wrote:
> > cc nf-dev
> >
> > On May 29 2007 06:34, Andrew Schulman wrote:
> >> For the archive, Massimilano Hofer sent me the attached patch, which
> >> solves the problem.  It seems that this patch should be merged into
> >> iptables.
>
> I don't find this patch in the archives, did it get lost or never post
> it to netfilter-devel? Massimiliano?

Sorry for the dalay. I couldn't read the mailing list in the last several 
weeks.
I sent my patch several months ago, but received no reply. I suppose it got 
lost in the noise.
I attach it again. Just a few fixes and a little tidying.

I have no objections to Jan's variants. Choose the one you like better.

-- 
Saluti,
   Massimiliano Hofer

--Boundary-00=_OuUmGYVQYmHE8IS
Content-Type: text/x-diff; charset="iso-8859-1";
	name="iptables-xt_condition.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="iptables-xt_condition.patch"

diff -Nru iptables-1.3.5-20060922.orig/extensions/.condition-test iptables-1.3.5-20060922.new/extensions/.condition-test
--- iptables-1.3.5-20060922.orig/extensions/.condition-test	2002-11-02 16:00:15.000000000 +0100
+++ iptables-1.3.5-20060922.new/extensions/.condition-test	2006-09-26 12:56:01.000000000 +0200
@@ -1,3 +1,5 @@
 #!/bin/sh
 # True if condition is applied.
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h ] && echo condition
+( [ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h ] ||
+  [ -f $KERNEL_DIR/include/linux/netfilter/xt_condition.h ] ) &&
+ echo condition
diff -Nru iptables-1.3.5-20060922.orig/extensions/.condition-test6 iptables-1.3.5-20060922.new/extensions/.condition-test6
--- iptables-1.3.5-20060922.orig/extensions/.condition-test6	2003-02-25 12:54:56.000000000 +0100
+++ iptables-1.3.5-20060922.new/extensions/.condition-test6	2006-09-26 12:55:23.000000000 +0200
@@ -1,3 +1,5 @@
 #!/bin/sh
 # True if condition6 is applied.
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_condition.h ] && echo condition
+( [ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_condition.h ] ||
+  [ -f $KERNEL_DIR/include/linux/netfilter/xt_condition.h ] ) &&
+ echo condition
diff -Nru iptables-1.3.5-20060922.orig/extensions/libip6t_condition.c iptables-1.3.5-20060922.new/extensions/libip6t_condition.c
--- iptables-1.3.5-20060922.orig/extensions/libip6t_condition.c	2005-02-14 14:13:04.000000000 +0100
+++ iptables-1.3.5-20060922.new/extensions/libip6t_condition.c	2006-09-26 13:04:09.000000000 +0200
@@ -6,7 +6,14 @@
 #include <ip6tables.h>
 
 #include<linux/netfilter_ipv6/ip6_tables.h>
+
+#ifndef _X_TABLES_H
 #include<linux/netfilter_ipv6/ip6t_condition.h>
+#define condition_info condition6_info
+#define CONDITION_NAME_LEN CONDITION6_NAME_LEN
+#else
+#include<linux/netfilter/xt_condition.h>
+#endif
 
 
 static void
@@ -29,8 +36,12 @@
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
@@ -39,12 +50,26 @@
 
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
@@ -67,8 +92,8 @@
 print(const struct ip6t_ip6 *ip,
 		  const struct ip6t_entry_match *match, int numeric)
 {
-	const struct condition6_info *info =
-	    (const struct condition6_info *) match->data;
+	const struct condition_info *info =
+	    (const struct condition_info *) match->data;
 
 	printf("condition %s%s ", (info->invert) ? "!" : "", info->name);
 }
@@ -78,8 +103,8 @@
 save(const struct ip6t_ip6 *ip,
 		 const struct ip6t_entry_match *match)
 {
-	const struct condition6_info *info =
-	    (const struct condition6_info *) match->data;
+	const struct condition_info *info =
+	    (const struct condition_info *) match->data;
 
 	printf("--condition %s\"%s\" ", (info->invert) ? "! " : "", info->name);
 }
@@ -88,8 +113,8 @@
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
diff -Nru iptables-1.3.5-20060922.orig/extensions/libip6t_condition.man iptables-1.3.5-20060922.new/extensions/libip6t_condition.man
--- iptables-1.3.5-20060922.orig/extensions/libip6t_condition.man	2006-01-30 09:50:09.000000000 +0100
+++ iptables-1.3.5-20060922.new/extensions/libip6t_condition.man	2006-09-26 09:31:40.000000000 +0200
@@ -1,4 +1,4 @@
 This matches if a specific /proc filename is '0' or '1'.
 .TP
 .BR "--condition " "[!] \fIfilename"
-Match on boolean value stored in /proc/net/ip6t_condition/filename file
+Match on boolean value stored in /proc/net/nf_condition/filename file
diff -Nru iptables-1.3.5-20060922.orig/extensions/libipt_condition.c iptables-1.3.5-20060922.new/extensions/libipt_condition.c
--- iptables-1.3.5-20060922.orig/extensions/libipt_condition.c	2005-02-14 14:13:04.000000000 +0100
+++ iptables-1.3.5-20060922.new/extensions/libipt_condition.c	2006-09-26 12:01:57.000000000 +0200
@@ -6,7 +6,12 @@
 #include <iptables.h>
 
 #include<linux/netfilter_ipv4/ip_tables.h>
+
+#ifndef _X_TABLES_H
 #include<linux/netfilter_ipv4/ipt_condition.h>
+#else
+#include<linux/netfilter/xt_condition.h>
+#endif
 
 
 static void
@@ -29,6 +34,10 @@
       const struct ipt_entry *entry, unsigned int *nfcache,
       struct ipt_entry_match **match)
 {
+	static const char * const forbidden_names[]={ "", ".", ".." };
+	const char *name;
+	int i;
+
 	struct condition_info *info =
 	    (struct condition_info *) (*match)->data;
 
@@ -39,12 +48,26 @@
 
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
diff -Nru iptables-1.3.5-20060922.orig/extensions/libipt_condition.man iptables-1.3.5-20060922.new/extensions/libipt_condition.man
--- iptables-1.3.5-20060922.orig/extensions/libipt_condition.man	2006-01-30 09:50:09.000000000 +0100
+++ iptables-1.3.5-20060922.new/extensions/libipt_condition.man	2006-09-26 09:31:42.000000000 +0200
@@ -1,4 +1,4 @@
 This matches if a specific /proc filename is '0' or '1'.
 .TP
 .BI "--condition " "[!] \fIfilename\fP"
-Match on boolean value stored in /proc/net/ipt_condition/filename file
+Match on boolean value stored in /proc/net/nf_condition/filename file

--Boundary-00=_OuUmGYVQYmHE8IS--
