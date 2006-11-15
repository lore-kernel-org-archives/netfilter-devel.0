From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_nat git tree
Date: Wed, 15 Nov 2006 07:27:16 +0100
Message-ID: <455AB344.7040406@trash.net>
References: <454E7165.90404@trash.net>
	<Pine.LNX.4.64.0611061448080.18620@blackhole.kfki.hu>
	<Pine.LNX.4.64.0611070938440.20795@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020704050106080708060801"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0611070938440.20795@blackhole.kfki.hu>
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
--------------020704050106080708060801
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Jozsef Kadlecsik wrote:
> On Mon, 6 Nov 2006, Jozsef Kadlecsik wrote:
> 
> 
>>alter_reply is solved by allocating a new conntrack entry and replacing 
>>the old one with the new. This is expensive, of course: the function 
>>checks everything in order to avoid it. We can skip allocating completely 
>>if we keep the helper (whatever it is) regardless of the result of NATing 
>>the connection, which is implemented by the keep_helper module option of 
>>nf_conntrack. (It is the cleanest, but not backward compatible: in theory 
>>the helper may change only when DNAT alters the port.) Untested code, so 
>>beware!
> 
> 
> This is crap, of course, I missed a few points: a pointer to skbuff should 
> be passed along, just to attach the new conntrack entry to it. And the 
> whole reallocating is fragile as the new conntrack pointer should be 
> passed upwards too. Sigh.
> 
> The big question is, how many guys out there rely on the feature that they 
> can DNAT non-standard ports to the standard port and then the standard 
> helper is attached to the connection by netfilter?


Probably not many, but I'm pretty certain at least some people really
use this feature.

> The attached patch fixes alter_reply by allocating large enough conntrack 
> entry in advance (Yasuyuki's suggestion) with the price that all conntrack 
> entries are full sized when NAT is enabled (default). I preserved the 
> 'keep_helper' module parameter from the previous patch so that one can 
> disable always allocating max size entries, but then conntrack won't try 
> to find a new helper after NAT.


I think it makes sense to let helpers like H.323 specify that they want
to assign a helper to an expected connection, although I would prefer
a struct nf_conntrack_helper pointer in struct nf_conntrack_expect
to get rid of using nf_conntrack_lock in helpers and the manual override
functions (something like the attached patch, although it doesn't
actually assign the helper yet because of the problems mentioned below).

>  static struct nf_conn *
>  __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
>  		     const struct nf_conntrack_tuple *repl,
> -		     const struct nf_conntrack_l3proto *l3proto)
> +		     const struct nf_conntrack_l3proto *l3proto,
> +		     unsigned int flags)
>  {
>  	struct nf_conn *conntrack = NULL;
>  	u_int32_t features = 0;
> -	struct nf_conntrack_helper *helper;
> +	struct nf_conntrack_helper *helper = NULL;
>  
>  	if (unlikely(!nf_conntrack_hash_rnd_initted)) {
>  		get_random_bytes(&nf_conntrack_hash_rnd, 4);
> @@ -574,30 +605,28 @@
>  	/*  find features needed by this conntrack. */
>  	features = l3proto->get_features(orig);
>  
> -	/* FIXME: protect helper list per RCU */
> -	read_lock_bh(&nf_conntrack_lock);
> -	helper = __nf_ct_helper_find(repl);
> -	if (helper)
> +	/* Expectfn wants to set the helper */
> +	if (flags & NF_CT_EXPECT_HELPER)
>  		features |= NF_CT_F_HELP;
> -	read_unlock_bh(&nf_conntrack_lock);
> -
> -	DEBUGP("nf_conntrack_alloc: features=0x%x\n", features);
> -
> -	read_lock_bh(&nf_ct_cache_lock);
> -
> -	if (unlikely(!nf_ct_cache[features].use)) {
> -		DEBUGP("nf_conntrack_alloc: not supported features = 0x%x\n",
> -			features);
> -		goto out;
> +	else {
> +		/* FIXME: protect helper list per RCU */
> +		read_lock_bh(&nf_conntrack_lock);
> +		helper = __nf_ct_helper_find(repl);
> +		if (helper)
> +			features |= NF_CT_F_HELP;
> +		read_unlock_bh(&nf_conntrack_lock);
> +		
> +		/* NAT may change (i.e. add) helper: 
> +		 * enable helper support in general */
> +		if ((features & NF_CT_F_NAT) && !keep_helper)
> +			features |= NF_CT_F_HELP;
>  	}
> -
> -	conntrack = kmem_cache_alloc(nf_ct_cache[features].cachep, GFP_ATOMIC);
> +	conntrack = __nf_ct_alloc_feature(features);
>  	if (conntrack == NULL) {
> -		DEBUGP("nf_conntrack_alloc: Can't alloc conntrack from cache\n");
> -		goto out;
> +		atomic_dec(&nf_conntrack_count);
> +		return conntrack;
>  	}
>  
> -	memset(conntrack, 0, nf_ct_cache[features].size);
>  	conntrack->features = features;
>  	if (helper) {
>  		struct nf_conn_help *help = nfct_help(conntrack);
> @@ -613,13 +642,8 @@
>  	init_timer(&conntrack->timeout);
>  	conntrack->timeout.data = (unsigned long)conntrack;
>  	conntrack->timeout.function = death_by_timeout;
> -	read_unlock_bh(&nf_ct_cache_lock);
>  
>  	return conntrack;
> -out:
> -	read_unlock_bh(&nf_ct_cache_lock);
> -	atomic_dec(&nf_conntrack_count);
> -	return conntrack;
>  }
>  
>  struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
> @@ -628,7 +652,7 @@
>  	struct nf_conntrack_l3proto *l3proto;
>  
>  	l3proto = __nf_ct_l3proto_find(orig->src.l3num);
> -	return __nf_conntrack_alloc(orig, repl, l3proto);
> +	return __nf_conntrack_alloc(orig, repl, l3proto, 0);
>  }
>  
>  void nf_conntrack_free(struct nf_conn *conntrack)
> @@ -659,7 +683,12 @@
>  		return NULL;
>  	}
>  
> -	conntrack = __nf_conntrack_alloc(tuple, &repl_tuple, l3proto);
> +	read_lock_bh(&nf_conntrack_lock);
> +	exp = find_expectation(tuple);
> +	read_unlock_bh(&nf_conntrack_lock);


This leaves a race between looking up the expectation and assigning it
to the conntrack and putting it on the unconfirmed list. If the helper
is unloaded during this race it won't be able to clean up the reference
and we'll get a use-after-free. The same problem exists in the helper
lookup in __nf_conntrack_alloc(), we need to hold the lock until the
conntrack is on the unconfirmed list. A second problem with the helper
lookup on allocation is that nf_conntrack_netlink will (unlike
ip_conntrack_netlink) automatically assign a helper to new conntracks.

IMO this just shows the real problem with the features allocation
scheme, we don't know everything in advance (especially considering
nf_conntrack_netlink), and trying to work around it results in these
problems. I really can't see a clean solution while keeping the
features allocation. The two obvious other solutions are to either
always allocate for everything as IPv4 connection tracking does, or
use pointers and extra allocations (or ct_extend, but I can't really
remember too much about it).


