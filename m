From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 12/14] net: sched: retry action check-insert on concurrent modification
Date: Wed, 16 May 2018 17:26:40 +0300
Message-ID: <vbfsh6r1xsv.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <1526308035-12484-13-git-send-email-vladbu@mellanox.com> <20180516095953.GI1972@nanopsycho> <vbf4lj724th.fsf@reg-r-vrt-018-180.mtr.labs.mlnx> <20180516122600.GM1972@nanopsycho> <vbfwow322k1.fsf@reg-r-vrt-018-180.mtr.labs.mlnx> <20180516132135.GN1972@nanopsycho> <vbfvabn1zic.fsf@reg-r-vrt-018-180.mtr.labs.mlnx> <20180516141319.GO1972@nanopsycho>
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
In-reply-to: <20180516141319.GO1972@nanopsycho>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Wed 16 May 2018 at 14:13, Jiri Pirko <jiri@resnulli.us> wrote:
> Wed, May 16, 2018 at 03:52:20PM CEST, vladbu@mellanox.com wrote:
>>
>>On Wed 16 May 2018 at 13:21, Jiri Pirko <jiri@resnulli.us> wrote:
>>> Wed, May 16, 2018 at 02:43:58PM CEST, vladbu@mellanox.com wrote:
>>>>
>>>>On Wed 16 May 2018 at 12:26, Jiri Pirko <jiri@resnulli.us> wrote:
>>>>> Wed, May 16, 2018 at 01:55:06PM CEST, vladbu@mellanox.com wrote:
>>>>>>
>>>>>>On Wed 16 May 2018 at 09:59, Jiri Pirko <jiri@resnulli.us> wrote:
>>>>>>> Mon, May 14, 2018 at 04:27:13PM CEST, vladbu@mellanox.com wrote:
>>>>>>>>Retry check-insert sequence in action init functions if action with same
>>>>>>>>index was inserted concurrently.
>>>>>>>>
>>>>>>>>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>>>>>>>>---
>>>>>>>> net/sched/act_bpf.c        | 8 +++++++-
>>>>>>>> net/sched/act_connmark.c   | 8 +++++++-
>>>>>>>> net/sched/act_csum.c       | 8 +++++++-
>>>>>>>> net/sched/act_gact.c       | 8 +++++++-
>>>>>>>> net/sched/act_ife.c        | 8 +++++++-
>>>>>>>> net/sched/act_ipt.c        | 8 +++++++-
>>>>>>>> net/sched/act_mirred.c     | 8 +++++++-
>>>>>>>> net/sched/act_nat.c        | 8 +++++++-
>>>>>>>> net/sched/act_pedit.c      | 8 +++++++-
>>>>>>>> net/sched/act_police.c     | 9 ++++++++-
>>>>>>>> net/sched/act_sample.c     | 8 +++++++-
>>>>>>>> net/sched/act_simple.c     | 9 ++++++++-
>>>>>>>> net/sched/act_skbedit.c    | 8 +++++++-
>>>>>>>> net/sched/act_skbmod.c     | 8 +++++++-
>>>>>>>> net/sched/act_tunnel_key.c | 9 ++++++++-
>>>>>>>> net/sched/act_vlan.c       | 9 ++++++++-
>>>>>>>> 16 files changed, 116 insertions(+), 16 deletions(-)
>>>>>>>>
>>>>>>>>diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
>>>>>>>>index 5554bf7..7e20fdc 100644
>>>>>>>>--- a/net/sched/act_bpf.c
>>>>>>>>+++ b/net/sched/act_bpf.c
>>>>>>>>@@ -299,10 +299,16 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
>>>>>>>> 
>>>>>>>> 	parm = nla_data(tb[TCA_ACT_BPF_PARMS]);
>>>>>>>> 
>>>>>>>>+replay:
>>>>>>>> 	if (!tcf_idr_check(tn, parm->index, act, bind)) {
>>>>>>>> 		ret = tcf_idr_create(tn, parm->index, est, act,
>>>>>>>> 				     &act_bpf_ops, bind, true);
>>>>>>>>-		if (ret < 0)
>>>>>>>>+		/* Action with specified index was created concurrently.
>>>>>>>>+		 * Check again.
>>>>>>>>+		 */
>>>>>>>>+		if (parm->index && ret == -ENOSPC)
>>>>>>>>+			goto replay;
>>>>>>>>+		else if (ret)
>>>>>>>
>>>>>>> Hmm, looks like you are doing the same/very similar thing in every act
>>>>>>> code. I think it would make sense to introduce a helper function for
>>>>>>> this purpose.
>>>>>>
>>>>>>This code uses goto so it can't be easily refactored into standalone
>>>>>>function. Could you specify which part of this code you suggest to
>>>>>>extract?
>>>>>
>>>>> Hmm, looking at the code, I think that what would help is to have a
>>>>> helper that would atomically check if index exists and if not, it would
>>>>> allocate one. Something like:
>>>>>
>>>>>
>>>>> int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
>>>>> 			struct tc_action **a, int bind)
>>>>> {
>>>>> 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
>>>>> 	struct tc_action *p;
>>>>> 	int err;
>>>>>
>>>>> 	spin_lock(&idrinfo->lock);
>>>>> 	if (*index) {
>>>>> 		p = idr_find(&idrinfo->action_idr, *index);
>>>>> 		if (p) {
>>>>> 			if (bind)
>>>>> 	   			p->tcfa_bindcnt++;
>>>>> 			p->tcfa_refcnt++;
>>>>> 			*a = p;
>>>>> 			err = 0;
>>>>> 		} else {
>>>>> 			*a = NULL;
>>>>> 			err = idr_alloc_u32(idr, NULL, index,
>>>>> 					    *index, GFP_ATOMIC);
>>>>> 		}
>>>>> 	} else {
>>>>> 		*index = 1;
>>>>> 		*a = NULL;
>>>>> 		err = idr_alloc_u32(idr, NULL, index, UINT_MAX, GFP_ATOMIC);
>>>>> 	}
>>>>> 	spin_unlock(&idrinfo->lock);
>>>>> 	return err;
>>>>> }
>>>>>
>>>>> The act code would just check if "a" is NULL and if so, it would call
>>>>> tcf_idr_create() with allocated index as arg.
>>>>
>>>>What about multiple actions that have arbitrary code between initial
>>>>check and idr allocation that is currently inside tcf_idr_create()?
>>>
>>> Why it would be a problem to have them after the allocation?
>>
>>Lets look at mirred for exmple:
>>	exists = tcf_idr_check(tn, parm->index, a, bind);
>>	if (exists && bind)
>>		return 0;
>>
>>	switch (parm->eaction) {
>>	case TCA_EGRESS_MIRROR:
>>	case TCA_EGRESS_REDIR:
>>	case TCA_INGRESS_REDIR:
>>	case TCA_INGRESS_MIRROR:
>>		break;
>>	default:
>>		if (exists)
>>			tcf_idr_release(*a, bind);
>>		NL_SET_ERR_MSG_MOD(extack, "Unknown mirred option");
>>		return -EINVAL;
>>	}
>>	if (parm->ifindex) {
>>		dev = __dev_get_by_index(net, parm->ifindex);
>>		if (dev == NULL) {
>>			if (exists)
>>				tcf_idr_release(*a, bind);
>>			return -ENODEV;
>>		}
>>		mac_header_xmit = dev_is_mac_header_xmit(dev);
>>	} else {
>>		dev = NULL;
>>	}
>>
>>	if (!exists) {
>>		if (!dev) {
>>			NL_SET_ERR_MSG_MOD(extack, "Specified device does not exist");
>>			return -EINVAL;
>>		}
>>		ret = tcf_idr_create(tn, parm->index, est, a,
>>				     &act_mirred_ops, bind, true);
>>		/* Action with specified index was created concurrently.
>>		 * Check again.
>>		 */
>>		if (parm->index && ret == -ENOSPC)
>>			goto replay;
>>		else if (ret)
>>			return ret;
>>
>>There are several returns and cleanup is only performed when action
>>exists. So all code like that will have to be audited to also remove
>>index from idr, otherwise idr handles leak on return.
>
> Yeah. You have to take care of the error path.
>
>
>>
>>>
>>> There is one issue though with my draft. tcf_idr_insert() function
>>> which actually assigns a "p" pointer to the idr index is called later on.
>>> Until that happens, the idr_find() would return NULL even if the index
>>> is actually allocated. We cannot assign "p" in tcf_idr_check_alloc()
>>> because it is allocated only later on in tcf_idr_create(). But that is
>>> resolvable by the following trick:
>>>
>>> int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
>>> 			struct tc_action **a, int bind)
>>> {
>>> 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
>>> 	struct tc_action *p;
>>> 	int err;
>>>
>>> again:
>>> 	spin_lock(&idrinfo->lock);
>>> 	if (*index) {
>>>  		p = idr_find(&idrinfo->action_idr, *index);
>>> 		if (IS_ERR(p)) {
>>> 			/* This means that another process allocated
>>> 			 * index but did not assign the pointer yet.
>>> 			 */
>>> 			spin_unlock(&idrinfo->lock);
>>> 			goto again;
>>> 		}
>>>  		if (p) {
>>>  			if (bind)
>>>  	   			p->tcfa_bindcnt++;
>>>  			p->tcfa_refcnt++;
>>>  			*a = p;
>>>  			err = 0;
>>>  		} else {
>>>  			*a = NULL;
>>>  			err = idr_alloc_u32(idr, NULL, index,
>>>  					    *index, GFP_ATOMIC);
>>> 			idr_replace(&idrinfo->action_idr,
>>> 				    ERR_PTR(-EBUSY), *index);
>>>  		}
>>>  	} else {
>>>  		*index = 1;
>>> 		*a = NULL;
>>>  		err = idr_alloc_u32(idr, NULL, index, UINT_MAX, GFP_ATOMIC);
>>> 		idr_replace(&idrinfo->action_idr, ERR_PTR(-EBUSY), *index);
>>>  	}
>>>  	spin_unlock(&idrinfo->lock);
>>>  	return err;
>>> }
>>>
>>
>>So users of action idr that might perform concurrent lookups are also
>>have to be changed to check for error pointers, that now can be inserted
>>into idr? Seems like a complex change...
>
> You can just add a simple check into tcf_idr_lookup(). Where else?
>

To me it looks like we take something simple and already working, and
make it complex to save few lines of code in action init...

Anyway, how should I do patch split for this?
Patch to implement function you outlined and another one to modify all
actions to use it(with all refactoring to not leak references)? Or patch
per action is better approach?
