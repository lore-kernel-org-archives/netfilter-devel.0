From: Andreas Schultz <aschultz@tpip.net>
Subject: [PATCH xtables-addons] make xt_ACCOUNT network namespace aware
Date: Tue,  8 Dec 2015 18:41:33 +0100
Message-ID: <1449596493-1146-1-git-send-email-aschultz@tpip.net>
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:36426 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbbLHRu1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Dec 2015 12:50:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_ACCOUNTing objects create in one network namespace could be
read from all namespaces. Also object with the same name in
different namespaces would collide.

Signed-off-by: Andreas Schultz <aschultz@tpip.net>
---
 extensions/ACCOUNT/xt_ACCOUNT.c | 302 ++++++++++++++++++++++++----------------
 1 file changed, 179 insertions(+), 123 deletions(-)

diff --git a/extensions/ACCOUNT/xt_ACCOUNT.c b/extensions/ACCOUNT/xt_ACCOUNT.c
index 5c3d943..ed57a88 100644
--- a/extensions/ACCOUNT/xt_ACCOUNT.c
+++ b/extensions/ACCOUNT/xt_ACCOUNT.c
@@ -15,6 +15,7 @@
 //#define DEBUG 1
 #include <linux/module.h>
 #include <linux/version.h>
+#include <net/net_namespace.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <net/icmp.h>
@@ -29,6 +30,7 @@
 #include <linux/string.h>
 #include <linux/spinlock.h>
 #include <asm/uaccess.h>
+#include <net/netns/generic.h>
 
 #include <net/route.h>
 #include "xt_ACCOUNT.h"
@@ -100,14 +102,19 @@ struct ipt_acc_mask_8 {
 	struct ipt_acc_mask_16 *mask_16[256];
 };
 
-static struct ipt_acc_table *ipt_acc_tables;
-static struct ipt_acc_handle *ipt_acc_handles;
-static void *ipt_acc_tmpbuf;
+static int ipt_acc_net_id __read_mostly;
 
-/* Spinlock used for manipulating the current accounting tables/data */
-static DEFINE_SPINLOCK(ipt_acc_lock);
-/* Mutex (semaphore) used for manipulating userspace handles/snapshot data */
-static struct semaphore ipt_acc_userspace_mutex;
+struct ipt_acc_net {
+	/* Spinlock used for manipulating the current accounting tables/data */
+	spinlock_t ipt_acc_lock;
+
+	/* Mutex (semaphore) used for manipulating userspace handles/snapshot data */
+	struct semaphore ipt_acc_userspace_mutex;
+
+	struct ipt_acc_table *ipt_acc_tables;
+	struct ipt_acc_handle *ipt_acc_handles;
+	void *ipt_acc_tmpbuf;
+};
 
 /* Allocates a page pair and clears it */
 static void *ipt_acc_zalloc_page(void)
@@ -169,7 +176,8 @@ static void ipt_acc_data_free(void *data, uint8_t depth)
 
 /* Look for existing table / insert new one.
    Return internal ID or -1 on error */
