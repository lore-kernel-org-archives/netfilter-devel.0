From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] netfilter: nft_hash: no need for rcu in the hash set
 destroy path
Date: Tue, 2 Sep 2014 15:41:52 +0200
Message-ID: <20140902134152.GA8790@salvia>
References: <1409650721-9621-1-git-send-email-pablo@netfilter.org>
 <20140902101440.GA12450@acer.localdomain>
 <20140902103856.GA10730@salvia>
 <20140902105920.GB12450@acer.localdomain>
 <20140902122207.GA11880@salvia>
 <20140902132813.GA29330@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tgraf@suug.ch
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41756 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbaIBNlE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:41:04 -0400
Content-Disposition: inline
In-Reply-To: <20140902132813.GA29330@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 02, 2014 at 02:28:14PM +0100, Patrick McHardy wrote:
> > > Same thing applies to all other objects that don't have a unique identifier
> > > chosen by the kernel.
> >
> > All other objects are always notified in order from the commit path,
> > so they seem fine to me.
>
> You're right, this only seems to affect sets.

Yes, but only the sets that are released through
nf_tables_unbind_set().

> > > > The anonymous sets are problematic, we need to notify this from the
> > > > commit path too to ensure the right ordering. I was trying to avoid
> > > > some specific notify() interface in expr->ops but it seems we need it
> > > > for nft_lookup.c.
> > > >
> > > > Can you think of a better solution?
> > >
> > > No, unless we can come up with a way that's synchronous.
> >
> > I would really like not to go back to the two nearly consecutive
> > synchronize_rcu() calls, it's slow.  I've been thinking on replacing
> > the current check in the packet path by static keys, but I didn't
> > manage to find the way yet.
>
> Which check exactly are you referring to?

>From the nft_do_chain:

        list_for_each_entry_continue_rcu(rule, &chain->rules, list) {

                /* This rule is not active, skip. */
                if (unlikely(rule->genmask & (1 << gencursor)))
                        continue;

Plus the trick that uses the synchronize_rcu() from the commit path to
make sure all packets have left the previous generation to deactivate
the rule before we start removing them from the list.
