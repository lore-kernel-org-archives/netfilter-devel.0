From: Pablo Neira <pablo@eurodev.net>
Subject: [RFC PATCH] ctnetlink port to nf_conntrack take #1
Date: Mon, 14 Nov 2005 02:30:02 +0100
Message-ID: <4377E89A.5030205@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020307000201050804060100"
Cc: Harald Welte <laforge@netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------020307000201050804060100
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

This is a RFC. Attached two patches, the first contains the required
modifications for nf_conntrack in order to get nf_conntrack_netlink working.

The second patch is an incremental diff against ip_conntrack_netlink.c,
my intention with this patch is making easy your review. It clearly
shows the slighty modifications introduced to carry out the porting.

On the other hand, the whole C file (nf_netlink_conntrack.c) is
available at http://people.netfilter.org/pablo/nf_conntrack_netlink.c

-- 
Pablo

--------------020307000201050804060100
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index cc48256..64b82b7 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -94,6 +94,9 @@ struct nf_conn
 	/* Current number of expected connections */
 	unsigned int expecting;
 
+	/* Unique ID that identifies this conntrack*/
+	unsigned int id;
+
 	/* Helper. if any */
 	struct nf_conntrack_helper *helper;
 
@@ -140,6 +143,9 @@ struct nf_conntrack_expect
 	/* Usage count. */
 	atomic_t use;
 
+	/* Unique ID */
+	unsigned int id;
+
 	/* Flags */
 	unsigned int flags;
 
@@ -190,6 +196,31 @@ static inline void nf_ct_put(struct nf_c
 	nf_conntrack_put(&ct->ct_general);
 }
 
+extern struct nf_conntrack_tuple_hash *
+__nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
+		    const struct nf_conn *ignored_conntrack);
+
+extern void nf_conntrack_hash_insert(struct nf_conn *ct);
+
+extern struct nf_conntrack_expect *
+__nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
+
+extern struct nf_conntrack_expect *
+nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
+
+extern void nf_ct_unlink_expect(struct nf_conntrack_expect *exp);
+
+extern void nf_ct_remove_expectations(struct nf_conn *ct);
+
+extern void nf_conntrack_flush(void);
+
+extern struct nf_conntrack_helper *
+nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple);
+extern void nf_ct_helper_put(struct nf_conntrack_helper *helper);
+
+extern struct nf_conntrack_helper *
+__nf_conntrack_helper_find_byname(const char *name);
+
 /* call to create an explicit dependency on nf_conntrack. */
 extern void need_nf_conntrack(void);
 
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 5a66b2a..86ec817 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -33,6 +33,8 @@ struct nf_conntrack_helper
 		    unsigned int protoff,
 		    struct nf_conn *ct,
 		    enum ip_conntrack_info conntrackinfo);
+
+	int (*to_nfattr)(struct sk_buff *skb, const struct nf_conn *ct);
 };
 
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
diff --git a/include/net/netfilter/nf_conntrack_protocol.h b/include/net/netfilter/nf_conntrack_protocol.h
index b3afda3..41e357d 100644
--- a/include/net/netfilter/nf_conntrack_protocol.h
+++ b/include/net/netfilter/nf_conntrack_protocol.h
@@ -12,6 +12,7 @@
 #include <net/netfilter/nf_conntrack.h>
 
 struct seq_file;
+struct nfattr;
 
 struct nf_conntrack_protocol
 {
@@ -66,6 +67,18 @@ struct nf_conntrack_protocol
 		     enum ip_conntrack_info *ctinfo,
 		     int pf, unsigned int hooknum);
 
+	/* convert protoinfo to nfnetink attributes */
+	int (*to_nfattr)(struct sk_buff *skb, struct nfattr *nfa,
+			 const struct nf_conn *ct);
+
+	/* convert nfnetlink attributes to protoinfo */
+	int (*from_nfattr)(struct nfattr *tb[], struct nf_conn *ct);
+
+	int (*tuple_to_nfattr)(struct sk_buff *skb,
+			       const struct nf_conntrack_tuple *t);
+	int (*nfattr_to_tuple)(struct nfattr *tb[],
+			       struct nf_conntrack_tuple *t);
+
 	/* Module (if any) which this is connected to. */
 	struct module *me;
 };
@@ -82,10 +95,21 @@ extern struct nf_conntrack_protocol **nf
 extern struct nf_conntrack_protocol *
 nf_ct_find_proto(u_int16_t l3proto, u_int8_t protocol);
 
+extern struct nf_conntrack_protocol *
+nf_ct_proto_find_get(u_int16_t l3proto, u_int8_t protocol);
+
+extern void nf_ct_proto_put(struct nf_conntrack_protocol *p);
+
 /* Protocol registration. */
 extern int nf_conntrack_protocol_register(struct nf_conntrack_protocol *proto);
 extern void nf_conntrack_protocol_unregister(struct nf_conntrack_protocol *proto);
 
+/* Generic netlink helpers */
+extern int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
+				      const struct nf_conntrack_tuple *tuple);
+extern int nf_ct_port_nfattr_to_tuple(struct nfattr *tb[],
+				      struct nf_conntrack_tuple *t);
+
 /* Log invalid packets */
 extern unsigned int nf_ct_log_invalid;
 
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 7ddb5c0..b1b5c42 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -116,16 +116,16 @@ static int icmp_packet(struct nf_conn *c
 	return NF_ACCEPT;
 }
 
+static u_int8_t valid_new[]
+	= { [ICMP_ECHO] = 1,
+	    [ICMP_TIMESTAMP] = 1,
+	    [ICMP_INFO_REQUEST] = 1,
+	    [ICMP_ADDRESS] = 1 };
+
 /* Called when a new connection for this protocol found. */
 static int icmp_new(struct nf_conn *conntrack,
 		    const struct sk_buff *skb, unsigned int dataoff)
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
@@ -281,6 +281,51 @@ checksum_skipped:
 	return icmp_error_message(skb, ctinfo, hooknum);
 }
 
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+static int icmp_tuple_to_nfattr(struct sk_buff *skb,
+				const struct nf_conntrack_tuple *t)
+{
+	NFA_PUT(skb, CTA_PROTO_ICMP_ID, sizeof(u_int16_t),
+		&t->src.u.icmp.id);
+	NFA_PUT(skb, CTA_PROTO_ICMP_TYPE, sizeof(u_int8_t),
+		&t->dst.u.icmp.type);
+	NFA_PUT(skb, CTA_PROTO_ICMP_CODE, sizeof(u_int8_t),
+		&t->dst.u.icmp.code);
+
+	if (t->dst.u.icmp.type >= sizeof(valid_new) 
+	    || !valid_new[t->dst.u.icmp.type])
+		return -EINVAL;
+
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static int icmp_nfattr_to_tuple(struct nfattr *tb[],
+				struct nf_conntrack_tuple *tuple)
+{
+	if (!tb[CTA_PROTO_ICMP_TYPE-1]
+	    || !tb[CTA_PROTO_ICMP_CODE-1]
+	    || !tb[CTA_PROTO_ICMP_ID-1])
+		return -1;
+
+	tuple->dst.u.icmp.type = 
+			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);
+	tuple->dst.u.icmp.code =
+			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
+	tuple->src.u.icmp.id =
+			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
+
+	return 0;
+}
+#endif
+
 struct nf_conntrack_protocol nf_conntrack_protocol_icmp =
 {
 	.list			= { NULL, NULL },
@@ -295,7 +340,12 @@ struct nf_conntrack_protocol nf_conntrac
 	.new			= icmp_new,
 	.error			= icmp_error,
 	.destroy		= NULL,
-	.me			= NULL
+	.me			= NULL,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.tuple_to_nfattr	= icmp_tuple_to_nfattr,
+	.nfattr_to_tuple	= icmp_nfattr_to_tuple,
+#endif
 };
 
 EXPORT_SYMBOL(nf_conntrack_protocol_icmp);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a84f922..eaab979 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -95,4 +95,11 @@ config NF_CONNTRACK_FTP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CT_NETLINK
