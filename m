From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/6] sched, wait: Make the __wait_event*() interface more
 friendly
Date: Fri, 27 Sep 2013 19:08:35 +0200
Message-ID: <20130927170835.GH15690@laptop.programming.kicks-ass.net>
References: <20130927161501.323694767@infradead.org>
 <20130927161852.137894317@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Oleg Nesterov <oleg@redhat.com>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Ingo Molnar <mingo@kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3I0RIn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:08:43 -0400
Content-Disposition: inline
In-Reply-To: <20130927161852.137894317@infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 27, 2013 at 06:15:07PM +0200, Peter Zijlstra wrote:
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -1637,12 +1637,9 @@ static int sync_thread_master(void *data
>  			continue;
>  		}
>  		while (ip_vs_send_sync_msg(tinfo->sock, sb->mesg) < 0) {
> -			int ret = 0;
> -
> -			__wait_event_interruptible(*sk_sleep(sk),
> +			int ret = __wait_event_interruptible(*sk_sleep(sk),
>  						   sock_writeable(sk) ||
> -						   kthread_should_stop(),
> -						   ret);
> +						   kthread_should_stop());
>  			if (unlikely(kthread_should_stop()))
>  				goto done;
>  		}

That site seems to be ignoring the interruptible state... seems wrong.

Pablo?
