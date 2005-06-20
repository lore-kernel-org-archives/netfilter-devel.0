From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH IPTABLES] negative port value of SNAT/DNAT.
Date: Mon, 20 Jun 2005 18:22:28 +0900 (JST)
Message-ID: <200506200922.j5K9MSIe012936@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Jun_20_18:22:28_2005_844)--"
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

----Next_Part(Mon_Jun_20_18:22:28_2005_844)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

This patch prevents user to set negative port value of SNAT/DNAT.

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Mon_Jun_20_18:22:28_2005_844)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdnat.patch"

Index: extensions/libipt_SNAT.c
===================================================================
--- extensions/libipt_SNAT.c	(revision 3958)
+++ extensions/libipt_SNAT.c	(working copy)
@@ -73,7 +73,7 @@
 		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
 		port = atoi(colon+1);
-		if (port == 0 || port > 65535)
+		if (port <= 0 || port > 65535)
 			exit_error(PARAMETER_PROBLEM,
 				   "Port `%s' not valid\n", colon+1);
 
@@ -91,7 +91,7 @@
 			int maxport;
 
 			maxport = atoi(dash + 1);
-			if (maxport == 0 || maxport > 65535)
+			if (maxport <= 0 || maxport > 65535)
 				exit_error(PARAMETER_PROBLEM,
 					   "Port `%s' not valid\n", dash+1);
 			if (maxport < port)
Index: extensions/libipt_DNAT.c
===================================================================
--- extensions/libipt_DNAT.c	(revision 3958)
+++ extensions/libipt_DNAT.c	(working copy)
@@ -73,7 +73,7 @@
 		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
 		port = atoi(colon+1);
-		if (port == 0 || port > 65535)
+		if (port <= 0 || port > 65535)
 			exit_error(PARAMETER_PROBLEM,
 				   "Port `%s' not valid\n", colon+1);
 
@@ -91,7 +91,7 @@
 			int maxport;
 
 			maxport = atoi(dash + 1);
-			if (maxport == 0 || maxport > 65535)
+			if (maxport <= 0 || maxport > 65535)
 				exit_error(PARAMETER_PROBLEM,
 					   "Port `%s' not valid\n", dash+1);
 			if (maxport < port)

----Next_Part(Mon_Jun_20_18:22:28_2005_844)----
