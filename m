From: Pawel Sikora <pluto@agmk.net>
Subject: [PATCH] kill build warnings in ipt_ACCOUNT.c
Date: Fri, 20 May 2005 13:52:27 +0200
Message-ID: <200505201352.27915.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_79cjCnlQxl2B3M3"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--Boundary-00=_79cjCnlQxl2B3M3
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

  CC [M]  net/ipv4/netfilter/ipt_ACCOUNT.o
net/ipv4/netfilter/ipt_ACCOUNT.c: In function 'ipt_acc_handle_prepare_read':
net/ipv4/netfilter/ipt_ACCOUNT.c:610: warning:
 ISO C90 forbids mixed declarations and code
net/ipv4/netfilter/ipt_ACCOUNT.c: At top level:
net/ipv4/netfilter/ipt_ACCOUNT.c:1024: warning:
 initialization from incompatible pointer type

-- 
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke

--Boundary-00=_79cjCnlQxl2B3M3
Content-Type: text/x-diff;
  charset="utf-8";
  name="x.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="x.diff"

Index: ipt_ACCOUNT.c
===================================================================
--- ipt_ACCOUNT.c	(wersja 3922)
+++ ipt_ACCOUNT.c	(kopia robocza)
@@ -414,9 +414,9 @@
 }
 
 static unsigned int ipt_acc_target(struct sk_buff **pskb,
-                                       unsigned int hooknum,
                                        const struct net_device *in,
                                        const struct net_device *out,
+                                       unsigned int hooknum,
                                        const void *targinfo,
                                        void *userinfo)
 {
@@ -592,7 +592,8 @@
             (struct ipt_acc_mask_8 *)ipt_acc_tables[table_nr].data;
         struct ipt_acc_mask_8 *network_8 = 
             (struct ipt_acc_mask_8 *)dest->data;
-        u_int32_t a;
+        struct ipt_acc_mask_16 *src_16, *network_16;
+        u_int32_t a, b;
 
         for (a = 0; a <= 255; a++) {
             if (src_8->mask_16[a]) {
@@ -607,9 +608,8 @@
                 memcpy(network_8->mask_16[a], src_8->mask_16[a], 
                        sizeof(struct ipt_acc_mask_16));
 
-                struct ipt_acc_mask_16 *src_16 = src_8->mask_16[a];
-                struct ipt_acc_mask_16 *network_16 = network_8->mask_16[a];
-                u_int32_t b;
+                src_16 = src_8->mask_16[a];
+                network_16 = network_8->mask_16[a];
 
                 for (b = 0; b <= 255; b++) {
                     if (src_16->mask_24[b]) {

--Boundary-00=_79cjCnlQxl2B3M3--
