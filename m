From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 -next 2/2] netfilter: store rules per NUMA node
 instead of per cpu
Date: Thu, 28 May 2015 15:04:15 -0700
Message-ID: <1432850655.7456.45.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1432846296-26396-1-git-send-email-fw@strlen.de>
	 <1432846296-26396-2-git-send-email-fw@strlen.de>
	 <1432849093.7456.32.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20150528215223.GG23992@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36283 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbbE1WER (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 18:04:17 -0400
Received: by iepj10 with SMTP id j10so49122146iep.3
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2015 15:04:16 -0700 (PDT)
In-Reply-To: <20150528215223.GG23992@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2015-05-28 at 23:52 +0200, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On Thu, 2015-05-28 at 22:51 +0200, Florian Westphal wrote:
> > > We store rule blob per (possible) cpu.  Unfortunately this means we can
> > > waste lot of memory on big smp machines. ipt_entry structure ('rule head')
> > > is 112 byte, so e.g. with maxcpu=64 one single rule eats close to 8k RAM.
> > > 
> > > Since previous patch moved counters to separate percpu blob, it appears
> > > there is nothing left in the rule blob that must be percpu.
> > > 
> > > Thus only duplicate the rule blob for each NUMA node.
> > > 
> > > On my test system (144 possible cpus, one numa node, 400k dummy rules) this
> > > change saves close to 9 Gigabyte of RAM.
> > > 
> > > Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > ---
> > 
> > Really if the program is now readonly, I would keep a single copy in
> > memory.
> 
> Some matches (limit for instance) store kernel data ptr in their
> matchinfo data (from checkentry hook, not per packet match function),
> so its not 100% readonly.

Lets change 'read only' by 'read mostly' then ;)

> 
> > Are we copying kernel text to each NUMA node ? ;)
> 
> Beats me.  I was under impression that cpu accessing memory on other node
> takes access penalty, thats why I changed it to per node allocation.

Well, it depends. If one core is busy while others are idle, then
fetching data from 2 NUMA nodes is actually faster. (Some workloads are
actually faster with 'random' NUMA interleaving)

If you constrain all memory access being done from local node, then you
might loose total bandwidth. In practice, intensive workloads will
populate L1/L2/L3 cache, and actual memory location does not really
matter.

> 
> Is it insignificant in practice?

Well, its a trade off I guess.

You made clear that some people had 400k rules ;)


