From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] ipt_time support for 2.6.21
Date: Thu, 26 Apr 2007 14:14:33 +0200
Message-ID: <200704261414.33473.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_peJMG20DiVICk2B"
Cc: netfilter-devel@lists.netfilter.org
To: Fabrice MARIE <fabrice@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

--Boundary-00=_peJMG20DiVICk2B
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Fabrice,

attached is a patch to add kernel 2.6.21 support to ipt_time.

Best regards,
Thomas Jarosch

--Boundary-00=_peJMG20DiVICk2B
Content-Type: text/x-diff; charset="iso-8859-1";
	name="pom-time-fix-2.6.21.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pom-time-fix-2.6.21.patch"

Signed-Off: Thomas Jarosch <thomas.jarosch@intra2net.com>

diff -u -r -p time.old/linux-2.6/net/ipv4/netfilter/ipt_time.c time/linux-2.6/net/ipv4/netfilter/ipt_time.c
--- time.old/linux-2.6/net/ipv4/netfilter/ipt_time.c	Tue Mar  6 15:01:42 2007
+++ time/linux-2.6/net/ipv4/netfilter/ipt_time.c	Thu Apr 26 13:39:53 2007
@@ -126,9 +126,16 @@ checkentry(const char *tablename,
 	return 1;
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
+static struct xt_match time_match = {
+#else
 static struct ipt_match time_match = {
+#endif
 	.name		= "time",
 	.match		= &match,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
+	.family         = AF_INET,
+#endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
 	.matchsize      = sizeof(struct ipt_time_info),
 #endif
@@ -139,12 +146,20 @@ static struct ipt_match time_match = {
 static int __init init(void)
 {
 	printk("ipt_time loading\n");
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
+	return xt_register_match(&time_match);
+#else
 	return ipt_register_match(&time_match);
+#endif
 }
 
 static void __exit fini(void)
 {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
+	xt_unregister_match(&time_match);
+#else
 	ipt_unregister_match(&time_match);
+#endif
 	printk("ipt_time unloaded\n");
 }
 

--Boundary-00=_peJMG20DiVICk2B--
