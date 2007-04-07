From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 4/7] ipt_connlimit compile fix for 2.6.21
Date: Sat, 7 Apr 2007 20:49:58 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704072049490.22181__12444.5682777607$1177662887$gmane$org@yvahk01.tjqt.qr>
References: <8d158e1f0704070955x2bb50060ueb8d2c0b91acba00@mail.gmail.com>
	<Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Mailing List <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
ReSent-Message-ID: <Pine.LNX.4.61.0704271032060.506@yvahk01.tjqt.qr>
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


Fix compilation of ipt_connlimit.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/net/ipv4/netfilter/ipt_connlimit.c
===================================================================
--- linux-2.6.21-rc5.orig/net/ipv4/netfilter/ipt_connlimit.c
+++ linux-2.6.21-rc5/net/ipv4/netfilter/ipt_connlimit.c
@@ -291,8 +291,9 @@ static void destroy(
 	kfree(info->data);
 }
 
-static struct ipt_match connlimit_match = { 
+static struct xt_match connlimit_match = {
 	.name		= "connlimit",
+	.family		= AF_INET,
 	.match		= &match,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
 	.matchsize	= sizeof(struct ipt_connlimit_info),
@@ -304,12 +305,12 @@ static struct ipt_match connlimit_match 
 
 static int __init init(void)
 {
-	return ipt_register_match(&connlimit_match);
+	return xt_register_match(&connlimit_match);
 }
 
 static void __exit fini(void)
 {
-	ipt_unregister_match(&connlimit_match);
+	xt_unregister_match(&connlimit_match);
 }
 
 module_init(init);
