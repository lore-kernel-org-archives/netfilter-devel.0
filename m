From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]: invalid port number in libipt_MASQUERADE.c
Date: Thu, 30 Oct 2003 14:36:26 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310300536.OAA14264@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Thu_Oct_30_14:36:26_2003_460)--"
Content-Transfer-Encoding: 7bit
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

----Next_Part(Thu_Oct_30_14:36:26_2003_460)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

This small patch fixes the bug that allows
	iptables -t nat -I POSTROUTING -p tcp -j MASQUERADE --to-port -1
	                                                             ^^^^
----------------------------------------
Yasuyuki KOZAKAI

Communication Platform Laboratory,
Corporate Research & Development Center,
Toshiba Corporation

yasuyuki.kozakai@toshiba.co.jp
----------------------------------------


----Next_Part(Thu_Oct_30_14:36:26_2003_460)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="libipt_MASQUERADE-invalid-port.patch"

--- userspace.orig/extensions/libipt_MASQUERADE.c	2003-10-29 06:49:32.000000000 +0900
+++ userspace/extensions/libipt_MASQUERADE.c	2003-10-29 18:36:41.000000000 +0900
@@ -47,7 +47,7 @@
 	mr->range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
 	port = atoi(arg);
-	if (port == 0 || port > 65535)
+	if (port <= 0 || port > 65535)
 		exit_error(PARAMETER_PROBLEM, "Port `%s' not valid\n", arg);
 
 	dash = strchr(arg, '-');

----Next_Part(Thu_Oct_30_14:36:26_2003_460)----
