From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: allow update of net base w. meta l4proto icmpv6
Date: Fri, 24 Mar 2017 12:50:21 +0100
Message-ID: <20170324115021.GA2515@salvia>
References: <20170321185437.22959-1-fw@strlen.de>
 <20170322130902.GA21742@salvia>
 <20170322134412.GA8584@breakpoint.cc>
 <20170322152909.GA22809@salvia>
 <20170322153204.GA22898@salvia>
 <20170322154400.GB8584@breakpoint.cc>
 <20170322160726.GA23136@salvia>
 <20170322192252.GC8584@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58302 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935802AbdCXLu1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 07:50:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8A874EBAF4
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 12:50:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 772C6DA804
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 12:50:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6ED9EDA879
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 12:50:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170322192252.GC8584@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 22, 2017 at 08:22:52PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Mar 22, 2017 at 04:44:00PM +0100, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Hm, I wonder why you need this new line in proto_inet_service:
> > > > 
> > > > +         PROTO_LINK(IPPROTO_ICMPV6,      &proto_icmp6),
> > > 
> > > meta_expr_pctx_update calls proto_find_upper(), without this
> > > that returns NULL and proto base is set to 'unknown'.
> > 
> > Oh right.
> > 
> > Will this still happen if you tell nft to generate the dependency
> > using meta l4proto instead of ip6 nexthdr?
> 
> Yes, tried with
> 
> src/nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
>  <cmdline>:1:41-51: Error: conflicting protocols specified: unknown vs.  icmpv6
> 
> and this patch:
> 
> diff --git a/src/proto.c b/src/proto.c
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -707,7 +707,7 @@ const struct proto_desc proto_icmp6 = {
>  const struct proto_desc proto_ip6 = {
>         .name           = "ip6",
>         .base           = PROTO_BASE_NETWORK_HDR,
> -       .protocol_key   = IP6HDR_NEXTHDR,
> +       .protocol_key   = IP6HDR_INVALID,

In order spots, we just remove this line given IP6HDR_INVALID is zero.
I think this may be confusing to newcomers reading the code.

>         .protocols      = {
>                 PROTO_LINK(IPPROTO_ESP,         &proto_esp),
>                 PROTO_LINK(IPPROTO_AH,          &proto_ah),
> @@ -720,6 +720,7 @@ const struct proto_desc proto_ip6 = {
>                 PROTO_LINK(IPPROTO_ICMPV6,      &proto_icmp6),
>         },
>         .templates      = {
> +               [IP6HDR_INVALID]        = PROTO_META_TEMPLATE("nfproto", &inet_protocol_type, NFT_META_L4PROTO, 8),

We can just use NFT_META_L4PROTO all the time, so we use it from IPv4
too, right?

And use:

        [0]     = PROTO_META_TEMPLATE(...)

for consistency.
