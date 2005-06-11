From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: ipt_TTL logic error
Date: Sat, 11 Jun 2005 18:38:17 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506111837310.19655@yvahk01.tjqt.qr>
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

Hello developers,


yet another bug in POM modules. Patch is:

diff -dpru linux-2.6-AS15/net/ipv4/netfilter/ipt_TTL.c linux-2.6-AS16/net/ipv4/netfilter/ipt_TTL.c
--- linux-2.6-AS15/net/ipv4/netfilter/ipt_TTL.c	2005-05-10 19:44:50.000000000 +0200
+++ linux-2.6-AS16/net/ipv4/netfilter/ipt_TTL.c	2005-06-09 21:31:52.000000000 +0200
@@ -40,7 +40,7 @@ static unsigned int ipt_ttl_target(struc
 				new_ttl = 255;
 			break;
 		case IPT_TTL_DEC:
-			new_ttl = iph->ttl + info->ttl;
+			new_ttl = iph->ttl - info->ttl;
 			if (new_ttl < 0)
 				new_ttl = 0;
 			break;
#eof


Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