-static int ipt_acc_table_insert(const char *name, __be32 ip, __be32 netmask)
+static int ipt_acc_table_insert(struct ipt_acc_table *ipt_acc_tables,
+				const char *name, __be32 ip, __be32 netmask)
 {
 	unsigned int i;
 
@@ -256,13 +264,15 @@ static int ipt_acc_table_insert(const char *name, __be32 ip, __be32 netmask)
 
 static int ipt_acc_checkentry(const struct xt_tgchk_param *par)
 {
+	struct ipt_acc_net *ian = net_generic(par->net, ipt_acc_net_id);
 	struct ipt_acc_info *info = par->targinfo;
 	int table_nr;
 
-	spin_lock_bh(&ipt_acc_lock);
-	table_nr = ipt_acc_table_insert(info->table_name, info->net_ip,
+	spin_lock_bh(&ian->ipt_acc_lock);
+	table_nr = ipt_acc_table_insert(ian->ipt_acc_tables,
+					info->table_name, info->net_ip,
 		info->net_mask);
-	spin_unlock_bh(&ipt_acc_lock);
+	spin_unlock_bh(&ian->ipt_acc_lock);
 
 	if (table_nr == -1) {
 		printk("ACCOUNT: Table insert problem. Aborting\n");
@@ -277,10 +287,11 @@ static int ipt_acc_checkentry(const struct xt_tgchk_param *par)
 
 static void ipt_acc_destroy(const struct xt_tgdtor_param *par)
 {
+	struct ipt_acc_net *ian = net_generic(par->net, ipt_acc_net_id);
 	unsigned int i;
 	struct ipt_acc_info *info = par->targinfo;
 
-	spin_lock_bh(&ipt_acc_lock);
+	spin_lock_bh(&ian->ipt_acc_lock);
 
 	pr_debug("ACCOUNT: ipt_acc_deleteentry called for table: %s (#%d)\n",
 		info->table_name, info->table_nr);
@@ -289,31 +300,31 @@ static void ipt_acc_destroy(const struct xt_tgdtor_param *par)
 
 	/* Look for table */
 	for (i = 0; i < ACCOUNT_MAX_TABLES; i++) {
-		if (strncmp(ipt_acc_tables[i].name, info->table_name,
+		if (strncmp(ian->ipt_acc_tables[i].name, info->table_name,
 		    ACCOUNT_TABLE_NAME_LEN) == 0) {
 			pr_debug("ACCOUNT: Found table at slot: %d\n", i);
 
-			ipt_acc_tables[i].refcount--;
+			ian->ipt_acc_tables[i].refcount--;
 			pr_debug("ACCOUNT: Refcount left: %d\n",
-				ipt_acc_tables[i].refcount);
+				ian->ipt_acc_tables[i].refcount);
 
 			/* Table not needed anymore? */
-			if (ipt_acc_tables[i].refcount == 0) {
+			if (ian->ipt_acc_tables[i].refcount == 0) {
 				pr_debug("ACCOUNT: Destroying table at slot: %d\n", i);
-				ipt_acc_data_free(ipt_acc_tables[i].data,
-					ipt_acc_tables[i].depth);
-				memset(&ipt_acc_tables[i], 0,
+				ipt_acc_data_free(ian->ipt_acc_tables[i].data,
+					ian->ipt_acc_tables[i].depth);
+				memset(&ian->ipt_acc_tables[i], 0,
 					sizeof(struct ipt_acc_table));
 			}
 
-			spin_unlock_bh(&ipt_acc_lock);
+			spin_unlock_bh(&ian->ipt_acc_lock);
 			return;
 		}
 	}
 
 	/* Table not found */
 	printk("ACCOUNT: Table %s not found for destroy\n", info->table_name);
-	spin_unlock_bh(&ipt_acc_lock);
+	spin_unlock_bh(&ian->ipt_acc_lock);
 }
 
 static void ipt_acc_depth0_insert(struct ipt_acc_mask_24 *mask_24,
@@ -471,6 +482,13 @@ static void ipt_acc_depth2_insert(struct ipt_acc_mask_8 *mask_8,
 static unsigned int
 ipt_acc_target(struct sk_buff *skb, const struct xt_action_param *par)
 {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,4,0)
+	struct ipt_acc_net *ian = net_generic(par->net, ipt_acc_net_id);
+#else
+	struct net *net = dev_net(par->in ? par->in : par->out);
+	struct ipt_acc_net *ian = net_generic(net, ipt_acc_net_id);
+#endif
+	struct ipt_acc_table *ipt_acc_tables = ian->ipt_acc_tables;
 	const struct ipt_acc_info *info =
 		par->targinfo;
 
@@ -478,13 +496,13 @@ ipt_acc_target(struct sk_buff *skb, const struct xt_action_param *par)
 	__be32 dst_ip = ip_hdr(skb)->daddr;
 	uint32_t size = ntohs(ip_hdr(skb)->tot_len);
 
-	spin_lock_bh(&ipt_acc_lock);
+	spin_lock_bh(&ian->ipt_acc_lock);
 
 	if (ipt_acc_tables[info->table_nr].name[0] == 0) {
 		printk("ACCOUNT: ipt_acc_target: Invalid table id %u. "
 			"IPs %u.%u.%u.%u/%u.%u.%u.%u\n", info->table_nr,
 			NIPQUAD(src_ip), NIPQUAD(dst_ip));
-		spin_unlock_bh(&ipt_acc_lock);
+		spin_unlock_bh(&ian->ipt_acc_lock);
 		return XT_CONTINUE;
 	}
 
@@ -496,7 +514,7 @@ ipt_acc_target(struct sk_buff *skb, const struct xt_action_param *par)
 			ipt_acc_tables[info->table_nr].ip,
 			ipt_acc_tables[info->table_nr].netmask,
 			src_ip, dst_ip, size, &ipt_acc_tables[info->table_nr].itemcount);
-		spin_unlock_bh(&ipt_acc_lock);
+		spin_unlock_bh(&ian->ipt_acc_lock);
 		return XT_CONTINUE;
 	}
 
@@ -507,7 +525,7 @@ ipt_acc_target(struct sk_buff *skb, const struct xt_action_param *par)
 			ipt_acc_tables[info->table_nr].ip,
 			ipt_acc_tables[info->table_nr].netmask,
 			src_ip, dst_ip, size, &ipt_acc_tables[info->table_nr].itemcount);
-		spin_unlock_bh(&ipt_acc_lock);
+		spin_unlock_bh(&ian->ipt_acc_lock);
 		return XT_CONTINUE;
 	}
 
@@ -518,7 +536,7 @@ ipt_acc_target(struct sk_buff *skb, const struct xt_action_param *par)
 			ipt_acc_tables[info->table_nr].ip,
 			ipt_acc_tables[info->table_nr].netmask,
 			src_ip, dst_ip, size, &ipt_acc_tables[info->table_nr].itemcount);
-		spin_unlock_bh(&ipt_acc_lock);
+		spin_unlock_bh(&ian->ipt_acc_lock);
 		return XT_CONTINUE;
 	}
 
@@ -526,7 +544,7 @@ ipt_acc_target(struct sk_buff *skb, const struct xt_action_param *par)
 		"Table id %u. IPs %u.%u.%u.%u/%u.%u.%u.%u\n",
 		info->table_nr, NIPQUAD(src_ip), NIPQUAD(dst_ip));
 
-	spin_unlock_bh(&ipt_acc_lock);
+	spin_unlock_bh(&ian->ipt_acc_lock);
 	return XT_CONTINUE;
 }
 
@@ -547,7 +565,7 @@ ipt_acc_target(struct sk_buff *skb, const struct xt_action_param *par)
 	but there could be two or more applications accessing the data
 	at the same time.
 */
-static int ipt_acc_handle_find_slot(void)
+static int ipt_acc_handle_find_slot(struct ipt_acc_handle *ipt_acc_handles)
 {
 	unsigned int i;
 	/* Insert new table */
@@ -567,7 +585,8 @@ static int ipt_acc_handle_find_slot(void)
 	return -1;
 }
 
-static int ipt_acc_handle_free(unsigned int handle)
+static int ipt_acc_handle_free(struct ipt_acc_handle *ipt_acc_handles,
+			       unsigned int handle)
 {
 	if (handle >= ACCOUNT_MAX_HANDLES) {
 		printk("ACCOUNT: Invalid handle for ipt_acc_handle_free() specified:"
@@ -583,7 +602,8 @@ static int ipt_acc_handle_free(unsigned int handle)
 
 /* Prepare data for read without flush. Use only for debugging!
    Real applications should use read&flush as it's way more efficent */
-static int ipt_acc_handle_prepare_read(char *tablename,
+static int ipt_acc_handle_prepare_read(struct ipt_acc_table *ipt_acc_tables,
+				       char *tablename,
 		 struct ipt_acc_handle *dest, uint32_t *count)
 {
 	int table_nr = -1;
@@ -685,7 +705,8 @@ static int ipt_acc_handle_prepare_read(char *tablename,
 }
 
 /* Prepare data for read and flush it */
-static int ipt_acc_handle_prepare_read_flush(char *tablename,
+static int ipt_acc_handle_prepare_read_flush(struct ipt_acc_table *ipt_acc_tables,
+					     char *tablename,
 			   struct ipt_acc_handle *dest, uint32_t *count)
 {
 	int table_nr;
@@ -726,7 +747,8 @@ static int ipt_acc_handle_prepare_read_flush(char *tablename,
 /* Copy 8 bit network data into a prepared buffer.
    We only copy entries != 0 to increase performance.
 */
-static int ipt_acc_handle_copy_data(void *to_user, unsigned long *to_user_pos,
+static int ipt_acc_handle_copy_data(struct ipt_acc_net *ian,
+				    void *to_user, unsigned long *to_user_pos,
 				unsigned long *tmpbuf_pos,
 				struct ipt_acc_mask_24 *data,
 				uint32_t net_ip, uint32_t net_OR_mask)
@@ -748,13 +770,13 @@ static int ipt_acc_handle_copy_data(void *to_user, unsigned long *to_user_pos,
 
 		/* Temporary buffer full? Flush to userspace */
 		if (*tmpbuf_pos + handle_ip_size >= PAGE_SIZE) {
-			if (copy_to_user(to_user + *to_user_pos, ipt_acc_tmpbuf,
+			if (copy_to_user(to_user + *to_user_pos, ian->ipt_acc_tmpbuf,
 			    *tmpbuf_pos))
 				return -EFAULT;
 			*to_user_pos = *to_user_pos + *tmpbuf_pos;
 			*tmpbuf_pos = 0;
 		}
-		memcpy(ipt_acc_tmpbuf + *tmpbuf_pos, &handle_ip, handle_ip_size);
+		memcpy(ian->ipt_acc_tmpbuf + *tmpbuf_pos, &handle_ip, handle_ip_size);
 		*tmpbuf_pos += handle_ip_size;
 	}
 
@@ -765,7 +787,8 @@ static int ipt_acc_handle_copy_data(void *to_user, unsigned long *to_user_pos,
    We only copy entries != 0 to increase performance.
    Overwrites ipt_acc_tmpbuf.
 */
-static int ipt_acc_handle_get_data(uint32_t handle, void *to_user)
+static int ipt_acc_handle_get_data(struct ipt_acc_net *ian,
+				   uint32_t handle, void *to_user)
 {
 	unsigned long to_user_pos = 0, tmpbuf_pos = 0;
 	uint32_t net_ip;
@@ -777,25 +800,25 @@ static int ipt_acc_handle_get_data(uint32_t handle, void *to_user)
 		return -1;
 	}
 
-	if (ipt_acc_handles[handle].data == NULL) {
+	if (ian->ipt_acc_handles[handle].data == NULL) {
 		printk("ACCOUNT: handle %u is BROKEN: Contains no data\n", handle);
 		return -1;
 	}
 
-	net_ip = ntohl(ipt_acc_handles[handle].ip);
-	depth = ipt_acc_handles[handle].depth;
+	net_ip = ntohl(ian->ipt_acc_handles[handle].ip);
+	depth = ian->ipt_acc_handles[handle].depth;
 
 	/* 8 bit network */
 	if (depth == 0) {
 		struct ipt_acc_mask_24 *network =
-			ipt_acc_handles[handle].data;
-		if (ipt_acc_handle_copy_data(to_user, &to_user_pos, &tmpbuf_pos,
+			ian->ipt_acc_handles[handle].data;
+		if (ipt_acc_handle_copy_data(ian, to_user, &to_user_pos, &tmpbuf_pos,
 		    network, net_ip, 0))
 			return -1;
 
 		/* Flush remaining data to userspace */
 		if (tmpbuf_pos)
-			if (copy_to_user(to_user + to_user_pos, ipt_acc_tmpbuf, tmpbuf_pos))
+			if (copy_to_user(to_user + to_user_pos, ian->ipt_acc_tmpbuf, tmpbuf_pos))
 				return -1;
 
 		return 0;
@@ -804,13 +827,13 @@ static int ipt_acc_handle_get_data(uint32_t handle, void *to_user)
 	/* 16 bit network */
 	if (depth == 1) {
 		struct ipt_acc_mask_16 *network_16 =
-			ipt_acc_handles[handle].data;
+			ian->ipt_acc_handles[handle].data;
 		unsigned int b;
 		for (b = 0; b <= 255; b++) {
 			if (network_16->mask_24[b]) {
 				struct ipt_acc_mask_24 *network =
 					network_16->mask_24[b];
-				if (ipt_acc_handle_copy_data(to_user, &to_user_pos,
+				if (ipt_acc_handle_copy_data(ian, to_user, &to_user_pos,
 				    &tmpbuf_pos, network, net_ip, (b << 8)))
 					return -1;
 			}
@@ -818,7 +841,7 @@ static int ipt_acc_handle_get_data(uint32_t handle, void *to_user)
 
 		/* Flush remaining data to userspace */
 		if (tmpbuf_pos)
-			if (copy_to_user(to_user + to_user_pos, ipt_acc_tmpbuf, tmpbuf_pos))
+			if (copy_to_user(to_user + to_user_pos, ian->ipt_acc_tmpbuf, tmpbuf_pos))
 				return -1;
 
 		return 0;
@@ -827,7 +850,7 @@ static int ipt_acc_handle_get_data(uint32_t handle, void *to_user)
 	/* 24 bit network */
 	if (depth == 2) {
 		struct ipt_acc_mask_8 *network_8 =
-			ipt_acc_handles[handle].data;
+			ian->ipt_acc_handles[handle].data;
 		unsigned int a, b;
 		for (a = 0; a <= 255; a++) {
 			if (network_8->mask_16[a]) {
@@ -837,7 +860,7 @@ static int ipt_acc_handle_get_data(uint32_t handle, void *to_user)
 					if (network_16->mask_24[b]) {
 						struct ipt_acc_mask_24 *network =
 							network_16->mask_24[b];
-						if (ipt_acc_handle_copy_data(to_user,
+						if (ipt_acc_handle_copy_data(ian, to_user,
 						    &to_user_pos, &tmpbuf_pos,
 						    network, net_ip, (a << 16) | (b << 8)))
 							return -1;
@@ -848,7 +871,7 @@ static int ipt_acc_handle_get_data(uint32_t handle, void *to_user)
 
 		/* Flush remaining data to userspace */
 		if (tmpbuf_pos)
-			if (copy_to_user(to_user + to_user_pos, ipt_acc_tmpbuf, tmpbuf_pos))
+			if (copy_to_user(to_user + to_user_pos, ian->ipt_acc_tmpbuf, tmpbuf_pos))
 				return -1;
 
 		return 0;
@@ -860,6 +883,8 @@ static int ipt_acc_handle_get_data(uint32_t handle, void *to_user)
 static int ipt_acc_set_ctl(struct sock *sk, int cmd,
 			void *user, unsigned int len)
 {
+	struct net *net = sock_net(sk);
+	struct ipt_acc_net *ian = net_generic(net, ipt_acc_net_id);
 	struct ipt_acc_handle_sockopt handle;
 	int ret = -EINVAL;
 
@@ -881,16 +906,16 @@ static int ipt_acc_set_ctl(struct sock *sk, int cmd,
 			break;
 		}
 
-		down(&ipt_acc_userspace_mutex);
-		ret = ipt_acc_handle_free(handle.handle_nr);
-		up(&ipt_acc_userspace_mutex);
+		down(&ian->ipt_acc_userspace_mutex);
+		ret = ipt_acc_handle_free(ian->ipt_acc_handles, handle.handle_nr);
+		up(&ian->ipt_acc_userspace_mutex);
 		break;
 	case IPT_SO_SET_ACCOUNT_HANDLE_FREE_ALL: {
 		unsigned int i;
-		down(&ipt_acc_userspace_mutex);
+		down(&ian->ipt_acc_userspace_mutex);
 		for (i = 0; i < ACCOUNT_MAX_HANDLES; i++)
-			ipt_acc_handle_free(i);
-		up(&ipt_acc_userspace_mutex);
+			ipt_acc_handle_free(ian->ipt_acc_handles, i);
+		up(&ian->ipt_acc_userspace_mutex);
 		ret = 0;
 		break;
 	}
@@ -903,6 +928,8 @@ static int ipt_acc_set_ctl(struct sock *sk, int cmd,
 
 static int ipt_acc_get_ctl(struct sock *sk, int cmd, void *user, int *len)
 {
+	struct net *net = sock_net(sk);
+	struct ipt_acc_net *ian = net_generic(net, ipt_acc_net_id);
 	struct ipt_acc_handle_sockopt handle;
 	int ret = -EINVAL;
 
@@ -927,28 +954,28 @@ static int ipt_acc_get_ctl(struct sock *sk, int cmd, void *user, int *len)
 			break;
 		}
 
-		spin_lock_bh(&ipt_acc_lock);
+		spin_lock_bh(&ian->ipt_acc_lock);
 		if (cmd == IPT_SO_GET_ACCOUNT_PREPARE_READ_FLUSH)
 			ret = ipt_acc_handle_prepare_read_flush(
-				handle.name, &dest, &handle.itemcount);
+				ian->ipt_acc_tables, handle.name, &dest, &handle.itemcount);
 		else
 			ret = ipt_acc_handle_prepare_read(
-				handle.name, &dest, &handle.itemcount);
-		spin_unlock_bh(&ipt_acc_lock);
+				ian->ipt_acc_tables, handle.name, &dest, &handle.itemcount);
+		spin_unlock_bh(&ian->ipt_acc_lock);
 		// Error occured during prepare_read?
 		if (ret == -1)
 			return -EINVAL;
 
 		/* Allocate a userspace handle */
-		down(&ipt_acc_userspace_mutex);
-		if ((handle.handle_nr = ipt_acc_handle_find_slot()) == -1) {
+		down(&ian->ipt_acc_userspace_mutex);
+		if ((handle.handle_nr = ipt_acc_handle_find_slot(ian->ipt_acc_handles)) == -1) {
 			ipt_acc_data_free(dest.data, dest.depth);
-			up(&ipt_acc_userspace_mutex);
+			up(&ian->ipt_acc_userspace_mutex);
 			return -EINVAL;
 		}
-		memcpy(&ipt_acc_handles[handle.handle_nr], &dest,
+		memcpy(&ian->ipt_acc_handles[handle.handle_nr], &dest,
 			sizeof(struct ipt_acc_handle));
-		up(&ipt_acc_userspace_mutex);
+		up(&ian->ipt_acc_userspace_mutex);
 
 		if (copy_to_user(user, &handle,
 		    sizeof(struct ipt_acc_handle_sockopt))) {
@@ -977,19 +1004,19 @@ static int ipt_acc_get_ctl(struct sock *sk, int cmd, void *user, int *len)
 			break;
 		}
 
-		if (*len < ipt_acc_handles[handle.handle_nr].itemcount
+		if (*len < ian->ipt_acc_handles[handle.handle_nr].itemcount
 		    * sizeof(struct ipt_acc_handle_ip)) {
 			printk("ACCOUNT: ipt_acc_get_ctl: not enough space (%u < %zu)"
 				" to store data from IPT_SO_GET_ACCOUNT_GET_DATA\n",
-				*len, ipt_acc_handles[handle.handle_nr].itemcount
+				*len, ian->ipt_acc_handles[handle.handle_nr].itemcount
 				* sizeof(struct ipt_acc_handle_ip));
 			ret = -ENOMEM;
 			break;
 		}
 
-		down(&ipt_acc_userspace_mutex);
-		ret = ipt_acc_handle_get_data(handle.handle_nr, user);
-		up(&ipt_acc_userspace_mutex);
+		down(&ian->ipt_acc_userspace_mutex);
+		ret = ipt_acc_handle_get_data(ian, handle.handle_nr, user);
+		up(&ian->ipt_acc_userspace_mutex);
 		if (ret) {
 			printk("ACCOUNT: ipt_acc_get_ctl: ipt_acc_handle_get_data"
 				" failed for handle %u\n", handle.handle_nr);
@@ -1009,11 +1036,11 @@ static int ipt_acc_get_ctl(struct sock *sk, int cmd, void *user, int *len)
 
 		/* Find out how many handles are in use */
 		handle.itemcount = 0;
-		down(&ipt_acc_userspace_mutex);
+		down(&ian->ipt_acc_userspace_mutex);
 		for (i = 0; i < ACCOUNT_MAX_HANDLES; i++)
-			if (ipt_acc_handles[i].data)
+			if (ian->ipt_acc_handles[i].data)
 				handle.itemcount++;
-		up(&ipt_acc_userspace_mutex);
+		up(&ian->ipt_acc_userspace_mutex);
 
 		if (copy_to_user(user, &handle,
 		    sizeof(struct ipt_acc_handle_sockopt))) {
@@ -1027,38 +1054,38 @@ static int ipt_acc_get_ctl(struct sock *sk, int cmd, void *user, int *len)
 		uint32_t size = 0, i, name_len;
 		char *tnames;
 
-		spin_lock_bh(&ipt_acc_lock);
+		spin_lock_bh(&ian->ipt_acc_lock);
 
 		/* Determine size of table names */
 		for (i = 0; i < ACCOUNT_MAX_TABLES; i++) {
-			if (ipt_acc_tables[i].name[0] != 0)
-				size += strlen(ipt_acc_tables[i].name) + 1;
+			if (ian->ipt_acc_tables[i].name[0] != 0)
+				size += strlen(ian->ipt_acc_tables[i].name) + 1;
 		}
 		size += 1;	/* Terminating NULL character */
 
 		if (*len < size || size > PAGE_SIZE) {
-			spin_unlock_bh(&ipt_acc_lock);
+			spin_unlock_bh(&ian->ipt_acc_lock);
 			printk("ACCOUNT: ipt_acc_get_ctl: not enough space (%u < %u < %lu)"
 				" to store table names\n", *len, size, PAGE_SIZE);
 			ret = -ENOMEM;
 			break;
 		}
 		/* Copy table names to userspace */
-		tnames = ipt_acc_tmpbuf;
+		tnames = ian->ipt_acc_tmpbuf;
 		for (i = 0; i < ACCOUNT_MAX_TABLES; i++) {
-			if (ipt_acc_tables[i].name[0] != 0) {
-				name_len = strlen(ipt_acc_tables[i].name) + 1;
-				memcpy(tnames, ipt_acc_tables[i].name, name_len);
+			if (ian->ipt_acc_tables[i].name[0] != 0) {
+				name_len = strlen(ian->ipt_acc_tables[i].name) + 1;
+				memcpy(tnames, ian->ipt_acc_tables[i].name, name_len);
 				tnames += name_len;
 			}
 		}
-		spin_unlock_bh(&ipt_acc_lock);
+		spin_unlock_bh(&ian->ipt_acc_lock);
 
 		/* Terminating NULL character */
 		*tnames = 0;
 
 		/* Transfer to userspace */
-		if (copy_to_user(user, ipt_acc_tmpbuf, size))
+		if (copy_to_user(user, ian->ipt_acc_tmpbuf, size))
 			return -EFAULT;
 
 		ret = 0;
@@ -1071,6 +1098,57 @@ static int ipt_acc_get_ctl(struct sock *sk, int cmd, void *user, int *len)
 	return ret;
 }
 
+static int __net_init ipt_acc_net_init(struct net *net)
+{
+	struct ipt_acc_net *ian = net_generic(net, ipt_acc_net_id);
+
+	sema_init(&ian->ipt_acc_userspace_mutex, 1);
+
+	if ((ian->ipt_acc_tables =
+	     kcalloc(ACCOUNT_MAX_TABLES,
+		     sizeof(struct ipt_acc_table), GFP_KERNEL)) == NULL) {
+		printk("ACCOUNT: Out of memory allocating account_tables structure");
+		goto error_cleanup;
+	}
+	if ((ian->ipt_acc_handles =
+	     kcalloc(ACCOUNT_MAX_HANDLES,
+		     sizeof(struct ipt_acc_handle), GFP_KERNEL)) == NULL) {
+		printk("ACCOUNT: Out of memory allocating account_handles structure");
+		goto error_cleanup;
+	}
+
+	/* Allocate one page as temporary storage */
+	if ((ian->ipt_acc_tmpbuf = (void *)__get_free_pages(GFP_KERNEL, 2)) == NULL) {
+		printk("ACCOUNT: Out of memory for temporary buffer page\n");
+		goto error_cleanup;
+	}
+
+	return 0;
+
+error_cleanup:
+	kfree(ian->ipt_acc_tables);
+	kfree(ian->ipt_acc_handles);
+	free_pages((unsigned long)ian->ipt_acc_tmpbuf, 2);
+
+	return -ENOMEM;
+}
+
+static void __net_exit ipt_acc_net_exit(struct net *net)
+{
+	struct ipt_acc_net *ian = net_generic(net, ipt_acc_net_id);
+
+	kfree(ian->ipt_acc_tables);
+	kfree(ian->ipt_acc_handles);
+	free_pages((unsigned long)ian->ipt_acc_tmpbuf, 2);
+}
+
+static struct pernet_operations ipt_acc_net_ops = {
+	.init = ipt_acc_net_init,
+	.exit = ipt_acc_net_exit,
+	.id   = &ipt_acc_net_id,
+	.size = sizeof(struct ipt_acc_net),
+};
+
 static struct xt_target xt_acc_reg __read_mostly = {
 	.name = "ACCOUNT",
 	.revision = 1,
@@ -1094,63 +1172,41 @@ static struct nf_sockopt_ops ipt_acc_sockopts = {
 
 static int __init account_tg_init(void)
 {
-	sema_init(&ipt_acc_userspace_mutex, 1);
+	int ret;
 
-	if ((ipt_acc_tables =
-	    kmalloc(ACCOUNT_MAX_TABLES *
-	    sizeof(struct ipt_acc_table), GFP_KERNEL)) == NULL) {
-		printk("ACCOUNT: Out of memory allocating account_tables structure");
-		goto error_cleanup;
-	}
-	memset(ipt_acc_tables, 0,
-		ACCOUNT_MAX_TABLES * sizeof(struct ipt_acc_table));
-
-	if ((ipt_acc_handles =
-	    kmalloc(ACCOUNT_MAX_HANDLES *
-	    sizeof(struct ipt_acc_handle), GFP_KERNEL)) == NULL) {
-		printk("ACCOUNT: Out of memory allocating account_handles structure");
-		goto error_cleanup;
-	}
-	memset(ipt_acc_handles, 0,
-		ACCOUNT_MAX_HANDLES * sizeof(struct ipt_acc_handle));
-
-	/* Allocate one page as temporary storage */
-	if ((ipt_acc_tmpbuf = (void *)__get_free_pages(GFP_KERNEL, 2)) == NULL) {
-		printk("ACCOUNT: Out of memory for temporary buffer page\n");
-		goto error_cleanup;
+	ret = register_pernet_subsys(&ipt_acc_net_ops);
+	if (ret < 0) {
+		pr_err("ACCOUNT: cannot register per net operations.\n");
+		goto error_out;
 	}
 
 	/* Register setsockopt */
-	if (nf_register_sockopt(&ipt_acc_sockopts) < 0) {
-		printk("ACCOUNT: Can't register sockopts. Aborting\n");
-		goto error_cleanup;
+	ret = nf_register_sockopt(&ipt_acc_sockopts);
+	if (ret < 0) {
+		pr_err("ACCOUNT: cannot register sockopts.\n");
+		goto unreg_pernet;
 	}
 
-	if (xt_register_target(&xt_acc_reg))
-		goto error_cleanup;
-
+	ret = xt_register_target(&xt_acc_reg);
+	if (ret < 0) {
+		pr_err("ACCOUNT: cannot register sockopts.\n");
+		goto unreg_sockopt;
+	}
 	return 0;
 
-error_cleanup:
-	if (ipt_acc_tables)
-		kfree(ipt_acc_tables);
-	if (ipt_acc_handles)
-		kfree(ipt_acc_handles);
-	if (ipt_acc_tmpbuf)
-		free_pages((unsigned long)ipt_acc_tmpbuf, 2);
-
-	return -EINVAL;
+unreg_sockopt:
+	nf_unregister_sockopt(&ipt_acc_sockopts);
+unreg_pernet:
+	unregister_pernet_subsys(&ipt_acc_net_ops);
+error_out:
+        return ret;
 }
 
 static void __exit account_tg_exit(void)
 {
 	xt_unregister_target(&xt_acc_reg);
-
 	nf_unregister_sockopt(&ipt_acc_sockopts);
-
-	kfree(ipt_acc_tables);
-	kfree(ipt_acc_handles);
-	free_pages((unsigned long)ipt_acc_tmpbuf, 2);
+	unregister_pernet_subsys(&ipt_acc_net_ops);
 }
 
 module_init(account_tg_init);
-- 
2.5.0

