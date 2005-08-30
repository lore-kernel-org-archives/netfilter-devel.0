From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 3/3] CLUSTERIP: use a bitmap to store node responsibility
	data
Date: Tue, 30 Aug 2005 14:15:39 +0200
Message-ID: <20050830121550.543376000@nienna.balabit>
References: <20050830121535.985929000@nienna.balabit>
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename=03-responsibility_bitmap.patch
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

CLUSTERIP: use a bitmap to store node responsibility data

Instead of maintaining an array containing a list of nodes this instance
is responsible for let's use a simple bitmap. This provides the
following features:

  * clusterip_responsible() and the add_node()/delete_node() operations
    become very simple and don't need locking
  * the config structure is much smaller

In spite of the completely different internal data representation the
user-space interface remains almost unchanged; the only difference is
that the proc file does not list nodes in the order they were added.
(The target info structure remains the same.)


Signed-off-by: KOVACS Krisztian <hidden@balabit.hu>


Index: linux-2.6.13/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- linux-2.6.13.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-08-30 14:12:43.365348289 +0200
+++ linux-2.6.13/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-08-30 14:12:46.077281161 +0200
@@ -13,6 +13,7 @@
 #include <linux/config.h>
 #include <linux/proc_fs.h>
 #include <linux/jhash.h>
+#include <linux/bitops.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
@@ -30,7 +31,7 @@
 #include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 
-#define CLUSTERIP_VERSION "0.7"
+#define CLUSTERIP_VERSION "0.8"
 
 #define DEBUG_CLUSTERIP
 
@@ -55,8 +56,7 @@
 	u_int8_t clustermac[ETH_ALEN];		/* the MAC address */
 	struct net_device *dev;			/* device */
 	u_int16_t num_total_nodes;		/* total number of nodes */
-	u_int16_t num_local_nodes;		/* number of local nodes */
-	u_int16_t local_nodes[CLUSTERIP_MAX_NODES];	/* node number array */
+	unsigned long local_nodes;		/* node number array */
 
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *pde;		/* proc dir entry */
@@ -67,8 +67,7 @@
 
 static LIST_HEAD(clusterip_configs);
 
-/* clusterip_lock protects the clusterip_configs list _AND_ the configurable
- * data within all structurses (num_local_nodes, local_nodes[]) */
+/* clusterip_lock protects the clusterip_configs list */
 static DEFINE_RWLOCK(clusterip_lock);
 
 #ifdef CONFIG_PROC_FS
@@ -151,6 +150,17 @@
 	return c;
 }
 
+static void
+clusterip_config_init_nodelist(struct clusterip_config *c,
+			       const struct ipt_clusterip_tgt_info *i)
+{
+	int n;
+
+	for (n = 0; n < i->num_local_nodes; n++) {
+		set_bit(i->local_nodes[n] - 1, &c->local_nodes);
+	}
+}
+
 static struct clusterip_config *
 clusterip_config_init(struct ipt_clusterip_tgt_info *i, u_int32_t ip,
 			struct net_device *dev)
@@ -167,8 +177,7 @@
 	c->clusterip = ip;
 	memcpy(&c->clustermac, &i->clustermac, ETH_ALEN);
 	c->num_total_nodes = i->num_total_nodes;
-	c->num_local_nodes = i->num_local_nodes;
-	memcpy(&c->local_nodes, &i->local_nodes, sizeof(c->local_nodes));
+	clusterip_config_init_nodelist(c, i);
 	c->hash_mode = i->hash_mode;
 	c->hash_initval = i->hash_initval;
 	atomic_set(&c->refcount, 1);
@@ -196,53 +205,28 @@
 static int
 clusterip_add_node(struct clusterip_config *c, u_int16_t nodenum)
 {
-	int i;
-
-	write_lock_bh(&clusterip_lock);
 
-	if (c->num_local_nodes >= CLUSTERIP_MAX_NODES
-	    || nodenum > CLUSTERIP_MAX_NODES) {
-		write_unlock_bh(&clusterip_lock);
+	if (nodenum == 0 ||
+	    nodenum > c->num_total_nodes)
 		return 1;
-	}
-
-	/* check if we alrady have this number in our array */
-	for (i = 0; i < c->num_local_nodes; i++) {
-		if (c->local_nodes[i] == nodenum) {
-			write_unlock_bh(&clusterip_lock);
-			return 1;
-		}
-	}
 
-	c->local_nodes[c->num_local_nodes++] = nodenum;
+	/* check if we already have this number in our bitfield */
+	if (test_and_set_bit(nodenum - 1, &c->local_nodes))
+		return 1;
 
-	write_unlock_bh(&clusterip_lock);
 	return 0;
 }
 
 static int
 clusterip_del_node(struct clusterip_config *c, u_int16_t nodenum)
 {
-	int i;
-
-	write_lock_bh(&clusterip_lock);
-
-	if (c->num_local_nodes <= 1 || nodenum > CLUSTERIP_MAX_NODES) {
-		write_unlock_bh(&clusterip_lock);
+	if (nodenum == 0 ||
+	    nodenum > c->num_total_nodes)
 		return 1;
-	}
 		
-	for (i = 0; i < c->num_local_nodes; i++) {
-		if (c->local_nodes[i] == nodenum) {
-			int size = sizeof(u_int16_t)*(c->num_local_nodes-(i+1));
-			memmove(&c->local_nodes[i], &c->local_nodes[i+1], size);
-			c->num_local_nodes--;
-			write_unlock_bh(&clusterip_lock);
-			return 0;
-		}
-	}
+	if (test_and_clear_bit(nodenum - 1, &c->local_nodes))
+		return 0;
 
-	write_unlock_bh(&clusterip_lock);
 	return 1;
 }
 
