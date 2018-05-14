From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 05/14] net: sched: always take reference to action
Date: Mon, 14 May 2018 21:49:07 +0300
Message-ID: <vbftvradqe4.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <1526308035-12484-6-git-send-email-vladbu@mellanox.com> <20180514162301.GC2134@nanopsycho.orion>
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
In-reply-to: <20180514162301.GC2134@nanopsycho.orion>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Mon 14 May 2018 at 16:23, Jiri Pirko <jiri@resnulli.us> wrote:
> Mon, May 14, 2018 at 04:27:06PM CEST, vladbu@mellanox.com wrote:
>>Without rtnl lock protection it is no longer safe to use pointer to tc
>>action without holding reference to it. (it can be destroyed concurrently)
>>
>>Remove unsafe action idr lookup function. Instead of it, implement safe tcf
>>idr check function that atomically looks up action in idr and increments
>>its reference and bind counters.
>>
>>Implement both action search and check using new safe function.
>>
>>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>>---
>> net/sched/act_api.c | 38 ++++++++++++++++----------------------
>> 1 file changed, 16 insertions(+), 22 deletions(-)
>>
>>diff --git a/net/sched/act_api.c b/net/sched/act_api.c
>>index 1331beb..9459cce 100644
>>--- a/net/sched/act_api.c
>>+++ b/net/sched/act_api.c
>>@@ -284,44 +284,38 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
>> }
>> EXPORT_SYMBOL(tcf_generic_walker);
>> 
>>-static struct tc_action *tcf_idr_lookup(u32 index, struct tcf_idrinfo *idrinfo)
>>+bool __tcf_idr_check(struct tc_action_net *tn, u32 index, struct tc_action **a,
>>+		     int bind)
>> {
>>-	struct tc_action *p = NULL;
>>+	struct tcf_idrinfo *idrinfo = tn->idrinfo;
>>+	struct tc_action *p;
>> 
>> 	spin_lock_bh(&idrinfo->lock);
>
> Why "_bh" variant is necessary here?

It is not my code.

>
>> 	p = idr_find(&idrinfo->action_idr, index);
>>+	if (p) {
>>+		refcount_inc(&p->tcfa_refcnt);
>>+		if (bind)
>>+			atomic_inc(&p->tcfa_bindcnt);
>>+	}
>> 	spin_unlock_bh(&idrinfo->lock);
>
> [...]
