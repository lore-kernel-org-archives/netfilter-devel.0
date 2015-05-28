From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 -next 2/2] netfilter: store rules per NUMA node
 instead of per cpu
Date: Thu, 28 May 2015 23:52:23 +0200
Message-ID: <20150528215223.GG23992@breakpoint.cc>
References: <1432846296-26396-1-git-send-email-fw@strlen.de>
 <1432846296-26396-2-git-send-email-fw@strlen.de>
 <1432849093.7456.32.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49800 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932440AbbE1VwZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 17:52:25 -0400
Content-Disposition: inline
In-Reply-To: <1432849093.7456.32.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2015-05-28 at 22:51 +0200, Florian Westphal wrote:
> > We store rule blob per (possible) cpu.  Unfortunately this means we can
> > waste lot of memory on big smp machines. ipt_entry structure ('rule head')
> > is 112 byte, so e.g. with maxcpu=64 one single rule eats close to 8k RAM.
> > 
> > Since previous patch moved counters to separate percpu blob, it appears
> > there is nothing left in the rule blob that must be percpu.
> > 
> > Thus only duplicate the rule blob for each NUMA node.
> > 
> > On my test system (144 possible cpus, one numa node, 400k dummy rules) this
> > change saves close to 9 Gigabyte of RAM.
> > 
> > Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> 
> Really if the program is now readonly, I would keep a single copy in
> memory.

Some matches (limit for instance) store kernel data ptr in their
matchinfo data (from checkentry hook, not per packet match function),
so its not 100% readonly.

> Are we copying kernel text to each NUMA node ? ;)

Beats me.  I was under impression that cpu accessing memory on other node
takes access penalty, thats why I changed it to per node allocation.

Is it insignificant in practice?

If so, I can respin it w/o the numa duplication; we can still add it
back later if needed.
