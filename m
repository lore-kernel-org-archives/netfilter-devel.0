From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 2/5] ipset: add "inner" flag implementation
Date: Sat, 29 Jun 2013 13:07:21 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1306291247010.25929@blackhole.kfki.hu>
References: <cover.1371423775.git.mr.dash.four@googlemail.com> <51BE49D4.1010901@googlemail.com> <alpine.DEB.2.00.1306262149560.17378@blackhole.kfki.hu> <51CCBE8A.3080305@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:36038 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab3F2LHX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 07:07:23 -0400
In-Reply-To: <51CCBE8A.3080305@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 27 Jun 2013, Dash Four wrote:

> Jozsef Kadlecsik wrote:
> > Get rid of the compatibility functions. Or keep the original function names
> > with the extended arguments: there's no stable API.
> >   
> As you've probably guessed, I kept the old functions and their parameters in
> order to preserve the existing interface API, since any changes I make to
> these will break existing code using them. If there is no objection and there
> is no such requirement, I'll get rid of them in the next release of the
> patches - just let me know.

Yes, there's no such requirement and remove the backward compatibility 
part.
 
> > >  #define _IP_SET_MODULE_DESC(a, b, c)		\
> > >  	MODULE_DESCRIPTION(a " type of IP sets, revisions " b "-" c)
> > > @@ -361,6 +365,25 @@ static inline int nla_put_ipaddr6(struct sk_buff
> > > *skb,
> > > int type,
> > >  }
> > > 
> > >  /* Get address from skbuff */
> > > +static inline bool
> > > +ipv4addrptr(const struct sk_buff *skb, bool inner, bool src, __be32
> > > *addr)
> > > +{
> > > +	struct iphdr *ih = ip_hdr(skb);
> > > +	unsigned int protooff = ip_hdrlen(skb);
> > > +
> > > +	if (ih == NULL ||
> > >     
> > 
> > Why do you have to check the IP header?
> >   
> Simply playing it safe. I am referencing it later on in the code and if that
> pointer is NULL for whatever reason, it will trigger a null-pointer
> dereference, hence the check above.

The return value of ip[6]_hdr was never checked in ipset code yet, because 
it doesn't return NULL at the point where these code parts are called. 
It's an unnecessary checking.
 
> > > +	    (inner &&
> > > +	     (ih->protocol != IPPROTO_ICMP ||
> > > +	      !ip_set_get_icmpv4_inner_hdr(skb, &protooff, &ih))))
> > > +			goto err;
> > > 
> 
> >  Also, there's no need for the goto here: there's no other error path.
> >   
> I disagree. By having "return false" (or "return 0", "return -1" and so on)
> instead of "goto err" it is not immediately apparent to someone who
> studies/reviews/uses the code that this is an error condition/path. I have
> been in that situation many times when I have to go back and look at a
> particular function call to see what "return false" or "return 0" actually
> means.
> 
> By including "goto err" instead of multiple "return false" statement, that
> makes it instantly obvious what the purpose of that statement is without
> having to look elsewhere.

I see the point, to self-document the code, with the price of more lines. 
It's a little bit overdoing in my opinion: pretty apparent which is the 
error path and which is not. But this is highly a personal taste, I won't 
press it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
