From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Tue, 28 Jun 2005 04:00:06 +0200
Message-ID: <42C0AF26.1040705@eurodev.net>
References: <42C03F2E.30706@eurodev.net>
	<20050627202621.GY19928@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080702070602090801030500"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050627202621.GY19928@sunbeam.de.gnumonks.org>
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
--------------080702070602090801030500
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
> the patch removes the whole old ip_conntrack_netlink.c file and replaces
> it with a new one.  I don't really see why.  An, now, you changed the
> directory name from 2.6.11 to 2.6.12.  Is this neccessarry?  Why would
> your recent changes to ctnetlink not work with a 2.6.11 kernel?

I did that because of the file linux-2.6.patch, the 2.6.11 version 
differs from the new 2.6.12 one. Can we have in pom-ng two different 
file patches for every version? I mean, something like 
linux-2.6.11.patch and linux-2.6.12.patch living in ctnetlink. If so, 
please add the patch attached to ctnetlink.

>>I've split this big patch above into four pieces to make it easier to 
>>understand the changes:
>>http://people.netfilter.org/~pablo/ctnetlink-2.6.12/2.6.11-vs-2.6.12/
> 
> please remove stuff like
> 
>>-#if 0
>>+#if 1
>> #define DEBUGP printk
> 
> before releasing a patch, thanks.

OK, I'll do so.

> Also, I would rather not like to have NFNL_SUBSYS_CTNETLINK_EXP deleted.
> I thought it would be nice to have expect handling separated from
> conntracks, since they really are two seperate data structures.
> 
> Apart from that I'm fine with all of your modifications.
> 
> I don't understand why the order of the expectation list was changed,
> though.  Would you please explain why this was done?

Because of the table dumping logic I was using.

-                       if (ct->id <= *id)
+                       if (ct->id >= *id)
                                 continue;

I needed to add the conntracks at the tail. This isn't really needed so 
I've just reverted this change in the linux-2.6.12.patch attached.

Please see that you have to apply the patch 05ctnetlink.patch to 
ctnetlink as well.

>>- Implement ip_conntrack_stats dumping and reset (accounting)
> 
> you want to dump the statistics via netlink?  i'm not sure whether that
> is required.  lnstat is the only program using those counters, and using
> /proc seems fine for that.

Could this be useful for accounting purposes? I mean, dump and reset as 
a single operation, something similar to conntrack -L -z, say conntrack 
-S -z.

>>- Implement get conntrack and destroy (accounting)
> 
> sorry, what are you referring to?

An atomical operation to dump conntrack information and then destroy it. 
For example, if someone does:

conntrack -D --orig-src 1.1.1.1 --orig-dst 2.2.2.2 -p tcp 
--orig-src-port 10 --orig-dst-port 20

the it sends the conntrack info and destroy it. This could be worth it 
for accounting.

>>- Kill event/dump mask based (?). Although it's unique, I think that it 
>>could be useful for weak conntrack event notification (think of just 
>>new, established and destroy event notification to reduce performance 
>>impact).
> 
> 
> well, an interesting optimization.  My major problem with this whole
> system (like the other IPCTNL_MSG_CONFIG stuff) is: how to correctly
> deal with multipel users.  

Yes, this is a problem.

> Now, I think there is a way to do it right.  Basically every application
> would only request the events that it is interested in, and the kernel
> would bitwise-or those events to create the event mask that actually is
> to be dumped into userspace.
> 
> It's a bit like multicast membership subscription with IGMP...
> 
> So the only question remaining is: how does the kernel clean up / expire
> the masks?  If apps only subscribe but never unsubscribe, we would never
> clean up.
> 
> I'm not sure if we could somehow (cleanly) tie into the scoket
> close/destroy code.  If yes, we could check if we can reduce the mask at
> socket destroy time.

I think there's no sane way to do this but let me check the netlink code 
again. I could use multicast netlink subscrition, so the client can get 
subscribed to those events that the user considers interesting.

Initially the purpose of the mask based event notification was reducing 
the impact of an socket overrun under big stress situations. Say you've 
got a firewall very loaded, so conntrack-netlink subsys has to send tons 
of update messages, in that case the buffer can overrun and some 
messages will be drop.

To avoid this I could use an approach similar to what you do in ULOG and 
just keep the mask in userspace. Anyway, this hurts performance as well, 
since unneeded messages will be delivered to userspace and dropped if 
the client doesn't consider them interesting. This solution isn't that 
bad though since the conntrack-netlink subsys will send burst of 
messages in once.

