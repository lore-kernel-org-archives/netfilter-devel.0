From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] fix ACCOUNT locking
Date: Fri, 15 Apr 2005 10:24:28 +0200
Message-ID: <200504151024.28858.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8o3XCQ87kWstXpF"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_8o3XCQ87kWstXpF
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

attached is a patch to fix ipt_ACCOUNT locking. ipt_ACCOUNT now works finally 
for large networks without trouble.

Repeat all after me:
I will not call copy_to_user under spinlock.
I will not call copy_to_user under spinlock.
I will not call copy_to_user under spinlock.

The patch is based upon the last patch I sent.

The full version can be found here:
http://www.intra2net.com/opensource/ipt_account/

Cheers,
Thomas

--Boundary-00=_8o3XCQ87kWstXpF
Content-Type: text/x-diff; charset="us-ascii"; name="ipt_ACCOUNT_locking.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ipt_ACCOUNT_locking.patch"

--- ipt_ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c	5 Apr 2005 07:34:37 -0000	1.31
+++ ipt_ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c	14 Apr 2005 20:55:52 -0000	1.32
@@ -15,11 +15,12 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
-#include <linux/spinlock.h>
 #include <net/icmp.h>
 #include <net/udp.h>
 #include <net/tcp.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <asm/semaphore.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/string.h>
@@ -43,9 +44,9 @@
 static void *ipt_acc_tmpbuf = NULL;
 
 /* Spinlock used for manipulating the current accounting tables/data */
-static spinlock_t ipt_acc_lock = SPIN_LOCK_UNLOCKED;
-/* Spinlock used for manipulating userspace handles/snapshot data */
-static spinlock_t ipt_acc_userspace_lock = SPIN_LOCK_UNLOCKED;
+DECLARE_LOCK(ipt_acc_lock);
+/* Mutex (semaphore) used for manipulating userspace handles/snapshot data */
+static struct semaphore ipt_acc_userspace_mutex;
 
 
 /* Recursive free of all data structures */
@@ -199,20 +200,19 @@
         return 0;
     }
 
-    spin_lock_bh(&ipt_acc_lock);
+    LOCK_BH(&ipt_acc_lock);
     table_nr = ipt_acc_table_insert(info->table_name, info->net_ip,
                                                       info->net_mask);
+    UNLOCK_BH(&ipt_acc_lock);
+    
     if (table_nr == -1) {
         printk("ACCOUNT: Table insert problem. Aborting\n");
-        spin_unlock_bh(&ipt_acc_lock);
         return 0;
     }
     /* Table nr caching so we don't have to do an extra string compare 
        for every packet */
     info->table_nr = table_nr;
 
-    spin_unlock_bh(&ipt_acc_lock);
-
     return 1;
 }
 
@@ -226,7 +226,7 @@
                targinfosize, IPT_ALIGN(sizeof(struct ipt_acc_info)));
     }
 
-    spin_lock_bh(&ipt_acc_lock);
+    LOCK_BH(&ipt_acc_lock);
 
     DEBUGP("ACCOUNT: ipt_acc_deleteentry called for table: %s (#%d)\n", 
            info->table_name, info->table_nr);
@@ -252,14 +252,14 @@
                        sizeof(struct ipt_acc_table));
             }
 
-            spin_unlock_bh(&ipt_acc_lock);
+            UNLOCK_BH(&ipt_acc_lock);
             return;
         }
     }
 
     /* Table not found */
     printk("ACCOUNT: Table %s not found for destroy\n", info->table_name);
