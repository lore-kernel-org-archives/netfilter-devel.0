From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 9/11] Netfilter:  Remove ip_conntrack_tuple_hash "ctrack"
	pointer
Date: Mon, 17 Jan 2005 16:46:11 +1100
Message-ID: <1105940771.3954.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

Name: Remove ip_conntrack_tuple_hash "ctrack" pointer
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

We keep a pointer from the hash table entry into the connection
tracking entry it's a part of.  However, there's a spare byte in the
hash entry anyway, which we can use to indicate which of the two
tuples it is, and the simply use container_of() to access the
conntrack.

This saves two pointers per connection tracking entry.

Index: linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_amanda.c
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-01-11 21:04:11.742513416 +1100
+++ linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-01-11 21:05:20.013134704 +1100
@@ -120,7 +120,7 @@
 		exp->mask.src.ip = 0xFFFFFFFF;
 		exp->mask.src.u.tcp.port = 0;
 		exp->mask.dst.ip = 0xFFFFFFFF;
-		exp->mask.dst.protonum = 0xFFFF;
+		exp->mask.dst.protonum = 0xFF;
 		exp->mask.dst.u.tcp.port = 0xFFFF;
 
 		if (ip_nat_amanda_hook)
@@ -149,7 +149,7 @@
 		   .dst = { .protonum = IPPROTO_UDP },
 	},
 	.mask = { .src = { .u = { 0xFFFF } },
-		 .dst = { .protonum = 0xFFFF },
+		 .dst = { .protonum = 0xFF },
 	},
 };
 
Index: linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-11 21:04:11.742513416 +1100
+++ linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-11 21:05:20.013134704 +1100
@@ -66,7 +66,8 @@
 
 #ifdef CONFIG_IP_NF_CT_ACCT
 static unsigned int
-seq_print_counters(struct seq_file *s, struct ip_conntrack_counter *counter)
+seq_print_counters(struct seq_file *s,
+		   const struct ip_conntrack_counter *counter)
 {
 	return seq_printf(s, "packets=%llu bytes=%llu ",
 			  (unsigned long long)counter->packets,
@@ -99,7 +100,7 @@
 static int ct_seq_real_show(const struct ip_conntrack_tuple_hash *hash,
 			    struct seq_file *s)
 {
-	struct ip_conntrack *conntrack = hash->ctrack;
+	const struct ip_conntrack *conntrack = tuplehash_to_ctrack(hash);
 	struct ip_conntrack_protocol *proto;
 
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
Index: linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_nat.h
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat.h	2005-01-11 21:04:45.753342984 +1100
+++ linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_nat.h	2005-01-11 21:05:20.014134552 +1100
@@ -66,6 +66,8 @@
 	struct ip_nat_seq seq[IP_CT_DIR_MAX];
 };
 
+struct ip_conntrack;
+
 /* Set up the info structure to map into this range. */
 extern unsigned int ip_nat_setup_info(struct ip_conntrack *conntrack,
 				      const struct ip_nat_range *range,
Index: linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-11 21:04:11.743513264 +1100
+++ linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-11 21:05:20.014134552 +1100
@@ -192,6 +192,13 @@
 	struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
 };
 
+static inline struct ip_conntrack *
+tuplehash_to_ctrack(const struct ip_conntrack_tuple_hash *hash)
+{
+	return container_of(hash, struct ip_conntrack,
+			    tuplehash[hash->tuple.dst.dir]);
+}
+
 /* get master conntrack via master expectation */
 #define master_ct(conntr) (conntr->master)
 
Index: linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_tftp.c
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-01-11 21:04:11.742513416 +1100
+++ linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-01-11 21:05:20.015134400 +1100
@@ -73,7 +73,7 @@
 		exp->mask.src.ip = 0xffffffff;
 		exp->mask.dst.ip = 0xffffffff;
 		exp->mask.dst.u.udp.port = 0xffff;
-		exp->mask.dst.protonum = 0xffff;
+		exp->mask.dst.protonum = 0xff;
 		exp->expectfn = NULL;
 		exp->master = ct;
 
@@ -128,7 +128,7 @@
 
 		tftp[i].tuple.dst.protonum = IPPROTO_UDP;
 		tftp[i].tuple.src.u.udp.port = htons(ports[i]);
-		tftp[i].mask.dst.protonum = 0xFFFF;
+		tftp[i].mask.dst.protonum = 0xFF;
 		tftp[i].mask.src.u.udp.port = 0xFFFF;
 		tftp[i].max_expected = 1;
 		tftp[i].timeout = 5 * 60; /* 5 minutes */
Index: linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-11 21:04:11.742513416 +1100
+++ linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-11 21:05:20.014134552 +1100
@@ -418,7 +418,7 @@
 	exp->tuple.dst.protonum = IPPROTO_TCP;
 	exp->mask = ((struct ip_conntrack_tuple)
 		{ { 0xFFFFFFFF, { 0 } },
-		  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
+		  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 
 	exp->expectfn = NULL;
 	exp->master = ct;
@@ -473,7 +473,7 @@
 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
 		ftp[i].mask.src.u.tcp.port = 0xFFFF;
-		ftp[i].mask.dst.protonum = 0xFFFF;
+		ftp[i].mask.dst.protonum = 0xFF;
 		ftp[i].max_expected = 1;
 		ftp[i].timeout = 5 * 60; /* 5 minutes */
 		ftp[i].me = THIS_MODULE;
Index: linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-01-11 21:04:11.742513416 +1100
+++ linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-01-11 21:05:20.015134400 +1100
@@ -196,7 +196,7 @@
 	}
 
 	/* Update skb to refer to this connection */
-	skb->nfct = &h->ctrack->ct_general;
+	skb->nfct = &tuplehash_to_ctrack(h)->ct_general;
 	skb->nfctinfo = *ctinfo;
 	return -NF_ACCEPT;
 }
Index: linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2005-01-11 21:04:11.742513416 +1100
+++ linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c	2005-01-11 21:05:20.015134400 +1100
@@ -215,7 +215,7 @@
 				    IPPROTO_TCP }});
 			exp->mask = ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },
