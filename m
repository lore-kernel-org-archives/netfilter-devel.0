From: Patrick McHardy <kaber@trash.net>
Subject: [RFC] updated ctnetlink patches: ctnetlink-0.11-0.12.diff
Date: Wed, 28 May 2003 15:45:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED4BD67.9070103@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060601030609040504030801"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060601030609040504030801
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------060601030609040504030801
Content-Type: text/plain;
 name="ctnetlink-0.11-0.12.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctnetlink-0.11-0.12.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1228  -> 1.1229 
#	net/ipv4/netfilter/ip_conntrack_proto_udp.c	1.5     -> 1.6    
#	net/ipv4/netfilter/ip_conntrack_core.c	1.20    -> 1.21   
#	net/ipv4/netfilter/ip_conntrack_proto_icmp.c	1.4     -> 1.5    
#	net/ipv4/netfilter/nfnetlink.c	1.1     -> 1.2    
#	net/ipv4/netfilter/ip_nat_core.c	1.17    -> 1.18   
#	include/linux/nfnetlink_conntrack.h	1.1     -> 1.2    
#	net/ipv4/netfilter/ip_conntrack_proto_generic.c	1.4     -> 1.5    
#	include/linux/netfilter_ipv4/ip_conntrack.h	1.10    -> 1.11   
#	net/ipv4/netfilter/ip_conntrack_standalone.c	1.11    -> 1.12   
#	net/ipv4/netfilter/Config.in	1.15    -> 1.16   
#	net/ipv4/netfilter/nfnetlink_conntrack.c	1.1     -> 1.2    
#	net/ipv4/netfilter/ip_conntrack_ftp.c	1.9     -> 1.10   
#	include/linux/netfilter_ipv4/ip_conntrack_protocol.h	1.4     -> 1.5    
#	net/ipv4/netfilter/ip_conntrack_proto_tcp.c	1.8     -> 1.9    
#	include/linux/netfilter_ipv4/ip_conntrack_core.h	1.4     -> 1.5    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/05/27	kaber@trash.net	1.1229
# import ctnetlink 0.12 changes
# --------------------------------------------
#
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h	Tue May 27 19:24:12 2003
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h	Tue May 27 19:24:12 2003
@@ -156,6 +156,18 @@
 	union ip_conntrack_expect_help help;
 };
 
+enum ip_conntrack_events
+{
+	IPCT_NEW,
+	IPCT_DESTROY,
+	IPCT_STATUS,
+	IPCT_REFRESH,
+	IPCT_PROTOINFO,
+	IPCT_HELPINFO,
+	IPCT_NATINFO,
+	IPCT_MARK
+};
+
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 struct ip_conntrack
 {
@@ -166,6 +178,13 @@
 	/* These are my tuples; original and reply */
 	struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
 
+	/* ordered list member - for table dumping over netlink */
+	struct list_head olist;
+
+	/* unique id (assigned when placing in hashtables) - for table dumping
+	 * over netlink */
+	unsigned int id;
+
 	/* Have we seen traffic both ways yet? (bitset) */
 	unsigned long status;
 
@@ -242,6 +261,11 @@
 
 extern struct module *ip_conntrack_module;
 
+struct ip_conntrack_protocol;
+extern int invert_tuple(struct ip_conntrack_tuple *inverse,
+                        const struct ip_conntrack_tuple *orig,
+                        const struct ip_conntrack_protocol *protocol);
+
 extern int invert_tuplepr(struct ip_conntrack_tuple *inverse,
 			  const struct ip_conntrack_tuple *orig);
 
@@ -262,6 +286,17 @@
 ip_ct_selective_cleanup(int (*kill)(const struct ip_conntrack *i, void *data),
 			void *data);
 
+/* returns new ip_conntrack struct or NULL */
+extern struct ip_conntrack *
+ip_conntrack_alloc(const struct ip_conntrack_tuple *,
+                   const struct ip_conntrack_tuple *);
+
+/* free conntrack structure */
+extern void ip_conntrack_free(struct ip_conntrack *);
+
+/* put connrack in hash and ordered list */
+extern void ip_conntrack_put_in_lists(struct ip_conntrack *);
+
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int is_confirmed(struct ip_conntrack *ct)
 {
@@ -269,5 +304,47 @@
 }
 
 extern unsigned int ip_conntrack_htable_size;
+extern struct list_head ip_conntrack_ordered_list;
+
+/* register notifier for conntrack events */
+extern int ip_conntrack_notify_register(struct notifier_block *);
+extern int ip_conntrack_notify_unregister(struct notifier_block *);
+
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+#include <linux/notifier.h>
+
+extern struct notifier_block *ip_conntrack_chain;
+extern unsigned long ip_conntrack_event_cache[NR_CPUS];
+
+static inline void ip_conntrack_event(enum ip_conntrack_events event,
+                                      struct ip_conntrack *ct)
+{
+	notifier_call_chain(&ip_conntrack_chain, 1 << event, ct);
+}
+
+static inline void ip_conntrack_event_cache_init(void)
+{
+	ip_conntrack_event_cache[smp_processor_id()] = 0UL;
+}
+
+static inline void ip_conntrack_cache_event(enum ip_conntrack_events event)
+{
+	ip_conntrack_event_cache[smp_processor_id()] |= 1 << event;
+}
+
+static inline void ip_conntrack_do_cached_events(struct ip_conntrack *ct)
+{
+	unsigned long events = ip_conntrack_event_cache[smp_processor_id()];
+
+	if (events)
+		notifier_call_chain(&ip_conntrack_chain, events, ct);
+}
+#else /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+static inline void ip_conntrack_event(enum ip_conntrack_events event,
+                                      struct ip_conntrack *ct)              {}
+static inline void ip_conntrack_event_cache_init(void)                      {}
+static inline void ip_conntrack_cache_event(enum ip_conntrack_events event) {}
+static inline void ip_conntrack_do_cached_events(struct ip_conntrack *ct)   {}
+#endif /* CONFIG_IP_CONNTRACK_EVENTS */
 #endif /* __KERNEL__ */
 #endif /* _IP_CONNTRACK_H */
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_core.h b/include/linux/netfilter_ipv4/ip_conntrack_core.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_core.h	Tue May 27 19:24:12 2003
+++ b/include/linux/netfilter_ipv4/ip_conntrack_core.h	Tue May 27 19:24:12 2003
@@ -32,6 +32,11 @@
 struct ip_conntrack_tuple_hash *
 ip_conntrack_find_get(const struct ip_conntrack_tuple *tuple,
 		      const struct ip_conntrack *ignored_conntrack);
+/* non-locked version */
+struct ip_conntrack_tuple_hash *
+__ip_conntrack_find_get(const struct ip_conntrack_tuple *tuple,
+                        const struct ip_conntrack *ignored_conntrack);
+
 
 extern int __ip_conntrack_confirm(struct nf_ct_info *nfct);
 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_protocol.h b/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	Tue May 27 19:24:12 2003
+++ b/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	Tue May 27 19:24:12 2003
@@ -42,6 +42,20 @@
 	int (*new)(struct ip_conntrack *conntrack, struct iphdr *iph,
 		   size_t len);
 
+	/* check if tuples are valid for a new connection */
+	int (*ctnl_check_tuples)(struct ip_conntrack_tuple *orig,
+	                         struct ip_conntrack_tuple *reply);
+
+	/* check protocol data is valid */
+	int (*ctnl_check_private)(union ip_conntrack_proto *p);
+
+	/* create new entry on behalf of ctnetlink */
+	void (*ctnl_new)(struct ip_conntrack *ct, union ip_conntrack_proto *p);
+
+	/* change protocol info on behalf of ctnetlink */
+	void (*ctnl_change)(struct ip_conntrack *ct,
+                            union ip_conntrack_proto *p);
+
 	/* Called when a conntrack entry is destroyed */
 	void (*destroy)(struct ip_conntrack *conntrack);
 
diff -Nru a/include/linux/nfnetlink_conntrack.h b/include/linux/nfnetlink_conntrack.h
--- a/include/linux/nfnetlink_conntrack.h	Tue May 27 19:24:12 2003
+++ b/include/linux/nfnetlink_conntrack.h	Tue May 27 19:24:12 2003
@@ -26,14 +26,13 @@
 	CTA_UNSPEC,     /* [none] I don't know (unspecified). */
 	CTA_ORIG,       /* [ip_conntrack_tuple] Original tuple. */
 	CTA_RPLY,       /* [ip_conntrack_tuple] Reply tuple. */