-    spin_unlock_bh(&ipt_acc_lock);
+    UNLOCK_BH(&ipt_acc_lock);
 }
 
 static void ipt_acc_depth0_insert(struct ipt_acc_mask_24 *mask_24,
@@ -425,13 +425,13 @@
     u_int32_t dst_ip = (*pskb)->nh.iph->daddr;
     u_int32_t size = ntohs((*pskb)->nh.iph->tot_len);
 
-    spin_lock_bh(&ipt_acc_lock);
+    LOCK_BH(&ipt_acc_lock);
 
     if (ipt_acc_tables[info->table_nr].name[0] == 0) {
         printk("ACCOUNT: ipt_acc_target: Invalid table id %u. "
                "IPs %u.%u.%u.%u/%u.%u.%u.%u\n", info->table_nr, 
                NIPQUAD(src_ip), NIPQUAD(dst_ip));
-        spin_unlock_bh(&ipt_acc_lock);
+        UNLOCK_BH(&ipt_acc_lock);
         return IPT_CONTINUE;
     }
 
@@ -443,7 +443,7 @@
             ipt_acc_tables[info->table_nr].ip, 
             ipt_acc_tables[info->table_nr].netmask,
             src_ip, dst_ip, size, &ipt_acc_tables[info->table_nr].itemcount);
-        spin_unlock_bh(&ipt_acc_lock);
+        UNLOCK_BH(&ipt_acc_lock);
         return IPT_CONTINUE;
     }
 
@@ -454,7 +454,7 @@
             ipt_acc_tables[info->table_nr].ip, 
             ipt_acc_tables[info->table_nr].netmask,
             src_ip, dst_ip, size, &ipt_acc_tables[info->table_nr].itemcount);
-        spin_unlock_bh(&ipt_acc_lock);
+        UNLOCK_BH(&ipt_acc_lock);
         return IPT_CONTINUE;
     }
 
@@ -465,7 +465,7 @@
             ipt_acc_tables[info->table_nr].ip, 
             ipt_acc_tables[info->table_nr].netmask,
             src_ip, dst_ip, size, &ipt_acc_tables[info->table_nr].itemcount);
-        spin_unlock_bh(&ipt_acc_lock);
+        UNLOCK_BH(&ipt_acc_lock);
         return IPT_CONTINUE;
     }
 
@@ -473,7 +473,7 @@
            "Table id %u. IPs %u.%u.%u.%u/%u.%u.%u.%u\n", 
            info->table_nr, NIPQUAD(src_ip), NIPQUAD(dst_ip));
 
-    spin_unlock_bh(&ipt_acc_lock);
+    UNLOCK_BH(&ipt_acc_lock);
     return IPT_CONTINUE;
 }
 
@@ -530,54 +530,46 @@
 
 /* Prepare data for read without flush. Use only for debugging!
    Real applications should use read&flush as it's way more efficent */
