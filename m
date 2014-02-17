From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2] netfilter: ctnetlink: force null nat binding on insert
Date: Mon, 17 Feb 2014 11:58:56 +0100
Message-ID: <20140217105856.GA16361@localhost>
References: <1392549343-7145-1-git-send-email-fw@strlen.de>
 <20140217103750.GA22363@localhost>
 <20140217104511.GB31125@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37949 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaBQK7D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:59:03 -0500
Content-Disposition: inline
In-Reply-To: <20140217104511.GB31125@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 17, 2014 at 11:45:11AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >  static int
> > > +nfnetlink_attach_null_binding(struct nf_conn *ct,
> > > +			      enum nf_nat_manip_type manip)
> > > +{
> > > +	int ret = -EAGAIN;
> > > +	bool can_alloc;
> > > +
> > > +	/* This looks bogus, but its important.
> > > +	 *
> > > +	 * We cannot be sure that L3 NAT is available.
> > > +	 *
> > > +	 * If it is not, we will oops in nf_nat_setup_info when we try
> > > +	 * to fetch the l4 nat protocol (which would be on top of the l3 one).
> > > +	 *
> > > +	 * Normally nf_nat_setup_info cannot be called without L3 nat
> > > +	 * available, but this function is invoked from ctnetlink.
> > > +	 */
> > > +	rcu_read_lock();
> > > +
> > > +	can_alloc = !!__nf_nat_l3proto_find(nf_ct_l3num(ct));
> > > +	if (can_alloc)
> > > +		ret = __nf_nat_alloc_null_binding(ct, manip);
> > > +
> > > +	rcu_read_unlock();
> > > +	return ret;
> >
> > I think we should always do the module autoloading for nf-nat and
> > nf-nat-ipvX modules depending on nf_ct_l3num(ct), then return EAGAIN
> > to give another retry. Now, this needs to happen in any case, not only
> > when calling ctnetlink_parse_nat_setup().
>
> Not sure what you mean.  If we enter nf_nat_setup_info without ctnetlink
> involvement the nf-nat protocol should already be there (else, how can
> we end up in nf_nat_setup_info? NAT/MASQUERADE depends on nf-nat).
>
> What use-case did you have in mind? (or, to put it differently, where
> do you think the module probing logic should be)?

If __nf_nat_l3proto_find returns NULL before trying to attach the null
binding, I think you should call the routine to autoload the modules
before returning EAGAIN.

        proto = __nf_nat_l3proto_find(nf_ct_l3num(ct));
        if (proto == NULL) {
                ... release locks
                request_module(...);
                ... acquire locks again
                return -EAGAIN;
        }
