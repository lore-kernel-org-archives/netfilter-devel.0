From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] conntrack: fix nfct_clone with certain attribute data
 types
Date: Tue, 27 Nov 2012 15:19:24 +0100
Message-ID: <20121127141924.GD14156@breakpoint.cc>
References: <1353361195-2345-1-git-send-email-fw@strlen.de>
 <20121127140509.GA8853@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50331 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086Ab2K0OT0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:19:26 -0500
Content-Disposition: inline
In-Reply-To: <20121127140509.GA8853@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Nov 19, 2012 at 10:39:55PM +0100, Florian Westphal wrote:
> > --- a/src/conntrack/api.c
> > +++ b/src/conntrack/api.c
> > @@ -147,7 +147,7 @@ struct nf_conntrack *nfct_clone(const struct nf_conntrack *ct)
> >  
> >  	if ((clone = nfct_new()) == NULL)
> >  		return NULL;
> > -	memcpy(clone, ct, sizeof(*ct));
> > +	nfct_copy(clone, ct, NFCT_CP_ALL);
> 
> That seems safe to me.
> 
> Still I think NFCT_CP_OVERRIDE is faster. I added that flag way after
> to improve a bit the copying time.

I missed that, thanks.

Suggestion:
I'll re-send with the above changed to
nfct_copy(clone, ct, NFCT_CP_OVERRIDE)

plus adding copy_attr_help_info(ct1, ct2)
to __copy_fast.
