From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: xtables: avoid percpu ruleset
 duplication
Date: Fri, 12 Jun 2015 08:04:52 -0700
Message-ID: <1434121492.27504.84.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1433979295-7747-1-git-send-email-fw@strlen.de>
	 <1433979295-7747-2-git-send-email-fw@strlen.de>
	 <1434000773.27504.31.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20150612123252.GA13866@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35477 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbbFLPEy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 11:04:54 -0400
Received: by iesa3 with SMTP id a3so26309449ies.2
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jun 2015 08:04:53 -0700 (PDT)
In-Reply-To: <20150612123252.GA13866@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2015-06-12 at 14:32 +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 10, 2015 at 10:32:53PM -0700, Eric Dumazet wrote:
> > On Thu, 2015-06-11 at 01:34 +0200, Florian Westphal wrote:
> > > We store the rule blob per (possible) cpu.  Unfortunately this means we can
> > > waste lot of memory on big smp machines. ipt_entry structure ('rule head')
> > > is 112 byte, so e.g. with maxcpu=64 one single rule eats
> > > close to 8k RAM.
> > > 
> > > Since previous patch made counters percpu it appears there is nothing
> > > left in the rule blob that needs to be percpu.
> > > 
> > > On my test system (144 possible cpus, 400k dummy rules) this
> > > change saves close to 9 Gigabyte of RAM.
> > > 
> > > Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > ---
> > 
> > Very happy to see this happening, thanks Florian.
> > 
> > Acked-by: Eric Dumazet <edumazet@google.com>
> 
> Applied this series, thanks !

Note that now we have a single copy of the rules, we might try to use
kmalloc() instead of vmalloc() a bit harder for tables <= 64KB, reducing
TLB pressure.

newinfo->entries = NULL;
if (size <= PAGE_SIZE << MAX_ORDER)
	newinfo->entries = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
if (!newinfo->entries)
	newinfo->entries = vmalloc(size);


I'll send a patch for this, but can you push your tree ?
(Assuming this is
http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/ )

Thanks


