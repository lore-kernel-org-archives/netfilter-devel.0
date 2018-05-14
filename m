From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 07/14] net: sched: use reference counting action init
Date: Mon, 14 May 2018 17:27:08 +0300
Message-ID: <1526308035-12484-8-git-send-email-vladbu@mellanox.com>
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

Change action API to assume that action init function always takes
reference to action, even when overwriting existing action. This is
necessary because action API continues to use action pointer after init
function is done. At this point action becomes accessible for concurrent
modifications so user must always hold reference to it.

Implement helper put list function to atomically release list of actions
after action API init code is done using them.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/act_api.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index d324a4c..3f02cd1 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -592,6 +592,18 @@ static int tcf_action_put(struct tc_action *p)
 	return __tcf_action_put(p, false);
 }
 
+static void tcf_action_put_lst(struct list_head *actions)
+{
+	struct tc_action *a, *tmp;
+
+	list_for_each_entry_safe(a, tmp, actions, list) {
+		const struct tc_action_ops *ops = a->ops;
+
+		if (tcf_action_put(a))
+			module_put(ops->owner);
+	}
+}
+
 int
 tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 {
@@ -799,17 +811,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	return ERR_PTR(err);
 }
 
-static void cleanup_a(struct list_head *actions, int ovr)
-{
-	struct tc_action *a;
-
-	if (!ovr)
-		return;
-
-	list_for_each_entry(a, actions, list)
-		refcount_dec(&a->tcfa_refcnt);
-}
-
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
 		    struct list_head *actions, size_t *attr_size, bool unlocked,
@@ -834,17 +835,10 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		}
 		act->order = i;
 		sz += tcf_action_fill_size(act);
-		if (ovr)
-			refcount_inc(&act->tcfa_refcnt);
 		list_add_tail(&act->list, actions);
 	}
 
 	*attr_size = tcf_action_full_attrs_size(sz);
-
-	/* Remove the temp refcnt which was necessary to protect against
-	 * destroying an existing action which was being replaced
-	 */
-	cleanup_a(actions, ovr);
 	return 0;
 
 err:
@@ -1196,8 +1190,7 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 		return ret;
 	}
 err:
-	if (event != RTM_GETACTION)
-		tcf_action_destroy(&actions, 0);
+	tcf_action_put_lst(&actions);
 	return ret;
 }
 
@@ -1239,8 +1232,11 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 			      &attr_size, false, extack);
 	if (ret)
 		return ret;
+	ret = tcf_add_notify(net, n, &actions, portid, attr_size, extack);
+	if (ovr)
+		tcf_action_put_lst(&actions);
 
-	return tcf_add_notify(net, n, &actions, portid, attr_size, extack);
+	return ret;
 }
 
 static u32 tcaa_root_flags_allowed = TCA_FLAG_LARGE_DUMP_ON;
-- 
2.7.5
