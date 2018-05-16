From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 11/14] net: core: add new/replace rate estimator lock parameter
Date: Wed, 16 May 2018 13:00:57 +0300
Message-ID: <vbf603n2a3q.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <1526308035-12484-12-git-send-email-vladbu@mellanox.com> <20180516095416.GH1972@nanopsycho>
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
In-reply-to: <20180516095416.GH1972@nanopsycho>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Wed 16 May 2018 at 09:54, Jiri Pirko <jiri@resnulli.us> wrote:
> Mon, May 14, 2018 at 04:27:12PM CEST, vladbu@mellanox.com wrote:
>>Extend rate estimator new and replace APIs with additional spinlock
>>parameter used by lockless actions to protect rate_est pointer from
>>concurrent modification.
>>
>>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>
> [...]
>
>
>> /**
>>  * gen_new_estimator - create a new rate estimator
>>  * @bstats: basic statistics
>>  * @cpu_bstats: bstats per cpu
>>  * @rate_est: rate estimator statistics
>>+ * @rate_est_lock: rate_est lock (might be NULL)
>
> I cannot find a place you actually use this new arg in this patchset.
> Did I miss it?

It is used by specific action init function. However, that code was
moved to next patchset due to patchset size limit.

>
>
>>  * @stats_lock: statistics lock
>>  * @running: qdisc running seqcount
>>  * @opt: rate estimator configuration TLV
>
> [...]