-				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
+				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 			exp->expectfn = NULL;
 			exp->master = ct;
 			if (ip_nat_irc_hook)
@@ -265,7 +265,7 @@
 		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
 		hlpr->tuple.dst.protonum = IPPROTO_TCP;
 		hlpr->mask.src.u.tcp.port = 0xFFFF;
-		hlpr->mask.dst.protonum = 0xFFFF;
+		hlpr->mask.dst.protonum = 0xFF;
 		hlpr->max_expected = max_dcc_channels;
 		hlpr->timeout = dcc_timeout;
 		hlpr->me = THIS_MODULE;
Index: linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-01-11 21:04:11.743513264 +1100
+++ linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-01-11 21:05:20.015134400 +1100
@@ -64,7 +64,10 @@
 		} u;
 
 		/* The protocol. */
-		u_int16_t protonum;
+		u8 protonum;
+
+		/* The direction (for tuplehash) */
+		u8 dir;
 	} dst;
 };
 
@@ -94,7 +97,7 @@
 #define CTINFO2DIR(ctinfo) ((ctinfo) >= IP_CT_IS_REPLY ? IP_CT_DIR_REPLY : IP_CT_DIR_ORIGINAL)
 
 /* If we're the first tuple, it's the original dir. */
-#define DIRECTION(h) ((enum ip_conntrack_dir)(&(h)->ctrack->tuplehash[1] == (h)))
+#define DIRECTION(h) ((enum ip_conntrack_dir)(h)->tuple.dst.dir)
 
 /* Connections have two entries in the hash table: one for each way */
 struct ip_conntrack_tuple_hash
@@ -102,9 +105,6 @@
 	struct list_head list;
 
 	struct ip_conntrack_tuple tuple;
-
-	/* this == &ctrack->tuplehash[DIRECTION(this)]. */
-	struct ip_conntrack *ctrack;
 };
 
 #endif /* __KERNEL__ */
