From: Josh Samuelson <josamue1@wsc.edu>
Subject: [PATCH 2/2] Introducing the timer target and match
Date: Tue, 28 Jun 2005 18:54:54 -0500
Message-ID: <20050628235454.GC23662@wsc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GID0FwUMdk1T2AWN"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings again,

This patch adds a TIMER target and a timer match.

Quoting the man page for the target:

  This is used to allow you to add a packet's source or destination, MAC
  or IPv4 address to a named table which has a corresponding timeout
  value associated with it.  New packets matching the target will refresh
  the timeout value for an entry in the named table.  The timeout value
  can also be refreshed by echoing the MAC or IPv4 address  to
  /proc/net/ipt_TIMER/name.  The live timeout values can also be read
  from the same proc file.

Quoting the man page for the match:

  This matches a packet if its address exists in the named TIMER target
  table.  The TIMER table properties will determine whether the source or
  destination, MAC or IPv4 address of the packet is checked.

Since this patch deals with raw MAC addresses and the concern that was
brought up on the list [1], does it appear that I handled that
properly?

The patch should apply to 2.6.12 and iptables v1.3.1.  Though I'll
be away from my email for the next week, I would appreciate any
feedback.  Questions?  Comments?  Useful/not?

[1]
http://lists.netfilter.org/pipermail/netfilter-devel/2005-April/019503.html

Cheers,
Josh

--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-timer-20050628.diff"

diff -Nru a/include/linux/netfilter_ipv4/ipt_TIMER.h b/include/linux/netfilter_ipv4/ipt_TIMER.h
--- a/include/linux/netfilter_ipv4/ipt_TIMER.h	1969-12-31 18:00:00.000000000 -0600
+++ b/include/linux/netfilter_ipv4/ipt_TIMER.h	2005-06-28 14:21:45.000000000 -0500
@@ -0,0 +1,71 @@
+#ifndef _IPT_TIMER_H
+#define _IPT_TIMER_H
+
+#define TIMER_NAME_LEN 128
+
+typedef enum { IPT_TIMER_MAC, IPT_TIMER_IPV4, IPT_TIMER_MAX } ipt_timer_t;
+
+#ifdef __KERNEL__
+
+struct ipt_timer_mac
+{
+	u_int8_t raw[MAX_ADDR_LEN];
+	u_int32_t len;
+};
+
+struct ipt_timer
+{
+	struct list_head list;
+	struct timer_list timer;
+	union
+	{
+		struct ipt_timer_mac mac;
+		u_int32_t ip;
+	} type;
+};
+
+#endif
+
+struct ipt_timer_t_info
+{
+#ifdef __KERNEL__
+	struct list_head list,
+			 *htable;
+	struct proc_dir_entry *pde;
+#else
+	struct
+	{
+		void *next,
+		     *prev;
+	} list,
+	  *htable;
+	void *pde;
+#endif
+	void *me;
+	char name[TIMER_NAME_LEN],
+	     dst;
+	ipt_timer_t type;
+	unsigned int htable_size,
+		     htable_rand,
+		     timeout,
+		     use;
+};
+
+struct ipt_timer_m_info
+{
+	char name[TIMER_NAME_LEN];
+	u_int8_t invert;
+};
+
+#ifdef __KERNEL__
+extern rwlock_t ipt_timer_lock;
+extern int ipt_get_addr(struct ipt_timer_t_info *ttinfo,
+	struct ipt_timer *ta,
+	const struct sk_buff *skb,
+	const struct net_device *nd);
+extern struct ipt_timer *ipt_timer_find(struct ipt_timer_t_info *ttinfo,
+	const struct ipt_timer *ta);
+extern struct ipt_timer_t_info *ipt_timer_t_find(const char *name);
+#endif
+
+#endif /* _IPT_TIMER_H */
diff -Nru a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig	2005-03-05 02:07:52.000000000 -0600
+++ b/net/ipv4/netfilter/Kconfig	2005-06-28 15:26:56.000000000 -0500
@@ -375,6 +375,17 @@
 	  destination IP' or `500pps from any given source IP'  with a single
 	  IPtables rule.
 
+config IP_NF_MATCH_TIMER
+	tristate "MAC/IPv4 address timer match support"
+	depends on IP_NF_IPTABLES && IP_NF_TARGET_TIMER && EXPERIMENTAL
+	help
+	  This option adds the ability to match a packet if its address
+	  exists in the named TIMER target table.  The TIMER table
+	  properties will determine whether the source or destination,
+	  MAC or IPv4 address of the packet is checked.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
@@ -445,6 +456,24 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_TARGET_TIMER
+	tristate "MAC/IPv4 address timer target support"
+	depends on IP_NF_IPTABLES && EXPERIMENTAL
+	help
+	  This option adds a 'TIMER' target which allows you to add
+	  a packet's source or destionation, MAC or IPv4 address to a named
+	  table which has a corresponding timeout value associated with it.
+	  New packets matching the target will refresh the timeout value
+	  for an entry in the named table.  The timeout value can also be
+	  refreshed by echoing the MAC or IPv4 address to
+	  /proc/net/ipt_TIMER/name.  The live timeout values can also
+	  be read from the same proc file.
+
+	  See "MAC/IPv4 address timer match support" to match packets from
+	  entries in this target table.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 # NAT + specific targets
 config IP_NF_NAT
 	tristate "Full NAT"
diff -Nru a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile	2005-03-05 02:07:52.000000000 -0600
+++ b/net/ipv4/netfilter/Makefile	2005-06-28 15:26:56.000000000 -0500
@@ -59,6 +59,7 @@
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
 obj-$(CONFIG_IP_NF_MATCH_COMMENT) += ipt_comment.o
+obj-$(CONFIG_IP_NF_MATCH_TIMER) += ipt_timer.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
@@ -76,6 +77,7 @@
 obj-$(CONFIG_IP_NF_TARGET_CONNMARK) += ipt_CONNMARK.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 obj-$(CONFIG_IP_NF_TARGET_TCPMSS) += ipt_TCPMSS.o
