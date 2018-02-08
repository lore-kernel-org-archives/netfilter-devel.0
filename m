From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [Patch net] ipt_CLUSTERIP: fix a refcount bug in clusterip_config_find_get()
Date: Thu, 8 Feb 2018 12:05:27 -0800
Message-ID: <CAM_iQpWj110yRVt0a0H-J4Q6cu9ocNTZT-f+JgAH+YdDJNp3Bw@mail.gmail.com>
References: <20180208055918.20411-1-xiyou.wangcong@gmail.com>
 <20180208055918.20411-2-xiyou.wangcong@gmail.com> <20180208080130.GJ14261@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180208080130.GJ14261@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Feb 8, 2018 at 12:01 AM, Florian Westphal <fw@strlen.de> wrote:
> Cong Wang <xiyou.wangcong@gmail.com> wrote:
>> In clusterip_config_find_get() we hold RCU read lock so it could
>> run concurrently with clusterip_config_entry_put(), as a result,
>> the refcnt could go back to 1 from 0, which leads to a double
>> list_del()... Just replace refcount_inc() with
>> refcount_inc_not_zero(), as for c->refcount.
>>
>> Fixes: d73f33b16883 ("netfilter: CLUSTERIP: RCU conversion")
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
>> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
>> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>> ---
>>  net/ipv4/netfilter/ipt_CLUSTERIP.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
>> index 1ff72b87a066..4537b1686c7c 100644
>> --- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
>> +++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
>> @@ -154,8 +154,10 @@ clusterip_config_find_get(struct net *net, __be32 clusterip, int entry)
>>  #endif
>>               if (unlikely(!refcount_inc_not_zero(&c->refcount)))
>>                       c = NULL;
>> -             else if (entry)
>> -                     refcount_inc(&c->entries);
>> +             else if (entry) {
>> +                     if (unlikely(!refcount_inc_not_zero(&c->entries)))
>
> this needs to call clusterip_config_put(c); too, else we leak one
> reference.
>
> Other than that this looks good.

Right, good catch! I will send v2.
