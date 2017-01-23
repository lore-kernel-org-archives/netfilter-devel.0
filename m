From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v3 nf-next 5/7] netfilter: add and use nf_ct_set helper
Date: Mon, 23 Jan 2017 20:37:12 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1701232033320.21987@blackhole.kfki.hu>
References: <1485174530-7678-1-git-send-email-fw@strlen.de> <1485174530-7678-6-git-send-email-fw@strlen.de> <20170123125403.GA1962@salvia> <20170123161026.GA13546@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:58074 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750705AbdAWTmh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2017 14:42:37 -0500
In-Reply-To: <20170123161026.GA13546@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Mon, 23 Jan 2017, Florian Westphal wrote:

> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Jan 23, 2017 at 01:28:48PM +0100, Florian Westphal wrote:
> > > diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> > > index 0c629fdf90e1..ce6adfae521a 100644
> > > --- a/net/netfilter/core.c
> > > +++ b/net/netfilter/core.c
> > > @@ -375,7 +375,7 @@ void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb)
> > >  {
> > >  	void (*attach)(struct sk_buff *, const struct sk_buff *);
> > >  
> > > -	if (skb_nfct(skb)) {
> > > +	if (skb->nfct) {
> > 
> > I guess this slipped through accidentally. No need to resent, I can
> > amend it here.
> 
> Hmm, let me review this.  I thin the skb_nfct() conversion is erroneous.
> (Q: If original is UNTRRACKED, should the reply packet that is being
>  attached be UNTRACKED or INVALID?)

If the packet is UNTRACKED, then how can there be a reply packet from 
conntrack point of view? In my opinion it's the user responsibility to 
handle both directions.

> I think its "UNTRACKED", and then this needs testing of skb->_nfct .
> 
> (at least once the untracked object gets removed).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
