From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH POM-NG] fix quota on SMP
Date: Tue, 12 Apr 2005 17:19:04 +0200
Message-ID: <425BE6E8.5040304@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030104080804030908060109"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------030104080804030908060109
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes quota on SMP boxes.

o 01-24.patch: For 2.4.x
o 01-26.patch: For 2.6.x
o 02kill-ip-discount.patch: quota doesn't count the size of the IP 
header on 2.6.x.
o quota-iptables.patch: iptables requires this patch to fix SMP for quota.
o x-help: remove `quota is broken on SMP' warning that isn't true anymore.

--
Pablo

--------------030104080804030908060109
Content-Type: text/x-patch;
 name="01-24.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-24.patch"

Index: linux/include/linux/netfilter_ipv4/ipt_quota.h
===================================================================
--- linux/include/linux/netfilter_ipv4/ipt_quota.h	(revision 3598)
+++ linux/include/linux/netfilter_ipv4/ipt_quota.h	(working copy)
@@ -6,6 +6,7 @@
 
 struct ipt_quota_info {
         u_int64_t quota;
+	struct ipt_quota_info *master;
 };
 
 #endif /*_IPT_QUOTA_H*/
Index: linux/net/ipv4/netfilter/ipt_quota.c
===================================================================
--- linux/net/ipv4/netfilter/ipt_quota.c	(revision 3598)
+++ linux/net/ipv4/netfilter/ipt_quota.c	(working copy)
@@ -2,6 +2,8 @@
  * netfilter module to enforce network quotas
  *
  * Sam Johnston <samj@samj.net>
+ *
+ * 30/01/05: Fixed on SMP --Pablo Neira <pablo@eurodev.net>
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
@@ -22,9 +24,9 @@
       const void *matchinfo,
       int offset, const void *hdr, u_int16_t datalen, int *hotdrop)
 {
+	struct ipt_quota_info *q =
+		((struct ipt_quota_info *) matchinfo)->master;
 
-        struct ipt_quota_info *q = (struct ipt_quota_info *) matchinfo;
-
         spin_lock_bh(&quota_lock);
 
         if (q->quota >= datalen) {
@@ -55,8 +57,13 @@
            void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
 {
         /* TODO: spinlocks? sanity checks? */
+	struct ipt_quota_info *q = (struct ipt_quota_info *) matchinfo;
+
         if (matchsize != IPT_ALIGN(sizeof (struct ipt_quota_info)))
                 return 0;
+	
+	/* For SMP, we only want to use one set of counters. */
+	q->master = q;
 
         return 1;
 }

--------------030104080804030908060109
Content-Type: text/x-patch;
 name="01-26.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-26.patch"

Index: linux-2.6/include/linux/netfilter_ipv4/ipt_quota.h
===================================================================
--- linux-2.6/include/linux/netfilter_ipv4/ipt_quota.h	(revision 3598)
+++ linux-2.6/include/linux/netfilter_ipv4/ipt_quota.h	(working copy)
@@ -6,6 +6,7 @@
 
 struct ipt_quota_info {
         u_int64_t quota;
+	struct ipt_quota_info *master;
 };
 
 #endif /*_IPT_QUOTA_H*/
Index: linux-2.6/net/ipv4/netfilter/ipt_quota.c
===================================================================
--- linux-2.6/net/ipv4/netfilter/ipt_quota.c	(revision 3598)
+++ linux-2.6/net/ipv4/netfilter/ipt_quota.c	(working copy)
@@ -2,6 +2,8 @@
  * netfilter module to enforce network quotas
  *
  * Sam Johnston <samj@samj.net>
+ *
+ * 30/01/05: Fixed on SMP --Pablo Neira <pablo@eurodev.net>
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
@@ -23,7 +25,8 @@
       const void *matchinfo,
       int offset, int *hotdrop)
 {
-        struct ipt_quota_info *q = (struct ipt_quota_info *) matchinfo;
+        struct ipt_quota_info *q = 
+		((struct ipt_quota_info *) matchinfo)->master;
 	unsigned int datalen;
 
 	if (skb->len < sizeof(struct iphdr))
@@ -61,8 +64,13 @@
            void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
 {
         /* TODO: spinlocks? sanity checks? */
+	struct ipt_quota_info *q = (struct ipt_quota_info *) matchinfo;
+
         if (matchsize != IPT_ALIGN(sizeof (struct ipt_quota_info)))
                 return 0;
+	
+	/* For SMP, we only want to use one set of counters. */
+	q->master = q;
 
         return 1;
 }

--------------030104080804030908060109
Content-Type: text/x-patch;
 name="02kill-ip-discount.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02kill-ip-discount.patch"

--- linux-2.5/net/ipv4/netfilter/ipt_quota.c.orig	2005-04-06 20:25:16.000000000 +0200
+++ linux-2.5/net/ipv4/netfilter/ipt_quota.c	2005-04-06 20:26:48.000000000 +0200
@@ -27,22 +27,19 @@
 {
         struct ipt_quota_info *q = 
 		((struct ipt_quota_info *) matchinfo)->master;
-	unsigned int datalen;
 
 	if (skb->len < sizeof(struct iphdr))
 		return NF_ACCEPT;
 	
-	datalen = skb->len - skb->nh.iph->ihl*4;
-
         spin_lock_bh(&quota_lock);
 
-        if (q->quota >= datalen) {
+        if (q->quota >= skb->len) {
                 /* we can afford this one */
-                q->quota -= datalen;
+                q->quota -= skb->len;
                 spin_unlock_bh(&quota_lock);
 
 #ifdef DEBUG_IPT_QUOTA
-                printk("IPT Quota OK: %llu datlen %d \n", q->quota, datalen);
+                printk("IPT Quota OK: %llu datlen %d \n", q->quota, skb->len);
 #endif
                 return 1;
         }
@@ -51,7 +48,7 @@
         q->quota = 0;
 
 #ifdef DEBUG_IPT_QUOTA
-        printk("IPT Quota Failed: %llu datlen %d \n", q->quota, datalen);
+        printk("IPT Quota Failed: %llu datlen %d \n", q->quota, skb->len);
 #endif
 
         spin_unlock_bh(&quota_lock);

--------------030104080804030908060109
Content-Type: text/plain;
 name="x-help"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x-help"

Index: help
===================================================================
--- help	(revision 3598)
+++ help	(working copy)
@@ -4,6 +4,3 @@
 Supported options are:
 --quota <bytes>
   The quota in bytes.
-
-KNOWN BUGS: this does not work on SMP systems.
-

--------------030104080804030908060109--