--
Pablo

--------------080702070602090801030500
Content-Type: text/x-patch;
 name="linux-2.6.12.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.12.patch"

Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_amanda.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-06-28 02:28:44.000000000 +0200
@@ -151,6 +151,7 @@
 	.mask = { .src = { .u = { 0xFFFF } },
 		 .dst = { .protonum = 0xFF },
 	},
+	.change_help = ip_ct_generic_change_help,
 };
 
 static void __exit fini(void)
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-28 02:44:45.000000000 +0200
@@ -76,6 +76,8 @@
 static LIST_HEAD(unconfirmed);
 static int ip_conntrack_vmalloc;
 
+static unsigned int ip_conntrack_next_id = 1;
+static unsigned int ip_conntrack_expect_next_id = 1;
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
 struct notifier_block *ip_conntrack_chain;
 struct notifier_block *ip_conntrack_expect_chain;
@@ -83,13 +85,6 @@
 
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
-void 
-ip_conntrack_put(struct ip_conntrack *ct)
-{
-	IP_NF_ASSERT(ct);
-	nf_conntrack_put(&ct->ct_general);
-}
-
 static int ip_conntrack_hash_rnd_initted;
 static unsigned int ip_conntrack_hash_rnd;
 
@@ -146,7 +141,7 @@
 {
 	ip_conntrack_put(exp->master);
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
-	kmem_cache_free(ip_conntrack_expect_cachep, exp);
+	ip_conntrack_expect_free(exp);
 	CONNTRACK_STAT_INC(expect_delete);
 }
 
@@ -158,6 +153,13 @@
 	exp->master->expecting--;
 }
 
+void ip_ct_unlink_destroy_expect(struct ip_conntrack_expect *exp)
+{
+	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
+	unlink_expect(exp);
+	destroy_expect(exp);
+}
+
 static void expectation_timed_out(unsigned long ul_expect)
 {
 	struct ip_conntrack_expect *exp = (void *)ul_expect;
@@ -169,6 +171,33 @@
 	destroy_expect(exp);
 }
 
+struct ip_conntrack_expect *
+__ip_conntrack_expect_find(const struct ip_conntrack_tuple *tuple)
+{
+	struct ip_conntrack_expect *i;
+	
+	list_for_each_entry(i, &ip_conntrack_expect_list, list) {
+		if (ip_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)) {
+			atomic_inc(&i->use);
+			return i;
+		}
+	}
+	return NULL;
+}
+
+/* Just find a expectation corresponding to a tuple. */
+struct ip_conntrack_expect *
+ip_conntrack_expect_find_get(const struct ip_conntrack_tuple *tuple)
+{
+	struct ip_conntrack_expect *i;
+	
+	READ_LOCK(&ip_conntrack_lock);
+	i = __ip_conntrack_expect_find(tuple);
+	READ_UNLOCK(&ip_conntrack_lock);
+
+	return i;
+}
+
 /* If an expectation for this connection is found, it gets delete from
  * global list then returned. */
 static struct ip_conntrack_expect *
@@ -193,7 +222,7 @@
 }
 
 /* delete all expectations for this conntrack */
-static void remove_expectations(struct ip_conntrack *ct)
+void ip_ct_remove_expectations(struct ip_conntrack *ct)
 {
 	struct ip_conntrack_expect *i, *tmp;
 
@@ -223,7 +252,7 @@
 	LIST_DELETE(&ip_conntrack_hash[hr], &ct->tuplehash[IP_CT_DIR_REPLY]);
 
 	/* Destroy all pending expectations */
-	remove_expectations(ct);
+	ip_ct_remove_expectations(ct);
 }
 
 static void
@@ -253,7 +282,7 @@
 	 * except TFTP can create an expectation on the first packet,
 	 * before connection is in the list, so we need to clean here,
 	 * too. */
-	remove_expectations(ct);
+	ip_ct_remove_expectations(ct);
 
 	/* We overload first tuple to link into unconfirmed list. */
 	if (!is_confirmed(ct)) {
@@ -268,8 +297,7 @@
 		ip_conntrack_put(ct->master);
 
 	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
-	kmem_cache_free(ip_conntrack_cachep, ct);
-	atomic_dec(&ip_conntrack_count);
+	ip_conntrack_free(ct);
 }
 
 static void death_by_timeout(unsigned long ul_conntrack)
