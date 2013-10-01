From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 6/6] sched, wait: Make the __wait_event*() interface
	more friendly
Date: Tue, 1 Oct 2013 19:19:50 +0200
Message-ID: <20131001171950.GA16145@redhat.com>
References: <alpine.LFD.2.00.1310011054280.1710@ja.ssi.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab3JAR07 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:26:59 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310011054280.1710@ja.ssi.bg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/01, Julian Anastasov wrote:
>
> 	Hello,
>
> > On Fri, Sep 27, 2013 at 06:15:07PM +0200, Peter Zijlstra wrote:
> > > +++ b/net/netfilter/ipvs/ip_vs_sync.c
> > > @@ -1637,12 +1637,9 @@ static int sync_thread_master(void *data
> > >                     continue;
> > >             }
> > >             while (ip_vs_send_sync_msg(tinfo->sock, sb->mesg) < 0) {
> > > -                   int ret = 0;
> > > -
> > > -                   __wait_event_interruptible(*sk_sleep(sk),
> > > +                   int ret =
> __wait_event_interruptible(*sk_sleep(sk),
> > >                                                sock_writeable(sk) ||
> > > -                                              kthread_should_stop(),
> > > -                                              ret);
> > > +                                              kthread_should_stop());
> > >                     if (unlikely(kthread_should_stop()))
> > >                             goto done;
> > >             }
> >
> > That site seems to be ignoring the interruptible state... seems wrong.
>
> 	This is a kthread which ignores signals by default.
> It terminates only with kthread_stop.

This only means that (with or without this change)
__wait_event_interruptible() generates the dead code but this
thread doesn't contribute to load_avg.

Anyway this patch should not makes any difference.

Oleg.

