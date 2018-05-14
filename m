From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 02/14] net: sched: change type of reference and bind counters
Date: Mon, 14 May 2018 17:27:03 +0300
Message-ID: <1526308035-12484-3-git-send-email-vladbu@mellanox.com>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Cc: davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, vladbu@mellanox.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Change type of action reference counter to refcount_t.

Change type of action bind counter to atomic_t.
This type is used to allow decrementing bind counter without testing
for 0 result.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 include/net/act_api.h      |  5 +++--
 net/sched/act_api.c        | 32 ++++++++++++++++++++++----------
 net/sched/act_bpf.c        |  4 ++--
 net/sched/act_connmark.c   |  4 ++--
 net/sched/act_csum.c       |  4 ++--
 net/sched/act_gact.c       |  4 ++--
 net/sched/act_ife.c        |  4 ++--
 net/sched/act_ipt.c        |  4 ++--
 net/sched/act_mirred.c     |  4 ++--
 net/sched/act_nat.c        |  4 ++--
 net/sched/act_pedit.c      |  4 ++--
 net/sched/act_police.c     |  4 ++--
 net/sched/act_sample.c     |  4 ++--
 net/sched/act_simple.c     |  4 ++--
 net/sched/act_skbedit.c    |  4 ++--
 net/sched/act_skbmod.c     |  4 ++--
 net/sched/act_tunnel_key.c |  4 ++--
 net/sched/act_vlan.c       |  4 ++--
 18 files changed, 57 insertions(+), 44 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index f7b59ef..e634014 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -6,6 +6,7 @@
  * Public action API for classifiers/qdiscs
 */
 
+#include <linux/refcount.h>
 #include <net/sch_generic.h>
 #include <net/pkt_sched.h>
 #include <net/net_namespace.h>
