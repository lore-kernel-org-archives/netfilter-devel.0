From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_nat: Fix possible null dereference
Date: Mon, 13 Jul 2015 17:50:03 +0200
Message-ID: <20150713155003.GA7062@salvia>
References: <fea9df65d6768053838fb1eca1846ef7.squirrel@www.codeaurora.org>
 <20150709222456.GA4111@salvia>
 <4acf7f20a629dd133bf5924886c0c4d0.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: subashab@codeaurora.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50271 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbbGMPoY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jul 2015 11:44:24 -0400
Content-Disposition: inline
In-Reply-To: <4acf7f20a629dd133bf5924886c0c4d0.squirrel@www.codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 09, 2015 at 11:16:05PM -0000, subashab@codeaurora.org wrote:
> > This function is called from nf_nat_ipv4_fn(), see do_chain().
> >
> > And we're accepting the packet with no NAT mangling if we fail to add
> > the extension:
> >
> >         nat = nf_ct_nat_ext_add(ct);
> >         if (nat == NULL)
> >                 return NF_ACCEPT;
> >
> > Can you provide more information on what your static analysis software
> > reports? Thanks.
> >
>
> Sure, here is the report
>
> - In nf_nat_masquerade_ipv4.c line 40, 'nat' is assigned the value from
> function 'nfct_nat'
> - In nf_nat.h line 58, '__nf_ct_ext_find( (ct),  (NF_CT_EXT_NAT) )' is
> assigned the return value from function '__nf_ct_ext_find'.
> - In nf_conntrack_extend.h line 68, '__nf_ct_ext_find' explicitly returns
> a NULL value.
>
> - As a result, pointer 'nat' returned from call to function 'nfct_nat' at
> line 40 may be NULL and may be dereferenced at line 59 'nat->masq_index =
> out->ifindex;'

I see, but if you look nf_nat_ipv4_fn() then you can confirm that we
always have a nat extension in place by when the iptables NAT
targets / nft NAT expressions:

nf_nat_ipv4_fn(...)
{
        [...]

        ct = nf_ct_get(skb, &ctinfo);
        /* Can't track?  It's not due to stress, or conntrack would
         * have dropped it.  Hence it's the user's responsibilty to
         * packet filter it out, or implement conntrack/NAT for that
         * protocol. 8) --RR
         */
        if (!ct)
                return NF_ACCEPT;

        /* Don't try to NAT if this packet is not conntracked */
        if (nf_ct_is_untracked(ct))
                return NF_ACCEPT;

        nat = nf_ct_nat_ext_add(ct);
        if (nat == NULL)
                return NF_ACCEPT;

        ...

If we fail to create the nat extension, then this accepts the packet,
so no chances we can reach this NULL dereference.

I wonder if this is a false positive. Would you please have a closer
look and confirm this? Thanks.