-static int ipt_acc_handle_prepare_read(char *tablename, u_int32_t *count)
+static int ipt_acc_handle_prepare_read(char *tablename,
+         struct ipt_acc_handle *dest, u_int32_t *count)
 {
-    int handle, i, table_nr=-1;
+    int table_nr=-1;
     unsigned char depth;
 
-    for (i = 0; i < ACCOUNT_MAX_TABLES; i++)
-        if (strncmp(ipt_acc_tables[i].name, tablename, 
-            ACCOUNT_TABLE_NAME_LEN) == 0) {
-            table_nr = i;
-            break;
-        }
+    for (table_nr = 0; table_nr < ACCOUNT_MAX_TABLES; table_nr++)
+        if (strncmp(ipt_acc_tables[table_nr].name, tablename, 
+            ACCOUNT_TABLE_NAME_LEN) == 0)
+                break;
 
-    if (table_nr == -1) {
+    if (table_nr == ACCOUNT_MAX_TABLES) {
         printk("ACCOUNT: ipt_acc_handle_prepare_read(): "
                "Table %s not found\n", tablename);
         return -1;
     }
 
-    /* Can't find a free handle slot? */
-    if ((handle = ipt_acc_handle_find_slot()) == -1)
-        return -1;
-
     /* Fill up handle structure */
-    ipt_acc_handles[handle].ip = ipt_acc_tables[table_nr].ip;
-    ipt_acc_handles[handle].depth = ipt_acc_tables[table_nr].depth;
-    ipt_acc_handles[handle].itemcount = ipt_acc_tables[table_nr].itemcount;
+    dest->ip = ipt_acc_tables[table_nr].ip;
+    dest->depth = ipt_acc_tables[table_nr].depth;
+    dest->itemcount = ipt_acc_tables[table_nr].itemcount;
 
     /* allocate "root" table */
-    if ((ipt_acc_handles[handle].data = 
-         (void*)get_zeroed_page(GFP_ATOMIC)) == NULL) {
+    if ((dest->data = (void*)get_zeroed_page(GFP_ATOMIC)) == NULL) {
         printk("ACCOUNT: out of memory for root table "
                "in ipt_acc_handle_prepare_read()\n");
-        memset (&ipt_acc_handles[handle], 0, 
-                sizeof(struct ipt_acc_handle));
         return -1;
     }
 
     /* Recursive copy of complete data structure */
-    depth = ipt_acc_handles[handle].depth;
+    depth = dest->depth;
     if (depth == 0) {
-        memcpy(ipt_acc_handles[handle].data, 
+        memcpy(dest->data, 
                ipt_acc_tables[table_nr].data, 
                sizeof(struct ipt_acc_mask_24));
     } else if (depth == 1) {
         struct ipt_acc_mask_16 *src_16 = 
             (struct ipt_acc_mask_16 *)ipt_acc_tables[table_nr].data;
         struct ipt_acc_mask_16 *network_16 =
-            (struct ipt_acc_mask_16 *)ipt_acc_handles[handle].data;
+            (struct ipt_acc_mask_16 *)dest->data;
         u_int32_t b;
 
         for (b = 0; b <= 255; b++) {
@@ -586,9 +578,7 @@
                      (void*)get_zeroed_page(GFP_ATOMIC)) == NULL) {
                     printk("ACCOUNT: out of memory during copy of 16 bit "
                            "network in ipt_acc_handle_prepare_read()\n");
-                    ipt_acc_data_free(ipt_acc_handles[handle].data, depth);
-                    memset (&ipt_acc_handles[handle], 0, 
-                            sizeof(struct ipt_acc_handle));
+                    ipt_acc_data_free(dest->data, depth);
                     return -1;
                 }
 
@@ -600,7 +590,7 @@
         struct ipt_acc_mask_8 *src_8 = 
             (struct ipt_acc_mask_8 *)ipt_acc_tables[table_nr].data;
         struct ipt_acc_mask_8 *network_8 = 
-            (struct ipt_acc_mask_8 *)ipt_acc_handles[handle].data;
+            (struct ipt_acc_mask_8 *)dest->data;
         u_int32_t a;
 
         for (a = 0; a <= 255; a++) {
@@ -609,9 +599,7 @@
                      (void*)get_zeroed_page(GFP_ATOMIC)) == NULL) {
                     printk("ACCOUNT: out of memory during copy of 24 bit network"
                            " in ipt_acc_handle_prepare_read()\n");
-                    ipt_acc_data_free(ipt_acc_handles[handle].data, depth);
-                    memset (&ipt_acc_handles[handle], 0, 
-                            sizeof(struct ipt_acc_handle));
+                    ipt_acc_data_free(dest->data, depth);
                     return -1;
                 }
 
@@ -628,10 +616,7 @@
                              (void*)get_zeroed_page(GFP_ATOMIC)) == NULL) {
                             printk("ACCOUNT: out of memory during copy of 16 bit"
                                    " network in ipt_acc_handle_prepare_read()\n");
-                            ipt_acc_data_free(ipt_acc_handles[handle].data,
-                                                  depth);
-                            memset (&ipt_acc_handles[handle], 0, 
-                                    sizeof(struct ipt_acc_handle));
+                            ipt_acc_data_free(dest->data, depth);
                             return -1;
                         }
 
@@ -644,32 +629,28 @@
     }
 
     *count = ipt_acc_tables[table_nr].itemcount;
