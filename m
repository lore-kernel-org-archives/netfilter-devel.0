From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/07]: ip{,6}_queue: convert to seq_file interface
Date: Fri,  2 Nov 2007 12:23:11 +0100 (MET)
Message-ID: <20071102112001.22803.93793.sendpatchset@localhost.localdomain>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45731 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbXKBLXN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Nov 2007 07:23:13 -0400
In-Reply-To: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ip{,6}_queue: convert to seq_file interface

I plan to kill ->get_info which means killing proc_net_create().

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9cfc1fadc1b0b5963fa8bef95f3653b8b2fb72b7
tree 9e4978bb689872525d1f4b656367ea65687a25a1
parent 54866f032307063776b4eff7eadb131d47f9f9b4
author Alexey Dobriyan <adobriyan@sw.ru> Fri, 02 Nov 2007 11:58:56 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 02 Nov 2007 11:58:56 +0100

 net/ipv4/netfilter/ip_queue.c  |   37 ++++++++++++++++++++-----------------
 net/ipv6/netfilter/ip6_queue.c |   37 ++++++++++++++++++++-----------------
 2 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 10a2ce0..14d64a3 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/security.h>
 #include <linux/mutex.h>
 #include <net/net_namespace.h>
@@ -607,15 +608,11 @@ static ctl_table ipq_root_table[] = {
 	{ .ctl_name = 0 }
 };
 
-#ifdef CONFIG_PROC_FS
-static int
-ipq_get_info(char *buffer, char **start, off_t offset, int length)
+static int ip_queue_show(struct seq_file *m, void *v)
 {
-	int len;
-
 	read_lock_bh(&queue_lock);
 
-	len = sprintf(buffer,
+	seq_printf(m,
 		      "Peer PID          : %d\n"
 		      "Copy mode         : %hu\n"
 		      "Copy range        : %u\n"
@@ -632,16 +629,21 @@ ipq_get_info(char *buffer, char **start, off_t offset, int length)
 		      queue_user_dropped);
 
 	read_unlock_bh(&queue_lock);
+	return 0;
+}
 
-	*start = buffer + offset;
-	len -= offset;
-	if (len > length)
-		len = length;
-	else if (len < 0)
-		len = 0;
-	return len;
+static int ip_queue_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ip_queue_show, NULL);
 }
-#endif /* CONFIG_PROC_FS */
+
+static const struct file_operations ip_queue_proc_fops = {
+	.open		= ip_queue_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.owner		= THIS_MODULE,
+};
 
 static struct nf_queue_handler nfqh = {
 	.name	= "ip_queue",
@@ -661,10 +663,11 @@ static int __init ip_queue_init(void)
 		goto cleanup_netlink_notifier;
 	}
 
-	proc = proc_net_create(&init_net, IPQ_PROC_FS_NAME, 0, ipq_get_info);
-	if (proc)
+	proc = create_proc_entry(IPQ_PROC_FS_NAME, 0, init_net.proc_net);
+	if (proc) {
 		proc->owner = THIS_MODULE;
-	else {
+		proc->proc_fops = &ip_queue_proc_fops;
+	} else {
 		printk(KERN_ERR "ip_queue: failed to create proc entry\n");
 		goto cleanup_ipqnl;
 	}
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 6413a30..e273605 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/mutex.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
@@ -596,15 +597,11 @@ static ctl_table ipq_root_table[] = {
 	{ .ctl_name = 0 }
 };
 
-#ifdef CONFIG_PROC_FS
-static int
-ipq_get_info(char *buffer, char **start, off_t offset, int length)
+static int ip6_queue_show(struct seq_file *m, void *v)
 {
-	int len;
-
 	read_lock_bh(&queue_lock);
 
-	len = sprintf(buffer,
+	seq_printf(m,
 		      "Peer PID          : %d\n"
 		      "Copy mode         : %hu\n"
 		      "Copy range        : %u\n"
@@ -621,16 +618,21 @@ ipq_get_info(char *buffer, char **start, off_t offset, int length)
 		      queue_user_dropped);
 
 	read_unlock_bh(&queue_lock);
+	return 0;
+}
 
-	*start = buffer + offset;
-	len -= offset;
-	if (len > length)
-		len = length;
-	else if (len < 0)
-		len = 0;
-	return len;
+static int ip6_queue_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ip6_queue_show, NULL);
 }
-#endif /* CONFIG_PROC_FS */
+
+static const struct file_operations ip6_queue_proc_fops = {
+	.open		= ip6_queue_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.owner		= THIS_MODULE,
+};
 
 static struct nf_queue_handler nfqh = {
 	.name	= "ip6_queue",
@@ -650,10 +652,11 @@ static int __init ip6_queue_init(void)
 		goto cleanup_netlink_notifier;
 	}
 
-	proc = proc_net_create(&init_net, IPQ_PROC_FS_NAME, 0, ipq_get_info);
-	if (proc)
+	proc = create_proc_entry(IPQ_PROC_FS_NAME, 0, init_net.proc_net);
+	if (proc) {
 		proc->owner = THIS_MODULE;
-	else {
+		proc->proc_fops = &ip6_queue_proc_fops;
+	} else {
 		printk(KERN_ERR "ip6_queue: failed to create proc entry\n");
 		goto cleanup_ipqnl;
 	}
