From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]   Condition match - error while parsing parameters
Date: Sat, 15 Mar 2003 10:15:37 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E734399.9050709@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_rMllxklZw7/qgeDtQrIuqg)"
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

This is a multi-part message in MIME format.

--Boundary_(ID_rMllxklZw7/qgeDtQrIuqg)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Folks,

   here are two small patches that fix a parsing error.  The error made 
the condition match module think that multiple conditions were specified 
on the iptables command line.

Stephane Ouellette.


--Boundary_(ID_rMllxklZw7/qgeDtQrIuqg)
Content-type: text/plain; name=libip6t_condition.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_condition.c.patch

--- netfilter.orig/userspace/extensions/libip6t_condition.c	Sat Mar 15 10:04:36 2003
+++ netfilter/userspace/extensions/libip6t_condition.c	Sat Mar 15 10:05:27 2003
@@ -41,11 +41,11 @@
 
 	check_inverse(optarg, &invert, &optind, 0);
 
-	if (*flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "Can't specify multiple conditions");
-
 	if (c == 'X') {
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify multiple conditions");
+
 		if (strlen(argv[optind - 1]) < CONDITION6_NAME_LEN)
 			strcpy(info->name, argv[optind - 1]);
 		else

--Boundary_(ID_rMllxklZw7/qgeDtQrIuqg)
Content-type: text/plain; name=libipt_condition.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libipt_condition.c.patch

--- netfilter.orig/userspace/extensions/libipt_condition.c	Sat Mar 15 10:04:36 2003
+++ netfilter/userspace/extensions/libipt_condition.c	Sat Mar 15 10:05:20 2003
@@ -41,11 +41,11 @@
 
 	check_inverse(optarg, &invert, &optind, 0);
 
-	if (*flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "Can't specify multiple conditions");
-
 	if (c == 'X') {
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify multiple conditions");
+
 		if (strlen(argv[optind - 1]) < CONDITION_NAME_LEN)
 			strcpy(info->name, argv[optind - 1]);
 		else

--Boundary_(ID_rMllxklZw7/qgeDtQrIuqg)--
