From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 1/2] change API and ip_conntrack modifications for
	nfnetlink_conntrack
Date: Mon, 28 Mar 2005 01:55:45 +0200
Message-ID: <42474801.2000508@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060501000504060609050404"
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------060501000504060609050404
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch contains the change API and other modifications required for 
the nfnetlink_conntrack. It applies on top of the ct-event-API.

I guess that this is heavy going to review but I don't see another way 
to such a patch.

Since this won't ever become part of ip_conntrack. Would it be worth it 
posting small patches with modifications for nf_conntrack to make fit 
requirements of nfnetlink_conntrack in future?

--------------060501000504060609050404
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

--- linux-2.5/net/ipv4/netfilter/ip_conntrack_core.c.orig	2005-03-09 18:35:17.000000000 +0100
+++ linux-2.5/net/ipv4/netfilter/ip_conntrack_core.c	2005-03-27 20:11:17.000000000 +0200
@@ -77,12 +77,35 @@
 static LIST_HEAD(unconfirmed);
 static int ip_conntrack_vmalloc;
 
+/* FIXME: currently racy. kaber says: "Luke, use per-cpu stuff "*/
+static unsigned int ip_conntrack_next_id = 1;
+static unsigned int ip_conntrack_exp_next_id = 1;
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
 struct notifier_block *ip_conntrack_chain;
 #endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
 
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
+/* Insert ordered */
+static inline void
+list_insert_ordered(struct list_head *head,
+		    struct ip_conntrack *ct,
+		    enum ip_conntrack_dir dir)
+{
+	struct list_head *i;
+	struct ip_conntrack *cur;
+
+	ASSERT_WRITE_LOCK(head);
+	list_for_each(i, head) {
+		cur = (struct ip_conntrack *) i;
+		if (ct->id <= cur->id) {
+			list_add_tail(&ct->tuplehash[dir].list, i);
+			return;
+		}
+        }
+	list_add_tail(&ct->tuplehash[dir].list, head);
+}
+
 void 
 ip_conntrack_put(struct ip_conntrack *ct)
 {
@@ -93,7 +116,7 @@
 static int ip_conntrack_hash_rnd_initted;
 static unsigned int ip_conntrack_hash_rnd;
 
-static u_int32_t
+u_int32_t
 hash_conntrack(const struct ip_conntrack_tuple *tuple)
 {
 #if 0
@@ -168,6 +191,24 @@
 	destroy_expect(exp);
 }
 
+/* Just find a expectation corresponding to a tuple. */
+struct ip_conntrack_expect *
+ip_conntrack_expect_find_get(const struct ip_conntrack_tuple *tuple)
+{
+	struct ip_conntrack_expect *i;
+	
+	READ_LOCK(&ip_conntrack_lock);
+	list_for_each_entry(i, &ip_conntrack_expect_list, list) {
+		if (ip_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)) {
+			atomic_inc(&i->use);
+			return i;
+		}
+	}
+	READ_UNLOCK(&ip_conntrack_lock);
+
+	return NULL;
+}
+
 /* If an expectation for this connection is found, it gets delete from
  * global list then returned. */
 static struct ip_conntrack_expect *
@@ -192,7 +233,7 @@
 }
 
 /* delete all expectations for this conntrack */
-static void remove_expectations(struct ip_conntrack *ct)
+void ip_ct_remove_expectations(struct ip_conntrack *ct)
 {
 	struct ip_conntrack_expect *i, *tmp;
 
@@ -222,7 +263,7 @@
 	LIST_DELETE(&ip_conntrack_hash[hr], &ct->tuplehash[IP_CT_DIR_REPLY]);
 
 	/* Destroy all pending expectations */
-	remove_expectations(ct);
+	ip_ct_remove_expectations(ct);
 }
 
 static void
@@ -252,7 +293,7 @@
 	 * except TFTP can create an expectation on the first packet,
 	 * before connection is in the list, so we need to clean here,
 	 * too. */
-	remove_expectations(ct);
+	ip_ct_remove_expectations(ct);
 
 	/* We overload first tuple to link into unconfirmed list. */
 	if (!is_confirmed(ct)) {
@@ -330,6 +371,14 @@
 	return h;
 }
 