@@ -296,7 +324,7 @@
 		&& ip_ct_tuple_equal(tuple, &i->tuple);
 }
 
-static struct ip_conntrack_tuple_hash *
+struct ip_conntrack_tuple_hash *
 __ip_conntrack_find(const struct ip_conntrack_tuple *tuple,
 		    const struct ip_conntrack *ignored_conntrack)
 {
@@ -331,6 +359,27 @@
 	return h;
 }
 
+static void __ip_conntrack_hash_insert(struct ip_conntrack *ct) 
+{
+	size_t hash, repl_hash;
+	
+	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	
+	list_add(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list, 
+		 &ip_conntrack_hash[hash]);
+	list_add(&ct->tuplehash[IP_CT_DIR_REPLY].list,
+		 &ip_conntrack_hash[repl_hash]);
+	ct->id = ++ip_conntrack_next_id;
+}
+
+void ip_conntrack_hash_insert(struct ip_conntrack *ct)
+{
+	WRITE_LOCK(&ip_conntrack_lock);
+	__ip_conntrack_hash_insert(ct);
+	WRITE_UNLOCK(&ip_conntrack_lock);
+}
+
 /* Confirm a connection given skb; places it in hash table */
 int
 __ip_conntrack_confirm(struct sk_buff **pskb)
@@ -377,10 +426,10 @@
 		/* Remove from unconfirmed list */
 		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 
-		list_prepend(&ip_conntrack_hash[hash],
-			     &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
-		list_prepend(&ip_conntrack_hash[repl_hash],
-			     &ct->tuplehash[IP_CT_DIR_REPLY]);
+		list_add(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list, 
+			 &ip_conntrack_hash[hash]);
+		list_add(&ct->tuplehash[IP_CT_DIR_REPLY].list,
+			 &ip_conntrack_hash[repl_hash]);
 		/* Timer relative to confirmation time, not original
 		   setting time, otherwise we'd get timer wrap in
 		   weird delay cases. */
@@ -398,6 +447,7 @@
 #endif
 		ip_conntrack_event_cache(master_ct(ct) ?
 					 IPCT_RELATED : IPCT_NEW, *pskb);
+		ct->id = ++ip_conntrack_next_id;
 
 		return NF_ACCEPT;
 	}
@@ -432,7 +482,7 @@
 
 static int early_drop(struct list_head *chain)
 {
-	/* Traverse forwards: gives us oldest, which is roughly LRU */
+	/* Traverse backwards: gives us oldest, which is roughly LRU */
 	struct ip_conntrack_tuple_hash *h;
 	struct ip_conntrack *ct = NULL;
 	int dropped = 0;
@@ -463,7 +513,7 @@
 	return ip_ct_tuple_mask_cmp(rtuple, &i->tuple, &i->mask);
 }
 
