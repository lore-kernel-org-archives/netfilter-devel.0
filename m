From: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Subject: pool module.
Date: Tue, 17 Feb 2004 13:12:41 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58L.0402171234001.24901@alpha.zarz.agh.edu.pl>
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

Hi 

In this module, in file net/ipv4/netfilter/ip_pool.c are missing two line:
EXPORT_SYMBOL(ip_pool_mod);
EXPORT_STMBOL(ip_pool_match);

here is patch:
==========================================================
--- patch-o-matic-ng/pool/linux/net/ipv4/netfilter/ip_pool.c.org	2003-12-18 19:28:43.000000000 +0100
+++ patch-o-matic-ng/pool/linux/net/ipv4/netfilter/ip_pool.c	2004-02-17 12:43:15.000000000 +0100
@@ -67,6 +67,7 @@
 	read_unlock_bh(&pool->lock);
 	return res;
 }
+EXPORT_SYMBOL(ip_pool_match);
 
 static int pool_change(ip_pool_t index, u_int32_t addr, int isdel)
 {
@@ -95,6 +96,7 @@
 	if (!isdel) res = !res;
 	return res;
 }
+EXPORT_SYMBOL(ip_pool_mod);
 
 static inline int bitmap_bytes(u_int32_t a, u_int32_t b)
 {

-- 
{Wojciech 'Sas' Cieciwa}  {Member of PLD Team                               }
{e-mail: cieciwa@alpha.zarz.agh.edu.pl, http://www2.zarz.agh.edu.pl/~cieciwa}
