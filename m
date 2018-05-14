From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 05/14] net: sched: always take reference to action
Date: Mon, 14 May 2018 17:27:06 +0300
Message-ID: <1526308035-12484-6-git-send-email-vladbu@mellanox.com>
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

Without rtnl lock protection it is no longer safe to use pointer to tc
action without holding reference to it. (it can be destroyed concurrently)

Remove unsafe action idr lookup function. Instead of it, implement safe tcf
idr check function that atomically looks up action in idr and increments
its reference and bind counters.

Implement both action search and check using new safe function.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/act_api.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 1331beb..9459cce 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -284,44 +284,38 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(tcf_generic_walker);
 
-static struct tc_action *tcf_idr_lookup(u32 index, struct tcf_idrinfo *idrinfo)
+bool __tcf_idr_check(struct tc_action_net *tn, u32 index, struct tc_action **a,
+		     int bind)
 {
-	struct tc_action *p = NULL;
+	struct tcf_idrinfo *idrinfo = tn->idrinfo;
+	struct tc_action *p;
 
 	spin_lock_bh(&idrinfo->lock);
 	p = idr_find(&idrinfo->action_idr, index);
+	if (p) {
+		refcount_inc(&p->tcfa_refcnt);
+		if (bind)
+			atomic_inc(&p->tcfa_bindcnt);
+	}
 	spin_unlock_bh(&idrinfo->lock);
 
-	return p;
+	if (p) {
+		*a = p;
+		return true;
+	}
+	return false;
 }
 
 int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index)
 {
-	struct tcf_idrinfo *idrinfo = tn->idrinfo;
-	struct tc_action *p = tcf_idr_lookup(index, idrinfo);
-
-	if (p) {
-		*a = p;
-		return 1;
-	}
-	return 0;
+	return __tcf_idr_check(tn, index, a, 0);
 }
 EXPORT_SYMBOL(tcf_idr_search);
 
 bool tcf_idr_check(struct tc_action_net *tn, u32 index, struct tc_action **a,
 		   int bind)
 {
-	struct tcf_idrinfo *idrinfo = tn->idrinfo;
-	struct tc_action *p = tcf_idr_lookup(index, idrinfo);
-
-	if (index && p) {
-		if (bind)
-			atomic_inc(&p->tcfa_bindcnt);
-		refcount_inc(&p->tcfa_refcnt);
-		*a = p;
-		return true;
-	}
-	return false;
+	return __tcf_idr_check(tn, index, a, bind);
 }
 EXPORT_SYMBOL(tcf_idr_check);
 
-- 
2.7.5
