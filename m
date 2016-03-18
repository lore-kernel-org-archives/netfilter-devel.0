From: Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH nf] netfilter: x_tables: deal with bogus nextoffset values
Date: Fri, 18 Mar 2016 14:03:40 +0100
Message-ID: <20160318130340.GA9843@unicorn.suse.cz>
References: <1457571362-25441-1-git-send-email-fw@strlen.de>
 <20160310141231.GA13006@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	hawkes@google.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306AbcCRNDm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 09:03:42 -0400
Content-Disposition: inline
In-Reply-To: <20160310141231.GA13006@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 03:12:31PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 10, 2016 at 01:56:02AM +0100, Florian Westphal wrote:
> > Ben Hawkes says:
> > 
> >  In the mark_source_chains function (net/ipv4/netfilter/ip_tables.c) it
> >  is possible for a user-supplied ipt_entry structure to have a large
> >  next_offset field. This field is not bounds checked prior to writing a
> >  counter value at the supplied offset.
> > 
> > Problem is that xt_entry_foreach() macro stops iterating once e->next_offset
> > is out of bounds, assuming this is the last entry.
> > 
> > With malformed data thats not necessarily the case so we can
> > write outside of allocated area later as we might not have walked the
> > entire blob.
> > 
> > Fix this by simplifying mark_source_chains -- it already has to check
> > if nextoff is in range to catch invalid jumps, so just do the check
> > when we move to a next entry as well.
...
> I'll place this in nf-next together with remaining pending fixes, it
> seems we'll have 4.5 just after this -rc7 so I don't think we'll get
> there in time for this.

Hi,

I can't see this patch neither in nf nor in nf-next even if the other
one (netfilter: x_tables: check for size overflow) is in nf-next. Was it
omitted on purpose or is it a mistake?

                                                          Michal Kubecek
