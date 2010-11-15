From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] netfilter: rcu sparse cleanups
Date: Mon, 15 Nov 2010 19:39:08 +0100
Message-ID: <1289846348.2607.115.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42111 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab0KOSjN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:39:13 -0500
Received: by wwa36 with SMTP id 36so341981wwa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2010 10:39:12 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use RCU helpers to reduce number of sparse warnings
(CONFIG_SPARSE_RCU_POINTER=y), and adds lockdep checks.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/netfilter/nf_conntrack_expect.c |   15 ++++++++++++---
 net/netfilter/nf_conntrack_extend.c |    6 ++++--
 net/netfilter/nf_conntrack_helper.c |   10 ++++++++--
 net/netfilter/nf_conntrack_proto.c  |    4 ++--
 4 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index cab196c..bbb2140 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -337,7 +337,10 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	setup_timer(&exp->timeout, nf_ct_expectation_timed_out,
 		    (unsigned long)exp);
 	if (master_help) {
-		p = &master_help->helper->expect_policy[exp->class];
+		p = &rcu_dereference_protected(
+				master_help->helper,
+				lockdep_is_held(&nf_conntrack_lock)
+				)->expect_policy[exp->class];
 		exp->timeout.expires = jiffies + p->timeout * HZ;
 	}
 	add_timer(&exp->timeout);
@@ -373,7 +376,10 @@ static inline int refresh_timer(struct nf_conntrack_expect *i)
 	if (!del_timer(&i->timeout))
 		return 0;
 
-	p = &master_help->helper->expect_policy[i->class];
+	p = &rcu_dereference_protected(
+		master_help->helper,
+		lockdep_is_held(&nf_conntrack_lock)
+		)->expect_policy[i->class];
 	i->timeout.expires = jiffies + p->timeout * HZ;
 	add_timer(&i->timeout);
 	return 1;
@@ -411,7 +417,10 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	}
 	/* Will be over limit? */
 	if (master_help) {
-		p = &master_help->helper->expect_policy[expect->class];
+		p = &rcu_dereference_protected(
+			master_help->helper,
+			lockdep_is_held(&nf_conntrack_lock)
+			)->expect_policy[expect->class];
 		if (p->max_expected &&
 		    master_help->expecting[expect->class] >= p->max_expected) {
 			evict_oldest_expect(master, expect);
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 920f924..80a23ed 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -140,14 +140,16 @@ static void update_alloc_size(struct nf_ct_ext_type *type)
 	/* This assumes that extended areas in conntrack for the types
 	   whose NF_CT_EXT_F_PREALLOC bit set are allocated in order */
 	for (i = min; i <= max; i++) {
-		t1 = nf_ct_ext_types[i];
+		t1 = rcu_dereference_protected(nf_ct_ext_types[i],
+				lockdep_is_held(&nf_ct_ext_type_mutex));
 		if (!t1)
 			continue;
 
 		t1->alloc_size = ALIGN(sizeof(struct nf_ct_ext), t1->align) +
 				 t1->len;
 		for (j = 0; j < NF_CT_EXT_NUM; j++) {
-			t2 = nf_ct_ext_types[j];
+			t2 = rcu_dereference_protected(nf_ct_ext_types[j],
+				lockdep_is_held(&nf_ct_ext_type_mutex));
 			if (t2 == NULL || t2 == t1 ||
 			    (t2->flags & NF_CT_EXT_F_PREALLOC) == 0)
 				continue;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 59e1a4c..767bbe9 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -158,7 +158,10 @@ static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(i);
 	struct nf_conn_help *help = nfct_help(ct);
 
-	if (help && help->helper == me) {
+	if (help && rcu_dereference_protected(
+			help->helper,
+			lockdep_is_held(&nf_conntrack_lock)
+			) == me) {
 		nf_conntrack_event(IPCT_HELPER, ct);
 		rcu_assign_pointer(help->helper, NULL);
 	}
@@ -210,7 +213,10 @@ static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
 		hlist_for_each_entry_safe(exp, n, next,
 					  &net->ct.expect_hash[i], hnode) {
 			struct nf_conn_help *help = nfct_help(exp->master);
-			if ((help->helper == me || exp->helper == me) &&
+			if ((rcu_dereference_protected(
+					help->helper,
+					lockdep_is_held(&nf_conntrack_lock)
+					) == me || exp->helper == me) &&
 			    del_timer(&exp->timeout)) {
 				nf_ct_unlink_expect(exp);
 				nf_ct_expect_put(exp);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 03b56a0..5701c8d 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -284,7 +284,7 @@ int nf_conntrack_l4proto_register(struct nf_conntrack_l4proto *l4proto)
 	mutex_lock(&nf_ct_proto_mutex);
 	if (!nf_ct_protos[l4proto->l3proto]) {
 		/* l3proto may be loaded latter. */
-		struct nf_conntrack_l4proto **proto_array;
+		struct nf_conntrack_l4proto __rcu **proto_array;
 		int i;
 
 		proto_array = kmalloc(MAX_NF_CT_PROTO *
@@ -296,7 +296,7 @@ int nf_conntrack_l4proto_register(struct nf_conntrack_l4proto *l4proto)
 		}
 
 		for (i = 0; i < MAX_NF_CT_PROTO; i++)
-			proto_array[i] = &nf_conntrack_l4proto_generic;
+			RCU_INIT_POINTER(proto_array[i], &nf_conntrack_l4proto_generic);
 
 		/* Before making proto_array visible to lockless readers,
 		 * we must make sure its content is committed to memory.


