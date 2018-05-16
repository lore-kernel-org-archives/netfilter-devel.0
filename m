From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 12/14] net: sched: retry action check-insert on concurrent modification
Date: Wed, 16 May 2018 15:43:58 +0300
Message-ID: <vbfwow322k1.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <1526308035-12484-13-git-send-email-vladbu@mellanox.com> <20180516095953.GI1972@nanopsycho> <vbf4lj724th.fsf@reg-r-vrt-018-180.mtr.labs.mlnx> <20180516122600.GM1972@nanopsycho>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Jiri Pirko <jiri@resnulli.us>
Return-path: <netdev-owner@vger.kernel.org>
In-reply-to: <20180516122600.GM1972@nanopsycho>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Wed 16 May 2018 at 12:26, Jiri Pirko <jiri@resnulli.us> wrote:
> Wed, May 16, 2018 at 01:55:06PM CEST, vladbu@mellanox.com wrote:
>>
>>On Wed 16 May 2018 at 09:59, Jiri Pirko <jiri@resnulli.us> wrote:
>>> Mon, May 14, 2018 at 04:27:13PM CEST, vladbu@mellanox.com wrote:
>>>>Retry check-insert sequence in action init functions if action with same
>>>>index was inserted concurrently.
>>>>
>>>>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>>>>---
>>>> net/sched/act_bpf.c        | 8 +++++++-
>>>> net/sched/act_connmark.c   | 8 +++++++-
>>>> net/sched/act_csum.c       | 8 +++++++-
>>>> net/sched/act_gact.c       | 8 +++++++-
>>>> net/sched/act_ife.c        | 8 +++++++-
>>>> net/sched/act_ipt.c        | 8 +++++++-
>>>> net/sched/act_mirred.c     | 8 +++++++-
>>>> net/sched/act_nat.c        | 8 +++++++-
>>>> net/sched/act_pedit.c      | 8 +++++++-
>>>> net/sched/act_police.c     | 9 ++++++++-
>>>> net/sched/act_sample.c     | 8 +++++++-
>>>> net/sched/act_simple.c     | 9 ++++++++-
>>>> net/sched/act_skbedit.c    | 8 +++++++-
>>>> net/sched/act_skbmod.c     | 8 +++++++-
>>>> net/sched/act_tunnel_key.c | 9 ++++++++-
>>>> net/sched/act_vlan.c       | 9 ++++++++-
>>>> 16 files changed, 116 insertions(+), 16 deletions(-)
>>>>
>>>>diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
>>>>index 5554bf7..7e20fdc 100644
>>>>--- a/net/sched/act_bpf.c
>>>>+++ b/net/sched/act_bpf.c
>>>>@@ -299,10 +299,16 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
>>>> 
>>>> 	parm = nla_data(tb[TCA_ACT_BPF_PARMS]);
>>>> 
>>>>+replay:
>>>> 	if (!tcf_idr_check(tn, parm->index, act, bind)) {
>>>> 		ret = tcf_idr_create(tn, parm->index, est, act,
>>>> 				     &act_bpf_ops, bind, true);
>>>>-		if (ret < 0)
>>>>+		/* Action with specified index was created concurrently.
>>>>+		 * Check again.
>>>>+		 */
>>>>+		if (parm->index && ret == -ENOSPC)
>>>>+			goto replay;
>>>>+		else if (ret)
>>>
>>> Hmm, looks like you are doing the same/very similar thing in every act
>>> code. I think it would make sense to introduce a helper function for
>>> this purpose.
>>
>>This code uses goto so it can't be easily refactored into standalone
>>function. Could you specify which part of this code you suggest to
>>extract?
>
> Hmm, looking at the code, I think that what would help is to have a
> helper that would atomically check if index exists and if not, it would
> allocate one. Something like:
>
>
> int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
> 			struct tc_action **a, int bind)
> {
> 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
> 	struct tc_action *p;
> 	int err;
>
> 	spin_lock(&idrinfo->lock);
> 	if (*index) {
> 		p = idr_find(&idrinfo->action_idr, *index);
> 		if (p) {
> 			if (bind)
> 	   			p->tcfa_bindcnt++;
> 			p->tcfa_refcnt++;
> 			*a = p;
> 			err = 0;
> 		} else {
> 			*a = NULL;
> 			err = idr_alloc_u32(idr, NULL, index,
> 					    *index, GFP_ATOMIC);
> 		}
> 	} else {
> 		*index = 1;
> 		*a = NULL;
> 		err = idr_alloc_u32(idr, NULL, index, UINT_MAX, GFP_ATOMIC);
> 	}
> 	spin_unlock(&idrinfo->lock);
> 	return err;
> }
>
> The act code would just check if "a" is NULL and if so, it would call
> tcf_idr_create() with allocated index as arg.

What about multiple actions that have arbitrary code between initial
check and idr allocation that is currently inside tcf_idr_create()?

>
>
>>
>>>
>>> [...]
>>
