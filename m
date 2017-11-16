From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/2] monitor: Make JSON output respect output_fp
Date: Thu, 16 Nov 2017 15:32:24 +0100
Message-ID: <20171116143224.GA17329@salvia>
References: <20171116080629.30564-1-phil@nwl.cc>
 <20171116080629.30564-3-phil@nwl.cc>
 <20171116133824.GA5926@salvia>
 <20171116135444.GA8328@salvia>
 <20171116135821.GK32305@orbyte.nwl.cc>
 <20171116141206.GA15344@salvia>
 <20171116141924.GM32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43152 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935377AbdKPOc3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 09:32:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8A78E2EFEAA
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 15:32:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7AD17DA863
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 15:32:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171116141924.GM32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 16, 2017 at 03:19:24PM +0100, Phil Sutter wrote:
> On Thu, Nov 16, 2017 at 03:12:06PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Nov 16, 2017 at 02:58:21PM +0100, Phil Sutter wrote:
> > > On Thu, Nov 16, 2017 at 02:54:44PM +0100, Pablo Neira Ayuso wrote:
> > > > On Thu, Nov 16, 2017 at 02:38:24PM +0100, Pablo Neira Ayuso wrote:
> > > > > On Thu, Nov 16, 2017 at 09:06:29AM +0100, Phil Sutter wrote:
> > > > > > This introduces a rather nasty macro to call nftnl_*_fprintf() only if
> > > > > > output_fp is valid. On the other hand, it allows to pull the common
> > > > > > parts (format argument, event conversion) into a single place.
> > > > > > 
> > > > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > > > ---
> > > > > >  src/netlink.c | 38 ++++++++++++++++++--------------------
> > > > > >  1 file changed, 18 insertions(+), 20 deletions(-)
> > > > > > 
> > > > > > diff --git a/src/netlink.c b/src/netlink.c
> > > > > > index 845eeeffd7387..81b92ac1e2d7c 100644
> > > > > > --- a/src/netlink.c
> > > > > > +++ b/src/netlink.c
> > > > > > @@ -40,6 +40,12 @@
> > > > > >  #include <iface.h>
> > > > > >  
> > > > > >  #define nft_mon_print(monh, ...) nft_print(monh->ctx->octx, __VA_ARGS__)
> > > > > > +#define nftnl_mon_print(monh, type, obj, event)				\
> > > > > > +	if (monh->ctx->octx->output_fp) {				\
> > > > > > +		nftnl_##type##_fprintf(monh->ctx->octx->output_fp,	\
> > > > > > +				       obj, monh->format,		\
> > > > > > +				       netlink_msg2nftnl_of(event));	\
> > > > > > +	}
> > > > > 
> > > > > Wait.
> > > > > 
> > > > > Can't we just change nftnl_*_fprintf to do nothing if output_fp is
> > > > > NULL.
> > > > > 
> > > > > That should be safe.
> > > > 
> > > > Or we just save all these branches by always setting output_fp to
> > > > stdout. It should simplify things a bit.
> > > > 
> > > > What am I missing here?
> > > 
> > > output_fp is under application control (via nft_ctx_set_output()), and I
> > > think it's a valid use-case for applications to call
> > > 'nft_ctx_set_output(NULL)' to disable all output.
> > 
> > We can set a dummy file descriptor that point to /dev/null, right?
> 
> Which we would have to acquire using 'open()', correct? What if that
> call fails?
> 
> I could think of a static FILE *devnull in nft_ctx_set_output() which is
> opened if needed, and closed if the program exits. Would that work?

Not sure how that looks like, but it removes many of the branches that
we have now in place to check if output_fp is non-null, then it will
simplify the existing code, which would be good :-).
