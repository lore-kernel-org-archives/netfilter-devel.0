From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 10/14] net: sched: extend act API for lockless actions
Date: Wed, 16 May 2018 09:50:00 +0200
Message-ID: <20180516075000.GC1972@nanopsycho>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-11-git-send-email-vladbu@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Vlad Buslov <vladbu@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526308035-12484-11-git-send-email-vladbu@mellanox.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mon, May 14, 2018 at 04:27:11PM CEST, vladbu@mellanox.com wrote:
>Implement new action API function to atomically delete action with
>specified index and to atomically insert unique action. These functions are
>required to implement init and delete functions for specific actions that
>do not rely on rtnl lock.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>---
> include/net/act_api.h |  2 ++
> net/sched/act_api.c   | 45 +++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 47 insertions(+)
>
>diff --git a/include/net/act_api.h b/include/net/act_api.h
>index a8c8570..bce0cf1 100644
>--- a/include/net/act_api.h
>+++ b/include/net/act_api.h
>@@ -153,7 +153,9 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
> 		   struct tc_action **a, const struct tc_action_ops *ops,
> 		   int bind, bool cpustats);
> void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a);
>+void tcf_idr_insert_unique(struct tc_action_net *tn, struct tc_action *a);
> 
>+int tcf_idr_find_delete(struct tc_action_net *tn, u32 index);
> int __tcf_idr_release(struct tc_action *a, bool bind, bool strict);
> 
> static inline int tcf_idr_release(struct tc_action *a, bool bind)
>diff --git a/net/sched/act_api.c b/net/sched/act_api.c
>index 2772276e..a5193dc 100644
>--- a/net/sched/act_api.c
>+++ b/net/sched/act_api.c
>@@ -330,6 +330,41 @@ bool tcf_idr_check(struct tc_action_net *tn, u32 index, struct tc_action **a,
> }
> EXPORT_SYMBOL(tcf_idr_check);
> 
>+int tcf_idr_find_delete(struct tc_action_net *tn, u32 index)
>+{
>+	struct tcf_idrinfo *idrinfo = tn->idrinfo;
>+	struct tc_action *p;
>+	int ret = 0;
>+
>+	spin_lock_bh(&idrinfo->lock);

Why "_bh" is needed here?


>+	p = idr_find(&idrinfo->action_idr, index);
>+	if (!p) {
>+		spin_unlock(&idrinfo->lock);
>+		return -ENOENT;
>+	}
>+
>+	if (!atomic_read(&p->tcfa_bindcnt)) {
>+		if (refcount_dec_and_test(&p->tcfa_refcnt)) {
>+			struct module *owner = p->ops->owner;
>+
>+			WARN_ON(p != idr_remove(&idrinfo->action_idr,
>+						p->tcfa_index));
>+			spin_unlock_bh(&idrinfo->lock);
>+
>+			tcf_action_cleanup(p);
>+			module_put(owner);
>+			return 0;
>+		}
>+		ret = 0;
>+	} else {
>+		ret = -EPERM;

I wonder if "-EPERM" is the best error code for this...


>+	}
>+
>+	spin_unlock_bh(&idrinfo->lock);
>+	return ret;
>+}
>+EXPORT_SYMBOL(tcf_idr_find_delete);
>+
> int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
> 		   struct tc_action **a, const struct tc_action_ops *ops,
> 		   int bind, bool cpustats)
>@@ -407,6 +442,16 @@ void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a)
> }
> EXPORT_SYMBOL(tcf_idr_insert);
> 
>+void tcf_idr_insert_unique(struct tc_action_net *tn, struct tc_action *a)
>+{
>+	struct tcf_idrinfo *idrinfo = tn->idrinfo;
>+
>+	spin_lock_bh(&idrinfo->lock);
>+	WARN_ON(idr_replace(&idrinfo->action_idr, a, a->tcfa_index));

Under which condition this WARN_ON is hit?


>+	spin_unlock_bh(&idrinfo->lock);
>+}
>+EXPORT_SYMBOL(tcf_idr_insert_unique);
>+
> void tcf_idrinfo_destroy(const struct tc_action_ops *ops,
> 			 struct tcf_idrinfo *idrinfo)
> {
>-- 
>2.7.5
>
