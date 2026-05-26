Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9419A3D4123
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 16:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813662; cv=none; b=Zwu/4mtlxiotTUUZyfvalPd8UfdEW+eWSUWIHcvbI4WWfrR0jQVVvKz96wTOHS2NaUUEjL3yTLARzYomRBV0B9GL8Rh9Tl5NDp01yDcU+W6Jo1XCKttgApO0FD2vuO6t5TqnCdJYJ6eG5lLi0oA6dB/61256JRj3ENjOHVd4GGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813662; c=relaxed/simple;
	bh=zPlrSJILIEJb/IZw2oJRXz7pipV9Zuomhde5JE8kAVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvxgRol9p223qjJk65hwpu0whv55AkW5UQLooKKpgl1I273RkBvJaCULz9juetweOlhf+2PiQ8C4bLqh2/TSEVKn9+H1NlPBxoxYAtNemjmIgyml3ItjUy3TSB/N725njhKFDiOBwkzGUSaQoz9gQxY8YQOsSZWa3lfbpv7qfWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SPM+tLf0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SPM+tLf0"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7F2E6604F0;
	Tue, 26 May 2026 18:40:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779813658;
	bh=H+oyL/MBP03HtRYgAbhJTv/RQJXh8MoSdvgY637F7ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPM+tLf0k3VsPYf4S3osbZDOEN/SJ4IliMSk9e/pABr7g/K+szTKZ75MnhNnJLMtE
	 M126V/WjiYebGFZe6iIjV6KUGpxGeML6SAjWq5Vi5LNv4pFTPdMgaj1CSag/nnKZFZ
	 FTVdDh02+WrE4Kq+2l4vvIKfI6ivGsLMpLews3e8Qp5//G/TyXevDZiq+pdEaqnaF1
	 W6wlagn3ffqQVHoY7YV8ZTfCFCazX3oCw8lOGH45htdka4HuEXZYDp5VzhJHcbveTF
	 61KJBw+ZAaYZnftFjOEvGwjcEc+BZVT2fEzcI4e1QKNm8cFo276l3nAfN09zDPRRC9
	 nqyi6LPUxYLpQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 5/6] netfilter: nf_conntrack_helper: add refcounting from datapath
Date: Tue, 26 May 2026 18:40:48 +0200
Message-ID: <20260526164049.148218-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260526164049.148218-1-pablo@netfilter.org>
References: <20260526164049.148218-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is already a refcount for control plane, to ensure the helper
does not go away if it is used by rulesets.

This patch adds a new ->ct_refcnt field to struct nf_conntrack_helper
which is bumped when the helper is used by the ct helper extension. Drop
this reference count when the conntrack entry is released. This is a
packet path refcount which ensures that struct nf_conntrack_helper
remains in place for tricky scenarios where a packet sits in nfqueue, or
elsewhere, with a conntrack that refers to this helper.

On helper removal, the help callback is set to NULL to disable it from
packet path and, after rcu grace period, existing expectations are
removed. Update ctnetlink to disable access to .to_nlattr and
.from_nlattr if the helper is going away.

Remove nf_queue_nf_hook_drop() since it has proven not to be effective
because packets with unconfirmed conntracks which are still flying to
sit in nfqueue.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h | 25 +++++++++++++++---
 net/netfilter/nf_conntrack_core.c           |  3 ++-
 net/netfilter/nf_conntrack_helper.c         | 28 ++++++---------------
 net/netfilter/nf_conntrack_netlink.c        | 12 ++++++---
 net/netfilter/nf_conntrack_ovs.c            | 14 ++++++++++-
 net/netfilter/nf_conntrack_proto.c          | 15 +++++++----
 net/netfilter/nft_ct.c                      |  2 +-
 net/netfilter/xt_CT.c                       |  7 +++---
 8 files changed, 66 insertions(+), 40 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 1956bc12bf56..a03cb4e59ea9 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -35,20 +35,23 @@ enum nf_ct_helper_flags {
 struct nf_conntrack_helper {
 	struct hlist_node hnode;	/* Internal use. */
 
+	struct rcu_head rcu;
+
 	char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
 	refcount_t refcnt;
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
 
@@ -138,6 +141,20 @@ static inline void *nfct_help_data(const struct nf_conn *ct)
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
index 63159c070c3a..493748f792de 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1739,6 +1739,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 			nat_hook->remove_nat_bysrc(ct);
 	}
 
+	nf_ct_help_put(ct);
 	nf_ct_timeout_put(ct);
 	rcu_read_unlock();
 
@@ -1822,7 +1823,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			assign_helper = rcu_dereference(exp->assign_helper);
 			if (assign_helper) {
 				help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
-				if (help)
+				if (help && refcount_inc_not_zero(&assign_helper->ct_refcnt))
 					rcu_assign_pointer(help->helper, assign_helper);
 			}
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b5b76e3a6ba0..0fe15d749d91 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -237,20 +237,6 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
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
@@ -388,6 +374,7 @@ int __nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 		}
 	}
 	refcount_set(&me->refcnt, 1);
