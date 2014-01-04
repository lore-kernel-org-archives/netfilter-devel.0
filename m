From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Sat, 4 Jan 2014 03:32:39 +0100
Message-ID: <20140104023239.GA5972@localhost>
References: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
 <1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
 <20131218095322.GA4740@localhost>
 <CANLsYkyA-DT3jWeYJUJG-6rNTDcfv22BrjfBBAaaL4qHu+H+PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	JP Abgrall <jpa@google.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANLsYkyA-DT3jWeYJUJG-6rNTDcfv22BrjfBBAaaL4qHu+H+PA@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jan 03, 2014 at 01:38:45PM -0700, Mathieu Poirier wrote:
> ...
> 
> > I think you can avoid this private area (including the spinlock) by
> > storing a copy of the packet/byte counter before calling
> > nfnl_acct_update(). Then if you note that old packet/byte counter was
> > below quota but new is overquota, then you have to send an event, ie.
> >
> >         old_pkts = atomic64_read(info->nfacct->pkts);
> >         new_pkts = nfnl_acct_update(skb, info->nfacct, info->flags);
> >         if (old_pkts < info->quota && new_pkts > info->quota)
> >                 send event
> >
> > There's still one problem with this approach since it is racy, as it
> > may send several events, so you can refine it with:
> >
> >         if (old_pkts < info->quota && new_pkts > info->quota
> >             && old_pkts + 1 == new_pkts)
> >                 send event
> >
> > You will need two different functions depending on the quota mode
> > (packet or bytes), and you will also need to modify nfnl_acct_update()
> > to return the new number of packets or bytes (depending on the flags),
> > you can use atomic_add_return and atomic_inc_return respectively to
> > retrieve the new (updated) value.
> 
> Now that we've dealt with the logging issue we can concentrate on the
> above suggestion that tries to avoid using a spinlock.  It works well
> in packet mode but not so much in byte mode.
>
> Whether working in byte or packet mode the solution is using packets
> to determine who will send the notification.  When dealing with bytes
> identifying which packet made the byte count go over quota is of prime
> importance.  The problem is that the upgrade of packet and bytes in
> "nfnl_acct_update()" is not atomic to the caller - there is always a
> possibility that the thread will lose the CPU between incrementing
> packet and bytes.  This could eventually lead to erroneous arithmetic
> and an imprecise recognition of a quota attainment.

In the input and forwarding path, packets run in bh context, so that
won't happen.  That may only happen in the output path in process
context. However, I don't understand how this may lead to "erroneous
arithmetic" in the "quota attainment" yet, you have to elaborate your
concerns/scenario more specifically.

> No matter how I turn things around in my head we need a spinlock -
> either in nfnl_acct_update() or in the match function of xt_nfacct.c.
