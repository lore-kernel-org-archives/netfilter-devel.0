From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 2/2] monitor: Make JSON output respect output_fp
Date: Thu, 16 Nov 2017 14:54:02 +0100
Message-ID: <20171116135402.GJ32305@orbyte.nwl.cc>
References: <20171116080629.30564-1-phil@nwl.cc>
 <20171116080629.30564-3-phil@nwl.cc>
 <20171116133824.GA5926@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60386 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934944AbdKPNyD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 08:54:03 -0500
Content-Disposition: inline
In-Reply-To: <20171116133824.GA5926@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 16, 2017 at 02:38:24PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 16, 2017 at 09:06:29AM +0100, Phil Sutter wrote:
> > This introduces a rather nasty macro to call nftnl_*_fprintf() only if
> > output_fp is valid. On the other hand, it allows to pull the common
> > parts (format argument, event conversion) into a single place.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/netlink.c | 38 ++++++++++++++++++--------------------
> >  1 file changed, 18 insertions(+), 20 deletions(-)
> > 
> > diff --git a/src/netlink.c b/src/netlink.c
> > index 845eeeffd7387..81b92ac1e2d7c 100644
> > --- a/src/netlink.c
> > +++ b/src/netlink.c
> > @@ -40,6 +40,12 @@
> >  #include <iface.h>
> >  
> >  #define nft_mon_print(monh, ...) nft_print(monh->ctx->octx, __VA_ARGS__)
> > +#define nftnl_mon_print(monh, type, obj, event)				\
> > +	if (monh->ctx->octx->output_fp) {				\
> > +		nftnl_##type##_fprintf(monh->ctx->octx->output_fp,	\
> > +				       obj, monh->format,		\
> > +				       netlink_msg2nftnl_of(event));	\
> > +	}
> 
> Wait.
> 
> Can't we just change nftnl_*_fprintf to do nothing if output_fp is
> NULL.
> 
> That should be safe.

Looks like you just caught me trying to avoid changing libnftnl. :D

Yet I still consider the macro valuable since it avoids the nasty
pointer deref chain.

I'll prepare a patch to libnftnl and then provide v2 of this patch with
simplified nftnl_mon_print() macro. ACK?

Thanks, Phil
