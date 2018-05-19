From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH 12/14] net: sched: retry action check-insert on
 concurrent modification
Date: Sat, 19 May 2018 19:35:46 -0300
Message-ID: <20180519223546.GG5488@localhost.localdomain>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-13-git-send-email-vladbu@mellanox.com>
 <20180516095953.GI1972@nanopsycho>
 <vbf4lj724th.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
 <20180516122600.GM1972@nanopsycho>
 <vbfwow322k1.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
 <20180516132135.GN1972@nanopsycho>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        ast@kernel.org, daniel@iogearbox.net, edumazet@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kliteyn@mellanox.com
To: Jiri Pirko <jiri@resnulli.us>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180516132135.GN1972@nanopsycho>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 16, 2018 at 03:21:35PM +0200, Jiri Pirko wrote:
...
> int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
> 			struct tc_action **a, int bind)

Considering we don't have any other variant of it, maybe just
"tcf_idr_alloc()" instead?