@@ -26,8 +27,8 @@ struct tc_action {
 	struct tcf_idrinfo		*idrinfo;
 
 	u32				tcfa_index;
-	int				tcfa_refcnt;
-	int				tcfa_bindcnt;
+	refcount_t			tcfa_refcnt;
+	atomic_t			tcfa_bindcnt;
 	u32				tcfa_capab;
 	int				tcfa_action;
 	struct tcf_t			tcfa_tm;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index ce829a3..96b0878 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -105,14 +105,26 @@ int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
 
 	ASSERT_RTNL();
 
+	/* Release with strict==1 and bind==0 is only called through act API
+	 * interface (classifiers always bind). Only case when action with
+	 * positive reference count and zero bind count can exist is when it was
+	 * also created with act API (unbinding last classifier will destroy the
+	 * action if it was created by classifier). So only case when bind count
+	 * can be changed after initial check is when unbound action is
+	 * destroyed by act API while classifier binds to action with same id
+	 * concurrently. This result either creation of new action(same behavior
+	 * as before), or reusing existing action if concurrent process
+	 * increments reference count before action is deleted. Both scenarios
+	 * are acceptable.
+	 */
 	if (p) {
 		if (bind)
-			p->tcfa_bindcnt--;
-		else if (strict && p->tcfa_bindcnt > 0)
+			atomic_dec(&p->tcfa_bindcnt);
+		else if (strict && atomic_read(&p->tcfa_bindcnt) > 0)
 			return -EPERM;
 
-		p->tcfa_refcnt--;
-		if (p->tcfa_bindcnt <= 0 && p->tcfa_refcnt <= 0) {
+		if (atomic_read(&p->tcfa_bindcnt) <= 0 &&
+		    refcount_dec_and_test(&p->tcfa_refcnt)) {
 			if (p->ops->cleanup)
 				p->ops->cleanup(p);
 			tcf_idr_remove(p->idrinfo, p);
@@ -304,8 +316,8 @@ bool tcf_idr_check(struct tc_action_net *tn, u32 index, struct tc_action **a,
 
 	if (index && p) {
 		if (bind)
-			p->tcfa_bindcnt++;
-		p->tcfa_refcnt++;
+			atomic_inc(&p->tcfa_bindcnt);
+		refcount_inc(&p->tcfa_refcnt);
 		*a = p;
 		return true;
 	}
@@ -324,9 +336,9 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 
 	if (unlikely(!p))
 		return -ENOMEM;
-	p->tcfa_refcnt = 1;
+	refcount_set(&p->tcfa_refcnt, 1);
 	if (bind)
-		p->tcfa_bindcnt = 1;
+		atomic_set(&p->tcfa_bindcnt, 1);
 
 	if (cpustats) {
 		p->cpu_bstats = netdev_alloc_pcpu_stats(struct gnet_stats_basic_cpu);
@@ -782,7 +794,7 @@ static void cleanup_a(struct list_head *actions, int ovr)
 		return;
 
 	list_for_each_entry(a, actions, list)
-		a->tcfa_refcnt--;
+		refcount_dec(&a->tcfa_refcnt);
 }
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
@@ -810,7 +822,7 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		act->order = i;
 		sz += tcf_action_fill_size(act);
 		if (ovr)
-			act->tcfa_refcnt++;
+			refcount_inc(&act->tcfa_refcnt);
 		list_add_tail(&act->list, actions);
 	}
 
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 18089c0..15a2a53 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -141,8 +141,8 @@ static int tcf_bpf_dump(struct sk_buff *skb, struct tc_action *act,
 	struct tcf_bpf *prog = to_bpf(act);
 	struct tc_act_bpf opt = {
 		.index   = prog->tcf_index,
-		.refcnt  = prog->tcf_refcnt - ref,
-		.bindcnt = prog->tcf_bindcnt - bind,
+		.refcnt  = refcount_read(&prog->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&prog->tcf_bindcnt) - bind,
 		.action  = prog->tcf_action,
 	};
 	struct tcf_t tm;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index e4b880f..1888650 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -154,8 +154,8 @@ static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
 
 	struct tc_connmark opt = {
 		.index   = ci->tcf_index,
-		.refcnt  = ci->tcf_refcnt - ref,
-		.bindcnt = ci->tcf_bindcnt - bind,
+		.refcnt  = refcount_read(&ci->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&ci->tcf_bindcnt) - bind,
 		.action  = ci->tcf_action,
 		.zone   = ci->zone,
 	};
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 7e28b2c..0572682 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -597,8 +597,8 @@ static int tcf_csum_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 	struct tcf_csum_params *params;
 	struct tc_csum opt = {
 		.index   = p->tcf_index,
-		.refcnt  = p->tcf_refcnt - ref,
-		.bindcnt = p->tcf_bindcnt - bind,
+		.refcnt  = refcount_read(&p->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&p->tcf_bindcnt) - bind,
 	};
 	struct tcf_t t;
 
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 4dc4f15..ca83deb 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -169,8 +169,8 @@ static int tcf_gact_dump(struct sk_buff *skb, struct tc_action *a,
 	struct tcf_gact *gact = to_gact(a);
 	struct tc_gact opt = {
 		.index   = gact->tcf_index,
-		.refcnt  = gact->tcf_refcnt - ref,
-		.bindcnt = gact->tcf_bindcnt - bind,
+		.refcnt  = refcount_read(&gact->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&gact->tcf_bindcnt) - bind,
 		.action  = gact->tcf_action,
 	};
 	struct tcf_t t;
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index a5994cf..689f63e 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -598,8 +598,8 @@ static int tcf_ife_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 	struct tcf_ife_params *p = rtnl_dereference(ife->params);
 	struct tc_ife opt = {
 		.index = ife->tcf_index,
-		.refcnt = ife->tcf_refcnt - ref,
-		.bindcnt = ife->tcf_bindcnt - bind,
+		.refcnt = refcount_read(&ife->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&ife->tcf_bindcnt) - bind,
 		.action = ife->tcf_action,
 		.flags = p->flags,
 	};
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 14c312d..7bce88d 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -280,8 +280,8 @@ static int tcf_ipt_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 	if (unlikely(!t))
 		goto nla_put_failure;
 
-	c.bindcnt = ipt->tcf_bindcnt - bind;
-	c.refcnt = ipt->tcf_refcnt - ref;
+	c.bindcnt = atomic_read(&ipt->tcf_bindcnt) - bind;
+	c.refcnt = refcount_read(&ipt->tcf_refcnt) - ref;
 	strcpy(t->u.user.name, ipt->tcfi_t->u.kernel.target->name);
 
 	if (nla_put(skb, TCA_IPT_TARG, ipt->tcfi_t->u.user.target_size, t) ||
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index fd34015..82a8bdd 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -250,8 +250,8 @@ static int tcf_mirred_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 	struct tc_mirred opt = {
 		.index   = m->tcf_index,
 		.action  = m->tcf_action,
-		.refcnt  = m->tcf_refcnt - ref,
-		.bindcnt = m->tcf_bindcnt - bind,
+		.refcnt  = refcount_read(&m->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&m->tcf_bindcnt) - bind,
 		.eaction = m->tcfm_eaction,
 		.ifindex = dev ? dev->ifindex : 0,
 	};
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 4b5848b..457c2ae 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -257,8 +257,8 @@ static int tcf_nat_dump(struct sk_buff *skb, struct tc_action *a,
 
 		.index    = p->tcf_index,
 		.action   = p->tcf_action,
-		.refcnt   = p->tcf_refcnt - ref,
-		.bindcnt  = p->tcf_bindcnt - bind,
+		.refcnt   = refcount_read(&p->tcf_refcnt) - ref,
+		.bindcnt  = atomic_read(&p->tcf_bindcnt) - bind,
 	};
 	struct tcf_t t;
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 8a925c7..0102b29 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -391,8 +391,8 @@ static int tcf_pedit_dump(struct sk_buff *skb, struct tc_action *a,
 	opt->nkeys = p->tcfp_nkeys;
 	opt->flags = p->tcfp_flags;
 	opt->action = p->tcf_action;
-	opt->refcnt = p->tcf_refcnt - ref;
-	opt->bindcnt = p->tcf_bindcnt - bind;
+	opt->refcnt = refcount_read(&p->tcf_refcnt) - ref;
+	opt->bindcnt = atomic_read(&p->tcf_bindcnt) - bind;
 
 	if (p->tcfp_keys_ex) {
 		tcf_pedit_key_ex_dump(skb, p->tcfp_keys_ex, p->tcfp_nkeys);
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 4e72bc2..a789b80 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -274,8 +274,8 @@ static int tcf_act_police_dump(struct sk_buff *skb, struct tc_action *a,
 		.action = police->tcf_action,
 		.mtu = police->tcfp_mtu,
 		.burst = PSCHED_NS2TICKS(police->tcfp_burst),
-		.refcnt = police->tcf_refcnt - ref,
-		.bindcnt = police->tcf_bindcnt - bind,
+		.refcnt = refcount_read(&police->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&police->tcf_bindcnt) - bind,
 	};
 	struct tcf_t t;
 
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 5db3584..4a46978 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -173,8 +173,8 @@ static int tcf_sample_dump(struct sk_buff *skb, struct tc_action *a,
 	struct tc_sample opt = {
 		.index      = s->tcf_index,
 		.action     = s->tcf_action,
-		.refcnt     = s->tcf_refcnt - ref,
-		.bindcnt    = s->tcf_bindcnt - bind,
+		.refcnt     = refcount_read(&s->tcf_refcnt) - ref,
+		.bindcnt    = atomic_read(&s->tcf_bindcnt) - bind,
 	};
 	struct tcf_t t;
 
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 9618b4a8..95d5985 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -148,8 +148,8 @@ static int tcf_simp_dump(struct sk_buff *skb, struct tc_action *a,
 	struct tcf_defact *d = to_defact(a);
 	struct tc_defact opt = {
 		.index   = d->tcf_index,
-		.refcnt  = d->tcf_refcnt - ref,
-		.bindcnt = d->tcf_bindcnt - bind,
+		.refcnt  = refcount_read(&d->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&d->tcf_bindcnt) - bind,
 		.action  = d->tcf_action,
 	};
 	struct tcf_t t;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index ddf69fc..adf0a72 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -172,8 +172,8 @@ static int tcf_skbedit_dump(struct sk_buff *skb, struct tc_action *a,
 	struct tcf_skbedit *d = to_skbedit(a);
 	struct tc_skbedit opt = {
 		.index   = d->tcf_index,
-		.refcnt  = d->tcf_refcnt - ref,
-		.bindcnt = d->tcf_bindcnt - bind,
+		.refcnt  = refcount_read(&d->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&d->tcf_bindcnt) - bind,
 		.action  = d->tcf_action,
 	};
 	struct tcf_t t;
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index bbcbdce..a0d9abb 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -202,8 +202,8 @@ static int tcf_skbmod_dump(struct sk_buff *skb, struct tc_action *a,
 	struct tcf_skbmod_params  *p = rtnl_dereference(d->skbmod_p);
 	struct tc_skbmod opt = {
 		.index   = d->tcf_index,
-		.refcnt  = d->tcf_refcnt - ref,
-		.bindcnt = d->tcf_bindcnt - bind,
+		.refcnt  = refcount_read(&d->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&d->tcf_bindcnt) - bind,
 		.action  = d->tcf_action,
 	};
 	struct tcf_t t;
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 626dac8..c6e5069 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -252,8 +252,8 @@ static int tunnel_key_dump(struct sk_buff *skb, struct tc_action *a,
 	struct tcf_tunnel_key_params *params;
 	struct tc_tunnel_key opt = {
 		.index    = t->tcf_index,
-		.refcnt   = t->tcf_refcnt - ref,
-		.bindcnt  = t->tcf_bindcnt - bind,
+		.refcnt   = refcount_read(&t->tcf_refcnt) - ref,
+		.bindcnt  = atomic_read(&t->tcf_bindcnt) - bind,
 	};
 	struct tcf_t tm;
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 8536046..8dda784 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -237,8 +237,8 @@ static int tcf_vlan_dump(struct sk_buff *skb, struct tc_action *a,
 	struct tcf_vlan_params *p = rtnl_dereference(v->vlan_p);
 	struct tc_vlan opt = {
 		.index    = v->tcf_index,
-		.refcnt   = v->tcf_refcnt - ref,
-		.bindcnt  = v->tcf_bindcnt - bind,
+		.refcnt   = refcount_read(&v->tcf_refcnt) - ref,
+		.bindcnt  = atomic_read(&v->tcf_bindcnt) - bind,
 		.action   = v->tcf_action,
 		.v_action = p->tcfv_action,
 	};
-- 
2.7.5
