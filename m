From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond
 packet boundary
Date: Wed, 15 May 2013 15:59:35 +0200
Message-ID: <20130515135935.GA1605@localhost>
References: <1368619552-30635-1-git-send-email-pablo@netfilter.org>
 <20130515123336.GE18095@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50387 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202Ab3EON7m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 09:59:42 -0400
Content-Disposition: inline
In-Reply-To: <20130515123336.GE18095@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 15, 2013 at 02:33:36PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This target assumes that tcph->doff is well-formed, that may be well
> > not the case. Add extra sanity checkings to avoid possible crash due
> > to read/write out of the real packet boundary.
> 
> >  static unsigned int
> >  tcpoptstrip_mangle_packet(struct sk_buff *skb,
> > -			  const struct xt_tcpoptstrip_target_info *info,
> > +			  const struct xt_action_param *par,
> >  			  unsigned int tcphoff, unsigned int minlen)
> >  {
> > +	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
> >  	unsigned int optl, i, j;
> >  	struct tcphdr *tcph;
> >  	u_int16_t n, o;
> >  	u_int8_t *opt;
> > +	int len;
> > +
> [..]
> > +	len = skb->len - tcphoff;
> > +	if (len < sizeof(struct tcphdr))
> 
> I think this needs a cast 'if (len < (int) sizeof( ...?

I'm not hitting any compilation warning.

> > @@ -51,7 +67,7 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
> >  	for (i = sizeof(struct tcphdr); i < tcp_hdrlen(skb); i += optl) {
> >  		optl = optlen(opt, i);
> >  
> > -		if (i + optl > tcp_hdrlen(skb))
> > +		if (i + optl > len)
> >  			break;
> 
> I don't understand this change.  This should stop parsing if the
> option length points outside of the tcp option size.
> 
> But doesn't len include the size of the actual payload?

We already validated a bit above that there's room for the TCP
options in the packet.

        /* Truncated TCP options, skip */
        if ((tcp_hdr(skb)->doff - 5) * 4 > len - sizeof(struct tcphdr))
                return NF_DROP;

So after that point we can trust the tcph->doff field.

Therefore, you're right, I'll remove that change. Thanks.
