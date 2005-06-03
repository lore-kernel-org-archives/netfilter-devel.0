From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [IPTABLES PATCH] chain name should not start with '!'
Date: Fri, 03 Jun 2005 17:03:44 +0900 (JST)
Message-ID: <200506030803.j5383iXf006561@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Jun__3_17:03:44_2005_682)--"
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

----Next_Part(Fri_Jun__3_17:03:44_2005_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

This patch fixes the bug allows to create the chain with name "!".

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Fri_Jun__3_17:03:44_2005_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="iptables.patch"

Index: iptables.c
===================================================================
--- iptables.c	(revision 3951)
+++ iptables.c	(working copy)
@@ -1925,10 +1925,10 @@
 			break;
 
 		case 'N':
-			if (optarg && *optarg == '-')
+			if (optarg && (*optarg == '-' || *optarg == '!'))
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
-					   "with `-'\n");
+					   "with `%c'\n", *optarg);
 			if (find_target(optarg, TRY_LOAD))
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "

----Next_Part(Fri_Jun__3_17:03:44_2005_682)----
