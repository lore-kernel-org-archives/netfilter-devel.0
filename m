From: Gregor Maier <gregor@net.in.tum.de>
Subject: [PATCH] nf_log: Add stackable loggers support
Date: Tue, 28 Feb 2006 20:41:21 +0100
Message-ID: <20060228194121.GB9136@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hello, 

Here's a patch that will add support for stackable loggers to nf_log.c

Sorry for not RTFM the FAQ on how to submit patches in the first place. 

cu
Gregor

=================================================================
[PATCH] nf_log: Add support for stackable loggers

More than one logger can be registered per PF. Registered loggers are
stored in a list. nf_log_unregister_pf needs the logger to unregister
as second parameter. nf_log_register still return -EEXIST if the logger
is already registered.
To be able to register a logger to more than one PF a container struct
nf_logging_node is used as nodes in the list.
The /proc interface will display all registered logger seperated by
spaces

Signed-off-by: Gregor Maier <gregor@net.in.tum.de>


diff -aur linux-2.6.16-rc4.orig/include/linux/netfilter.h linux-2.6.16-rc4.yyy/include/linux/netfilter.h
--- linux-2.6.16-rc4.orig/include/linux/netfilter.h	2006-02-17 23:23:45.000000000 +0100
+++ linux-2.6.16-rc4.yyy/include/linux/netfilter.h	2006-02-26 18:28:18.000000000 +0100
@@ -157,7 +157,7 @@
 
 /* Function to register/unregister log function. */
 int nf_log_register(int pf, struct nf_logger *logger);
-int nf_log_unregister_pf(int pf);
+int nf_log_unregister_pf(int pf, struct nf_logger *logger);
 void nf_log_unregister_logger(struct nf_logger *logger);
 
 /* Calls the registered backend logging function */
diff -aur linux-2.6.16-rc4.orig/net/netfilter/nf_log.c linux-2.6.16-rc4.yyy/net/netfilter/nf_log.c
--- linux-2.6.16-rc4.orig/net/netfilter/nf_log.c	2006-02-17 23:23:45.000000000 +0100
+++ linux-2.6.16-rc4.yyy/net/netfilter/nf_log.c	2006-02-26 21:47:34.000000000 +0100
@@ -6,6 +6,8 @@
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
 #include <linux/seq_file.h>
+#include <linux/list.h>
+#include <linux/slab.h> /* for kmalloc */
 #include <net/protocol.h>
 
 #include "nf_internals.h"
@@ -15,14 +17,19 @@
 
 #define NF_LOG_PREFIXLEN		128
 
-static struct nf_logger *nf_logging[NPROTO]; /* = NULL */
+struct nf_logging_node {
+	struct list_head list;
+	struct nf_logger *logger;
+};
+
+static struct list_head nf_logging[NPROTO]; /* = NULL */
 static DEFINE_SPINLOCK(nf_log_lock);
 
-/* return EBUSY if somebody else is registered, EEXIST if the same logger
- * is registred, 0 on success. */
+/* EEXIST if the same logger is registred, 0 on success. */
 int nf_log_register(int pf, struct nf_logger *logger)
 {
-	int ret = -EBUSY;
+	struct nf_logging_node *node;
+	int ret = 0;
 
 	if (pf >= NPROTO)
 		return -EINVAL;
@@ -30,28 +37,50 @@
 	/* Any setup of logging members must be done before
 	 * substituting pointer. */
 	spin_lock(&nf_log_lock);
-	if (!nf_logging[pf]) {
-		rcu_assign_pointer(nf_logging[pf], logger);
-		ret = 0;
-	} else if (nf_logging[pf] == logger)
-		ret = -EEXIST;
-
+	/* Check if we are already registered */
+	list_for_each_entry(node, &nf_logging[pf], list) {
+		if (node->logger == logger) {
+			ret = -EEXIST;
+			goto reg_out;
+		}
+	}
+	node = kmalloc(sizeof(struct nf_logging_node), GFP_KERNEL);
+	if (!node) {
+		ret = -ENOMEM;
+		goto reg_out;
+	}
+	node->logger = logger;
+	list_add_rcu(&node->list, &nf_logging[pf]);
+	
+reg_out:
 	spin_unlock(&nf_log_lock);
+	synchronize_net();
 	return ret;
 }		
 EXPORT_SYMBOL(nf_log_register);
 
