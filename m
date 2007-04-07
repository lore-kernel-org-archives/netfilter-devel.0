From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 1/7] ipt_ACCOUNT compile fix for 2.6.21
Date: Sat, 7 Apr 2007 20:49:11 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704072048520.22181__49403.0269016095$1177662945$gmane$org@yvahk01.tjqt.qr>
References: <8d158e1f0704070955x2bb50060ueb8d2c0b91acba00@mail.gmail.com>
	<Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Mailing List <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
ReSent-Message-ID: <Pine.LNX.4.61.0704271032040.506@yvahk01.tjqt.qr>
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


Fixes compilation of ipt_ACCOUNT.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/net/ipv4/netfilter/ipt_ACCOUNT.c
===================================================================
--- linux-2.6.21-rc5.orig/net/ipv4/netfilter/ipt_ACCOUNT.c
+++ linux-2.6.21-rc5/net/ipv4/netfilter/ipt_ACCOUNT.c
@@ -1051,8 +1051,9 @@ static int ipt_acc_get_ctl(struct sock *
     return ret;
 }
 
-static struct ipt_target ipt_acc_reg = {
+static struct xt_target ipt_acc_reg = {
     .name = "ACCOUNT",
+    .family = AF_INET,
     .target = ipt_acc_target,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
     .targetsize = sizeof(struct ipt_acc_info),
@@ -1106,7 +1107,7 @@ static int __init init(void)
         goto error_cleanup;
     }
 
-    if (ipt_register_target(&ipt_acc_reg))
+    if (xt_register_target(&ipt_acc_reg))
         goto error_cleanup;
 
     return 0;
@@ -1124,7 +1125,7 @@ error_cleanup:
 
 static void __exit fini(void)
 {
-    ipt_unregister_target(&ipt_acc_reg);
+    xt_unregister_target(&ipt_acc_reg);
 
     nf_unregister_sockopt(&ipt_acc_sockopts);
 