+	tristate 'Connection tracking netlink interface'
+	depends on NF_CONNTRACK && NETFILTER_NETLINK
+	depends on NF_CONNTRACK!=y || NETFILTER_NETLINK!=m
+	help
+	  This option enables support for a netlink-based userspace interface
+
 endmenu
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 55f019a..cb21831 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -13,3 +13,6 @@ obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_con
 
 # SCTP protocol connection tracking
 obj-$(CONFIG_NF_CT_PROTO_SCTP) += nf_conntrack_proto_sctp.o
+
+# netlink interface for nf_conntrack
+obj-$(CONFIG_NF_CT_NETLINK) += nf_conntrack_netlink.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9a67c79..2e23230 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -82,6 +82,8 @@ unsigned int nf_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc;
 
+static unsigned int nf_conntrack_next_id = 1;
+static unsigned int nf_conntrack_expect_next_id = 1;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 struct notifier_block *nf_conntrack_chain;
 struct notifier_block *nf_conntrack_expect_chain;
@@ -192,6 +194,29 @@ nf_ct_find_proto(u_int16_t l3proto, u_in
 	return nf_ct_protos[l3proto][protocol];
 }
 
+/* this is guaranteed to always return a valid protocol helper, since
+ * it falls back to generic_protocol */
+struct nf_conntrack_protocol *
+nf_ct_proto_find_get(u_int16_t l3proto, u_int8_t protocol)
+{
+	struct nf_conntrack_protocol *p;
+
+	preempt_disable();
+	p = nf_ct_find_proto(l3proto, protocol);
+	if (p) {
+		if (!try_module_get(p->me))
+			p = &nf_conntrack_generic_protocol;
+	}
+	preempt_enable();
+	
+	return p;
+}
+
+void nf_ct_proto_put(struct nf_conntrack_protocol *p)
+{
+	module_put(p->me);
+}
+
 static int nf_conntrack_hash_rnd_initted;
 static unsigned int nf_conntrack_hash_rnd;
 
@@ -384,7 +409,7 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 }
 
 /* nf_conntrack_expect helper functions */
-static void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
+void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 {
 	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
 	NF_CT_ASSERT(!timer_pending(&exp_timeout));
@@ -404,6 +429,33 @@ static void expectation_timed_out(unsign
 	nf_conntrack_expect_put(exp);
 }
 
+struct nf_conntrack_expect *
+__nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_expect *i;
+	
+	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
+		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)) {
+			atomic_inc(&i->use);
+			return i;
+		}
+	}
+	return NULL;
+}
+
+/* Just find a expectation corresponding to a tuple. */
+struct nf_conntrack_expect *
+nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_expect *i;
+	
+	read_lock_bh(&nf_conntrack_lock);
+	i = __nf_conntrack_expect_find(tuple);
+	read_unlock_bh(&nf_conntrack_lock);
+
+	return i;
+}
+
 /* If an expectation for this connection is found, it gets delete from
  * global list then returned. */
 static struct nf_conntrack_expect *
@@ -432,7 +484,7 @@ find_expectation(const struct nf_conntra
 }
 
 /* delete all expectations for this conntrack */
-static void remove_expectations(struct nf_conn *ct)
+void nf_ct_remove_expectations(struct nf_conn *ct)
 {
 	struct nf_conntrack_expect *i, *tmp;
 
@@ -462,7 +514,7 @@ clean_from_lists(struct nf_conn *ct)
 	LIST_DELETE(&nf_conntrack_hash[hr], &ct->tuplehash[IP_CT_DIR_REPLY]);
 
 	/* Destroy all pending expectations */
-	remove_expectations(ct);
+	nf_ct_remove_expectations(ct);
 }
 
 static void
@@ -499,7 +551,7 @@ destroy_conntrack(struct nf_conntrack *n
 	 * except TFTP can create an expectation on the first packet,
 	 * before connection is in the list, so we need to clean here,
 	 * too. */
-	remove_expectations(ct);
+	nf_ct_remove_expectations(ct);
 
 	/* We overload first tuple to link into unconfirmed list. */
 	if (!nf_ct_is_confirmed(ct)) {
@@ -540,7 +592,7 @@ conntrack_tuple_cmp(const struct nf_conn
 		&& nf_ct_tuple_equal(tuple, &i->tuple);
 }
 
-static struct nf_conntrack_tuple_hash *
+struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_conn *ignored_conntrack)
 {
@@ -575,6 +627,29 @@ nf_conntrack_find_get(const struct nf_co
 	return h;
 }
 
+static void __nf_conntrack_hash_insert(struct nf_conn *ct,
+				       unsigned int hash,
+				       unsigned int repl_hash) 
+{
+	ct->id = ++nf_conntrack_next_id;
+	list_prepend(&nf_conntrack_hash[hash],
+		     &ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+	list_prepend(&nf_conntrack_hash[repl_hash],
+		     &ct->tuplehash[IP_CT_DIR_REPLY].list);
+}
+
+void nf_conntrack_hash_insert(struct nf_conn *ct)
+{
+	unsigned int hash, repl_hash;
+
+	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+
+	write_lock_bh(&nf_conntrack_lock);
+	__nf_conntrack_hash_insert(ct, hash, repl_hash);
+	write_unlock_bh(&nf_conntrack_lock);
+}
+
 /* Confirm a connection given skb; places it in hash table */
 int
 __nf_conntrack_confirm(struct sk_buff **pskb)
@@ -621,10 +696,7 @@ __nf_conntrack_confirm(struct sk_buff **
 		/* Remove from unconfirmed list */
 		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 
-		list_prepend(&nf_conntrack_hash[hash],
-			     &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
-		list_prepend(&nf_conntrack_hash[repl_hash],
-			     &ct->tuplehash[IP_CT_DIR_REPLY]);
+		__nf_conntrack_hash_insert(ct, hash, repl_hash);
 		/* Timer relative to confirmation time, not original
 		   setting time, otherwise we'd get timer wrap in
 		   weird delay cases. */
@@ -715,6 +787,34 @@ nf_ct_find_helper(const struct nf_conntr
 			 tuple);
 }
 
+struct nf_conntrack_helper *
+nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_helper *helper;
+
+	/* need ip_conntrack_lock to assure that helper exists until
+	 * try_module_get() is called */
+	read_lock_bh(&nf_conntrack_lock);
+
+	helper = nf_ct_find_helper(tuple);
+	if (helper) {
+		/* need to increase module usage count to assure helper will
+		 * not go away while the caller is e.g. busy putting a
+		 * conntrack in the hash that uses the helper */
+		if (!try_module_get(helper->me))
+			helper = NULL;
+	}
+
+	read_unlock_bh(&nf_conntrack_lock);
+
+	return helper;
+}
+
+void nf_ct_helper_put(struct nf_conntrack_helper *helper)
+{
+	module_put(helper->me);
+}
+
 static struct nf_conn *
 __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 		     const struct nf_conntrack_tuple *repl,
@@ -1096,6 +1196,7 @@ static void nf_conntrack_expect_insert(s
 	exp->timeout.expires = jiffies + exp->master->helper->timeout * HZ;
 	add_timer(&exp->timeout);
 
+	exp->id = ++nf_conntrack_expect_next_id;
 	atomic_inc(&exp->use);
 	NF_CT_STAT_INC(expect_create);
 }
@@ -1200,6 +1301,19 @@ int nf_conntrack_helper_register(struct 
 	return 0;
 }
 
+struct nf_conntrack_helper *
+__nf_conntrack_helper_find_byname(const char *name)
+{
+	struct nf_conntrack_helper *h;
+
+	list_for_each_entry(h, &helpers, list) {
+		if (!strcmp(h->name, name))
+			return h;
+	}
+
+	return NULL;
+}
+
 static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 			 const struct nf_conntrack_helper *me)
 {
@@ -1283,6 +1397,43 @@ void __nf_ct_refresh_acct(struct nf_conn
 		nf_conntrack_event_cache(event, skb);
 }
 
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+/* Generic function for tcp/udp/sctp/dccp and alike. This needs to be
+ * in ip_conntrack_core, since we don't want the protocols to autoload
+ * or depend on ctnetlink */
+int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
+			       const struct nf_conntrack_tuple *tuple)
+{
+	NFA_PUT(skb, CTA_PROTO_SRC_PORT, sizeof(u_int16_t),
+		&tuple->src.u.tcp.port);
+	NFA_PUT(skb, CTA_PROTO_DST_PORT, sizeof(u_int16_t),
+		&tuple->dst.u.tcp.port);
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+int nf_ct_port_nfattr_to_tuple(struct nfattr *tb[],
+			       struct nf_conntrack_tuple *t)
+{
+	if (!tb[CTA_PROTO_SRC_PORT-1] || !tb[CTA_PROTO_DST_PORT-1])
+		return -EINVAL;
+
+	t->src.u.tcp.port =
+		*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_SRC_PORT-1]);
+	t->dst.u.tcp.port =
+		*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_DST_PORT-1]);
+
+	return 0;
+}
+#endif
+
 /* Used by ipt_REJECT and ip6t_REJECT. */
 void __nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb)
 {
@@ -1365,12 +1516,8 @@ static void free_conntrack_hash(struct l
 			   get_order(sizeof(struct list_head) * size));
 }
 
