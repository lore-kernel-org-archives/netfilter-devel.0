From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 2/2] monitor: Make JSON output respect output_fp
Date: Thu, 16 Nov 2017 14:58:21 +0100
Message-ID: <20171116135821.GK32305@orbyte.nwl.cc>
References: <20171116080629.30564-1-phil@nwl.cc>
 <20171116080629.30564-3-phil@nwl.cc>
 <20171116133824.GA5926@salvia>
 <20171116135444.GA8328@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60398 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935188AbdKPN6W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 08:58:22 -0500
Content-Disposition: inline
In-Reply-To: <20171116135444.GA8328@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 16, 2017 at 02:54:44PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 16, 2017 at 02:38:24PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Nov 16, 2017 at 09:06:29AM +0100, Phil Sutter wrote:
> > > This introduces a rather nasty macro to call nftnl_*_fprintf() only if
> > > output_fp is valid. On the other hand, it allows to pull the common
> > > parts (format argument, event conversion) into a single place.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  src/netlink.c | 38 ++++++++++++++++++--------------------
> > >  1 file changed, 18 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/src/netlink.c b/src/netlink.c
> > > index 845eeeffd7387..81b92ac1e2d7c 100644
> > > --- a/src/netlink.c
> > > +++ b/src/netlink.c
> > > @@ -40,6 +40,12 @@
> > >  #include <iface.h>
> > >  
> > >  #define nft_mon_print(monh, ...) nft_print(monh->ctx->octx, __VA_ARGS__)
> > > +#define nftnl_mon_print(monh, type, obj, event)				\
> > > +	if (monh->ctx->octx->output_fp) {				\
> > > +		nftnl_##type##_fprintf(monh->ctx->octx->output_fp,	\
> > > +				       obj, monh->format,		\
> > > +				       netlink_msg2nftnl_of(event));	\
> > > +	}
> > 
> > Wait.
> > 
> > Can't we just change nftnl_*_fprintf to do nothing if output_fp is
> > NULL.
> > 
> > That should be safe.
> 
> Or we just save all these branches by always setting output_fp to
> stdout. It should simplify things a bit.
> 
> What am I missing here?

output_fp is under application control (via nft_ctx_set_output()), and I
think it's a valid use-case for applications to call
'nft_ctx_set_output(NULL)' to disable all output. On a second thought,
this is also a bit inconsistent since nft_run_cmd_from_*() set output_fp
to stderr before printing erec, but that could be exported to
applications without much effort.

Cheers, Phil