+void inline ip_conntrack_insert(struct ip_conntrack *ct, 
+				unsigned int hash,
+				unsigned int rpl_hash)
+{
+	list_insert_ordered(&ip_conntrack_hash[hash], ct, IP_CT_DIR_ORIGINAL);
+	list_insert_ordered(&ip_conntrack_hash[rpl_hash], ct, IP_CT_DIR_REPLY);
+}
+
 /* Confirm a connection given skb; places it in hash table */
 int
 __ip_conntrack_confirm(struct sk_buff **pskb)
@@ -376,10 +425,7 @@
 		/* Remove from unconfirmed list */
 		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 
-		list_prepend(&ip_conntrack_hash[hash],
-			     &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
-		list_prepend(&ip_conntrack_hash[repl_hash],
-			     &ct->tuplehash[IP_CT_DIR_REPLY]);
+		ip_conntrack_insert(ct, hash, repl_hash);
 		/* Timer relative to confirmation time, not original
 		   setting time, otherwise we'd get timer wrap in
 		   weird delay cases. */
@@ -398,6 +444,7 @@
 #endif
 		ip_conntrack_event_cache(master_ct(ct) ?
 					 IPCT_RELATED : IPCT_NEW, *pskb);
+		ct->id = ++ip_conntrack_next_id;
 
 		return NF_ACCEPT;
 	}
@@ -463,17 +510,48 @@
 	return ip_ct_tuple_mask_cmp(rtuple, &i->tuple, &i->mask);
 }
 
-static struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple)
+struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple)
 {
 	return LIST_FIND(&helpers, helper_cmp,
 			 struct ip_conntrack_helper *,
 			 tuple);
 }
 
+struct ip_conntrack *ip_conntrack_alloc(struct ip_conntrack_tuple *orig,
+					struct ip_conntrack_tuple *repl)
+{
+	struct ip_conntrack *conntrack;
+
+	conntrack = kmem_cache_alloc(ip_conntrack_cachep, GFP_ATOMIC);
+	if (!conntrack) {
+		DEBUGP("Can't allocate conntrack.\n");
+		return NULL;
+	}
+
+	memset(conntrack, 0, sizeof(*conntrack));
+	atomic_set(&conntrack->ct_general.use, 1);
+	conntrack->ct_general.destroy = destroy_conntrack;
+	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
+	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *repl;
+
+	/* Don't set timer yet: wait for confirmation */
+	init_timer(&conntrack->timeout);
+	conntrack->timeout.data = (unsigned long)conntrack;
+	conntrack->timeout.function = death_by_timeout;
+
+	return conntrack;
+}
+
+inline void
+ip_conntrack_free(struct ip_conntrack *conntrack)
+{
+	kmem_cache_free(ip_conntrack_cachep, conntrack);
+}
+
 /* Allocate a new conntrack: we return -ENOMEM if classification
    failed due to stress.  Otherwise it really is unclassifiable. */
 static struct ip_conntrack_tuple_hash *
-init_conntrack(const struct ip_conntrack_tuple *tuple,
+init_conntrack(struct ip_conntrack_tuple *tuple,
 	       struct ip_conntrack_protocol *protocol,
 	       struct sk_buff *skb)
 {
@@ -506,25 +584,13 @@
 		return NULL;
 	}
 
-	conntrack = kmem_cache_alloc(ip_conntrack_cachep, GFP_ATOMIC);
-	if (!conntrack) {
-		DEBUGP("Can't allocate conntrack.\n");
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!(conntrack = ip_conntrack_alloc(tuple, &repl_tuple)))
+		return NULL;
 
-	memset(conntrack, 0, sizeof(*conntrack));
-	atomic_set(&conntrack->ct_general.use, 1);
-	conntrack->ct_general.destroy = destroy_conntrack;
-	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *tuple;
-	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = repl_tuple;
 	if (!protocol->new(conntrack, skb)) {
 		kmem_cache_free(ip_conntrack_cachep, conntrack);
 		return NULL;
 	}
-	/* Don't set timer yet: wait for confirmation */
-	init_timer(&conntrack->timeout);
-	conntrack->timeout.data = (unsigned long)conntrack;
-	conntrack->timeout.function = death_by_timeout;
 
 	WRITE_LOCK(&ip_conntrack_lock);
 	exp = find_expectation(tuple);
@@ -765,13 +831,15 @@
 		DEBUGP("expect_related: OOM allocating expect\n");
 		return NULL;
 	}