-/* Mishearing the voices in his head, our hero wonders how he's
-   supposed to kill the mall. */
-void nf_conntrack_cleanup(void)
+void nf_conntrack_flush()
 {
-	int i;
-
 	/* This makes sure all current packets have passed through
 	   netfilter framework.  Roll on, two-stage module
 	   delete... */
@@ -1383,6 +1530,18 @@ void nf_conntrack_cleanup(void)
 		schedule();
 		goto i_see_dead_people;
 	}
+	/* wait until all references to ip_conntrack_untracked are dropped */
+	while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
+		schedule();
+}
+
+/* Mishearing the voices in his head, our hero wonders how he's
+   supposed to kill the mall. */
+void nf_conntrack_cleanup(void)
+{
+	int i;
+
+	nf_conntrack_flush();
 
 	for (i = 0; i < NF_CT_F_NUM; i++) {
 		if (nf_ct_cache[i].use == 0)
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 5a6fcf3..2636f9b 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1136,6 +1136,62 @@ static int tcp_new(struct nf_conn *connt
 		receiver->td_scale);
 	return 1;
 }
+
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+static int tcp_to_nfattr(struct sk_buff *skb, struct nfattr *nfa,
+			 const struct nf_conn *ct)
+{
+	struct nfattr *nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
+	
+	read_lock_bh(&tcp_lock);
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
+		&ct->proto.tcp.state);
+	read_unlock_bh(&tcp_lock);
+
+	NFA_NEST_END(skb, nest_parms);
+
+	return 0;
+
+nfattr_failure:
+	read_unlock_bh(&tcp_lock);
+	return -1;
+}
+
+static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX] = {
+	[CTA_PROTOINFO_TCP_STATE-1]	= sizeof(u_int8_t),
+};
+
+static int nfattr_to_tcp(struct nfattr *cda[], struct nf_conn *ct)
+{
+	struct nfattr *attr = cda[CTA_PROTOINFO_TCP-1];
+	struct nfattr *tb[CTA_PROTOINFO_TCP_MAX];
+
+	/* updates could not contain anything about the private
+	 * protocol info, in that case skip the parsing */
+	if (!attr)
+		return 0;
+
+        nfattr_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr);
+
+	if (nfattr_bad_size(tb, CTA_PROTOINFO_TCP_MAX, cta_min_tcp))
+		return -EINVAL;
+
+	if (!tb[CTA_PROTOINFO_TCP_STATE-1])
+		return -EINVAL;
+
+	write_lock_bh(&tcp_lock);
+	ct->proto.tcp.state = 
+		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+	write_unlock_bh(&tcp_lock);
+
+	return 0;
+}
+#endif
   
 struct nf_conntrack_protocol nf_conntrack_protocol_tcp4 =
 {
@@ -1149,6 +1205,13 @@ struct nf_conntrack_protocol nf_conntrac
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
 	.error			= tcp_error4,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.to_nfattr		= tcp_to_nfattr,
+	.from_nfattr		= nfattr_to_tcp,
+	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
+	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+#endif
 };
 
 struct nf_conntrack_protocol nf_conntrack_protocol_tcp6 =
@@ -1163,6 +1226,13 @@ struct nf_conntrack_protocol nf_conntrac
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
 	.error			= tcp_error6,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.to_nfattr		= tcp_to_nfattr,
+	.from_nfattr		= nfattr_to_tcp,
+	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
+	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+#endif
 };
 
 EXPORT_SYMBOL(nf_conntrack_protocol_tcp4);
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 3cae7ce..1a592a5 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -196,6 +196,11 @@ struct nf_conntrack_protocol nf_conntrac
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error4,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
+	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+#endif
 };
 
 struct nf_conntrack_protocol nf_conntrack_protocol_udp6 =
@@ -210,6 +215,11 @@ struct nf_conntrack_protocol nf_conntrac
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error6,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
+	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+#endif
 };
 
 EXPORT_SYMBOL(nf_conntrack_protocol_udp4);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 45224db..6c1ff41 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -848,6 +848,8 @@ EXPORT_SYMBOL(nf_ct_iterate_cleanup);
 EXPORT_SYMBOL(__nf_ct_refresh_acct);
 EXPORT_SYMBOL(nf_ct_protos);
 EXPORT_SYMBOL(nf_ct_find_proto);
+EXPORT_SYMBOL(nf_ct_proto_find_get);
+EXPORT_SYMBOL(nf_ct_proto_put);
 EXPORT_SYMBOL(nf_ct_l3protos);
 EXPORT_SYMBOL(nf_conntrack_expect_alloc);
 EXPORT_SYMBOL(nf_conntrack_expect_put);
@@ -867,3 +869,18 @@ EXPORT_SYMBOL(nf_ct_get_tuple);
 EXPORT_SYMBOL(nf_ct_invert_tuple);
 EXPORT_SYMBOL(nf_conntrack_in);
 EXPORT_SYMBOL(__nf_conntrack_attach);
+EXPORT_SYMBOL(nf_conntrack_alloc);
+EXPORT_SYMBOL(nf_conntrack_free);
+EXPORT_SYMBOL(nf_conntrack_flush);
+EXPORT_SYMBOL(nf_ct_remove_expectations);
+EXPORT_SYMBOL(nf_ct_helper_find_get);
+EXPORT_SYMBOL(nf_ct_helper_put);
+EXPORT_SYMBOL(__nf_conntrack_helper_find_byname);
+EXPORT_SYMBOL(__nf_conntrack_find);
+EXPORT_SYMBOL(nf_ct_unlink_expect);
+EXPORT_SYMBOL(nf_conntrack_hash_insert);
+EXPORT_SYMBOL(__nf_conntrack_expect_find);
+EXPORT_SYMBOL(nf_conntrack_expect_find);
+EXPORT_SYMBOL(nf_conntrack_expect_list);
+EXPORT_SYMBOL(nf_ct_port_tuple_to_nfattr);
+EXPORT_SYMBOL(nf_ct_port_nfattr_to_tuple);

