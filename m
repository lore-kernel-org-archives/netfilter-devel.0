From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack error
Date: Sun, 13 Feb 2005 00:21:29 +0100
Message-ID: <420E8F79.1010802@trash.net>
References: <20050212110358.GA32095@daleka.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030101080203040204060301"
Cc: netfilter-devel@lists.netfilter.org
To: Piotrek Kaczmarek <kaczorek@k.daleka.net>
In-Reply-To: <20050212110358.GA32095@daleka.net>
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

This is a multi-part message in MIME format.
--------------030101080203040204060301
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Piotrek Kaczmarek wrote:

>Hi,
>I encountered the following situation - when there are around 20000 connections
>"cat /proc/net/ip_conntrack" doesn't display all connections and outputs
>"cat: No space left on device" error. If I patch kernel with POM and 'nth' module
>(only patch, don't load the module) the same happens around 17000 connections.
>It happenes both with 2.6.9 and 2.6.10 kernels.
>
>Why is it so? Is this matter of memory limit or something else?
>
It happens when the first hash chain it tries to dump exceeds the available
size. This patch should fix it. You need to apply both patches to avoid 
rejects.

Regards
Patrick


--------------030101080203040204060301
Content-Type: text/x-patch;
 name="2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/13 00:16:46+01:00 kaber@coreworks.de 
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
#   2005/02/13 00:16:34+01:00 kaber@coreworks.de +77 -39
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
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-02-13 00:20:00 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-02-13 00:20:00 +01:00
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

--------------030101080203040204060301
Content-Type: text/x-patch;
 name="1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="1.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/04 04:16:35+01:00 kaber@coreworks.de 
#   [NETFILTER]: Use correct types in seq_printf calls
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_hashlimit.c
#   2005/02/04 04:16:26+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Use correct types in seq_printf calls
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2005/02/04 04:16:26+01:00 kaber@coreworks.de +6 -5
#   [NETFILTER]: Use correct types in seq_printf calls
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-02-13 00:20:14 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-02-13 00:20:14 +01:00
@@ -115,11 +115,12 @@
 			       .tuple.dst.protonum);
 	IP_NF_ASSERT(proto);
 
-	if (seq_printf(s, "%-8s %u %lu ",
+	if (seq_printf(s, "%-8s %u %ld ",
 		      proto->name,
 		      conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
 		      timer_pending(&conntrack->timeout)
-		      ? (conntrack->timeout.expires - jiffies)/HZ : 0) != 0)
+		      ? (long)(conntrack->timeout.expires - jiffies)/HZ
+		      : 0) != 0)
 		return 1;
 
 	if (proto->print_conntrack(s, conntrack))
@@ -148,7 +149,7 @@
 			return 1;
 
 #if defined(CONFIG_IP_NF_CONNTRACK_MARK)
-	if (seq_printf(s, "mark=%ld ", conntrack->mark))
+	if (seq_printf(s, "mark=%lu ", conntrack->mark))
 		return 1;
 #endif
 
@@ -235,8 +236,8 @@
 	struct ip_conntrack_expect *expect = v;
 
 	if (expect->timeout.function)
-		seq_printf(s, "%lu ", timer_pending(&expect->timeout)
-			   ? (expect->timeout.expires - jiffies)/HZ : 0);
+		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
+			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);
 	else
 		seq_printf(s, "- ");
 
diff -Nru a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
--- a/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-13 00:20:14 +01:00
+++ b/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-13 00:20:14 +01:00
@@ -609,7 +609,7 @@
 	rateinfo_recalc(ent, jiffies);
 
 	return seq_printf(s, "%ld %u.%u.%u.%u:%u->%u.%u.%u.%u:%u %u %u %u\n",
-			(ent->expires - jiffies)/HZ,
+			(long)(ent->expires - jiffies)/HZ,
 			NIPQUAD(ent->dst.src_ip), ntohs(ent->dst.src_port),
 			NIPQUAD(ent->dst.dst_ip), ntohs(ent->dst.dst_port),
 			ent->rateinfo.credit, ent->rateinfo.credit_cap,

--------------030101080203040204060301--