-	CTA_IIF,        /* [char] Input interface name (ie eth0). */
-	CTA_OIF,        /* [char] Output interface name (ie eth1). */
 	CTA_STATUS,     /* [unsigned long] Status of connection. */
 	CTA_INFO,       /* [unsigned long] Information (ctinfo). */
 	CTA_PROTOINFO,  /* [cta_proto] Protocol specific ct information. */
 	CTA_HELPINFO,   /* [cta_help] Helper specific information. */
 	CTA_NATINFO,    /* [cta_nat] Any NAT transformations. */
-	CTA_TIMEOUT,	/* [unsigne long] timer */
+	CTA_TIMEOUT,    /* [unsigned long] timer */
+	CTA_MARK,       /* [unsigned long] mark .*/
 
 	CTA_EXP_TIMEOUT,/* [fixme] timer */
 	CTA_EXP_TUPLE,	/* [ip_conntrack_tuple] Expected tuple */
diff -Nru a/net/ipv4/netfilter/Config.in b/net/ipv4/netfilter/Config.in
--- a/net/ipv4/netfilter/Config.in	Tue May 27 19:24:12 2003
+++ b/net/ipv4/netfilter/Config.in	Tue May 27 19:24:12 2003
@@ -8,6 +8,7 @@
 
 tristate 'Connection tracking (required for masq/NAT)' CONFIG_IP_NF_CONNTRACK
 if [ "$CONFIG_IP_NF_CONNTRACK" != "n" ]; then
+  bool 'Connection tracking event notifications' CONFIG_IP_NF_CONNTRACK_EVENTS
   if [ "$CONFIG_IP_NF_CONNTRACK" = "y" ]; then
     dep_tristate '  Connection tracking netlink interface' CONFIG_IP_NF_NETLINK_CONNTRACK $CONFIG_IP_NF_NETLINK
   else
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Tue May 27 19:24:12 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Tue May 27 19:24:12 2003
@@ -11,6 +11,9 @@
  * 16 Jul 2002: Harald Welte <laforge@gnumonks.org>
  * 	- add usage/reference counts to ip_conntrack_expect
  *	- export ip_conntrack[_expect]_{find_get,put} functions
+ * 26 Mai 2003: Patrick McHardy <kaber@trash.net>
+ *      - event notifications
+ *      - restructured/exported some functions for ctnetlink
  * */
 
 #include <linux/version.h>
@@ -30,6 +33,7 @@
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/jhash.h>
+#include <linux/notifier.h>
 /* For ERR_PTR().  Yeah, I know... --RR */
 #include <linux/fs.h>
 
@@ -65,6 +69,14 @@
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
 
+/* for ctnetlink */
+LIST_HEAD(ip_conntrack_ordered_list);
+static unsigned int ip_conntrack_next_id = 1;
+struct notifier_block *ip_conntrack_chain = NULL;
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+unsigned long ip_conntrack_event_cache[NR_CPUS];
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+
 extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
 
 static inline int proto_cmpfn(const struct ip_conntrack_protocol *curr,
@@ -148,7 +160,7 @@
 	return ret;
 }
 
-static int
+int
 invert_tuple(struct ip_conntrack_tuple *inverse,
 	     const struct ip_conntrack_tuple *orig,
 	     const struct ip_conntrack_protocol *protocol)
@@ -292,6 +304,7 @@
 {
 	DEBUGP("clean_from_lists(%p)\n", ct);
 	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
+	LIST_DELETE(&ip_conntrack_ordered_list, &ct->olist);
 	LIST_DELETE(&ip_conntrack_hash
 		    [hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple)],
 		    &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
@@ -313,6 +326,8 @@
 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
 
+	ip_conntrack_event(IPCT_DESTROY, ct);
+
 	if (ct->master && master_ct(ct))
 		ip_conntrack_put(master_ct(ct));
 
@@ -340,8 +355,7 @@
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
-	kmem_cache_free(ip_conntrack_cachep, ct);
-	atomic_dec(&ip_conntrack_count);
+	ip_conntrack_free(ct);
 }
 
 static void death_by_timeout(unsigned long ul_conntrack)
@@ -378,6 +392,17 @@
 	return h;
 }
 
+inline struct ip_conntrack_tuple_hash *
+__ip_conntrack_find_get(const struct ip_conntrack_tuple *tuple,
+                        const struct ip_conntrack *ignored_conntrack)
+{
+	struct ip_conntrack_tuple_hash *h;
+	h = __ip_conntrack_find(tuple, ignored_conntrack);
+	if (h)
+		atomic_inc(&h->ctrack->ct_general.use);
+	return h;
+}
+
 /* Find a connection corresponding to a tuple. */
 struct ip_conntrack_tuple_hash *
 ip_conntrack_find_get(const struct ip_conntrack_tuple *tuple,
@@ -386,9 +411,7 @@
 	struct ip_conntrack_tuple_hash *h;
 
 	READ_LOCK(&ip_conntrack_lock);
-	h = __ip_conntrack_find(tuple, ignored_conntrack);
-	if (h)
-		atomic_inc(&h->ctrack->ct_general.use);
+	h = __ip_conntrack_find_get(tuple, ignored_conntrack);
 	READ_UNLOCK(&ip_conntrack_lock);
 
 	return h;
@@ -415,6 +438,21 @@
 	return NULL;
 }
 
+void inline
+ip_conntrack_put_in_lists(struct ip_conntrack *conntrack)
+{
+	struct ip_conntrack_tuple_hash *h;
+
+	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
+
+	conntrack->id = ip_conntrack_next_id++;
+	list_add_tail(&conntrack->olist, &ip_conntrack_ordered_list);
+	h = &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
+	list_prepend(&ip_conntrack_hash[hash_conntrack(&h->tuple)], h);
+	h = &conntrack->tuplehash[IP_CT_DIR_REPLY];
+	list_prepend(&ip_conntrack_hash[hash_conntrack(&h->tuple)], h);
+}
+
 /* Confirm a connection given skb->nfct; places it in hash table */
 int
 __ip_conntrack_confirm(struct nf_ct_info *nfct)
@@ -457,10 +495,7 @@
 			  conntrack_tuple_cmp,
 			  struct ip_conntrack_tuple_hash *,
 			  &ct->tuplehash[IP_CT_DIR_REPLY].tuple, NULL)) {
-		list_prepend(&ip_conntrack_hash[hash],
-			     &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
-		list_prepend(&ip_conntrack_hash[repl_hash],
-			     &ct->tuplehash[IP_CT_DIR_REPLY]);
+		ip_conntrack_put_in_lists(ct);
 		/* Timer relative to confirmation time, not original
 		   setting time, otherwise we'd get timer wrap in
 		   weird delay cases. */
@@ -469,6 +504,7 @@
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		WRITE_UNLOCK(&ip_conntrack_lock);
+		ip_conntrack_event(IPCT_NEW, ct);
 		return NF_ACCEPT;
 	}
 
@@ -625,18 +661,12 @@
 			 tuple);
 }
 
-/* Allocate a new conntrack: we return -ENOMEM if classification
-   failed due to stress.  Otherwise it really is unclassifiable. */
-static struct ip_conntrack_tuple_hash *
-init_conntrack(const struct ip_conntrack_tuple *tuple,
-	       struct ip_conntrack_protocol *protocol,
-	       struct sk_buff *skb)
+struct ip_conntrack *
+ip_conntrack_alloc(const struct ip_conntrack_tuple *orig,
+                   const struct ip_conntrack_tuple *reply)
 {
 	struct ip_conntrack *conntrack;
-	struct ip_conntrack_tuple repl_tuple;
-	size_t hash;
-	struct ip_conntrack_expect *expected;
-	int i;
+	unsigned int hash, i;
 	static unsigned int drop_next = 0;
 
 	if (!ip_conntrack_hash_rnd_initted) {
@@ -644,7 +674,7 @@
 		ip_conntrack_hash_rnd_initted = 1;
 	}
 
-	hash = hash_conntrack(tuple);
+	hash = hash_conntrack(orig);
 
 	if (ip_conntrack_max &&
 	    atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {
@@ -657,37 +687,25 @@
 		    && !early_drop(&ip_conntrack_hash[hash])) {
 			if (net_ratelimit())
 				printk(KERN_WARNING
-				       "ip_conntrack: table full, dropping"
-				       " packet.\n");
-			return ERR_PTR(-ENOMEM);
+				       "ip_conntrack: table full.\n");
+			return NULL;
 		}
 	}
 