--------------020307000201050804060100
Content-Type: text/plain;
 name="y"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="y"

--- netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-13 19:00:07.000000000 +0100
+++ netfilter-2.6.14.git/net/netfilter/nf_conntrack_netlink.c	2005-11-14 02:16:27.000000000 +0100
@@ -16,6 +16,8 @@
  *
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
+ *
+ * Derived from ip_conntrack_netlink.c: Port by Pablo Neira Ayuso (05/11/14)
  */
 
 #include <linux/init.h>
@@ -30,10 +32,10 @@
 #include <linux/notifier.h>
 
 #include <linux/netfilter.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
-#include <linux/netfilter_ipv4/ip_conntrack_core.h>
-#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
-#include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_nat_protocol.h>
 
 #include <linux/netfilter/nfnetlink.h>
@@ -41,7 +43,7 @@
 
 MODULE_LICENSE("GPL");
 
-static char __initdata version[] = "0.90";
+static char __initdata version[] = "0.92";
 
 #if 0
 #define DEBUGP printk
@@ -52,17 +54,17 @@
 
 static inline int
 ctnetlink_dump_tuples_proto(struct sk_buff *skb, 
-			    const struct ip_conntrack_tuple *tuple)
+			    const struct nf_conntrack_tuple *tuple)
 {
-	struct ip_conntrack_protocol *proto;
+	struct nf_conntrack_protocol *proto;
 	int ret = 0;
 
 	NFA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
 
-	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
+	proto = nf_ct_proto_find_get(tuple->src.l3num, tuple->dst.protonum);
 	if (likely(proto && proto->tuple_to_nfattr)) {
 		ret = proto->tuple_to_nfattr(skb, tuple);
-		ip_conntrack_proto_put(proto);
+		nf_ct_proto_put(proto);
 	}
 
 	return ret;
@@ -73,13 +75,13 @@
 
 static inline int
 ctnetlink_dump_tuples(struct sk_buff *skb, 
-		      const struct ip_conntrack_tuple *tuple)
+		      const struct nf_conntrack_tuple *tuple)
 {
 	struct nfattr *nest_parms;
 	
 	nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
-	NFA_PUT(skb, CTA_IP_V4_SRC, sizeof(u_int32_t), &tuple->src.ip);
-	NFA_PUT(skb, CTA_IP_V4_DST, sizeof(u_int32_t), &tuple->dst.ip);
+	NFA_PUT(skb, CTA_IP_V4_SRC, sizeof(u_int32_t), &tuple->src.u3.ip);
+	NFA_PUT(skb, CTA_IP_V4_DST, sizeof(u_int32_t), &tuple->dst.u3.ip);
 	NFA_NEST_END(skb, nest_parms);
 
 	nest_parms = NFA_NEST(skb, CTA_TUPLE_PROTO);
@@ -93,7 +95,7 @@
 }
 
 static inline int
-ctnetlink_dump_status(struct sk_buff *skb, const struct ip_conntrack *ct)
+ctnetlink_dump_status(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	u_int32_t status = htonl((u_int32_t) ct->status);
 	NFA_PUT(skb, CTA_STATUS, sizeof(status), &status);
@@ -104,7 +106,7 @@
 }
 
 static inline int
-ctnetlink_dump_timeout(struct sk_buff *skb, const struct ip_conntrack *ct)
+ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	long timeout_l = ct->timeout.expires - jiffies;
 	u_int32_t timeout;
@@ -122,10 +124,9 @@
 }
 
 static inline int
-ctnetlink_dump_protoinfo(struct sk_buff *skb, const struct ip_conntrack *ct)
+ctnetlink_dump_protoinfo(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	struct ip_conntrack_protocol *proto = ip_conntrack_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
-
+	struct nf_conntrack_protocol *proto = nf_ct_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num, ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
 	struct nfattr *nest_proto;
 	int ret;
 	
@@ -136,7 +137,7 @@
 
 	ret = proto->to_nfattr(skb, nest_proto, ct);
 
-	ip_conntrack_proto_put(proto);
+	nf_ct_proto_put(proto);
 
 	NFA_NEST_END(skb, nest_proto);
 
@@ -147,7 +148,7 @@
 }
 
 static inline int
-ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct ip_conntrack *ct)
+ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	struct nfattr *nest_helper;
 
@@ -168,9 +169,9 @@
 	return -1;
 }
 
-#ifdef CONFIG_IP_NF_CT_ACCT
+#ifdef CONFIG_NF_CT_ACCT
 static inline int
-ctnetlink_dump_counters(struct sk_buff *skb, const struct ip_conntrack *ct,
+ctnetlink_dump_counters(struct sk_buff *skb, const struct nf_conn *ct,
 			enum ip_conntrack_dir dir)
 {
 	enum ctattr_type type = dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
@@ -194,9 +195,9 @@
 #define ctnetlink_dump_counters(a, b, c) (0)
 #endif
 
-#ifdef CONFIG_IP_NF_CONNTRACK_MARK
+#ifdef CONFIG_NF_CONNTRACK_MARK
 static inline int
-ctnetlink_dump_mark(struct sk_buff *skb, const struct ip_conntrack *ct)
+ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	u_int32_t mark = htonl(ct->mark);
 
@@ -211,7 +212,7 @@
 #endif
 
 static inline int
-ctnetlink_dump_id(struct sk_buff *skb, const struct ip_conntrack *ct)
+ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	u_int32_t id = htonl(ct->id);
 	NFA_PUT(skb, CTA_ID, sizeof(u_int32_t), &id);
@@ -222,7 +223,7 @@
 }
 
 static inline int
-ctnetlink_dump_use(struct sk_buff *skb, const struct ip_conntrack *ct)
+ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	unsigned int use = htonl(atomic_read(&ct->ct_general.use));
 	
@@ -238,7 +239,7 @@
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 		    int event, int nowait, 
-		    const struct ip_conntrack *ct)
+		    const struct nf_conn *ct)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
@@ -252,7 +253,8 @@
 	nfmsg  = NLMSG_DATA(nlh);
 
 	nlh->nlmsg_flags    = (nowait && pid) ? NLM_F_MULTI : 0;
-	nfmsg->nfgen_family = AF_INET;
+	nfmsg->nfgen_family = 
+		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	nfmsg->version      = NFNETLINK_V0;
 	nfmsg->res_id	    = 0;
 
@@ -286,21 +288,21 @@
 	return -1;
 }
 
-#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 static int ctnetlink_conntrack_event(struct notifier_block *this,
                                      unsigned long events, void *ptr)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	struct nfattr *nest_parms;
-	struct ip_conntrack *ct = (struct ip_conntrack *)ptr;
+	struct nf_conn *ct = (struct nf_conn *)ptr;
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned char *b;
 	unsigned int flags = 0, group;
 
 	/* ignore our fake conntrack entry */
-	if (ct == &ip_conntrack_untracked)
+	if (ct == &nf_conntrack_untracked)
 		return NOTIFY_DONE;
 
 	if (events & IPCT_DESTROY) {
@@ -383,7 +385,7 @@
 	kfree_skb(skb);
 	return NOTIFY_DONE;
 }