Index: linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-11 21:04:11.742513416 +1100
+++ linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-11 21:05:20.017134096 +1100
@@ -117,6 +117,7 @@
 	tuple->src.ip = iph->saddr;
 	tuple->dst.ip = iph->daddr;
 	tuple->dst.protonum = iph->protocol;
+	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
 
 	return protocol->pkt_to_tuple(skb, dataoff, tuple);
 }
@@ -129,6 +130,7 @@
 	inverse->src.ip = orig->dst.ip;
 	inverse->dst.ip = orig->src.ip;
 	inverse->dst.protonum = orig->dst.protonum;
+	inverse->dst.dir = !orig->dst.dir;
 
 	return protocol->invert_tuple(inverse, orig);
 }
@@ -281,7 +283,7 @@
 		    const struct ip_conntrack *ignored_conntrack)
 {
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	return i->ctrack != ignored_conntrack
+	return tuplehash_to_ctrack(i) != ignored_conntrack
 		&& ip_ct_tuple_equal(tuple, &i->tuple);
 }
 
@@ -314,7 +316,7 @@
 	READ_LOCK(&ip_conntrack_lock);
 	h = __ip_conntrack_find(tuple, ignored_conntrack);
 	if (h)
-		atomic_inc(&h->ctrack->ct_general.use);
+		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
 	READ_UNLOCK(&ip_conntrack_lock);
 
 	return h;
@@ -407,30 +409,33 @@
    connection.  Too bad: we're in trouble anyway. */
 static inline int unreplied(const struct ip_conntrack_tuple_hash *i)
 {
-	return !(test_bit(IPS_ASSURED_BIT, &i->ctrack->status));
+	return !(test_bit(IPS_ASSURED_BIT, &tuplehash_to_ctrack(i)->status));
 }
 
 static int early_drop(struct list_head *chain)
 {
 	/* Traverse backwards: gives us oldest, which is roughly LRU */
 	struct ip_conntrack_tuple_hash *h;
+	struct ip_conntrack *ct = NULL;
 	int dropped = 0;
 
 	READ_LOCK(&ip_conntrack_lock);
 	h = LIST_FIND_B(chain, unreplied, struct ip_conntrack_tuple_hash *);
-	if (h)
-		atomic_inc(&h->ctrack->ct_general.use);
+	if (h) {
+		ct = tuplehash_to_ctrack(h);
+		atomic_inc(&ct->ct_general.use);
+	}
 	READ_UNLOCK(&ip_conntrack_lock);
 
-	if (!h)
+	if (!ct)
 		return dropped;
 
-	if (del_timer(&h->ctrack->timeout)) {
-		death_by_timeout((unsigned long)h->ctrack);
+	if (del_timer(&ct->timeout)) {
+		death_by_timeout((unsigned long)ct);
 		dropped = 1;
 		CONNTRACK_STAT_INC(early_drop);
 	}
-	ip_conntrack_put(h->ctrack);
+	ip_conntrack_put(ct);
 	return dropped;
 }
 
@@ -493,9 +498,7 @@
 	atomic_set(&conntrack->ct_general.use, 1);
 	conntrack->ct_general.destroy = destroy_conntrack;
 	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *tuple;
-	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].ctrack = conntrack;
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = repl_tuple;
-	conntrack->tuplehash[IP_CT_DIR_REPLY].ctrack = conntrack;
 	if (!protocol->new(conntrack, skb)) {
 		kmem_cache_free(ip_conntrack_cachep, conntrack);
 		return NULL;
@@ -550,6 +553,7 @@
 {
 	struct ip_conntrack_tuple tuple;
 	struct ip_conntrack_tuple_hash *h;
+	struct ip_conntrack *ct;
 
 	IP_NF_ASSERT((skb->nh.iph->frag_off & htons(IP_OFFSET)) == 0);
 
@@ -566,6 +570,7 @@
 		if (IS_ERR(h))
 			return (void *)h;
 	}
+	ct = tuplehash_to_ctrack(h);
 
 	/* It exists; we have (non-exclusive) reference. */
 	if (DIRECTION(h) == IP_CT_DIR_REPLY) {
@@ -574,24 +579,24 @@
 		*set_reply = 1;
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
-		if (test_bit(IPS_SEEN_REPLY_BIT, &h->ctrack->status)) {
+		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 			DEBUGP("ip_conntrack_in: normal packet for %p\n",
-			       h->ctrack);
+			       ct);
 		        *ctinfo = IP_CT_ESTABLISHED;
-		} else if (test_bit(IPS_EXPECTED_BIT, &h->ctrack->status)) {
+		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
 			DEBUGP("ip_conntrack_in: related packet for %p\n",
-			       h->ctrack);
+			       ct);
 			*ctinfo = IP_CT_RELATED;
 		} else {
 			DEBUGP("ip_conntrack_in: new packet for %p\n",
-			       h->ctrack);
+			       ct);
 			*ctinfo = IP_CT_NEW;
 		}
 		*set_reply = 0;
 	}
