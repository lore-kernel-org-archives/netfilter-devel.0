From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: allow update of net base w. meta l4proto icmpv6
Date: Wed, 22 Mar 2017 16:32:04 +0100
Message-ID: <20170322153204.GA22898@salvia>
References: <20170321185437.22959-1-fw@strlen.de>
 <20170322130902.GA21742@salvia>
 <20170322134412.GA8584@breakpoint.cc>
 <20170322152909.GA22809@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36176 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934968AbdCVPin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 11:38:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 840DC170D38
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 16:32:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73EE9DA86B
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 16:32:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E05EFDA86E
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 16:32:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170322152909.GA22809@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 22, 2017 at 04:29:09PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 22, 2017 at 02:44:12PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Tue, Mar 21, 2017 at 07:54:37PM +0100, Florian Westphal wrote:
> > > > nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
> > > > <cmdline>:1:50-60: Error: conflicting protocols specified: unknown vs. icmpv6
> > > > 
> > > > add icmpv6 to nexthdr list so base gets updated correctly.
> > > > 
> > > > Reported-by: Thomas Woerner <twoerner@redhat.com>
> > > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > > ---
> > > >  NB: This is STILL not correct.
> > > >  nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
> > > >  gets listed as
> > > >   icmpv6 type nd-router-advert
> > > > 
> > > > because post processing removes the l3 dependency.
> > > > 
> > > > However, "icmpv6 type nd-router-advert" uses dependency
> > > > ip6 nexthdr icmpv6
> > > > which isn't the same as meta l4proto icmpv6.
> > > > 
> > > > I suspect nft should always generate implicit l4 dependencies
> > > > via meta in the ipv6 case, what do others think
> > > > (and not autoremove 'nexthdr' check)?
> > > 
> > > I think we should use meta l4proto, ip6 nexthdr may point to some of
> > > the extension headers in the packet actually.
> > 
> > Yes.
> > Alright, I'll work on this change towards l4 meta.
> > 
> > > > diff --git a/src/proto.c b/src/proto.c
> > > > index 79e9dbf2b33e..fcdfbe73c735 100644
> > > > --- a/src/proto.c
> > > > +++ b/src/proto.c
> > > > @@ -779,6 +779,7 @@ const struct proto_desc proto_inet_service = {
> > > >  		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
> > > >  		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
> > > >  		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
> > > > +		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
> > > 
> > > This also allows icmp6 from IPv4, right? I remember I mentioned this
> > > in a patch that I attached to bugzilla at some point so I didn't apply
> > > this.
> > 
> > Yes, whats the concern with that?
> 
> Not a problem these days from inet/netdev chains since:
> 
> commit 0011985554e269e1cc8f8e5b41eb9dcd795ebe8c
> Author: Arturo Borrero Gonzalez <arturo@debian.org>
> Date:   Wed Jan 25 12:51:08 2017 +0100
> 
>     payload: explicit network ctx assignment for icmp/icmp6 in special families
> 
> Now we generate the right bytecode to restrict this to IPv6:
> 
> # nft --debug=netlink add rule inet f i icmpv6 type nd-router-advert
> inet f i 
>   [ meta load nfproto => reg 1 ]
>   [ cmp eq reg 1 0x0000000a ]
>   [ payload load 1b @ network header + 6 => reg 1 ]
>   [ cmp eq reg 1 0x0000003a ]
>   [ payload load 1b @ transport header + 0 => reg 1 ]
>   [ cmp eq reg 1 0x00000086 ]
> 
> So forget my concern, just remove this mental "postit" note, it's stale ;)

Hm, I wonder why you need this new line in proto_inet_service:

+         PROTO_LINK(IPPROTO_ICMPV6,      &proto_icmp6),
