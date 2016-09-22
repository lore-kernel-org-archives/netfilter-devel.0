From: Fabian Frederick <fabf@skynet.be>
Subject: Re: [PATCH 1/1 linux-next] netfilter: conntrack: fix kmemleak false
 positive
Date: Thu, 22 Sep 2016 19:55:57 +0200 (CEST)
Message-ID: <49958525.49207.1474566957624.open-xchange@webmail.nmp.proximus.be>
References: <1474487397-11032-1-git-send-email-fabf@skynet.be> <20160921210253.GB24153@breakpoint.cc>
Reply-To: Fabian Frederick <fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160921210253.GB24153@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



> On 21 September 2016 at 23:02 Florian Westphal <fw@strlen.de> wrote:
>
>
> Fabian Frederick <fabf@skynet.be> wrote:
> > Since commit f330a7fdbe16
> > ("netfilter: conntrack: get rid of conntrack timer")
> >
> > closed connections remain longer in /proc/net/nf_conntrack
> >
> > Running current kernel; just after boot:
> > cat /proc/net/nf_conntrack | wc -l = 5
> > 4 minutes required to clean up the table.
>
> We should reap the stale entries while iterating, just like
> we do for ctnetlink interface.
>
> Can you try this patch?
>
> diff --git a/net/netfilter/nf_conntrack_standalone.c
> b/net/netfilter/nf_conntrack_standalone.c
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -212,6 +212,11 @@ static int ct_seq_show(struct seq_file *s, void *v)
>       if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
>               return 0;
> 
> +     if (nf_ct_should_gc(ct)) {
> +             nf_ct_kill(ct);
> +             goto release;
> +     }
> +
>       /* we only want to print DIR_ORIGINAL */
>       if (NF_CT_DIRECTION(hash))
>               goto release;
>

Hello Florian,

        First problem is solved: table gets cleared 3 minutes earlier
but I still have kmemleak before running the following:

echo scan > /sys/kernel/debug/kmemleak
cat /sys/kernel/debug/kmemleak
Nothing
echo scan > /sys/kernel/debug/kmemleak
cat /sys/kernel/debug/kmemleak
-> rsyslogd

I talked about false positive because everything is cleared later.

Note that problem appears only in a VM which is really slow due to
ksoftirqd eating lot of CPU for an unknown reason. Maybe you should test
somewhere else before applying.

Regards,
Fabian

> > Going back to kernel version before commit above there are
> > no connections after some seconds.
> >
> > Referring to the commit changelog this was an expected behaviour but
> > it results in temporary kmemleak reports:
>
> I don't see kmemleak complaints on my test vm, I'm reluctant to
> turn it off.
>
> Can you explain why we see such 'false positive'?
>
> The conntracks should still be referenced, as they
> are in main table.
>
> > unreferenced object 0xffff88003b0e6600 (size 248):
> >   comm "rsyslogd", pid 1595, jiffies 4294741312 (age 7.343s)
> >   ...
> >   backtrace:
> >     [] kmemleak_alloc+0x23/0x40
> >     [] kmem_cache_alloc+0xd9/0x180
> >     [] __nf_conntrack_alloc.isra.50+0x48/0x170
> >     [] nf_conntrack_in+0x3a2/0x5f0
> >     [] ipv4_conntrack_local+0x40/0x50
> >     [] nf_iterate+0x5d/0x70
> >     [] nf_hook_slow+0x5f/0xb0
> >     [] __ip_local_out+0xad/0xe0
> >     [] ip_local_out+0x17/0x40
> >     [] ip_send_skb+0x14/0x40
> >     [] udp_send_skb+0x91/0x260
> >     [] udp_sendmsg+0x2f5/0x950
> >     [] inet_sendmsg+0x60/0x90
> >     [] sock_sendmsg+0x33/0x40
> >     [] SYSC_sendto+0xee/0x160
> >     [] SyS_sendto+0x9/0x10
> >
> > (248 bytes being an nf_conn structure)
> >
> > Those structures being cleared in gc_worker() later on we can't talk
> > about unreferenced object so this patch uses kmemleak_not_leak() to
> > prevent those warnings.
>
> If thats the case, why is kmemleak complaining? Are you sure this
> is a false positive?
