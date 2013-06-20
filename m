From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/2] conntrack: snprintf: add connlabel format specifier
Date: Fri, 21 Jun 2013 00:31:14 +0200
Message-ID: <20130620223114.GL2124@breakpoint.cc>
References: <1371588862-3407-1-git-send-email-fw@strlen.de>
 <1371588862-3407-2-git-send-email-fw@strlen.de>
 <20130620115052.GB7070@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38634 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161092Ab3FTWbQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 18:31:16 -0400
Content-Disposition: inline
In-Reply-To: <20130620115052.GB7070@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Jun 18, 2013 at 10:54:22PM +0200, Florian Westphal wrote:
> > by default, nfct_snprintf will not resolve connlabel names, as they're
> > system specific. This adds a fmt attribute to resolve names accordingly.
> > 
> > output looks like this:
> > ... mark=0 use=1 labels=eth0-in (0),eth1-in (1)
> > or
> > <labels>
> > <label name="eth0-in" bit="0"/>
> > <label name="eth1-in" bit="1"/>
> > </labels>
> 
> I think that the bit field is meaningless, so I would just export the
> strings. I'd use:
> 
> <labels>
> <label>eth0-in</label>
> <label>eth1-in</label>
> <labels>
> 
> I'd rather use elements, attributes are not easily extensible IMO.

Okay, I'll change it accordingly.  In case translation fails i'll put
the number in there, so you'd get <label>(42)</label> if bit 42 is set
but has no mapping entry.

> > Major stupidity:
> > As names can be anything, we need to be careful, especially when
> > creating XML output. Only alphanumerical label names are printed at
> > this time.
> 
> Hm, the string is enclosed between commas, isn't that enough to avoid
> troubles?

What if connlabel.conf contains line like
0  foo<bar>&;!"

> >  a) the chosen xml representation
> >  b) wheter it makes sense to limit valid charactes in the label
> >     names this way (e.g., should we care? should be disallow that
> >     in iptables as well, etc).
> >  c) if this patch makes sense in the first place, e.g, can't use
> >      alternate mapping file for labels with nfct_snprintf
> 
> Regarding c) I think it makes sense. You can add some
> nfct_set_connlabel_file interface to set where to find it, it's a bit
> cheating but should resolve the issue.

Yuck ;-)

Lets ignore it for now, adding that would break thread-safety.
I guess one alternative would be to add

nfct_labelmap_snprintf(char *buf,
	       	       size_t sz,
		       const struct nfct_labelmap *,
		       const struct nfct_bitmask *, int flags);

When a use case presents itself.

> > +/*
> > + * Labels can have any name, there are no restrictions.
> > + * We will only print alpha numerical ones; else parsers
> > + * could choke when putinng "&>" and friends into output
> > + * (especially when using XML format).  ASCII machines only.
> > + */
> > +static bool label_is_sane(const char *label)
> > +{
> > +	for (;*label; label++) {
> > +		if (*label >= 'a' && *label <= 'z')
> > +			continue;
> > +		if (*label >= 'A' && *label <= 'Z')
> > +			continue;
> > +		if (*label >= '0' && *label <= '9')
> > +			continue;
> 
> is isalnum() instead?

I was intimidated by locale interactions of isalnum...

Cheers,
Florian
