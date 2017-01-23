From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v3 nf-next 5/7] netfilter: add and use nf_ct_set helper
Date: Mon, 23 Jan 2017 23:57:42 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1701232356220.22517@blackhole.kfki.hu>
References: <1485174530-7678-1-git-send-email-fw@strlen.de> <1485174530-7678-6-git-send-email-fw@strlen.de> <20170123125403.GA1962@salvia> <20170123161026.GA13546@breakpoint.cc> <alpine.DEB.2.10.1701232033320.21987@blackhole.kfki.hu>
 <20170123212202.GB13546@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:51820 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751654AbdAWW5s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2017 17:57:48 -0500
In-Reply-To: <20170123212202.GB13546@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 23 Jan 2017, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > > > > --- a/net/netfilter/core.c
> > > > > +++ b/net/netfilter/core.c
> > > > > @@ -375,7 +375,7 @@ void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb)
> > > > >  {
> > > > >  	void (*attach)(struct sk_buff *, const struct sk_buff *);
> > > > >  
> > > > > -	if (skb_nfct(skb)) {
> > > > > +	if (skb->nfct) {
> > > > 
> > > > I guess this slipped through accidentally. No need to resent, I can
> > > > amend it here.
> > > 
> > > Hmm, let me review this.  I thin the skb_nfct() conversion is erroneous.
> > > (Q: If original is UNTRRACKED, should the reply packet that is being
> > >  attached be UNTRACKED or INVALID?)
> > 
> > If the packet is UNTRACKED, then how can there be a reply packet from 
> > conntrack point of view? In my opinion it's the user responsibility to 
> > handle both directions.
> 
> afaics it would happen with this:
> 
> -t raw -j UNTRACKED
> -t filter -j REJECT
> 
> REJECT target ends up calling nf_ct_attach to associate the rst/icmp
> packet with original skb->nfct.

Ohh, I see. Yes, that should then be UNTRACKED as well. Thanks for the 
clarification!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
