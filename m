From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] src: allow update of net base w. meta l4proto icmpv6
Date: Wed, 22 Mar 2017 20:22:52 +0100
Message-ID: <20170322192252.GC8584@breakpoint.cc>
References: <20170321185437.22959-1-fw@strlen.de>
 <20170322130902.GA21742@salvia>
 <20170322134412.GA8584@breakpoint.cc>
 <20170322152909.GA22809@salvia>
 <20170322153204.GA22898@salvia>
 <20170322154400.GB8584@breakpoint.cc>
 <20170322160726.GA23136@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56720 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935407AbdCVTYN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 15:24:13 -0400
Content-Disposition: inline
In-Reply-To: <20170322160726.GA23136@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Mar 22, 2017 at 04:44:00PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Hm, I wonder why you need this new line in proto_inet_service:
> > > 
> > > +         PROTO_LINK(IPPROTO_ICMPV6,      &proto_icmp6),
> > 
> > meta_expr_pctx_update calls proto_find_upper(), without this
> > that returns NULL and proto base is set to 'unknown'.
> 
> Oh right.
> 
> Will this still happen if you tell nft to generate the dependency
> using meta l4proto instead of ip6 nexthdr?

Yes, tried with

src/nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
 <cmdline>:1:41-51: Error: conflicting protocols specified: unknown vs.  icmpv6

and this patch:

diff --git a/src/proto.c b/src/proto.c
--- a/src/proto.c
+++ b/src/proto.c
@@ -707,7 +707,7 @@ const struct proto_desc proto_icmp6 = {
 const struct proto_desc proto_ip6 = {
        .name           = "ip6",
        .base           = PROTO_BASE_NETWORK_HDR,
-       .protocol_key   = IP6HDR_NEXTHDR,
+       .protocol_key   = IP6HDR_INVALID,
        .protocols      = {
                PROTO_LINK(IPPROTO_ESP,         &proto_esp),
                PROTO_LINK(IPPROTO_AH,          &proto_ah),
@@ -720,6 +720,7 @@ const struct proto_desc proto_ip6 = {
                PROTO_LINK(IPPROTO_ICMPV6,      &proto_icmp6),
        },
        .templates      = {
+               [IP6HDR_INVALID]        = PROTO_META_TEMPLATE("nfproto", &inet_protocol_type, NFT_META_L4PROTO, 8),
                [IP6HDR_VERSION]        = HDR_BITFIELD("version", &integer_type, 0, 4),
                [IP6HDR_DSCP]           = HDR_BITFIELD("dscp", &dscp_type, 4, 6),
                [IP6HDR_ECN]            = HDR_BITFIELD("ecn", &ecn_type, 10, 2),


