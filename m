From: Patrick McHardy <kaber@trash.net>
Subject: nf_conntrack allocation issue
Date: Thu, 30 Nov 2006 16:45:19 +0100
Message-ID: <456EFC8F.2000507@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000607030109050702040003"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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
--------------000607030109050702040003
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

I've added these three patches to fix the allocation problems.
I don't want to add the new module option introduced by
Jozsef's patch since the current situation is just ridiculous,
we need to search for both helpers and expectations twice for
every new connection, so this needs to be redesigned anyway.

It seems to work fine in some quick testing. This was the
last problem I'm aware of, so I'm probably going to push
all patches soon.

Last thing is the helper renaming, any objections to prefix
all helpers with nf_conntrack_helper_?

--------------000607030109050702040003
Content-Type: text/plain;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: nf_conntrack: automatic helper assignment for expectations

Some helpers (namely H.323) manually assign further helpers to expected
connections. This is not possible with nf_conntrack anymore since we
need to know whether a helper is used at allocation time.

Handle the helper assignment centrally, which allows to perform the
correct allocation and as a nice side effect eliminates the need
for the H.323 helper to fiddle with nf_conntrack_lock.

Mid term the allocation scheme really needs to be redesigned since
we do both the helper and expectation lookup _twice_ for every new
connection.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fa7ba8735f8bdcc47b2ca5d11c1b8ec6fb7ae241
tree ddcc58530cfeded09283ffd6659c6a44aaaeb294
parent 35d1fac7ef0f6a79e41f86af6d28036570dc21b9
author Patrick McHardy <kaber@trash.net> Thu, 30 Nov 2006 16:23:42 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 30 Nov 2006 16:23:42 +0100

 include/net/netfilter/nf_conntrack_expect.h |    3 +++
 net/netfilter/nf_conntrack_core.c           |   19 ++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 2d335f0..5d853e8 100644
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
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a672806..44b8744 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -545,10 +545,10 @@ static int early_drop(struct list_head *
 static struct nf_conn *
 __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 		     const struct nf_conntrack_tuple *repl,
-		     const struct nf_conntrack_l3proto *l3proto)
+		     const struct nf_conntrack_l3proto *l3proto,
+		     u_int32_t features)
 {
 	struct nf_conn *conntrack = NULL;
-	u_int32_t features = 0;
 	struct nf_conntrack_helper *helper;
 
 	if (unlikely(!nf_conntrack_hash_rnd_initted)) {
@@ -574,7 +574,7 @@ __nf_conntrack_alloc(const struct nf_con
 	}
 
 	/*  find features needed by this conntrack. */
-	features = l3proto->get_features(orig);
+	features |= l3proto->get_features(orig);
 
 	/* FIXME: protect helper list per RCU */
 	read_lock_bh(&nf_conntrack_lock);
@@ -624,7 +624,7 @@ struct nf_conn *nf_conntrack_alloc(const
 	struct nf_conntrack_l3proto *l3proto;
 
 	l3proto = __nf_ct_l3proto_find(orig->src.l3num);
-	return __nf_conntrack_alloc(orig, repl, l3proto);
+	return __nf_conntrack_alloc(orig, repl, l3proto, 0);
 }
 
 void nf_conntrack_free(struct nf_conn *conntrack)
@@ -649,13 +649,20 @@ init_conntrack(const struct nf_conntrack
 	struct nf_conn *conntrack;
 	struct nf_conntrack_tuple repl_tuple;
 	struct nf_conntrack_expect *exp;
+	u_int32_t features = 0;
 
 	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, l4proto)) {
 		DEBUGP("Can't invert tuple.\n");
 		return NULL;
 	}
 
-	conntrack = __nf_conntrack_alloc(tuple, &repl_tuple, l3proto);
+	read_lock_bh(&nf_conntrack_lock);
+	exp = __nf_conntrack_expect_find(tuple);
+	if (exp && exp->helper)
+		features = NF_CT_F_HELP;
+	read_unlock_bh(&nf_conntrack_lock);
+
+	conntrack = __nf_conntrack_alloc(tuple, &repl_tuple, l3proto, features);
 	if (conntrack == NULL || IS_ERR(conntrack)) {
 		DEBUGP("Can't allocate conntrack.\n");
 		return (struct nf_conntrack_tuple_hash *)conntrack;
@@ -676,6 +683,8 @@ init_conntrack(const struct nf_conntrack
 		/* Welcome, Mr. Bond.  We've been expecting you... */
 		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
 		conntrack->master = exp->master;
+		if (exp->helper)
+			nfct_help(conntrack)->helper = exp->helper;
 #ifdef CONFIG_NF_CONNTRACK_MARK
 		conntrack->mark = exp->master->mark;
 #endif

--------------000607030109050702040003
Content-Type: text/plain;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b41e785..8c34b67 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -579,7 +579,8 @@ __nf_conntrack_alloc(const struct nf_con
 	/* FIXME: protect helper list per RCU */
 	read_lock_bh(&nf_conntrack_lock);
 	helper = __nf_ct_helper_find(repl);
-	if (helper)
+	/* NAT might want to assign a helper later */
+	if (helper || features & NF_CT_F_NAT)
 		features |= NF_CT_F_HELP;
 	read_unlock_bh(&nf_conntrack_lock);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 83242cd..91b7859 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -866,7 +866,7 @@ void nf_conntrack_alter_reply(struct nf_
 	NF_CT_DUMP_TUPLE(newreply);
 
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (!conntrack->master && help->expecting == 0)
+	if (!conntrack->master && help && help->expecting == 0)
 		help->helper = __nf_ct_helper_find(newreply);
 	write_unlock_bh(&nf_conntrack_lock);
 }

--------------000607030109050702040003
Content-Type: text/plain;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index a7e818d..c9ff0c6 100644
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
diff --git a/net/netfilter/nf_conntrack_helper_h323.c b/net/netfilter/nf_conntrack_helper_h323.c
index 67b935b..755c195 100644
--- a/net/netfilter/nf_conntrack_helper_h323.c
+++ b/net/netfilter/nf_conntrack_helper_h323.c
@@ -109,6 +109,10 @@ int (*nat_q931_hook) (struct sk_buff **p
 static DEFINE_SPINLOCK(nf_h323_lock);
 static char *h323_buffer;
 
+static struct nf_conntrack_helper nf_conntrack_helper_h245;
+static struct nf_conntrack_helper nf_conntrack_helper_q931;
+static struct nf_conntrack_helper nf_conntrack_helper_ras;
+
 /****************************************************************************/
 static int get_tpkt_data(struct sk_buff **pskb, unsigned int protoff,
 			 struct nf_conn *ct, enum ip_conntrack_info ctinfo,
@@ -304,9 +308,6 @@ static int expect_rtp_rtcp(struct sk_buf
 		ret = nat_rtp_rtcp(pskb, ct, ctinfo, data, dataoff,
 				   taddr, port, rtp_port, rtp_exp, rtcp_exp);
 	} else {		/* Conntrack only */
-		rtp_exp->expectfn = NULL;
-		rtcp_exp->expectfn = NULL;
-
 		if (nf_conntrack_expect_related(rtp_exp) == 0) {
 			if (nf_conntrack_expect_related(rtcp_exp) == 0) {
 				DEBUGP("nf_ct_h323: expect RTP ");
@@ -365,7 +366,6 @@ static int expect_t120(struct sk_buff **
 		ret = nat_t120(pskb, ct, ctinfo, data, dataoff, taddr,
 			       port, exp);
 	} else {		/* Conntrack only */
-		exp->expectfn = NULL;
 		if (nf_conntrack_expect_related(exp) == 0) {
 			DEBUGP("nf_ct_h323: expect T.120 ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
@@ -622,15 +622,6 @@ static struct nf_conntrack_helper nf_con
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
@@ -689,6 +680,7 @@ static int expect_h245(struct sk_buff **
 				 &ct->tuplehash[!dir].tuple.src.u3,
 				 &ct->tuplehash[!dir].tuple.dst.u3,
 				 IPPROTO_TCP, NULL, &port);
+	exp->helper = &nf_conntrack_helper_h245;
 
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
 		   &ct->tuplehash[!dir].tuple.dst.u3,
@@ -699,8 +691,6 @@ static int expect_h245(struct sk_buff **
 		ret = nat_h245(pskb, ct, ctinfo, data, dataoff, taddr,
 			       port, exp);
 	} else {		/* Conntrack only */
-		exp->expectfn = nf_conntrack_h245_expect;
-
 		if (nf_conntrack_expect_related(exp) == 0) {
 			DEBUGP("nf_ct_q931: expect H.245 ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
@@ -713,10 +703,6 @@ static int expect_h245(struct sk_buff **
 	return ret;
 }
 
-/* Forwarding declaration */
-void nf_conntrack_q931_expect(struct nf_conn *new,
-			      struct nf_conntrack_expect *this);
-
 /* If the calling party is on the same side of the forward-to party,
  * we don't need to track the second call */
 static int callforward_do_filter(union nf_conntrack_address *src,
@@ -805,6 +791,7 @@ static int expect_callforwarding(struct 
 	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
 				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
 				 IPPROTO_TCP, NULL, &port);
+	exp->helper = &nf_conntrack_helper_q931;
 
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
 		   &ct->tuplehash[!dir].tuple.dst.u3,
@@ -815,8 +802,6 @@ static int expect_callforwarding(struct 
 		ret = nat_callforwarding(pskb, ct, ctinfo, data, dataoff,
 					 taddr, port, exp);
 	} else {		/* Conntrack only */
-		exp->expectfn = nf_conntrack_q931_expect;
-
 		if (nf_conntrack_expect_related(exp) == 0) {
 			DEBUGP("nf_ct_q931: expect Call Forwarding ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
@@ -1210,15 +1195,6 @@ static struct nf_conntrack_helper nf_con
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
@@ -1303,14 +1279,13 @@ static int expect_q931(struct sk_buff **
 					NULL,
 				 &ct->tuplehash[!dir].tuple.dst.u3,
 				 IPPROTO_TCP, NULL, &port);
+	exp->helper = &nf_conntrack_helper_q931;
 	exp->flags = NF_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
 	nat_q931 = rcu_dereference(nat_q931_hook);
 	if (nat_q931 && ct->status & IPS_NAT_MASK) {	/* Need NAT */
 		ret = nat_q931(pskb, ct, ctinfo, data, taddr, i, port, exp);
 	} else {		/* Conntrack only */
-		exp->expectfn = nf_conntrack_q931_expect;
-
 		if (nf_conntrack_expect_related(exp) == 0) {
 			DEBUGP("nf_ct_ras: expect Q.931 ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
@@ -1342,10 +1317,6 @@ static int process_grq(struct sk_buff **
 	return 0;
 }
 
-/* Declare before using */
-static void nf_conntrack_ras_expect(struct nf_conn *new,
-				    struct nf_conntrack_expect *this);
-
 /****************************************************************************/
 static int process_gcf(struct sk_buff **pskb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
@@ -1377,7 +1348,7 @@ static int process_gcf(struct sk_buff **
 	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
 				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
 				 IPPROTO_UDP, NULL, &port);
-	exp->expectfn = nf_conntrack_ras_expect;
+	exp->helper = &nf_conntrack_helper_ras;
 
 	if (nf_conntrack_expect_related(exp) == 0) {
 		DEBUGP("nf_ct_ras: expect RAS ");
@@ -1583,7 +1554,7 @@ static int process_acf(struct sk_buff **
 				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
 				 IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	exp->expectfn = nf_conntrack_q931_expect;
+	exp->helper = &nf_conntrack_helper_q931;
 
 	if (nf_conntrack_expect_related(exp) == 0) {
 		DEBUGP("nf_ct_ras: expect Q.931 ");
@@ -1636,7 +1607,7 @@ static int process_lcf(struct sk_buff **
 				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
 				 IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	exp->expectfn = nf_conntrack_q931_expect;
+	exp->helper = &nf_conntrack_helper_q931;
 
 	if (nf_conntrack_expect_related(exp) == 0) {
 		DEBUGP("nf_ct_ras: expect Q.931 ");
@@ -1785,15 +1756,6 @@ static struct nf_conntrack_helper nf_con
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
@@ -1825,8 +1787,6 @@ module_init(init);
 module_exit(fini);
 
 EXPORT_SYMBOL_GPL(get_h225_addr);
-EXPORT_SYMBOL_GPL(nf_conntrack_h245_expect);
-EXPORT_SYMBOL_GPL(nf_conntrack_q931_expect);
 EXPORT_SYMBOL_GPL(set_h245_addr_hook);
 EXPORT_SYMBOL_GPL(set_h225_addr_hook);
 EXPORT_SYMBOL_GPL(set_sig_addr_hook);

--------------000607030109050702040003--
