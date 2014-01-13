From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Mon, 13 Jan 2014 14:50:55 -0700
Message-ID: <CANLsYky3y-h++c06j8VimWYXSv767MAqUgd0wHridATkKKcpng@mail.gmail.com>
References: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
	<1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
	<20131218095322.GA4740@localhost>
	<CANLsYkyA-DT3jWeYJUJG-6rNTDcfv22BrjfBBAaaL4qHu+H+PA@mail.gmail.com>
	<20140104023239.GA5972@localhost>
	<CANLsYkw4UhBGpUcvO9qqqvgz8j00=E6zojMxxXCsPQhStQtGXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	JP Abgrall <jpa@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CANLsYkw4UhBGpUcvO9qqqvgz8j00=E6zojMxxXCsPQhStQtGXg@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

I haven't heard back from my last post in which I detailed a scenario
where a race condition may occur on the output path.  Do you need more
information?  Is there something you'd like me to be more specific on?

Thanks,
Mathieu

On 6 January 2014 09:31, Mathieu Poirier <mathieu.poirier@linaro.org> wrote:
> On 3 January 2014 19:32, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Fri, Jan 03, 2014 at 01:38:45PM -0700, Mathieu Poirier wrote:
>>> ...
>>>
>>> > I think you can avoid this private area (including the spinlock) by
>>> > storing a copy of the packet/byte counter before calling
>>> > nfnl_acct_update(). Then if you note that old packet/byte counter was
>>> > below quota but new is overquota, then you have to send an event, ie.
>>> >
>>> >         old_pkts = atomic64_read(info->nfacct->pkts);
>>> >         new_pkts = nfnl_acct_update(skb, info->nfacct, info->flags);
>>> >         if (old_pkts < info->quota && new_pkts > info->quota)
>>> >                 send event
>>> >
>>> > There's still one problem with this approach since it is racy, as it
>>> > may send several events, so you can refine it with:
>>> >
>>> >         if (old_pkts < info->quota && new_pkts > info->quota
>>> >             && old_pkts + 1 == new_pkts)
>>> >                 send event
>>> >
>>> > You will need two different functions depending on the quota mode
>>> > (packet or bytes), and you will also need to modify nfnl_acct_update()
>>> > to return the new number of packets or bytes (depending on the flags),
>>> > you can use atomic_add_return and atomic_inc_return respectively to
>>> > retrieve the new (updated) value.
>>>
>>> Now that we've dealt with the logging issue we can concentrate on the
>>> above suggestion that tries to avoid using a spinlock.  It works well
>>> in packet mode but not so much in byte mode.
>>>
>>> Whether working in byte or packet mode the solution is using packets
>>> to determine who will send the notification.  When dealing with bytes
>>> identifying which packet made the byte count go over quota is of prime
>>> importance.  The problem is that the upgrade of packet and bytes in
>>> "nfnl_acct_update()" is not atomic to the caller - there is always a
>>> possibility that the thread will lose the CPU between incrementing
>>> packet and bytes.  This could eventually lead to erroneous arithmetic
>>> and an imprecise recognition of a quota attainment.
>>
>> In the input and forwarding path, packets run in bh context, so that
>> won't happen.  That may only happen in the output path in process
>> context. However, I don't understand how this may lead to "erroneous
>> arithmetic" in the "quota attainment" yet, you have to elaborate your
>> concerns/scenario more specifically.
>
> Given the following snippet:
>
>  1        old_bytes = atomic64_read(nfacct->bytes);
>  2        old_packets = atomic64_read(nfacct->pkts);
>  3        new_bytes = nfnl_acct_update(skb, info->nfacct, info->flags);
>  4        new_packets = atomic64_read(nfacct->pkts);
>
> 1. I think we have a problem between line 1 and 2.  Process A could be
> interrupted after line 1, process B upgrading both nfacct->bytes and
> nfacct->pkts and Process A resuming, setting bad metrics from the
> start.  This can be remedied by reading packets, then bytes and
> packets again, repeating the process until both packet count are
> equal.
>
> 2. I think we need to modify nfnl_acct_update() to take a byte and
> packet count rather than a flags.  That way both could be upgraded
> within the function.
>
> 3. After line 3 we have our new byte count and let's assume at that
> point old_packets is 100.  At that very moment the process (let's call
> it A) is suspended and the same code gets to run on another CPU in the
> system (process B), making nfacct->pkts == 101.  When process A
> resumes it will increment nfacct->pkts, making it 102, which will not
> be equal to old_packets + 1.  Here Process B will end up sending the
> notification when in fact it should be process A.
>
> My paranoia may come from a lack of understanding of how packets are
> processed in the system.
>
>>
>>> No matter how I turn things around in my head we need a spinlock -
>>> either in nfnl_acct_update() or in the match function of xt_nfacct.c.
