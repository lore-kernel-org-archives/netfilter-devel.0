From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Thu, 9 Dec 2004 09:34:34 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
	Grzegorz Piotr Jaskiewicz <gj@pointblue.com.pl>
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

Hi,

The included patch addresses the following issues:

- When the conntrack table is full, we search only in a single hash
  bucket. We are in trouble anyway, so let's search harder for
  droppable entries: the patch extends the search to at most the third of
  all the buckets.
- If the conntrack table is full, the remote management of the machine
  becomes a little bit complicated :-). The patch adds the ability to
  reserve a given number of entries to be used for management connections.
  The following proc entries are added to /proc/sys/net/ipv4/netfilter:

  ip_conntrack_reserved		the number of reserved connections

  ip_conntrack_reserved_mark	mark value to match

  ip_conntrack_reserved_mask	mask to use at matching

  Example:

  # Let's reserve 3 conntrack entries
  echo 3 > /proc/sys/net/ipv4/netfilter/ip_conntrack_reserved
  # Set mark value; mask is left the default 0xffffffff
  echo 1 > /proc/sys/net/ipv4/netfilter/ip_conntrack_reserved_mark
  # Mark connection-initiating packets in raw table to use the reserved
  # entries when the table is full, i.e ip_conntrack_count >=
  # ip_conntrack_max - ip_conntrack_reserved
  iptables -t raw -A PREROUTING -s <management station> -d <firewall> \
	  	  -p tcp --dport 22 -m mark --mark 1 -j ACCEPT

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.9-orig/include/linux/sysctl.h linux-2.6.9-early_drop/include/linux/sysctl.h
--- linux-2.6.9-orig/include/linux/sysctl.h	2004-10-18 23:54:31.000000000 +0200
+++ linux-2.6.9-early_drop/include/linux/sysctl.h	2004-12-09 05:27:02.000000000 +0100
@@ -426,6 +426,9 @@
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD=25,
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT=26,
 	NET_IPV4_NF_CONNTRACK_COUNT=27,
+	NET_IPV4_NF_CONNTRACK_RESERVED=28,
+	NET_IPV4_NF_CONNTRACK_RESERVED_MARK=29,
+	NET_IPV4_NF_CONNTRACK_RESERVED_MASK=30,
 };

 /* /proc/sys/net/ipv6 */
diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.9-orig/net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.9-early_drop/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.9-orig/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-18 23:53:05.000000000 +0200
+++ linux-2.6.9-early_drop/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-09 05:42:19.000000000 +0100
@@ -76,6 +76,11 @@
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid;

+/* Number of reserved conntrack entries; mark value; mask */
+int ip_ct_reserved = 0;
+unsigned long ip_ct_reserved_mark = 0;
+unsigned long ip_ct_reserved_mask = 0xffffffff;
+
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);

 inline void
@@ -468,16 +473,32 @@
 	return !(test_bit(IPS_ASSURED_BIT, &i->ctrack->status));
 }

-static int early_drop(struct list_head *chain)
+static int early_drop(struct sk_buff *skb, unsigned int hash)
 {
-	/* Traverse backwards: gives us oldest, which is roughly LRU */
-	struct ip_conntrack_tuple_hash *h;
-	int dropped = 0;
+	struct ip_conntrack_tuple_hash *h = NULL;
+	int dropped = 1;
+	unsigned int i, bucket;
+
+	if (ip_ct_reserved == 0
+	    || atomic_read(&ip_conntrack_count) >= ip_conntrack_max)
+		goto not_reserved;

+	/* Let through reserved connections */
+	if ((skb->nfmark & ip_ct_reserved_mask) == ip_ct_reserved_mark)
+		return dropped;
+
+    not_reserved:
+    	dropped = 0;
 	READ_LOCK(&ip_conntrack_lock);
-	h = LIST_FIND_B(chain, unreplied, struct ip_conntrack_tuple_hash *);
-	if (h)
-		atomic_inc(&h->ctrack->ct_general.use);
+	/* Try hard but not fully: magic number is three */
+	for (i = 0; h == NULL && i < ip_conntrack_htable_size/3; i++) {
+		bucket = (i + hash) % ip_conntrack_htable_size;
+		/* Traverse backwards: gives us oldest, which is roughly LRU */
+		h = LIST_FIND_B(&ip_conntrack_hash[bucket], unreplied,
+				struct ip_conntrack_tuple_hash *);
+		if (h)
+			atomic_inc(&h->ctrack->ct_general.use);
+	}
 	READ_UNLOCK(&ip_conntrack_lock);

 	if (!h)
@@ -525,9 +546,10 @@
 	hash = hash_conntrack(tuple);

 	if (ip_conntrack_max
-	    && atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {
-		/* Try dropping from this hash chain. */
-		if (!early_drop(&ip_conntrack_hash[hash])) {
+	    && atomic_read(&ip_conntrack_count)
+	       >= (ip_conntrack_max - ip_ct_reserved)) {
+		/* Try dropping starting from this hash chain. */
+		if (!early_drop(skb, hash)) {
 			if (net_ratelimit())
 				printk(KERN_WARNING
 				       "ip_conntrack: table full, dropping"
diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.9-orig/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.6.9-early_drop/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.6.9-orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-18 23:54:07.000000000 +0200
+++ linux-2.6.9-early_drop/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-09 05:47:04.000000000 +0100
@@ -481,6 +481,14 @@
 /* From ip_conntrack_core.c */
 extern int ip_conntrack_max;
 extern unsigned int ip_conntrack_htable_size;
+extern int ip_ct_reserved;
+extern unsigned long ip_ct_reserved_mask;
+extern unsigned long ip_ct_reserved_mark;
+
+/* Static boundaries */
+static int reserved_min = 0;
+static int conntrack_max = INT_MAX;
+

 /* From ip_conntrack_proto_tcp.c */
 extern unsigned long ip_ct_tcp_timeout_syn_sent;
@@ -519,7 +527,9 @@
 		.data		= &ip_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.extra1		= &ip_ct_reserved,
+		.extra2		= &conntrack_max,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_COUNT,
@@ -676,6 +686,32 @@
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_RESERVED,
+		.procname	= "ip_conntrack_reserved",
+		.data		= &ip_ct_reserved,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.extra1		= &reserved_min,
+		.extra2		= &ip_conntrack_max,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_RESERVED_MARK,
+		.procname	= "ip_conntrack_reserved_mark",
+		.data		= &ip_ct_reserved_mark,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_RESERVED_MASK,
+		.procname	= "ip_conntrack_reserved_mask",
+		.data		= &ip_ct_reserved_mask,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
 	{ .ctl_name = 0 }
 };
