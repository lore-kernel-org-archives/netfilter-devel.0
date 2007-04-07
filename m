From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 7/7] ipt_u32 compile fix for 2.6.21
Date: Sat, 7 Apr 2007 20:50:33 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704072050240.22181__32269.8873271749$1177663107$gmane$org@yvahk01.tjqt.qr>
References: <8d158e1f0704070955x2bb50060ueb8d2c0b91acba00@mail.gmail.com>
	<Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Mailing List <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
ReSent-Message-ID: <Pine.LNX.4.61.0704271032101.506@yvahk01.tjqt.qr>
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


Fix compilation of ipt_u32.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/net/ipv4/netfilter/ipt_u32.c
===================================================================
--- linux-2.6.21-rc5.orig/net/ipv4/netfilter/ipt_u32.c
+++ linux-2.6.21-rc5/net/ipv4/netfilter/ipt_u32.c
@@ -201,35 +201,22 @@ match(const struct sk_buff *skb,
 	return 1;
 }
 
-static int
-checkentry(const char *tablename,
-           const void *ip,
-           const struct xt_match *match,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
-{
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_u32)))
-		return 0;
-	return 1;
-}
-
-static struct ipt_match u32_match = { 
+static struct xt_match u32_match = { 
 	.name 		= "u32",
+	.family		= AF_INET,
 	.match		= &match,
 	.matchsize	= sizeof(struct ipt_u32),
-	.checkentry	= &checkentry,
 	.me		= THIS_MODULE
 };
 
 static int __init init(void)
 {
-	return ipt_register_match(&u32_match);
+	return xt_register_match(&u32_match);
 }
 
 static void __exit fini(void)
 {
-	ipt_unregister_match(&u32_match);
+	xt_unregister_match(&u32_match);
 }
 
 module_init(init);
