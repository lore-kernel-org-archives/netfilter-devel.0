From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: remove extra timer from ecache extension
Date: Mon, 3 Dec 2012 16:17:06 +0100
Message-ID: <20121203151706.GD11627@breakpoint.cc>
References: <1354306565-2289-1-git-send-email-fw@strlen.de>
 <20121203143933.GB5599@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41180 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490Ab2LCPRI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:17:08 -0500
Content-Disposition: inline
In-Reply-To: <20121203143933.GB5599@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Instead we use a per-ns tasklet to re-trigger event delivery.
> > When we enqueue a ct entry into the dying list, the tasklet
> > is scheduled.
> > 
> > The tasklet will then deliver up to 20 entries.  It will
> > re-sched itself if not all the pending events could be delivered.
> 
> I would like to give a test to this patch in my testbed.

That would be great.

I can re-spin the patch on top of your dying-list changes, if
you prefer to test all patches at the same time.

> And I wonder if we can make it better with some timer-based garbage
> collector that randomly / adaptively runs to give tries to deliver
> events.
> 
> I remember that insisting too often in the delivery of missed events
> does not make any good.

Yes, from my tests only very few attempts are successful.

However, I've failed to come up with a scheme where events
are re-tried in a timely manner without risk of acummulating
a large event/entry backlog.

> >  Note: Conflicts with "improve conntrack object traceability".
> > 
> >  The patch assumes the dying list only contains entries where the delete
> >  event has not been delivered yet.
> > 
> >  With that patch, all conntracks are put on the dying list, including
> >  those who are about to be free'd.
> > 
> >  I THINK that this is fixable by skipping dying-list entries with
> >  IPS_DYING_BIT set.  However, this will increase the tasket workload.
> 
> I think you will mostly find entries that are waiting for its event to
> be delivered. So playing with IPS_DYING_BIT seems the right way to go
> to me.

Perfect.  Thats what I'll do, then.