-#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+#endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
 static int ctnetlink_done(struct netlink_callback *cb)
 {
@@ -394,21 +396,21 @@
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct ip_conntrack *ct = NULL;
-	struct ip_conntrack_tuple_hash *h;
+	struct nf_conn *ct = NULL;
+	struct nf_conntrack_tuple_hash *h;
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[1];
 
 	DEBUGP("entered %s, last bucket=%lu id=%u\n", __FUNCTION__, 
 			cb->args[0], *id);
 
-	read_lock_bh(&ip_conntrack_lock);
-	for (; cb->args[0] < ip_conntrack_htable_size; cb->args[0]++, *id = 0) {
-		list_for_each_prev(i, &ip_conntrack_hash[cb->args[0]]) {
-			h = (struct ip_conntrack_tuple_hash *) i;
+	read_lock_bh(&nf_conntrack_lock);
+	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++, *id = 0) {
+		list_for_each_prev(i, &nf_conntrack_hash[cb->args[0]]) {
+			h = (struct nf_conntrack_tuple_hash *) i;
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
-			ct = tuplehash_to_ctrack(h);
+			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (ct->id <= *id)
 				continue;
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -420,32 +422,32 @@
 		}
 	}
 out:	
-	read_unlock_bh(&ip_conntrack_lock);
+	read_unlock_bh(&nf_conntrack_lock);
 
 	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
 
 	return skb->len;
 }
 
-#ifdef CONFIG_IP_NF_CT_ACCT
+#ifdef CONFIG_NF_CT_ACCT
 static int
 ctnetlink_dump_table_w(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct ip_conntrack *ct = NULL;
-	struct ip_conntrack_tuple_hash *h;
+	struct nf_conn *ct = NULL;
+	struct nf_conntrack_tuple_hash *h;
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[1];
 
 	DEBUGP("entered %s, last bucket=%u id=%u\n", __FUNCTION__, 
 			cb->args[0], *id);
 
-	write_lock_bh(&ip_conntrack_lock);
-	for (; cb->args[0] < ip_conntrack_htable_size; cb->args[0]++, *id = 0) {
-		list_for_each_prev(i, &ip_conntrack_hash[cb->args[0]]) {
-			h = (struct ip_conntrack_tuple_hash *) i;
+	write_lock_bh(&nf_conntrack_lock);
+	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++, *id = 0) {
+		list_for_each_prev(i, &nf_conntrack_hash[cb->args[0]]) {
+			h = (struct nf_conntrack_tuple_hash *) i;
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
-			ct = tuplehash_to_ctrack(h);
+			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (ct->id <= *id)
 				continue;
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -459,7 +461,7 @@
 		}
 	}
 out:	
-	write_unlock_bh(&ip_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 
 	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
 
@@ -473,7 +475,7 @@
 };
 
 static inline int
-ctnetlink_parse_tuple_ip(struct nfattr *attr, struct ip_conntrack_tuple *tuple)
+ctnetlink_parse_tuple_ip(struct nfattr *attr, struct nf_conntrack_tuple *tuple)
 {
 	struct nfattr *tb[CTA_IP_MAX];
 
@@ -486,11 +488,11 @@
 
 	if (!tb[CTA_IP_V4_SRC-1])
 		return -EINVAL;
-	tuple->src.ip = *(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_SRC-1]);
+	tuple->src.u3.ip = *(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_SRC-1]);
 
 	if (!tb[CTA_IP_V4_DST-1])
 		return -EINVAL;
-	tuple->dst.ip = *(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_DST-1]);
+	tuple->dst.u3.ip = *(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_DST-1]);
 
 	DEBUGP("leaving\n");
 
@@ -508,10 +510,10 @@
 
 static inline int
 ctnetlink_parse_tuple_proto(struct nfattr *attr, 
-			    struct ip_conntrack_tuple *tuple)
+			    struct nf_conntrack_tuple *tuple)
 {
 	struct nfattr *tb[CTA_PROTO_MAX];
-	struct ip_conntrack_protocol *proto;
+	struct nf_conntrack_protocol *proto;
 	int ret = 0;
 
 	DEBUGP("entered %s\n", __FUNCTION__);
@@ -525,19 +527,19 @@
 		return -EINVAL;
 	tuple->dst.protonum = *(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
 
-	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
+	proto = nf_ct_proto_find_get(tuple->src.l3num, tuple->dst.protonum);
 
 	if (likely(proto && proto->nfattr_to_tuple)) {
 		ret = proto->nfattr_to_tuple(tb, tuple);
-		ip_conntrack_proto_put(proto);
+		nf_ct_proto_put(proto);
 	}
 	
 	return ret;
 }
 
 static inline int
-ctnetlink_parse_tuple(struct nfattr *cda[], struct ip_conntrack_tuple *tuple,
-		      enum ctattr_tuple type)
+ctnetlink_parse_tuple(struct nfattr *cda[], struct nf_conntrack_tuple *tuple,
+		      enum ctattr_tuple type, u_int8_t l3num)
 {
 	struct nfattr *tb[CTA_TUPLE_MAX];
 	int err;
@@ -555,6 +557,8 @@
 	if (err < 0)
 		return err;
 
+	tuple->src.l3num = l3num;
+
 	if (!tb[CTA_TUPLE_PROTO-1])
 		return -EINVAL;
 
@@ -568,7 +572,7 @@
 	else
 		tuple->dst.dir = IP_CT_DIR_ORIGINAL;
 
-	DUMP_TUPLE(tuple);
+	NF_CT_DUMP_TUPLE(tuple);
 
 	DEBUGP("leaving\n");
 
@@ -582,7 +586,7 @@
 };
 
 static int ctnetlink_parse_nat_proto(struct nfattr *attr,
-				     const struct ip_conntrack *ct,
+				     const struct nf_conn *ct,
 				     struct ip_nat_range *range)
 {
 	struct nfattr *tb[CTA_PROTONAT_MAX];
@@ -621,7 +625,7 @@
 
 static inline int
 ctnetlink_parse_nat(struct nfattr *cda[],
-		    const struct ip_conntrack *ct, struct ip_nat_range *range)
+		    const struct nf_conn *ct, struct ip_nat_range *range)
 {
 	struct nfattr *tb[CTA_NAT_MAX];
 	int err;
@@ -687,9 +691,11 @@
 ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb, 
 			struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
-	struct ip_conntrack_tuple_hash *h;
-	struct ip_conntrack_tuple tuple;
-	struct ip_conntrack *ct;
+	struct nf_conntrack_tuple_hash *h;
+	struct nf_conntrack_tuple tuple;
+	struct nf_conn *ct;
+	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
 	DEBUGP("entered %s\n", __FUNCTION__);
@@ -698,39 +704,39 @@
 		return -EINVAL;
 
 	if (cda[CTA_TUPLE_ORIG-1])
-		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG);
+		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG, u3);
 	else if (cda[CTA_TUPLE_REPLY-1])
-		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY);
+		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY, u3);
 	else {
 		/* Flush the whole table */
-		ip_conntrack_flush();
+		nf_conntrack_flush();
 		return 0;
 	}
 
 	if (err < 0)
 		return err;
 
-	h = ip_conntrack_find_get(&tuple, NULL);
+	h = nf_conntrack_find_get(&tuple, NULL);
 	if (!h) {
 		DEBUGP("tuple not found in conntrack hash\n");
 		return -ENOENT;
 	}
 
-	ct = tuplehash_to_ctrack(h);
+	ct = nf_ct_tuplehash_to_ctrack(h);
 	
 	if (cda[CTA_ID-1]) {
 		u_int32_t id = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_ID-1]));
 		if (ct->id != id) {
-			ip_conntrack_put(ct);
+			nf_ct_put(ct);
 			return -ENOENT;
 		}
 	}	
 	if (del_timer(&ct->timeout)) {
-		ip_conntrack_put(ct);
+		nf_ct_put(ct);
 		ct->timeout.function((unsigned long)ct);
 		return 0;
 	}
