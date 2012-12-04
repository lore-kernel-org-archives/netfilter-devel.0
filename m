From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2] netfilter: remove extra timer from ecache extension
Date: Tue, 4 Dec 2012 18:21:57 +0100
Message-ID: <20121204172157.GA18304@1984>
References: <1354613751-30154-1-git-send-email-fw@strlen.de>
 <20121204121323.GA29442@1984>
 <20121204154118.GE11627@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52574 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab2LDRWG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2012 12:22:06 -0500
Content-Disposition: inline
In-Reply-To: <20121204154118.GE11627@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 04, 2012 at 04:41:18PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Dec 04, 2012 at 10:35:51AM +0100, Florian Westphal wrote:
> > > This brings the (per-conntrack) ecache extension back to 24 bytes in
> > > size (was 112 byte on x86_64 with lockdep on).
> > > 
> > > Instead we use a per-ns tasklet to re-trigger event delivery.  When we
> > > enqueue a ct entry into the dying list, the tasklet is scheduled.
> > > 
> > > The tasklet will then deliver up to 20 entries.  It will re-sched
> > > itself unless all the pending events could be delivered.
> > > 
> > > While at it, dying list handling is moved into ecache.c, since its only
> > > revlevant if ct events are enabled.
> > 
> > Just tested this. My testbed consists of two firewalls in HA running
> > conntrackd with event reliable mode. I've got a client that generates
> > lots of small TCP flows that goes through the firewalls and reach a
> > benchmark server.
> > 
> > This is my analysis:
> > 
> > conntrack -C shows:
> [..]
> > 261548 <--- we hit table full, dropping packets
> > 176849 <--- it seems the tasklet gets a chance to run
> >             given that we get less interruptions from the NIC
> > 166449 <--- it slightly empty the dying list
> > 131176
> > 55602
> > 28316
> [..]
> > #  hits  hits/s  ^h/s  ^bytes   kB/s  errs   rst  tout  mhtime
> > 4796894 15727 16509   2393805   2227     0     0     0   0.005
> > 4813038 15728 16144   2340880   2227     0     0     0   0.005
> > 4828796 15728 15758   2284910   2227     0     0     0   0.005
> > 4845279 15731 16483   2390035   2227     0     0     0   0.005
> > 4860956 15731 15677   2273165   2227     0     0     0   0.005
> > 4876826 15731 15870   2301150   2227     0     0     0   0.005
> > 4883165 15701  6339    919155   2223     0     0     0   0.004
> > 4883165 15651     0         0   2216     0     0     0   0.000  <--- table full
> > 4883165 15601     0         0   2209     0     0     0   0.000
> > 4894657 15588 11492   1666340   2207     0     0     0   3.008
> > 4913408 15598 18751   2718895   2208     0     0     0   0.004
> > 4931896 15607 18488   2680760   2210     0     0     0   0.004
> > 
> > So it seems the tasklet gets starved under heavy load.
> > 
> > This happens on and on, so after some time we hit table full and again
> > the dying list is empty.
> > 
> > These are old HP proliant DL145G2 from 2005, that's why the maximum
> > flows/s looks low.
> > 
> > Looking at the number and the behaviour under heavy stress, I think we
> > have to consider a different approach.
> 
> Thanks for testing.  Is that a single cpu machine?

Single cpu with two cores.

> If yes, I think this result might be because the tasklet busy-loop
> competes with conntrackd for cpu, so essentially we waste cycles
> on futile re-delivery instead of leaving the cpu to conntrackd,
> (which should process events).

Makes sense.

> If thats true, then we might be able to improve this by avoiding the
> 'tasklet re-scheds itself'.  This would also solve the
> 'softirqd eats 100% cpu' when conntrackd is stopped/suspended.
>
> I'll see if I can cook up a patch some time tomorrow.

That's fine.

Thanks.