-static struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple)
+struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple)
 {
 	return LIST_FIND(&helpers, helper_cmp,
 			 struct ip_conntrack_helper *,
@@ -472,22 +522,18 @@
 
 /* Allocate a new conntrack: we return -ENOMEM if classification
    failed due to stress.  Otherwise it really is unclassifiable. */
-static struct ip_conntrack_tuple_hash *
-init_conntrack(const struct ip_conntrack_tuple *tuple,
-	       struct ip_conntrack_protocol *protocol,
-	       struct sk_buff *skb)
+struct ip_conntrack *ip_conntrack_alloc(struct ip_conntrack_tuple *orig,
+					struct ip_conntrack_tuple *repl)
 {
 	struct ip_conntrack *conntrack;
-	struct ip_conntrack_tuple repl_tuple;
 	size_t hash;
-	struct ip_conntrack_expect *exp;
 
 	if (!ip_conntrack_hash_rnd_initted) {
 		get_random_bytes(&ip_conntrack_hash_rnd, 4);
 		ip_conntrack_hash_rnd_initted = 1;
 	}
 
-	hash = hash_conntrack(tuple);
+	hash = hash_conntrack(orig);
 
 	if (ip_conntrack_max
 	    && atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {
@@ -501,11 +547,6 @@
 		}
 	}
 
-	if (!ip_ct_invert_tuple(&repl_tuple, tuple, protocol)) {
-		DEBUGP("Can't invert tuple.\n");
-		return NULL;
-	}
-
 	conntrack = kmem_cache_alloc(ip_conntrack_cachep, GFP_ATOMIC);
 	if (!conntrack) {
 		DEBUGP("Can't allocate conntrack.\n");
@@ -515,17 +556,51 @@
 	memset(conntrack, 0, sizeof(*conntrack));
 	atomic_set(&conntrack->ct_general.use, 1);
 	conntrack->ct_general.destroy = destroy_conntrack;
-	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *tuple;
-	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = repl_tuple;
-	if (!protocol->new(conntrack, skb)) {
-		kmem_cache_free(ip_conntrack_cachep, conntrack);
-		return NULL;
-	}
+	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
+	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *repl;
+
 	/* Don't set timer yet: wait for confirmation */
 	init_timer(&conntrack->timeout);
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
+	atomic_inc(&ip_conntrack_count);
+
+	return conntrack;
+}
+
+void
+ip_conntrack_free(struct ip_conntrack *conntrack)
+{
+	atomic_dec(&ip_conntrack_count);
+	kmem_cache_free(ip_conntrack_cachep, conntrack);
+}
+
+static struct ip_conntrack_tuple_hash *
+init_conntrack(struct ip_conntrack_tuple *tuple,
+	       struct ip_conntrack_protocol *protocol,
+	       struct sk_buff *skb)
+{
+	struct ip_conntrack *conntrack;
+	struct ip_conntrack_tuple repl_tuple;
+	struct ip_conntrack_expect *exp;
+
+	if (!ip_ct_invert_tuple(&repl_tuple, tuple, protocol)) {
+		DEBUGP("Can't invert tuple.\n");
+		return NULL;
+	}
+
+	if (!(conntrack = ip_conntrack_alloc(tuple, &repl_tuple)))
+		return NULL;
+
+	if (IS_ERR(conntrack))
+		return (void *) conntrack;
+
+	if (!protocol->new(conntrack, skb)) {
+		ip_conntrack_free(conntrack);
+		return NULL;
+	}
+
 	WRITE_LOCK(&ip_conntrack_lock);
 	exp = find_expectation(tuple);
 
@@ -549,7 +624,6 @@
 	/* Overload tuple linked list to put us in unconfirmed list. */
 	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
 
-	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	if (exp) {
@@ -765,13 +839,15 @@
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
@@ -790,6 +866,9 @@
 	} else
 		exp->timeout.function = NULL;
 
+	exp->id = ++ip_conntrack_expect_next_id;
+
+	atomic_inc(&exp->use);
 	CONNTRACK_STAT_INC(expect_create);
 }
 
@@ -1018,6 +1097,32 @@
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
@@ -1144,23 +1249,27 @@
 				     * ip_conntrack_htable_size));
 }
 
-/* Mishearing the voices in his head, our hero wonders how he's
-   supposed to kill the mall. */
-void ip_conntrack_cleanup(void)
+void ip_conntrack_flush()
 {
-	ip_ct_attach = NULL;
 	/* This makes sure all current packets have passed through
            netfilter framework.  Roll on, two-stage module
            delete... */
 	synchronize_net();
- 
+
  i_see_dead_people:
 	ip_ct_iterate_cleanup(kill_all, NULL);
 	if (atomic_read(&ip_conntrack_count) != 0) {
 		schedule();
 		goto i_see_dead_people;
 	}
+}
 