-int nf_log_unregister_pf(int pf)
+int nf_log_unregister_pf(int pf, struct nf_logger *logger)
 {
+	struct nf_logging_node *node; 
+	int do_kfree = 0;
+	
 	if (pf >= NPROTO)
 		return -EINVAL;
 
 	spin_lock(&nf_log_lock);
-	nf_logging[pf] = NULL;
+	list_for_each_entry(node, &nf_logging[pf], list) {
+		if (node->logger == logger) {
+			list_del_rcu(&node->list);
+			do_kfree=1;
+			break;
+		}
+	}
 	spin_unlock(&nf_log_lock);
 
 	/* Give time to concurrent readers. */
 	synchronize_net();
+	if (do_kfree)
+		kfree(node);
 
 	return 0;
 }
@@ -61,14 +90,10 @@
 {
 	int i;
 
-	spin_lock(&nf_log_lock);
 	for (i = 0; i < NPROTO; i++) {
-		if (nf_logging[i] == logger)
-			nf_logging[i] = NULL;
+		nf_log_unregister_pf(i, logger);
 	}
-	spin_unlock(&nf_log_lock);
 
-	synchronize_net();
 }
 EXPORT_SYMBOL(nf_log_unregister_logger);
 
@@ -82,20 +107,25 @@
 {
 	va_list args;
 	char prefix[NF_LOG_PREFIXLEN];
-	struct nf_logger *logger;
+	struct nf_logging_node *node;
+	
+	if (pf >= NPROTO)
+		return;
 	
+	va_start(args, fmt);
+	vsnprintf(prefix, sizeof(prefix), fmt, args);
+	va_end(args);
+
 	rcu_read_lock();
-	logger = rcu_dereference(nf_logging[pf]);
-	if (logger) {
-		va_start(args, fmt);
-		vsnprintf(prefix, sizeof(prefix), fmt, args);
-		va_end(args);
-		/* We must read logging before nf_logfn[pf] */
-		logger->logfn(pf, hooknum, skb, in, out, loginfo, prefix);
-	} else if (net_ratelimit()) {
+	if (list_empty(&nf_logging[pf]) && net_ratelimit()) {
 		printk(KERN_WARNING "nf_log_packet: can\'t log since "
 		       "no backend logging module loaded in! Please either "
 		       "load one, or disable logging explicitly\n");
+		rcu_read_unlock();
+		return;
+	}
+	list_for_each_entry_rcu(node, &nf_logging[pf], list) {
+		node->logger->logfn(pf, hooknum, skb, in, out, loginfo, prefix);
 	}
 	rcu_read_unlock();
 }
@@ -130,14 +160,20 @@
 static int seq_show(struct seq_file *s, void *v)
 {
 	loff_t *pos = v;
-	const struct nf_logger *logger;
+	struct nf_logging_node *node;
 
-	logger = rcu_dereference(nf_logging[*pos]);
 
-	if (!logger)
+	if (list_empty(&nf_logging[*pos])) 
 		return seq_printf(s, "%2lld NONE\n", *pos);
+	if  (seq_printf(s, "%2lld", *pos) < 0)
+		return -1;
+
+	list_for_each_entry_rcu(node, &nf_logging[*pos], list) {
+		if (seq_printf(s, " %s", node->logger->name) < 0)
+			return -1; 
+	}
 	
-	return seq_printf(s, "%2lld %s\n", *pos, logger->name);
+	return seq_putc(s, '\n');
 }
 
 static struct seq_operations nflog_seq_ops = {
@@ -165,6 +201,8 @@
 
 int __init netfilter_log_init(void)
 {
+	int i;
+
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *pde;
 
@@ -174,5 +212,9 @@
 
 	pde->proc_fops = &nflog_file_ops;
 #endif
+
+	for (i = 0; i < NPROTO; i++) {
+		INIT_LIST_HEAD(&nf_logging[i]);
+	}
 	return 0;
 }
diff -aur linux-2.6.16-rc4.orig/net/netfilter/nfnetlink_log.c linux-2.6.16-rc4.yyy/net/netfilter/nfnetlink_log.c
--- linux-2.6.16-rc4.orig/net/netfilter/nfnetlink_log.c	2006-02-17 23:23:45.000000000 +0100
+++ linux-2.6.16-rc4.yyy/net/netfilter/nfnetlink_log.c	2006-02-26 19:19:37.000000000 +0100
@@ -808,7 +808,7 @@
 			UDEBUG("unregistering log handler for pf=%u\n", pf);
 			/* This is a bug and a feature.  We cannot unregister
 			 * other handlers, like nfnetlink_inst can */
-			nf_log_unregister_pf(pf);
+			nf_log_unregister_pf(pf, &nfulnl_logger);
 			break;
 		default:
 			ret = -EINVAL;
