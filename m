From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] Fix ipt_ACCOUNT for large networks - 2nd try
Date: Tue, 5 Apr 2005 09:48:51 +0200
Message-ID: <200504050948.51387.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
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

Hi Patrick,

attached is a patch to fix the ACCOUNT target for large networks.
This time for good ;-) Discard the patch I sent yesterday.

It runs stable now on a network with ~1300 active clients. Quoting the user:
"Nevertheless, from performance point of view, ipt_ACCOUNT rocks. I have a
distribution for routers (Route Hat) and last night switched from ipt_account
to ipt_ACCOUNT completely. What took half a minute before now takes 300ms
i.e. 100 times faster, same router, same net. Gr8 work :-)"

Cheers,
Thomas

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

diff -u -r -b ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c ACCOUNT.1.4/linux/net/ipv4/netfilter/ipt_ACCOUNT.c
--- ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c      2004-06-13 22:41:21.000000000 +0200
+++ ACCOUNT.1.4/linux/net/ipv4/netfilter/ipt_ACCOUNT.c  2005-04-05 09:33:52.000000000 +0200
@@ -3,7 +3,7 @@
  *   See http://www.intra2net.com/opensource/ipt_account                   *
  *   for further information                                               *
  *                                                                         *
- *   Copyright (C) 2004 by Intra2net AG                                    *
+ *   Copyright (C) 2004-2005 by Intra2net AG                               *
  *   opensource@intra2net.com                                              *
  *                                                                         *
  *   This program is free software; you can redistribute it and/or modify  *
@@ -694,7 +694,8 @@
 /* Copy 8 bit network data into a prepared buffer.
    We only copy entries != 0 to increase performance.
 */
-static int ipt_acc_handle_copy_data(void *to_user, int *pos,
+static int ipt_acc_handle_copy_data(void *to_user, u_int32_t *to_user_pos,
+                                  u_int32_t *tmpbuf_pos,
                                     struct ipt_acc_mask_24 *data,
                                     u_int32_t net_ip, u_int32_t net_OR_mask)
 {
@@ -712,13 +713,15 @@
             handle_ip.dst_bytes = data->ip[i].dst_bytes;

             /* Temporary buffer full? Flush to userspace */
-            if (*pos+handle_ip_size >= PAGE_SIZE) {
-                *pos = 0;
-                if (copy_to_user(to_user, ipt_acc_tmpbuf, *pos))
+            if (*tmpbuf_pos+handle_ip_size >= PAGE_SIZE) {
+                if (copy_to_user(to_user + *to_user_pos, ipt_acc_tmpbuf,
+                                                           *tmpbuf_pos))
                     return -EFAULT;
+                *to_user_pos = *to_user_pos + *tmpbuf_pos;
+                *tmpbuf_pos = 0;
             }
-            memcpy(ipt_acc_tmpbuf+*pos, &handle_ip, handle_ip_size);
-            *pos += handle_ip_size;
+            memcpy(ipt_acc_tmpbuf+*tmpbuf_pos, &handle_ip, handle_ip_size);
+            *tmpbuf_pos += handle_ip_size;
         }
     }

@@ -731,7 +734,7 @@
 */
 static int ipt_acc_handle_get_data(u_int32_t handle, void *to_user)
 {
-    u_int32_t tmpbuf_pos=0, net_ip;
+    u_int32_t to_user_pos=0, tmpbuf_pos=0, net_ip;
     unsigned char depth;

     if (handle >= ACCOUNT_MAX_HANDLES) {
@@ -752,12 +755,13 @@
     if (depth == 0) {
         struct ipt_acc_mask_24 *network =
             (struct ipt_acc_mask_24*)ipt_acc_handles[handle].data;
-        if (ipt_acc_handle_copy_data(to_user, &tmpbuf_pos, network, net_ip, 0))
+        if (ipt_acc_handle_copy_data(to_user, &to_user_pos, &tmpbuf_pos,
+                                     network, net_ip, 0))
             return -1;

         /* Flush remaining data to userspace */
         if (tmpbuf_pos)
-            if (copy_to_user(to_user, ipt_acc_tmpbuf, tmpbuf_pos))
+            if (copy_to_user(to_user+to_user_pos, ipt_acc_tmpbuf, tmpbuf_pos))
                 return -1;

         return 0;
@@ -772,15 +776,15 @@
             if (network_16->mask_24[b]) {
                 struct ipt_acc_mask_24 *network =
                     (struct ipt_acc_mask_24*)network_16->mask_24[b];
-                if (ipt_acc_handle_copy_data(to_user, &tmpbuf_pos, network,
-                                             net_ip, (b << 16)))
+                if (ipt_acc_handle_copy_data(to_user, &to_user_pos,
+                                      &tmpbuf_pos, network, net_ip, (b << 16)))
                     return -1;
             }
         }

         /* Flush remaining data to userspace */
         if (tmpbuf_pos)
-            if (copy_to_user(to_user, ipt_acc_tmpbuf, tmpbuf_pos))
+            if (copy_to_user(to_user+to_user_pos, ipt_acc_tmpbuf, tmpbuf_pos))
                 return -1;

         return 0;
@@ -799,7 +803,8 @@
                     if (network_16->mask_24[b]) {
                         struct ipt_acc_mask_24 *network =
                             (struct ipt_acc_mask_24*)network_16->mask_24[b];
-                        if (ipt_acc_handle_copy_data(to_user, &tmpbuf_pos,
+                        if (ipt_acc_handle_copy_data(to_user,
+                                       &to_user_pos, &tmpbuf_pos,
                                         network, net_ip, (a << 8) | (b << 16)))
                             return -1;
                     }
@@ -809,7 +814,7 @@

         /* Flush remaining data to userspace */
         if (tmpbuf_pos)
-            if (copy_to_user(to_user, ipt_acc_tmpbuf, tmpbuf_pos))
+            if (copy_to_user(to_user+to_user_pos, ipt_acc_tmpbuf, tmpbuf_pos))
                 return -1;

         return 0;
diff -u -r -b ACCOUNT/linux/include/linux/netfilter_ipv4/ipt_ACCOUNT.h ACCOUNT.1.4/linux/include/linux/netfilter_ipv4/ipt_ACCOUNT.h
--- ACCOUNT/linux/include/linux/netfilter_ipv4/ipt_ACCOUNT.h    2004-06-13 22:41:21.000000000 +0200
+++ ACCOUNT.1.4/linux/include/linux/netfilter_ipv4/ipt_ACCOUNT.h        2005-04-05 09:24:20.995818974 +0200
@@ -1,5 +1,5 @@
 /***************************************************************************
- *   Copyright (C) 2004 by Intra2net AG                                    *
+ *   Copyright (C) 2004-2005 by Intra2net AG                               *
  *   opensource@intra2net.com                                              *
  *                                                                         *
  *   This program is free software; you can redistribute it and/or modify  *
