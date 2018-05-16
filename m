From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 10/14] net: sched: extend act API for lockless actions
Date: Wed, 16 May 2018 12:39:52 +0300
Message-ID: <vbfa7t00wif.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <1526308035-12484-11-git-send-email-vladbu@mellanox.com> <20180516075000.GC1972@nanopsycho> <vbfbmdg10du.fsf@reg-r-vrt-018-180.mtr.labs.mlnx> <20180516085628.GE1972@nanopsycho>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Jiri Pirko <jiri@resnulli.us>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20180516085628.GE1972@nanopsycho>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Wed 16 May 2018 at 08:56, Jiri Pirko <jiri@resnulli.us> wrote:
> Wed, May 16, 2018 at 10:16:13AM CEST, vladbu@mellanox.com wrote:
>>
>>On Wed 16 May 2018 at 07:50, Jiri Pirko <jiri@resnulli.us> wrote:
>>> Mon, May 14, 2018 at 04:27:11PM CEST, vladbu@mellanox.com wrote:
>>>>Implement new action API function to atomically delete action with
>>>>specified index and to atomically insert unique action. These functions are
>>>>required to implement init and delete functions for specific actions that
>>>>do not rely on rtnl lock.
>>>>
>>>>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>>>>---
>>>> include/net/act_api.h |  2 ++
>>>> net/sched/act_api.c   | 45 +++++++++++++++++++++++++++++++++++++++++++++
>>>> 2 files changed, 47 insertions(+)
>>>>
>>>>diff --git a/include/net/act_api.h b/include/net/act_api.h
>>>>index a8c8570..bce0cf1 100644
>>>>--- a/include/net/act_api.h
>>>>+++ b/include/net/act_api.h
>>>>@@ -153,7 +153,9 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
>>>> 		   struct tc_action **a, const struct tc_action_ops *ops,
>>>> 		   int bind, bool cpustats);
>>>> void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a);
>>>>+void tcf_idr_insert_unique(struct tc_action_net *tn, struct tc_action *a);
>>>> 
>>>>+int tcf_idr_find_delete(struct tc_action_net *tn, u32 index);
>>>> int __tcf_idr_release(struct tc_action *a, bool bind, bool strict);
>>>> 
>>>> static inline int tcf_idr_release(struct tc_action *a, bool bind)
>>>>diff --git a/net/sched/act_api.c b/net/sched/act_api.c
>>>>index 2772276e..a5193dc 100644
>>>>--- a/net/sched/act_api.c
>>>>+++ b/net/sched/act_api.c
>>>>@@ -330,6 +330,41 @@ bool tcf_idr_check(struct tc_action_net *tn, u32 index, struct tc_action **a,
>>>> }
>>>> EXPORT_SYMBOL(tcf_idr_check);
>>>> 
>>>>+int tcf_idr_find_delete(struct tc_action_net *tn, u32 index)
>>>>+{
>>>>+	struct tcf_idrinfo *idrinfo = tn->idrinfo;
>>>>+	struct tc_action *p;
>>>>+	int ret = 0;
>>>>+
>>>>+	spin_lock_bh(&idrinfo->lock);
>>>
>>> Why "_bh" is needed here?
>>
>>Original idr remove function used _bh version so I used it here as well.
>>As I already replied to your previous question about idrinfo lock usage,
>>I don't see any particular reason for locking with _bh at this point.
>>I've contacted the author(Chris Mi) and he said that he just preserved
>>locking the same way as it was before he changed hash table to idr for
>>action lookup.
>>
>>You want me to do standalone patch that cleans up idrinfo locking?
>
> Yes please. You can send it separately, not as a part of this
> patchset.

Okay.

>
>
>
>>
>>>
>>>
>>>>+	p = idr_find(&idrinfo->action_idr, index);
>>>>+	if (!p) {
>>>>+		spin_unlock(&idrinfo->lock);
>>>>+		return -ENOENT;
>>>>+	}
>>>>+
>>>>+	if (!atomic_read(&p->tcfa_bindcnt)) {
>>>>+		if (refcount_dec_and_test(&p->tcfa_refcnt)) {
>>>>+			struct module *owner = p->ops->owner;
>>>>+
>>>>+			WARN_ON(p != idr_remove(&idrinfo->action_idr,
>>>>+						p->tcfa_index));
>>>>+			spin_unlock_bh(&idrinfo->lock);
>>>>+
>>>>+			tcf_action_cleanup(p);
>>>>+			module_put(owner);
>>>>+			return 0;
>>>>+		}
>>>>+		ret = 0;
>>>>+	} else {
>>>>+		ret = -EPERM;
>>>
>>> I wonder if "-EPERM" is the best error code for this...
>>
>>This is what original code returned so I decided to preserve
>>compatibility.
>
> Okay.
>
>
>>
>>>
>>>
>>>>+	}
>>>>+
>>>>+	spin_unlock_bh(&idrinfo->lock);
>>>>+	return ret;
>>>>+}
>>>>+EXPORT_SYMBOL(tcf_idr_find_delete);
>>>>+
>>>> int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
>>>> 		   struct tc_action **a, const struct tc_action_ops *ops,
>>>> 		   int bind, bool cpustats)
>>>>@@ -407,6 +442,16 @@ void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a)
>>>> }
>>>> EXPORT_SYMBOL(tcf_idr_insert);
>>>> 
>>>>+void tcf_idr_insert_unique(struct tc_action_net *tn, struct tc_action *a)
>>>>+{
>>>>+	struct tcf_idrinfo *idrinfo = tn->idrinfo;
>>>>+
>>>>+	spin_lock_bh(&idrinfo->lock);
>>>>+	WARN_ON(idr_replace(&idrinfo->action_idr, a, a->tcfa_index));
>>>
>>> Under which condition this WARN_ON is hit?
>>
>>When idr replace returns non-NULL pointer, which means that somehow
>>concurrent insertion of action with same index has happened and we are
>>leaking memory.
>
> Is that possible to happen? Meaning, can I as a user cause this by doing
> something in a wrong/unexpected way?

No, it shouldn't be possible unless there is a race condition.
Otherwise I would put some proper error handling code there.

>
>
>>
>>By the way I'm still not sure if having this insert unique function is
>>warranted or I should just add WARN to regular idr insert. What is your
>>opinion on this?
>
> I have to check where you use this.

Every action init function uses this.

>
>
>>
>>>
>>>
>>>>+	spin_unlock_bh(&idrinfo->lock);
>>>>+}
>>>>+EXPORT_SYMBOL(tcf_idr_insert_unique);
>>>>+
>>>> void tcf_idrinfo_destroy(const struct tc_action_ops *ops,
>>>> 			 struct tcf_idrinfo *idrinfo)
>>>> {
>>>>-- 
>>>>2.7.5
>>>>
>>