+	atomic_set(&new->use, 0);
 	new->master = NULL;
 	return new;
 }
 
 void ip_conntrack_expect_free(struct ip_conntrack_expect *expect)
 {
-	kmem_cache_free(ip_conntrack_expect_cachep, expect);
+	if (atomic_dec_and_test(&expect->use))
+		kmem_cache_free(ip_conntrack_expect_cachep, expect);
 }
 
 static void ip_conntrack_expect_insert(struct ip_conntrack_expect *exp)
@@ -790,6 +858,7 @@
 	} else
 		exp->timeout.function = NULL;
 
+	atomic_inc(&exp->use);
 	CONNTRACK_STAT_INC(expect_create);
 }
 
@@ -1017,6 +1086,32 @@
 	nf_conntrack_get(nskb->nfct);
 }
 
+void ip_ct_generic_change_proto(struct ip_conntrack *ct, 
+				union ip_conntrack_proto *p)
+{
+	struct ip_conntrack_protocol *proto;
+	struct ip_conntrack_tuple_hash *th = &ct->tuplehash[IP_CT_DIR_REPLY];
+
+	proto = ip_ct_find_proto(th->tuple.dst.protonum);
+	if (proto->lock != NULL) {
+		write_lock_bh(proto->lock);
+		memcpy(&ct->proto, p, sizeof(union ip_conntrack_proto));
+		write_unlock_bh(proto->lock);
+	} else
+		memcpy(&ct->proto, p, sizeof(union ip_conntrack_proto));
+}
+
+void ip_ct_generic_change_help(struct ip_conntrack *ct, 
+			       union ip_conntrack_help *h)
+{
+	if (ct->helper->lock != NULL) {
+		spin_lock_bh(ct->helper->lock);
+		memcpy(&ct->help, h, sizeof(ct->help));
+		spin_unlock_bh(ct->helper->lock);
+	} else
+		memcpy(&ct->help, h, sizeof(ct->help));
+}
+
 static inline int
 do_iter(const struct ip_conntrack_tuple_hash *i,
 	int (*iter)(struct ip_conntrack *i, void *data),
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_standalone.c.orig	2005-03-09 18:19:24.000000000 +0100
+++ linux-2.5/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-03-27 15:30:45.000000000 +0200
@@ -892,6 +892,17 @@
 {
 }
 
+EXPORT_SYMBOL(hash_conntrack);
+EXPORT_SYMBOL(ip_conntrack_expect_list);
+EXPORT_SYMBOL(ip_ct_invert_tuple);
+EXPORT_SYMBOL(ip_ct_generic_change_proto);
+EXPORT_SYMBOL(ip_ct_generic_change_help);
+EXPORT_SYMBOL(ip_conntrack_expect_find_get);
+EXPORT_SYMBOL(ip_conntrack_alloc);
+EXPORT_SYMBOL(ip_conntrack_free);
+EXPORT_SYMBOL(ip_conntrack_insert);
+EXPORT_SYMBOL(ip_ct_remove_expectations);
+EXPORT_SYMBOL(ip_ct_find_helper);
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
 EXPORT_SYMBOL(ip_conntrack_chain);
 EXPORT_SYMBOL(ip_conntrack_register_notifier);
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_icmp.c.orig	2005-03-28 01:11:03.000000000 +0200
+++ linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-03-10 23:55:44.000000000 +0100
@@ -109,16 +109,17 @@
 	return NF_ACCEPT;
 }
 
