From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2] netfilter: ctnetlink: force null nat binding on insert
Date: Mon, 17 Feb 2014 11:45:11 +0100
Message-ID: <20140217104511.GB31125@breakpoint.cc>
References: <1392549343-7145-1-git-send-email-fw@strlen.de>
 <20140217103750.GA22363@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47723 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbaBQKpN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:45:13 -0500
Content-Disposition: inline
In-Reply-To: <20140217103750.GA22363@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  static int
> > +nfnetlink_attach_null_binding(struct nf_conn *ct,
> > +			      enum nf_nat_manip_type manip)
> > +{
> > +	int ret = -EAGAIN;
> > +	bool can_alloc;
> > +
> > +	/* This looks bogus, but its important.
> > +	 *
> > +	 * We cannot be sure that L3 NAT is available.
> > +	 *
> > +	 * If it is not, we will oops in nf_nat_setup_info when we try
> > +	 * to fetch the l4 nat protocol (which would be on top of the l3 one).
> > +	 *
> > +	 * Normally nf_nat_setup_info cannot be called without L3 nat
> > +	 * available, but this function is invoked from ctnetlink.
> > +	 */
> > +	rcu_read_lock();
> > +
> > +	can_alloc = !!__nf_nat_l3proto_find(nf_ct_l3num(ct));
> > +	if (can_alloc)
> > +		ret = __nf_nat_alloc_null_binding(ct, manip);
> > +
> > +	rcu_read_unlock();
> > +	return ret;
> 
> I think we should always do the module autoloading for nf-nat and
> nf-nat-ipvX modules depending on nf_ct_l3num(ct), then return EAGAIN
> to give another retry. Now, this needs to happen in any case, not only
> when calling ctnetlink_parse_nat_setup().

Not sure what you mean.  If we enter nf_nat_setup_info without ctnetlink
involvement the nf-nat protocol should already be there (else, how can
we end up in nf_nat_setup_info? NAT/MASQUERADE depends on nf-nat).

What use-case did you have in mind? (or, to put it differently, where
do you think the module probing logic should be)?

Thanks!
