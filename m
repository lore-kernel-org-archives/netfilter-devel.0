From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]  libipt_condition.c and libip6t_condition.c
Date: Tue, 22 Apr 2003 00:32:36 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA4C5E4.6010808@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_hwjwAQq4MLHqtkZ39+CvDQ)"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>,
 Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_hwjwAQq4MLHqtkZ39+CvDQ)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

   the following two patches move the call to check_inverse() to a saner 
place and surround the condition name by double-quotes in save().

   Please apply.

Stephane.


--Boundary_(ID_hwjwAQq4MLHqtkZ39+CvDQ)
Content-type: text/plain; name=libipt_condition.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libipt_condition.c.patch

--- netfilter-orig/userspace/extensions/libipt_condition.c	Wed Mar 26 09:42:35 2003
+++ netfilter-fixed/userspace/extensions/libipt_condition.c	Tue Apr 22 00:21:59 2003
@@ -1,3 +1,4 @@
+/* Shared library add-on to iptables for condition match */
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -39,13 +40,13 @@
 	struct condition_info *info =
 	    (struct condition_info *) (*match)->data;
 
-	check_inverse(optarg, &invert, &optind, 0);
-
 	if (c == 'X') {
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple conditions");
 
+		check_inverse(optarg, &invert, &optind, 0);
+
 		if (strlen(argv[optind - 1]) < CONDITION_NAME_LEN)
 			strcpy(info->name, argv[optind - 1]);
 		else
@@ -88,7 +89,7 @@
 	const struct condition_info *info =
 	    (const struct condition_info *) match->data;
 
-	printf("--condition %s%s ", (info->invert) ? "! " : "", info->name);
+	printf("--condition %s\"%s\" ", (info->invert) ? "! " : "", info->name);
 }
 
 

--Boundary_(ID_hwjwAQq4MLHqtkZ39+CvDQ)
Content-type: text/plain; name=libip6t_condition.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_condition.c.patch

--- netfilter-orig/userspace/extensions/libip6t_condition.c	Wed Mar 26 09:42:35 2003
+++ netfilter-fixed/userspace/extensions/libip6t_condition.c	Tue Apr 22 00:23:22 2003
@@ -1,3 +1,4 @@
+/* Shared library add-on to ip6tables for condition match */
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -39,13 +40,13 @@
 	struct condition6_info *info =
 	    (struct condition6_info *) (*match)->data;
 
-	check_inverse(optarg, &invert, &optind, 0);
-
 	if (c == 'X') {
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple conditions");
 
+		check_inverse(optarg, &invert, &optind, 0);
+
 		if (strlen(argv[optind - 1]) < CONDITION6_NAME_LEN)
 			strcpy(info->name, argv[optind - 1]);
 		else
@@ -88,7 +89,7 @@
 	const struct condition6_info *info =
 	    (const struct condition6_info *) match->data;
 
-	printf("--condition %s%s ", (info->invert) ? "! " : "", info->name);
+	printf("--condition %s\"%s\" ", (info->invert) ? "! " : "", info->name);
 }
 
 

--Boundary_(ID_hwjwAQq4MLHqtkZ39+CvDQ)--
