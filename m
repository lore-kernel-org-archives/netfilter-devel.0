From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 5/12]: kill struct nf_ct_info
Date: Tue, 21 Sep 2004 05:22:39 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9E7F.4060506@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080805030403060707040508"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080805030403060707040508
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch might be controversial, it kills struct nf_ct_info and adds
a new field to the skb to indicate the relationship of the skb to the
conntrack. This saves 5 pointers per conntrack and removes an unnecessary
level of pointer dereference. Currently nfct points to one of the five
struct nf_ct_info embedded in struct ip_conntrack, each one containing a
pointer to the struct ip_conntrack. The relationship is determined from the
index of the struct nf_ct_info pointed to by the skb. There are usually alot
more connection tracking entries than skbs in the system, so I thing it's
worth it. To make up for the increased skb size I'm going to look at
removing nfcache :)


ChangeSet@1.1935.1.5, 2004-09-19 15:29:24+02:00, kaber@coreworks.de
  [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
 
  The relationship of the skb to the conntrack is stored in a new field
  in the skb.
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------080805030403060707040508
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/19 15:29:24+02:00 kaber@coreworks.de 
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/ip6_output.c
#   2004/09/19 15:29:00+02:00 kaber@coreworks.de +1 -0
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_state.c
#   2004/09/19 15:29:00+02:00 kaber@coreworks.de +2 -2
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_conntrack.c
#   2004/09/19 15:29:00+02:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_REJECT.c
#   2004/09/19 15:29:00+02:00 kaber@coreworks.de +6 -6
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_NOTRACK.c
#   2004/09/19 15:28:59+02:00 kaber@coreworks.de +2 -1
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_fw_compat_masq.c
#   2004/09/19 15:28:59+02:00 kaber@coreworks.de +3 -3
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_icmp.c
#   2004/09/19 15:28:59+02:00 kaber@coreworks.de +2 -1
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/09/19 15:28:59+02:00 kaber@coreworks.de +15 -47
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/ip_output.c
#   2004/09/19 15:28:59+02:00 kaber@coreworks.de +1 -0
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/core/skbuff.c
#   2004/09/19 15:28:59+02:00 kaber@coreworks.de +2 -0
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/core/netfilter.c
#   2004/09/19 15:28:59+02:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/skbuff.h
#   2004/09/19 15:28:59+02:00 kaber@coreworks.de +8 -10
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack_core.h
#   2004/09/19 15:28:59+02:00 kaber@coreworks.de +3 -3
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack.h
#   2004/09/19 15:28:59+02:00 kaber@coreworks.de +6 -7
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter.h
#   2004/09/19 15:28:59+02:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
#   
#   The relationship of the skb to the conntrack is stored in a new field
#   in the skb.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter.h b/include/linux/netfilter.h
--- a/include/linux/netfilter.h	2004-09-20 11:57:45 +02:00
+++ b/include/linux/netfilter.h	2004-09-20 11:57:45 +02:00
@@ -178,7 +178,7 @@
 ip6t_find_target_lock(const char *name, int *error, struct semaphore *mutex);
 extern inline struct arpt_target *
 arpt_find_target_lock(const char *name, int *error, struct semaphore *mutex);
-extern void (*ip_ct_attach)(struct sk_buff *, struct nf_ct_info *);
+extern void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
 
 #ifdef CONFIG_NETFILTER_DEBUG
 extern void nf_dump_skb(int pf, struct sk_buff *skb);
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h	2004-09-20 11:57:45 +02:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h	2004-09-20 11:57:45 +02:00
@@ -196,12 +196,7 @@
 	/* Helper, if any. */
 	struct ip_conntrack_helper *helper;
 
-	/* Our various nf_ct_info structs specify *what* relation this
-           packet has to the conntrack */
-	struct nf_ct_info infos[IP_CT_NUMBER];
-
 	/* Storage reserved for other modules: */
-
 	union ip_conntrack_proto proto;
 
 	union ip_conntrack_help help;
@@ -238,8 +233,12 @@
 			 const struct ip_conntrack *ignored_conntrack);
 
 /* Return conntrack_info and tuple hash for given skb. */
