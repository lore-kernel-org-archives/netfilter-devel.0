Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4489FC54EE9
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Sep 2022 14:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiIVOfu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 10:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiIVOfr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 10:35:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AE8F2740
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2022 07:35:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1obNIm-0006lP-Hz; Thu, 22 Sep 2022 16:35:44 +0200
Date:   Thu, 22 Sep 2022 16:35:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft] iptables-nft: must withdraw PAYLOAD flag
 after parsing
Message-ID: <20220922143544.GA22541@breakpoint.cc>
References: <20220919201254.32253-1-fw@strlen.de>
 <20220919213109.GD3498@breakpoint.cc>
 <Yys3YhGiy7/kegkM@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yys3YhGiy7/kegkM@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Mon, Sep 19, 2022 at 11:31:09PM +0200, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > else, next payload is stacked via 'CTX_PREV_PAYLOAD'.
> > > 
> > > Example breakage:
> > > 
> > > ip saddr 1.2.3.4 meta l4proto tcp
> > > ... is dumped as
> > > -s 6.0.0.0 -p tcp
> > > 
> > > iptables-nft -s 1.2.3.4 -p tcp is dumped correctly, because
> > > the expressions are ordered like:
> > > meta l4proto tcp ip saddr 1.2.3.4
> > > 
> > > ... and 'meta l4proto' will clear the PAYLOAD flag.
> > > 
> > > Fixes: 250dce876d92 ("nft-shared: support native tcp port delinearize")
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > ---
> > >  iptables/nft-shared.c                         |  2 ++
> > >  .../ipt-restore/0018-multi-payload_0          | 27 +++++++++++++++++++
> > >  2 files changed, 29 insertions(+)
> > >  create mode 100755 iptables/tests/shell/testcases/ipt-restore/0018-multi-payload_0
> > > 
> > > diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> > > index 71e2f18dab92..66e09e8fd533 100644
> > > --- a/iptables/nft-shared.c
> > > +++ b/iptables/nft-shared.c
> > > @@ -986,6 +986,8 @@ static void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
> > >  			nft_parse_transport(ctx, e, ctx->cs);
> > >  			break;
> > >  		}
> > > +
> > > +		ctx->flags &= ~NFT_XT_CTX_PAYLOAD;
> > >  	}
> > 
> > This isn't ideal either since this breaks dissection of '1-42' ranges
> > that use two compare operands, i.e.:
> > 
> > cmp reg1 gte 1
> > cmp reg1 lte 42
> > 
> > ...as first cmp 'hides' reg1 again.
> > 
> > I'd propose to rework this context stuff:
> > no more payload/meta/whatever flags, instead 'mirror' the raw data
> > registers.
> > 
> > Other ideas/suggestions?
> 
> When do we use multiple flags? I see we need NFT_XT_CTX_BITWISE in
> addition to NFT_XT_CTX_META. Do we need e.g. NFT_XT_CTX_META and
> NFT_XT_CTX_PAYLOAD at the same time?

No, that makes no sense. I'm working on a new decoder that handles
each dreg individually.

Then, only one of meta/immediate/payload can be active per register.
bitwise can be set in addition.

I hope to have a rough RFC draft ready by tomorrw.
One big advantage is that we would no longer have to clear the flags
in the individual nft_expr -> xt_match/target dissectors.

Instead, those are always auto-cleared when a nft expressio writes
to the register.

> the LHS expression which is overwritten by each consecutive LHS
> expression and a bitfield for the "on top" stuff.

Yes, thats the same concept that I'm aiming for:

+enum nft_ctx_reg_type {
+       NFT_XT_REG_UNDEF,
+       NFT_XT_REG_PAYLOAD,
+       NFT_XT_REG_IMMEDIATE,
+       NFT_XT_REG_META,
+};
+
+struct nft_xt_ctx_reg {
+       enum nft_ctx_reg_type type:8;
+
+       union {
+               struct {
+                       uint32_t base;
+                       uint32_t offset;
+                       uint32_t len;
+               } payload;
+               struct {
+                       uint32_t data[4];
+                       uint8_t len;
+               } immediate;
+               struct {
+                       uint32_t key;
+               } meta;
+       };
+
+       struct {
+               uint32_t mask[4];
+               uint32_t xor[4];
+               bool set;
+       } bitwise;
+};
