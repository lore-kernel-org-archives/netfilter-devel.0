From: =?iso-8859-2?Q?Jaros=B3aw?= Pyszny <arghil@tlen.pl>
Subject: [PATCH]70_expect-evict-order.patch (cosmetic patch)
Date: 08 Nov 2003 14:08:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1068296896.18243.28.camel@lx.siec>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-xZ4m7b/Mbf3s7w2QzooO"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-xZ4m7b/Mbf3s7w2QzooO
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

s/whcih/which/ in *.help files
Jarek
-- 
8  \\|||//  Jaroslaw J. Pyszny <arghil@tlen.pl>
b   (o|o)    AUROX Linux developer ("Vitae,non scholae,discimus")
i  --\_/--   Linux user: #96704    (http://counter.li.org)
t =-> 8-bit. komputer(y) - daj znac jesli chcesz sie pozbyc <-=

--=-xZ4m7b/Mbf3s7w2QzooO
Content-Disposition: attachment; filename=expect-evict-order.diff
Content-Type: text/x-patch; name=expect-evict-order.diff; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

diff -urN netfilter/patch-o-matic/pending/70_expect-evict-order.patch.help netfilter.new/patch-o-matic/pending/70_expect-evict-order.patch.help
--- netfilter/patch-o-matic/pending/70_expect-evict-order.patch.help	2003-09-30 21:54:16.000000000 +0200
+++ netfilter.new/patch-o-matic/pending/70_expect-evict-order.patch.help	2003-11-08 14:04:01.000000000 +0100
@@ -1,7 +1,7 @@
 Author: Patrick McHardy <kaber@trash.net>
 Status: Pending for kernel inclusion, needs testing
 
-This patch fixes the order in whcih expectations are evicted when a helper
+This patch fixes the order in which expectations are evicted when a helper
 specifies IP_CT_HELPER_F_REUSE_EXPECT.  Prior to that patch, each new
 expectation is added at the beginning of the masters sibling list.  When
 max_expected is reached, the first non-established one on the list is reused
diff -urN netfilter/patch-o-matic_2.5/pending/70_expect-evict-order.patch.help netfilter.new/patch-o-matic_2.5/pending/70_expect-evict-order.patch.help
--- netfilter/patch-o-matic_2.5/pending/70_expect-evict-order.patch.help	2003-09-30 21:54:16.000000000 +0200
+++ netfilter.new/patch-o-matic_2.5/pending/70_expect-evict-order.patch.help	2003-11-08 14:03:53.000000000 +0100
@@ -1,7 +1,7 @@
 Author: Patrick McHardy <kaber@trash.net>
 Status: Pending for kernel inclusion, needs testing
 
-This patch fixes the order in whcih expectations are evicted when a helper
+This patch fixes the order in which expectations are evicted when a helper
 specifies IP_CT_HELPER_F_REUSE_EXPECT.  Prior to that patch, each new
 expectation is added at the beginning of the masters sibling list.  When
 max_expected is reached, the first non-established one on the list is reused

--=-xZ4m7b/Mbf3s7w2QzooO--