@@ -310,25 +294,7 @@
 static inline int
 clusterip_responsible(struct clusterip_config *config, u_int32_t hash)
 {
-	int i;
-
-	read_lock_bh(&clusterip_lock);
-
-	if (config->num_local_nodes == 0) {
-		read_unlock_bh(&clusterip_lock);
-		return 0;
-	}
-
-	for (i = 0; i < config->num_local_nodes; i++) {
-		if (config->local_nodes[i] == hash) {
-			read_unlock_bh(&clusterip_lock);
-			return 1;
-		}
-	}
-
-	read_unlock_bh(&clusterip_lock);
-
-	return 0;
+	return test_bit(hash - 1, &config->local_nodes);
 }
 
 /*********************************************************************** 
@@ -603,56 +569,69 @@
 
 #ifdef CONFIG_PROC_FS
 
+struct clusterip_seq_position {
+	unsigned int pos;	/* position */
+	unsigned int weight;	/* number of bits set == size */
+	unsigned int bit;	/* current bit */
+	unsigned long val;	/* current value */
+};
+
 static void *clusterip_seq_start(struct seq_file *s, loff_t *pos)
 {
 	struct proc_dir_entry *pde = s->private;
 	struct clusterip_config *c = pde->data;
-	unsigned int *nodeidx;
-
-	read_lock_bh(&clusterip_lock);
-	if (*pos >= c->num_local_nodes)
+	unsigned int weight;
+	u_int32_t local_nodes;
+	struct clusterip_seq_position *idx;
+
+	/* FIXME: possible race */
+	local_nodes = c->local_nodes;
+	weight = hweight32(local_nodes);
+	if (*pos >= weight)
 		return NULL;
 
-	nodeidx = kmalloc(sizeof(unsigned int), GFP_KERNEL);
-	if (!nodeidx)
+	idx = kmalloc(sizeof(struct clusterip_seq_position), GFP_KERNEL);
+	if (!idx)
 		return ERR_PTR(-ENOMEM);
 
-	*nodeidx = *pos;
-	return nodeidx;
+	idx->pos = *pos;
+	idx->weight = weight;
+	idx->bit = ffs(local_nodes);
+	idx->val = local_nodes;
+	clear_bit(idx->bit - 1, &idx->val);
+
+	return idx;
 }
 
 static void *clusterip_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct proc_dir_entry *pde = s->private;
-	struct clusterip_config *c = pde->data;
-	unsigned int *nodeidx = (unsigned int *)v;
+	struct clusterip_seq_position *idx = (struct clusterip_seq_position *)v;
 
-	*pos = ++(*nodeidx);
-	if (*pos >= c->num_local_nodes) {
+	*pos = ++idx->pos;
+	if (*pos >= idx->weight) {
 		kfree(v);
 		return NULL;
 	}
-	return nodeidx;
+	idx->bit = ffs(idx->val);
+	clear_bit(idx->bit - 1, &idx->val);
+	return idx;
 }
 
 static void clusterip_seq_stop(struct seq_file *s, void *v)
 {
 	kfree(v);
-
-	read_unlock_bh(&clusterip_lock);
 }
 
 static int clusterip_seq_show(struct seq_file *s, void *v)
 {
-	struct proc_dir_entry *pde = s->private;
-	struct clusterip_config *c = pde->data;
-	unsigned int *nodeidx = (unsigned int *)v;
+	struct clusterip_seq_position *idx = (struct clusterip_seq_position *)v;
 
-	if (*nodeidx != 0) 
+	if (idx->pos != 0) 
 		seq_putc(s, ',');
-	seq_printf(s, "%u", c->local_nodes[*nodeidx]);
 
-	if (*nodeidx == c->num_local_nodes-1)
+	seq_printf(s, "%u", idx->bit);
+
+	if (idx->pos == idx->weight - 1)
 		seq_putc(s, '\n');
 
 	return 0;

--
 Regards,
  Krisztian Kovacs
 
