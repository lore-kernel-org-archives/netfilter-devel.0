From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 09/14] net: sched: don't release reference on action
 overwrite
Date: Wed, 16 May 2018 09:50:29 +0200
Message-ID: <20180516075029.GD1972@nanopsycho>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-10-git-send-email-vladbu@mellanox.com>
 <20180516074332.GB1972@nanopsycho>
 <vbfd0xw11pn.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Vlad Buslov <vladbu@mellanox.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <vbfd0xw11pn.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Wed, May 16, 2018 at 09:47:32AM CEST, vladbu@mellanox.com wrote:
>
>On Wed 16 May 2018 at 07:43, Jiri Pirko <jiri@resnulli.us> wrote:
>> Mon, May 14, 2018 at 04:27:10PM CEST, vladbu@mellanox.com wrote:
>>>Return from action init function with reference to action taken,
>>>even when overwriting existing action.
>>>
>>>Action init API initializes its fourth argument (pointer to pointer to
>>>tc action) to either existing action with same index or newly created
>>>action. In case of existing index(and bind argument is zero), init
>>>function returns without incrementing action reference counter. Caller
>>>of action init then proceeds working with action without actually
>>>holding reference to it. This means that action could be deleted
>>>concurrently. To prevent such scenario this patch changes action init
>>
>> Be imperative to the codebase in the patch description.
>>
>>
>>>behavior to always take reference to action before returning
>>>successfully.
>>
>> Where's the balance? Who does the release instead? I'm probably missing
>> something.
>
>I've resplit these patches for V2 to always do take/release in same
>patch.

Good. Thanks.

>
>>
>>>
>>>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>>>---
>>> net/sched/act_bpf.c        |  8 ++++----
>>> net/sched/act_connmark.c   |  5 +++--
>>> net/sched/act_csum.c       |  8 ++++----
>>> net/sched/act_gact.c       |  5 +++--
>>> net/sched/act_ife.c        | 12 +++++-------
>>> net/sched/act_ipt.c        |  5 +++--
>>> net/sched/act_mirred.c     |  5 ++---
>>> net/sched/act_nat.c        |  5 +++--
>>> net/sched/act_pedit.c      |  5 +++--
>>> net/sched/act_police.c     |  8 +++-----
>>> net/sched/act_sample.c     |  8 +++-----
>>> net/sched/act_simple.c     |  5 +++--
>>> net/sched/act_skbedit.c    |  5 +++--
>>> net/sched/act_skbmod.c     |  8 +++-----
>>> net/sched/act_tunnel_key.c |  8 +++-----
>>> net/sched/act_vlan.c       |  8 +++-----
>>> 16 files changed, 51 insertions(+), 57 deletions(-)
>>>
>>>diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
>>>index 5d95c43..5554bf7 100644
>>>--- a/net/sched/act_bpf.c
>>>+++ b/net/sched/act_bpf.c
>>>@@ -311,9 +311,10 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
>>> 		if (bind)
>>> 			return 0;
>>> 
>>>-		tcf_idr_release(*act, bind);
>>>-		if (!replace)
>>>+		if (!replace) {
>>>+			tcf_idr_release(*act, bind);
>>> 			return -EEXIST;
>>>+		}
>>> 	}
>>> 
>>> 	is_bpf = tb[TCA_ACT_BPF_OPS_LEN] && tb[TCA_ACT_BPF_OPS];
>>
>> [...]
>
