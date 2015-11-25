From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 1/2] src: add dscp support
Date: Wed, 25 Nov 2015 20:45:13 +0000
Message-ID: <20151125204512.GA20093@macbook.localdomain>
References: <1448480362-12411-1-git-send-email-pablo@netfilter.org>
 <20151125200124.GH30712@macbook.localdomain>
 <20151125202201.GA11893@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:61301 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750734AbbKYUpX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 15:45:23 -0500
Content-Disposition: inline
In-Reply-To: <20151125202201.GA11893@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.11, Pablo Neira Ayuso wrote:
> On Wed, Nov 25, 2015 at 08:01:25PM +0000, Patrick McHardy wrote:
> > On 25.11, Pablo Neira Ayuso wrote:
> > >  #define TYPE_MAX		(__TYPE_MAX - 1)
> > > diff --git a/include/proto.h b/include/proto.h
> > > index a43bf98..41af0c1 100644
> > > --- a/include/proto.h
> > > +++ b/include/proto.h
> > > @@ -176,7 +176,7 @@ enum ip_hdr_fields {
> > >  	IPHDR_INVALID,
> > >  	IPHDR_VERSION,
> > >  	IPHDR_HDRLENGTH,
> > > -	IPHDR_TOS,
> > > +	IPHDR_DSCP,
> > 
> > Shouldn't we keep both? I think it should work to do that or at least not be
> > difficult to make it work.
> 
> Last time we discussed this, people arised concerns related to the
> fact that this is obsolete, and nobody should be using this these
> days.

I don't really buy into these arguments. We support lots of obsolete things,
the fact is that even though it is obsoleted, it still exists and for old
devices might even be the only thing they support.
