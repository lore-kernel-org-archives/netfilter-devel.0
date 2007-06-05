From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/03]: nf_conntrack: fix helper module unload races
Date: Tue,  5 Jun 2007 15:35:10 +0200 (MEST)
Message-ID: <20070605133509.10309.45032.sendpatchset@localhost.localdomain>
References: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: fix helper module unload races

When a helper module is unloaded all conntracks refering to it have their
helper pointer NULLed out, leading to lots of races. In most places this
can be fixed by proper use of RCU (they do already check for != NULL,
but in a racy way), additionally nf_conntrack_expect_related needs to
bail out when no helper is present.

Also remove two paranoid BUG_ONs in nf_conntrack_proto_gre that are racy
and not worth fixing.

Signed-off-by: Patrick McHarrdy <kaber@trash.net>

---
commit eed17841cda83ffa195b9e5ec4d5ee4b6840ed17
tree 1bca5e37fc461999f2160c3b0673a12649ea2023
parent 5ecd3100e695228ac5e0ce0e325e252c0f11806f
author Patrick McHardy <kaber@trash.net> Tue, 05 Jun 2007 14:22:34 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 05 Jun 2007 14:22:34 +0200

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   13 ++++++---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    9 +++++-
 net/netfilter/nf_conntrack_core.c              |   26 +++++++++++++-----
 net/netfilter/nf_conntrack_expect.c            |    4 +++
 net/netfilter/nf_conntrack_helper.c            |    2 +
 net/netfilter/nf_conntrack_netlink.c           |   34 ++++++++++++++++--------
 net/netfilter/nf_conntrack_proto_gre.c         |    2 -
 7 files changed, 61 insertions(+), 29 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index fd62a41..6dc72a8 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -133,6 +133,7 @@ static unsigned int ipv4_conntrack_help(unsigned int hooknum,
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_help *help;
+	struct nf_conntrack_helper *helper;
 
 	/* This is where we call the helper: as the packet goes out. */
 	ct = nf_ct_get(*pskb, &ctinfo);
@@ -140,12 +141,14 @@ static unsigned int ipv4_conntrack_help(unsigned int hooknum,
 		return NF_ACCEPT;
 
 	help = nfct_help(ct);
-	if (!help || !help->helper)
+	if (!help)
 		return NF_ACCEPT;
-
-	return help->helper->help(pskb,
-				  skb_network_offset(*pskb) + ip_hdrlen(*pskb),
-				  ct, ctinfo);
+	/* rcu_read_lock()ed by nf_hook_slow */
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return NF_ACCEPT;
+	return helper->help(pskb, skb_network_offset(*pskb) + ip_hdrlen(*pskb),
+			    ct, ctinfo);
 }
 
 static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index dc442fb..1b1797f 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -160,6 +160,7 @@ static unsigned int ipv6_confirm(unsigned int hooknum,
 {
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
+	struct nf_conntrack_helper *helper;
 	enum ip_conntrack_info ctinfo;
 	unsigned int ret, protoff;
 	unsigned int extoff = (u8 *)(ipv6_hdr(*pskb) + 1) - (*pskb)->data;
@@ -172,7 +173,11 @@ static unsigned int ipv6_confirm(unsigned int hooknum,
 		goto out;
 
 	help = nfct_help(ct);
-	if (!help || !help->helper)
+	if (!help)
+		goto out;
+	/* rcu_read_lock()ed by nf_hook_slow */
+	helper = rcu_dereference(help->helper);
+	if (!helper)
 		goto out;
 
 	protoff = nf_ct_ipv6_skip_exthdr(*pskb, extoff, &pnum,
@@ -182,7 +187,7 @@ static unsigned int ipv6_confirm(unsigned int hooknum,
 		return NF_ACCEPT;
 	}
 
-	ret = help->helper->help(pskb, protoff, ct, ctinfo);
+	ret = helper->help(pskb, protoff, ct, ctinfo);
 	if (ret != NF_ACCEPT)
 		return ret;
 out:
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 483e927..7a15e30 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -350,9 +350,15 @@ static void death_by_timeout(unsigned long ul_conntrack)
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
 	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_helper *helper;
 
-	if (help && help->helper && help->helper->destroy)
-		help->helper->destroy(ct);
+	if (help) {
+		rcu_read_lock();
+		helper = rcu_dereference(help->helper);
+		if (helper && helper->destroy)
+			helper->destroy(ct);
+		rcu_read_unlock();
+	}
 
 	write_lock_bh(&nf_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
@@ -661,6 +667,7 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 	       unsigned int dataoff)
 {
 	struct nf_conn *conntrack;
+	struct nf_conn_help *help;
 	struct nf_conntrack_tuple repl_tuple;
 	struct nf_conntrack_expect *exp;
 	u_int32_t features = 0;
@@ -691,6 +698,7 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 	write_lock_bh(&nf_conntrack_lock);
 	exp = find_expectation(tuple);
 
+	help = nfct_help(conntrack);
 	if (exp) {
 		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
 			conntrack, exp);
@@ -698,7 +706,7 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
 		conntrack->master = exp->master;
 		if (exp->helper)
-			nfct_help(conntrack)->helper = exp->helper;
+			rcu_assign_pointer(help->helper, exp->helper);
 #ifdef CONFIG_NF_CONNTRACK_MARK
 		conntrack->mark = exp->master->mark;
 #endif
@@ -708,10 +716,11 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 		nf_conntrack_get(&conntrack->master->ct_general);
 		NF_CT_STAT_INC(expect_new);
 	} else {
-		struct nf_conn_help *help = nfct_help(conntrack);
-
-		if (help)
-			help->helper = __nf_ct_helper_find(&repl_tuple);
+		if (help) {
+			/* not in hash table yet, so not strictly necessary */
+			rcu_assign_pointer(help->helper,
+					   __nf_ct_helper_find(&repl_tuple));
+		}
 		NF_CT_STAT_INC(new);
 	}
 
@@ -893,7 +902,8 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 		helper = __nf_ct_helper_find(newreply);
 		if (helper)
 			memset(&help->help, 0, sizeof(help->help));
-		help->helper = helper;
+		/* not in hash table yet, so not strictly necessary */
+		rcu_assign_pointer(help->helper, helper);
 	}
 	write_unlock_bh(&nf_conntrack_lock);
 }
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 117cbfd..504fb6c 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -337,6 +337,10 @@ int nf_conntrack_expect_related(struct nf_conntrack_expect *expect)
 	NF_CT_ASSERT(master_help);
 
 	write_lock_bh(&nf_conntrack_lock);
+	if (!master_help->helper) {
+		ret = -ESHUTDOWN;
+		goto out;
+	}
 	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
 		if (expect_matches(i, expect)) {
 			/* Refresh timer: if it's dying, ignore.. */
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 0743be4..f868b7f 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -93,7 +93,7 @@ static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 
 	if (help && help->helper == me) {
 		nf_conntrack_event(IPCT_HELPER, ct);
-		help->helper = NULL;
+		rcu_assign_pointer(help->helper, NULL);
 	}
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d6d39e2..3f73327 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -171,21 +171,29 @@ ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	struct nfattr *nest_helper;
 	const struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_helper *helper;
 
-	if (!help || !help->helper)
+	if (!help)
 		return 0;
 
+	rcu_read_lock();
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		goto out;
+
 	nest_helper = NFA_NEST(skb, CTA_HELP);
-	NFA_PUT(skb, CTA_HELP_NAME, strlen(help->helper->name), help->helper->name);
+	NFA_PUT(skb, CTA_HELP_NAME, strlen(helper->name), helper->name);
 
-	if (help->helper->to_nfattr)
-		help->helper->to_nfattr(skb, ct);
+	if (helper->to_nfattr)
+		helper->to_nfattr(skb, ct);
 
 	NFA_NEST_END(skb, nest_helper);
-
+out:
+	rcu_read_unlock();
 	return 0;
 
 nfattr_failure:
+	rcu_read_unlock();
 	return -1;
 }
 
@@ -842,7 +850,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
 		if (help && help->helper) {
 			/* we had a helper before ... */
 			nf_ct_remove_expectations(ct);
-			help->helper = NULL;
+			rcu_assign_pointer(help->helper, NULL);
 		}
 
 		return 0;
@@ -866,7 +874,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
 
 	/* need to zero data of old helper */
 	memset(&help->help, 0, sizeof(help->help));
-	help->helper = helper;
+	rcu_assign_pointer(help->helper, helper);
 
 	return 0;
 }
@@ -950,6 +958,7 @@ ctnetlink_create_conntrack(struct nfattr *cda[],
 	struct nf_conn *ct;
 	int err = -EINVAL;
 	struct nf_conn_help *help;
+	struct nf_conntrack_helper *helper = NULL;
 
 	ct = nf_conntrack_alloc(otuple, rtuple);
 	if (ct == NULL || IS_ERR(ct))
@@ -980,14 +989,17 @@ ctnetlink_create_conntrack(struct nfattr *cda[],
 #endif
 
 	help = nfct_help(ct);
-	if (help)
-		help->helper = nf_ct_helper_find_get(rtuple);
+	if (help) {
+		helper = nf_ct_helper_find_get(rtuple);
+		/* not in hash table yet so not strictly necessary */
+		rcu_assign_pointer(help->helper, helper);
+	}
 
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
 
-	if (help && help->helper)
-		nf_ct_helper_put(help->helper);
+	if (helper)
+		nf_ct_helper_put(helper);
 
 	return 0;
 
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 5434472..339c397 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -100,7 +100,6 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_ct_gre_keymap **kmp, *km;
 
-	BUG_ON(strcmp(help->helper->name, "pptp"));
 	kmp = &help->help.ct_pptp_info.keymap[dir];
 	if (*kmp) {
 		/* check whether it's a retransmission */
@@ -137,7 +136,6 @@ void nf_ct_gre_keymap_destroy(struct nf_conn *ct)
 	enum ip_conntrack_dir dir;
 
 	DEBUGP("entering for ct %p\n", ct);
-	BUG_ON(strcmp(help->helper->name, "pptp"));
 
 	write_lock_bh(&nf_ct_gre_lock);
 	for (dir = IP_CT_DIR_ORIGINAL; dir < IP_CT_DIR_MAX; dir++) {