+/* Mishearing the voices in his head, our hero wonders how he's
+   supposed to kill the mall. */
+void ip_conntrack_cleanup(void)
+{
+	ip_ct_attach = NULL;
+	ip_conntrack_flush();
 	kmem_cache_destroy(ip_conntrack_cachep);
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
 	free_conntrack_hash();
@@ -1258,6 +1367,8 @@
 	/*  - and look it like as a confirmed connection */
 	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
 
+	printk("untracked: %p\n", &ip_conntrack_untracked);
+
 	return ret;
 
 err_free_conntrack_slab:
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_ftp.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-06-28 02:28:44.000000000 +0200
@@ -481,6 +481,8 @@
 		ftp[i].timeout = 5 * 60; /* 5 minutes */
 		ftp[i].me = THIS_MODULE;
 		ftp[i].help = help;
+		ftp[i].lock = &ip_ftp_lock;
+		ftp[i].change_help = ip_ct_generic_change_help;
 
 		tmpname = &ftp_names[i][0];
 		if (ports[i] == FTP_PORT)
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_irc.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_irc.c	2005-06-28 02:28:44.000000000 +0200
@@ -275,6 +275,8 @@
 		hlpr->timeout = dcc_timeout;
 		hlpr->me = THIS_MODULE;
 		hlpr->help = help;
+		hlpr->lock = &irc_buffer_lock;
+		hlpr->change_help = ip_ct_generic_change_help;
 
 		tmpname = &irc_names[i][0];
 		if (ports[i] == IRC_PORT)
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-06-28 02:28:44.000000000 +0200
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
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-06-28 02:28:44.000000000 +0200
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
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-06-28 02:28:44.000000000 +0200
@@ -1094,6 +1094,7 @@
 {
 	.proto 			= IPPROTO_TCP,
 	.name 			= "tcp",
+	.lock			= &tcp_lock,
 	.pkt_to_tuple 		= tcp_pkt_to_tuple,
 	.invert_tuple 		= tcp_invert_tuple,
 	.print_tuple 		= tcp_print_tuple,
@@ -1101,4 +1102,5 @@
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
 	.error			= tcp_error,
+	.change_proto           = ip_ct_generic_change_proto
 };
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_udp.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-06-28 02:28:44.000000000 +0200
@@ -144,4 +144,5 @@
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error,
+	.change_proto           = ip_ct_generic_change_proto
 };
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-06-28 02:28:44.000000000 +0200
@@ -963,6 +963,19 @@
 {
 }
 
+EXPORT_SYMBOL(ip_ct_unlink_destroy_expect);
+EXPORT_SYMBOL(ip_conntrack_flush);
+EXPORT_SYMBOL(__ip_conntrack_expect_find);
+EXPORT_SYMBOL(__ip_conntrack_find);
+EXPORT_SYMBOL(ip_conntrack_expect_list);
+EXPORT_SYMBOL(ip_ct_generic_change_proto);
+EXPORT_SYMBOL(ip_ct_generic_change_help);
+EXPORT_SYMBOL(ip_conntrack_expect_find_get);
+EXPORT_SYMBOL(ip_conntrack_alloc);
+EXPORT_SYMBOL(ip_conntrack_free);
+EXPORT_SYMBOL(ip_conntrack_hash_insert);
+EXPORT_SYMBOL(ip_ct_remove_expectations);
+EXPORT_SYMBOL(ip_ct_find_helper);
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
 EXPORT_SYMBOL(ip_conntrack_chain);
 EXPORT_SYMBOL(ip_conntrack_expect_chain);
@@ -993,7 +1006,6 @@
 EXPORT_SYMBOL(ip_conntrack_hash);
 EXPORT_SYMBOL(ip_conntrack_untracked);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
-EXPORT_SYMBOL_GPL(ip_conntrack_put);
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 EXPORT_SYMBOL(ip_conntrack_tcp_update);
 #endif
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_tftp.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-06-28 02:28:44.000000000 +0200
@@ -134,6 +134,7 @@
 		tftp[i].timeout = 5 * 60; /* 5 minutes */
 		tftp[i].me = THIS_MODULE;
 		tftp[i].help = tftp_help;
+		tftp[i].change_help = ip_ct_generic_change_help;
 
 		tmpname = &tftp_names[i][0];
 		if (ports[i] == TFTP_PORT)
Index: davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_amanda.h
===================================================================
--- davem-2.6.orig/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	2005-06-28 02:28:44.000000000 +0200
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
Index: davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_ftp.h
===================================================================
--- davem-2.6.orig/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	2005-06-28 02:28:44.000000000 +0200
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
Index: davem-2.6/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- davem-2.6.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/include/linux/netfilter_ipv4/ip_conntrack.h	2005-06-28 02:28:44.000000000 +0200
@@ -71,13 +71,13 @@
 	IPS_DESTROYED = (1 << IPS_DESTROYED_BIT),
 };
 
-#ifdef __KERNEL__
-#include <linux/config.h>
-#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
-#include <linux/bitops.h>
-#include <linux/compiler.h>
-#include <asm/atomic.h>
+struct ip_conntrack_counter
+{
+	u_int64_t packets;
+	u_int64_t bytes;
+};
 
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
 #include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_icmp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_sctp.h>
@@ -106,6 +106,7 @@
 	struct ip_ct_irc_master ct_irc_info;
 };
 