-	if (!invert_tuple(&repl_tuple, tuple, protocol)) {
-		DEBUGP("Can't invert tuple.\n");
-		return NULL;
-	}
-
 	conntrack = kmem_cache_alloc(ip_conntrack_cachep, GFP_ATOMIC);
-	if (!conntrack) {
-		DEBUGP("Can't allocate conntrack.\n");
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!conntrack)
+		return NULL;
 
 	memset(conntrack, 0, sizeof(*conntrack));
 	atomic_set(&conntrack->ct_general.use, 1);
 	conntrack->ct_general.destroy = destroy_conntrack;
-	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *tuple;
+	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
 	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].ctrack = conntrack;
-	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = repl_tuple;
+	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *reply;
 	conntrack->tuplehash[IP_CT_DIR_REPLY].ctrack = conntrack;
 	for (i=0; i < IP_CT_NUMBER; i++)
 		conntrack->infos[i].master = &conntrack->ct_general;
 
-	if (!protocol->new(conntrack, skb->nh.iph, skb->len)) {
-		kmem_cache_free(ip_conntrack_cachep, conntrack);
-		return NULL;
-	}
 	/* Don't set timer yet: wait for confirmation */
 	init_timer(&conntrack->timeout);
 	conntrack->timeout.data = (unsigned long)conntrack;
@@ -697,6 +715,43 @@
 
 	/* Mark clearly that it's not in the hash table. */
 	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list.next = NULL;
+	atomic_inc(&ip_conntrack_count);
+
+	return conntrack;
+}
+
+void ip_conntrack_free(struct ip_conntrack  *conntrack)
+{
+	kmem_cache_free(ip_conntrack_cachep, conntrack);
+	atomic_dec(&ip_conntrack_count);
+}
+
+/* Allocate a new conntrack: we return -ENOMEM if classification
+   failed due to stress.  Otherwise it really is unclassifiable. */
+static struct ip_conntrack_tuple_hash *
+init_conntrack(const struct ip_conntrack_tuple *tuple,
+	       struct ip_conntrack_protocol *protocol,
+	       struct sk_buff *skb)
+{
+	struct ip_conntrack *conntrack;
+	struct ip_conntrack_tuple repl_tuple;
+	struct ip_conntrack_expect *expected;
+
+	if (!invert_tuple(&repl_tuple, tuple, protocol)) {
+		DEBUGP("Can't invert tuple.\n");
+		return NULL;
+	}
+
+	conntrack = ip_conntrack_alloc(tuple, &repl_tuple);
+	if (!conntrack) {
+		DEBUGP("Can't allocate conntrack.\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	if (!protocol->new(conntrack, skb->nh.iph, skb->len)) {
+		ip_conntrack_free(conntrack);
+		return NULL;
+	}
 
 	WRITE_LOCK(&ip_conntrack_lock);
 	/* Need finding and deleting of expected ONLY if we win race */
@@ -735,7 +790,6 @@
 		expected->expectant->expecting--;
 		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
 	}
-	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	if (expected && expected->expectfn)
@@ -811,6 +865,8 @@
 	/* FIXME: Do this right please. --RR */
 	(*pskb)->nfcache |= NFC_UNKNOWN;
 
+	ip_conntrack_event_cache_init();
+
 /* Doesn't cover locally-generated broadcast, so not worth it. */
 #if 0
 	/* Ignore broadcast: no `connection'. */
@@ -873,8 +929,12 @@
 			return NF_ACCEPT;
 		}
 	}
-	if (set_reply)
+	if (set_reply && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+		ip_conntrack_cache_event(IPCT_STATUS);
+	}
+
+	ip_conntrack_do_cached_events(ct);
 
 	return ret;
 }
@@ -1189,11 +1249,12 @@
 	/* If not in hash table, timer will not be active yet */
 	if (!is_confirmed(ct))
 		ct->timeout.expires = extra_jiffies;
-	else {
+	else if (ct->timeout.expires != jiffies + extra_jiffies) {
 		/* Need del_timer for race avoidance (may already be dying). */
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires = jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
+			ip_conntrack_cache_event(IPCT_REFRESH);
 		}
 	}
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -1302,6 +1363,16 @@
 
 		ip_conntrack_put(h->ctrack);
 	}
+}
+
+int ip_conntrack_notify_register(struct notifier_block *nb)
+{
+	return notifier_chain_register(&ip_conntrack_chain, nb);
+}
+
+int ip_conntrack_notify_unregister(struct notifier_block *nb)
+{
+	return notifier_chain_unregister(&ip_conntrack_chain, nb);
 }
 
 /* Fast function for those who don't want to parse /proc (and I don't
diff -Nru a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c	Tue May 27 19:24:12 2003
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c	Tue May 27 19:24:12 2003
@@ -287,6 +287,7 @@
 			ct_ftp_info->seq_aft_nl[dir] = 
 						ntohl(tcph->seq) + datalen;
 			ct_ftp_info->seq_aft_nl_set[dir] = 1;
+			ip_conntrack_cache_event(IPCT_HELPINFO);
 		}
 	}
 	UNLOCK_BH(&ip_ftp_lock);
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_generic.c b/net/ipv4/netfilter/ip_conntrack_proto_generic.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_generic.c	Tue May 27 19:24:12 2003
+++ b/net/ipv4/netfilter/ip_conntrack_proto_generic.c	Tue May 27 19:24:12 2003
@@ -57,5 +57,6 @@
 struct ip_conntrack_protocol ip_conntrack_generic_protocol
 = { { NULL, NULL }, 0, "unknown",
     generic_pkt_to_tuple, generic_invert_tuple, generic_print_tuple,
-    generic_print_conntrack, established, new, NULL, NULL, NULL };
+    generic_print_conntrack, established, new, NULL, NULL, NULL, NULL, NULL,
+    NULL, NULL };
 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	Tue May 27 19:24:12 2003
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	Tue May 27 19:24:12 2003
@@ -14,6 +14,13 @@
 #define DEBUGP(format, args...)
 #endif
 
+static u_int8_t valid_new[] = {
+	[ICMP_ECHO] = 1,
+	[ICMP_TIMESTAMP] = 1,
+	[ICMP_INFO_REQUEST] = 1,
+	[ICMP_ADDRESS] = 1
+};
+
 static int icmp_pkt_to_tuple(const void *datah, size_t datalen,
 			     struct ip_conntrack_tuple *tuple)
 {
@@ -82,6 +89,7 @@
 			ct->timeout.function((unsigned long)ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
+		ip_conntrack_cache_event(IPCT_PROTOINFO);
 		ip_ct_refresh(ct, ICMP_TIMEOUT);
 	}
 
@@ -92,12 +100,6 @@
 static int icmp_new(struct ip_conntrack *conntrack,
 		    struct iphdr *iph, size_t len)
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
@@ -110,7 +112,26 @@
 	return 1;
 }
 
+static int icmp_ctnl_check_tuples(struct ip_conntrack_tuple *orig,
+                                  struct ip_conntrack_tuple *reply)
+{
+	unsigned int type = orig->dst.u.icmp.type;
+
+	if (type >= sizeof(valid_new) || !valid_new[type])
+		return -EINVAL;
+
+	return 0;
+}
+
+static void icmp_ctnl_new(struct ip_conntrack *conntrack,
+                          union ip_conntrack_proto *p)
+{
+	conntrack->proto.icmp = *(struct ip_ct_icmp *)p;
+}
+
 struct ip_conntrack_protocol ip_conntrack_protocol_icmp
 = { { NULL, NULL }, IPPROTO_ICMP, "icmp",
     icmp_pkt_to_tuple, icmp_invert_tuple, icmp_print_tuple,
-    icmp_print_conntrack, icmp_packet, icmp_new, NULL, NULL, NULL };
+    icmp_print_conntrack, icmp_packet, icmp_new,
+    icmp_ctnl_check_tuples, NULL, icmp_ctnl_new, icmp_ctnl_new,
+    NULL, NULL, NULL };
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Tue May 27 19:24:12 2003
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Tue May 27 19:24:12 2003
@@ -178,13 +178,17 @@
 	}
 
 	conntrack->proto.tcp.state = newconntrack;
+	if (newconntrack != oldtcpstate)
+		ip_conntrack_cache_event(IPCT_PROTOINFO);
 
 	/* Poor man's window tracking: record SYN/ACK for handshake check */
 	if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
 	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
