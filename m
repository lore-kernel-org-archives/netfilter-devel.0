From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond
 packet boundary
Date: Wed, 15 May 2013 17:10:11 +0200
Message-ID: <20130515151011.GA7369@localhost>
References: <1368619552-30635-1-git-send-email-pablo@netfilter.org>
 <20130515123336.GE18095@breakpoint.cc>
 <20130515135935.GA1605@localhost>
 <20130515144824.GG18095@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35249 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab3EOPKT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 11:10:19 -0400
Content-Disposition: inline
In-Reply-To: <20130515144824.GG18095@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 15, 2013 at 04:48:24PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, May 15, 2013 at 02:33:36PM +0200, Florian Westphal wrote:
> > > > +	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
> > > >  	unsigned int optl, i, j;
> > > >  	struct tcphdr *tcph;
> > > >  	u_int16_t n, o;
> > > >  	u_int8_t *opt;
> > > > +	int len;
> > > > +
> > > [..]
> > > > +	len = skb->len - tcphoff;
> > > > +	if (len < sizeof(struct tcphdr))
> > > 
> > > I think this needs a cast 'if (len < (int) sizeof( ...?
> > 
> > I'm not hitting any compilation warning.
> 
> len is signed, thats why i asked, and, afair recall sizeof
> is unsigned and thus len is treated as unsigned.

Right. I'll fix it, thanks.
