From: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Subject: iptables dstlimit patch
Date: Mon, 1 Mar 2004 11:25:39 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58L.0403011124180.12185@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter developmnet mailing list <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

I try to compile libipt_dstlimit module, and I found small typo: missing "R"

here is patch:
--- iptables-1.2.9-20040229/extensions/libipt_dstlimit.c.org	2004-02-22 21:37:40.000000000 +0100
+++ iptables-1.2.9-20040229/extensions/libipt_dstlimit.c	2004-03-01 11:21:16.561749672 +0100
@@ -295,7 +295,7 @@
 		printf("htable-size %u ", r->cfg.size);
 	if (r->cfg.max)
 		printf("htable-max %u ", r->cfg.max);
-	if (r->cfg.gc_interval != IPT_DSTLIMIT_GCINTEVAL)
+	if (r->cfg.gc_interval != IPT_DSTLIMIT_GCINTERVAL)
 		printf("htable-gcinterval %u ", r->cfg.gc_interval);
 	if (r->cfg.expire != IPT_DSTLIMIT_EXPIRE)
 		printf("htable-expire %u ", r->cfg.expire);

-- 
{Wojciech 'Sas' Cieciwa}  {Member of PLD Team                               }
{e-mail: cieciwa@alpha.zarz.agh.edu.pl, http://www2.zarz.agh.edu.pl/~cieciwa}
