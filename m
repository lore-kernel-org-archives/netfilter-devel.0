From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 5/8]: Fix /proc/net/ip_conntrack seq_file operations
Date: Fri, 04 Mar 2005 13:00:44 +0100
Message-ID: <42284DEC.50505@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="05.diff"
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

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/03 23:17:17+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix /proc/net/ip_conntrack seq_file operations
#   
#   ip_conntrack dumps an entire hash chain at a time. If dumping
#   the first hash chain exceeds the available room nothing has
#   been copied and seq_read() stops and returns the error. Change
#   it to dump just a single entry at a time.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2005/03/03 23:17:07+01:00 kaber@coreworks.de +77 -39
#   [NETFILTER]: Fix /proc/net/ip_conntrack seq_file operations
#   
#   ip_conntrack dumps an entire hash chain at a time. If dumping
#   the first hash chain exceeds the available room nothing has
#   been copied and seq_read() stops and returns the error. Change
#   it to dump just a single entry at a time.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-03-03 23:35:54 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-03-03 23:35:54 +01:00
@@ -77,34 +77,70 @@
 #define seq_print_counters(x, y)	0
 #endif
 
-static void *ct_seq_start(struct seq_file *s, loff_t *pos)
+struct ct_iter_state {
+	unsigned int bucket;
+};
+
+static struct list_head *ct_get_first(struct seq_file *seq)
 {
-	if (*pos >= ip_conntrack_htable_size)
-		return NULL;
-	return &ip_conntrack_hash[*pos];
+	struct ct_iter_state *st = seq->private;
+
+	for (st->bucket = 0;
+	     st->bucket < ip_conntrack_htable_size;
+	     st->bucket++) {
+		if (!list_empty(&ip_conntrack_hash[st->bucket]))
+			return ip_conntrack_hash[st->bucket].next;
+	}
+	return NULL;
 }
-  
-static void ct_seq_stop(struct seq_file *s, void *v)
+
+static struct list_head *ct_get_next(struct seq_file *seq, struct list_head *head)
 {
+	struct ct_iter_state *st = seq->private;
+
+	head = head->next;
+	while (head == &ip_conntrack_hash[st->bucket]) {
+		if (++st->bucket >= ip_conntrack_htable_size)
+			return NULL;
+		head = ip_conntrack_hash[st->bucket].next;
+	}
+	return head;
+}
+
+static struct list_head *ct_get_idx(struct seq_file *seq, loff_t pos)
+{
+	struct list_head *head = ct_get_first(seq);
+
+	if (head)
+		while (pos && (head = ct_get_next(seq, head)))
+			pos--;
+	return pos ? NULL : head;
+}
+
+static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	READ_LOCK(&ip_conntrack_lock);
+	return ct_get_idx(seq, *pos);
 }
 
 static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	(*pos)++;
-	if (*pos >= ip_conntrack_htable_size)
-		return NULL;
-	return &ip_conntrack_hash[*pos];
+	return ct_get_next(s, v);
 }
   
-/* return 0 on success, 1 in case of error */
-static int ct_seq_real_show(const struct ip_conntrack_tuple_hash *hash,
-			    struct seq_file *s)
+static void ct_seq_stop(struct seq_file *s, void *v)
+{
+	READ_UNLOCK(&ip_conntrack_lock);
+}
+ 
+static int ct_seq_show(struct seq_file *s, void *v)
 {
+	const struct ip_conntrack_tuple_hash *hash = v;
 	const struct ip_conntrack *conntrack = tuplehash_to_ctrack(hash);
 	struct ip_conntrack_protocol *proto;
 
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-
 	IP_NF_ASSERT(conntrack);
 
 	/* we only want to print DIR_ORIGINAL */
@@ -121,58 +157,44 @@
 		      timer_pending(&conntrack->timeout)
 		      ? (long)(conntrack->timeout.expires - jiffies)/HZ
 		      : 0) != 0)
-		return 1;
+		return -ENOSPC;
 
 	if (proto->print_conntrack(s, conntrack))
-		return 1;
+		return -ENOSPC;
   
 	if (print_tuple(s, &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 			proto))
-		return 1;
+		return -ENOSPC;
 
  	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_ORIGINAL]))
-		return 1;
+		return -ENOSPC;
 
 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)))
 		if (seq_printf(s, "[UNREPLIED] "))
-			return 1;
+			return -ENOSPC;
 
 	if (print_tuple(s, &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple,
 			proto))
-		return 1;
+		return -ENOSPC;
 
  	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_REPLY]))
-		return 1;
+		return -ENOSPC;
 
 	if (test_bit(IPS_ASSURED_BIT, &conntrack->status))
 		if (seq_printf(s, "[ASSURED] "))
-			return 1;
+			return -ENOSPC;
 
 #if defined(CONFIG_IP_NF_CONNTRACK_MARK)
 	if (seq_printf(s, "mark=%lu ", conntrack->mark))
-		return 1;
+		return -ENOSPC;
 #endif
 
 	if (seq_printf(s, "use=%u\n", atomic_read(&conntrack->ct_general.use)))
-		return 1;
+		return -ENOSPC;
 
 	return 0;
 }
 
-static int ct_seq_show(struct seq_file *s, void *v)
-{
-	struct list_head *list = v;
-	int ret = 0;
-
-	/* FIXME: Simply truncates if hash chain too long. */
-	READ_LOCK(&ip_conntrack_lock);
-	if (LIST_FIND(list, ct_seq_real_show,
-		      struct ip_conntrack_tuple_hash *, s))
-		ret = -ENOSPC;
-	READ_UNLOCK(&ip_conntrack_lock);
-	return ret;
-}
-	
 static struct seq_operations ct_seq_ops = {
 	.start = ct_seq_start,
 	.next  = ct_seq_next,
@@ -182,7 +204,23 @@
   
 static int ct_open(struct inode *inode, struct file *file)
 {
-	return seq_open(file, &ct_seq_ops);
+	struct seq_file *seq;
+	struct ct_iter_state *st;
+	int ret;
+
+	st = kmalloc(sizeof(struct ct_iter_state), GFP_KERNEL);
+	if (st == NULL)
+		return -ENOMEM;
+	ret = seq_open(file, &ct_seq_ops);
+	if (ret)
+		goto out_free;
+	seq          = file->private_data;
+	seq->private = st;
+	memset(st, 0, sizeof(struct ct_iter_state));
+	return ret;
+out_free:
+	kfree(st);
+	return ret;
 }
 
 static struct file_operations ct_file_ops = {
@@ -190,7 +228,7 @@
 	.open    = ct_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = seq_release
+	.release = seq_release_private,
 };
   
 /* expects */
