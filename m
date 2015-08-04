From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3] netfilter: nf_tables: add generation mask to
 set objects
Date: Tue, 4 Aug 2015 11:29:57 +0200
Message-ID: <20150804092957.GB7944@salvia>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
 <1438679128-4146-3-git-send-email-pablo@netfilter.org>
 <20150804091205.GB6033@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49273 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbbHDJYB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 05:24:01 -0400
Content-Disposition: inline
In-Reply-To: <20150804091205.GB6033@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 04, 2015 at 11:12:05AM +0200, Patrick McHardy wrote:
> On 04.08, Pablo Neira Ayuso wrote:
> > -#define NFT_SET_INACTIVE	(1 << 15)
> > +static inline bool
> > +nft_set_is_active(struct net *net, const struct nft_set *set)
> > +{
> > +	return (set->genmask & nft_genmask_cur(net)) == 0;
> > +}
> 
> Do we really want this set of basic functions for every object type? There will
> still be cases where we need to open code the checks anyway, f.i. iterators
> and callbacks.

We can have a macro thing instead at some point.
