From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] src: allow update of net base w. meta l4proto icmpv6
Date: Wed, 22 Mar 2017 14:44:12 +0100
Message-ID: <20170322134412.GA8584@breakpoint.cc>
References: <20170321185437.22959-1-fw@strlen.de>
 <20170322130902.GA21742@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53580 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759325AbdCVNoo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 09:44:44 -0400
Content-Disposition: inline
In-Reply-To: <20170322130902.GA21742@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Mar 21, 2017 at 07:54:37PM +0100, Florian Westphal wrote:
> > nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
> > <cmdline>:1:50-60: Error: conflicting protocols specified: unknown vs. icmpv6
> > 
> > add icmpv6 to nexthdr list so base gets updated correctly.
> > 
> > Reported-by: Thomas Woerner <twoerner@redhat.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  NB: This is STILL not correct.
> >  nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
> >  gets listed as
> >   icmpv6 type nd-router-advert
> > 
> > because post processing removes the l3 dependency.
> > 
> > However, "icmpv6 type nd-router-advert" uses dependency
> > ip6 nexthdr icmpv6
> > which isn't the same as meta l4proto icmpv6.
> > 
> > I suspect nft should always generate implicit l4 dependencies
> > via meta in the ipv6 case, what do others think
> > (and not autoremove 'nexthdr' check)?
> 
> I think we should use meta l4proto, ip6 nexthdr may point to some of
> the extension headers in the packet actually.

Yes.
Alright, I'll work on this change towards l4 meta.

> > diff --git a/src/proto.c b/src/proto.c
> > index 79e9dbf2b33e..fcdfbe73c735 100644
> > --- a/src/proto.c
> > +++ b/src/proto.c
> > @@ -779,6 +779,7 @@ const struct proto_desc proto_inet_service = {
> >  		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
> >  		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
> >  		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
> > +		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
> 
> This also allows icmp6 from IPv4, right? I remember I mentioned this
> in a patch that I attached to bugzilla at some point so I didn't apply
> this.

Yes, whats the concern with that?

