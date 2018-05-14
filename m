From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 06/14] net: sched: implement reference counted action release
Date: Mon, 14 May 2018 17:27:07 +0300
Message-ID: <1526308035-12484-7-git-send-email-vladbu@mellanox.com>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Cc: davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, vladbu@mellanox.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Implement helper function to delete action using new action ops delete
function implemented by each action for lockless execution.

Implement action put function that releases reference to action and frees
it if necessary. Refactor action deletion code to use new put function and
not to rely on rtnl lock. Remove rtnl lock assertions that are no longer
needed.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/act_api.c | 98 ++++++++++++++++++++++++++++++++++++++++++++---------
 net/sched/cls_api.c |  1 -
 2 files changed, 82 insertions(+), 17 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 9459cce..d324a4c 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -90,21 +90,39 @@ static void free_tcf(struct tc_action *p)
 	kfree(p);
 }
 
-static void tcf_idr_remove(struct tcf_idrinfo *idrinfo, struct tc_action *p)
+static void tcf_action_cleanup(struct tc_action *p)
 {
-	spin_lock_bh(&idrinfo->lock);
-	idr_remove(&idrinfo->action_idr, p->tcfa_index);
-	spin_unlock_bh(&idrinfo->lock);
+	if (p->ops->cleanup)
+		p->ops->cleanup(p);
+
 	gen_kill_estimator(&p->tcfa_rate_est);
 	free_tcf(p);
 }
 
+static int __tcf_action_put(struct tc_action *p, bool bind)
+{
+	struct tcf_idrinfo *idrinfo = p->idrinfo;
+
+	if (refcount_dec_and_lock(&p->tcfa_refcnt, &idrinfo->lock)) {
+		if (bind)
+			atomic_dec(&p->tcfa_bindcnt);
+		idr_remove(&idrinfo->action_idr, p->tcfa_index);
+		spin_unlock(&idrinfo->lock);
+
+		tcf_action_cleanup(p);
+		return 1;
+	}
+
+	if (bind)
+		atomic_dec(&p->tcfa_bindcnt);
+
+	return 0;
+}
+
 int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
 {
 	int ret = 0;
 
-	ASSERT_RTNL();
-
 	/* Release with strict==1 and bind==0 is only called through act API
 	 * interface (classifiers always bind). Only case when action with
 	 * positive reference count and zero bind count can exist is when it was
@@ -118,18 +136,11 @@ int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
 	 * are acceptable.
 	 */
 	if (p) {
-		if (bind)
-			atomic_dec(&p->tcfa_bindcnt);
-		else if (strict && atomic_read(&p->tcfa_bindcnt) > 0)
+		if (!bind && strict && atomic_read(&p->tcfa_bindcnt) > 0)
 			return -EPERM;
 
-		if (atomic_read(&p->tcfa_bindcnt) <= 0 &&
-		    refcount_dec_and_test(&p->tcfa_refcnt)) {
-			if (p->ops->cleanup)
-				p->ops->cleanup(p);
-			tcf_idr_remove(p->idrinfo, p);
+		if (__tcf_action_put(p, bind))
 			ret = ACT_P_DELETED;
-		}
 	}
 
 	return ret;
@@ -576,6 +587,11 @@ int tcf_action_destroy(struct list_head *actions, int bind)
 	return ret;
 }
 
+static int tcf_action_put(struct tc_action *p)
+{
+	return __tcf_action_put(p, false);
+}
+
 int
 tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 {
@@ -975,6 +991,26 @@ static struct tc_action *tcf_action_get_1(struct net *net, struct nlattr *nla,
 	return ERR_PTR(err);
 }
 
+static int tcf_action_del_1(struct net *net, char *kind, u32 index,
+			    struct netlink_ext_ack *extack)
+{
+	const struct tc_action_ops *ops;
+	int err = -EINVAL;
+
+	ops = tc_lookup_action_n(kind);
+	if (!ops) {
+		NL_SET_ERR_MSG(extack, "Specified TC action not found");
+		goto err_out;
+	}
+
+	if (ops->delete)
+		err = ops->delete(net, index);
+
+	module_put(ops->owner);
+err_out:
+	return err;
+}
+
 static int tca_action_flush(struct net *net, struct nlattr *nla,
 			    struct nlmsghdr *n, u32 portid,
 			    struct netlink_ext_ack *extack)
@@ -1052,6 +1088,36 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 	return err;
 }
 
+static int tcf_action_delete(struct net *net, struct list_head *actions,
+			     struct netlink_ext_ack *extack)
+{
+	int ret;
+	struct tc_action *a, *tmp;
+	char kind[IFNAMSIZ];
+	u32 act_index;
+
+	list_for_each_entry_safe(a, tmp, actions, list) {
+		const struct tc_action_ops *ops = a->ops;
+
+		/* Actions can be deleted concurrently
+		 * so we must save their type and id to search again
+		 * after reference is released.
+		 */
+		strncpy(kind, a->ops->kind, sizeof(kind) - 1);
+		act_index = a->tcfa_index;
+
+		list_del(&a->list);
+		if (tcf_action_put(a))
+			module_put(ops->owner);
+
+		/* now do the delete */
+		ret = tcf_action_del_1(net, kind, act_index, extack);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
 static int
 tcf_del_notify(struct net *net, struct nlmsghdr *n, struct list_head *actions,
 	       u32 portid, size_t attr_size, struct netlink_ext_ack *extack)
@@ -1072,7 +1138,7 @@ tcf_del_notify(struct net *net, struct nlmsghdr *n, struct list_head *actions,
 	}
 
 	/* now do the delete */
-	ret = tcf_action_destroy(actions, 0);
+	ret = tcf_action_delete(net, actions, extack);
 	if (ret < 0) {
 		NL_SET_ERR_MSG(extack, "Failed to delete TC action");
 		kfree_skb(skb);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index bcba94b..00b88e5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1417,7 +1417,6 @@ void tcf_exts_destroy(struct tcf_exts *exts)
 #ifdef CONFIG_NET_CLS_ACT
 	LIST_HEAD(actions);
 
-	ASSERT_RTNL();
 	tcf_exts_to_list(exts, &actions);
 	tcf_action_destroy(&actions, TCA_ACT_UNBIND);
 	kfree(exts->actions);
-- 
2.7.5
