From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH nf-next,v2] netfilter: nft_counter: convert it to use
 per-cpu counters
Date: Fri, 19 Jun 2015 10:43:32 -0300
Message-ID: <20150619134332.GB11133@localhost.localdomain>
References: <1434706590-3560-1-git-send-email-pablo@netfilter.org>
 <20150619093937.GD22946@acer.localdomain>
 <20150619094936.GA5011@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	fw@strlen.de, eric.dumazet@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbbFSNne (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:43:34 -0400
Content-Disposition: inline
In-Reply-To: <20150619094936.GA5011@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 19, 2015 at 11:49:36AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jun 19, 2015 at 11:39:37AM +0200, Patrick McHardy wrote:
> > On 19.06, Pablo Neira Ayuso wrote:
> > >  static void nft_counter_eval(const struct nft_expr *expr,
> > >  			     struct nft_regs *regs,
> > >  			     const struct nft_pktinfo *pkt)
> > >  {
> > > -	struct nft_counter *priv = nft_expr_priv(expr);
> > > +	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
> > > +	struct nft_counter_percpu *this_cpu;
> > >  
> > > -	write_seqlock_bh(&priv->lock);
> > > -	priv->bytes += pkt->skb->len;
> > > -	priv->packets++;
> > > -	write_sequnlock_bh(&priv->lock);
> > > +	this_cpu = this_cpu_ptr(priv->counter);
> > > +	this_cpu->counter.bytes += pkt->skb->len;
> > > +	this_cpu->counter.packets++;
> > 
> > u64_state_update_begin()/end()?
> 
> Right, will fix that, thanks!
> 
> > > @@ -67,23 +83,46 @@ static int nft_counter_init(const struct nft_ctx *ctx,
> > >  			    const struct nft_expr *expr,
> > >  			    const struct nlattr * const tb[])
> > >  {
> > > -	struct nft_counter *priv = nft_expr_priv(expr);
> > > -
> > > -	if (tb[NFTA_COUNTER_PACKETS])
> > > -	        priv->packets = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
> > > -	if (tb[NFTA_COUNTER_BYTES])
> > > -		priv->bytes = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
> > > +	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
> > > +	struct nft_counter_percpu __percpu *cpu_stats;
> > > +	struct nft_counter_percpu *this_cpu;
> > > +
> > > +	cpu_stats = netdev_alloc_pcpu_stats(struct nft_counter_percpu);
> > > +	if (cpu_stats == NULL)
> > > +		return ENOMEM;
> > > +
> > > +	preempt_disable();
> > 
> > Seems unnecessary, the stats are not active durign ->init().
> 
> I know, I need to find a better way to silent a lockdep preempt splat
> that I'm getting here because of illegal use of this_cpu_ptr() with
> preemption enabled.

If preemption is safe, maybe you can use raw_cpu_ptr() instead?

  Marcelo

> > > +	this_cpu = this_cpu_ptr(cpu_stats);
> > > +	if (tb[NFTA_COUNTER_PACKETS]) {
> > > +	        this_cpu->counter.packets =
> > > +			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
> > > +	}
> > > +	if (tb[NFTA_COUNTER_BYTES]) {
> > > +		this_cpu->counter.bytes =
> > > +			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
> > > +	}
> > > +	preempt_enable();
> > > +
> > > +	priv->counter = cpu_stats;
> > >  
> > > -	seqlock_init(&priv->lock);
> > >  	return 0;
> > >  }
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
