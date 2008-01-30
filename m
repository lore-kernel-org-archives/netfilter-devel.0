From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 45/69]: nf_conntrack: naming unification
Date: Wed, 30 Jan 2008 21:18:03 +0100 (MET)
Message-ID: <20080130201801.29874.26627.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60769 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764023AbYA3USF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:05 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: naming unification

Rename all "conntrack" variables to "ct" for more consistency and avoiding
some overly long lines.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cd3672c2df98db3eb29b793ec537f8382e268dc8
tree f59812b460484dd55188e97ad22e9e0e48328d3f
parent 9dcd796f052a9383e55d81e7da5912e0a6cd4b19
author Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:09 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:09 +0100

 include/net/netfilter/nf_conntrack.h           |    4 -
 include/net/netfilter/nf_conntrack_l3proto.h   |    4 -
 include/net/netfilter/nf_conntrack_l4proto.h   |    6 -
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   12 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c          |   10 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    8 +
 net/netfilter/nf_conntrack_core.c              |   58 ++++-----
 net/netfilter/nf_conntrack_proto_generic.c     |    6 -
 net/netfilter/nf_conntrack_proto_sctp.c        |    2 
 net/netfilter/nf_conntrack_proto_tcp.c         |  150 ++++++++++++------------
 net/netfilter/nf_conntrack_proto_udp.c         |   13 +-
 net/netfilter/nf_conntrack_proto_udplite.c     |   13 +-
 net/netfilter/nf_conntrack_standalone.c        |   38 +++---
 13 files changed, 157 insertions(+), 167 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 14e0cc8..bda78a2 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -145,7 +145,7 @@ nf_ct_tuplehash_to_ctrack(const struct nf_conntrack_tuple_hash *hash)
 
 /* Alter reply tuple (maybe alter helper). */
 extern void
-nf_conntrack_alter_reply(struct nf_conn *conntrack,
+nf_conntrack_alter_reply(struct nf_conn *ct,
 			 const struct nf_conntrack_tuple *newreply);
 
 /* Is this tuple taken? (ignoring any belonging to the given
@@ -218,7 +218,7 @@ static inline void nf_ct_refresh(struct nf_conn *ct,
 /* Update TCP window tracking data when NAT mangles the packet */
 extern void nf_conntrack_tcp_update(struct sk_buff *skb,
 				    unsigned int dataoff,
-				    struct nf_conn *conntrack,
+				    struct nf_conn *ct,
 				    int dir);
 
 /* Fake conntrack entry for untracked connections */
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index d5526bc..b886e3a 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -43,7 +43,7 @@ struct nf_conntrack_l3proto
 			   const struct nf_conntrack_tuple *);
 
 	/* Returns verdict for packet, or -1 for invalid. */