-	ip_conntrack_put(ct);
+	nf_ct_put(ct);
 	DEBUGP("leaving\n");
 
 	return 0;
@@ -740,24 +746,25 @@
 ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb, 
 			struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
-	struct ip_conntrack_tuple_hash *h;
-	struct ip_conntrack_tuple tuple;
-	struct ip_conntrack *ct;
+	struct nf_conntrack_tuple_hash *h;
+	struct nf_conntrack_tuple tuple;
+	struct nf_conn *ct;
 	struct sk_buff *skb2 = NULL;
+	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct nfgenmsg *msg = NLMSG_DATA(nlh);
 		u32 rlen;
 
-		if (msg->nfgen_family != AF_INET)
+		if (nfmsg->nfgen_family != AF_INET)
 			return -EAFNOSUPPORT;
 
 		if (NFNL_MSG_TYPE(nlh->nlmsg_type) ==
 					IPCTNL_MSG_CT_GET_CTRZERO) {
-#ifdef CONFIG_IP_NF_CT_ACCT
+#ifdef CONFIG_NF_CT_ACCT
 			if ((*errp = netlink_dump_start(ctnl, skb, nlh,
 						ctnetlink_dump_table_w,
 						ctnetlink_done)) != 0)
@@ -783,34 +790,34 @@
 		return -EINVAL;
 
 	if (cda[CTA_TUPLE_ORIG-1])
-		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG);
+		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG, u3);
 	else if (cda[CTA_TUPLE_REPLY-1])
-		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY);
+		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY, u3);
 	else
 		return -EINVAL;
 
 	if (err < 0)
 		return err;
 
-	h = ip_conntrack_find_get(&tuple, NULL);
+	h = nf_conntrack_find_get(&tuple, NULL);
 	if (!h) {
 		DEBUGP("tuple not found in conntrack hash");
 		return -ENOENT;
 	}
 	DEBUGP("tuple found\n");
-	ct = tuplehash_to_ctrack(h);
+	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	err = -ENOMEM;
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb2) {
-		ip_conntrack_put(ct);
+		nf_ct_put(ct);
 		return -ENOMEM;
 	}
 	NETLINK_CB(skb2).dst_pid = NETLINK_CB(skb).pid;
 
 	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, 
 				  IPCTNL_MSG_CT_NEW, 1, ct);
-	ip_conntrack_put(ct);
+	nf_ct_put(ct);
 	if (err <= 0)
 		goto free;
 
@@ -828,7 +835,7 @@
 }
 
 static inline int
-ctnetlink_change_status(struct ip_conntrack *ct, struct nfattr *cda[])
+ctnetlink_change_status(struct nf_conn *ct, struct nfattr *cda[])
 {
 	unsigned long d;
 	unsigned status = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_STATUS-1]));
@@ -892,9 +899,9 @@
 
 
 static inline int
-ctnetlink_change_helper(struct ip_conntrack *ct, struct nfattr *cda[])
+ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
 {
-	struct ip_conntrack_helper *helper;
+	struct nf_conntrack_helper *helper;
 	char *helpname;
 	int err;
 
@@ -908,7 +915,7 @@
 	if (err < 0)
 		return err;
 
-	helper = __ip_conntrack_helper_find_byname(helpname);
+	helper = __nf_conntrack_helper_find_byname(helpname);
 	if (!helper) {
 		if (!strcmp(helpname, ""))
 			helper = NULL;
@@ -919,7 +926,7 @@
 	if (ct->helper) {
 		if (!helper) {
 			/* we had a helper before ... */
-			ip_ct_remove_expectations(ct);
+			nf_ct_remove_expectations(ct);
 			ct->helper = NULL;
 		} else {
 			/* need to zero data of old helper */
@@ -933,7 +940,7 @@
 }
 
 static inline int
-ctnetlink_change_timeout(struct ip_conntrack *ct, struct nfattr *cda[])
+ctnetlink_change_timeout(struct nf_conn *ct, struct nfattr *cda[])
 {
 	u_int32_t timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
 	
@@ -947,28 +954,29 @@
 }
 
 static inline int
-ctnetlink_change_protoinfo(struct ip_conntrack *ct, struct nfattr *cda[])
+ctnetlink_change_protoinfo(struct nf_conn *ct, struct nfattr *cda[])
 {
 	struct nfattr *tb[CTA_PROTOINFO_MAX], *attr = cda[CTA_PROTOINFO-1];
-	struct ip_conntrack_protocol *proto;
+	struct nf_conntrack_protocol *proto;
 	u_int16_t npt = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+	u_int16_t l3num = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int err = 0;
 
 	nfattr_parse_nested(tb, CTA_PROTOINFO_MAX, attr);
 
-	proto = ip_conntrack_proto_find_get(npt);
+	proto = nf_ct_proto_find_get(l3num, npt);
 	if (!proto)
 		return -EINVAL;
 
 	if (proto->from_nfattr)
 		err = proto->from_nfattr(tb, ct);
-	ip_conntrack_proto_put(proto); 
+	nf_ct_proto_put(proto); 
 
 	return err;
 }
 
 static int
-ctnetlink_change_conntrack(struct ip_conntrack *ct, struct nfattr *cda[])
+ctnetlink_change_conntrack(struct nf_conn *ct, struct nfattr *cda[])
 {
 	int err;
 
@@ -1009,15 +1017,15 @@
 
 static int
 ctnetlink_create_conntrack(struct nfattr *cda[], 
-			   struct ip_conntrack_tuple *otuple,
-			   struct ip_conntrack_tuple *rtuple)
+			   struct nf_conntrack_tuple *otuple,
+			   struct nf_conntrack_tuple *rtuple)
 {
-	struct ip_conntrack *ct;
+	struct nf_conn *ct;
 	int err = -EINVAL;
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
-	ct = ip_conntrack_alloc(otuple, rtuple);
+	ct = nf_conntrack_alloc(otuple, rtuple);
 	if (ct == NULL || IS_ERR(ct))
 		return -ENOMEM;	
 
@@ -1038,13 +1046,13 @@
 			return err;
 	}
 
-	ct->helper = ip_conntrack_helper_find_get(rtuple);
+	ct->helper = nf_ct_helper_find_get(rtuple);
 
 	add_timer(&ct->timeout);
-	ip_conntrack_hash_insert(ct);
+	nf_conntrack_hash_insert(ct);
 
 	if (ct->helper)
-		ip_conntrack_helper_put(ct->helper);
+		nf_ct_helper_put(ct->helper);
 
 #if defined(CONFIG_IP_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK-1])
@@ -1055,7 +1063,7 @@
 	return 0;
 
 err:	
-	ip_conntrack_free(ct);
+	nf_conntrack_free(ct);
 	return err;
 }
 
@@ -1063,8 +1071,10 @@
 ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb, 
 			struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
-	struct ip_conntrack_tuple otuple, rtuple;
-	struct ip_conntrack_tuple_hash *h = NULL;
+	struct nf_conntrack_tuple otuple, rtuple;
+	struct nf_conntrack_tuple_hash *h = NULL;
+	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
 	DEBUGP("entered %s\n", __FUNCTION__);
@@ -1073,25 +1083,25 @@
 		return -EINVAL;
 
 	if (cda[CTA_TUPLE_ORIG-1]) {
-		err = ctnetlink_parse_tuple(cda, &otuple, CTA_TUPLE_ORIG);
+		err = ctnetlink_parse_tuple(cda, &otuple, CTA_TUPLE_ORIG, u3);
 		if (err < 0)
 			return err;
 	}
 
 	if (cda[CTA_TUPLE_REPLY-1]) {
-		err = ctnetlink_parse_tuple(cda, &rtuple, CTA_TUPLE_REPLY);
+		err = ctnetlink_parse_tuple(cda, &rtuple, CTA_TUPLE_REPLY, u3);
 		if (err < 0)
 			return err;
 	}
 
-	write_lock_bh(&ip_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	if (cda[CTA_TUPLE_ORIG-1])
-		h = __ip_conntrack_find(&otuple, NULL);
+		h = __nf_conntrack_find(&otuple, NULL);
 	else if (cda[CTA_TUPLE_REPLY-1])
-		h = __ip_conntrack_find(&rtuple, NULL);
+		h = __nf_conntrack_find(&rtuple, NULL);
 
 	if (h == NULL) {
-		write_unlock_bh(&ip_conntrack_lock);
+		write_unlock_bh(&nf_conntrack_lock);
 		DEBUGP("no such conntrack, create new\n");
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
@@ -1111,10 +1121,10 @@
 	DEBUGP("conntrack found\n");
 	err = -EEXIST;
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL))
-		err = ctnetlink_change_conntrack(tuplehash_to_ctrack(h), cda);
+		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h), cda);
 
 out_unlock:
-	write_unlock_bh(&ip_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 	return err;
 }
 
@@ -1124,7 +1134,7 @@
 
 static inline int
 ctnetlink_exp_dump_tuple(struct sk_buff *skb,
-			 const struct ip_conntrack_tuple *tuple,
+			 const struct nf_conntrack_tuple *tuple,
 			 enum ctattr_expect type)
 {
 	struct nfattr *nest_parms = NFA_NEST(skb, type);
@@ -1142,9 +1152,9 @@
 
 static inline int
 ctnetlink_exp_dump_expect(struct sk_buff *skb,
-                          const struct ip_conntrack_expect *exp)
+                          const struct nf_conntrack_expect *exp)
 {
-	struct ip_conntrack *master = exp->master;
+	struct nf_conn *master = exp->master;
 	u_int32_t timeout = htonl((exp->timeout.expires - jiffies) / HZ);
 	u_int32_t id = htonl(exp->id);
 
@@ -1170,7 +1180,7 @@
 ctnetlink_exp_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 		    int event, 
 		    int nowait, 
-		    const struct ip_conntrack_expect *exp)
+		    const struct nf_conntrack_expect *exp)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
@@ -1199,13 +1209,13 @@
 	return -1;
 }
 
-#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 static int ctnetlink_expect_event(struct notifier_block *this,
 				  unsigned long events, void *ptr)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
-	struct ip_conntrack_expect *exp = (struct ip_conntrack_expect *)ptr;
+	struct nf_conntrack_expect *exp = (struct nf_conntrack_expect *)ptr;
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned char *b;
@@ -1251,15 +1261,15 @@
 static int
 ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct ip_conntrack_expect *exp = NULL;
+	struct nf_conntrack_expect *exp = NULL;
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[0];
 
 	DEBUGP("entered %s, last id=%llu\n", __FUNCTION__, *id);
 
-	read_lock_bh(&ip_conntrack_lock);
-	list_for_each_prev(i, &ip_conntrack_expect_list) {
-		exp = (struct ip_conntrack_expect *) i;
+	read_lock_bh(&nf_conntrack_lock);
+	list_for_each_prev(i, &nf_conntrack_expect_list) {
+		exp = (struct nf_conntrack_expect *) i;
 		if (exp->id <= *id)
 			continue;
 		if (ctnetlink_exp_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -1270,7 +1280,7 @@
 		*id = exp->id;
 	}
 out:	
-	read_unlock_bh(&ip_conntrack_lock);
+	read_unlock_bh(&nf_conntrack_lock);
 
 	DEBUGP("leaving, last id=%llu\n", *id);
 
@@ -1286,9 +1296,11 @@
 ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb, 
 		     struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
-	struct ip_conntrack_tuple tuple;
-	struct ip_conntrack_expect *exp;
+	struct nf_conntrack_tuple tuple;
+	struct nf_conntrack_expect *exp;
 	struct sk_buff *skb2;
+	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
 	DEBUGP("entered %s\n", __FUNCTION__);
@@ -1297,10 +1309,9 @@
 		return -EINVAL;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct nfgenmsg *msg = NLMSG_DATA(nlh);
 		u32 rlen;
 
-		if (msg->nfgen_family != AF_INET)
+		if (nfmsg->nfgen_family != AF_INET)
 			return -EAFNOSUPPORT;
 
 		if ((*errp = netlink_dump_start(ctnl, skb, nlh,
@@ -1315,21 +1326,21 @@
 	}
 
 	if (cda[CTA_EXPECT_MASTER-1])
-		err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASTER);
+		err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASTER, u3);
 	else
 		return -EINVAL;
 
 	if (err < 0)
 		return err;
 
-	exp = ip_conntrack_expect_find(&tuple);
+	exp = nf_conntrack_expect_find(&tuple);
 	if (!exp)
 		return -ENOENT;
 
 	if (cda[CTA_EXPECT_ID-1]) {
 		u_int32_t id = *(u_int32_t *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
 		if (exp->id != ntohl(id)) {
-			ip_conntrack_expect_put(exp);
+			nf_conntrack_expect_put(exp);
 			return -ENOENT;
 		}
 	}	
@@ -1346,14 +1357,14 @@
 	if (err <= 0)
 		goto free;
 
-	ip_conntrack_expect_put(exp);
+	nf_conntrack_expect_put(exp);
 
 	return netlink_unicast(ctnl, skb2, NETLINK_CB(skb).pid, MSG_DONTWAIT);
 
 free:
 	kfree_skb(skb2);
 out:
-	ip_conntrack_expect_put(exp);
+	nf_conntrack_expect_put(exp);
 	return err;
 }
 
@@ -1361,9 +1372,11 @@
 ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb, 
 		     struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
-	struct ip_conntrack_expect *exp, *tmp;
-	struct ip_conntrack_tuple tuple;
-	struct ip_conntrack_helper *h;
+	struct nf_conntrack_expect *exp, *tmp;
+	struct nf_conntrack_tuple tuple;
+	struct nf_conntrack_helper *h;
+	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	u_int8_t u3 = nfmsg->nfgen_family;
 	int err;
 
 	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
@@ -1371,12 +1384,12 @@
 
 	if (cda[CTA_EXPECT_TUPLE-1]) {
 		/* delete a single expect by tuple */
-		err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE);
+		err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE, u3);
 		if (err < 0)
 			return err;
 
 		/* bump usage count to 2 */
-		exp = ip_conntrack_expect_find(&tuple);
+		exp = nf_conntrack_expect_find(&tuple);
 		if (!exp)
 			return -ENOENT;
 
@@ -1384,83 +1397,83 @@
 			u_int32_t id = 
 				*(u_int32_t *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
 			if (exp->id != ntohl(id)) {
-				ip_conntrack_expect_put(exp);
+				nf_conntrack_expect_put(exp);
 				return -ENOENT;
 			}
 		}
 
 		/* after list removal, usage count == 1 */
-		ip_conntrack_unexpect_related(exp);
+		nf_conntrack_unexpect_related(exp);
 		/* have to put what we 'get' above. 
 		 * after this line usage count == 0 */
-		ip_conntrack_expect_put(exp);
+		nf_conntrack_expect_put(exp);
 	} else if (cda[CTA_EXPECT_HELP_NAME-1]) {
 		char *name = NFA_DATA(cda[CTA_EXPECT_HELP_NAME-1]);
 
 		/* delete all expectations for this helper */
-		write_lock_bh(&ip_conntrack_lock);
-		h = __ip_conntrack_helper_find_byname(name);
+		write_lock_bh(&nf_conntrack_lock);
+		h = __nf_conntrack_helper_find_byname(name);
 		if (!h) {
-			write_unlock_bh(&ip_conntrack_lock);
+			write_unlock_bh(&nf_conntrack_lock);
 			return -EINVAL;
 		}
-		list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list,
+		list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list,
 					 list) {
 			if (exp->master->helper == h 
 			    && del_timer(&exp->timeout)) {
-				ip_ct_unlink_expect(exp);
-				ip_conntrack_expect_put(exp);
+				nf_ct_unlink_expect(exp);
+				nf_conntrack_expect_put(exp);
 			}
 		}
