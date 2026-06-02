Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5245634BA20
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jun 2026 21:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780434611; cv=none; b=sTakr3cTLUI3BZMe4o232wZoA46WRZGhmcZNoCFgfBreDjzxFpFktz1h55SR7BMD+djGVkkremicCSfNpgAxbEVkejn8JmvVeY2x4NhZRUeznXB0tX8mpfumwXzS8Xhi1NolROAw9GXiOFtyFqCvb3dthJV17xhohSZkOX5ROKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780434611; c=relaxed/simple;
	bh=ipk17D16QBa90TC7HrYuvECFTWJxHo2P6WD5u0jmTM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsZWwcmFCx54C84bTNAHkY7+OFi4U9ZFRhoU5LPSAWFkV/+b46C56kf/6zrwemAwwieDa1VzFHuBrNrBIF4bZF1Z8/eKADsRWQ5dtt92qowvfJpOCLyd3AUNsZ/0qRLYFu9ImIcMMEY8DUTBJHGn8k3idSaedJF/4FS8p5r92IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bTBEYoap; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bTBEYoap"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C63606019E;
	Tue,  2 Jun 2026 23:10:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780434601;
	bh=RNfrt7TVYNbe1FMlk58WSloKNxOi6IMRKuicSmqRhNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTBEYoapZCH4+Q77nGMx1m7y/a3iOSb3LsNS8JgmbbMepFVQYqn1l8EjWUdbkjydb
	 YfMuZXynYepgHNLR+XmQjqeKe0OGN63StPV3n/r40aG9LIjHgu6Dob6zUG09Gszzug
	 HOkL2M085sMCxBT0hTL+T60Z6kwtUu8h7uuoC3qLvwwd+DRqIXF2abEr7FLkAb7G4E
	 i3p81cIF+PSfmSvSJ7PJpve5b7ZmS++Z1P9asiGwSnvYgVYTE82z5NEKEbjgk343D5
	 UBZTQfaAFzyzvNuc1BzWIiaI5rGLQoYp3zFqM3hRBadPclbtgobqWYJDoznpXLbNms
	 FxgY78Y1pXvJA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v3 4/6] netfilter: nf_conntrack_helper: add refcounting from datapath
Date: Tue,  2 Jun 2026 23:09:50 +0200
Message-ID: <20260602210952.736311-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602210952.736311-1-pablo@netfilter.org>
References: <20260602210952.736311-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds a new ->ct_refcnt field to struct nf_conntrack_helper
which is bumped when the helper is used by the ct helper extension. Drop
this reference count when the conntrack entry is released. This is a
packet path refcount which ensures that struct nf_conntrack_helper
remains in place for tricky scenarios where a packet sits in nfqueue, or
elsewhere, with a conntrack that refers to this helper.

For simplicity, this leaves a single refcount for helper objects in
place, remove the existing refcount for control plane that ensures that
the helper does not go away if it is used by ruleset.

On helper removal, the help callback is set to NULL to disable it from
packet path and, after rcu grace period, existing expectations are
removed. Update ctnetlink to disable access to .to_nlattr and
.from_nlattr if the helper is going away.

