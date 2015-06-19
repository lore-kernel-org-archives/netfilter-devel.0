From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,v2] netfilter: nft_counter: convert it to use
 per-cpu counters
Date: Fri, 19 Jun 2015 11:59:17 +0200
Message-ID: <20150619095917.GA7177@salvia>
References: <1434706590-3560-1-git-send-email-pablo@netfilter.org>
 <20150619093937.GD22946@acer.localdomain>
 <20150619094936.GA5011@salvia>
 <20150619095012.GE22946@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	eric.dumazet@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56355 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbbFSJx7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 05:53:59 -0400
Content-Disposition: inline
In-Reply-To: <20150619095012.GE22946@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 19, 2015 at 11:50:12AM +0200, Patrick McHardy wrote:
> On 19.06, Pablo Neira Ayuso wrote:
> > On Fri, Jun 19, 2015 at 11:39:37AM +0200, Patrick McHardy wrote:
> > > > +	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
> > > > +	struct nft_counter_percpu __percpu *cpu_stats;
> > > > +	struct nft_counter_percpu *this_cpu;
> > > > +
> > > > +	cpu_stats = netdev_alloc_pcpu_stats(struct nft_counter_percpu);
> > > > +	if (cpu_stats == NULL)
> > > > +		return ENOMEM;
> > > > +
> > > > +	preempt_disable();
> > > 
> > > Seems unnecessary, the stats are not active durign ->init().
> > 
> > I know, I need to find a better way to silent a lockdep preempt splat
> > that I'm getting here because of illegal use of this_cpu_ptr() with
> > preemption enabled.
> 
> Ok guess it doesn't really hurt.

I'm going to leave it in place, OK?
