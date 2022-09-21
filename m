Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECE7C6FA82
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Sep 2022 16:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiIUQ2q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 12:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiIUQ22 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 12:28:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67957B3B35
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Sep 2022 09:10:25 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ob2Ic-0007Md-VN; Wed, 21 Sep 2022 18:10:10 +0200
Date:   Wed, 21 Sep 2022 18:10:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft] iptables-nft: must withdraw PAYLOAD flag
 after parsing
Message-ID: <Yys3YhGiy7/kegkM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20220919201254.32253-1-fw@strlen.de>
 <20220919213109.GD3498@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919213109.GD3498@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 19, 2022 at 11:31:09PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > else, next payload is stacked via 'CTX_PREV_PAYLOAD'.
> > 
> > Example breakage:
> > 
> > ip saddr 1.2.3.4 meta l4proto tcp
> > ... is dumped as
> > -s 6.0.0.0 -p tcp
> > 
> > iptables-nft -s 1.2.3.4 -p tcp is dumped correctly, because
> > the expressions are ordered like:
> > meta l4proto tcp ip saddr 1.2.3.4
> > 
> > ... and 'meta l4proto' will clear the PAYLOAD flag.
> > 
> > Fixes: 250dce876d92 ("nft-shared: support native tcp port delinearize")
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  iptables/nft-shared.c                         |  2 ++
> >  .../ipt-restore/0018-multi-payload_0          | 27 +++++++++++++++++++
> >  2 files changed, 29 insertions(+)
> >  create mode 100755 iptables/tests/shell/testcases/ipt-restore/0018-multi-payload_0
> > 
> > diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> > index 71e2f18dab92..66e09e8fd533 100644
> > --- a/iptables/nft-shared.c
> > +++ b/iptables/nft-shared.c
> > @@ -986,6 +986,8 @@ static void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
> >  			nft_parse_transport(ctx, e, ctx->cs);
> >  			break;
> >  		}
> > +
> > +		ctx->flags &= ~NFT_XT_CTX_PAYLOAD;
> >  	}
> 
> This isn't ideal either since this breaks dissection of '1-42' ranges
> that use two compare operands, i.e.:
> 
> cmp reg1 gte 1
> cmp reg1 lte 42
> 
> ...as first cmp 'hides' reg1 again.
> 
> I'd propose to rework this context stuff:
> no more payload/meta/whatever flags, instead 'mirror' the raw data
> registers.
> 
> Other ideas/suggestions?

When do we use multiple flags? I see we need NFT_XT_CTX_BITWISE in
addition to NFT_XT_CTX_META. Do we need e.g. NFT_XT_CTX_META and
NFT_XT_CTX_PAYLOAD at the same time? My idea would be to use an enum for
the LHS expression which is overwritten by each consecutive LHS
expression and a bitfield for the "on top" stuff.

Cheers, Phil