-extern struct ip_conntrack *
-ip_conntrack_get(struct sk_buff *skb, enum ip_conntrack_info *ctinfo);
+static inline struct ip_conntrack *
+ip_conntrack_get(const struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
+{
+	*ctinfo = skb->nfctinfo;
+	return (struct ip_conntrack *)skb->nfct;
+}
 
 /* decrement reference count on a conntrack */
 extern inline void ip_conntrack_put(struct ip_conntrack *ct);
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_core.h b/include/linux/netfilter_ipv4/ip_conntrack_core.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-09-20 11:57:45 +02:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-09-20 11:57:45 +02:00
@@ -38,14 +38,14 @@
 ip_conntrack_find_get(const struct ip_conntrack_tuple *tuple,
 		      const struct ip_conntrack *ignored_conntrack);
 
-extern int __ip_conntrack_confirm(struct nf_ct_info *nfct);
+extern int __ip_conntrack_confirm(struct sk_buff *skb);
 
 /* Confirm a connection: returns NF_DROP if packet must be dropped. */
 static inline int ip_conntrack_confirm(struct sk_buff *skb)
 {
 	if (skb->nfct
-	    && !is_confirmed((struct ip_conntrack *)skb->nfct->master))
-		return __ip_conntrack_confirm(skb->nfct);
+	    && !is_confirmed((struct ip_conntrack *)skb->nfct))
+		return __ip_conntrack_confirm(skb);
 	return NF_ACCEPT;
 }
 
diff -Nru a/include/linux/skbuff.h b/include/linux/skbuff.h
--- a/include/linux/skbuff.h	2004-09-20 11:57:45 +02:00
+++ b/include/linux/skbuff.h	2004-09-20 11:57:45 +02:00
@@ -97,10 +97,6 @@
 	void (*destroy)(struct nf_conntrack *);
 };
 
