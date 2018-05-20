From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 02/14] net: sched: change type of reference and bind counters
Date: Sun, 20 May 2018 13:55:59 +0300
Message-ID: <vbfsh6ma94w.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <1526308035-12484-3-git-send-email-vladbu@mellanox.com> <20180519210442.GA5488@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20180519210442.GA5488@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sat 19 May 2018 at 21:04, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Mon, May 14, 2018 at 05:27:03PM +0300, Vlad Buslov wrote:
>> Change type of action reference counter to refcount_t.
>>
>> Change type of action bind counter to atomic_t.
>> This type is used to allow decrementing bind counter without testing
>> for 0 result.
>
> ... and in what does not testing for 0 result helps?
>
>   Marcelo

Atomic operations don't WARN in this case.
