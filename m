From: Patrick McHardy <kaber@trash.net>
Subject: Re: new ipt_ACCOUNT version
Date: Sun, 13 Jun 2004 22:44:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087159457.11287.39.camel@ws>
References: <200405291527.43712.thomas.jarosch@intra2net.com>
	 <200406091133.59850.thomas.jarosch@intra2net.com>
	 <40C6DB4E.2080804@trash.net>
	 <200406101907.05352.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-x2DLz8iS6zearsSkXTPo"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
In-Reply-To: <200406101907.05352.thomas.jarosch@intra2net.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-x2DLz8iS6zearsSkXTPo
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2004-06-10 at 19:07, Thomas Jarosch wrote:
> Hi Patrick,
>
> Please see the attached file. Hope the userspace patch is ok.

Applied with the attached patch on top (trailing whitespace cleanup
and missing statics).

Regards
Patrick


> 
> Cheers,
> Thomas

--=-x2DLz8iS6zearsSkXTPo
Content-Disposition: attachment; filename=x
Content-Type: text/plain; name=x; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Index: include/linux/netfilter_ipv4/ipt_ACCOUNT.h
===================================================================
RCS file: /cvsroot/patch-o-matic-ng/ACCOUNT/linux/include/linux/netfilter_ipv4/ipt_ACCOUNT.h,v
retrieving revision 1.1
diff -u -r1.1 ipt_ACCOUNT.h
--- include/linux/netfilter_ipv4/ipt_ACCOUNT.h	13 Jun 2004 20:35:22 -0000	1.1
+++ include/linux/netfilter_ipv4/ipt_ACCOUNT.h	13 Jun 2004 20:40:27 -0000
@@ -28,24 +28,24 @@
     char name[ACCOUNT_TABLE_NAME_LEN];     /* name of the table */
     u_int32_t ip;                          /* base IP of network */
     u_int32_t netmask;                     /* netmask of the network */
-    unsigned char depth;                   /* size of network: 
+    unsigned char depth;                   /* size of network:
                                                  0: 8 bit, 1: 16bit, 2: 24 bit */
-    u_int32_t refcount;                    /* refcount of this table. 
+    u_int32_t refcount;                    /* refcount of this table.
                                                  if zero, destroy it */
     u_int32_t itemcount;                   /* number of IPs in this table */
-    void *data;                            /* pointer to the actual data, 
+    void *data;                            /* pointer to the actual data,
                                                  depending on netmask */
 };
 
 /* Internal handle structure */
 struct ipt_acc_handle {
-    u_int32_t ip;                          /* base IP of network. Used for 
+    u_int32_t ip;                          /* base IP of network. Used for
                                                  caculating the final IP during
                                                  get_data() */
-    unsigned char depth;                   /* size of network. See above for 
+    unsigned char depth;                   /* size of network. See above for
                                                  details */
     u_int32_t itemcount;                   /* number of IPs in this table */
-    void *data;                            /* pointer to the actual data, 
+    void *data;                            /* pointer to the actual data,
                                                  depending on size */
 };
 
@@ -58,8 +58,8 @@
                                                  HANDLE_READ_FLUSH */
 };
 
