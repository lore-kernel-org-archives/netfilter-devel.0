From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 12/14] net: sched: retry action check-insert on
 concurrent modification
Date: Wed, 16 May 2018 11:59:53 +0200
Message-ID: <20180516095953.GI1972@nanopsycho>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-13-git-send-email-vladbu@mellanox.com>
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
In-Reply-To: <1526308035-12484-13-git-send-email-vladbu@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mon, May 14, 2018 at 04:27:13PM CEST, vladbu@mellanox.com wrote:
>Retry check-insert sequence in action init functions if action with same
>index was inserted concurrently.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>---
> net/sched/act_bpf.c        | 8 +++++++-
> net/sched/act_connmark.c   | 8 +++++++-
> net/sched/act_csum.c       | 8 +++++++-
> net/sched/act_gact.c       | 8 +++++++-
> net/sched/act_ife.c        | 8 +++++++-
> net/sched/act_ipt.c        | 8 +++++++-
> net/sched/act_mirred.c     | 8 +++++++-
> net/sched/act_nat.c        | 8 +++++++-
> net/sched/act_pedit.c      | 8 +++++++-
> net/sched/act_police.c     | 9 ++++++++-
> net/sched/act_sample.c     | 8 +++++++-
> net/sched/act_simple.c     | 9 ++++++++-
> net/sched/act_skbedit.c    | 8 +++++++-
> net/sched/act_skbmod.c     | 8 +++++++-
> net/sched/act_tunnel_key.c | 9 ++++++++-
> net/sched/act_vlan.c       | 9 ++++++++-
> 16 files changed, 116 insertions(+), 16 deletions(-)
>
>diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
>index 5554bf7..7e20fdc 100644
>--- a/net/sched/act_bpf.c
>+++ b/net/sched/act_bpf.c
>@@ -299,10 +299,16 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
> 
> 	parm = nla_data(tb[TCA_ACT_BPF_PARMS]);
> 
>+replay:
> 	if (!tcf_idr_check(tn, parm->index, act, bind)) {
> 		ret = tcf_idr_create(tn, parm->index, est, act,
> 				     &act_bpf_ops, bind, true);
>-		if (ret < 0)
>+		/* Action with specified index was created concurrently.
>+		 * Check again.
>+		 */
>+		if (parm->index && ret == -ENOSPC)
>+			goto replay;
>+		else if (ret)

Hmm, looks like you are doing the same/very similar thing in every act
code. I think it would make sense to introduce a helper function for
this purpose.

[...]
