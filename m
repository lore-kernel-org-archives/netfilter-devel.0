From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2 lnf-ct 2/2] conntrack: snprintf: add connlabel
 format specifier
Date: Tue, 25 Jun 2013 21:43:47 +0200
Message-ID: <20130625194347.GA28818@breakpoint.cc>
References: <1372022079-11719-1-git-send-email-fw@strlen.de>
 <1372022079-11719-2-git-send-email-fw@strlen.de>
 <20130625153959.GA5883@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52713 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab3FYTnu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:43:50 -0400
Content-Disposition: inline
In-Reply-To: <20130625153959.GA5883@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Jun 23, 2013 at 11:14:39PM +0200, Florian Westphal wrote:
> > By default, nfct_snprintf will not print connlabels, as they're
> > system specific and can easily generate lots of output.
> > 
> > This adds a fmt attribute to print connlabel names.
> > +static int
> > +__snprintf_clabels(char *buf, unsigned int len,
> > +		   const struct nf_conntrack *ct)
> > +{
> > +	const struct nfct_bitmask *b = nfct_get_attr(ct, ATTR_CONNLABELS);
> > +	struct nfct_labelmap *map;
> > +	int ret, size = 0, offset = 0;
> > +
> > +	if (!b)
> > +		return 0;
> > +
> > +	map = nfct_labelmap_new(NULL);
> > +	if (!map)
> > +		return 0;
> 
> This opens and parses the map file for each conntrack, it would be
> expensive.  I think it's better provide more control to the client
> regarding the load of the mapping, it's more flexible.
> 
> Consider adding:
> 
> int nfct_snprintf_connlabel(char *buf, unsigned int len,
>                             const struct nf_conntrack *ct,
>                             const struct nfct_labelmap *labelmap);

Thats what I'll do.

Thanks!