-	int (*packet)(struct nf_conn *conntrack,
+	int (*packet)(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo);
 
@@ -51,7 +51,7 @@ struct nf_conntrack_l3proto
 	 * Called when a new connection for this protocol found;
 	 * returns TRUE if it's OK.  If so, packet() called next.
 	 */
-	int (*new)(struct nf_conn *conntrack, const struct sk_buff *skb);
+	int (*new)(struct nf_conn *ct, const struct sk_buff *skb);
 
 	/*
 	 * Called before tracking. 
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 84892cc..efc16ec 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -36,7 +36,7 @@ struct nf_conntrack_l4proto
 			    const struct nf_conntrack_tuple *orig);
 
 	/* Returns verdict for packet, or -1 for invalid. */
-	int (*packet)(struct nf_conn *conntrack,
+	int (*packet)(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
@@ -45,11 +45,11 @@ struct nf_conntrack_l4proto
 
 	/* Called when a new connection for this protocol found;
 	 * returns TRUE if it's OK.  If so, packet() called next. */
-	int (*new)(struct nf_conn *conntrack, const struct sk_buff *skb,
+	int (*new)(struct nf_conn *ct, const struct sk_buff *skb,
 		   unsigned int dataoff);
 
 	/* Called when a conntrack entry is destroyed */
-	void (*destroy)(struct nf_conn *conntrack);
+	void (*destroy)(struct nf_conn *ct);
 
 	int (*error)(struct sk_buff *skb, unsigned int dataoff,
 		     enum ip_conntrack_info *ctinfo,
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 4004a04..17217f4 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -100,7 +100,7 @@ static int icmp_packet(struct nf_conn *ct,
 }
 
 /* Called when a new connection for this protocol found. */
-static int icmp_new(struct nf_conn *conntrack,
+static int icmp_new(struct nf_conn *ct,
 		    const struct sk_buff *skb, unsigned int dataoff)
 {
 	static const u_int8_t valid_new[] = {
@@ -110,15 +110,15 @@ static int icmp_new(struct nf_conn *conntrack,
 		[ICMP_ADDRESS] = 1
 	};
 
-	if (conntrack->tuplehash[0].tuple.dst.u.icmp.type >= sizeof(valid_new)
-	    || !valid_new[conntrack->tuplehash[0].tuple.dst.u.icmp.type]) {
+	if (ct->tuplehash[0].tuple.dst.u.icmp.type >= sizeof(valid_new)
+	    || !valid_new[ct->tuplehash[0].tuple.dst.u.icmp.type]) {
 		/* Can't create a new ICMP `conn' with this. */
 		pr_debug("icmp: can't create new conn with type %u\n",
-			 conntrack->tuplehash[0].tuple.dst.u.icmp.type);
-		NF_CT_DUMP_TUPLE(&conntrack->tuplehash[0].tuple);
+			 ct->tuplehash[0].tuple.dst.u.icmp.type);
+		NF_CT_DUMP_TUPLE(&ct->tuplehash[0].tuple);
 		return 0;
 	}
-	atomic_set(&conntrack->proto.icmp.count, 0);
+	atomic_set(&ct->proto.icmp.count, 0);
 	return 1;
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index c9dbd55..b887ebb 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -59,7 +59,7 @@ static int
 gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 const struct nf_nat_range *range,
 		 enum nf_nat_manip_type maniptype,
-		 const struct nf_conn *conntrack)
+		 const struct nf_conn *ct)
 {
 	static u_int16_t key;
 	__be16 *keyptr;
@@ -67,7 +67,7 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 
 	/* If there is no master conntrack we are not PPTP,
 	   do not change tuples */
-	if (!conntrack->master)
+	if (!ct->master)
 		return 0;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
@@ -76,7 +76,7 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 		keyptr = &tuple->dst.u.gre.key;
 
 	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)) {
-		pr_debug("%p: NATing GRE PPTP\n", conntrack);
+		pr_debug("%p: NATing GRE PPTP\n", ct);
 		min = 1;
 		range_size = 0xffff;
 	} else {
@@ -88,11 +88,11 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 
 	for (i = 0; i < range_size; i++, key++) {
 		*keyptr = htons(min + key % range_size);
-		if (!nf_nat_used_tuple(tuple, conntrack))
+		if (!nf_nat_used_tuple(tuple, ct))
 			return 1;
 	}
 
-	pr_debug("%p: no NAT mapping\n", conntrack);
+	pr_debug("%p: no NAT mapping\n", ct);
 	return 0;
 }
 
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index da924c6..430db1d 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -101,7 +101,7 @@ static int icmpv6_packet(struct nf_conn *ct,
 }
 
 /* Called when a new connection for this protocol found. */
-static int icmpv6_new(struct nf_conn *conntrack,
+static int icmpv6_new(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff)
 {
@@ -109,16 +109,16 @@ static int icmpv6_new(struct nf_conn *conntrack,
 		[ICMPV6_ECHO_REQUEST - 128] = 1,
 		[ICMPV6_NI_QUERY - 128] = 1
 	};
-	int type = conntrack->tuplehash[0].tuple.dst.u.icmp.type - 128;
+	int type = ct->tuplehash[0].tuple.dst.u.icmp.type - 128;
 
 	if (type < 0 || type >= sizeof(valid_new) || !valid_new[type]) {
 		/* Can't create a new ICMPv6 `conn' with this. */
 		pr_debug("icmpv6: can't create new conn with type %u\n",
 			 type + 128);
-		NF_CT_DUMP_TUPLE(&conntrack->tuplehash[0].tuple);
+		NF_CT_DUMP_TUPLE(&ct->tuplehash[0].tuple);
 		return 0;
 	}
-	atomic_set(&conntrack->proto.icmp.count, 0);
+	atomic_set(&ct->proto.icmp.count, 0);
 	return 1;
 }
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index fabc9eb..0db7d1d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -462,7 +462,7 @@ static noinline int early_drop(unsigned int hash)
 struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 				   const struct nf_conntrack_tuple *repl)
 {
-	struct nf_conn *conntrack = NULL;
+	struct nf_conn *ct = NULL;
 
 	if (unlikely(!nf_conntrack_hash_rnd_initted)) {
 		get_random_bytes(&nf_conntrack_hash_rnd, 4);
@@ -485,22 +485,21 @@ struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 		}
 	}
 
-	conntrack = kmem_cache_zalloc(nf_conntrack_cachep, GFP_ATOMIC);
-	if (conntrack == NULL) {
+	ct = kmem_cache_zalloc(nf_conntrack_cachep, GFP_ATOMIC);
+	if (ct == NULL) {
 		pr_debug("nf_conntrack_alloc: Can't alloc conntrack.\n");
 		atomic_dec(&nf_conntrack_count);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	atomic_set(&conntrack->ct_general.use, 1);
-	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
-	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *repl;
+	atomic_set(&ct->ct_general.use, 1);
+	ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
+	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *repl;
 	/* Don't set timer yet: wait for confirmation */
-	setup_timer(&conntrack->timeout, death_by_timeout,
-		    (unsigned long)conntrack);
-	INIT_RCU_HEAD(&conntrack->rcu);
+	setup_timer(&ct->timeout, death_by_timeout, (unsigned long)ct);
+	INIT_RCU_HEAD(&ct->rcu);
 
-	return conntrack;
+	return ct;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alloc);
 
@@ -513,9 +512,9 @@ static void nf_conntrack_free_rcu(struct rcu_head *head)
 	atomic_dec(&nf_conntrack_count);
 }
 
-void nf_conntrack_free(struct nf_conn *conntrack)
+void nf_conntrack_free(struct nf_conn *ct)
 {
-	call_rcu(&conntrack->rcu, nf_conntrack_free_rcu);
+	call_rcu(&ct->rcu, nf_conntrack_free_rcu);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_free);
 
@@ -528,7 +527,7 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 	       struct sk_buff *skb,
 	       unsigned int dataoff)
 {
-	struct nf_conn *conntrack;
+	struct nf_conn *ct;
 	struct nf_conn_help *help;
 	struct nf_conntrack_tuple repl_tuple;
 	struct nf_conntrack_expect *exp;
@@ -538,14 +537,14 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 		return NULL;
 	}
 
-	conntrack = nf_conntrack_alloc(tuple, &repl_tuple);
-	if (conntrack == NULL || IS_ERR(conntrack)) {
+	ct = nf_conntrack_alloc(tuple, &repl_tuple);
+	if (ct == NULL || IS_ERR(ct)) {
 		pr_debug("Can't allocate conntrack.\n");
-		return (struct nf_conntrack_tuple_hash *)conntrack;
+		return (struct nf_conntrack_tuple_hash *)ct;
 	}
 
-	if (!l4proto->new(conntrack, skb, dataoff)) {
-		nf_conntrack_free(conntrack);
+	if (!l4proto->new(ct, skb, dataoff)) {
+		nf_conntrack_free(ct);
 		pr_debug("init conntrack: can't track with proto module\n");
 		return NULL;
 	}
@@ -554,30 +553,30 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 	exp = nf_ct_find_expectation(tuple);
 	if (exp) {
 		pr_debug("conntrack: expectation arrives ct=%p exp=%p\n",
-			 conntrack, exp);
+			 ct, exp);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
-		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
-		conntrack->master = exp->master;
+		__set_bit(IPS_EXPECTED_BIT, &ct->status);
+		ct->master = exp->master;
 		if (exp->helper) {
-			help = nf_ct_helper_ext_add(conntrack, GFP_ATOMIC);
+			help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 			if (help)
 				rcu_assign_pointer(help->helper, exp->helper);
 		}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-		conntrack->mark = exp->master->mark;
+		ct->mark = exp->master->mark;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-		conntrack->secmark = exp->master->secmark;
+		ct->secmark = exp->master->secmark;
 #endif
-		nf_conntrack_get(&conntrack->master->ct_general);
+		nf_conntrack_get(&ct->master->ct_general);
 		NF_CT_STAT_INC(expect_new);
 	} else {
 		struct nf_conntrack_helper *helper;
 
 		helper = __nf_ct_helper_find(&repl_tuple);
 		if (helper) {
-			help = nf_ct_helper_ext_add(conntrack, GFP_ATOMIC);
+			help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 			if (help)
 				rcu_assign_pointer(help->helper, helper);
 		}
@@ -585,18 +584,17 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 	}
 
 	/* Overload tuple linked list to put us in unconfirmed list. */
-	hlist_add_head(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].hnode,
-		       &unconfirmed);
+	hlist_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode, &unconfirmed);
 
 	spin_unlock_bh(&nf_conntrack_lock);
 
 	if (exp) {
 		if (exp->expectfn)
-			exp->expectfn(conntrack, exp);
+			exp->expectfn(ct, exp);
 		nf_ct_expect_put(exp);
 	}
 
-	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
+	return &ct->tuplehash[IP_CT_DIR_ORIGINAL];
 }
 
 /* On success, returns conntrack ptr, sets skb->nfct and ctinfo */
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 22c5dcb..5545891 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -41,19 +41,19 @@ static int generic_print_tuple(struct seq_file *s,
 }
 
 /* Returns verdict for packet, or -1 for invalid. */
-static int packet(struct nf_conn *conntrack,
+static int packet(struct nf_conn *ct,
 		  const struct sk_buff *skb,
 		  unsigned int dataoff,
 		  enum ip_conntrack_info ctinfo,
 		  int pf,
 		  unsigned int hooknum)
 {
-	nf_ct_refresh_acct(conntrack, ctinfo, skb, nf_ct_generic_timeout);
+	nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_generic_timeout);
 	return NF_ACCEPT;
 }
 
 /* Called when a new connection for this protocol found. */
-static int new(struct nf_conn *conntrack, const struct sk_buff *skb,
+static int new(struct nf_conn *ct, const struct sk_buff *skb,
 	       unsigned int dataoff)
 {
 	return 1;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7017b16..f9a0837 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -25,7 +25,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 
-/* Protects conntrack->proto.sctp */
+/* Protects ct->proto.sctp */
 static DEFINE_RWLOCK(sctp_lock);
 
 /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 8e22075..9807af6 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -26,7 +26,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_log.h>
 
-/* Protects conntrack->proto.tcp */
+/* Protects ct->proto.tcp */
 static DEFINE_RWLOCK(tcp_lock);
 
 /* "Be conservative in what you do,
@@ -292,13 +292,12 @@ static int tcp_print_tuple(struct seq_file *s,
 }
 
 /* Print out the private part of the conntrack. */
-static int tcp_print_conntrack(struct seq_file *s,
-			       const struct nf_conn *conntrack)
+static int tcp_print_conntrack(struct seq_file *s, const struct nf_conn *ct)
 {
 	enum tcp_conntrack state;
 
 	read_lock_bh(&tcp_lock);
-	state = conntrack->proto.tcp.state;
+	state = ct->proto.tcp.state;
 	read_unlock_bh(&tcp_lock);
 
 	return seq_printf(s, "%s ", tcp_conntrack_names[state]);
@@ -689,12 +688,12 @@ static int tcp_in_window(struct nf_conn *ct,
 /* Caller must linearize skb at tcp header. */
 void nf_conntrack_tcp_update(struct sk_buff *skb,
 			     unsigned int dataoff,
-			     struct nf_conn *conntrack,
+			     struct nf_conn *ct,
 			     int dir)
 {
 	struct tcphdr *tcph = (void *)skb->data + dataoff;
-	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[dir];
-	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[!dir];
+	struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[dir];
+	struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[!dir];
 	__u32 end;
 
 	end = segment_seq_plus_len(ntohl(tcph->seq), skb->len, dataoff, tcph);
@@ -703,9 +702,9 @@ void nf_conntrack_tcp_update(struct sk_buff *skb,
 	/*
 	 * We have to worry for the ack in the reply packet only...
 	 */
-	if (after(end, conntrack->proto.tcp.seen[dir].td_end))
-		conntrack->proto.tcp.seen[dir].td_end = end;
-	conntrack->proto.tcp.last_end = end;
+	if (after(end, ct->proto.tcp.seen[dir].td_end))
+		ct->proto.tcp.seen[dir].td_end = end;
+	ct->proto.tcp.last_end = end;
 	write_unlock_bh(&tcp_lock);
 	pr_debug("tcp_update: sender end=%u maxend=%u maxwin=%u scale=%i "
 		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
@@ -794,7 +793,7 @@ static int tcp_error(struct sk_buff *skb,
 }
 
 /* Returns verdict for packet, or -1 for invalid. */
-static int tcp_packet(struct nf_conn *conntrack,
+static int tcp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
@@ -812,26 +811,24 @@ static int tcp_packet(struct nf_conn *conntrack,
 	BUG_ON(th == NULL);
 
 	write_lock_bh(&tcp_lock);
-	old_state = conntrack->proto.tcp.state;
+	old_state = ct->proto.tcp.state;
 	dir = CTINFO2DIR(ctinfo);
 	index = get_conntrack_index(th);
 	new_state = tcp_conntracks[dir][index][old_state];
-	tuple = &conntrack->tuplehash[dir].tuple;
+	tuple = &ct->tuplehash[dir].tuple;
 
 	switch (new_state) {
 	case TCP_CONNTRACK_SYN_SENT:
 		if (old_state < TCP_CONNTRACK_TIME_WAIT)
 			break;
-		if ((conntrack->proto.tcp.seen[!dir].flags &
-			IP_CT_TCP_FLAG_CLOSE_INIT)
-		    || (conntrack->proto.tcp.last_dir == dir
-		        && conntrack->proto.tcp.last_index == TCP_RST_SET)) {
+		if ((ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_CLOSE_INIT)
+		    || (ct->proto.tcp.last_dir == dir
+		        && ct->proto.tcp.last_index == TCP_RST_SET)) {
 			/* Attempt to reopen a closed/aborted connection.
 			 * Delete this connection and look up again. */
 			write_unlock_bh(&tcp_lock);
-			if (del_timer(&conntrack->timeout))
-				conntrack->timeout.function((unsigned long)
-							    conntrack);
+			if (del_timer(&ct->timeout))
+				ct->timeout.function((unsigned long)ct);
 			return -NF_REPEAT;
 		}
 		/* Fall through */
@@ -843,10 +840,9 @@ static int tcp_packet(struct nf_conn *conntrack,
 		 * c) ACK in reply direction after initial SYN in original.
 		 */
 		if (index == TCP_SYNACK_SET
-		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
-		    && conntrack->proto.tcp.last_dir != dir
-		    && ntohl(th->ack_seq) ==
-			     conntrack->proto.tcp.last_end) {
+		    && ct->proto.tcp.last_index == TCP_SYN_SET
+		    && ct->proto.tcp.last_dir != dir
+		    && ntohl(th->ack_seq) == ct->proto.tcp.last_end) {
 			/* This SYN/ACK acknowledges a SYN that we earlier
 			 * ignored as invalid. This means that the client and
 			 * the server are both in sync, while the firewall is
@@ -858,15 +854,14 @@ static int tcp_packet(struct nf_conn *conntrack,
 			if (LOG_INVALID(IPPROTO_TCP))
 				nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
 					  "nf_ct_tcp: killing out of sync session ");
-			if (del_timer(&conntrack->timeout))
-				conntrack->timeout.function((unsigned long)
-							    conntrack);
+			if (del_timer(&ct->timeout))
+				ct->timeout.function((unsigned long)ct);
 			return -NF_DROP;
 		}
-		conntrack->proto.tcp.last_index = index;
-		conntrack->proto.tcp.last_dir = dir;
-		conntrack->proto.tcp.last_seq = ntohl(th->seq);
-		conntrack->proto.tcp.last_end =
+		ct->proto.tcp.last_index = index;
+		ct->proto.tcp.last_dir = dir;
+		ct->proto.tcp.last_seq = ntohl(th->seq);
+		ct->proto.tcp.last_end =
 		    segment_seq_plus_len(ntohl(th->seq), skb->len, dataoff, th);
 
 		write_unlock_bh(&tcp_lock);
@@ -885,11 +880,11 @@ static int tcp_packet(struct nf_conn *conntrack,
 		return -NF_ACCEPT;
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
-		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
-			 && conntrack->proto.tcp.last_index == TCP_SYN_SET)
-			|| (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
-			    && conntrack->proto.tcp.last_index == TCP_ACK_SET))
-		    && ntohl(th->ack_seq) == conntrack->proto.tcp.last_end) {
+		    && ((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)
+			 && ct->proto.tcp.last_index == TCP_SYN_SET)
+			|| (!test_bit(IPS_ASSURED_BIT, &ct->status)
+			    && ct->proto.tcp.last_index == TCP_ACK_SET))
+		    && ntohl(th->ack_seq) == ct->proto.tcp.last_end) {
 			/* RST sent to invalid SYN or ACK we had let through
 			 * at a) and c) above:
 			 *
@@ -907,15 +902,15 @@ static int tcp_packet(struct nf_conn *conntrack,
 		break;
 	}
 
-	if (!tcp_in_window(conntrack, &conntrack->proto.tcp, dir, index,
+	if (!tcp_in_window(ct, &ct->proto.tcp, dir, index,
 			   skb, dataoff, th, pf)) {
 		write_unlock_bh(&tcp_lock);
 		return -NF_ACCEPT;
 	}
      in_window:
 	/* From now on we have got in-window packets */
-	conntrack->proto.tcp.last_index = index;
-	conntrack->proto.tcp.last_dir = dir;
+	ct->proto.tcp.last_index = index;
+	ct->proto.tcp.last_dir = dir;
 
 	pr_debug("tcp_conntracks: ");
 	NF_CT_DUMP_TUPLE(tuple);
@@ -924,12 +919,12 @@ static int tcp_packet(struct nf_conn *conntrack,
 		 (th->fin ? 1 : 0), (th->rst ? 1 : 0),
 		 old_state, new_state);
 
-	conntrack->proto.tcp.state = new_state;
+	ct->proto.tcp.state = new_state;
 	if (old_state != new_state
 	    && (new_state == TCP_CONNTRACK_FIN_WAIT
 		|| new_state == TCP_CONNTRACK_CLOSE))
-		conntrack->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
-	timeout = conntrack->proto.tcp.retrans >= nf_ct_tcp_max_retrans
+		ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
+	timeout = ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans
 		  && tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
 		  ? nf_ct_tcp_timeout_max_retrans : tcp_timeouts[new_state];
 	write_unlock_bh(&tcp_lock);
@@ -938,41 +933,40 @@ static int tcp_packet(struct nf_conn *conntrack,
 	if (new_state != old_state)
 		nf_conntrack_event_cache(IPCT_PROTOINFO, skb);
 
-	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
+	if (!test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		/* If only reply is a RST, we can consider ourselves not to
 		   have an established connection: this is a fairly common
 		   problem case, so we can delete the conntrack
 		   immediately.  --RR */
 		if (th->rst) {
-			if (del_timer(&conntrack->timeout))
-				conntrack->timeout.function((unsigned long)
-							    conntrack);
+			if (del_timer(&ct->timeout))
+				ct->timeout.function((unsigned long)ct);
 			return NF_ACCEPT;
 		}
-	} else if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
+	} else if (!test_bit(IPS_ASSURED_BIT, &ct->status)
 		   && (old_state == TCP_CONNTRACK_SYN_RECV
 		       || old_state == TCP_CONNTRACK_ESTABLISHED)
 		   && new_state == TCP_CONNTRACK_ESTABLISHED) {
 		/* Set ASSURED if we see see valid ack in ESTABLISHED
 		   after SYN_RECV or a valid answer for a picked up
 		   connection. */
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		set_bit(IPS_ASSURED_BIT, &ct->status);
 		nf_conntrack_event_cache(IPCT_STATUS, skb);
 	}
-	nf_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
+	nf_ct_refresh_acct(ct, ctinfo, skb, timeout);
 
 	return NF_ACCEPT;
 }
 
 /* Called when a new connection for this protocol found. */
-static int tcp_new(struct nf_conn *conntrack,
+static int tcp_new(struct nf_conn *ct,
 		   const struct sk_buff *skb,
 		   unsigned int dataoff)
 {
 	enum tcp_conntrack new_state;
 	struct tcphdr *th, _tcph;
-	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[0];
-	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[1];
+	struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[0];
+	struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[1];
 
 	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
 	BUG_ON(th == NULL);
@@ -990,17 +984,17 @@ static int tcp_new(struct nf_conn *conntrack,
 
 	if (new_state == TCP_CONNTRACK_SYN_SENT) {
 		/* SYN packet */
-		conntrack->proto.tcp.seen[0].td_end =
+		ct->proto.tcp.seen[0].td_end =
 			segment_seq_plus_len(ntohl(th->seq), skb->len,
 					     dataoff, th);
-		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
-		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
-			conntrack->proto.tcp.seen[0].td_maxwin = 1;
-		conntrack->proto.tcp.seen[0].td_maxend =
-			conntrack->proto.tcp.seen[0].td_end;
-
-		tcp_options(skb, dataoff, th, &conntrack->proto.tcp.seen[0]);
-		conntrack->proto.tcp.seen[1].flags = 0;
+		ct->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
+		if (ct->proto.tcp.seen[0].td_maxwin == 0)
+			ct->proto.tcp.seen[0].td_maxwin = 1;
+		ct->proto.tcp.seen[0].td_maxend =
+			ct->proto.tcp.seen[0].td_end;
+
+		tcp_options(skb, dataoff, th, &ct->proto.tcp.seen[0]);
+		ct->proto.tcp.seen[1].flags = 0;
 	} else if (nf_ct_tcp_loose == 0) {
 		/* Don't try to pick up connections. */
 		return 0;
@@ -1010,32 +1004,32 @@ static int tcp_new(struct nf_conn *conntrack,
 		 * its history is lost for us.
 		 * Let's try to use the data from the packet.
 		 */
-		conntrack->proto.tcp.seen[0].td_end =
+		ct->proto.tcp.seen[0].td_end =
 			segment_seq_plus_len(ntohl(th->seq), skb->len,
 					     dataoff, th);
-		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
-		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
-			conntrack->proto.tcp.seen[0].td_maxwin = 1;
-		conntrack->proto.tcp.seen[0].td_maxend =
-			conntrack->proto.tcp.seen[0].td_end +
-			conntrack->proto.tcp.seen[0].td_maxwin;
-		conntrack->proto.tcp.seen[0].td_scale = 0;
+		ct->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
+		if (ct->proto.tcp.seen[0].td_maxwin == 0)
+			ct->proto.tcp.seen[0].td_maxwin = 1;
+		ct->proto.tcp.seen[0].td_maxend =
+			ct->proto.tcp.seen[0].td_end +
+			ct->proto.tcp.seen[0].td_maxwin;
+		ct->proto.tcp.seen[0].td_scale = 0;
 
 		/* We assume SACK and liberal window checking to handle
 		 * window scaling */
-		conntrack->proto.tcp.seen[0].flags =
-		conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM |
-						     IP_CT_TCP_FLAG_BE_LIBERAL;
+		ct->proto.tcp.seen[0].flags =
+		ct->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM |
+					      IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
 
-	conntrack->proto.tcp.seen[1].td_end = 0;
-	conntrack->proto.tcp.seen[1].td_maxend = 0;
-	conntrack->proto.tcp.seen[1].td_maxwin = 1;
-	conntrack->proto.tcp.seen[1].td_scale = 0;
+	ct->proto.tcp.seen[1].td_end = 0;
+	ct->proto.tcp.seen[1].td_maxend = 0;
+	ct->proto.tcp.seen[1].td_maxwin = 1;
+	ct->proto.tcp.seen[1].td_scale = 0;
 
 	/* tcp_packet will set them */
-	conntrack->proto.tcp.state = TCP_CONNTRACK_NONE;
-	conntrack->proto.tcp.last_index = TCP_NONE_SET;
+	ct->proto.tcp.state = TCP_CONNTRACK_NONE;
+	ct->proto.tcp.last_index = TCP_NONE_SET;
 
 	pr_debug("tcp_new: sender end=%u maxend=%u maxwin=%u scale=%i "
 		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 3848754..4c1e67e 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -61,7 +61,7 @@ static int udp_print_tuple(struct seq_file *s,
 }
 
 /* Returns verdict for packet, and may modify conntracktype */
-static int udp_packet(struct nf_conn *conntrack,
+static int udp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
@@ -70,20 +70,19 @@ static int udp_packet(struct nf_conn *conntrack,
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
-	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
-		nf_ct_refresh_acct(conntrack, ctinfo, skb,
-				   nf_ct_udp_timeout_stream);
+	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
-		if (!test_and_set_bit(IPS_ASSURED_BIT, &conntrack->status))
+		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_STATUS, skb);
 	} else
-		nf_ct_refresh_acct(conntrack, ctinfo, skb, nf_ct_udp_timeout);
+		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_udp_timeout);
 
 	return NF_ACCEPT;
 }
 
 /* Called when a new connection for this protocol found. */
-static int udp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
+static int udp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		   unsigned int dataoff)
 {
 	return 1;
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 070056d..d9e1532 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -60,7 +60,7 @@ static int udplite_print_tuple(struct seq_file *s,
 }
 
 /* Returns verdict for packet, and may modify conntracktype */
-static int udplite_packet(struct nf_conn *conntrack,
+static int udplite_packet(struct nf_conn *ct,
 			  const struct sk_buff *skb,
 			  unsigned int dataoff,
 			  enum ip_conntrack_info ctinfo,
@@ -69,21 +69,20 @@ static int udplite_packet(struct nf_conn *conntrack,
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
-	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
-		nf_ct_refresh_acct(conntrack, ctinfo, skb,
+	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		nf_ct_refresh_acct(ct, ctinfo, skb,
 				   nf_ct_udplite_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
-		if (!test_and_set_bit(IPS_ASSURED_BIT, &conntrack->status))
+		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_STATUS, skb);
 	} else
-		nf_ct_refresh_acct(conntrack, ctinfo, skb,
-				   nf_ct_udplite_timeout);
+		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_udplite_timeout);
 
 	return NF_ACCEPT;
 }
 
 /* Called when a new connection for this protocol found. */
-static int udplite_new(struct nf_conn *conntrack, const struct sk_buff *skb,
+static int udplite_new(struct nf_conn *ct, const struct sk_buff *skb,
 		       unsigned int dataoff)
 {
 	return 1;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 98f0cd3..278b35e 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -117,71 +117,71 @@ static void ct_seq_stop(struct seq_file *s, void *v)
 static int ct_seq_show(struct seq_file *s, void *v)
 {
 	const struct nf_conntrack_tuple_hash *hash = v;
-	const struct nf_conn *conntrack = nf_ct_tuplehash_to_ctrack(hash);
+	const struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(hash);
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
 
-	NF_CT_ASSERT(conntrack);
+	NF_CT_ASSERT(ct);
 
 	/* we only want to print DIR_ORIGINAL */
 	if (NF_CT_DIRECTION(hash))
 		return 0;
 
-	l3proto = __nf_ct_l3proto_find(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+	l3proto = __nf_ct_l3proto_find(ct->tuplehash[IP_CT_DIR_ORIGINAL]
 				       .tuple.src.l3num);
 
 	NF_CT_ASSERT(l3proto);
-	l4proto = __nf_ct_l4proto_find(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+	l4proto = __nf_ct_l4proto_find(ct->tuplehash[IP_CT_DIR_ORIGINAL]
 				   .tuple.src.l3num,
-				   conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+				   ct->tuplehash[IP_CT_DIR_ORIGINAL]
 				   .tuple.dst.protonum);
 	NF_CT_ASSERT(l4proto);
 
 	if (seq_printf(s, "%-8s %u %-8s %u %ld ",
 		       l3proto->name,
-		       conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num,
+		       ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num,
 		       l4proto->name,
-		       conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
-		       timer_pending(&conntrack->timeout)
-		       ? (long)(conntrack->timeout.expires - jiffies)/HZ : 0) != 0)
+		       ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
+		       timer_pending(&ct->timeout)
+		       ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
 		return -ENOSPC;
 
-	if (l4proto->print_conntrack && l4proto->print_conntrack(s, conntrack))
+	if (l4proto->print_conntrack && l4proto->print_conntrack(s, ct))
 		return -ENOSPC;
 
-	if (print_tuple(s, &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 			l3proto, l4proto))
 		return -ENOSPC;
 
-	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_ORIGINAL]))
+	if (seq_print_counters(s, &ct->counters[IP_CT_DIR_ORIGINAL]))
 		return -ENOSPC;
 
-	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)))
+	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
 		if (seq_printf(s, "[UNREPLIED] "))
 			return -ENOSPC;
 
-	if (print_tuple(s, &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple,
+	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 			l3proto, l4proto))
 		return -ENOSPC;
 
-	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_REPLY]))
+	if (seq_print_counters(s, &ct->counters[IP_CT_DIR_REPLY]))
 		return -ENOSPC;
 
-	if (test_bit(IPS_ASSURED_BIT, &conntrack->status))
+	if (test_bit(IPS_ASSURED_BIT, &ct->status))
 		if (seq_printf(s, "[ASSURED] "))
 			return -ENOSPC;
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (seq_printf(s, "mark=%u ", conntrack->mark))
+	if (seq_printf(s, "mark=%u ", ct->mark))
 		return -ENOSPC;
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-	if (seq_printf(s, "secmark=%u ", conntrack->secmark))
+	if (seq_printf(s, "secmark=%u ", ct->secmark))
 		return -ENOSPC;
 #endif
 
-	if (seq_printf(s, "use=%u\n", atomic_read(&conntrack->ct_general.use)))
+	if (seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use)))
 		return -ENOSPC;
 
 	return 0;