Remove nf_queue_nf_hook_drop() since it has proven not to be effective
because packets with unconfirmed conntracks which are still flying to
sit in nfqueue.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: address AI reviewer hints.

 include/net/netfilter/nf_conntrack_helper.h | 26 ++++++++++++---
 net/netfilter/nf_conntrack_core.c           |  3 +-
 net/netfilter/nf_conntrack_helper.c         | 37 +++++++--------------
 net/netfilter/nf_conntrack_netlink.c        | 28 ++++++++++------
 net/netfilter/nf_conntrack_ovs.c            |  9 ++++-
 net/netfilter/nf_conntrack_proto.c          | 15 ++++++---
 net/netfilter/nfnetlink_cthelper.c          | 14 +++-----
 net/netfilter/nft_ct.c                      |  3 +-
 net/netfilter/xt_CT.c                       |  3 --
 9 files changed, 77 insertions(+), 61 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 1956bc12bf56..ed93a5a1adc8 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -35,20 +35,22 @@ enum nf_ct_helper_flags {
 struct nf_conntrack_helper {
 	struct hlist_node hnode;	/* Internal use. */
 
+	struct rcu_head rcu;
+
 	char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
-	refcount_t refcnt;
 	struct module *me;		/* pointer to self */
 	struct nf_conntrack_expect_policy expect_policy[NF_CT_MAX_EXPECT_CLASSES];
 
+	refcount_t ct_refcnt;
+
 	/* Tuple of things we will help (compared against server response) */
 	struct nf_conntrack_tuple tuple;
 
 	/* Function to call when data passes; return verdict, or -1 to
            invalidate. */
-	int (*help)(struct sk_buff *skb,
-		    unsigned int protoff,
-		    struct nf_conn *ct,
-		    enum ip_conntrack_info conntrackinfo);
+	int __rcu (*help)(struct sk_buff *skb, unsigned int protoff,
+			  struct nf_conn *ct,
+			  enum ip_conntrack_info conntrackinfo);
 
 	void (*destroy)(struct nf_conn *ct);
 
@@ -138,6 +140,20 @@ static inline void *nfct_help_data(const struct nf_conn *ct)
 	return (void *)help->data;
 }
 
+static inline void nf_ct_help_put(const struct nf_conn *ct)
+{
+	struct nf_conntrack_helper *helper;
+	struct nf_conn_help *help;
+
+	help = nfct_help(ct);
+	if (!help)
+		return;
+
+	helper = rcu_dereference(help->helper);
+	if (helper && refcount_dec_and_test(&helper->ct_refcnt))
+		kfree_rcu(helper, rcu);
+}
+
 int nf_conntrack_helper_init(void);
 void nf_conntrack_helper_fini(void);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2e8f47ad1a8f..31e0bae1d75d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1746,6 +1746,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 			nat_hook->remove_nat_bysrc(ct);
 	}
 
+	nf_ct_help_put(ct);
 	nf_ct_timeout_put(ct);
 	rcu_read_unlock();
 
@@ -1829,7 +1830,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			assign_helper = rcu_dereference(exp->assign_helper);
 			if (assign_helper) {
 				help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
-				if (help)
+				if (help && refcount_inc_not_zero(&assign_helper->ct_refcnt))
 					rcu_assign_pointer(help->helper, assign_helper);
 			}
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 6161b4707011..d31ebd908e47 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -92,7 +92,7 @@ nf_conntrack_helper_try_module_get(const char *name, u16 l3num, u8 protonum)
 #endif
 	if (h != NULL && !try_module_get(h->me))
 		h = NULL;
-	if (h != NULL && !refcount_inc_not_zero(&h->refcnt)) {
+	if (h != NULL && !refcount_inc_not_zero(&h->ct_refcnt)) {
 		module_put(h->me);
 		h = NULL;
 	}
@@ -105,8 +105,9 @@ EXPORT_SYMBOL_GPL(nf_conntrack_helper_try_module_get);
 
 void nf_conntrack_helper_put(struct nf_conntrack_helper *helper)
 {
-	refcount_dec(&helper->refcnt);
 	module_put(helper->me);
+	if (refcount_dec_and_test(&helper->ct_refcnt))
+		kfree_rcu(helper, rcu);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_put);
 
@@ -231,26 +232,13 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 		}
 	}
 
-	rcu_assign_pointer(help->helper, helper);
+	if (refcount_inc_not_zero(&helper->ct_refcnt))
+		rcu_assign_pointer(help->helper, helper);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
 
-/* appropriate ct lock protecting must be taken by caller */
-static int unhelp(struct nf_conn *ct, void *me)
-{
-	struct nf_conn_help *help = nfct_help(ct);
-
-	if (help && rcu_dereference_raw(help->helper) == me) {
-		nf_conntrack_event(IPCT_HELPER, ct);
-		RCU_INIT_POINTER(help->helper, NULL);
-	}
-
-	/* We are not intended to delete this conntrack. */
-	return 0;
-}
-
 void nf_ct_helper_destroy(struct nf_conn *ct)
 {
 	struct nf_conn_help *help = nfct_help(ct);
@@ -386,7 +374,7 @@ int __nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 			}
 		}
 	}
