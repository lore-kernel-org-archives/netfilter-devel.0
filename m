From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 14/14] net: sched: implement delete for all actions
Date: Wed, 16 May 2018 12:58:38 +0300
Message-ID: <vbf7eo32a7l.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <1526308035-12484-15-git-send-email-vladbu@mellanox.com> <20180516094850.GF1972@nanopsycho>
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
In-reply-to: <20180516094850.GF1972@nanopsycho>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Wed 16 May 2018 at 09:48, Jiri Pirko <jiri@resnulli.us> wrote:
> Mon, May 14, 2018 at 04:27:15PM CEST, vladbu@mellanox.com wrote:
>>Implement delete function that is required to delete actions without
>>holding rtnl lock. Use action API function that atomically deletes action
>>only if it is still in action idr. This implementation prevents concurrent
>>threads from deleting same action twice.
>>
>>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>>---
>> net/sched/act_bpf.c        |  8 ++++++++
>> net/sched/act_connmark.c   |  8 ++++++++
>> net/sched/act_csum.c       |  8 ++++++++
>> net/sched/act_gact.c       |  8 ++++++++
>> net/sched/act_ife.c        |  8 ++++++++
>> net/sched/act_ipt.c        | 16 ++++++++++++++++
>> net/sched/act_mirred.c     |  8 ++++++++
>> net/sched/act_nat.c        |  8 ++++++++
>> net/sched/act_pedit.c      |  8 ++++++++
>> net/sched/act_police.c     |  8 ++++++++
>> net/sched/act_sample.c     |  8 ++++++++
>> net/sched/act_simple.c     |  8 ++++++++
>> net/sched/act_skbedit.c    |  8 ++++++++
>> net/sched/act_skbmod.c     |  8 ++++++++
>> net/sched/act_tunnel_key.c |  8 ++++++++
>> net/sched/act_vlan.c       |  8 ++++++++
>> 16 files changed, 136 insertions(+)
>>
>>diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
>>index 0bf4ecf..36f7f66 100644
>>--- a/net/sched/act_bpf.c
>>+++ b/net/sched/act_bpf.c
>>@@ -394,6 +394,13 @@ static int tcf_bpf_search(struct net *net, struct tc_action **a, u32 index,
>> 	return tcf_idr_search(tn, a, index);
>> }
>> 
>>+static int tcf_bpf_delete(struct net *net, u32 index)
>>+{
>>+	struct tc_action_net *tn = net_generic(net, bpf_net_id);
>>+
>>+	return tcf_idr_find_delete(tn, index);
>>+}
>>+
>> static struct tc_action_ops act_bpf_ops __read_mostly = {
>> 	.kind		=	"bpf",
>> 	.type		=	TCA_ACT_BPF,
>>@@ -404,6 +411,7 @@ static struct tc_action_ops act_bpf_ops __read_mostly = {
>> 	.init		=	tcf_bpf_init,
>> 	.walk		=	tcf_bpf_walker,
>> 	.lookup		=	tcf_bpf_search,
>>+	.delete		=	tcf_bpf_delete,
>
> I wonder, right before this patch, how the idr index got removed?
> delete op is NULL and I didn't find anyone else to do it.
>
> Also, after this patch, does it make sense to have following check in
> tcf_action_del_1()?
>
>        if (ops->delete)
> 	       err = ops->delete(net, index);
>
> Looks like ops->delete is non-null for all.
>
> Seems to me that you need to introduce this patch filling up the delete
> op in all acts and only after that introduce a code that actually calls
> it.

Already moved this for V2 patchset to:
  - Add delete callback to ops and implement it for all actions in single
  patch.
  - Move this patch before delete first use.

Will now remove the conditional as well.

>
> [...]
