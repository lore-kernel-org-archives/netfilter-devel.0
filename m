From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 6/7] ipt_time compile fix for 2.6.21
Date: Sat, 7 Apr 2007 20:50:22 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704072050120.22181__39917.3723454171$1177663062$gmane$org@yvahk01.tjqt.qr>
References: <8d158e1f0704070955x2bb50060ueb8d2c0b91acba00@mail.gmail.com>
	<Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Mailing List <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
ReSent-Message-ID: <Pine.LNX.4.61.0704271032100.506@yvahk01.tjqt.qr>
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


Fix compilation of ipt_time.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/net/ipv4/netfilter/ipt_time.c
===================================================================
--- linux-2.6.21-rc5.orig/net/ipv4/netfilter/ipt_time.c
+++ linux-2.6.21-rc5/net/ipv4/netfilter/ipt_time.c
@@ -97,7 +97,6 @@ checkentry(const char *tablename,
             const struct xt_match *match,
 #endif
            void *matchinfo,
-           unsigned int matchsize,
            unsigned int hook_mask)
 {
 	struct ipt_time_info *info = matchinfo;   /* match info for rule */
@@ -127,9 +126,10 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct ipt_match time_match = {
+static struct xt_match time_match = {
 	.name		= "time",
 	.match		= &match,
+	.family		= AF_INET,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
 	.matchsize      = sizeof(struct ipt_time_info),
 #endif
@@ -140,12 +140,12 @@ static struct ipt_match time_match = {
 static int __init init(void)
 {
 	printk("ipt_time loading\n");
-	return ipt_register_match(&time_match);
+	return xt_register_match(&time_match);
 }
 
 static void __exit fini(void)
 {
-	ipt_unregister_match(&time_match);
+	xt_unregister_match(&time_match);
 	printk("ipt_time unloaded\n");
 }
 