+static u_int8_t valid_new[] = { 
+	[ICMP_ECHO] = 1,
+	[ICMP_TIMESTAMP] = 1,
+	[ICMP_INFO_REQUEST] = 1,
+	[ICMP_ADDRESS] = 1 
+};
+
 /* Called when a new connection for this protocol found. */
 static int icmp_new(struct ip_conntrack *conntrack,
 		    const struct sk_buff *skb)
 {
-	static u_int8_t valid_new[]
-		= { [ICMP_ECHO] = 1,
-		    [ICMP_TIMESTAMP] = 1,
-		    [ICMP_INFO_REQUEST] = 1,
-		    [ICMP_ADDRESS] = 1 };
-
 	if (conntrack->tuplehash[0].tuple.dst.u.icmp.type >= sizeof(valid_new)
 	    || !valid_new[conntrack->tuplehash[0].tuple.dst.u.icmp.type]) {
 		/* Can't create a new ICMP `conn' with this. */
@@ -266,6 +267,17 @@
 	return icmp_error_message(skb, ctinfo, hooknum);
 }
 
+static int icmp_change_check_tuples(struct ip_conntrack_tuple *orig,
+				    struct ip_conntrack_tuple *reply)
+{
+	unsigned int type = orig->dst.u.icmp.type;
+
+	if (type >= sizeof(valid_new) || !valid_new[type])
+		return -EINVAL;
+
+	return 0;
+}
+
 struct ip_conntrack_protocol ip_conntrack_protocol_icmp =
 {
 	.proto 			= IPPROTO_ICMP,
@@ -277,4 +289,6 @@
 	.packet			= icmp_packet,
 	.new			= icmp_new,
 	.error			= icmp_error,
+	.change_check_tuples    = icmp_change_check_tuples,
+	.change_proto           = ip_ct_generic_change_proto,
 };
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_amanda.c.orig	2005-03-28 01:12:12.000000000 +0200
+++ linux-2.5/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-03-28 01:12:15.000000000 +0200
@@ -151,6 +151,7 @@
 	.mask = { .src = { .u = { 0xFFFF } },
 		 .dst = { .protonum = 0xFF },
 	},
+	.change_help = ip_ct_generic_change_help,
 };
 
 static void __exit fini(void)
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_sctp.c.orig	2005-03-28 01:06:12.000000000 +0200
+++ linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-03-28 01:06:27.000000000 +0200
@@ -499,6 +499,7 @@
 static struct ip_conntrack_protocol ip_conntrack_protocol_sctp = { 
 	.proto 		 = IPPROTO_SCTP, 
 	.name 		 = "sctp",
+	.lock		 = &sctp_lock,
 	.pkt_to_tuple 	 = sctp_pkt_to_tuple, 
 	.invert_tuple 	 = sctp_invert_tuple, 
 	.print_tuple 	 = sctp_print_tuple, 
@@ -506,7 +507,8 @@
 	.packet 	 = sctp_packet, 
 	.new 		 = sctp_new, 
 	.destroy 	 = NULL, 
-	.me 		 = THIS_MODULE 
+	.me 		 = THIS_MODULE,
+	.change_proto	 = ip_ct_generic_change_proto,
 };
 
 #ifdef CONFIG_SYSCTL
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_ftp.c.orig	2005-02-21 11:41:14.000000000 +0100
+++ linux-2.5/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-03-10 23:42:33.000000000 +0100
@@ -263,7 +263,8 @@
 }
 
 /* We don't update if it's older than what we have. */
-static void update_nl_seq(u16 nl_seq, struct ip_ct_ftp_master *info, int dir)
+static void update_nl_seq(u16 nl_seq, struct ip_ct_ftp_master *info, int dir,
+			  struct sk_buff *skb)
 {
 	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
 
@@ -277,10 +278,13 @@
 			oldest = i;
 	}
 