+	refcount_set(&me->ct_refcnt, 1);
 	hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
 	nf_ct_helper_count++;
 out:
@@ -445,19 +432,18 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
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
 
@@ -479,7 +465,7 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 	helper->tuple.dst.protonum = protonum;
 	helper->tuple.src.u.all = htons(spec_port);
 
-	helper->help = help;
+	rcu_assign_pointer(helper->help, help);
 	helper->from_nlattr = from_nlattr;
 	helper->me = module;
 	snprintf(helper->nat_mod_name, sizeof(helper->nat_mod_name),
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index befa7e83ee49..4ba6ded8a29f 100644
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
@@ -1974,7 +1975,8 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 	if (help) {
 		if (rcu_access_pointer(help->helper) == helper) {
 			/* update private helper data if allowed. */
-			if (helper->from_nlattr)
+			if (rcu_access_pointer(helper->help) &&
+			    helper->from_nlattr)
 				helper->from_nlattr(helpinfo, ct);
 			err = 0;
 		} else
@@ -2289,12 +2291,14 @@ ctnetlink_create_conntrack(struct net *net,
 				goto err2;
 			}
 			/* set private helper data if allowed. */
-			if (helper->from_nlattr)
+			if (rcu_access_pointer(helper->help) &&
+			    helper->from_nlattr)
 				helper->from_nlattr(helpinfo, ct);
 
 			/* disable helper auto-assignment for this entry */
 			ct->status |= IPS_HELPER;
-			RCU_INIT_POINTER(help->helper, helper);
+			if (refcount_inc_not_zero(&helper->ct_refcnt))
+				RCU_INIT_POINTER(help->helper, helper);
 		}
 	}
 
diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index a6988eeb1579..ddb2ac6fd982 100644
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
 
@@ -100,6 +107,11 @@ int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
 		}
 	}
 #endif
+	if (!refcount_inc_not_zero(&helper->ct_refcnt)) {
+		nf_conntrack_helper_put(helper);
+		return -ENOENT;
+	}
+
 	rcu_assign_pointer(help->helper, helper);
 	*hp = helper;
 	return ret;
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
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 85e3d68dfb59..61f63d3a445b 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1148,7 +1148,7 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
 		return;
 
 	help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
-	if (help) {
+	if (help && refcount_inc_not_zero(&to_assign->ct_refcnt)) {
 		rcu_assign_pointer(help->helper, to_assign);
 		set_bit(IPS_HELPER_BIT, &ct->status);
 
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index b94f004d5f5c..3b9f4e182468 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -97,6 +97,10 @@ xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
 		return -ENOMEM;
 	}
 
+	if (!refcount_inc_not_zero(&helper->ct_refcnt)) {
+		nf_conntrack_helper_put(helper);
+		return -ENOENT;
+	}
 	rcu_assign_pointer(help->helper, helper);
 	return 0;
 }
@@ -284,9 +288,6 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 	struct nf_conn_help *help;
 
 	if (ct) {
-		if (info->helper[0])
-			nf_queue_nf_hook_drop(par->net);
-
 		help = nfct_help(ct);
 		xt_ct_put_helper(help);
 
-- 
2.47.3