-	    && tcph->syn && tcph->ack)
+	    && tcph->syn && tcph->ack) {
 		conntrack->proto.tcp.handshake_ack
 			= htonl(ntohl(tcph->seq) + 1);
+		ip_conntrack_cache_event(IPCT_PROTOINFO);
+	}
 
 	/* If only reply is a RST, we can consider ourselves not to
 	   have an established connection: this is a fairly common
@@ -199,8 +203,10 @@
 		if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
 		    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
 		    && tcph->ack && !tcph->syn
-		    && tcph->ack_seq == conntrack->proto.tcp.handshake_ack)
+		    && tcph->ack_seq == conntrack->proto.tcp.handshake_ack) {
 			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+			ip_conntrack_cache_event(IPCT_STATUS);
+		}
 
 		WRITE_UNLOCK(&tcp_lock);
 		ip_ct_refresh(conntrack, tcp_timeouts[newconntrack]);
@@ -231,6 +237,28 @@
 	return 1;
 }
 
+static int tcp_ctnl_check_private(union ip_conntrack_proto *p)
+{
+	struct ip_ct_tcp *tcp = (struct ip_ct_tcp *)p;
+	if (tcp->state >= TCP_CONNTRACK_MAX)
+		return -EINVAL;
+	return 0;
+}
+
+static void tcp_ctnl_new(struct ip_conntrack *conntrack,
+                         union ip_conntrack_proto *p)
+{
+	conntrack->proto.tcp = *(struct ip_ct_tcp *)p;
+}
+
+static void tcp_ctnl_change(struct ip_conntrack *conntrack,
+                            union ip_conntrack_proto *p)
+{
+	WRITE_LOCK(&tcp_lock);
+	conntrack->proto.tcp = *(struct ip_ct_tcp *)p;
+	WRITE_UNLOCK(&tcp_lock);
+}
+
 static int tcp_exp_matches_pkt(struct ip_conntrack_expect *exp,
 			       struct sk_buff **pskb)
 {
@@ -246,4 +274,5 @@
 struct ip_conntrack_protocol ip_conntrack_protocol_tcp
 = { { NULL, NULL }, IPPROTO_TCP, "tcp",
     tcp_pkt_to_tuple, tcp_invert_tuple, tcp_print_tuple, tcp_print_conntrack,
-    tcp_packet, tcp_new, NULL, tcp_exp_matches_pkt, NULL };
+    tcp_packet, tcp_new, NULL, tcp_ctnl_check_private, tcp_ctnl_new,
+    tcp_ctnl_change, NULL, tcp_exp_matches_pkt, NULL };
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_udp.c b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c	Tue May 27 19:24:12 2003
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c	Tue May 27 19:24:12 2003
@@ -54,7 +54,10 @@
 	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
 		ip_ct_refresh(conntrack, UDP_STREAM_TIMEOUT);
 		/* Also, more likely to be important, and not a probe */
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)) {
+			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+			ip_conntrack_cache_event(IPCT_STATUS);
+		}
 	} else
 		ip_ct_refresh(conntrack, UDP_TIMEOUT);
 
@@ -71,4 +74,4 @@
 struct ip_conntrack_protocol ip_conntrack_protocol_udp
 = { { NULL, NULL }, IPPROTO_UDP, "udp",
     udp_pkt_to_tuple, udp_invert_tuple, udp_print_tuple, udp_print_conntrack,
-    udp_packet, udp_new, NULL, NULL, NULL };
+    udp_packet, udp_new, NULL, NULL, NULL, NULL, NULL, NULL, NULL };
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	Tue May 27 19:24:12 2003
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	Tue May 27 19:24:12 2003
@@ -105,7 +105,7 @@
 	len += sprintf(buffer + len, "use=%u ",
 		       atomic_read(&conntrack->ct_general.use));
 #if defined(CONFIG_IP_NF_CONNTRACK_MARK)
-	len += sprintf(buffer + len, "mark=%ld ", conntrack->mark);
+	len += sprintf(buffer + len, "mark=%lu ", conntrack->mark);
 #endif
 	len += sprintf(buffer + len, "\n");
 
@@ -354,7 +354,11 @@
 
 EXPORT_SYMBOL(ip_conntrack_protocol_register);
 EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
+EXPORT_SYMBOL(invert_tuple);
 EXPORT_SYMBOL(invert_tuplepr);
+EXPORT_SYMBOL(ip_conntrack_alloc);
+EXPORT_SYMBOL(ip_conntrack_free);
+EXPORT_SYMBOL(ip_conntrack_put_in_lists);
 EXPORT_SYMBOL(ip_conntrack_alter_reply);
 EXPORT_SYMBOL(ip_conntrack_destroyed);
 EXPORT_SYMBOL(ip_conntrack_get);
@@ -375,7 +379,15 @@
 EXPORT_SYMBOL(ip_ct_gather_frags);
 EXPORT_SYMBOL(ip_conntrack_htable_size);
 EXPORT_SYMBOL(ip_conntrack_expect_list);
+EXPORT_SYMBOL(ip_conntrack_ordered_list);
 EXPORT_SYMBOL(ip_conntrack_lock);
 EXPORT_SYMBOL(ip_conntrack_hash);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
+EXPORT_SYMBOL_GPL(__ip_conntrack_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_put);
+EXPORT_SYMBOL(ip_conntrack_notify_register);
+EXPORT_SYMBOL(ip_conntrack_notify_unregister);
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+EXPORT_SYMBOL(ip_conntrack_event_cache);
+EXPORT_SYMBOL(ip_conntrack_chain);
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	Tue May 27 19:24:12 2003
+++ b/net/ipv4/netfilter/ip_nat_core.c	Tue May 27 19:24:12 2003
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/timer.h>
+#include <linux/notifier.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/brlock.h>
@@ -630,6 +631,8 @@
 			   IP_NAT_MANIP_SRC, inv_tuple.src });
 		IP_NF_ASSERT(info->num_manips <= IP_NAT_MAX_MANIPS);
 	}
+
+	ip_conntrack_event(IPCT_NATINFO, conntrack);
 
 	/* If there's a helper, assign it; based on new tuple. */
 	if (!conntrack->master)
diff -Nru a/net/ipv4/netfilter/nfnetlink.c b/net/ipv4/netfilter/nfnetlink.c
--- a/net/ipv4/netfilter/nfnetlink.c	Tue May 27 19:24:12 2003
+++ b/net/ipv4/netfilter/nfnetlink.c	Tue May 27 19:24:12 2003
@@ -39,11 +39,18 @@
 
 MODULE_LICENSE("GPL");
 