-	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER)
+	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] = nl_seq;
-	else if (oldest != NUM_SEQ_TO_REMEMBER)
+		ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
+	} else if (oldest != NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][oldest] = nl_seq;
+		ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
+	}
 }
 
 static int help(struct sk_buff **pskb,
@@ -440,7 +444,7 @@
 	/* Now if this ends in \n, update ftp info.  Seq may have been
 	 * adjusted by NAT code. */
 	if (ends_in_nl)
-		update_nl_seq(seq, ct_ftp_info,dir);
+		update_nl_seq(seq, ct_ftp_info,dir, *pskb);
  out:
 	UNLOCK_BH(&ip_ftp_lock);
 	return ret;
@@ -477,6 +481,8 @@
 		ftp[i].timeout = 5 * 60; /* 5 minutes */
 		ftp[i].me = THIS_MODULE;
 		ftp[i].help = help;
+		ftp[i].lock = &ip_ftp_lock;
+		ftp[i].change_help = ip_ct_generic_change_help;
 
 		tmpname = &ftp_names[i][0];
 		if (ports[i] == FTP_PORT)
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_irc.c.orig	2005-03-28 01:00:16.000000000 +0200
+++ linux-2.5/net/ipv4/netfilter/ip_conntrack_irc.c	2005-03-28 01:00:21.000000000 +0200
@@ -275,6 +275,8 @@
 		hlpr->timeout = dcc_timeout;
 		hlpr->me = THIS_MODULE;
 		hlpr->help = help;
+		hlpr->lock = &irc_buffer_lock;
+		hlpr->change_help = ip_ct_generic_change_help;
 
 		tmpname = &irc_names[i][0];
 		if (ports[i] == IRC_PORT)
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_tftp.c.orig	2005-03-28 01:00:55.000000000 +0200
+++ linux-2.5/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-03-28 01:02:33.000000000 +0200
@@ -134,6 +134,7 @@
 		tftp[i].timeout = 5 * 60; /* 5 minutes */
 		tftp[i].me = THIS_MODULE;
 		tftp[i].help = tftp_help;
+		tftp[i].change_help = ip_ct_generic_change_help;
 
 		tmpname = &tftp_names[i][0];
 		if (ports[i] == TFTP_PORT)
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_tcp.c.orig	2005-03-28 01:04:41.000000000 +0200
+++ linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-03-28 01:04:58.000000000 +0200
@@ -1069,6 +1069,7 @@
 {
 	.proto 			= IPPROTO_TCP,
 	.name 			= "tcp",
+	.lock			= &tcp_lock,
 	.pkt_to_tuple 		= tcp_pkt_to_tuple,
 	.invert_tuple 		= tcp_invert_tuple,
 	.print_tuple 		= tcp_print_tuple,
@@ -1076,4 +1077,5 @@
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
 	.error			= tcp_error,
+	.change_proto           = ip_ct_generic_change_proto
 };
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_udp.c.orig	2005-03-28 01:05:27.000000000 +0200
+++ linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-03-28 01:05:44.000000000 +0200
@@ -144,4 +144,5 @@
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error,
+	.change_proto           = ip_ct_generic_change_proto
 };
--- linux-2.5/include/linux/netfilter_ipv4/ip_conntrack.h.orig	2005-03-28 00:35:50.000000000 +0200
+++ linux-2.5/include/linux/netfilter_ipv4/ip_conntrack.h	2005-03-27 16:21:30.000000000 +0200
@@ -119,13 +119,7 @@
 	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
 };
 
-#ifdef __KERNEL__
-#include <linux/config.h>
 #include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
-#include <linux/bitops.h>
-#include <linux/compiler.h>
-#include <asm/atomic.h>
-
 #include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_icmp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_sctp.h>
@@ -154,6 +148,7 @@
 	struct ip_ct_irc_master ct_irc_info;
 };
 
+#ifdef __KERNEL__
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 #include <linux/netfilter_ipv4/ip_nat.h>
 #endif
