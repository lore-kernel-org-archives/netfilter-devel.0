From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 2/7] ipt_SYSRQ compile fix for 2.6.21
Date: Sat, 7 Apr 2007 20:49:33 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704072049130.22181__40741.2039734938$1177662836$gmane$org@yvahk01.tjqt.qr>
References: <8d158e1f0704070955x2bb50060ueb8d2c0b91acba00@mail.gmail.com>
	<Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Mailing List <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
ReSent-Message-ID: <Pine.LNX.4.61.0704271032050.506@yvahk01.tjqt.qr>
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


Fixes compilation of ipt_SYSRQ.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/net/ipv4/netfilter/ipt_SYSRQ.c
===================================================================
--- linux-2.6.21-rc5.orig/net/ipv4/netfilter/ipt_SYSRQ.c
+++ linux-2.6.21-rc5/net/ipv4/netfilter/ipt_SYSRQ.c
@@ -9,10 +9,9 @@
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 
-#include "rsysrq.h"
-
-#include "sha1.c"
-#include "rsysrq_protocol.c"
+#include "ipt_sysrq_g.h"
+#include "ipt_sysrq_sha1.c"
+#include "ipt_sysrq_protocol.c"
 
 static char *passwd = "";
 module_param(passwd,charp,0);
@@ -38,12 +37,7 @@ static int target_do( char *buf, int len
 	if( (c=rsysrq_extract((struct rsysrq_s*)buf,passwd,now.tv_sec,tolerance))==0 )
 		return(0);
 	
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	handle_sysrq(c, NULL, NULL, NULL );
-#else
-	handle_sysrq(c, NULL, NULL );
-#endif
-	
+	handle_sysrq(c, NULL);
 	return(1);
 }
 
@@ -64,8 +58,7 @@ target(struct sk_buff **pskb,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
        const struct xt_target *target,
 #endif
-       const void *targinfo,
-       void *userinfo)
+       const void *targinfo)
 #endif
 {
 	const struct iphdr *iph = (*pskb)->nh.iph;
@@ -101,14 +94,14 @@ checkentry(const char *tablename,
 	   const struct ipt_entry *e,
 #endif
            void *targinfo,
-           unsigned int targinfosize,
            unsigned int hook_mask)
 {
 	return 1;
 }
 
-static struct ipt_target ipt_sysrq_reg = {
+static struct xt_target ipt_sysrq_reg = {
         .name           = "SYSRQ",
+        .family		= AF_INET,
         .target         = target,
         .checkentry     = checkentry,
         .me             = THIS_MODULE,
@@ -120,7 +113,7 @@ static struct ipt_target ipt_sysrq_reg =
 
 static int __init init(void)
 {
-	if (ipt_register_target(&ipt_sysrq_reg))
+	if (xt_register_target(&ipt_sysrq_reg))
 		return -EINVAL;
 
 	return 0;
@@ -128,7 +121,7 @@ static int __init init(void)
 
 static void __exit fini(void)
 {
-	ipt_unregister_target(&ipt_sysrq_reg);
+	xt_unregister_target(&ipt_sysrq_reg);
 }
 
 module_init(init);
