From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATH 01/16] libnftables: introduce library
Date: Thu, 17 Aug 2017 19:13:50 +0200
Message-ID: <20170817171350.GD10864@orbyte.nwl.cc>
References: <20170816204310.3371-1-eric@regit.org>
 <20170816204310.3371-2-eric@regit.org>
 <20170817085750.GS16375@orbyte.nwl.cc>
 <1502989742.31564.5.camel@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44835 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753285AbdHQRNw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 13:13:52 -0400
Content-Disposition: inline
In-Reply-To: <1502989742.31564.5.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hey,

On Thu, Aug 17, 2017 at 07:09:02PM +0200, Eric Leblond wrote:
> On Thu, 2017-08-17 at 10:57 +0200, Phil Sutter wrote:
> > On Wed, Aug 16, 2017 at 10:42:55PM +0200, Eric Leblond wrote:
[...]
> > > +void nft_global_init(void)
> > > +{
> > > +	mark_table_init();
> > > +	realm_table_rt_init();
> > > +	devgroup_table_init();
> > > +	realm_table_meta_init();
> > > +	ct_label_table_init();
> > > +	gmp_init();
> > > +#ifdef HAVE_LIBXTABLES
> > > +	xt_init();
> > > +#endif
> > > +}
> > > +
> > > +void nft_global_deinit(void)
> > > +{
> > > +	ct_label_table_exit();
> > > +	realm_table_rt_exit();
> > > +	devgroup_table_exit();
> > > +	realm_table_meta_exit();
> > > +	mark_table_exit();
> > > +}
> > 
> > How about calling these from nft_context_new() and
> > nft_context_free()?
> 
> I want to be able to have multiple context for a single process. Hence
> I defined a global init and deinit. But maybe it does not really make
> sense and could be attached to each context or init could be done at
> first usage.

My idea was to implement simple reference counting to see whether the
library was already initialized and whether it is safe to deinit. Of
course this needs some serialization for thread-safety.

Or maybe the deinit can be ignored completely and nft_global_init() just
has to check whether data is already initialized or not.

Cheers, Phil
