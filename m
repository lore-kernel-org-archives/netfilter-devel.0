From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 7/9]: changes names in to avoid conflicts
Date: Tue, 22 Mar 2005 23:00:11 +0900 (JST)
Message-ID: <200503221400.j2ME0CT7022839@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Mar_22_23:00:11_2005_505)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
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

----Next_Part(Tue_Mar_22_23:00:11_2005_505)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch changes the names in nf_conntrack{_core}.h to avoid name conflicts
in the case that matches/targets includes both of {ip,nf}_conntrack.h.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Tue_Mar_22_23:00:11_2005_505)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="07-symbols.patch"

diff -Nur linux-2.6.11-nfct-defs-sctp/include/linux/netfilter/nf_conntrack.h linux-2.6.11-nfct-symbols/include/linux/netfilter/nf_conntrack.h
--- linux-2.6.11-nfct-defs-sctp/include/linux/netfilter/nf_conntrack.h	2005-03-22 17:39:17.000000000 +0900
+++ linux-2.6.11-nfct-symbols/include/linux/netfilter/nf_conntrack.h	2005-03-22 18:53:36.000000000 +0900
@@ -146,7 +146,7 @@
 };
 
 static inline struct nf_conn *
-tuplehash_to_ctrack(const struct nf_conntrack_tuple_hash *hash)
+nf_ct_tuplehash_to_ctrack(const struct nf_conntrack_tuple_hash *hash)
 {
 	return container_of(hash, struct nf_conn,
 			    tuplehash[hash->tuple.dst.dir]);
@@ -209,7 +209,7 @@
 nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data), void *data);
 
 /* It's confirmed if it is, or has been in the hash table. */
-static inline int is_confirmed(struct nf_conn *ct)
+static inline int nf_ct_is_confirmed(struct nf_conn *ct)
 {
 	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
diff -Nur linux-2.6.11-nfct-defs-sctp/include/linux/netfilter/nf_conntrack_core.h linux-2.6.11-nfct-symbols/include/linux/netfilter/nf_conntrack_core.h
--- linux-2.6.11-nfct-defs-sctp/include/linux/netfilter/nf_conntrack_core.h	2005-03-22 17:39:01.000000000 +0900
+++ linux-2.6.11-nfct-symbols/include/linux/netfilter/nf_conntrack_core.h	2005-03-22 18:53:36.000000000 +0900
@@ -59,7 +59,7 @@
 static inline int nf_conntrack_confirm(struct sk_buff **pskb)
 {
 	if ((*pskb)->nfct
-	    && !is_confirmed((struct nf_conn *)(*pskb)->nfct))
+	    && !nf_ct_is_confirmed((struct nf_conn *)(*pskb)->nfct))
 		return __nf_conntrack_confirm(pskb);
 	return NF_ACCEPT;
 }
diff -Nur linux-2.6.11-nfct-defs-sctp/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c linux-2.6.11-nfct-symbols/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- linux-2.6.11-nfct-defs-sctp/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-03-22 17:39:01.000000000 +0900
+++ linux-2.6.11-nfct-symbols/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-03-22 18:53:36.000000000 +0900
@@ -369,7 +369,7 @@
 	h = nf_conntrack_find_get(&tuple, NULL);
 	if (h) {
 		struct sockaddr_in sin;
-		struct nf_conn *ct = tuplehash_to_ctrack(h);
+		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 
 		sin.sin_family = AF_INET;
 		sin.sin_port = ct->tuplehash[IP_CT_DIR_ORIGINAL]
diff -Nur linux-2.6.11-nfct-defs-sctp/net/ipv4/netfilter/nf_conntrack_proto_icmp.c linux-2.6.11-nfct-symbols/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
--- linux-2.6.11-nfct-defs-sctp/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2005-03-22 17:39:01.000000000 +0900
+++ linux-2.6.11-nfct-symbols/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2005-03-22 18:53:36.000000000 +0900
@@ -210,7 +210,7 @@
 	}
 
         /* Update skb to refer to this connection */
