From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/20]: nf_conntrack: automatic helper assignment for
	expectations
Date: Sat,  2 Dec 2006 15:49:44 +0100 (MET)
Message-ID: <20061202145248.1381.24721.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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
commit fff1e474556ff5fcae813c7b73a0a95c2b7143fc
tree 7f00d21c569f225d6990741a96a2905a0a02d788
parent 3dc28b1e6e6e9e4f9064ab33fa57b56ccb9a7a67
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:57 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:57 +0100

 include/net/netfilter/nf_conntrack_expect.h |    3 +++
 net/netfilter/nf_conntrack_core.c           |   19 ++++++++++++++-----
 net/netfilter/nf_conntrack_ftp.c            |    1 +
 net/netfilter/nf_conntrack_helper.c         |    3 ++-
 net/netfilter/nf_conntrack_netlink.c        |    1 +
 5 files changed, 21 insertions(+), 6 deletions(-)

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
index a401b1e..f952a7f 100644
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
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index fdac52b..e96c41d 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -516,6 +516,7 @@ static int help(struct sk_buff **pskb,
 	}
 
 	exp->expectfn = NULL;
+	exp->helper = NULL;
 	exp->flags = 0;
 
 	/* Now, NAT might want to mangle the packet, and register the
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 2628f4b..81542dc 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -129,7 +129,8 @@ void nf_conntrack_helper_unregister(stru
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list, list) {
 		struct nf_conn_help *help = nfct_help(exp->master);
-		if (help->helper == me && del_timer(&exp->timeout)) {
+		if ((help->helper == me || exp->helper == me) &&
+		    del_timer(&exp->timeout)) {
 			nf_ct_unlink_expect(exp);
 			nf_conntrack_expect_put(exp);
 		}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a693d3b..acaef40 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1447,6 +1447,7 @@ ctnetlink_create_expect(struct nfattr *c
 	exp->expectfn = NULL;
 	exp->flags = 0;
 	exp->master = ct;
+	exp->helper = NULL;
 	memcpy(&exp->tuple, &tuple, sizeof(struct nf_conntrack_tuple));
 	memcpy(&exp->mask, &mask, sizeof(struct nf_conntrack_tuple));
 
