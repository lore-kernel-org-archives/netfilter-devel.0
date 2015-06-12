From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: xtables: avoid percpu ruleset
 duplication
Date: Fri, 12 Jun 2015 14:32:52 +0200
Message-ID: <20150612123252.GA13866@salvia>
References: <1433979295-7747-1-git-send-email-fw@strlen.de>
 <1433979295-7747-2-git-send-email-fw@strlen.de>
 <1434000773.27504.31.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57408 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbbFLM1j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 08:27:39 -0400
Content-Disposition: inline
In-Reply-To: <1434000773.27504.31.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 10, 2015 at 10:32:53PM -0700, Eric Dumazet wrote:
> On Thu, 2015-06-11 at 01:34 +0200, Florian Westphal wrote:
> > We store the rule blob per (possible) cpu.  Unfortunately this means we can
> > waste lot of memory on big smp machines. ipt_entry structure ('rule head')
> > is 112 byte, so e.g. with maxcpu=64 one single rule eats
> > close to 8k RAM.
> > 
> > Since previous patch made counters percpu it appears there is nothing
> > left in the rule blob that needs to be percpu.
> > 
> > On my test system (144 possible cpus, 400k dummy rules) this
> > change saves close to 9 Gigabyte of RAM.
> > 
> > Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> 
> Very happy to see this happening, thanks Florian.
> 
> Acked-by: Eric Dumazet <edumazet@google.com>

Applied this series, thanks !