-struct nf_ct_info {
-	struct nf_conntrack *master;
-};
-
 #ifdef CONFIG_BRIDGE_NETFILTER
 struct nf_bridge_info {
 	atomic_t use;
@@ -186,6 +182,7 @@
  *	@nfmark: Can be used for communication between hooks
  *	@nfcache: Cache info
  *	@nfct: Associated connection, if any
+ *	@nfctinfo: Relationship of this skb to the connection
  *	@nf_debug: Netfilter debugging
  *	@nf_bridge: Saved data about a bridged frame - see br_netfilter.c
  *      @private: Data which is private to the HIPPI implementation
@@ -253,7 +250,8 @@
 #ifdef CONFIG_NETFILTER
         unsigned long		nfmark;
 	__u32			nfcache;
-	struct nf_ct_info	*nfct;
+	struct nf_conntrack	*nfct;
+	__u32			nfctinfo;
 #ifdef CONFIG_NETFILTER_DEBUG
         unsigned int		nf_debug;
 #endif
@@ -1141,15 +1139,15 @@
 extern void skb_iter_abort(const struct sk_buff *skb, struct skb_iter *i);
 
 #ifdef CONFIG_NETFILTER
-static inline void nf_conntrack_put(struct nf_ct_info *nfct)
+static inline void nf_conntrack_put(struct nf_conntrack *nfct)
 {
-	if (nfct && atomic_dec_and_test(&nfct->master->use))
-		nfct->master->destroy(nfct->master);
+	if (nfct && atomic_dec_and_test(&nfct->use))
+		nfct->destroy(nfct);
 }
-static inline void nf_conntrack_get(struct nf_ct_info *nfct)
+static inline void nf_conntrack_get(struct nf_conntrack *nfct)
 {
 	if (nfct)
-		atomic_inc(&nfct->master->use);
+		atomic_inc(&nfct->use);
 }
 static inline void nf_reset(struct sk_buff *skb)
 {
diff -Nru a/net/core/netfilter.c b/net/core/netfilter.c
--- a/net/core/netfilter.c	2004-09-20 11:57:45 +02:00
+++ b/net/core/netfilter.c	2004-09-20 11:57:45 +02:00
@@ -806,7 +806,7 @@
    tracking in use: without this, connection may not be in hash table,
    and hence manufactured ICMP or RST packets will not be associated
    with it. */
-void (*ip_ct_attach)(struct sk_buff *, struct nf_ct_info *);
+void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
 
 void __init netfilter_init(void)
 {
diff -Nru a/net/core/skbuff.c b/net/core/skbuff.c
--- a/net/core/skbuff.c	2004-09-20 11:57:45 +02:00
+++ b/net/core/skbuff.c	2004-09-20 11:57:45 +02:00
@@ -311,6 +311,7 @@
 	C(nfcache);
 	C(nfct);
 	nf_conntrack_get(skb->nfct);
+	C(nfctinfo);
 #ifdef CONFIG_NETFILTER_DEBUG
 	C(nf_debug);
 #endif
@@ -377,6 +378,7 @@
 	new->nfcache	= old->nfcache;
 	new->nfct	= old->nfct;
 	nf_conntrack_get(old->nfct);
+	new->nfctinfo	= old->nfctinfo;
 #ifdef CONFIG_NETFILTER_DEBUG
 	new->nf_debug	= old->nf_debug;
 #endif
diff -Nru a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c	2004-09-20 11:57:45 +02:00
+++ b/net/ipv4/ip_output.c	2004-09-20 11:57:45 +02:00
@@ -422,6 +422,7 @@
 	nf_conntrack_put(to->nfct);
 	to->nfct = from->nfct;
 	nf_conntrack_get(to->nfct);
+	to->nfctinfo = from->nfctinfo;
 #ifdef CONFIG_BRIDGE_NETFILTER
 	nf_bridge_put(to->nf_bridge);
 	to->nf_bridge = from->nf_bridge;
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 11:57:45 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 11:57:45 +02:00
@@ -112,10 +112,7 @@
 ip_conntrack_put(struct ip_conntrack *ct)
 {
 	IP_NF_ASSERT(ct);
-	IP_NF_ASSERT(ct->infos[0].master);
-	/* nf_conntrack_put wants to go via an info struct, so feed it
-           one at random. */
-	nf_conntrack_put(&ct->infos[0]);
+	nf_conntrack_put(&ct->ct_general);
 }
 
 static int ip_conntrack_hash_rnd_initted;
@@ -416,36 +413,15 @@
 	return h;
 }
 
-static inline struct ip_conntrack *
-__ip_conntrack_get(struct nf_ct_info *nfct, enum ip_conntrack_info *ctinfo)
-{
-	struct ip_conntrack *ct
-		= (struct ip_conntrack *)nfct->master;
-
-	/* ctinfo is the index of the nfct inside the conntrack */
-	*ctinfo = nfct - ct->infos;
-	IP_NF_ASSERT(*ctinfo >= 0 && *ctinfo < IP_CT_NUMBER);
-	return ct;
-}
-
-/* Return conntrack and conntrack_info given skb->nfct->master */
-struct ip_conntrack *
-ip_conntrack_get(struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
-{
-	if (skb->nfct) 
-		return __ip_conntrack_get(skb->nfct, ctinfo);
-	return NULL;
-}
-
-/* Confirm a connection given skb->nfct; places it in hash table */
+/* Confirm a connection given skb; places it in hash table */
 int
-__ip_conntrack_confirm(struct nf_ct_info *nfct)
+__ip_conntrack_confirm(struct sk_buff *skb)
 {
 	unsigned int hash, repl_hash;
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 
-	ct = __ip_conntrack_get(nfct, &ctinfo);
+	ct = ip_conntrack_get(skb, &ctinfo);
 
 	/* ipt_REJECT uses ip_conntrack_attach to attach related
 	   ICMP/TCP RST packets in other direction.  Actual packet
@@ -570,7 +546,6 @@
 	struct ip_conntrack_tuple repl_tuple;
 	size_t hash;
 	struct ip_conntrack_expect *expected;
-	int i;
 
 	if (!ip_conntrack_hash_rnd_initted) {
 		get_random_bytes(&ip_conntrack_hash_rnd, 4);
@@ -609,9 +584,6 @@
 	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].ctrack = conntrack;
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = repl_tuple;
 	conntrack->tuplehash[IP_CT_DIR_REPLY].ctrack = conntrack;
-	for (i=0; i < IP_CT_NUMBER; i++)
-		conntrack->infos[i].master = &conntrack->ct_general;
-
 	if (!protocol->new(conntrack, skb)) {
 		kmem_cache_free(ip_conntrack_cachep, conntrack);
 		return NULL;
@@ -655,7 +627,7 @@
 		expected->sibling = conntrack;
 		LIST_DELETE(&ip_conntrack_expect_list, expected);
 		expected->expectant->expecting--;
-		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
+		nf_conntrack_get(&master_ct(conntrack)->ct_general);
 
 		/* this is a braindead... --pablo */
 		atomic_inc(&ip_conntrack_count);
@@ -728,7 +700,8 @@
 		}
 		*set_reply = 0;
 	}
-	skb->nfct = &h->ctrack->infos[*ctinfo];
+	skb->nfct = &h->ctrack->ct_general;
+	skb->nfctinfo = *ctinfo;
 	return h->ctrack;
 }
 
@@ -1213,23 +1186,23 @@
 }
 
 /* Used by ipt_REJECT. */