-        skb->nfct = &tuplehash_to_ctrack(h)->ct_general;
+        skb->nfct = &nf_ct_tuplehash_to_ctrack(h)->ct_general;
         skb->nfctinfo = *ctinfo;
         return -NF_ACCEPT;
 }
diff -Nur linux-2.6.11-nfct-defs-sctp/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c linux-2.6.11-nfct-symbols/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- linux-2.6.11-nfct-defs-sctp/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-03-22 17:39:01.000000000 +0900
+++ linux-2.6.11-nfct-symbols/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-03-22 18:53:36.000000000 +0900
@@ -439,7 +439,7 @@
 	h = nf_conntrack_find_get(&tuple, NULL);
 	if (h) {
 		struct sockaddr_in6 sin;
-		struct nf_conn *ct = tuplehash_to_ctrack(h);
+		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 
 		memset(&sin, 0, sizeof(sin));
 
diff -Nur linux-2.6.11-nfct-defs-sctp/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c linux-2.6.11-nfct-symbols/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
--- linux-2.6.11-nfct-defs-sctp/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2005-03-22 17:39:01.000000000 +0900
+++ linux-2.6.11-nfct-symbols/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2005-03-22 18:53:36.000000000 +0900
@@ -212,7 +212,7 @@
 	}
 
 	/* Update skb to refer to this connection */
-	skb->nfct = &tuplehash_to_ctrack(h)->ct_general;
+	skb->nfct = &nf_ct_tuplehash_to_ctrack(h)->ct_general;
 	skb->nfctinfo = *ctinfo;
 	return -NF_ACCEPT;
 }
diff -Nur linux-2.6.11-nfct-defs-sctp/net/netfilter/nf_conntrack_core.c linux-2.6.11-nfct-symbols/net/netfilter/nf_conntrack_core.c
--- linux-2.6.11-nfct-defs-sctp/net/netfilter/nf_conntrack_core.c	2005-03-22 17:39:01.000000000 +0900
+++ linux-2.6.11-nfct-symbols/net/netfilter/nf_conntrack_core.c	2005-03-22 18:53:36.000000000 +0900
@@ -403,7 +403,7 @@
 	   master ct never got confirmed, we'd hold a reference to it
 	   and weird things would happen to future packets). */
 		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)
-		    && is_confirmed(i->master)
+		    && nf_ct_is_confirmed(i->master)
 		    && del_timer(&i->timeout)) {
 			unlink_expect(i);
 			return i;
@@ -480,7 +480,7 @@
 	remove_expectations(ct);
 
 	/* We overload first tuple to link into unconfirmed list. */
-	if (!is_confirmed(ct)) {
+	if (!nf_ct_is_confirmed(ct)) {
 		BUG_ON(list_empty(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list));
 		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 	}
@@ -515,7 +515,7 @@
 		    const struct nf_conn *ignored_conntrack)
 {
 	MUST_BE_READ_LOCKED(&nf_conntrack_lock);
-	return tuplehash_to_ctrack(i) != ignored_conntrack
+	return nf_ct_tuplehash_to_ctrack(i) != ignored_conntrack
 		&& nf_ct_tuple_equal(tuple, &i->tuple);
 }
 
@@ -548,7 +548,7 @@
 	READ_LOCK(&nf_conntrack_lock);
 	h = __nf_conntrack_find(tuple, ignored_conntrack);
 	if (h)
-		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
+		atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
 	READ_UNLOCK(&nf_conntrack_lock);
 
 	return h;
@@ -581,7 +581,7 @@
 
 	/* No external references means noone else could have
 	   confirmed us. */
-	NF_CT_ASSERT(!is_confirmed(ct));
+	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
 	DEBUGP("Confirming conntrack %p\n", ct);
 
 	WRITE_LOCK(&nf_conntrack_lock);
@@ -640,7 +640,8 @@
    connection.  Too bad: we're in trouble anyway. */
 static inline int unreplied(const struct nf_conntrack_tuple_hash *i)
 {
-	return !(test_bit(IPS_ASSURED_BIT, &tuplehash_to_ctrack(i)->status));
+	return !(test_bit(IPS_ASSURED_BIT,
+			  &nf_ct_tuplehash_to_ctrack(i)->status));
 }
 
 static int early_drop(struct list_head *chain)
@@ -653,7 +654,7 @@
 	READ_LOCK(&nf_conntrack_lock);
 	h = LIST_FIND_B(chain, unreplied, struct nf_conntrack_tuple_hash *);
 	if (h) {
-		ct = tuplehash_to_ctrack(h);
+		ct = nf_ct_tuplehash_to_ctrack(h);
 		atomic_inc(&ct->ct_general.use);
 	}
 	READ_UNLOCK(&nf_conntrack_lock);
@@ -819,7 +820,7 @@
 		if (IS_ERR(h))
 			return (void *)h;
 	}
