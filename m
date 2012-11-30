From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Handle routing changes for the MASQUERADE target
Date: Fri, 30 Nov 2012 22:27:50 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211302222190.16257@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1211302149050.16257@blackhole.kfki.hu> <20121130211147.GD31969@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:59575 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2K3V1w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:27:52 -0500
In-Reply-To: <20121130211147.GD31969@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Fri, 30 Nov 2012, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> 
> > index bd8eea7..fc8f1b8 100644
> > --- a/include/net/netfilter/nf_nat.h
> > +++ b/include/net/netfilter/nf_nat.h
> > @@ -68,4 +68,22 @@ static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
> >  
> > +static inline bool nf_nat_oif_changed(const struct sk_buff *skb,
> > +				      unsigned int hooknum,
> [..]
> > +{
> 
> If you put the #if IS_ENABLED here, it would no longer be necessary
> in the .c files.  nf_nat_oif_changed() would always return false
> in the 'no MASQERADE' case.

Yes, you're right - and a few lines are spared again :-).
 
> > +	if (nat->masq_index && hooknum == NF_INET_POST_ROUTING &&
> > +	    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
> > +	    nat->masq_index != out->ifindex) {
> > +		/* Outgoing interface changed, destroy conntrack. */
> > +		nf_ct_kill_acct(cf, ctinfo, skb);
> > +		nf_ct_put(ct);
> 
> Hmm. Is the nf_ct_put() correct?
> nf_ct_kill invokes death_by_timeout(), which also puts ct.

nf_nat_ipv[46]_fn starts with "nf_ct_get", so that must be released. 
Technically the last nf_ct_put destroys the entry.
 
> > diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
> > index ac635a7..4ed34ab 100644
> > --- a/net/ipv4/netfilter/iptable_nat.c
> > +++ b/net/ipv4/netfilter/iptable_nat.c
> > @@ -134,6 +134,10 @@ nf_nat_ipv4_fn(unsigned int hooknum,
> >  		/* ESTABLISHED */
> >  		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
> >  			     ctinfo == IP_CT_ESTABLISHED_REPLY);
> > +#if IS_ENABLED(CONFIG_IP_NF_TARGET_MASQUERADE)
> > +		if (nf_nat_oif_changed(skb, hooknum, ct, ctinfo, nat, out))
> > +			return NF_DROP;
> > +#endif
> >  	}
> 
> I wonder if this:
> 
> 	if (nf_nat_oif_changed(skb, hooknum, ctinfo, nat, out)) {
> 		nf_ct_kill_acct(ct, ctinfo, skb);
> 		return NF_DROP;
> 	}
> 
> Would be clearer (the name 'nf_nat_oif_changed' sounds like it only
> performs a test).

OK, I'll send an updated version.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