+#ifdef __KERNEL__
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 #include <linux/netfilter_ipv4/ip_nat.h>
 #endif
@@ -126,12 +127,6 @@
 #define IP_NF_ASSERT(x)
 #endif
 
-struct ip_conntrack_counter
-{
-	u_int64_t packets;
-	u_int64_t bytes;
-};
-
 struct ip_conntrack_helper;
 
 struct ip_conntrack
@@ -140,6 +135,9 @@
            plus 1 for any connection(s) we are `master' for */
 	struct nf_conntrack ct_general;
 
+	/* Unique ID that identifies this conntrack*/
+	u_int64_t id;
+
 	/* Have we seen traffic both ways yet? (bitset) */
 	unsigned long status;
 
@@ -188,6 +186,9 @@
 	/* Internal linked list (global expectation list) */
 	struct list_head list;
 
+	/* Expectation ID */
+	__u64 id;
+
 	/* We expect this tuple, with the following mask */
 	struct ip_conntrack_tuple tuple, mask;
  
@@ -201,6 +202,8 @@
 	/* Timer function; deletes the expectation. */
 	struct timer_list timeout;
 
+	atomic_t use;
+
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 	/* This is the original per-proto part, used to map the
 	 * expected connection the way the recipient expects. */
@@ -240,7 +243,12 @@
 }
 
 /* decrement reference count on a conntrack */
-extern inline void ip_conntrack_put(struct ip_conntrack *ct);
+static inline void
+ip_conntrack_put(struct ip_conntrack *ct)
+{
+	IP_NF_ASSERT(ct);
+	nf_conntrack_put(&ct->ct_general);
+}
 
 /* call to create an explicit dependency on ip_conntrack. */
 extern void need_ip_conntrack(void);
@@ -275,6 +283,34 @@
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
+extern void ip_conntrack_free(struct ip_conntrack *ct);
+
+extern void ip_conntrack_hash_insert(struct ip_conntrack *ct);
+
+extern struct ip_conntrack_expect *
+__ip_conntrack_expect_find(const struct ip_conntrack_tuple *tuple);
+
+extern struct ip_conntrack_expect *
+ip_conntrack_expect_find_get(const struct ip_conntrack_tuple *tuple);
+
+extern struct ip_conntrack_tuple_hash *
+__ip_conntrack_find(const struct ip_conntrack_tuple *tuple,
+                    const struct ip_conntrack *ignored_conntrack);
+
+extern inline void ip_conntrack_expect_put(struct ip_conntrack_expect *exp);
+
+extern void ip_conntrack_flush(void);
+
+extern void ip_ct_unlink_destroy_expect(struct ip_conntrack_expect *exp);
+
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int is_confirmed(struct ip_conntrack *ct)
 {
Index: davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_helper.h
===================================================================
--- davem-2.6.orig/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-06-28 02:28:44.000000000 +0200
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
Index: davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
===================================================================
--- davem-2.6.orig/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-06-28 02:28:38.000000000 +0200
+++ davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-06-28 02:28:44.000000000 +0200
@@ -10,6 +10,8 @@
 	/* Protocol number. */
 	u_int8_t proto;
 
+	rwlock_t *lock;
+
 	/* Protocol name */
 	const char *name;
 
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

--------------080702070602090801030500
Content-Type: text/x-patch;
 name="05ctnetlink.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05ctnetlink.patch"

Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-06-28 02:40:30.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-06-28 02:41:10.000000000 +0200
@@ -455,7 +455,7 @@
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = tuplehash_to_ctrack(h);
-			if (ct->id <= *id)
+			if (ct->id >= *id)
 				continue;
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 		                        	cb->nlh->nlmsg_seq,
@@ -491,7 +491,7 @@
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = tuplehash_to_ctrack(h);
-			if (ct->id <= *id)
+			if (ct->id >= *id)
 				continue;
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 		                        	cb->nlh->nlmsg_seq,
@@ -1060,7 +1060,7 @@
 	READ_LOCK(&ip_conntrack_lock);
 	list_for_each(i, &ip_conntrack_expect_list) {
 		exp = (struct ip_conntrack_expect *) i;
-		if (exp->id <= *id)
+		if (exp->id >= *id)
 			continue;
 		if (ctnetlink_exp_fill_info(skb, NETLINK_CB(cb->skb).pid,
 					    cb->nlh->nlmsg_seq,

--------------080702070602090801030500--
