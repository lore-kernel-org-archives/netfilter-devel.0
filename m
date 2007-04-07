From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 5/7] ipt_ipp2p compile fix for 2.6.21
Date: Sat, 7 Apr 2007 20:50:10 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704072050000.22181__25982.338973745$1177662998$gmane$org@yvahk01.tjqt.qr>
References: <8d158e1f0704070955x2bb50060ueb8d2c0b91acba00@mail.gmail.com>
	<Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Mailing List <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
ReSent-Message-ID: <Pine.LNX.4.61.0704271032070.506@yvahk01.tjqt.qr>
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


Fix compilation of ipt_ipp2p.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/net/ipv4/netfilter/ipt_ipp2p.c
===================================================================
--- linux-2.6.21-rc5.orig/net/ipv4/netfilter/ipt_ipp2p.c
+++ linux-2.6.21-rc5/net/ipv4/netfilter/ipt_ipp2p.c
@@ -831,7 +831,6 @@ checkentry(const char *tablename,
             const struct xt_match *match,
 #endif
 	    void *matchinfo,
-	    unsigned int matchsize,
 	    unsigned int hook_mask)
 {
         /* Must specify -p tcp */
@@ -845,36 +844,27 @@ checkentry(const char *tablename,
 
 
 
-static struct ipt_match ipp2p_match = { 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	{ NULL, NULL }, 
-	"ipp2p", 
-	&match, 
-	&checkentry, 
-	NULL, 
-	THIS_MODULE
-#endif
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+static struct xt_match ipp2p_match = { 
 	.name		= "ipp2p",
 	.match		= &match,
+	.family		= AF_INET,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
 	.matchsize	= sizeof(struct ipt_p2p_info),
 #endif
 	.checkentry	= &checkentry,
 	.me		= THIS_MODULE,
-#endif
 };
 
 
 static int __init init(void)
 {
     printk(KERN_INFO "IPP2P v%s loading\n", IPP2P_VERSION);
-    return ipt_register_match(&ipp2p_match);
+    return xt_register_match(&ipp2p_match);
 }
 	
 static void __exit fini(void)
 {
-    ipt_unregister_match(&ipp2p_match);
+    xt_unregister_match(&ipp2p_match);
     printk(KERN_INFO "IPP2P v%s unloaded\n", IPP2P_VERSION);    
 }
 	