--------------020704050106080708060801
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/linux/netfilter/nf_conntrack_h323.h b/include/linux/netfilter/nf_conntrack_h323.h
index 3faeb58..fbf9a94 100644
--- a/include/linux/netfilter/nf_conntrack_h323.h
+++ b/include/linux/netfilter/nf_conntrack_h323.h
@@ -32,10 +32,6 @@ struct nf_conn;
 extern int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 			 TransportAddress *taddr,
 			 union nf_conntrack_address *addr, __be16 *port);
-extern void nf_conntrack_h245_expect(struct nf_conn *new,
-				     struct nf_conntrack_expect *this);
-extern void nf_conntrack_q931_expect(struct nf_conn *new,
-				     struct nf_conntrack_expect *this);
 extern int (*set_h245_addr_hook) (struct sk_buff **pskb,
 				  unsigned char **data, int dataoff,
 				  H245_TransportAddress *taddr,
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 2923bec..1c23ec2 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -22,6 +22,9 @@ struct nf_conntrack_expect
 	void (*expectfn)(struct nf_conn *new,
 			 struct nf_conntrack_expect *this);
 
+	/* Helper to assign to new connection */
+	struct nf_conntrack_helper *helper;
+
 	/* The conntrack of the master connection */
 	struct nf_conn *master;
 
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 81eb00f..a51fd46 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -324,18 +324,6 @@ static int nat_t120(struct sk_buff **psk
 	return 0;
 }
 
-/****************************************************************************
- * This conntrack expect function replaces nf_conntrack_h245_expect()
- * which was set by nf_conntrack_helper_h323.c. It calls both
- * nf_nat_follow_master() and nf_conntrack_h245_expect()
- ****************************************************************************/
-static void ip_nat_h245_expect(struct nf_conn *new,
-			       struct nf_conntrack_expect *this)
-{
-	nf_nat_follow_master(new, this);
-	nf_conntrack_h245_expect(new, this);
-}
-
 /****************************************************************************/
 static int nat_h245(struct sk_buff **pskb, struct nf_conn *ct,
 		    enum ip_conntrack_info ctinfo,
@@ -349,7 +337,7 @@ static int nat_h245(struct sk_buff **psk
 
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
-	exp->expectfn = ip_nat_h245_expect;
+	exp->expectfn = nf_nat_follow_master;
 	exp->dir = !dir;
 
 	/* Check existing expects */
@@ -399,7 +387,7 @@ static void ip_nat_q931_expect(struct nf
 
 	if (this->tuple.src.u3.ip != 0) {	/* Only accept calls from GK */
 		nf_nat_follow_master(new, this);
-		goto out;
+		return;
 	}
 
 	/* This must be a fresh one. */
@@ -420,9 +408,6 @@ static void ip_nat_q931_expect(struct nf
 
 	/* hook doesn't matter, but it has to do destination manip */
 	nf_nat_setup_info(new, &range, NF_IP_PRE_ROUTING);
-
-      out:
-	nf_conntrack_q931_expect(new, this);
 }
 
 /****************************************************************************/
@@ -510,8 +495,6 @@ static void ip_nat_callforwarding_expect
 
 	/* hook doesn't matter, but it has to do destination manip */
 	nf_nat_setup_info(new, &range, NF_IP_PRE_ROUTING);
-
-	nf_conntrack_q931_expect(new, this);
 }
 
 /****************************************************************************/
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 59de125..7041d25 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -211,6 +211,7 @@ void nf_conntrack_expect_init(struct nf_
 
 	exp->flags = 0;
 	exp->expectfn = NULL;
+	exp->helper = NULL;
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
 	exp->mask.src.l3num = 0xFFFF;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index bd3bb15..ee77ed3 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -128,7 +128,8 @@ void nf_conntrack_helper_unregister(stru
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list, list) {
 		struct nf_conn_help *help = nfct_help(exp->master);
-		if (help->helper == me && del_timer(&exp->timeout)) {
+		if ((exp->helper == me || help->helper == me) &&
+		    del_timer(&exp->timeout)) {
 			nf_ct_unlink_expect(exp);
 			nf_conntrack_expect_put(exp);
 		}
diff --git a/net/netfilter/nf_conntrack_helper_h323.c b/net/netfilter/nf_conntrack_helper_h323.c
index ed45ff2..1295a93 100644
--- a/net/netfilter/nf_conntrack_helper_h323.c
+++ b/net/netfilter/nf_conntrack_helper_h323.c
@@ -619,15 +619,6 @@ static struct nf_conntrack_helper nf_con
 };
 
 /****************************************************************************/
-void nf_conntrack_h245_expect(struct nf_conn *new,
-			      struct nf_conntrack_expect *this)
-{
-	write_lock_bh(&nf_conntrack_lock);
-	nfct_help(new)->helper = &nf_conntrack_helper_h245;
-	write_unlock_bh(&nf_conntrack_lock);
-}
-
-/****************************************************************************/
 int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 		  TransportAddress *taddr,
 		  union nf_conntrack_address *addr, __be16 *port)
@@ -685,6 +676,7 @@ static int expect_h245(struct sk_buff **
 				 &ct->tuplehash[!dir].tuple.src.u3,
 				 &ct->tuplehash[!dir].tuple.dst.u3,
 				 IPPROTO_TCP, NULL, &port);
+	exp->helper = &nf_conntrack_helper_h245;
 
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
 		   &ct->tuplehash[!dir].tuple.dst.u3,
@@ -694,8 +686,6 @@ static int expect_h245(struct sk_buff **
 		ret = nat_h245_hook(pskb, ct, ctinfo, data, dataoff, taddr,
 				    port, exp);
 	} else {		/* Conntrack only */
-		exp->expectfn = nf_conntrack_h245_expect;
-
 		if (nf_conntrack_expect_related(exp) == 0) {
 			DEBUGP("nf_ct_q931: expect H.245 ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
@@ -708,10 +698,6 @@ static int expect_h245(struct sk_buff **
 	return ret;
 }
 
-/* Forwarding declaration */
-void nf_conntrack_q931_expect(struct nf_conn *new,
-			      struct nf_conntrack_expect *this);
-
 /* If the calling party is on the same side of the forward-to party,
  * we don't need to track the second call */
 static int callforward_do_filter(union nf_conntrack_address *src,
@@ -767,6 +753,8 @@ #endif
 
 }
 
+static struct nf_conntrack_helper nf_conntrack_helper_q931;
+
 /****************************************************************************/
 static int expect_callforwarding(struct sk_buff **pskb,
 				 struct nf_conn *ct,
@@ -799,6 +787,7 @@ static int expect_callforwarding(struct 
 	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
 				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
 				 IPPROTO_TCP, NULL, &port);
+	exp->helper = &nf_conntrack_helper_q931;
 
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
 		   &ct->tuplehash[!dir].tuple.dst.u3,
@@ -808,8 +797,6 @@ static int expect_callforwarding(struct 
 		ret = nat_callforwarding_hook(pskb, ct, ctinfo, data, dataoff,
 					      taddr, port, exp);
 	} else {		/* Conntrack only */
-		exp->expectfn = nf_conntrack_q931_expect;
-
 		if (nf_conntrack_expect_related(exp) == 0) {
 			DEBUGP("nf_ct_q931: expect Call Forwarding ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
@@ -1203,15 +1190,6 @@ static struct nf_conntrack_helper nf_con
 };
 
 /****************************************************************************/
-void nf_conntrack_q931_expect(struct nf_conn *new,
-			      struct nf_conntrack_expect *this)
-{
-	write_lock_bh(&nf_conntrack_lock);
-	nfct_help(new)->helper = &nf_conntrack_helper_q931;
-	write_unlock_bh(&nf_conntrack_lock);
-}
-
-/****************************************************************************/
 static unsigned char *get_udp_data(struct sk_buff **pskb, unsigned int protoff,
 				   int *datalen)
 {
@@ -1295,14 +1273,13 @@ static int expect_q931(struct sk_buff **
 					NULL,
 				 &ct->tuplehash[!dir].tuple.dst.u3,
 				 IPPROTO_TCP, NULL, &port);
+	exp->helper = &nf_conntrack_helper_q931;
 	exp->flags = NF_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
 	if (nat_q931_hook && ct->status & IPS_NAT_MASK) {	/* Need NAT */
 		ret = nat_q931_hook(pskb, ct, ctinfo, data, taddr, i,
 				    port, exp);
 	} else {		/* Conntrack only */
-		exp->expectfn = nf_conntrack_q931_expect;
-
 		if (nf_conntrack_expect_related(exp) == 0) {
 			DEBUGP("nf_ct_ras: expect Q.931 ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
@@ -1331,9 +1308,7 @@ static int process_grq(struct sk_buff **
 	return 0;
 }
 
-/* Declare before using */
-static void nf_conntrack_ras_expect(struct nf_conn *new,
-				    struct nf_conntrack_expect *this);
+static struct nf_conntrack_helper nf_conntrack_helper_ras;
 
 /****************************************************************************/
 static int process_gcf(struct sk_buff **pskb, struct nf_conn *ct,
@@ -1366,7 +1341,7 @@ static int process_gcf(struct sk_buff **
 	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
 				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
 				 IPPROTO_UDP, NULL, &port);
-	exp->expectfn = nf_conntrack_ras_expect;
+	exp->helper = &nf_conntrack_helper_ras;
 
 	if (nf_conntrack_expect_related(exp) == 0) {
 		DEBUGP("nf_ct_ras: expect RAS ");
@@ -1562,8 +1537,8 @@ static int process_acf(struct sk_buff **
 	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
 				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
 				 IPPROTO_TCP, NULL, &port);
+	exp->helper = &nf_conntrack_helper_q931;
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	exp->expectfn = nf_conntrack_q931_expect;
 
 	if (nf_conntrack_expect_related(exp) == 0) {
 		DEBUGP("nf_ct_ras: expect Q.931 ");
@@ -1612,8 +1587,8 @@ static int process_lcf(struct sk_buff **
 	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
 				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
 				 IPPROTO_TCP, NULL, &port);
+	exp->helper = &nf_conntrack_helper_q931;
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	exp->expectfn = nf_conntrack_q931_expect;
 
 	if (nf_conntrack_expect_related(exp) == 0) {
 		DEBUGP("nf_ct_ras: expect Q.931 ");
@@ -1758,15 +1733,6 @@ static struct nf_conntrack_helper nf_con
 };
 
 /****************************************************************************/
-static void nf_conntrack_ras_expect(struct nf_conn *new,
-				    struct nf_conntrack_expect *this)
-{
-	write_lock_bh(&nf_conntrack_lock);
-	nfct_help(new)->helper = &nf_conntrack_helper_ras;
-	write_unlock_bh(&nf_conntrack_lock);
-}
-
-/****************************************************************************/
 /* Not __exit - called from init() */
 static void fini(void)
 {
@@ -1798,8 +1764,6 @@ module_init(init);
 module_exit(fini);
 
 EXPORT_SYMBOL_GPL(get_h225_addr);
-EXPORT_SYMBOL_GPL(nf_conntrack_h245_expect);
-EXPORT_SYMBOL_GPL(nf_conntrack_q931_expect);
 EXPORT_SYMBOL_GPL(set_h245_addr_hook);
 EXPORT_SYMBOL_GPL(set_h225_addr_hook);
 EXPORT_SYMBOL_GPL(set_sig_addr_hook);

--------------020704050106080708060801--
