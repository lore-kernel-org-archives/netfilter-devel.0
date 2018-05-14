From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 01/14] net: sched: use rcu for action cookie update
Date: Mon, 14 May 2018 17:27:02 +0300
Message-ID: <1526308035-12484-2-git-send-email-vladbu@mellanox.com>
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

Implement functions to atomically update and free action cookie
using rcu mechanism.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 include/net/act_api.h |  2 +-
 include/net/pkt_cls.h |  1 +
 net/sched/act_api.c   | 44 ++++++++++++++++++++++++++++++--------------
 3 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 9e59ebf..f7b59ef 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -37,7 +37,7 @@ struct tc_action {
 	spinlock_t			tcfa_lock;
 	struct gnet_stats_basic_cpu __percpu *cpu_bstats;
 	struct gnet_stats_queue __percpu *cpu_qstats;
-	struct tc_cookie	*act_cookie;
+	struct tc_cookie	__rcu *act_cookie;
 	struct tcf_chain	*goto_chain;
 };
 #define tcf_index	common.tcfa_index
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index e828d31..3068cc8 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -769,6 +769,7 @@ struct tc_mqprio_qopt_offload {
 struct tc_cookie {
 	u8  *data;
 	u32 len;
+	struct rcu_head rcu;
 };
 
 struct tc_qopt_offload_stats {
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 72251241..ce829a3 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -55,6 +55,24 @@ static void tcf_action_goto_chain_exec(const struct tc_action *a,
 	res->goto_tp = rcu_dereference_bh(chain->filter_chain);
 }
 
+static void tcf_free_cookie_rcu(struct rcu_head *p)
+{
+	struct tc_cookie *cookie = container_of(p, struct tc_cookie, rcu);
+
+	kfree(cookie->data);
+	kfree(cookie);
+}
+
+static void tcf_set_action_cookie(struct tc_cookie __rcu **old_cookie,
+				  struct tc_cookie *new_cookie)
+{
+	struct tc_cookie *old;
+
+	old = xchg(old_cookie, new_cookie);
+	if (old)
+		call_rcu(&old->rcu, tcf_free_cookie_rcu);
+}
+
 /* XXX: For standalone actions, we don't need a RCU grace period either, because
  * actions are always connected to filters and filters are already destroyed in
  * RCU callbacks, so after a RCU grace period actions are already disconnected
@@ -65,10 +83,7 @@ static void free_tcf(struct tc_action *p)
 	free_percpu(p->cpu_bstats);
 	free_percpu(p->cpu_qstats);
 
-	if (p->act_cookie) {
-		kfree(p->act_cookie->data);
-		kfree(p->act_cookie);
-	}
+	tcf_set_action_cookie(&p->act_cookie, NULL);
 	if (p->goto_chain)
 		tcf_action_goto_chain_fini(p);
 
@@ -567,16 +582,22 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	int err = -EINVAL;
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
+	struct tc_cookie *cookie;
 
 	if (nla_put_string(skb, TCA_KIND, a->ops->kind))
 		goto nla_put_failure;
 	if (tcf_action_copy_stats(skb, a, 0))
 		goto nla_put_failure;
-	if (a->act_cookie) {
-		if (nla_put(skb, TCA_ACT_COOKIE, a->act_cookie->len,
-			    a->act_cookie->data))
+
+	rcu_read_lock();
+	cookie = rcu_dereference(a->act_cookie);
+	if (cookie) {
+		if (nla_put(skb, TCA_ACT_COOKIE, cookie->len, cookie->data)) {
+			rcu_read_unlock();
 			goto nla_put_failure;
+		}
 	}
+	rcu_read_unlock();
 
 	nest = nla_nest_start(skb, TCA_OPTIONS);
 	if (nest == NULL)
@@ -719,13 +740,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (err < 0)
 		goto err_mod;
 
-	if (name == NULL && tb[TCA_ACT_COOKIE]) {
-		if (a->act_cookie) {
-			kfree(a->act_cookie->data);
-			kfree(a->act_cookie);
-		}
-		a->act_cookie = cookie;
-	}
+	if (!name && tb[TCA_ACT_COOKIE])
+		tcf_set_action_cookie(&a->act_cookie, cookie);
 
 	/* module count goes up only when brand new policy is created
 	 * if it exists and is only bound to in a_o->init() then
-- 
2.7.5