-    return handle;
+    
+    return 0;
 }
 
 /* Prepare data for read and flush it */
-static int ipt_acc_handle_prepare_read_flush(char *tablename, u_int32_t *count)
+static int ipt_acc_handle_prepare_read_flush(char *tablename,
+               struct ipt_acc_handle *dest, u_int32_t *count)
 {
-    int handle, i, table_nr=-1;
+    int table_nr;
     void *new_data_page;
 
-    for (i = 0; i < ACCOUNT_MAX_TABLES; i++)
-        if (strncmp(ipt_acc_tables[i].name, tablename, 
-                    ACCOUNT_TABLE_NAME_LEN) == 0) {
-            table_nr = i;
-            break;
-        }
+    for (table_nr = 0; table_nr < ACCOUNT_MAX_TABLES; table_nr++)
+        if (strncmp(ipt_acc_tables[table_nr].name, tablename, 
+            ACCOUNT_TABLE_NAME_LEN) == 0)
+                break;
 
-    if (table_nr == -1) {
+    if (table_nr == ACCOUNT_MAX_TABLES) {
         printk("ACCOUNT: ipt_acc_handle_prepare_read_flush(): "
                "Table %s not found\n", tablename);
         return -1;
     }
 
-    /* Can't find a free handle slot? */
-    if ((handle = ipt_acc_handle_find_slot()) == -1)
-        return -1;
-
     /* Try to allocate memory */
     if (!(new_data_page = (void*)get_zeroed_page(GFP_ATOMIC))) {
         printk("ACCOUNT: ipt_acc_handle_prepare_read_flush(): "
@@ -678,17 +659,17 @@
     }
 
     /* Fill up handle structure */
-    ipt_acc_handles[handle].ip = ipt_acc_tables[table_nr].ip;
-    ipt_acc_handles[handle].depth = ipt_acc_tables[table_nr].depth;
-    ipt_acc_handles[handle].itemcount = ipt_acc_tables[table_nr].itemcount;
-    ipt_acc_handles[handle].data = ipt_acc_tables[table_nr].data;
+    dest->ip = ipt_acc_tables[table_nr].ip;
+    dest->depth = ipt_acc_tables[table_nr].depth;
+    dest->itemcount = ipt_acc_tables[table_nr].itemcount;
+    dest->data = ipt_acc_tables[table_nr].data;
     *count = ipt_acc_tables[table_nr].itemcount;
 
     /* "Flush" table data */
     ipt_acc_tables[table_nr].data = new_data_page;
     ipt_acc_tables[table_nr].itemcount = 0;
 
-    return handle;
+    return 0;
 }
 
 /* Copy 8 bit network data into a prepared buffer.
@@ -847,16 +828,16 @@
             break;
         }
 
-        spin_lock_bh(&ipt_acc_userspace_lock);
+        down(&ipt_acc_userspace_mutex);
         ret = ipt_acc_handle_free(handle.handle_nr);
-        spin_unlock_bh(&ipt_acc_userspace_lock);
+        up(&ipt_acc_userspace_mutex);
         break;
     case IPT_SO_SET_ACCOUNT_HANDLE_FREE_ALL: {
             u_int32_t i;
-            spin_lock_bh(&ipt_acc_userspace_lock);
+            down(&ipt_acc_userspace_mutex);
             for (i = 0; i < ACCOUNT_MAX_HANDLES; i++)
                 ipt_acc_handle_free(i);
-            spin_unlock_bh(&ipt_acc_userspace_lock);
+            up(&ipt_acc_userspace_mutex);
             ret = 0;
             break;
         }
@@ -877,43 +858,52 @@
 
     switch (cmd) {
     case IPT_SO_GET_ACCOUNT_PREPARE_READ_FLUSH:
-    case IPT_SO_GET_ACCOUNT_PREPARE_READ:
-        if (*len < sizeof(struct ipt_acc_handle_sockopt)) {
-            printk("ACCOUNT: ipt_acc_get_ctl: wrong data size (%u != %u) "
-                   "for IPT_SO_GET_ACCOUNT_PREPARE_READ/READ_FLUSH\n",
-                   *len, sizeof(struct ipt_acc_handle_sockopt));
-            break;
-        }
-
-        if (copy_from_user (&handle, user, 
+    case IPT_SO_GET_ACCOUNT_PREPARE_READ: {
+            struct ipt_acc_handle dest;
+    
+            if (*len < sizeof(struct ipt_acc_handle_sockopt)) {
+                printk("ACCOUNT: ipt_acc_get_ctl: wrong data size (%u != %u) "
+                    "for IPT_SO_GET_ACCOUNT_PREPARE_READ/READ_FLUSH\n",
+                    *len, sizeof(struct ipt_acc_handle_sockopt));
+                break;
+            }
+    
+            if (copy_from_user (&handle, user, 
+                                sizeof(struct ipt_acc_handle_sockopt))) {
+                return -EFAULT;
+                break;
+            }
+    
+            LOCK_BH(&ipt_acc_lock);
+            if (cmd == IPT_SO_GET_ACCOUNT_PREPARE_READ_FLUSH)
+                ret = ipt_acc_handle_prepare_read_flush(
+                                    handle.name, &dest, &handle.itemcount);
+            else
+                ret = ipt_acc_handle_prepare_read(
+                                    handle.name, &dest, &handle.itemcount);
+            UNLOCK_BH(&ipt_acc_lock);
+            // Error occured during prepare_read?
+           if (ret == -1)
+                return -EINVAL;
+            
+            /* Allocate a userspace handle */
+            down(&ipt_acc_userspace_mutex);
+            if ((handle.handle_nr = ipt_acc_handle_find_slot()) == -1) {
+                ipt_acc_data_free(dest.data, dest.depth);
+                return -EINVAL;
+            }
+            memcpy(&ipt_acc_handles[handle.handle_nr], &dest,
+                             sizeof(struct ipt_acc_handle));
+            up(&ipt_acc_userspace_mutex);
+            
+            if (copy_to_user(user, &handle, 
                             sizeof(struct ipt_acc_handle_sockopt))) {
-            return -EFAULT;
-            break;
-        }
-
-        spin_lock_bh(&ipt_acc_lock);
-        spin_lock_bh(&ipt_acc_userspace_lock);
-        if (cmd == IPT_SO_GET_ACCOUNT_PREPARE_READ_FLUSH)
-            handle.handle_nr = ipt_acc_handle_prepare_read_flush(
-                                   handle.name, &handle.itemcount);
-        else
-            handle.handle_nr = ipt_acc_handle_prepare_read(
-                                   handle.name, &handle.itemcount);
-        spin_unlock_bh(&ipt_acc_userspace_lock);
-        spin_unlock_bh(&ipt_acc_lock);
-
-        if (handle.handle_nr == -1) {
-            return -EINVAL;
-            break;
-        }
-
-        if (copy_to_user(user, &handle, 
-                         sizeof(struct ipt_acc_handle_sockopt))) {
-            return -EFAULT;
+                return -EFAULT;
+                break;
+            }
+            ret = 0;
             break;
         }
-        ret = 0;
-        break;
     case IPT_SO_GET_ACCOUNT_GET_DATA:
         if (*len < sizeof(struct ipt_acc_handle_sockopt)) {
             printk("ACCOUNT: ipt_acc_get_ctl: wrong data size (%u != %u)"
@@ -943,9 +933,9 @@
             break;
         }
 
-        spin_lock_bh(&ipt_acc_userspace_lock);
+        down(&ipt_acc_userspace_mutex);
         ret = ipt_acc_handle_get_data(handle.handle_nr, user);
-        spin_unlock_bh(&ipt_acc_userspace_lock);
+        up(&ipt_acc_userspace_mutex);
         if (ret) {
             printk("ACCOUNT: ipt_acc_get_ctl: ipt_acc_handle_get_data"
                    " failed for handle %u\n", handle.handle_nr);
@@ -965,11 +955,11 @@
 
             /* Find out how many handles are in use */
             handle.itemcount = 0;
-            spin_lock_bh(&ipt_acc_userspace_lock);
+            down(&ipt_acc_userspace_mutex);
             for (i = 0; i < ACCOUNT_MAX_HANDLES; i++)
                 if (ipt_acc_handles[i].data)
                     handle.itemcount++;
-            spin_unlock_bh(&ipt_acc_userspace_lock);
+            up(&ipt_acc_userspace_mutex);
 
             if (copy_to_user(user, &handle, 
                              sizeof(struct ipt_acc_handle_sockopt))) {
@@ -980,10 +970,10 @@
             break;
         }
     case IPT_SO_GET_ACCOUNT_GET_TABLE_NAMES: {
-            u_int32_t size = 0, i;
+            u_int32_t size = 0, i, name_len;
             char *tnames;
-            
-            spin_lock_bh(&ipt_acc_lock);
+
+            LOCK_BH(&ipt_acc_lock);
 
             /* Determine size of table names */
             for (i = 0; i < ACCOUNT_MAX_TABLES; i++) {
@@ -992,32 +982,31 @@
             }
             size += 1;    /* Terminating NULL character */
 
-            if (*len < size) {
-                spin_unlock_bh(&ipt_acc_lock);
-                printk("ACCOUNT: ipt_acc_get_ctl: not enough space (%u < %u)"
-                       " to store table names\n", *len, size);
+            if (*len < size || size > PAGE_SIZE) {
+                UNLOCK_BH(&ipt_acc_lock);
+                printk("ACCOUNT: ipt_acc_get_ctl: not enough space (%u < %u < %lu)"
+                       " to store table names\n", *len, size, PAGE_SIZE);
                 ret = -ENOMEM;
                 break;
             }
             /* Copy table names to userspace */
-            tnames = user;
+            tnames = ipt_acc_tmpbuf;
             for (i = 0; i < ACCOUNT_MAX_TABLES; i++) {
                 if (ipt_acc_tables[i].name[0] != 0) {
-                    int len = strlen (ipt_acc_tables[i].name) + 1;
-                    /* copy string + terminating zero */
-                    if (copy_to_user(tnames, ipt_acc_tables[i].name, len)) {
-                        spin_unlock_bh(&ipt_acc_lock);
-                        return -EFAULT;
-                    }
-                    tnames += len;
+                    name_len = strlen (ipt_acc_tables[i].name) + 1;
+                    memcpy(tnames, ipt_acc_tables[i].name, name_len);
+                    tnames += name_len;
                 }
             }
-            /* Append terminating zero */
-            i = 0;
-            ret = copy_to_user(tnames, &i, 1);
-            spin_unlock_bh(&ipt_acc_lock);
-            if (ret)
+            UNLOCK_BH(&ipt_acc_lock);
+            
+            /* Terminating NULL character */
+            *tnames = 0;
+            
+            /* Transfer to userspace */                    
+            if (copy_to_user(user, ipt_acc_tmpbuf, size))
                 return -EFAULT;
+            
             ret = 0;
             break;
         }
@@ -1048,6 +1037,8 @@
 
 static int __init init(void)
 {
+    init_MUTEX(&ipt_acc_userspace_mutex);    
+
     if ((ipt_acc_tables = 
          kmalloc(ACCOUNT_MAX_TABLES * 
                  sizeof(struct ipt_acc_table), GFP_KERNEL)) == NULL) {

--Boundary-00=_8o3XCQ87kWstXpF--