-static void ip_conntrack_attach(struct sk_buff *nskb, struct nf_ct_info *nfct)
+static void ip_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 
-	ct = __ip_conntrack_get(nfct, &ctinfo);
-
-	/* This ICMP is in reverse direction to the packet which
-           caused it */
+	/* This ICMP is in reverse direction to the packet which caused it */
+	ct = ip_conntrack_get(skb, &ctinfo);
+	
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
 		ctinfo = IP_CT_RELATED + IP_CT_IS_REPLY;
 	else
 		ctinfo = IP_CT_RELATED;
 
-	/* Attach new skbuff, and increment count */
-	nskb->nfct = &ct->infos[ctinfo];
-	atomic_inc(&ct->ct_general.use);
+	/* Attach to new skbuff, and increment count */
+	nskb->nfct = &ct->ct_general;
+	nskb->nfctinfo = ctinfo;
+	nf_conntrack_get(nskb->nfct);
 }
 
 static inline int
@@ -1441,11 +1414,6 @@
 	atomic_set(&ip_conntrack_untracked.ct_general.use, 1);
 	/*  - and look it like as a confirmed connection */
 	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
-	/*  - and prepare the ctinfo field for REJECT & NAT. */
-	ip_conntrack_untracked.infos[IP_CT_NEW].master =
-	ip_conntrack_untracked.infos[IP_CT_RELATED].master =
-	ip_conntrack_untracked.infos[IP_CT_RELATED + IP_CT_IS_REPLY].master = 
-			&ip_conntrack_untracked.ct_general;
 
 	return ret;
 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-09-20 11:57:45 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-09-20 11:57:45 +02:00
@@ -195,7 +195,8 @@
 	}
 
 	/* Update skb to refer to this connection */
-	skb->nfct = &h->ctrack->infos[*ctinfo];
+	skb->nfct = &h->ctrack->ct_general;
+	skb->nfctinfo = *ctinfo;
 	return -NF_ACCEPT;
 }
 
diff -Nru a/net/ipv4/netfilter/ip_fw_compat_masq.c b/net/ipv4/netfilter/ip_fw_compat_masq.c
--- a/net/ipv4/netfilter/ip_fw_compat_masq.c	2004-09-20 11:57:45 +02:00
+++ b/net/ipv4/netfilter/ip_fw_compat_masq.c	2004-09-20 11:57:45 +02:00
@@ -146,7 +146,7 @@
 	case IPPROTO_ICMP:
 		/* ICMP errors. */
 		protocol->error(*pskb, &ctinfo, NF_IP_PRE_ROUTING);
