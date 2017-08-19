From: Eric Leblond <eric@regit.org>
Subject: Re: [nft PATH 01/16] libnftables: introduce library
Date: Sat, 19 Aug 2017 10:43:12 +0200
Message-ID: <1503132192.31564.17.camel@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
         <20170816204310.3371-2-eric@regit.org>
         <20170817085750.GS16375@orbyte.nwl.cc> <1502989742.31564.5.camel@regit.org>
         <20170817171350.GD10864@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:57702 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751626AbdHSInT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 04:43:19 -0400
In-Reply-To: <20170817171350.GD10864@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 2017-08-17 at 19:13 +0200, Phil Sutter wrote:
> Hey,
> 
> On Thu, Aug 17, 2017 at 07:09:02PM +0200, Eric Leblond wrote:
> > On Thu, 2017-08-17 at 10:57 +0200, Phil Sutter wrote:
> > > On Wed, Aug 16, 2017 at 10:42:55PM +0200, Eric Leblond wrote:
> 
> [...]
> > > > +void nft_global_init(void)
> > > > +{
> > > > +	mark_table_init();
> > > > +	realm_table_rt_init();
> > > > +	devgroup_table_init();
> > > > +	realm_table_meta_init();
> > > > +	ct_label_table_init();
> > > > +	gmp_init();
> > > > +#ifdef HAVE_LIBXTABLES
> > > > +	xt_init();
> > > > +#endif
> > > > +}
> > > > +
> > > > +void nft_global_deinit(void)
> > > > +{
> > > > +	ct_label_table_exit();
> > > > +	realm_table_rt_exit();
> > > > +	devgroup_table_exit();
> > > > +	realm_table_meta_exit();
> > > > +	mark_table_exit();
> > > > +}
> > > 
> > > How about calling these from nft_context_new() and
> > > nft_context_free()?
> > 
> > I want to be able to have multiple context for a single process.
> > Hence
> > I defined a global init and deinit. But maybe it does not really
> > make
> > sense and could be attached to each context or init could be done
> > at
> > first usage.
> 
> My idea was to implement simple reference counting to see whether the
> library was already initialized and whether it is safe to deinit. Of
> course this needs some serialization for thread-safety.
> 
> Or maybe the deinit can be ignored completely and nft_global_init()
> just
> has to check whether data is already initialized or not.

I have used numerous libraries providing a global init or deinit. For
now we could easily skip it with your approach or another but I prefer
we have it existing so it is available later in case of needs. 

++
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