@@ -188,6 +183,9 @@
            plus 1 for any connection(s) we are `master' for */
 	struct nf_conntrack ct_general;
 
+	/* Unique ID that identifies this conntrack*/
+	unsigned int id;
+
 	/* Have we seen traffic both ways yet? (bitset) */
 	unsigned long status;
 
@@ -249,6 +247,8 @@
 	/* Timer function; deletes the expectation. */
 	struct timer_list timeout;
 
+	atomic_t use;
+
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 	/* This is the original per-proto part, used to map the
 	 * expected connection the way the recipient expects. */
@@ -323,6 +323,27 @@
 ip_ct_iterate_cleanup(int (*iter)(struct ip_conntrack *i, void *data),
 		      void *data);
 
+extern struct ip_conntrack_helper *
+ip_ct_find_helper(const struct ip_conntrack_tuple *tuple);
+
+extern void ip_ct_remove_expectations(struct ip_conntrack *ct);
+
+extern struct ip_conntrack *ip_conntrack_alloc(struct ip_conntrack_tuple *,
+					       struct ip_conntrack_tuple *);
+
+extern inline void ip_conntrack_free(struct ip_conntrack *ct);
+
+extern inline void ip_conntrack_insert(struct ip_conntrack *ct,
+				       unsigned int hash,
+				       unsigned int repl_hash);
+
+extern struct ip_conntrack_expect *
+ip_conntrack_expect_find_get(const struct ip_conntrack_tuple *tuple);
+
+extern inline void ip_conntrack_expect_put(struct ip_conntrack_expect *exp);
+
+extern u_int32_t hash_conntrack(const struct ip_conntrack_tuple *tuple);
+
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int is_confirmed(struct ip_conntrack *ct)
 {
--- linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_amanda.h.orig	2005-03-28 01:09:12.000000000 +0200
+++ linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	2005-03-28 01:09:15.000000000 +0200
@@ -3,9 +3,11 @@
 /* AMANDA tracking. */
 
 struct ip_conntrack_expect;
+#ifdef __KERNEL__
 extern unsigned int (*ip_nat_amanda_hook)(struct sk_buff **pskb,
 					  enum ip_conntrack_info ctinfo,
 					  unsigned int matchoff,
 					  unsigned int matchlen,
 					  struct ip_conntrack_expect *exp);
+#endif
 #endif /* _IP_CONNTRACK_AMANDA_H */
--- linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_helper.h.orig	2005-03-28 01:14:00.000000000 +0200
+++ linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-03-28 01:14:08.000000000 +0200
@@ -9,6 +9,8 @@
 {	
 	struct list_head list; 		/* Internal use. */
 
+	spinlock_t *lock;		/* protect private info and buffer */
+
 	const char *name;		/* name of the module */
 	struct module *me;		/* pointer to self */
 	unsigned int max_expected;	/* Maximum number of concurrent 
@@ -24,6 +26,8 @@
 	int (*help)(struct sk_buff **pskb,
 		    struct ip_conntrack *ct,
 		    enum ip_conntrack_info conntrackinfo);
+
+	void (*change_help)(struct ip_conntrack *, union ip_conntrack_help *);
 };
 
 extern int ip_conntrack_helper_register(struct ip_conntrack_helper *);
@@ -38,4 +42,7 @@
 extern int ip_conntrack_expect_related(struct ip_conntrack_expect *exp);
 extern void ip_conntrack_unexpect_related(struct ip_conntrack_expect *exp);
 
+extern void ip_ct_generic_change_help(struct ip_conntrack *ct,
+				      union ip_conntrack_help *h);
+
 #endif /*_IP_CONNTRACK_HELPER_H*/
--- linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_ftp.h.orig	2005-03-28 01:08:31.000000000 +0200
+++ linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	2005-03-28 01:08:33.000000000 +0200
@@ -31,6 +31,7 @@
 
 struct ip_conntrack_expect;
 
+#ifdef __KERNEL__
 /* For NAT to hook in when we find a packet which describes what other
  * connection we should expect. */
 extern unsigned int (*ip_nat_ftp_hook)(struct sk_buff **pskb,
@@ -40,4 +41,5 @@
 				       unsigned int matchlen,
 				       struct ip_conntrack_expect *exp,
 				       u32 *seq);
+#endif
 #endif /* _IP_CONNTRACK_FTP_H */
--- linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_protocol.h.orig	2005-03-28 01:09:45.000000000 +0200
+++ linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-03-28 01:09:49.000000000 +0200
@@ -10,6 +10,8 @@
 	/* Protocol number. */
 	u_int8_t proto;
 
+	rwlock_t *lock;
+
 	/* Protocol name */
 	const char *name;
 
@@ -34,7 +36,7 @@
 
 	/* Returns verdict for packet, or -1 for invalid. */
 	int (*packet)(struct ip_conntrack *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo);
 
 	/* Called when a new connection for this protocol found;
@@ -47,6 +49,17 @@
 	int (*error)(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
 		     unsigned int hooknum);
 
+	/* check if tuples are valid for a new connection */
+	int (*change_check_tuples)(struct ip_conntrack_tuple *orig,
+				   struct ip_conntrack_tuple *reply);
+
+	/* check protocol data is valid */
+	int (*change_check_proto)(union ip_conntrack_proto *p);
+
+	/* change protocol info on behalf of ctnetlink */
+	void (*change_proto)(struct ip_conntrack *ct,
+			     union ip_conntrack_proto *p);
+	
 	/* Module (if any) which this is connected to. */
 	struct module *me;
 };
@@ -57,6 +70,8 @@
 /* Protocol registration. */
 extern int ip_conntrack_protocol_register(struct ip_conntrack_protocol *proto);
 extern void ip_conntrack_protocol_unregister(struct ip_conntrack_protocol *proto);
+extern void ip_ct_generic_change_proto(struct ip_conntrack *conntrack,
+				       union ip_conntrack_proto *p);
 
 static inline struct ip_conntrack_protocol *ip_ct_find_proto(u_int8_t protocol)
 {

--------------060501000504060609050404--
