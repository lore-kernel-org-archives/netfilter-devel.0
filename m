Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E88D4C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 11:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiLALkx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 06:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiLALks (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 06:40:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0701D335
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 03:40:46 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p0hvn-0000CU-HT; Thu, 01 Dec 2022 12:40:44 +0100
Date:   Thu, 1 Dec 2022 12:40:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [RFC ebtables-nft] unify ether type and meta protocol decoding
Message-ID: <Y4iSu5DQmxXI5fIh@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20221130113718.85576-1-fw@strlen.de>
 <Y4ds+Pk4ZrR+NxtT@orbyte.nwl.cc>
 <20221201101603.GF17072@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201101603.GF17072@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 01, 2022 at 11:16:03AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Wed, Nov 30, 2022 at 12:37:18PM +0100, Florian Westphal wrote:
> > > Handle "ether protocol" and "meta protcol" the same.
> > > 
> > > Problem is that this breaks the test case *again*:
> > > 
> > > I: [EXECUTING]   iptables/tests/shell/testcases/ebtables/0006-flush_0
> > > --A FORWARD --among-dst fe:ed:ba:be:13:37=10.0.0.1 -j ACCEPT
> > > --A OUTPUT --among-src c0:ff:ee:90:0:0=192.168.0.1 -j DROP
> > > +-A FORWARD -p IPv4 --among-dst fe:ed:ba:be:13:37=10.0.0.1 -j ACCEPT
> > > +-A OUTPUT -p IPv4 --among-src c0:ff:ee:90:0:0=192.168.0.1 -j DROP
> > > 
> > > ... because ebtables-nft will now render meta protocol as "-p IPv4".
> > > 
> > > ebtables-legacy does not have any special handling for this.
> > > 
> > > Solving this would need more internal annotations during decode, so
> > > we can suppress/ignore "meta protocol" once a "among-type" set is
> > > encountered.
> > > 
> > > Any (other) suggestions?
> > 
> > Since ebtables among does not support IPv6, match elimination should be
> > pretty simple, no? Entirely untested:
> > 
> > diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
> > index 08c93feeba2c9..0daebfd983127 100644
> > --- a/iptables/nft-bridge.c
> > +++ b/iptables/nft-bridge.c
> > @@ -520,6 +520,10 @@ static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,
> >         if (set_elems_to_among_pairs(among_data->pairs + poff, s, cnt))
> >                 xtables_error(OTHER_PROBLEM,
> >                               "ebtables among pair parsing failed");
> > +
> > +       if (!(ctx->cs.eb.bitmask & EBT_NOPROTO) &&
> > +           ctx->cs.eb.ethproto == htons(0x0800))
> > +               ctx->cs.eb.bitmask |= EBT_NOPROTO;
> 
> But that would munge
> ebtables-nft -p ipv4 ....
> ebtables-nft ....
> 
> We don't know if "-p" was added explicitly or not.

Ah, the infamous explicit vs. implicit problem. :(

Looking at ebt_among.c in kernel, it seems packets which are neither
IPv4 nor ARP are treated as non-matching. Since ebtables-nft doesn't
support ARP with among anyway, can we assume people will not specify '-p
ipv4' when using among?

Cheers, Phil
