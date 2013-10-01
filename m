From: Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH 6/6] sched, wait: Make the __wait_event*() interface more
 friendly
Date: Tue, 1 Oct 2013 11:00:41 +0300 (EEST)
Message-ID: <alpine.LFD.2.00.1310011054280.1710@ja.ssi.bg>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ja.ssi.bg ([178.16.129.10]:45561 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751769Ab3JAIGQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:06:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


	Hello,

> On Fri, Sep 27, 2013 at 06:15:07PM +0200, Peter Zijlstra wrote:
> > +++ b/net/netfilter/ipvs/ip_vs_sync.c
> > @@ -1637,12 +1637,9 @@ static int sync_thread_master(void *data
> >                     continue;
> >             }
> >             while (ip_vs_send_sync_msg(tinfo->sock, sb->mesg) < 0) {
> > -                   int ret = 0;
> > -
> > -                   __wait_event_interruptible(*sk_sleep(sk),
> > +                   int ret = 
__wait_event_interruptible(*sk_sleep(sk),
> >                                                sock_writeable(sk) ||
> > -                                              kthread_should_stop(),
> > -                                              ret);
> > +                                              kthread_should_stop());
> >                     if (unlikely(kthread_should_stop()))
> >                             goto done;
> >             }
>
> That site seems to be ignoring the interruptible state... seems wrong.

	This is a kthread which ignores signals by default.
It terminates only with kthread_stop. I hope it works
correctly for such context. This is a loop that polls socket
space for writing when there is a buffer for sending.

Regards

--
Julian Anastasov <ja@ssi.bg>
