From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 2/7] libnftables: Move library stuff out of main.c
Date: Fri, 20 Oct 2017 19:02:13 +0200
Message-ID: <20171020170212.GF32305@orbyte.nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-3-phil@nwl.cc>
 <20171020121202.GB4068@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53290 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752573AbdJTRCP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 13:02:15 -0400
Content-Disposition: inline
In-Reply-To: <20171020121202.GB4068@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Oct 20, 2017 at 02:12:02PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 19, 2017 at 10:18:42AM +0200, Phil Sutter wrote:
[...]
> > diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> > new file mode 100644
> > index 0000000000000..052a77bfb5371
> > --- /dev/null
> > +++ b/include/nftables/nftables.h
> 
> Is this nftables/nftables.h file what we will expose later on as
> header for this library?

Yes, exactly.

[...]
> > @@ -0,0 +1,88 @@
> > +/*
> > + * Copyright (c) 2017 Eric Leblond <eric@regit.org>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + */
> > +#ifndef LIB_NFTABLES_H
> > +#define LIB_NFTABLES_H
> > +
> > +struct parser_state;
> > +struct mnl_socket;
> > +
> > +struct nft_cache {
> > +	bool			initialized;
> > +	struct list_head	list;
> > +	uint32_t		seqnum;
> > +};
> > +
> > +#define INCLUDE_PATHS_MAX	16
> > +
> > +struct output_ctx {
> > +	unsigned int numeric;
> > +	unsigned int stateless;
> > +	unsigned int ip2name;
> > +	unsigned int handle;
> > +	unsigned int echo;
> > +	FILE *output_fp;
> > +};
> 
> I think these structure should be just like:
> 
> struct output_ctx;
> 
> as a forward declaration. So we enforce users to use getters and
> setters.

Ultimately, I want to forward-declare struct nft_ctx as a whole. Is this
fine with you (also from advanced API point of view)?

Thanks, Phil