+obj-$(CONFIG_IP_NF_TARGET_TIMER) += ipt_TIMER.o
 obj-$(CONFIG_IP_NF_TARGET_NOTRACK) += ipt_NOTRACK.o
 obj-$(CONFIG_IP_NF_TARGET_CLUSTERIP) += ipt_CLUSTERIP.o
 
diff -Nru a/net/ipv4/netfilter/ipt_TIMER.c b/net/ipv4/netfilter/ipt_TIMER.c
--- a/net/ipv4/netfilter/ipt_TIMER.c	1969-12-31 18:00:00.000000000 -0600
+++ b/net/ipv4/netfilter/ipt_TIMER.c	2005-06-28 14:23:15.000000000 -0500
@@ -0,0 +1,760 @@
+/* Kernel module that creates a target table (source/destination, MAC/IPv4
+ * addresses entries with timers)
+ */
+
+/* (C) 2004 2005 Josh Samuelson <josamue1@wsc.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/jhash.h>
+#include <linux/random.h>
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/netdevice.h>
+#include <linux/if_arp.h>
+#include <linux/if_ether.h>
+#ifdef CONFIG_PROC_FS
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#endif
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <linux/netfilter_ipv4/ipt_TIMER.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Josh Samuelson <josamue1@wsc.edu>");
+MODULE_DESCRIPTION("target module for MAC/IPv4 address timers");
+
+rwlock_t ipt_timer_lock = RW_LOCK_UNLOCKED;
+EXPORT_SYMBOL(ipt_timer_lock);
+static struct list_head ipt_timer_head;
+static kmem_cache_t *ipt_timer_cachep;
+#ifdef CONFIG_PROC_FS
+static struct proc_dir_entry *ipt_timer_procdir;
+#endif
+
+static void
+ipt_timer_update(struct ipt_timer_t_info *ttinfo, const struct ipt_timer *ta);
+
+#ifdef CONFIG_PROC_FS
+
+/* These must match up with the ipt_timer_t constants in ipt_TIMER.h */
+static const char *timer_types[] = { "mac", "ip", NULL };
+
+struct ipt_timer_iter_state {
+	unsigned int bucket;
+	struct proc_dir_entry *pde;
+};
+
+static struct list_head *
+ipt_timer_get_first(struct seq_file *seq)
+{
+	struct ipt_timer_iter_state *st = seq->private;
+	struct ipt_timer_t_info *ttinfo = st->pde->data;
+
+	for (st->bucket = 0; st->bucket < ttinfo->htable_size; st->bucket++) {
+		if (!list_empty(&ttinfo->htable[st->bucket]))
+			return ttinfo->htable[st->bucket].next;
+	}
+	return NULL;
+}
+
+static struct list_head *
+ipt_timer_get_next(struct seq_file *seq, struct list_head *head)
+{
+	struct ipt_timer_iter_state *st = seq->private;
+	struct ipt_timer_t_info *ttinfo = st->pde->data;
+
+	head = head->next;
+	while (head == &ttinfo->htable[st->bucket]) {
+		if (++st->bucket >= ttinfo->htable_size)
+			return NULL;
+		head = ttinfo->htable[st->bucket].next;
+	}
+	return head;
+}
+
+static struct list_head *
+ipt_timer_get_idx(struct seq_file *seq, loff_t pos)
+{
+	struct list_head *head = ipt_timer_get_first(seq);
+
+	if (head)
+		while (pos && (head = ipt_timer_get_next(seq, head)))
+			pos--;
+	return pos ? NULL : head;
+}
+
+static void *
+ipt_timer_seq_start(struct seq_file *seq, loff_t *ppos)
+{
+	struct ipt_timer_iter_state *st = seq->private;
+	struct ipt_timer_t_info *ttinfo = st->pde->data;
+
+	read_lock_bh(&ipt_timer_lock);
+	if (seq_printf(seq, "%u %s %s\n",
+		       ttinfo->timeout,
+		       (ttinfo->dst ? "dst" : "src"),
+		       timer_types[ttinfo->type]))
+		return ERR_PTR(-ENOSPC);
+	return ipt_timer_get_idx(seq, *ppos);
+}
+  
+static void
+ipt_timer_seq_stop(struct seq_file *seq, void *v)
+{
+	read_unlock_bh(&ipt_timer_lock);
+}
+
+static void *
+ipt_timer_seq_next(struct seq_file *seq, void *v, loff_t *ppos)
+{
+/*	ASSERT_READ_LOCK(&ipt_timer_lock); */
+	(*ppos)++;
+	return ipt_timer_get_next(seq, v);
+}
+
+static int
+ipt_timer_seq_show(struct seq_file *seq, void *v)
+{
+	unsigned int loop;
+	struct ipt_timer_iter_state *st = seq->private;
+	struct ipt_timer_t_info *ttinfo = st->pde->data;
+	struct ipt_timer *t = (struct ipt_timer *) v;
+
+/*	ASSERT_READ_LOCK(&ipt_timer_lock); */
+	switch(ttinfo->type) {
+		case IPT_TIMER_MAC:
+			if (seq_printf(seq, "%lu ",
+				       (t->timer.expires - jiffies) / HZ))
+				return -ENOSPC;
+			for (loop = 0; loop < t->type.mac.len; loop++) {
+				if (loop == 0) {
+					if (seq_printf(seq, "%02x",
+						       t->type.mac.raw[loop]))
+						return -ENOSPC;
+				} else {
+					if (seq_printf(seq, ":%02x",
+						       t->type.mac.raw[loop]))
+						return -ENOSPC;
+				}
+			}
+			if (seq_printf(seq, "\n"))
+				return -ENOSPC;
+			break;
+		case IPT_TIMER_IPV4:
+			if (seq_printf(seq, "%lu %u.%u.%u.%u\n",
+				       (t->timer.expires - jiffies) / HZ,
+				       NIPQUAD(t->type.ip)))
+				return -ENOSPC;
+			break;
+		case IPT_TIMER_MAX:
+			/* this should never happen */
+			break;
+	}
+	return 0;
+}
+  
+static struct seq_operations ipt_timer_seq_ops = {
+	.start = ipt_timer_seq_start,
+	.stop  = ipt_timer_seq_stop,
+	.next  = ipt_timer_seq_next,
+	.show  = ipt_timer_seq_show
+};
+
+/*
+ * pase_ipv4 - parse a IPv4 address from a NULL terminated string
+ * accepts "x.x.x.x" or "x.x.x.x\n" where x is base 10
+ * @buffer: pointer to NULL terminated string
+ * @ip: pointer to where the parsed IPv4 address will be stored
+ * @return: 0 failed to parse, 1 for successful parse
+ */
+static int
+parse_ipv4(const char *buffer, u_int32_t *ip)
+{
+	char *ep;
+	const char *p,
+		   *octet;
+	int num_dots;
+	u_int32_t result;
+
+	*ip = 0;
+	p = buffer;
+	for (num_dots = 0; num_dots < 4; num_dots++) {
+		octet = p;
+		if ((result = simple_strtoul(octet, &ep, 10)) > 255)
+			return 0;
+		if (p == ep)
+			return 0;
+		if (num_dots < 3) {
+			if (*ep != '.')
+				return 0;
+		} else {
+			if ((ep[0] != '\0') &&
+			    ((ep[0] != '\n') || (ep[1] != '\0')))
+				return 0;
+		}
+		p = ++ep;
+		*ip <<= 8;
+		*ip += (result & 0xff);
+	}
+	*ip = htonl(*ip);
+	return 1;
+}
+
+/*
+ * parse_mac - parse a MAC address from a NULL terminated string
+ * accepts "xx:xx..." or "xx:xx...\n" where xx is base 16
+ * @buffer: pointer to NULL terminated string
+ * @raw: pointer to area of MAX_ADDR_LEN for storing the MAC address
+ * @len: pointer to store the number of octets the MAC address contains
+ * @return: 0 failed to parse, 1 for successful parse
+ */
+static int
+parse_mac(const char *buffer, u_int8_t *raw, u_int32_t *len)
+{
+	char *ep;
+	const char *p,
+		   *octet;
+	int num_colons;
+	u_int32_t result;
+
+	p = buffer;
+	for (num_colons = 0; num_colons < MAX_ADDR_LEN; num_colons++) {
+		octet = p;
+		if ((result = simple_strtoul(octet, &ep, 16)) > 255)
+			return 0;
+		if (*ep != ':')
+			break;
+		p = ++ep;
+		raw[num_colons] = (u_int8_t) (result & 0xff);
+	}
+	if (num_colons == MAX_ADDR_LEN)
+		return 0;
+	if ((ep[0] != '\0') && ((ep[0] != '\n') || (ep[1] != '\0')))
+		return 0;
+	raw[num_colons] = (u_int8_t) (result & 0xff);
+	*len = ++num_colons;
+	return 1;
+}
+
+static ssize_t
+ipt_timer_write(struct file *file,
+	const char __user *buffer,
+	size_t count,
+	loff_t *ppos)
+{
+	unsigned char command_buffer[100];
+	struct seq_file *seq = file->private_data;
+	struct ipt_timer_iter_state *st = seq->private;
+	struct ipt_timer_t_info *ttinfo = st->pde->data;
+	struct ipt_timer timer;
+
+	if (count > (sizeof(command_buffer) - 1))
+		return -EINVAL;
+	if (copy_from_user(command_buffer, buffer, count))
+		return -EFAULT;
+	command_buffer[count] = '\0';
+	*ppos += count;
+	memset(&timer, 0, sizeof(timer));
+	switch (ttinfo->type) {
+		case IPT_TIMER_MAC:
+			if (parse_mac(command_buffer, timer.type.mac.raw,
+				      &timer.type.mac.len)) {
+				ipt_timer_update(ttinfo->me, &timer);
+			}
+			break;
+		case IPT_TIMER_IPV4:
+			if (parse_ipv4(command_buffer, &timer.type.ip))
+				ipt_timer_update(ttinfo->me, &timer);
+			break;
+		case IPT_TIMER_MAX:
+			/* this should never happen */
+			break;
+	}
+	return count;
+}
+
+static int
+ipt_timer_open(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq;
+	struct ipt_timer_iter_state *st;
+	int ret;
+
+	st = kmalloc(sizeof(struct ipt_timer_iter_state), GFP_KERNEL);
+
+	if (!st)
+		return -ENOMEM;
+	ret = seq_open(file, &ipt_timer_seq_ops);
+	if (ret)
+		goto out_free;
+
+	seq = file->private_data;
+	seq->private = st;
+	memset(st, 0, sizeof(struct ipt_timer_iter_state));
+	st->pde = PDE(inode);
+	return ret;
+out_free:
+	kfree(st);
+	return ret;
+}
+
+static struct file_operations ipt_timer_file_ops = {
+	.owner   = THIS_MODULE,
+	.llseek  = seq_lseek,
+	.read    = seq_read,
+	.write   = ipt_timer_write,
+	.open    = ipt_timer_open,
+	.release = seq_release_private
+};
+#endif /* CONFIG_PROC_FS */
+
+/*
+ * ipt_get_addr - get either IPv4 or MAC address from socket buffer
+ * @return: 0 failed, 1 success
+ */
+int
+ipt_get_addr(struct ipt_timer_t_info *ttinfo,
+	struct ipt_timer *ta,
+	const struct sk_buff *skb,
+	const struct net_device *nd)
+{
+	switch (ttinfo->type) {
+		case IPT_TIMER_MAC:
+			if (!nd) {
+				if (net_ratelimit())
+					printk(KERN_WARNING
+					       "ipt_TIMER: net_device is "
+					       "NULL\n");
+				return 0;
+			}
+			switch (nd->type) {
+				case ARPHRD_ETHER:
+					/* can we assume this?
+					 *if (ETH_ALEN > MAX_ADDR_LEN)
+					 *	return 0;
+					 */
+					memcpy(ta->type.mac.raw,
+					       ttinfo->dst ?
+						eth_hdr(skb)->h_dest :
+						eth_hdr(skb)->h_source,
+					       ETH_ALEN);
+					ta->type.mac.len = ETH_ALEN;
+					break;
+				default:
+					if (net_ratelimit())
+						printk(KERN_WARNING
+						       "ipt_TIMER:%s:%u "
+						       "hardware "
+						       "MAC type %u "
+						       "unsupported\n",
+						       __FILE__,
+						       __LINE__,
+						       nd->type);
+					return 0;
+					break;
+			}
+			break;
+		case IPT_TIMER_IPV4:
+			ta->type.ip = ttinfo->dst ? skb->nh.iph->daddr :
+						   skb->nh.iph->saddr;
+			break;
+		default:
+			return 0;
+			break;
+	}
+	return 1;
+}
+EXPORT_SYMBOL(ipt_get_addr);
+
+static u_int32_t
+ipt_timer_hash(struct ipt_timer_t_info *ttinfo, const struct ipt_timer *ta)
+{
+	unsigned int loop;
+	u_int32_t i1 = 0,
+		  ret = 0;
+
+	switch (ttinfo->type) {
+		case IPT_TIMER_MAC:
+			i1 = 0;
+			for (loop = 0; loop < ta->type.mac.len; loop++) {
+				i1 += ta->type.mac.raw[loop];
+				i1 <<= 1;
+			}
+			break;
+		case IPT_TIMER_IPV4:
+			i1 = ta->type.ip;
+			break;
+		case IPT_TIMER_MAX:
+			/* this should never happen */
+			break;
+	}
+	ret = jhash_1word(i1, ttinfo->htable_rand);
+	return (ret % ttinfo->htable_size);
+}
+
+static int
+ipt_timer_htable_init(struct ipt_timer_t_info *ttinfo)
+{
+	unsigned int loop,
+		     size;
+
+	if (ttinfo->htable_size) 
+		size = ttinfo->htable_size;
+	else {
+		/* size computation lifted from ip_conntrack_core.c */
+		size = (((num_physpages << PAGE_SHIFT) / 16384)
+			/ sizeof(struct list_head));
+		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
+			size = 8192;
+		if (size < 16)
+			size = 16;
+		ttinfo->htable_size = size;
+	}
+
+	ttinfo->htable = kmalloc(sizeof(struct list_head) * size, GFP_ATOMIC);
+
+	if (!ttinfo->htable) {
+		printk(KERN_ERR "ipt_TIMER: Unable to create hashtable\n");
+		return -ENOMEM;
+	}
+	
+	for (loop = 0; loop < size; loop++)
+		INIT_LIST_HEAD(&ttinfo->htable[loop]);
+
+	get_random_bytes(&ttinfo->htable_rand, 4);
+
+	return 0;
+}
+  
+static int
+ipt_timer_t_init(struct ipt_timer_t_info *ttinfo)
+{
+	struct list_head *list;
+	struct ipt_timer_t_info *existing;
+
+/*	ASSERT_WRITE_LOCK(&ipt_timer_lock); */
+
+	if (ttinfo->type >= IPT_TIMER_MAX)
+		return 0;
+
+	if (!ttinfo->timeout) {
+		printk(KERN_WARNING "ipt_TIMER: bad timeout value\n");
+		return 0;
+	}
+
+	if (strstr(ttinfo->name, "/")) {
+		printk(KERN_WARNING
+		       "ipt_TIMER: name must not include '/' characters\n");
+		return 0;
+	}
+
+	existing = kmalloc(sizeof(struct ipt_timer_t_info), GFP_ATOMIC);
+	if (!existing) {
+		printk(KERN_ERR "ipt_TIMER: memory allocation "
+		       "failure for ipt_timer_t_info\n");
+		return 0;
+	}
+	memcpy(existing, ttinfo, sizeof(struct ipt_timer_t_info));
+	if (ipt_timer_htable_init(existing)) {
+		kfree(existing);
+		return 0;
+	}
+#ifdef CONFIG_PROC_FS
+	existing->pde = create_proc_entry(existing->name, S_IRUSR | S_IWUSR,
+					  ipt_timer_procdir);
+	if (!existing->pde) {
+		kfree(existing->htable);
+		kfree(existing);
+		return 0;
+		
+	}
+	existing->pde->proc_fops = &ipt_timer_file_ops;
+	existing->pde->data = existing;
+#endif
+	existing->me = existing;
+	existing->use = 1;
+	memcpy(ttinfo, existing, sizeof(struct ipt_timer_t_info));
+	list = (struct list_head *) existing;
+	list_add(list, &ipt_timer_head);
+	return 1;
+}
+
+static struct ipt_timer *
+ipt_timer_init(struct ipt_timer_t_info *ttinfo, const struct ipt_timer *ta)
+{
+	u_int32_t hash;
+	struct list_head *list;
+	struct ipt_timer *t;
+
+	hash = ipt_timer_hash(ttinfo, ta);
+/*	ASSERT_WRITE_LOCK(&ipt_timer_lock); */
+	t = kmem_cache_alloc(ipt_timer_cachep, GFP_ATOMIC);
+	if (!t) {
+		printk(KERN_ERR "ipt_TIMER: memory allocation "
+		       "failure for ipt_timer\n");
+		return NULL;
+	}
+	t->type = ta->type;
+	list = (struct list_head *) t;
+	list_add(list, (struct list_head *) &ttinfo->htable[hash]);
+	return t;
+}
+
+struct ipt_timer *
+ipt_timer_find(struct ipt_timer_t_info *ttinfo, const struct ipt_timer *ta)
+{
+	u_int32_t hash;
+	struct list_head *list;
+	struct ipt_timer *t;
+
+	hash = ipt_timer_hash(ttinfo, ta);
+	list_for_each(list, &ttinfo->htable[hash]) {
+		t = (struct ipt_timer *) list;
+		switch (ttinfo->type) {
+			case IPT_TIMER_MAC:
+				if ((ta->type.mac.len == t->type.mac.len) &&
+				    (memcmp(ta->type.mac.raw,
+					    t->type.mac.raw,
+					    ta->type.mac.len) == 0))
+					return t;
+				break;
+			case IPT_TIMER_IPV4:
+				if (ta->type.ip == t->type.ip)
+					return t;
+				break;
+			case IPT_TIMER_MAX:
+				/* this should never happen */
+				break;
+		}
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(ipt_timer_find);
+
+struct ipt_timer_t_info *
+ipt_timer_t_find(const char *name)
+{
+	struct list_head *list;
+	struct ipt_timer_t_info *ttinfo;
+
+	list_for_each(list, &ipt_timer_head) {
+		ttinfo = (struct ipt_timer_t_info *) list;
+		if ((strnlen(ttinfo->name, TIMER_NAME_LEN) ==
+		    strnlen(name, TIMER_NAME_LEN)) &&
+		    (strncmp(ttinfo->name, name, TIMER_NAME_LEN) == 0))
+			return ttinfo;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(ipt_timer_t_find);
+
+static void
+ipt_timer_destroy(struct list_head *head)
+{
+	struct list_head *list;
+	struct ipt_timer *t;
+
+/*	ASSERT_WRITE_LOCK(&ipt_timer_lock); */
+	list = head->next;
+	while (list != head) {
+		t = (struct ipt_timer *) list;
+		list = list->next;
+		if (del_timer(&t->timer)) {
+			list_del((struct list_head *) t);
+			kmem_cache_free(ipt_timer_cachep, t);
+		}
+	}
+}
+
+static void
+ipt_timer_timeout(unsigned long ul_t)
+{
+	struct list_head *list;
+	struct ipt_timer *t = (struct ipt_timer *) ul_t;
+
+	list = (struct list_head *) t;
+	write_lock_bh(&ipt_timer_lock);
+	list_del(list);
+	write_unlock_bh(&ipt_timer_lock);
+	kmem_cache_free(ipt_timer_cachep, t);
+}
+
+static void
+ipt_timer_update(struct ipt_timer_t_info *ttinfo, const struct ipt_timer *ta)
+{
+	struct ipt_timer *t;
+
+	write_lock_bh(&ipt_timer_lock);
+	if ((t = ipt_timer_find(ttinfo, ta))) {
+		if (!mod_timer(&t->timer, jiffies + (ttinfo->timeout * HZ))) {
+			/* timer.expires has been reached before we got here */
+			del_timer(&t->timer);
+			/* timer.function should be waiting on the lock */
+			goto update_unlock;
+		}
+	} else {
+		if ((t = ipt_timer_init(ttinfo, ta))) {
+			init_timer(&t->timer);
+			t->timer.data = (unsigned long) t;
+			t->timer.function = ipt_timer_timeout;
+			t->timer.expires = jiffies + (ttinfo->timeout * HZ);
+			add_timer(&t->timer);
+		}
+	}
+update_unlock:
+	write_unlock_bh(&ipt_timer_lock);
+}
+
+static unsigned int
+target(struct sk_buff **pskb,
+	const struct net_device *in,
+	const struct net_device *out,
+	unsigned int hooknum,
+	const void *targinfo,
+	void *userdata)
+{
+	struct ipt_timer_t_info *ttinfo = (struct ipt_timer_t_info *) targinfo;
+	struct ipt_timer timer;
+
+	if (in || out) {
+		if (ipt_get_addr(ttinfo, &timer, *pskb, in ? in : out))
+			ipt_timer_update(ttinfo->me, &timer);
+	}
+
+	return IPT_CONTINUE;
+}
+
+static int
+checkentry(const char *tablename,
+	const struct ipt_entry *e,
+	void *targinfo,
+	unsigned int targinfosize,
+	unsigned int hook_mask)
+{
+	int ret = 0;
+	struct ipt_timer_t_info *ttinfo = (struct ipt_timer_t_info *) targinfo,
+				*existing;
+
+	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_timer_t_info)))
+		return ret;
+	ttinfo->name[TIMER_NAME_LEN - 1] = '\0';
+	write_lock_bh(&ipt_timer_lock);
+	if ((existing = ipt_timer_t_find(ttinfo->name)) == NULL) {
+		ret = ipt_timer_t_init(ttinfo);
+	} else {
+		existing->use++;
+		memcpy(ttinfo, existing, sizeof(struct ipt_timer_t_info));
+		ret = 1;
+	}
+	write_unlock_bh(&ipt_timer_lock);
+	return ret;
+}
+
+static void
+destroy(void *targinfo,
+	unsigned int targinfosize)
+{
+	unsigned int i;
+	struct list_head *list;
+	struct ipt_timer_t_info *ttinfo = (struct ipt_timer_t_info *) targinfo,
+				*existing;
+
+	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_timer_t_info)))
+		return;
+
+	write_lock_bh(&ipt_timer_lock);
+	existing = ttinfo->me;
+	existing->use--;
+	if (!existing->use) {
+#ifdef CONFIG_PROC_FS
+		remove_proc_entry(existing->name, ipt_timer_procdir);
+#endif
+		for (i = 0; i < existing->htable_size; i++)
+			ipt_timer_destroy(&existing->htable[i]);
+		kfree(existing->htable);
+		list = (struct list_head *) existing;
+		list_del(list);
+		kfree(existing);
+	}
+	write_unlock_bh(&ipt_timer_lock);
+}
+
+static struct ipt_target ipt_timer_t_reg = {
+	.name 		= "TIMER",
+	.checkentry	= &checkentry,
+	.destroy	= &destroy,
+	.target 	= &target,
+	.me		= THIS_MODULE,
+};
+
+static int
+init_or_fini(int fini)
+{
+	int ret = 0;
+
+	if (fini)
+		goto cleanup;
+
+	ipt_timer_cachep = kmem_cache_create("ipt_TIMER",
+					       sizeof(struct ipt_timer), 0,
+					       0, NULL, NULL);
+
+	if (!ipt_timer_cachep) {
+		printk(KERN_ERR "Unable to create ipt_TIMER slab cache\n");
+		ret = -ENOMEM;
+		goto cleanup_nothing;
+	}
+
+#ifdef CONFIG_PROC_FS
+	ipt_timer_procdir = proc_mkdir("ipt_TIMER", proc_net);
+	if (!ipt_timer_procdir) {
+		printk(KERN_ERR "Unable to create proc dir entry\n");
+		ret = -ENOMEM;
+		goto cleanup_free_slab;
+	}
+#endif
+
+	INIT_LIST_HEAD(&ipt_timer_head);
+	ret = ipt_register_target(&ipt_timer_t_reg);
+	if (ret) {
+		ret = -ENOMEM;
+		goto cleanup_proc;
+	}
+
+	return 0;
+
+cleanup:
+	ipt_unregister_target(&ipt_timer_t_reg);
+cleanup_proc:
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("ipt_TIMER", proc_net);
+#endif
+cleanup_free_slab:
+	kmem_cache_destroy(ipt_timer_cachep);
+cleanup_nothing:
+	return ret;
+}
+
+static int __init
+init(void)
+{
+	return init_or_fini(0);
+}
+
+static void __exit
+fini(void)
+{
+	init_or_fini(1);
+}
+
+module_init(init);
+module_exit(fini);
diff -Nru a/net/ipv4/netfilter/ipt_timer.c b/net/ipv4/netfilter/ipt_timer.c
--- a/net/ipv4/netfilter/ipt_timer.c	1969-12-31 18:00:00.000000000 -0600
+++ b/net/ipv4/netfilter/ipt_timer.c	2005-06-28 15:10:42.000000000 -0500
@@ -0,0 +1,89 @@
+/* Kernel module that creates a match for the TIMER target */
+
+/* (C) 2004 Josh Samuelson <josamue1@wsc.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <linux/netfilter_ipv4/ipt_TIMER.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Josh Samuelson <josamue1@wsc.edu>");
+MODULE_DESCRIPTION("match module for MAC/IPv4 address timers target");
+
+static int
+match(const struct sk_buff *skb,
+	const struct net_device *in,
+	const struct net_device *out,
+	const void *matchinfo,
+	int offset,
+	int *hotdrop)
+{
+	int ret = 0;
+	const struct ipt_timer_m_info *tminfo = matchinfo;
+	struct ipt_timer timer;
+	struct ipt_timer_t_info *ttinfo;
+
+	if (in || out) {
+		READ_LOCK(&ipt_timer_lock);
+		if ((ttinfo = ipt_timer_t_find(tminfo->name)) &&
+		    ipt_get_addr(ttinfo, &timer, skb, in ? in : out) &&
+		    ipt_timer_find(ttinfo, &timer)) {
+				ret = 1;
+		}
+		READ_UNLOCK(&ipt_timer_lock);
+	}
+	return tminfo->invert ^ ret;
+}
+
+static int
+checkentry(const char *tablename,
+	const struct ipt_ip *ip,
+	void *matchinfo,
+	unsigned int matchinfosize,
+	unsigned int hook_mask)
+{
+	struct ipt_timer_t_info *ttinfo;
+	struct ipt_timer_m_info *tminfo = matchinfo;
+
+	if (matchinfosize != IPT_ALIGN(sizeof(struct ipt_timer_m_info)))
+		return 0;
+
+	tminfo->name[TIMER_NAME_LEN - 1] = '\0';
+	READ_LOCK(&ipt_timer_lock);
+	ttinfo = ipt_timer_t_find(tminfo->name);
+	READ_UNLOCK(&ipt_timer_lock);
+	if (!ttinfo)
+		printk(KERN_WARNING "ipt_timer: \"%s\" not found in the TIMER "
+				    "tables\n", tminfo->name);
+	return 1;
+}
+
+static struct ipt_match ipt_tm_reg = {
+	.name		= "timer",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+
+};
+
+static int __init
+init(void)
+{
+	return ipt_register_match(&ipt_tm_reg);
+}
+
+static void __exit
+fini(void)
+{
+	ipt_unregister_match(&ipt_tm_reg);
+}
+
+module_init(init);
+module_exit(fini);

--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-timer-20050628.diff"

diff -Nru a/extensions/Makefile b/extensions/Makefile
--- a/extensions/Makefile	2004-11-18 16:52:12.000000000 -0600
+++ b/extensions/Makefile	2005-06-28 14:04:21.000000000 -0500
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc sctp standard state tcp tcpmss timer tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TIMER TOS TRACE TTL ULOG
 PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner physdev standard tcp udp HL LOG MARK TRACE
 
 # Optionals
diff -Nru a/extensions/libipt_TIMER.c b/extensions/libipt_TIMER.c
--- a/extensions/libipt_TIMER.c	1969-12-31 18:00:00.000000000 -0600
+++ b/extensions/libipt_TIMER.c	2005-06-28 15:41:58.000000000 -0500
@@ -0,0 +1,218 @@
+/*
+ * Shared library iptables add-on providing a target for source/destination,
+ * MAC/IPv4 addresses with associated timers
+ */
+
+/* (C) 2004 2005 Josh Samuelson <josamue1@wsc.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_TIMER.h>
+
+enum timer_flags {
+		   TIMER_NAME = 1,
+		   TIMER_TIMEOUT = 2,
+		   TIMER_TYPE = 4,
+		   TIMER_HTABLE_SIZE = 8,
+		   TIMER_DST = 16
+		 };
+
+#define MAX_SIZE(c) ~(1 << ((sizeof(c) * 8) - 1))
+
+/* These must match up with the ipt_timer_t constants in ipt_TIMER.h */
+const char *timer_types[] = { "mac", "ip", NULL };
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf("TIMER v%s options:\n"
+	       " Each following option must be specified\n"
+	       " --TIMER-name name\n"
+	       " --TIMER-timeout n\n"
+	       " Only one of the following options must be specfied\n"
+	       " --TIMER-mac\n"
+	       " --TIMER-ipv4\n"
+	       " Optional flags\n"
+	       " --TIMER-htable-size n\n"
+	       " --TIMER-dst\n"
+	       "\n", IPTABLES_VERSION);
+}
+
+/* Initialize the target. */
+static void
+init(struct ipt_entry_target *t, unsigned int *nfcache)
+{
+	struct ipt_timer_t_info *ttinfo = (struct ipt_timer_t_info *) t;
+
+	/* match source addresses by default */
+	ttinfo->dst = 0;
+}
+
+/* Function which parses command options; returns true if it ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+	const struct ipt_entry *entry,
+	struct ipt_entry_target **target)
+{
+	int ret;
+	unsigned int count;
+	struct ipt_timer_t_info *ttinfo = (struct ipt_timer_t_info *)
+					   (*target)->data;
+
+
+	if (invert || check_inverse(optarg, &invert, &optind, 0)) {
+		exit_error(PARAMETER_PROBLEM, "TIMER: has no inverted options");
+	}
+	switch (c) {
+		case 0:
+			if (*flags & TIMER_NAME) {
+				exit_error(PARAMETER_PROBLEM,
+					   "TIMER: only one --TIMER-name "
+					   "allowed");
+			}
+			strncpy(ttinfo->name, optarg, TIMER_NAME_LEN - 1);
+			ttinfo->name[TIMER_NAME_LEN - 1] = '\0';
+			*flags |= TIMER_NAME;
+			break;
+		case 1:
+			if (*flags & TIMER_TIMEOUT) {
+				exit_error(PARAMETER_PROBLEM,
+					   "TIMER: only one --TIMER-timeout "
+					   "allowed");
+			}
+			ret = string_to_number(optarg, 1, MAX_SIZE(count),
+					       &count);
+			if (ret == -1) {
+				exit_error(PARAMETER_PROBLEM,
+					   "value out of range");
+			}
+			*flags |= TIMER_TIMEOUT;
+			ttinfo->timeout = count;
+			break;
+		case 2:
+		case 3:
+			if (*flags & TIMER_TYPE) {
+				exit_error(PARAMETER_PROBLEM,
+					   "TIMER: only one type allowed");
+			}
+			*flags |= TIMER_TYPE;
+			if (c == 2)
+				ttinfo->type = IPT_TIMER_MAC;
+			if (c == 3)
+				ttinfo->type = IPT_TIMER_IPV4;
+			break;
+		case 4:
+			if (*flags & TIMER_HTABLE_SIZE) {
+				exit_error(PARAMETER_PROBLEM,
+					   "TIMER: only one "
+					   "--TIMER-htable-size allowed");
+			}
+			ret = string_to_number(optarg, 1, MAX_SIZE(count),
+					       &count);
+			if (ret == -1) {
+				exit_error(PARAMETER_PROBLEM,
+					   "value out of range");
+			}
+			*flags |= TIMER_HTABLE_SIZE;
+			ttinfo->htable_size = count;
+			break;
+		case 5:
+			if (*flags & TIMER_DST) {
+				exit_error(PARAMETER_PROBLEM,
+					   "TIMER: only one --TIMER-dst "
+					   "allowed");
+			}
+			*flags |= TIMER_DST;
+			ttinfo->dst = 1;
+			break;
+		default:
+			return 0;
+	}
+
+	return 1;
+}
+
+/* Final check */
+static void
+final_check(unsigned int flags)
+{
+	if ((flags & ~(TIMER_HTABLE_SIZE | TIMER_DST)) !=
+	    (TIMER_NAME | TIMER_TIMEOUT | TIMER_TYPE))
+		exit_error(PARAMETER_PROBLEM, "You must specify "
+			   "`--TIMER-name' and `--TIMER-timeout' with either\n"
+			   "`--TIMER-mac' or `--TIMER-ipv4'");
+}
+
+static void
+timer_print(struct ipt_timer_t_info *ttinfo)
+{
+	printf("--TIMER-name \"%s\" --TIMER-timeout %u "
+	       "--TIMER-%s --TIMER-htable-size %u %s",
+	       ttinfo->name,
+	       ttinfo->timeout,
+	       timer_types[ttinfo->type],
+	       ttinfo->htable_size,
+	       (ttinfo->dst ? "--TIMER-dst " : ""));
+}
+
+/* Prints out the targetinfo. */
+static void
+print(const struct ipt_ip *ip, const struct ipt_entry_target *target,
+	int numeric)
+{
+	struct ipt_timer_t_info *ttinfo = (struct ipt_timer_t_info *)
+					   target->data;
+
+	printf("TIMER ");
+	timer_print(ttinfo);
+}
+
+/* Saves the targetinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+	struct ipt_timer_t_info *ttinfo = (struct ipt_timer_t_info *)
+					   target->data;
+
+	timer_print(ttinfo);
+}
+
+static struct option opts[] = {
+	{ .name = "TIMER-name", .has_arg = 1, .flag =0, .val = 0 },
+	{ .name = "TIMER-timeout", .has_arg = 1, .flag =0, .val = 1 },
+	{ .name = "TIMER-mac", .has_arg = 0, .flag =0, .val = 2 },
+	{ .name = "TIMER-ipv4", .has_arg = 0, .flag =0, .val = 3 },
+	{ .name = "TIMER-htable-size", .has_arg = 1, .flag =0, .val = 4 },
+	{ .name = "TIMER-dst", .has_arg = 0, .flag =0, .val = 5 },
+	{0}
+};
+
+static struct iptables_target tt = {
+	.next		= NULL,
+	.name		= "TIMER",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_timer_t_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_timer_t_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void
+_init(void)
+{
+	register_target(&tt);
+}
diff -Nru a/extensions/libipt_TIMER.man b/extensions/libipt_TIMER.man
--- a/extensions/libipt_TIMER.man	1969-12-31 18:00:00.000000000 -0600
+++ b/extensions/libipt_TIMER.man	2005-06-28 14:04:21.000000000 -0500
@@ -0,0 +1,39 @@
+This is used to allow you to add a packet's source or
+destination, MAC or IPv4 address to a named table which
+has a corresponding timeout value associated with it.
+New packets matching the target will refresh the timeout
+value for an entry in the named table.  The timeout value
+can also be refreshed by echoing the MAC or IPv4 address to
+/proc/net/ipt_TIMER/name.  The live timeout values can also
+be read from the same proc file.
+.TP
+.BI "REQUIRED OPTIONS"
+.RS
+.TP .4i
+.BI "--TIMER-name " "name"
+The name of a TIMER target can be up to 127 characters.
+.TP
+.BI "--TIMER-timeout " "timeout"
+The named table will have this value as its timeout.
+.RE
+.TP
+.BI "REQUIRED TYPE, ONLY ONE SHOULD BE SPECIFIED"
+.RS
+.TP .4i
+.BI "--TIMER-mac"
+The named TIMER target table will keep track of MAC addresses.
+.TP
+.BI "--TIMER-ipv4"
+The named TIMER target table will keep track of IPv4 addresses.
+.RE
+.TP
+.BI "OPTIONAL"
+.RS
+.TP .4i
+.BI "--TIMER-htable-size" "n"
+The named TIMER target will have "n" hash buckets allocated to it.
+.TP
+.BI "--TIMER-dst"
+Optional flag to add the packet destination address in the
+TIMER target table.  The default is to add the source address.
+.RE
diff -Nru a/extensions/libipt_timer.c b/extensions/libipt_timer.c
--- a/extensions/libipt_timer.c	1969-12-31 18:00:00.000000000 -0600
+++ b/extensions/libipt_timer.c	2005-06-28 15:42:27.000000000 -0500
@@ -0,0 +1,139 @@
+/*
+ * Shared library iptables add-on providing a match for source/destination,
+ * MAC/IPv4 addresses within the TIMER target tables
+ */
+
+/* (C) 2004 2005 Josh Samuelson <josamue1@wsc.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_TIMER.h>
+
+enum timer_flags { TIMER_NAME = 1 };
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf("timer v%s options:\n"
+	       " The following option must be specified\n"
+	       " --timer-name [!] name\n"
+	       "\n", IPTABLES_VERSION);
+}
+
+/* Function which parses command options; returns true if it ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+	const struct ipt_entry *entry,
+	unsigned int *nfcache,
+	struct ipt_entry_match **match)
+{
+	struct ipt_timer_m_info *tminfo = (struct ipt_timer_m_info *)
+					   (*match)->data;
+
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "cannot invert %s, only its argument",
+			   argv[optind - 2]);
+	check_inverse(optarg, &invert, &optind, 0);
+
+	switch (c) {
+		case 0:
+			if (*flags & TIMER_NAME) {
+				exit_error(PARAMETER_PROBLEM,
+					   "timer: only one --timer-name "
+					   "allowed");
+			}
+			if (invert)
+				strncpy(tminfo->name,
+					argv[optind - 1], TIMER_NAME_LEN - 1);
+			else
+				strncpy(tminfo->name,
+					optarg, TIMER_NAME_LEN - 1);
+			tminfo->name[TIMER_NAME_LEN - 1] = '\0';
+			*flags |= TIMER_NAME;
+			tminfo->invert = invert;
+			break;
+		default:
+			return 0;
+	}
+
+	return 1;
+}
+
+/* Final check */
+static void
+final_check(unsigned int flags)
+{
+	if (flags != TIMER_NAME)
+		exit_error(PARAMETER_PROBLEM,
+			   "You must specify `--timer-name'");
+}
+
+static void
+timer_print(struct ipt_timer_m_info *tminfo)
+{
+	char *invert;
+
+	if (tminfo->invert)
+		invert = "! ";
+	else
+		invert = "";
+
+	printf("--timer-name %s\"%s\" ", invert, tminfo->name);
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ipt_ip *ip, const struct ipt_entry_match *match,
+	int numeric)
+{
+	struct ipt_timer_m_info *tminfo = (struct ipt_timer_m_info *)
+					   match->data;
+
+	printf("timer ");
+	timer_print(tminfo);
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	struct ipt_timer_m_info *tminfo = (struct ipt_timer_m_info *)
+					   match->data;
+
+	timer_print(tminfo);
+}
+
+static struct option opts[] = {
+	{ .name = "timer-name", .has_arg = 1, .flag =0, .val = 0 },
+	{0}
+};
+
+static struct iptables_match tm = {
+	.next		= NULL,
+	.name		= "timer",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_timer_m_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_timer_m_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void
+_init(void)
+{
+	register_match(&tm);
+}
diff -Nru a/extensions/libipt_timer.man b/extensions/libipt_timer.man
--- a/extensions/libipt_timer.man	1969-12-31 18:00:00.000000000 -0600
+++ b/extensions/libipt_timer.man	2005-06-28 14:04:21.000000000 -0500
@@ -0,0 +1,9 @@
+This matches a packet if its address exists in the named TIMER
+target table.  The TIMER table properties will determine whether
+the source or destination, MAC or IPv4 address of the packet is
+checked.
+.TP
+.BI "--timer-name " "[!] name"
+Where name is a TIMER target table name.  If "!" is specified,
+the rule will match if the packet address is not found in the
+named TIMER table.

--GID0FwUMdk1T2AWN--