-char nfversion[] = "0.11";
-int nf_debug_level = 1;
-#define nf_debug(level, format, arg...) \
-        if(nf_debug_level > level)  \
-                printk(__FUNCTION__ ": " format, ## arg)
+static char __initdata nfversion[] = "0.12";
+
+#if 1
+static int nf_debug_level = 1;
+#define nf_debug(level, format, arg...)					       \
+	do {								       \
+		if (nf_debug_level > level)				       \
+			printk(KERN_DEBUG "%s: " format, __FUNCTION__, ## arg);\
+	} while(0)
+#else
+#define nf_debug(level, format, arg...)
+#endif
 
 static struct sock *nfnl = NULL;
 static LIST_HEAD(subsys_list);
@@ -141,7 +148,7 @@
 
 int nfattr_parse(struct nfattr *tb[], int maxattr, struct nfattr *nfa, int len)
 {
-	memset(tb, 0, sizeof(struct nfattr *)*maxattr);
+	memset(tb, 0, sizeof(struct nfattr *) * maxattr);
 
 	while (NFA_OK(nfa, len)) {
 		unsigned flavor = nfa->nfa_type;
@@ -167,6 +174,8 @@
 {
 	int min_len;
 
+	memset(cda, 0, sizeof(struct nfattr *) * subsys->attr_count);
+
 	/* check attribute lengths. */
 	min_len = sizeof(struct nfgenmsg);
 	if (nlh->nlmsg_len < min_len)
@@ -193,12 +202,13 @@
 
 int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, int echo)
 {
+	int allocation = in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;
 	int err = 0;
 
 	NETLINK_CB(skb).dst_groups = group;
 	if (echo)
 		atomic_inc(&skb->users);
-	netlink_broadcast(nfnl, skb, pid, group, GFP_KERNEL);
+	netlink_broadcast(nfnl, skb, pid, group, allocation);
 	if (echo)
 		err = netlink_unicast(nfnl, skb, pid, MSG_DONTWAIT);
 
diff -Nru a/net/ipv4/netfilter/nfnetlink_conntrack.c b/net/ipv4/netfilter/nfnetlink_conntrack.c
--- a/net/ipv4/netfilter/nfnetlink_conntrack.c	Tue May 27 19:24:12 2003
+++ b/net/ipv4/netfilter/nfnetlink_conntrack.c	Tue May 27 19:24:12 2003
@@ -3,11 +3,13 @@
  *
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2003 by Patrick Mchardy <kaber@trash.net>,
+ *             Harald Welte <laforge@gnumonks.org>
  *
  * Initial connection tracking via netlink development funded and 
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
  *
- * Further development of this code funded by Astaro AG (http://www.asaro.com)
+ * Further development of this code funded by Astaro AG (http://www.astaro.com)
  *
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
@@ -32,6 +34,7 @@
 #include <linux/init.h>
 #include <linux/netlink.h>
 #include <linux/spinlock.h>
+#include <linux/notifier.h>
 #include <linux/rtnetlink.h>
 
 #include <linux/netfilter.h>
@@ -39,6 +42,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 
 #include <linux/nfnetlink.h>
 #include <linux/nfnetlink_conntrack.h>
@@ -49,79 +53,158 @@
 
 MODULE_LICENSE("GPL");
 
-char ctversion[] = "0.11";
-int ct_debug_level = 1;
-#define ct_debug(level, format, arg...) \
-	if(ct_debug_level > level)  \
-		printk(__FUNCTION__ ": " format, ## arg)
+static char __initdata ctversion[] = "0.12";
+
+#if 1
+static int ct_debug_level = 1;
+#define ct_debug(level, format, arg...)					       \
+	do {								       \
+		if(ct_debug_level > level)				       \
+			printk(KERN_DEBUG "%s: " format, __FUNCTION__, ## arg);\
+	} while(0)
 
 /* FIXME: this define is just needed for DUMP_TUPLE */
 #define DEBUGP(format, args...)	ct_debug(0, format, ## args)
+#else
+#define ct_debug(level, format, arg...)
+#define DEBUGP(format, args...)
+#endif
 
 static struct nfnetlink_subsystem *ctnl_subsys;
 
+
+static inline int
+ctnetlink_dump_tuples(struct sk_buff *skb, const struct ip_conntrack *ct)
+{
+	NFA_PUT(skb, CTA_ORIG, sizeof(struct ip_conntrack_tuple),
+	        &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	NFA_PUT(skb, CTA_RPLY, sizeof(struct ip_conntrack_tuple),
+	        &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static inline int
+ctnetlink_dump_status(struct sk_buff *skb, const struct ip_conntrack *ct)
+{
+	NFA_PUT(skb, CTA_STATUS, sizeof(ct->status), &ct->status);
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static inline int
+ctnetlink_dump_timeout(struct sk_buff *skb, const struct ip_conntrack *ct)
+{
+	unsigned long timeout = (ct->timeout.expires - jiffies) * 100 / HZ;
+	
+	NFA_PUT(skb, CTA_TIMEOUT, sizeof(timeout), &timeout);
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static inline int
+ctnetlink_dump_protoinfo(struct sk_buff *skb, const struct ip_conntrack *ct)
+{
+	struct cta_proto cp;
+
+	cp.num_proto = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+	memcpy(&cp.proto, &ct->proto, sizeof(cp.proto));
+	NFA_PUT(skb, CTA_PROTOINFO, sizeof(cp), &cp);
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static inline int
+ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct ip_conntrack *ct)
+{
+	struct ip_conntrack_helper *h = ct->helper;
+	struct cta_help ch;
+
+	if (h == NULL)
+		return 0;
+
+	memcpy(&ch.tuple, &h->tuple, sizeof(struct ip_conntrack_tuple));
+	memcpy(&ch.mask, &h->mask, sizeof(struct ip_conntrack_tuple));
+	strncpy((char *)&ch.name, h->name, sizeof(ch.name));
+	memcpy(&ch.help, &ct->help, sizeof(ch.help));
+	NFA_PUT(skb, CTA_HELPINFO, sizeof(ch), &ch);
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static inline int
+ctnetlink_dump_natinfo(struct sk_buff *skb, const struct ip_conntrack *ct)
+{
+	const struct ip_nat_info *info = &ct->nat.info;
+	struct cta_nat cn;
+
+	if (!info->initialized || !info->num_manips)
+		return 0;
+
+	cn.num_manips = info->num_manips;
+	memcpy(&cn.manips, &info->manips,
+	       info->num_manips * sizeof(struct ip_nat_info_manip));
+	NFA_PUT(skb, CTA_NATINFO, sizeof(struct cta_nat), &cn);
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static inline int
+ctnetlink_dump_mark(struct sk_buff *skb, const struct ip_conntrack *ct)
+{
+#ifdef CONFIG_IP_NF_CONNTRACK_MARK
+	if (!ct->mark)
+		return 0;
+	NFA_PUT(skb, CTA_MARK, sizeof(ct->mark), &ct->mark);
+	return 0;
+
+nfattr_failure:
+	return -1;
+#else
+	return 0;
+#endif
+}
+
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
-		    int event, 
-		    int nowait, 
-		    const struct ip_conntrack *ct, 
-		    const enum ip_conntrack_info *ctinfo, 
-		    unsigned char proto,
-		    const struct net_device *in,
-		    const struct net_device *out)
+		    int event, int nowait, 
+		    const struct ip_conntrack *ct)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
-	struct cta_proto cp;
-	unsigned long s;
 	unsigned char *b;
 
 	b = skb->tail;
-	nlh = NLMSG_PUT(skb, pid, seq, (NFNL_SUBSYS_CTNETLINK<<8)|event, 
-			sizeof(struct nfgenmsg));
-	nfmsg = NLMSG_DATA(nlh);
 
-	nlh->nlmsg_flags 	= (nowait && pid) ? NLM_F_MULTI : 0;
-	nfmsg->nfgen_family	= AF_INET;
-	NFA_PUT(skb, CTA_ORIG, sizeof(struct ip_conntrack_tuple), 
-		&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	NFA_PUT(skb, CTA_RPLY, sizeof(struct ip_conntrack_tuple),
-		&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-	s = ct->status;
-	NFA_PUT(skb, CTA_STATUS, sizeof(unsigned long), &s);
-	if (in)
-		NFA_PUT(skb, CTA_IIF, IFNAMSIZ, in->name);
-	if (out)
-		NFA_PUT(skb, CTA_OIF, IFNAMSIZ, out->name);
-	if (ctinfo)
-		NFA_PUT(skb, CTA_INFO, sizeof(unsigned long), ctinfo);
+	event |= NFNL_SUBSYS_CTNETLINK << 8;
+	nlh    = NLMSG_PUT(skb, pid, seq, event, sizeof(struct nfgenmsg));
+	nfmsg  = NLMSG_DATA(nlh);
 
-	cp.num_proto = proto;
-	memcpy(&cp.proto, &ct->proto, sizeof (cp.proto));
-	NFA_PUT(skb, CTA_PROTOINFO, sizeof(cp), &cp);
-
-	if (ct->helper) {
-		struct cta_help ch;
-
-		memcpy(&ch.tuple, &ct->helper->tuple, 
-			sizeof(struct ip_conntrack_tuple));
-		memcpy(&ch.mask, &ct->helper->mask,
-			sizeof(struct ip_conntrack_tuple));
-		strncpy((char *)&ch.name, ct->helper->name, sizeof(ch.name));
-		memcpy(&ch.help, &ct->help, sizeof(ch.help));
-		NFA_PUT(skb, CTA_HELPINFO, sizeof(ch), &ch);
-	}
+	nlh->nlmsg_flags    = (nowait && pid) ? NLM_F_MULTI : 0;
+	nfmsg->nfgen_family = AF_INET;
 
+	if (ctnetlink_dump_tuples(skb, ct) < 0 ||
+	    ctnetlink_dump_status(skb, ct) < 0 ||
+	    ctnetlink_dump_timeout(skb, ct) < 0 ||
+	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
+	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
+	    ctnetlink_dump_mark(skb, ct) < 0)
+		goto nfattr_failure;
 #ifdef CONFIG_IP_NF_NAT_NEEDED
-	if (ct->nat.info.initialized && ct->nat.info.num_manips) {
-		const struct ip_nat_info *nat = &ct->nat.info;
-		struct cta_nat cn;
-
-		cn.num_manips = nat->num_manips;
-		memcpy(&cn.manips, &nat->manips, (nat->num_manips 
-			* sizeof(struct ip_nat_info_manip)));
-		NFA_PUT(skb, CTA_NATINFO, sizeof(struct cta_nat), &cn);
-	}
+	if (ctnetlink_dump_natinfo(skb, ct) < 0)
+		goto nfattr_failure;
 #endif /* CONFIG_IP_NF_NAT_NEEDED */
 
 	nlh->nlmsg_len = skb->tail - b;
@@ -133,76 +216,108 @@
 	return -1;
 }
 
-static inline struct sk_buff *
-ctnetlink_event_build_msg(const struct ip_conntrack *ct, 
-			  const enum ip_conntrack_info ctinfo, 
-			  const unsigned char proto,
-			  const struct net_device *in,
-			  const struct net_device *out)
+static inline unsigned int
+ctnetlink_get_mcgroups(struct ip_conntrack *ct)
 {
-	struct sk_buff *skb;
-	int err;
+	unsigned int groups;
+	int proto = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
 
-	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
-	if (!skb)
-		return NULL;
-
-	err = ctnetlink_fill_info(skb, 0, 0, CTNL_MSG_NEWCONNTRACK, 1, ct,
-				  &ctinfo, proto, in, out);
-	if (err <= 0)
-		goto nlmsg_failure;
-	return skb;
+	switch (proto) {
+	case IPPROTO_TCP:
+		groups = NFGRP_IPV4_CT_TCP;
+		break;
+	case IPPROTO_UDP:
+		groups = NFGRP_IPV4_CT_UDP;
+		break;
+	case IPPROTO_ICMP:
+		groups = NFGRP_IPV4_CT_ICMP;
+		break;
+	default:
+		groups = NFGRP_IPV4_CT_OTHER;
+		break;
+	}
 
-nlmsg_failure:
-	return NULL;
+	return groups;
 }
 
-static void
-ctnetlink_create(struct ip_conntrack *ct,
-		 enum ip_conntrack_info ctinfo,
-		 const struct net_device *in, 
-		 const struct net_device *out)
+#define EVENT(m,e) ((m) & (1 << (e)))
+
+static int ctnetlink_conntrack_event(struct notifier_block *this,
+                                     unsigned long events, void *ptr)
 {
-	u16 proto = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfmsg;
+	struct ip_conntrack *ct = (struct ip_conntrack *)ptr;
 	struct sk_buff *skb;
+	unsigned int type;
+	unsigned char *b;
+
+	if (!(ct->status & IPS_CONFIRMED))
+		return NOTIFY_DONE;
 
-	skb = ctnetlink_event_build_msg(ct, ctinfo, proto, in, out);
+	/* FIXME: much too big, costs lots of socket buffer space */
+	skb = alloc_skb(400 /* NLMSG_GOODSIZE */, GFP_ATOMIC);
 	if (!skb)
-		return;
+		return NOTIFY_DONE;
 
-	if (proto == IPPROTO_TCP) {
-		nfnetlink_send(skb, 0, NFGRP_IPV4_CT_TCP, 0);
-		return;
-       	} else if (proto == IPPROTO_UDP) {
-		nfnetlink_send(skb, 0, NFGRP_IPV4_CT_UDP, 0);
-		return;
-       	} else if (proto == IPPROTO_ICMP) {
-		nfnetlink_send(skb, 0, NFGRP_IPV4_CT_ICMP, 0);
-		return;
-	} else {
-		nfnetlink_send(skb, 0, NFGRP_IPV4_CT_OTHER, 0);
-		return;
+	if (EVENT(events, IPCT_DESTROY))
+		type = CTNL_MSG_DELCONNTRACK;
+	else {
+		type = CTNL_MSG_NEWCONNTRACK;
+		if (EVENT(events, IPCT_NEW))
+			/* dump everything */
+			events = ~0UL;
 	}
-	kfree_skb(skb);
-	return;
-}
 
-#if 0
-static void ctnetlink_destroy(struct ip_conntrack *ct)
-{
-        ctnetlink_create(ct, IP_CT_DELETE, NULL, NULL);
+	b = skb->tail;
+
+	type |= NFNL_SUBSYS_CTNETLINK << 8;
+	nlh   = NLMSG_PUT(skb, 0, 0, type, sizeof(struct nfgenmsg));
+	nfmsg = NLMSG_DATA(nlh);
+
+	nlh->nlmsg_flags    = 0;
+	nfmsg->nfgen_family = AF_INET;
+
+	if (ctnetlink_dump_tuples(skb, ct) < 0)
+		goto nfattr_failure;
+
+	if (EVENT(events, IPCT_STATUS)
+	    && ctnetlink_dump_status(skb, ct) < 0)
+		goto nfattr_failure;
+	if (EVENT(events, IPCT_REFRESH)
+	    && ctnetlink_dump_timeout(skb, ct) < 0)
+		goto nfattr_failure;
+	if (EVENT(events, IPCT_PROTOINFO)
+	    && ctnetlink_dump_protoinfo(skb, ct) < 0)
+		goto nfattr_failure;
+	if (EVENT(events, IPCT_HELPINFO)
+	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
+		goto nfattr_failure;
+	if (EVENT(events, IPCT_NATINFO)
+	    && ctnetlink_dump_natinfo(skb, ct) < 0)
+		goto nfattr_failure;
+	if (EVENT(events, IPCT_MARK)
+	    && ctnetlink_dump_mark(skb, ct) < 0)
+		goto nfattr_failure;
+
+	nlh->nlmsg_len = skb->tail - b;
+	nfnetlink_send(skb, 0, ctnetlink_get_mcgroups(ct), 0);
+	return NOTIFY_DONE;
+
+nlmsg_failure:
+nfattr_failure:
+	kfree_skb(skb);
+	return NOTIFY_DONE;
 }
-#endif
 
 static inline int ctnetlink_kill(const struct ip_conntrack *i, void *data)
 {
 	struct ip_conntrack *t = (struct ip_conntrack *)data;
 
 	if (!memcmp(&i->tuplehash[IP_CT_DIR_ORIGINAL], 
-	    &t->tuplehash[IP_CT_DIR_ORIGINAL], 
-	    sizeof(struct ip_conntrack_tuple_hash))) {
-		//ip_conntrack_put(t);
-		nf_conntrack_put(&t->infos[0]);
+	            &t->tuplehash[IP_CT_DIR_ORIGINAL], 
+	            sizeof(struct ip_conntrack_tuple_hash))) {
+		ip_conntrack_put(t);
 		return 1;
 	}
 
@@ -222,6 +337,14 @@
 	if (nfnetlink_check_attributes(ctnl_subsys, nlh, cda) < 0)
 		return -EINVAL;
 
+	if (cda[CTA_ORIG-1] &&
+	    NFA_PAYLOAD(cda[CTA_ORIG-1]) < sizeof(struct ip_conntrack_tuple))
+		return -EINVAL;
+
+	if (cda[CTA_RPLY-1] &&
+	    NFA_PAYLOAD(cda[CTA_RPLY-1]) < sizeof(struct ip_conntrack_tuple))
+		return -EINVAL;
+	
 	if (cda[CTA_ORIG-1])
 		tuple = NFA_DATA(cda[CTA_ORIG-1]);
 	else {
@@ -253,53 +376,27 @@
 }
 
 static int
-ctnetlink_dump_build_msg(const struct ip_conntrack_tuple_hash *hash,
-			 struct sk_buff *skb, u32 pid, u32 seq)
+ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct ip_conntrack *ct;
-	int err, proto;
-
-	/* Only count originals */
-	if (DIRECTION(hash))
-		return 0;
-
-	ct = hash->ctrack;
-	if (!ct)
-		goto nlmsg_failure;
-
-	proto = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
-	err = ctnetlink_fill_info(skb, pid, seq, CTNL_MSG_NEWCONNTRACK, 1,
-				  ct, NULL, proto, NULL, NULL);
-	if (err <= 0)
-		goto nlmsg_failure;
-	return 0;
 
-nlmsg_failure:
-	if (skb)
-		kfree_skb(skb);
-	return -1;
-}
-
-static int
-ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
-{
-	int i;
-	int idx;
-	int s_idx = cb->args[0];
+	ct_debug(0, "entered, last=%lu\n", cb->args[0]);
 
-	/* Traverse hash; send originals then reply. */
+	/* Traverse ordered list; send originals then reply. */
 	READ_LOCK(&ip_conntrack_lock);
-        for (i = 0, idx = 0; i < ip_conntrack_htable_size; i++, idx++) {
-		if (idx < s_idx)
-			continue;
-		if (LIST_FIND(&ip_conntrack_hash[i], ctnetlink_dump_build_msg,
-			      struct ip_conntrack_tuple_hash *, skb,
-			      NETLINK_CB(cb->skb).pid, cb->nlh->nlmsg_seq))
+	list_for_each_entry(ct, &ip_conntrack_ordered_list, olist) {
+		if (ct->id <= cb->args[0])
 			continue;
+		if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
+		                        cb->nlh->nlmsg_seq,
+					CTNL_MSG_NEWCONNTRACK, 1, ct) < 0)
+			break;
+		cb->args[0] = ct->id;
 	}
 	READ_UNLOCK(&ip_conntrack_lock);
+	
+	ct_debug(0, "leaving, last=%lu\n", cb->args[0]);
 
-	cb->args[0] = idx;
 	return skb->len;
 }
 
@@ -312,7 +409,7 @@
 	struct nfattr *cda[CTA_MAX];
 	struct ip_conntrack *ct;
 	struct sk_buff *skb2 = NULL;
-	int err, proto;
+	int err;
 
 	ct_debug(0, "entered\n");
 
@@ -323,11 +420,11 @@
 		if (msg->nfgen_family != AF_INET)
 			return -EAFNOSUPPORT;
 
-		ct_debug(0, "starting dump\n");
-                if ((*errp = netlink_dump_start(ctnl, skb, nlh,
-		    				ctnetlink_dump_table,
-						ctnetlink_done)) != 0)
+		if ((*errp = netlink_dump_start(ctnl, skb, nlh,
+		                                ctnetlink_dump_table,
+		                                ctnetlink_done)) != 0)
 			return -EINVAL;
+
 		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
 		if (rlen > skb->len)
 			rlen = skb->len;
@@ -338,6 +435,14 @@
 	if (nfnetlink_check_attributes(ctnl_subsys, nlh, cda) < 0)
 		return -EINVAL;
 
+	if (cda[CTA_ORIG-1] &&
+	    NFA_PAYLOAD(cda[CTA_ORIG-1]) < sizeof(struct ip_conntrack_tuple))
+		return -EINVAL;
+
+	if (cda[CTA_RPLY-1] &&
+	    NFA_PAYLOAD(cda[CTA_RPLY-1]) < sizeof(struct ip_conntrack_tuple))
+		return -EINVAL;
+	
 	if (cda[CTA_ORIG-1])
 		tuple = NFA_DATA(cda[CTA_ORIG-1]);
 	else {
@@ -348,22 +453,22 @@
 	}
 
 	h = ip_conntrack_find_get(tuple, NULL);
-	if (!h)
+	if (!h) {
+		ct_debug(0, "tuple not found in conntrack hash:");
+		DUMP_TUPLE(tuple);
 		return -ENOENT;
-
+	}
 	ct = h->ctrack;
-	if (!ct)
-		goto nlmsg_failure;
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
-	if (!skb2)
+	if (!skb2) {
+		ip_conntrack_put(ct);
 		return -ENOMEM;
+	}
 	NETLINK_CB(skb2).dst_pid = NETLINK_CB(skb).pid;
 
-        proto = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
 	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, 
-				  CTNL_MSG_NEWCONNTRACK, 1, ct, NULL, 
-				  proto, NULL, NULL);
+				  CTNL_MSG_NEWCONNTRACK, 1, ct);
 	ip_conntrack_put(ct);
 	if (err <= 0)
 		goto nlmsg_failure;
@@ -379,14 +484,273 @@
 	return -1;
 }
 
-/* Finish me: should support NLM_F_CREATE and NLM_F_REPLACE. */
+static inline int
+ctnetlink_change_status(struct ip_conntrack *ct, unsigned long *status)
+{
+	unsigned long d = ct->status ^ *status;
+
+	if (d & (IPS_EXPECTED|IPS_CONFIRMED))
+		/* unchangeable */
+		return -EINVAL;
+	
+	if (d & IPS_SEEN_REPLY && !(*status & IPS_SEEN_REPLY))
+		/* SEEN_REPLY bit can only be set */
+		return -EINVAL;
+
+	if (d & IPS_ASSURED && !(*status & IPS_ASSURED))
+		/* ASSURED bit can only be set */
+		return -EINVAL;
+
+	*status &= IPS_EXPECTED|IPS_SEEN_REPLY|IPS_ASSURED|IPS_CONFIRMED;
+	ct->status = *status;
+
+	return 0;
+}
+
+static inline int
+ctnetlink_change_protoinfo(struct ip_conntrack *ct, struct cta_proto *cp)
+{
+	struct ip_conntrack_protocol *icp;
+	int proto = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+	
+	if (cp->num_proto != proto)
+		return -EINVAL;
+
+	icp = __ip_ct_find_proto(cp->num_proto);
+
+	if (icp->ctnl_check_private && icp->ctnl_check_private(&cp->proto))
+		return -EINVAL;
+	if (icp->ctnl_change)
+		icp->ctnl_change(ct, &cp->proto);
+
+	return 0;
+}
+
+static inline int
+ctnetlink_change_helpinfo(struct ip_conntrack *ct, struct cta_help *h)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int
+ctnetlink_change_natinfo(struct ip_conntrack *ct, struct cta_nat *n)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int
+ctnetlink_change_timeout(struct ip_conntrack *ct, unsigned long *timeout)
+{
+	if (!del_timer(&ct->timeout))
+		return -1;
+	ct->timeout.expires = jiffies + *timeout * HZ / 100;
+	add_timer(&ct->timeout);
+
+	return 0;
+}
+
+static inline int
+ctnetlink_change_mark(struct ip_conntrack *ct, unsigned long *mark)
+{
+#ifdef CONFIG_IP_NF_CONNTRACK_MARK
+	ct->mark = *mark;
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int
+ctnetlink_change_conntrack(struct ip_conntrack *ct, struct nfattr *cda[])
+{
+	void *data;
+	int err;
+	
+	ct_debug(0, "entered\n");
+
+	if (cda[CTA_STATUS-1]) {
+		data = NFA_DATA(cda[CTA_STATUS-1]);
+		if ((err = ctnetlink_change_status(ct, data)) < 0)
+			return err;
+	}
+	if (cda[CTA_PROTOINFO-1]) {
+		data = NFA_DATA(cda[CTA_PROTOINFO-1]);
+		if ((err = ctnetlink_change_protoinfo(ct, data)) < 0)
+			return err;
+	}
+	if (cda[CTA_HELPINFO-1]) {
+		data = NFA_DATA(cda[CTA_HELPINFO-1]);
+		if ((err = ctnetlink_change_helpinfo(ct, data)) < 0)
+			return err;
+	}
+	if (cda[CTA_NATINFO-1]) {
+		data = NFA_DATA(cda[CTA_HELPINFO-1]);
+		if ((err = ctnetlink_change_natinfo(ct, data)) < 0)
+			return err;
+	}
+	if (cda[CTA_TIMEOUT-1]) {
+		data = NFA_DATA(cda[CTA_TIMEOUT-1]);
+		if ((err = ctnetlink_change_timeout(ct, data)) < 0)
+			return err;
+	}
+	if (cda[CTA_MARK-1]) {
+		data = NFA_DATA(cda[CTA_MARK-1]);
+		if ((err = ctnetlink_change_mark(ct, data)) < 0)
+			return err;
+	}
+
+	ct_debug(0, "all done\n");
+	return 0;
+}
+
+static int
+ctnetlink_create_conntrack(struct nfattr *cda[])
+{
+	struct ip_conntrack *ct;
+	struct ip_conntrack_tuple *otuple, *rtuple, t;
+	struct ip_conntrack_protocol *icp;
+	struct cta_proto *proto;
+	unsigned long *status;
+	unsigned long *timeout;
+
+	ct_debug(0, "entered\n");
+
+	if (!(cda[CTA_ORIG-1] && cda[CTA_RPLY-1] && cda[CTA_STATUS-1] &&
+	      cda[CTA_PROTOINFO-1] && cda[CTA_TIMEOUT-1])) {
+		ct_debug(0, "required attribute(s) missing\n");
+		return -EINVAL;
+	}
+
+	otuple = NFA_DATA(cda[CTA_ORIG-1]);
+	rtuple = NFA_DATA(cda[CTA_RPLY-1]);
+
+	status = NFA_DATA(cda[CTA_STATUS-1]);
+	if (!(*status & IPS_CONFIRMED))
+		/* cannot create unconfirmed connections */
+		return -EINVAL;
+
+	proto = NFA_DATA(cda[CTA_PROTOINFO-1]);
+	icp   = __ip_ct_find_proto(proto->num_proto);
+
+	if (icp->ctnl_check_tuples && icp->ctnl_check_tuples(otuple, rtuple))
+		return -EINVAL;
+	
+	if (!invert_tuple(&t, otuple, icp))
+		return -EINVAL;
+
+	if (memcmp(rtuple, &t, sizeof(struct ip_conntrack_tuple)))
+		/* rtuple is not inverted otuple */
+		return -EINVAL;
+	
+	if (icp->ctnl_check_private && icp->ctnl_check_private(&proto->proto))
+		return -EINVAL;
+
+	ct = ip_conntrack_alloc(otuple, rtuple);
+	if (ct == NULL)
+		return -ENOMEM;
+
+	ct->status = *status;
+	if (icp->ctnl_new)
+		icp->ctnl_new(ct, &proto->proto);
+
+	ip_conntrack_put_in_lists(ct);
+
+	timeout = NFA_DATA(cda[CTA_TIMEOUT-1]);
+	ct->timeout.expires = jiffies + *timeout * HZ / 100;
+	add_timer(&ct->timeout);
+
+	cda[CTA_ORIG-1] = cda[CTA_RPLY-1] = cda[CTA_PROTOINFO-1] = 
+	        cda[CTA_STATUS-1] = cda[CTA_TIMEOUT-1] = NULL;
+
+	return ctnetlink_change_conntrack(ct, cda);
+}
+
 static int 
 ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb, 
 			struct nlmsghdr *nlh, int *errp)
 {
-	return -EOPNOTSUPP;
-}
+	struct nfattr *cda[CTA_MAX];
+	struct ip_conntrack_tuple *otuple = NULL, *rtuple = NULL;
+	struct ip_conntrack_tuple_hash *h = NULL;
+	int err = 0;
+
+	ct_debug(0, "entered\n");
 
+	if (nfnetlink_check_attributes(ctnl_subsys, nlh, cda) < 0)
+		return -EINVAL;
+
+	if (cda[CTA_ORIG-1] &&
+	    NFA_PAYLOAD(cda[CTA_ORIG-1]) < sizeof(struct ip_conntrack_tuple))
+		return -EINVAL;
+
+	if (cda[CTA_RPLY-1] &&
+	    NFA_PAYLOAD(cda[CTA_RPLY-1]) < sizeof(struct ip_conntrack_tuple))
+		return -EINVAL;
+
+	if (cda[CTA_PROTOINFO-1] &&
+	    NFA_PAYLOAD(cda[CTA_PROTOINFO-1]) < sizeof(struct cta_proto))
+		return -EINVAL;
+
+	if (cda[CTA_HELPINFO-1] &&
+	    NFA_PAYLOAD(cda[CTA_HELPINFO-1]) < sizeof(struct cta_help))
+		return -EINVAL;
+
+	if (cda[CTA_NATINFO-1] &&
+	    NFA_PAYLOAD(cda[CTA_NATINFO-1]) < sizeof(struct cta_nat))
+		return -EINVAL;
+
+	if (cda[CTA_STATUS-1] &&
+	    NFA_PAYLOAD(cda[CTA_STATUS-1]) < sizeof(unsigned long))
+		return -EINVAL;
+
+	if (cda[CTA_TIMEOUT-1] &&
+	    NFA_PAYLOAD(cda[CTA_TIMEOUT-1]) < sizeof(unsigned long))
+		return -EINVAL;
+
+	if (cda[CTA_MARK-1] &&
+	    NFA_PAYLOAD(cda[CTA_MARK-1]) < sizeof(unsigned long))
+		return -EINVAL;
+
+	ct_debug(0, "all attribute sizes ok\n");
+
+	if (cda[CTA_ORIG-1])
+		otuple = NFA_DATA(cda[CTA_ORIG-1]);
+	
+	if (cda[CTA_RPLY-1])
+		rtuple = NFA_DATA(cda[CTA_RPLY-1]);
+
+	if (otuple == NULL && rtuple == NULL) {
+		ct_debug(0, "no tuple in request\n");
+		return -EINVAL;
+	}
+
+	WRITE_LOCK(&ip_conntrack_lock);
+	if (otuple)
+		h = __ip_conntrack_find_get(otuple, NULL);
+	if (h == NULL && rtuple)
+		h = __ip_conntrack_find_get(rtuple, NULL);
+
+	if (h == NULL) {
+		ct_debug(0, "no such conntrack, create new\n");
+		err = -ENOENT;
+		if (!(nlh->nlmsg_flags & NLM_F_CREATE))
+			goto out_unlock;
+		err = ctnetlink_create_conntrack(cda);
+		goto out_unlock;
+	} else {
+		ct_debug(0, "conntrack found, change\n");
+		err = -EEXIST;
+		if (nlh->nlmsg_flags & NLM_F_EXCL)
+			goto out_put;
+		err = ctnetlink_change_conntrack(h->ctrack, cda);
+	}
+
+out_put:
+	ip_conntrack_put(h->ctrack);
+out_unlock:
+	WRITE_UNLOCK(&ip_conntrack_lock);
+	return err;
+}
 
 /* EXPECT */
 
@@ -489,6 +853,14 @@
 	if (nfnetlink_check_attributes(ctnl_subsys, nlh, cda) < 0)
 		return -EINVAL;
 
+	if (cda[CTA_ORIG-1] &&
+	    NFA_PAYLOAD(cda[CTA_ORIG-1]) < sizeof(struct ip_conntrack_tuple))
+		return -EINVAL;
+
+	if (cda[CTA_RPLY-1] &&
+	    NFA_PAYLOAD(cda[CTA_RPLY-1]) < sizeof(struct ip_conntrack_tuple))
+		return -EINVAL;
+	        
 	if (cda[CTA_ORIG-1])
 		tuple = NFA_DATA(cda[CTA_ORIG-1]);
 	else {
@@ -583,6 +955,14 @@
 	if (nfnetlink_check_attributes(ctnl_subsys, nlh, cda) < 0)
 		return -EINVAL;
 
+	if (cda[CTA_ORIG-1]
+	    && NFA_PAYLOAD(cda[CTA_ORIG-1]) < sizeof(struct ip_conntrack_tuple))
+		return -EINVAL;
+
+	if (cda[CTA_RPLY-1]
+	    && NFA_PAYLOAD(cda[CTA_RPLY-1]) < sizeof(struct ip_conntrack_tuple))
+		return -EINVAL;
+
 	if (cda[CTA_ORIG-1])
 		tuple = NFA_DATA(cda[CTA_ORIG-1]);
 	else {
@@ -628,19 +1008,17 @@
 
 /* struct conntrack_expect stuff */
 
-#if 0
-static struct ip_conntrack_notify ctnl_notify = { { NULL, NULL },
-						ctnetlink_destroy,
-						ctnetlink_create };
-
-static struct ip_conntrack_notify ctnl_exp_notify;
-#endif
+static struct notifier_block ctnl_notifier = {
+	ctnetlink_conntrack_event,
+	NULL,
+	0
+};
 
 static void __exit ctnetlink_exit(void)
 {
 	printk("ctnetlink: unregistering with nfnetlink.\n");
 //	ip_conntrack_notify_unregister(&ctnl_exp_notify);
-//	ip_conntrack_notify_unregister(&ctnl_notify);
+	ip_conntrack_notify_unregister(&ctnl_notifier);
 	nfnetlink_subsys_unregister(ctnl_subsys);
 	kfree(ctnl_subsys);
 	return;
@@ -674,21 +1052,19 @@
 	ctnl_subsys->cb[CTNL_MSG_GETEXPECT].cap_required = 0;
 	// FIXME: CONFIRM
 
-	printk("ctnetlink: registering with nfnetlink v%s.\n", ctversion);
+	printk("ctnetlink v%s: registering with nfnetlink.\n", ctversion);
 	if (nfnetlink_subsys_register(ctnl_subsys) < 0) {
 		printk("ctnetlink_init: cannot register with nfnetlink.\n");
 		ret = -1;
 		goto err_free_subsys;
 	}
 
-
-#if 0
-	if (ip_conntrack_notify_register(&ctnl_notify) < 0) {
+	if ((ret = ip_conntrack_notify_register(&ctnl_notifier)) < 0) {
 		printk("ctnetlink_init: cannot register notifier.\n");
-		ret = -1;
 		goto err_unreg_subsys;
 	}
 
+#if 0
 	if (ip_conntrack_notify_register(&ctnl_exp_notify) < 0) {
 		printk("ctnetlink_init: cannot register exp notifier\n");
 		ret = -1;

--------------060601030609040504030801--