-		write_unlock_bh(&ip_conntrack_lock);
+		write_unlock_bh(&nf_conntrack_lock);
 	} else {
 		/* This basically means we have to flush everything*/
-		write_lock_bh(&ip_conntrack_lock);
-		list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list,
+		write_lock_bh(&nf_conntrack_lock);
+		list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list,
 					 list) {
 			if (del_timer(&exp->timeout)) {
-				ip_ct_unlink_expect(exp);
-				ip_conntrack_expect_put(exp);
+				nf_ct_unlink_expect(exp);
+				nf_conntrack_expect_put(exp);
 			}
 		}
-		write_unlock_bh(&ip_conntrack_lock);
+		write_unlock_bh(&nf_conntrack_lock);
 	}
 
 	return 0;
 }
 static int
-ctnetlink_change_expect(struct ip_conntrack_expect *x, struct nfattr *cda[])
+ctnetlink_change_expect(struct nf_conntrack_expect *x, struct nfattr *cda[])
 {
 	return -EOPNOTSUPP;
 }
 
 static int
-ctnetlink_create_expect(struct nfattr *cda[])
+ctnetlink_create_expect(struct nfattr *cda[], u_int8_t u3)
 {
-	struct ip_conntrack_tuple tuple, mask, master_tuple;
-	struct ip_conntrack_tuple_hash *h = NULL;
-	struct ip_conntrack_expect *exp;
-	struct ip_conntrack *ct;
+	struct nf_conntrack_tuple tuple, mask, master_tuple;
+	struct nf_conntrack_tuple_hash *h = NULL;
+	struct nf_conntrack_expect *exp;
+	struct nf_conn *ct;
 	int err = 0;
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
 	/* caller guarantees that those three CTA_EXPECT_* exist */
-	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE);
+	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE, u3);
 	if (err < 0)
 		return err;
-	err = ctnetlink_parse_tuple(cda, &mask, CTA_EXPECT_MASK);
+	err = ctnetlink_parse_tuple(cda, &mask, CTA_EXPECT_MASK, u3);
 	if (err < 0)
 		return err;
-	err = ctnetlink_parse_tuple(cda, &master_tuple, CTA_EXPECT_MASTER);
+	err = ctnetlink_parse_tuple(cda, &master_tuple, CTA_EXPECT_MASTER, u3);
 	if (err < 0)
 		return err;
 
 	/* Look for master conntrack of this expectation */
-	h = ip_conntrack_find_get(&master_tuple, NULL);
+	h = nf_conntrack_find_get(&master_tuple, NULL);
 	if (!h)
 		return -ENOENT;
-	ct = tuplehash_to_ctrack(h);
+	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	if (!ct->helper) {
 		/* such conntrack hasn't got any helper, abort */
@@ -1468,7 +1481,7 @@
 		goto out;
 	}
 
-	exp = ip_conntrack_expect_alloc(ct);
+	exp = nf_conntrack_expect_alloc(ct);
 	if (!exp) {
 		err = -ENOMEM;
 		goto out;
@@ -1477,14 +1490,14 @@
 	exp->expectfn = NULL;
 	exp->flags = 0;
 	exp->master = ct;
-	memcpy(&exp->tuple, &tuple, sizeof(struct ip_conntrack_tuple));
-	memcpy(&exp->mask, &mask, sizeof(struct ip_conntrack_tuple));
+	memcpy(&exp->tuple, &tuple, sizeof(struct nf_conntrack_tuple));
+	memcpy(&exp->mask, &mask, sizeof(struct nf_conntrack_tuple));
 
-	err = ip_conntrack_expect_related(exp);
-	ip_conntrack_expect_put(exp);
+	err = nf_conntrack_expect_related(exp);
+	nf_conntrack_expect_put(exp);
 
 out:	
-	ip_conntrack_put(tuplehash_to_ctrack(h));
+	nf_ct_put(nf_ct_tuplehash_to_ctrack(h));
 	return err;
 }
 
@@ -1492,8 +1505,10 @@
 ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 		     struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
-	struct ip_conntrack_tuple tuple;
-	struct ip_conntrack_expect *exp;
+	struct nf_conntrack_tuple tuple;
+	struct nf_conntrack_expect *exp;
+	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
 	DEBUGP("entered %s\n", __FUNCTION__);	
@@ -1506,32 +1521,32 @@
 	    || !cda[CTA_EXPECT_MASTER-1])
 		return -EINVAL;
 
-	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE);
+	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE, u3);
 	if (err < 0)
 		return err;
 
-	write_lock_bh(&ip_conntrack_lock);
-	exp = __ip_conntrack_expect_find(&tuple);
+	write_lock_bh(&nf_conntrack_lock);
+	exp = __nf_conntrack_expect_find(&tuple);
 
 	if (!exp) {
-		write_unlock_bh(&ip_conntrack_lock);
+		write_unlock_bh(&nf_conntrack_lock);
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
-			err = ctnetlink_create_expect(cda);
+			err = ctnetlink_create_expect(cda, u3);
 		return err;
 	}
 
 	err = -EEXIST;
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL))
 		err = ctnetlink_change_expect(exp, cda);
-	write_unlock_bh(&ip_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 
 	DEBUGP("leaving\n");
 	
 	return err;
 }
 
-#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 static struct notifier_block ctnl_notifier = {
 	.notifier_call	= ctnetlink_conntrack_event,
 };
@@ -1601,14 +1616,14 @@
 		goto err_unreg_subsys;
 	}
 
-#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
-	ret = ip_conntrack_register_notifier(&ctnl_notifier);
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	ret = nf_conntrack_register_notifier(&ctnl_notifier);
 	if (ret < 0) {
 		printk("ctnetlink_init: cannot register notifier.\n");
 		goto err_unreg_exp_subsys;
 	}
 
-	ret = ip_conntrack_expect_register_notifier(&ctnl_notifier_exp);
+	ret = nf_conntrack_expect_register_notifier(&ctnl_notifier_exp);
 	if (ret < 0) {
 		printk("ctnetlink_init: cannot expect register notifier.\n");
 		goto err_unreg_notifier;
@@ -1617,9 +1632,9 @@
 
 	return 0;
 
-#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 err_unreg_notifier:
-	ip_conntrack_unregister_notifier(&ctnl_notifier);
+	nf_conntrack_unregister_notifier(&ctnl_notifier);
 err_unreg_exp_subsys:
 	nfnetlink_subsys_unregister(&ctnl_exp_subsys);
 #endif
@@ -1633,9 +1648,9 @@
 {
 	printk("ctnetlink: unregistering from nfnetlink.\n");
 
-#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
-	ip_conntrack_unregister_notifier(&ctnl_notifier_exp);
-	ip_conntrack_unregister_notifier(&ctnl_notifier);
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	nf_conntrack_unregister_notifier(&ctnl_notifier_exp);
+	nf_conntrack_unregister_notifier(&ctnl_notifier);
 #endif
 
 	nfnetlink_subsys_unregister(&ctnl_exp_subsys);

--------------020307000201050804060100--