-		ct = (struct ip_conntrack *)(*pskb)->nfct->master;
+		ct = (struct ip_conntrack *)(*pskb)->nfct;
 		if (ct) {
 			/* We only do SNAT in the compatibility layer.
 			   So we can manipulate ICMP errors from
@@ -187,7 +187,7 @@
 				      NULL, NULL, NULL);
 
 		/* Put back the reference gained from find_get */
-		nf_conntrack_put(&h->ctrack->infos[0]);
+		nf_conntrack_put(&h->ctrack->ct_general);
 		if (ret == NF_ACCEPT) {
 			struct ip_conntrack *ct;
 			ct = ip_conntrack_get(*pskb, &ctinfo);
@@ -206,7 +206,7 @@
 	} else {
 		if (h)
 			/* Put back the reference gained from find_get */
-			nf_conntrack_put(&h->ctrack->infos[0]);
+			nf_conntrack_put(&h->ctrack->ct_general);
 		ret = NF_ACCEPT;
 	}
 
diff -Nru a/net/ipv4/netfilter/ipt_NOTRACK.c b/net/ipv4/netfilter/ipt_NOTRACK.c
--- a/net/ipv4/netfilter/ipt_NOTRACK.c	2004-09-20 11:57:45 +02:00
+++ b/net/ipv4/netfilter/ipt_NOTRACK.c	2004-09-20 11:57:45 +02:00
@@ -23,7 +23,8 @@
 	   If there is a real ct entry correspondig to this packet, 
 	   it'll hang aroun till timing out. We don't deal with it
 	   for performance reasons. JK */
-	(*pskb)->nfct = &ip_conntrack_untracked.infos[IP_CT_NEW];
+	(*pskb)->nfct = &ip_conntrack_untracked.ct_general;
+	(*pskb)->nfctinfo = IP_CT_NEW;
 	nf_conntrack_get((*pskb)->nfct);
 
 	return IPT_CONTINUE;
diff -Nru a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
--- a/net/ipv4/netfilter/ipt_REJECT.c	2004-09-20 11:57:45 +02:00
+++ b/net/ipv4/netfilter/ipt_REJECT.c	2004-09-20 11:57:45 +02:00
@@ -41,14 +41,14 @@
 /* If the original packet is part of a connection, but the connection
    is not confirmed, our manufactured reply will not be associated
    with it, so we need to do this manually. */
-static void connection_attach(struct sk_buff *new_skb, struct nf_ct_info *nfct)
+static void connection_attach(struct sk_buff *new_skb, struct sk_buff *skb)
 {
-	void (*attach)(struct sk_buff *, struct nf_ct_info *);
+	void (*attach)(struct sk_buff *, struct sk_buff *);
 
 	/* Avoid module unload race with ip_ct_attach being NULLed out */
-	if (nfct && (attach = ip_ct_attach) != NULL) {
+	if (skb->nfct && (attach = ip_ct_attach) != NULL) {
 		mb(); /* Just to be sure: must be read before executing this */
-		attach(new_skb, nfct);
+		attach(new_skb, skb);
 	}
 }
 
@@ -209,7 +209,7 @@
 	if (nskb->len > dst_pmtu(nskb->dst))
 		goto free_nskb;
 
-	connection_attach(nskb, oldskb->nfct);
+	connection_attach(nskb, oldskb);
 
 	NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, nskb, NULL, nskb->dst->dev,
 		ip_finish_output);
@@ -360,7 +360,7 @@
 	icmph->checksum = ip_compute_csum((unsigned char *)icmph,
 					  length - sizeof(struct iphdr));
 
-	connection_attach(nskb, skb_in->nfct);
+	connection_attach(nskb, skb_in);
 
 	NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, nskb, NULL, nskb->dst->dev,
 		ip_finish_output);
diff -Nru a/net/ipv4/netfilter/ipt_conntrack.c b/net/ipv4/netfilter/ipt_conntrack.c
--- a/net/ipv4/netfilter/ipt_conntrack.c	2004-09-20 11:57:45 +02:00
+++ b/net/ipv4/netfilter/ipt_conntrack.c	2004-09-20 11:57:45 +02:00
@@ -35,7 +35,7 @@
 
 #define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
 
-	if (skb->nfct == &ip_conntrack_untracked.infos[IP_CT_NEW])
+	if (ct == &ip_conntrack_untracked)
 		statebit = IPT_CONNTRACK_STATE_UNTRACKED;
 	else if (ct)
  		statebit = IPT_CONNTRACK_STATE_BIT(ctinfo);
diff -Nru a/net/ipv4/netfilter/ipt_state.c b/net/ipv4/netfilter/ipt_state.c
--- a/net/ipv4/netfilter/ipt_state.c	2004-09-20 11:57:45 +02:00
+++ b/net/ipv4/netfilter/ipt_state.c	2004-09-20 11:57:45 +02:00
@@ -30,9 +30,9 @@
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
-	if (skb->nfct == &ip_conntrack_untracked.infos[IP_CT_NEW])
+	if (skb->nfct == &ip_conntrack_untracked.ct_general)
 		statebit = IPT_STATE_UNTRACKED;
-	else if (!ip_conntrack_get((struct sk_buff *)skb, &ctinfo))
+	else if (!ip_conntrack_get(skb, &ctinfo))
 		statebit = IPT_STATE_INVALID;
 	else
 		statebit = IPT_STATE_BIT(ctinfo);
diff -Nru a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
--- a/net/ipv6/ip6_output.c	2004-09-20 11:57:45 +02:00
+++ b/net/ipv6/ip6_output.c	2004-09-20 11:57:45 +02:00
@@ -477,6 +477,7 @@
 	/* Connection association is same as pre-frag packet */
 	to->nfct = from->nfct;
 	nf_conntrack_get(to->nfct);
+	to->nfctinfo = from->nfctinfo;
 #ifdef CONFIG_BRIDGE_NETFILTER
 	nf_bridge_put(to->nf_bridge);
 	to->nf_bridge = from->nf_bridge;

--------------080805030403060707040508--