-	ct = tuplehash_to_ctrack(h);
+	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	/* It exists; we have (non-exclusive) reference. */
 	if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY) {
@@ -1083,7 +1084,7 @@
 {
 	WRITE_LOCK(&nf_conntrack_lock);
 	/* Should be unconfirmed, so not in hash table yet */
-	NF_CT_ASSERT(!is_confirmed(conntrack));
+	NF_CT_ASSERT(!nf_ct_is_confirmed(conntrack));
 
 	DEBUGP("Altering reply tuple of %p to ", conntrack);
 	NF_CT_DUMP_TUPLE(newreply);
@@ -1118,8 +1119,8 @@
 static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 			 const struct nf_conntrack_helper *me)
 {
-	if (tuplehash_to_ctrack(i)->helper == me)
-		tuplehash_to_ctrack(i)->helper = NULL;
+	if (nf_ct_tuplehash_to_ctrack(i)->helper == me)
+		nf_ct_tuplehash_to_ctrack(i)->helper = NULL;
 	return 0;
 }
 
@@ -1175,7 +1176,7 @@
 	NF_CT_ASSERT(ct->timeout.data == (unsigned long)ct);
 
 	/* If not in hash table, timer will not be active yet */
-	if (!is_confirmed(ct)) {
+	if (!nf_ct_is_confirmed(ct)) {
 		ct->timeout.expires = extra_jiffies;
 		ct_add_counters(ct, ctinfo, skb);
 	} else {
@@ -1214,7 +1215,7 @@
 	int (*iter)(struct nf_conn *i, void *data),
 	void *data)
 {
-	return iter(tuplehash_to_ctrack(i), data);
+	return iter(nf_ct_tuplehash_to_ctrack(i), data);
 }
 
 /* Bring out ya dead! */
@@ -1235,7 +1236,7 @@
 		h = LIST_FIND_W(&unconfirmed, do_iter,
 				struct nf_conntrack_tuple_hash *, iter, data);
 	if (h)
-		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
+		atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
 	WRITE_UNLOCK(&nf_conntrack_lock);
 
 	return h;
@@ -1248,7 +1249,7 @@
 	unsigned int bucket = 0;
 
 	while ((h = get_next_corpse(iter, data, &bucket)) != NULL) {
-		struct nf_conn *ct = tuplehash_to_ctrack(h);
+		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 		/* Time to push up daises... */
 		if (del_timer(&ct->timeout))
 			death_by_timeout((unsigned long)ct);
diff -Nur linux-2.6.11-nfct-defs-sctp/net/netfilter/nf_conntrack_standalone.c linux-2.6.11-nfct-symbols/net/netfilter/nf_conntrack_standalone.c
--- linux-2.6.11-nfct-defs-sctp/net/netfilter/nf_conntrack_standalone.c	2005-03-22 17:39:01.000000000 +0900
+++ linux-2.6.11-nfct-symbols/net/netfilter/nf_conntrack_standalone.c	2005-03-22 18:53:36.000000000 +0900
@@ -150,7 +150,7 @@
 static int ct_seq_show(struct seq_file *s, void *v)
 {
 	const struct nf_conntrack_tuple_hash *hash = v;
-	const struct nf_conn *conntrack = tuplehash_to_ctrack(hash);
+	const struct nf_conn *conntrack = nf_ct_tuplehash_to_ctrack(hash);
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_protocol *proto;
 

----Next_Part(Tue_Mar_22_23:00:11_2005_505)----
