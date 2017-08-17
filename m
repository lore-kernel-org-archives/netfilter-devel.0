From: Eric Leblond <eric@regit.org>
Subject: Re: [nft PATH 01/16] libnftables: introduce library
Date: Thu, 17 Aug 2017 19:09:02 +0200
Message-ID: <1502989742.31564.5.camel@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
         <20170816204310.3371-2-eric@regit.org>
         <20170817085750.GS16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:54910 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752031AbdHQRJK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 13:09:10 -0400
In-Reply-To: <20170817085750.GS16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 2017-08-17 at 10:57 +0200, Phil Sutter wrote:
> On Wed, Aug 16, 2017 at 10:42:55PM +0200, Eric Leblond wrote:
> [...]
> > diff --git a/src/libnftables.c b/src/libnftables.c
> > new file mode 100644
> > index 0000000..215179a
> > --- /dev/null
> > +++ b/src/libnftables.c
> > @@ -0,0 +1,53 @@
> > +/*
> > + * Copyright (c) 2017 Eric Leblond <eric@regit.org>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > modify
> > + * it under the terms of the GNU General Public License version 2
> > as
> > + * published by the Free Software Foundation.
> > + *
> > + */
> > +
> > +#include <nftables/nftables.h>
> > +#include <string.h>
> > +#include <errno.h>
> > +#include <nftables.h>
> > +#include <parser.h>
> > +#include <iface.h>
> > +#include <netlink.h>
> > +#include <erec.h>
> > +#include <libmnl/libmnl.h>
> > +#include <mnl.h>
> > +
> > +#include <unistd.h>
> > +#include <fcntl.h>
> > +
> > +
> > +unsigned int max_errors = 10;
> > +unsigned int numeric_output;
> > +unsigned int ip2name_output;
> > +unsigned int handle_output;
> > +#ifdef DEBUG
> > +unsigned int debug_level;
> > +#endif
> 
> I guess these global variables have to die. I tried static linking
> (for
> quick testing without installing) which didn't work because
> max_errors
> is then redefined here. (There is a stale one in main.c which you
> probably just forgot to remove.)
> 
> Maybe max_errors could become part of struct nft_ctx? Alternatively I
> would make it static and add a getter to be used from parser_bison.y.

I'm gonna remove the all but max_errors and see how I could addmax_errors somewhere. 

> The remaining ones apart from debug_level are leftovers, they live in
> struct output_ctx now.

Indeed. Good catch.

> I am not sure where debug_level really belongs to. One one hand, it
> has
> something to do with printing, so struct output_ctx. On the other,
> nft_ctx would have to be made reachable from all places where debug
> output happens.
> 
> Maybe the whole debugging infrastructure (i.e. debug data dumpers and
> printers) should be exported to the application?
> 
> > +
> > +void nft_global_init(void)
> > +{
> > +	mark_table_init();
> > +	realm_table_rt_init();
> > +	devgroup_table_init();
> > +	realm_table_meta_init();
> > +	ct_label_table_init();
> > +	gmp_init();
> > +#ifdef HAVE_LIBXTABLES
> > +	xt_init();
> > +#endif
> > +}
> > +
> > +void nft_global_deinit(void)
> > +{
> > +	ct_label_table_exit();
> > +	realm_table_rt_exit();
> > +	devgroup_table_exit();
> > +	realm_table_meta_exit();
> > +	mark_table_exit();
> > +}
> 
> How about calling these from nft_context_new() and
> nft_context_free()?

I want to be able to have multiple context for a single process. Hence
I defined a global init and deinit. But maybe it does not really make
sense and could be attached to each context or init could be done at
first usage.

++
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
