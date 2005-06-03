From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: TCPLAG fix
Date: Fri, 3 Jun 2005 21:50:44 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506032150090.19992@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

Hello list,


here is a small fix for a line I stumbled upon when looking through POM for 
fun. Patch is here.


diff -dpru patch-o-matic-ng-20050602~/TCPLAG/linux/net/ipv4/netfilter/ipt_TCPLAG.c patch-o-matic-ng-20050602/TCPLAG/linux/net/ipv4/netfilter/ipt_TCPLAG.c
--- patch-o-matic-ng-20050602~/TCPLAG/linux/net/ipv4/netfilter/ipt_TCPLAG.c	2003-12-18 19:47:52.000000000 +0100
+++ patch-o-matic-ng-20050602/TCPLAG/linux/net/ipv4/netfilter/ipt_TCPLAG.c	2005-06-03 21:36:24.000000000 +0200
@@ -99,7 +99,7 @@ static void divide_down( timeval_T *T, i
 	T->tv_usec /= c;
 	remainder = T->tv_sec % c; /* Only works properly with positive numbers */
 	remainder *= 1000000;
-	T->tv_usec == remainder;
+	T->tv_usec = remainder;
 	T->tv_sec /= c;
 }
 


Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