-	skb->nfct = &h->ctrack->ct_general;
+	skb->nfct = &ct->ct_general;
 	skb->nfctinfo = *ctinfo;
-	return h->ctrack;
+	return ct;
 }
 
 /* Netfilter hook itself. */
@@ -862,8 +867,8 @@
 static inline int unhelp(struct ip_conntrack_tuple_hash *i,
 			 const struct ip_conntrack_helper *me)
 {
-	if (i->ctrack->helper == me)
-		i->ctrack->helper = NULL;
+	if (tuplehash_to_ctrack(i)->helper == me)
+		tuplehash_to_ctrack(i)->helper = NULL;
 	return 0;
 }
 
@@ -1001,7 +1006,7 @@
 	int (*iter)(struct ip_conntrack *i, void *data),
 	void *data)
 {
-	return iter(i->ctrack, data);
+	return iter(tuplehash_to_ctrack(i), data);
 }
 
 /* Bring out ya dead! */
@@ -1022,7 +1027,7 @@
 		h = LIST_FIND_W(&unconfirmed, do_iter,
 				struct ip_conntrack_tuple_hash *, iter, data);
 	if (h)
-		atomic_inc(&h->ctrack->ct_general.use);
+		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	return h;
@@ -1035,12 +1040,13 @@
 	unsigned int bucket = 0;
 
 	while ((h = get_next_corpse(iter, data, &bucket)) != NULL) {
+		struct ip_conntrack *ct = tuplehash_to_ctrack(h);
 		/* Time to push up daises... */
-		if (del_timer(&h->ctrack->timeout))
-			death_by_timeout((unsigned long)h->ctrack);
+		if (del_timer(&ct->timeout))
+			death_by_timeout((unsigned long)ct);
 		/* ... else the timer will get him soon. */
 
-		ip_conntrack_put(h->ctrack);
+		ip_conntrack_put(ct);
 	}
 }
 
@@ -1077,16 +1083,17 @@
 	h = ip_conntrack_find_get(&tuple, NULL);
 	if (h) {
 		struct sockaddr_in sin;
+		struct ip_conntrack *ct = tuplehash_to_ctrack(h);
 
 		sin.sin_family = AF_INET;
-		sin.sin_port = h->ctrack->tuplehash[IP_CT_DIR_ORIGINAL]
+		sin.sin_port = ct->tuplehash[IP_CT_DIR_ORIGINAL]
 			.tuple.dst.u.tcp.port;
-		sin.sin_addr.s_addr = h->ctrack->tuplehash[IP_CT_DIR_ORIGINAL]
+		sin.sin_addr.s_addr = ct->tuplehash[IP_CT_DIR_ORIGINAL]
 			.tuple.dst.ip;
 
 		DEBUGP("SO_ORIGINAL_DST: %u.%u.%u.%u %u\n",
 		       NIPQUAD(sin.sin_addr.s_addr), ntohs(sin.sin_port));
-		ip_conntrack_put(h->ctrack);
+		ip_conntrack_put(ct);
 		if (copy_to_user(user, &sin, sizeof(sin)) != 0)
 			return -EFAULT;
 		else
