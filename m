From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 13/14] net: sched: use unique idr insert function in unlocked actions
Date: Wed, 16 May 2018 12:54:29 +0300
Message-ID: <vbf8t8k0vu2.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <1526308035-12484-14-git-send-email-vladbu@mellanox.com> <20180516095057.GG1972@nanopsycho>
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
In-reply-to: <20180516095057.GG1972@nanopsycho>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Wed 16 May 2018 at 09:50, Jiri Pirko <jiri@resnulli.us> wrote:
> Mon, May 14, 2018 at 04:27:14PM CEST, vladbu@mellanox.com wrote:
>>Substitute calls to action insert function with calls to action insert
>>unique function that warns if insertion overwrites index in idr.
>>
>>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>>---
>> net/sched/act_bpf.c        | 2 +-
>> net/sched/act_connmark.c   | 2 +-
>> net/sched/act_csum.c       | 2 +-
>> net/sched/act_gact.c       | 2 +-
>> net/sched/act_ife.c        | 2 +-
>> net/sched/act_ipt.c        | 2 +-
>> net/sched/act_mirred.c     | 2 +-
>> net/sched/act_nat.c        | 2 +-
>> net/sched/act_pedit.c      | 2 +-
>> net/sched/act_police.c     | 2 +-
>> net/sched/act_sample.c     | 2 +-
>> net/sched/act_simple.c     | 2 +-
>> net/sched/act_skbedit.c    | 2 +-
>> net/sched/act_skbmod.c     | 2 +-
>> net/sched/act_tunnel_key.c | 2 +-
>> net/sched/act_vlan.c       | 2 +-
>> 16 files changed, 16 insertions(+), 16 deletions(-)
>>
>>diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
>>index 7e20fdc..0bf4ecf 100644
>>--- a/net/sched/act_bpf.c
>>+++ b/net/sched/act_bpf.c
>>@@ -354,7 +354,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
>> 	rcu_assign_pointer(prog->filter, cfg.filter);
>> 
>> 	if (res == ACT_P_CREATED) {
>>-		tcf_idr_insert(tn, *act);
>>+		tcf_idr_insert_unique(tn, *act);
>
> Seems to me that tcf_idr_insert() is unused after this patch. If that is
> the case, I think that you don't need to introduce
> tcf_idr_insert_unique() and just do what you need to do in
> tcf_idr_insert()

Got it.

>
> [...]
