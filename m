From: Deti Fliegl <deti@fliegl.de>
Subject: Re: iptables & new CONNMARK 32bit marks
Date: Wed, 02 Nov 2005 10:25:51 +0100
Message-ID: <4368861F.6040008@fliegl.de>
References: <435D0456.60405@fliegl.de>
	<20051030094349.GZ4479@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030001010106020406010106"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051030094349.GZ4479@sunbeam.de.gnumonks.org>
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

This is a multi-part message in MIME format.
--------------030001010106020406010106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

the patch attached to this mail fixes the 32bit connmark issues on 64bit 
systems. Please could anyone test if the code is still working on 32bit 
systems?

Changes:

* replaced any occurences of ~0UL by 0xffffffff which is now platform 
independently 32bit wide.
* the ipt_connmark_target_info structure still uses long variables 
(which 64bit on 64bit systems) for mask & mark - IMHO someone should 
change this to u_int32_t if mark values are meant to be 32bit wide.
* remove any code that has to be compiled #ifdef KERNEL_64_USERSPACE_32 
as 32bit stay 32bit even on 64bit systems

Deti

--------------030001010106020406010106
Content-Type: text/x-patch;
 name="iptables-connmark-32bit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-connmark-32bit.patch"

Index: extensions/libipt_CONNMARK.c
===================================================================
--- extensions/libipt_CONNMARK.c	(revision 4421)
+++ extensions/libipt_CONNMARK.c	(working copy)
@@ -72,25 +72,17 @@
 	struct ipt_connmark_target_info *markinfo
 		= (struct ipt_connmark_target_info *)(*target)->data;
 
-#ifdef KERNEL_64_USERSPACE_32
-	markinfo->mask = ~0ULL;
-#else
-	markinfo->mask = ~0UL;
-#endif
+	markinfo->mask = 0xffffffffUL;
 
 	switch (c) {
 		char *end;
 	case '1':
 		markinfo->mode = IPT_CONNMARK_SET;
-#ifdef KERNEL_64_USERSPACE_32
-		markinfo->mark = strtoull(optarg, &end, 0);
-		if (*end == '/' && end[1] != '\0')
-		    markinfo->mask = strtoull(end+1, &end, 0);
-#else
+
 		markinfo->mark = strtoul(optarg, &end, 0);
 		if (*end == '/' && end[1] != '\0')
 		    markinfo->mask = strtoul(end+1, &end, 0);
-#endif
+
 		if (*end != '\0' || end == optarg)
 			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
 		if (*flags)
@@ -116,11 +108,8 @@
 		if (!*flags)
 			exit_error(PARAMETER_PROBLEM,
 			           "CONNMARK target: Can't specify --mask without a operation");
-#ifdef KERNEL_64_USERSPACE_32
-		markinfo->mask = strtoull(optarg, &end, 0);
-#else
 		markinfo->mask = strtoul(optarg, &end, 0);
-#endif
+
 		if (*end != '\0' || end == optarg)
 			exit_error(PARAMETER_PROBLEM, "Bad MASK value `%s'", optarg);
 		break;
@@ -139,23 +128,7 @@
 		           "CONNMARK target: No operation specified");
 }
 
-#ifdef KERNEL_64_USERSPACE_32
 static void
-print_mark(unsigned long long mark)
-{
-	printf("0x%llx", mark);
-}
-
-static void
-print_mask(const char *text, unsigned long long mask)
-{
-	if (mask != ~0ULL)
-		printf("%s0x%llx", text, mask);
-}
-
-#else
-
-static void
 print_mark(unsigned long mark)
 {
 	printf("0x%lx", mark);
@@ -164,10 +137,9 @@
 static void
 print_mask(const char *text, unsigned long mask)
 {
-	if (mask != ~0UL)
+	if (mask != 0xffffffffUL)
 		printf("%s0x%lx", text, mask);
 }
-#endif
 
 
 /* Prints out the target info. */
Index: extensions/libipt_connmark.c
===================================================================
--- extensions/libipt_connmark.c	(revision 4421)
+++ extensions/libipt_connmark.c	(working copy)
@@ -66,17 +66,13 @@
 		char *end;
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
-#ifdef KERNEL_64_USERSPACE_32
-		markinfo->mark = strtoull(optarg, &end, 0);
-		markinfo->mask = ~0ULL;
-		if (*end == '/')
-			markinfo->mask = strtoull(end+1, &end, 0);
-#else
+
 		markinfo->mark = strtoul(optarg, &end, 0);
-		markinfo->mask = ~0UL;
+		markinfo->mask = 0xffffffffUL;
+		
 		if (*end == '/')
 			markinfo->mask = strtoul(end+1, &end, 0);
-#endif
+
 		if (*end != '\0' || end == optarg)
 			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
 		if (invert)
@@ -90,25 +86,14 @@
 	return 1;
 }
 
-#ifdef KERNEL_64_USERSPACE_32
 static void
-print_mark(unsigned long long mark, unsigned long long mask, int numeric)
-{
-	if(mask != ~0ULL)
-		printf("0x%llx/0x%llx ", mark, mask);
-	else
-		printf("0x%llx ", mark);
-}
-#else
-static void
 print_mark(unsigned long mark, unsigned long mask, int numeric)
 {
-	if(mask != ~0UL)
+	if(mask != 0xffffffffUL)
 		printf("0x%lx/0x%lx ", mark, mask);
 	else
 		printf("0x%lx ", mark);
 }
-#endif
 
 /* Final check; must have specified --mark. */
 static void

--------------030001010106020406010106--
