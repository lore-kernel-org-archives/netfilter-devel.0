From: Nicolas Bouliane <nib@cookinglinux.org>
Subject: [PATCH] libipt_helper
Date: Sun, 02 Jan 2005 02:35:26 -0500
Message-ID: <41D7A43E.9060903@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060005000500060008000105"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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
--------------060005000500060008000105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This trivial patch prevents from using `--helper` several time, which 
case would overwriting previous value.

Cheers :)

-acidfu

--------------060005000500060008000105
Content-Type: text/x-patch;
 name="libipt_helper.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libipt_helper.c.patch"

Index: extensions/libipt_helper.c
===================================================================
--- extensions/libipt_helper.c	(revision 3540)
+++ extensions/libipt_helper.c	(working copy)
@@ -44,6 +44,9 @@
 
 	switch (c) {
 	case '1':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+					"helper match: Only use --helper ONCE!");
 		check_inverse(optarg, &invert, &invert, 0);
 		strncpy(info->name, optarg, 29);
 		info->name[29] = '\0';

--------------060005000500060008000105--