-/* Used for every IP entry 
-   Size is 16 bytes so that 256 (class C network) * 16 
+/* Used for every IP entry
+   Size is 16 bytes so that 256 (class C network) * 16
    fits in one kernel (zero) page */
 struct ipt_acc_ip {
     u_int32_t src_packets;
Index: net/ipv4/netfilter/ipt_ACCOUNT.c
===================================================================
RCS file: /cvsroot/patch-o-matic-ng/ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c,v
retrieving revision 1.1
diff -u -r1.1 ipt_ACCOUNT.c
--- net/ipv4/netfilter/ipt_ACCOUNT.c	13 Jun 2004 20:35:22 -0000	1.1
+++ net/ipv4/netfilter/ipt_ACCOUNT.c	13 Jun 2004 20:40:29 -0000
@@ -2,7 +2,7 @@
  *   This is a module which is used for counting packets.                  *
  *   See http://www.intra2net.com/opensource/ipt_account                   *
  *   for further information                                               *
- *                                                                         * 
+ *                                                                         *
  *   Copyright (C) 2004 by Intra2net AG                                    *
  *   opensource@intra2net.com                                              *
  *                                                                         *
@@ -25,7 +25,6 @@
 #include <linux/string.h>
 #include <asm/uaccess.h>
 
-struct in_device;
 #include <net/route.h>
 #include <linux/netfilter_ipv4/ipt_ACCOUNT.h>
 
@@ -39,9 +38,9 @@
 #error "ipt_ACCOUNT needs at least a PAGE_SIZE of 4096"
 #endif
 
-struct ipt_acc_table *ipt_acc_tables = NULL;
-struct ipt_acc_handle *ipt_acc_handles = NULL;
-void *ipt_acc_tmpbuf = NULL;
+static struct ipt_acc_table *ipt_acc_tables = NULL;
+static struct ipt_acc_handle *ipt_acc_handles = NULL;
+static void *ipt_acc_tmpbuf = NULL;
 
 /* Spinlock used for manipulating the current accounting tables/data */
 static spinlock_t ipt_acc_lock = SPIN_LOCK_UNLOCKED;
@@ -50,7 +49,7 @@
 
 
 /* Recursive free of all data structures */
-void ipt_acc_data_free(void *data, unsigned char depth)
+static void ipt_acc_data_free(void *data, unsigned char depth)
 {
     /* Empty data set */
     if (!data)
@@ -82,7 +81,7 @@
             if (((struct ipt_acc_mask_8 *)data)->mask_16[a]) {
                 struct ipt_acc_mask_16 *mask_16 = (struct ipt_acc_mask_16*)
                                    ((struct ipt_acc_mask_8 *)data)->mask_16[a];
-                
+
                 for (b=0; b <= 255; b++) {
                     if (mask_16->mask_24[b]) {
                         free_page((unsigned long)mask_16->mask_24[b]);
@@ -95,14 +94,14 @@
         return;
     }
 
-    printk("ACCOUNT: ipt_acc_data_free called with unknown depth: %d\n", 
+    printk("ACCOUNT: ipt_acc_data_free called with unknown depth: %d\n",
            depth);
     return;
 }
 
-/* Look for existing table / insert new one. 
+/* Look for existing table / insert new one.
    Return internal ID or -1 on error */
-int ipt_acc_table_insert(char *name, u_int32_t ip, u_int32_t netmask)
+static int ipt_acc_table_insert(char *name, u_int32_t ip, u_int32_t netmask)
 {
     u_int32_t i;
 
@@ -111,18 +110,18 @@
 
     /* Look for existing table */
     for (i = 0; i < ACCOUNT_MAX_TABLES; i++) {
-        if (strncmp(ipt_acc_tables[i].name, name, 
+        if (strncmp(ipt_acc_tables[i].name, name,
                     ACCOUNT_TABLE_NAME_LEN) == 0) {
             DEBUGP("ACCOUNT: Found existing slot: %d - "
-                   "%u.%u.%u.%u/%u.%u.%u.%u\n", i, 
-                   NIPQUAD(ipt_acc_tables[i].ip), 
+                   "%u.%u.%u.%u/%u.%u.%u.%u\n", i,
+                   NIPQUAD(ipt_acc_tables[i].ip),
                    NIPQUAD(ipt_acc_tables[i].netmask));
 
-            if (ipt_acc_tables[i].ip != ip 
+            if (ipt_acc_tables[i].ip != ip
                 || ipt_acc_tables[i].netmask != netmask) {
                 printk("ACCOUNT: Table %s found, but IP/netmask mismatch. "
                        "IP/netmask found: %u.%u.%u.%u/%u.%u.%u.%u\n",
-                       name, NIPQUAD(ipt_acc_tables[i].ip), 
+                       name, NIPQUAD(ipt_acc_tables[i].ip),
                        NIPQUAD(ipt_acc_tables[i].netmask));
                 return -1;
             }
@@ -138,7 +137,7 @@
         /* Found free slot */
         if (ipt_acc_tables[i].name[0] == 0) {
             u_int32_t j, calc_mask, netsize=0;
-            
+
             DEBUGP("ACCOUNT: Found free slot: %d\n", i);
             strncpy (ipt_acc_tables[i].name, name, ACCOUNT_TABLE_NAME_LEN-1);
 
@@ -163,14 +162,14 @@
                 ipt_acc_tables[i].depth = 2;
 
             DEBUGP("ACCOUNT: calculated netsize: %u -> "
-                   "ipt_acc_table depth %u\n", netsize, 
+                   "ipt_acc_table depth %u\n", netsize,
                    ipt_acc_tables[i].depth);
 
             ipt_acc_tables[i].refcount++;
             if ((ipt_acc_tables[i].data
                 = (void *)get_zeroed_page(GFP_ATOMIC)) == NULL) {
                 printk("ACCOUNT: out of memory for data of table: %s\n", name);
-                memset(&ipt_acc_tables[i], 0, 
+                memset(&ipt_acc_tables[i], 0,
                        sizeof(struct ipt_acc_table));
                 return -1;
             }
@@ -208,7 +207,7 @@
         spin_unlock_bh(&ipt_acc_lock);
         return 0;
     }
-    /* Table nr caching so we don't have to do an extra string compare 
+    /* Table nr caching so we don't have to do an extra string compare
        for every packet */
     info->table_nr = table_nr;
 
@@ -217,7 +216,7 @@
     return 1;
 }
 
-void ipt_acc_deleteentry(void *targinfo, unsigned int targinfosize)
+static void ipt_acc_deleteentry(void *targinfo, unsigned int targinfosize)
 {
     u_int32_t i;
     struct ipt_acc_info *info = targinfo;
@@ -229,27 +228,27 @@
 
     spin_lock_bh(&ipt_acc_lock);
 
-    DEBUGP("ACCOUNT: ipt_acc_deleteentry called for table: %s (#%d)\n", 
+    DEBUGP("ACCOUNT: ipt_acc_deleteentry called for table: %s (#%d)\n",
            info->table_name, info->table_nr);
 
     info->table_nr = -1;    /* Set back to original state */
 
     /* Look for table */
     for (i = 0; i < ACCOUNT_MAX_TABLES; i++) {
-        if (strncmp(ipt_acc_tables[i].name, info->table_name, 
+        if (strncmp(ipt_acc_tables[i].name, info->table_name,
                     ACCOUNT_TABLE_NAME_LEN) == 0) {
             DEBUGP("ACCOUNT: Found table at slot: %d\n", i);
 
             ipt_acc_tables[i].refcount--;
-            DEBUGP("ACCOUNT: Refcount left: %d\n", 
+            DEBUGP("ACCOUNT: Refcount left: %d\n",
                    ipt_acc_tables[i].refcount);
 
             /* Table not needed anymore? */
             if (ipt_acc_tables[i].refcount == 0) {
                 DEBUGP("ACCOUNT: Destroying table at slot: %d\n", i);
-                ipt_acc_data_free(ipt_acc_tables[i].data, 
+                ipt_acc_data_free(ipt_acc_tables[i].data,
                                       ipt_acc_tables[i].depth);
-                memset(&ipt_acc_tables[i], 0, 
+                memset(&ipt_acc_tables[i], 0,
                        sizeof(struct ipt_acc_table));
             }
 
@@ -263,16 +262,16 @@
     spin_unlock_bh(&ipt_acc_lock);
 }
 
-void ipt_acc_depth0_insert(struct ipt_acc_mask_24 *mask_24,
-                               u_int32_t net_ip, u_int32_t netmask,
-                               u_int32_t src_ip, u_int32_t dst_ip,
-                               u_int32_t size, u_int32_t *itemcount)
+static void ipt_acc_depth0_insert(struct ipt_acc_mask_24 *mask_24,
+                                  u_int32_t net_ip, u_int32_t netmask,
+                                  u_int32_t src_ip, u_int32_t dst_ip,
+                                  u_int32_t size, u_int32_t *itemcount)
 {
     unsigned char is_src = 0, is_dst = 0, src_slot, dst_slot;
     char is_src_new_ip = 0, is_dst_new_ip = 0; /* Check if this entry is new */
 
     DEBUGP("ACCOUNT: ipt_acc_depth0_insert: %u.%u.%u.%u/%u.%u.%u.%u "
-           "for net %u.%u.%u.%u/%u.%u.%u.%u, size: %u\n", NIPQUAD(src_ip), 
+           "for net %u.%u.%u.%u/%u.%u.%u.%u, size: %u\n", NIPQUAD(src_ip),
            NIPQUAD(dst_ip), NIPQUAD(net_ip), NIPQUAD(netmask), size);
 
     /* Check if src/dst is inside our network. */
@@ -286,7 +285,7 @@
 
     if (!is_src && !is_dst) {
         DEBUGP("ACCOUNT: Skipping packet %u.%u.%u.%u/%u.%u.%u.%u "
-               "for net %u.%u.%u.%u/%u.%u.%u.%u\n", NIPQUAD(src_ip), 
+               "for net %u.%u.%u.%u/%u.%u.%u.%u\n", NIPQUAD(src_ip),
                NIPQUAD(dst_ip), NIPQUAD(net_ip), NIPQUAD(netmask));
         return;
     }
@@ -299,7 +298,7 @@
     if (is_src) {
         /* Calculate network slot */
         DEBUGP("ACCOUNT: Calculated SRC 8 bit network slot: %d\n", src_slot);
-        if (!mask_24->ip[src_slot].src_packets 
+        if (!mask_24->ip[src_slot].src_packets
             && !mask_24->ip[src_slot].dst_packets)
             is_src_new_ip = 1;
 
@@ -308,7 +307,7 @@
     }
     if (is_dst) {
         DEBUGP("ACCOUNT: Calculated DST 8 bit network slot: %d\n", dst_slot);
-        if (!mask_24->ip[dst_slot].src_packets 
+        if (!mask_24->ip[dst_slot].src_packets
             && !mask_24->ip[dst_slot].dst_packets)
             is_dst_new_ip = 1;
 
@@ -320,7 +319,7 @@
     DEBUGP("ACCOUNT: Itemcounter before: %d\n", *itemcount);
     if (src_slot == dst_slot) {
         if (is_src_new_ip || is_dst_new_ip) {
-            DEBUGP("ACCOUNT: src_slot == dst_slot: %d, %d\n", 
+            DEBUGP("ACCOUNT: src_slot == dst_slot: %d, %d\n",
                    is_src_new_ip, is_dst_new_ip);
             (*itemcount)++;
         }
@@ -337,10 +336,10 @@
     DEBUGP("ACCOUNT: Itemcounter after: %d\n", *itemcount);
 }
 
-void ipt_acc_depth1_insert(struct ipt_acc_mask_16 *mask_16, 
-                               u_int32_t net_ip, u_int32_t netmask, 
-                               u_int32_t src_ip, u_int32_t dst_ip,
-                               u_int32_t size, u_int32_t *itemcount)
+static void ipt_acc_depth1_insert(struct ipt_acc_mask_16 *mask_16,
+                                  u_int32_t net_ip, u_int32_t netmask,
+                                  u_int32_t src_ip, u_int32_t dst_ip,
+                                  u_int32_t size, u_int32_t *itemcount)
 {
     /* Do we need to process src IP? */
     if ((net_ip&netmask) == (src_ip&netmask)) {
@@ -348,7 +347,7 @@
         DEBUGP("ACCOUNT: Calculated SRC 16 bit network slot: %d\n", slot);
 
         /* Do we need to create a new mask_24 bucket? */
-        if (!mask_16->mask_24[slot] && (mask_16->mask_24[slot] = 
+        if (!mask_16->mask_24[slot] && (mask_16->mask_24[slot] =
              (void *)get_zeroed_page(GFP_ATOMIC)) == NULL) {
             printk("ACCOUNT: Can't process packet because out of memory!\n");
             return;
@@ -364,7 +363,7 @@
         DEBUGP("ACCOUNT: Calculated DST 16 bit network slot: %d\n", slot);
 
         /* Do we need to create a new mask_24 bucket? */
-        if (!mask_16->mask_24[slot] && (mask_16->mask_24[slot] 
+        if (!mask_16->mask_24[slot] && (mask_16->mask_24[slot]
             = (void *)get_zeroed_page(GFP_ATOMIC)) == NULL) {
             printk("ACCOUT: Can't process packet because out of memory!\n");
             return;
@@ -375,10 +374,10 @@
     }
 }
 
-void ipt_acc_depth2_insert(struct ipt_acc_mask_8 *mask_8, 
-                               u_int32_t net_ip, u_int32_t netmask,
-                               u_int32_t src_ip, u_int32_t dst_ip,
-                               u_int32_t size, u_int32_t *itemcount)
+static void ipt_acc_depth2_insert(struct ipt_acc_mask_8 *mask_8,
+                                  u_int32_t net_ip, u_int32_t netmask,
+                                  u_int32_t src_ip, u_int32_t dst_ip,
+                                  u_int32_t size, u_int32_t *itemcount)
 {
     /* Do we need to process src IP? */
     if ((net_ip&netmask) == (src_ip&netmask)) {
@@ -386,7 +385,7 @@
         DEBUGP("ACCOUNT: Calculated SRC 24 bit network slot: %d\n", slot);
 
         /* Do we need to create a new mask_24 bucket? */
-        if (!mask_8->mask_16[slot] && (mask_8->mask_16[slot] 
+        if (!mask_8->mask_16[slot] && (mask_8->mask_16[slot]
             = (void *)get_zeroed_page(GFP_ATOMIC)) == NULL) {
             printk("ACCOUNT: Can't process packet because out of memory!\n");
             return;
@@ -402,7 +401,7 @@
         DEBUGP("ACCOUNT: Calculated DST 24 bit network slot: %d\n", slot);
 
         /* Do we need to create a new mask_24 bucket? */
-        if (!mask_8->mask_16[slot] && (mask_8->mask_16[slot] 
+        if (!mask_8->mask_16[slot] && (mask_8->mask_16[slot]
             = (void *)get_zeroed_page(GFP_ATOMIC)) == NULL) {
             printk("ACCOUNT: Can't process packet because out of memory!\n");
             return;
@@ -420,7 +419,7 @@
                                        const void *targinfo,
                                        void *userinfo)
 {
-    const struct ipt_acc_info *info = 
+    const struct ipt_acc_info *info =
         (const struct ipt_acc_info *)targinfo;
     u_int32_t src_ip = (*pskb)->nh.iph->saddr;
     u_int32_t dst_ip = (*pskb)->nh.iph->daddr;
@@ -430,7 +429,7 @@
 
     if (ipt_acc_tables[info->table_nr].name[0] == 0) {
         printk("ACCOUNT: ipt_acc_target: Invalid table id %u. "
-               "IPs %u.%u.%u.%u/%u.%u.%u.%u\n", info->table_nr, 
+               "IPs %u.%u.%u.%u/%u.%u.%u.%u\n", info->table_nr,
                NIPQUAD(src_ip), NIPQUAD(dst_ip));
         spin_unlock_bh(&ipt_acc_lock);
         return IPT_CONTINUE;
@@ -441,7 +440,7 @@
         /* Count packet and check if the IP is new */
         ipt_acc_depth0_insert(
             (struct ipt_acc_mask_24 *)ipt_acc_tables[info->table_nr].data,
-            ipt_acc_tables[info->table_nr].ip, 
+            ipt_acc_tables[info->table_nr].ip,
             ipt_acc_tables[info->table_nr].netmask,
             src_ip, dst_ip, size, &ipt_acc_tables[info->table_nr].itemcount);
         spin_unlock_bh(&ipt_acc_lock);
@@ -452,7 +451,7 @@
     if (ipt_acc_tables[info->table_nr].depth == 1) {
         ipt_acc_depth1_insert(
             (struct ipt_acc_mask_16 *)ipt_acc_tables[info->table_nr].data,
-            ipt_acc_tables[info->table_nr].ip, 
+            ipt_acc_tables[info->table_nr].ip,
             ipt_acc_tables[info->table_nr].netmask,
             src_ip, dst_ip, size, &ipt_acc_tables[info->table_nr].itemcount);
         spin_unlock_bh(&ipt_acc_lock);
@@ -463,7 +462,7 @@
     if (ipt_acc_tables[info->table_nr].depth == 2) {
         ipt_acc_depth2_insert(
             (struct ipt_acc_mask_8 *)ipt_acc_tables[info->table_nr].data,
-            ipt_acc_tables[info->table_nr].ip, 
+            ipt_acc_tables[info->table_nr].ip,
             ipt_acc_tables[info->table_nr].netmask,
             src_ip, dst_ip, size, &ipt_acc_tables[info->table_nr].itemcount);
         spin_unlock_bh(&ipt_acc_lock);
@@ -471,7 +470,7 @@
     }
 
     printk("ACCOUNT: ipt_acc_target: Unable to process packet. "
-           "Table id %u. IPs %u.%u.%u.%u/%u.%u.%u.%u\n", 
+           "Table id %u. IPs %u.%u.%u.%u/%u.%u.%u.%u\n",
            info->table_nr, NIPQUAD(src_ip), NIPQUAD(dst_ip));
 
     spin_unlock_bh(&ipt_acc_lock);
@@ -481,11 +480,11 @@
 /*
     Functions dealing with "handles":
     Handles are snapshots of a accounting state.
-    
+
     read snapshots are only for debugging the code
     and are very expensive concerning speed/memory
     compared to read_and_flush.
-    
+
     The functions aren't protected by spinlocks themselves
     as this is done in the ioctl part of the code.
 */
@@ -495,14 +494,14 @@
     but there could be two or more applications accessing the data
     at the same time.
 */
-int ipt_acc_handle_find_slot(void)
+static int ipt_acc_handle_find_slot(void)
 {
     u_int32_t i;
     /* Insert new table */
     for (i = 0; i < ACCOUNT_MAX_HANDLES; i++) {
         /* Found free slot */
         if (ipt_acc_handles[i].data == NULL) {
-            /* Don't "mark" data as used as we are protected by a spinlock 
+            /* Don't "mark" data as used as we are protected by a spinlock
                by the calling function. handle_find_slot() is only a function
                to prevent code duplication. */
             return i;
@@ -515,7 +514,7 @@
     return -1;
 }
 
-int ipt_acc_handle_free(u_int32_t handle)
+static int ipt_acc_handle_free(u_int32_t handle)
 {
     if (handle >= ACCOUNT_MAX_HANDLES) {
         printk("ACCOUNT: Invalid handle for ipt_acc_handle_free() specified:"
@@ -523,7 +522,7 @@
         return -EINVAL;
     }
 
-    ipt_acc_data_free(ipt_acc_handles[handle].data, 
+    ipt_acc_data_free(ipt_acc_handles[handle].data,
                           ipt_acc_handles[handle].depth);
     memset (&ipt_acc_handles[handle], 0, sizeof (struct ipt_acc_handle));
     return 0;
@@ -531,13 +530,13 @@
 
 /* Prepare data for read without flush. Use only for debugging!
    Real applications should use read&flush as it's way more efficent */
-int ipt_acc_handle_prepare_read(char *tablename, u_int32_t *count)
+static int ipt_acc_handle_prepare_read(char *tablename, u_int32_t *count)
 {
     int handle, i, table_nr=-1;
     unsigned char depth;
 
     for (i = 0; i < ACCOUNT_MAX_TABLES; i++)
-        if (strncmp(ipt_acc_tables[i].name, tablename, 
+        if (strncmp(ipt_acc_tables[i].name, tablename,
             ACCOUNT_TABLE_NAME_LEN) == 0) {
             table_nr = i;
             break;
@@ -559,11 +558,11 @@
     ipt_acc_handles[handle].itemcount = ipt_acc_tables[table_nr].itemcount;
 
     /* allocate "root" table */
-    if ((ipt_acc_handles[handle].data = 
+    if ((ipt_acc_handles[handle].data =
          (void*)get_zeroed_page(GFP_ATOMIC)) == NULL) {
         printk("ACCOUNT: out of memory for root table "
                "in ipt_acc_handle_prepare_read()\n");
-        memset (&ipt_acc_handles[handle], 0, 
+        memset (&ipt_acc_handles[handle], 0,
                 sizeof(struct ipt_acc_handle));
         return -1;
     }
@@ -571,11 +570,11 @@
     /* Recursive copy of complete data structure */
     depth = ipt_acc_handles[handle].depth;
     if (depth == 0) {
-        memcpy(ipt_acc_handles[handle].data, 
-               ipt_acc_tables[table_nr].data, 
+        memcpy(ipt_acc_handles[handle].data,
+               ipt_acc_tables[table_nr].data,
                sizeof(struct ipt_acc_mask_24));
     } else if (depth == 1) {
-        struct ipt_acc_mask_16 *src_16 = 
+        struct ipt_acc_mask_16 *src_16 =
             (struct ipt_acc_mask_16 *)ipt_acc_tables[table_nr].data;
         struct ipt_acc_mask_16 *network_16 =
             (struct ipt_acc_mask_16 *)ipt_acc_handles[handle].data;
@@ -583,40 +582,40 @@
 
         for (b = 0; b <= 255; b++) {
             if (src_16->mask_24[b]) {
-                if ((network_16->mask_24[b] = 
+                if ((network_16->mask_24[b] =
                      (void*)get_zeroed_page(GFP_ATOMIC)) == NULL) {
                     printk("ACCOUNT: out of memory during copy of 16 bit "
                            "network in ipt_acc_handle_prepare_read()\n");
                     ipt_acc_data_free(ipt_acc_handles[handle].data, depth);
-                    memset (&ipt_acc_handles[handle], 0, 
+                    memset (&ipt_acc_handles[handle], 0,
                             sizeof(struct ipt_acc_handle));
                     return -1;
                 }
 
-                memcpy(network_16->mask_24[b], src_16->mask_24[b], 
+                memcpy(network_16->mask_24[b], src_16->mask_24[b],
                        sizeof(struct ipt_acc_mask_24));
             }
         }
     } else if(depth == 2) {
-        struct ipt_acc_mask_8 *src_8 = 
+        struct ipt_acc_mask_8 *src_8 =
             (struct ipt_acc_mask_8 *)ipt_acc_tables[table_nr].data;
-        struct ipt_acc_mask_8 *network_8 = 
+        struct ipt_acc_mask_8 *network_8 =
             (struct ipt_acc_mask_8 *)ipt_acc_handles[handle].data;
         u_int32_t a;
 
         for (a = 0; a <= 255; a++) {
             if (src_8->mask_16[a]) {
-                if ((network_8->mask_16[a] = 
+                if ((network_8->mask_16[a] =
                      (void*)get_zeroed_page(GFP_ATOMIC)) == NULL) {
                     printk("ACCOUNT: out of memory during copy of 24 bit network"
                            " in ipt_acc_handle_prepare_read()\n");
                     ipt_acc_data_free(ipt_acc_handles[handle].data, depth);
-                    memset (&ipt_acc_handles[handle], 0, 
+                    memset (&ipt_acc_handles[handle], 0,
                             sizeof(struct ipt_acc_handle));
                     return -1;
                 }
 
-                memcpy(network_8->mask_16[a], src_8->mask_16[a], 
+                memcpy(network_8->mask_16[a], src_8->mask_16[a],
                        sizeof(struct ipt_acc_mask_16));
 
                 struct ipt_acc_mask_16 *src_16 = src_8->mask_16[a];
@@ -625,18 +624,18 @@
 
                 for (b = 0; b <= 255; b++) {
                     if (src_16->mask_24[b]) {
-                        if ((network_16->mask_24[b] = 
+                        if ((network_16->mask_24[b] =
                              (void*)get_zeroed_page(GFP_ATOMIC)) == NULL) {
                             printk("ACCOUNT: out of memory during copy of 16 bit"
                                    " network in ipt_acc_handle_prepare_read()\n");
                             ipt_acc_data_free(ipt_acc_handles[handle].data,
                                                   depth);
-                            memset (&ipt_acc_handles[handle], 0, 
+                            memset (&ipt_acc_handles[handle], 0,
                                     sizeof(struct ipt_acc_handle));
                             return -1;
                         }
 
-                        memcpy(network_16->mask_24[b], src_16->mask_24[b], 
+                        memcpy(network_16->mask_24[b], src_16->mask_24[b],
                                sizeof(struct ipt_acc_mask_24));
                     }
                 }
@@ -649,13 +648,13 @@
 }
 
 /* Prepare data for read and flush it */
-int ipt_acc_handle_prepare_read_flush(char *tablename, u_int32_t *count)
+static int ipt_acc_handle_prepare_read_flush(char *tablename, u_int32_t *count)
 {
     int handle, i, table_nr=-1;
     void *new_data_page;
 
     for (i = 0; i < ACCOUNT_MAX_TABLES; i++)
-        if (strncmp(ipt_acc_tables[i].name, tablename, 
+        if (strncmp(ipt_acc_tables[i].name, tablename,
                     ACCOUNT_TABLE_NAME_LEN) == 0) {
             table_nr = i;
             break;
@@ -695,18 +694,18 @@
 /* Copy 8 bit network data into a prepared buffer.
    We only copy entries != 0 to increase performance.
 */
-int ipt_acc_handle_copy_data(void *to_user, int *pos, 
-                                  struct ipt_acc_mask_24 *data,
-                                  u_int32_t net_ip, u_int32_t net_OR_mask)
+static int ipt_acc_handle_copy_data(void *to_user, int *pos,
+                                    struct ipt_acc_mask_24 *data,
+                                    u_int32_t net_ip, u_int32_t net_OR_mask)
 {
     struct ipt_acc_handle_ip handle_ip;
     u_int32_t handle_ip_size = sizeof (struct ipt_acc_handle_ip);
     u_int32_t i;
-    
+
     for (i = 0; i <= 255; i++) {
         if (data->ip[i].src_packets || data->ip[i].dst_packets) {
             handle_ip.ip = net_ip | net_OR_mask | (i<<24);
-            
+
             handle_ip.src_packets = data->ip[i].src_packets;
             handle_ip.src_bytes = data->ip[i].src_bytes;
             handle_ip.dst_packets = data->ip[i].dst_packets;
@@ -722,15 +721,15 @@
             *pos += handle_ip_size;
         }
     }
-    
+
     return 0;
 }
-   
-/* Copy the data from our internal structure 
+
+/* Copy the data from our internal structure
    We only copy entries != 0 to increase performance.
    Overwrites ipt_acc_tmpbuf.
 */
-int ipt_acc_handle_get_data(u_int32_t handle, void *to_user)
+static int ipt_acc_handle_get_data(u_int32_t handle, void *to_user)
 {
     u_int32_t tmpbuf_pos=0, net_ip;
     unsigned char depth;
@@ -751,11 +750,11 @@
 
     /* 8 bit network */
     if (depth == 0) {
-        struct ipt_acc_mask_24 *network = 
+        struct ipt_acc_mask_24 *network =
             (struct ipt_acc_mask_24*)ipt_acc_handles[handle].data;
         if (ipt_acc_handle_copy_data(to_user, &tmpbuf_pos, network, net_ip, 0))
             return -1;
-        
+
         /* Flush remaining data to userspace */
         if (tmpbuf_pos)
             if (copy_to_user(to_user, ipt_acc_tmpbuf, tmpbuf_pos))
@@ -766,14 +765,14 @@
 
     /* 16 bit network */
     if (depth == 1) {
-        struct ipt_acc_mask_16 *network_16 = 
+        struct ipt_acc_mask_16 *network_16 =
             (struct ipt_acc_mask_16*)ipt_acc_handles[handle].data;
         u_int32_t b;
         for (b = 0; b <= 255; b++) {
             if (network_16->mask_24[b]) {
-                struct ipt_acc_mask_24 *network = 
+                struct ipt_acc_mask_24 *network =
                     (struct ipt_acc_mask_24*)network_16->mask_24[b];
-                if (ipt_acc_handle_copy_data(to_user, &tmpbuf_pos, network, 
+                if (ipt_acc_handle_copy_data(to_user, &tmpbuf_pos, network,
                                              net_ip, (b << 16)))
                     return -1;
             }
@@ -789,16 +788,16 @@
 
     /* 24 bit network */
     if (depth == 2) {
-        struct ipt_acc_mask_8 *network_8 = 
+        struct ipt_acc_mask_8 *network_8 =
             (struct ipt_acc_mask_8*)ipt_acc_handles[handle].data;
         u_int32_t a, b;
         for (a = 0; a <= 255; a++) {
             if (network_8->mask_16[a]) {
-                struct ipt_acc_mask_16 *network_16 = 
+                struct ipt_acc_mask_16 *network_16 =
                     (struct ipt_acc_mask_16*)network_8->mask_16[a];
                 for (b = 0; b <= 255; b++) {
                     if (network_16->mask_24[b]) {
-                        struct ipt_acc_mask_24 *network = 
+                        struct ipt_acc_mask_24 *network =
                             (struct ipt_acc_mask_24*)network_16->mask_24[b];
                         if (ipt_acc_handle_copy_data(to_user, &tmpbuf_pos,
                                         network, net_ip, (a << 8) | (b << 16)))
@@ -815,11 +814,11 @@
 
         return 0;
     }
-    
+
     return -1;
 }
 
-static int ipt_acc_set_ctl(struct sock *sk, int cmd, 
+static int ipt_acc_set_ctl(struct sock *sk, int cmd,
                                void *user, u_int32_t len)
 {
     struct ipt_acc_handle_sockopt handle;
@@ -832,7 +831,7 @@
     case IPT_SO_SET_ACCOUNT_HANDLE_FREE:
         if (len != sizeof(struct ipt_acc_handle_sockopt)) {
             printk("ACCOUNT: ipt_acc_set_ctl: wrong data size (%u != %u) "
-                   "for IPT_SO_SET_HANDLE_FREE\n", 
+                   "for IPT_SO_SET_HANDLE_FREE\n",
                    len, sizeof(struct ipt_acc_handle_sockopt));
             break;
         }
@@ -881,7 +880,7 @@
             break;
         }
 
-        if (copy_from_user (&handle, user, 
+        if (copy_from_user (&handle, user,
                             sizeof(struct ipt_acc_handle_sockopt))) {
             return -EFAULT;
             break;
@@ -903,7 +902,7 @@
             break;
         }
 
-        if (copy_to_user(user, &handle, 
+        if (copy_to_user(user, &handle,
                          sizeof(struct ipt_acc_handle_sockopt))) {
             return -EFAULT;
             break;
@@ -918,7 +917,7 @@
             break;
         }
 
-        if (copy_from_user (&handle, user, 
+        if (copy_from_user (&handle, user,
                             sizeof(struct ipt_acc_handle_sockopt))) {
             return -EFAULT;
             break;
@@ -967,7 +966,7 @@
                     handle.itemcount++;
             spin_unlock_bh(&ipt_acc_userspace_lock);
 
-            if (copy_to_user(user, &handle, 
+            if (copy_to_user(user, &handle,
                              sizeof(struct ipt_acc_handle_sockopt))) {
                 return -EFAULT;
                 break;
@@ -978,7 +977,7 @@
     case IPT_SO_GET_ACCOUNT_GET_TABLE_NAMES: {
             u_int32_t size = 0, i;
             char *tnames;
-            
+
             spin_lock_bh(&ipt_acc_lock);
 
             /* Determine size of table names */
@@ -1044,22 +1043,22 @@
 
 static int __init init(void)
 {
-    if ((ipt_acc_tables = 
-         kmalloc(ACCOUNT_MAX_TABLES * 
+    if ((ipt_acc_tables =
+         kmalloc(ACCOUNT_MAX_TABLES *
                  sizeof(struct ipt_acc_table), GFP_KERNEL)) == NULL) {
         printk("ACCOUNT: Out of memory allocating account_tables structure");
         goto error_cleanup;
     }
-    memset(ipt_acc_tables, 0, 
+    memset(ipt_acc_tables, 0,
            ACCOUNT_MAX_TABLES * sizeof(struct ipt_acc_table));
 
-    if ((ipt_acc_handles = 
-         kmalloc(ACCOUNT_MAX_HANDLES * 
+    if ((ipt_acc_handles =
+         kmalloc(ACCOUNT_MAX_HANDLES *
                  sizeof(struct ipt_acc_handle), GFP_KERNEL)) == NULL) {
         printk("ACCOUNT: Out of memory allocating account_handles structure");
         goto error_cleanup;
     }
-    memset(ipt_acc_handles, 0, 
+    memset(ipt_acc_handles, 0,
            ACCOUNT_MAX_HANDLES * sizeof(struct ipt_acc_handle));
 
     /* Allocate one page as temporary storage */
@@ -1076,9 +1075,9 @@
 
     if (ipt_register_target(&ipt_acc_reg))
         goto error_cleanup;
-        
+
     return 0;
-        
+
 error_cleanup:
     if(ipt_acc_tables)
         kfree(ipt_acc_tables);
@@ -1086,7 +1085,7 @@
         kfree(ipt_acc_handles);
     if (ipt_acc_tmpbuf)
         free_page((unsigned long)ipt_acc_tmpbuf);
-        
+
     return -EINVAL;
 }
 

--=-x2DLz8iS6zearsSkXTPo--