-	refcount_set(&me->refcnt, 1);
+	refcount_set(&me->ct_refcnt, 1);
 	hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
 	nf_ct_helper_count++;
 out:
@@ -444,19 +432,18 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	nf_ct_helper_count--;
 	mutex_unlock(&nf_ct_helper_mutex);
 
+	/* This helper is going away, disable it. */
+	rcu_assign_pointer(me->help, NULL);
+
 	/* Make sure every nothing is still using the helper unless its a
 	 * connection in the hash.
 	 */
 	synchronize_rcu();
 
 	nf_ct_expect_iterate_destroy(expect_iter_me, me);
-	nf_ct_iterate_destroy(unhelp, me);
 
-	/* nf_ct_iterate_destroy() does an unconditional synchronize_rcu() as
-	 * last step, this ensures rcu readers of exp->helper are done.
-	 * No need for another synchronize_rcu() here.
-	 */
-	kfree(me);
+	if (refcount_dec_and_test(&me->ct_refcnt))
+		kfree_rcu(me, rcu);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
@@ -478,7 +465,7 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 	helper->tuple.dst.protonum = protonum;
 	helper->tuple.src.u.all = htons(spec_port);
 
-	helper->help = help;
+	rcu_assign_pointer(helper->help, help);
 	helper->from_nlattr = from_nlattr;
 	helper->me = module;
 	snprintf(helper->nat_mod_name, sizeof(helper->nat_mod_name),
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index befa7e83ee49..958b3d6116f5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -240,7 +240,8 @@ static int ctnetlink_dump_helpinfo(struct sk_buff *skb,
 	if (nla_put_string(skb, CTA_HELP_NAME, helper->name))
 		goto nla_put_failure;
 
-	if (helper->to_nlattr)
+	if (rcu_access_pointer(helper->help) &&
+	    helper->to_nlattr)
 		helper->to_nlattr(skb, ct);
 
 	nla_nest_end(skb, nest_helper);
@@ -1935,6 +1936,7 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 	if (err < 0)
 		return err;
 
+	rcu_read_lock();
 	/* don't change helper of sibling connections */
 	if (ct->master) {
 		/* If we try to change the helper to the same thing twice,
@@ -1943,27 +1945,27 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 		 */
 		err = -EBUSY;
 		if (help) {
-			rcu_read_lock();
 			helper = rcu_dereference(help->helper);
 			if (helper && !strcmp(helper->name, helpname))
 				err = 0;
-			rcu_read_unlock();
 		}
-
+		rcu_read_unlock();
 		return err;
 	}
 
-	if (!strcmp(helpname, "")) {
-		if (help && help->helper) {
+	if (!strcmp(helpname, "") && help) {
+		helper = rcu_dereference(help->helper);
+		if (helper) {
 			/* we had a helper before ... */
 			nf_ct_remove_expectations(ct);
 			RCU_INIT_POINTER(help->helper, NULL);
+			if (refcount_dec_and_test(&helper->ct_refcnt))
+				kfree_rcu(helper, rcu);
 		}
-
+		rcu_read_unlock();
 		return 0;
 	}
 
-	rcu_read_lock();
 	helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
 					    nf_ct_protonum(ct));
 	if (helper == NULL) {
@@ -1974,7 +1976,8 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 	if (help) {
 		if (rcu_access_pointer(help->helper) == helper) {
 			/* update private helper data if allowed. */
-			if (helper->from_nlattr)
+			if (rcu_access_pointer(helper->help) &&
+			    helper->from_nlattr)
 				helper->from_nlattr(helpinfo, ct);
 			err = 0;
 		} else
@@ -2289,11 +2292,16 @@ ctnetlink_create_conntrack(struct net *net,
 				goto err2;
 			}
 			/* set private helper data if allowed. */
-			if (helper->from_nlattr)
+			if (rcu_access_pointer(helper->help) &&
+			    helper->from_nlattr)
 				helper->from_nlattr(helpinfo, ct);
 
 			/* disable helper auto-assignment for this entry */
 			ct->status |= IPS_HELPER;
+			if (!refcount_inc_not_zero(&helper->ct_refcnt)) {
+				err = -ENOENT;
+				goto err2;
+			}
 			RCU_INIT_POINTER(help->helper, helper);
 		}
 	}
diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index a6988eeb1579..49d1511e9921 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -12,6 +12,9 @@
 int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 		 enum ip_conntrack_info ctinfo, u16 proto)
 {
+	int (*helper_cb)(struct sk_buff *skb, unsigned int protoff,
+			 struct nf_conn *ct,
+			 enum ip_conntrack_info conntrackinfo);
 	const struct nf_conntrack_helper *helper;
 	const struct nf_conn_help *help;
 	unsigned int protoff;
@@ -60,7 +63,11 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 	if (helper->tuple.dst.protonum != proto)
 		return NF_ACCEPT;
 
-	err = helper->help(skb, protoff, ct, ctinfo);
+	helper_cb = rcu_dereference(helper->help);
+	if (!helper_cb)
+		return NF_ACCEPT;
+
+	err = helper_cb(skb, protoff, ct, ctinfo);
 	if (err != NF_ACCEPT)
 		return err;
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 50ddd3d613e1..ad96896516b6 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -129,6 +129,9 @@ unsigned int nf_confirm(void *priv,
 			struct sk_buff *skb,
 			const struct nf_hook_state *state)
 {
+	int (*helper_cb)(struct sk_buff *skb, unsigned int protoff,
+			 struct nf_conn *ct,
+			 enum ip_conntrack_info conntrackinfo);
 	const struct nf_conn_help *help;
 	enum ip_conntrack_info ctinfo;
 	unsigned int protoff;
@@ -175,11 +178,13 @@ unsigned int nf_confirm(void *priv,
 		/* rcu_read_lock()ed by nf_hook */
 		helper = rcu_dereference(help->helper);
 		if (helper) {
-			ret = helper->help(skb,
-					   protoff,
-					   ct, ctinfo);
-			if (ret != NF_ACCEPT)
-				return ret;
+			helper_cb = rcu_dereference(helper->help);
+			if (helper_cb) {
+				ret = helper_cb(skb, protoff,
+						ct, ctinfo);
+				if (ret != NF_ACCEPT)
+					return ret;
+			}
 		}
 	}
 
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index a08f5da9888e..13a1229e9b29 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -713,15 +713,11 @@ static int nfnl_cthelper_del(struct sk_buff *skb, const struct nfnl_info *info,
 		     tuple.dst.protonum != cur->tuple.dst.protonum))
 			continue;
 
-		if (refcount_dec_if_one(&cur->refcnt)) {
-			found = true;
-			nf_conntrack_helper_unregister(cur);
-
-			list_del(&nlcth->list);
-			kfree(nlcth);
-		} else {
-			ret = -EBUSY;
-		}
+		found = true;
+		nf_conntrack_helper_unregister(cur);
+
+		list_del(&nlcth->list);
+		kfree(nlcth);
 	}
 
 	/* Make sure we return success if we flush and there is no helpers */
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 801c01c6af95..9fe179d688da 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1101,7 +1101,6 @@ static void nft_ct_helper_obj_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_ct_helper_obj *priv = nft_obj_data(obj);
 
-	nf_queue_nf_hook_drop(ctx->net);
 	if (priv->helper4)
 		nf_conntrack_helper_put(priv->helper4);
 	if (priv->helper6)
@@ -1144,7 +1143,7 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
 		return;
 
 	help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
-	if (help) {
+	if (help && refcount_inc_not_zero(&to_assign->ct_refcnt)) {
 		rcu_assign_pointer(help->helper, to_assign);
 		set_bit(IPS_HELPER_BIT, &ct->status);
 
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index b94f004d5f5c..e78660dfdf4b 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -284,9 +284,6 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 	struct nf_conn_help *help;
 
 	if (ct) {
-		if (info->helper[0])
-			nf_queue_nf_hook_drop(par->net);
-
 		help = nfct_help(ct);
 		xt_ct_put_helper(help);
 
-- 
2.47.3

