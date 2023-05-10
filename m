Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE339C77B7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 15:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbjEJPrP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 11:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237320AbjEJPrC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 11:47:02 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91FE40F6
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2023 08:46:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pwm1o-0000EM-Rs; Wed, 10 May 2023 17:46:56 +0200
Date:   Wed, 10 May 2023 17:46:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: nf_tables: reject loads from
 uninitialized registers
Message-ID: <20230510154656.GD21949@breakpoint.cc>
References: <20230505111656.32238-1-fw@strlen.de>
 <ZFUTfE/u4q34TTDY@calendula>
 <20230505145113.GD6126@breakpoint.cc>
 <ZFUh6r8BrMefU7G6@calendula>
 <20230507112254.GA18570@breakpoint.cc>
 <ZFtOQEZmKEZ2VHPE@calendula>
 <20230510080632.GB21949@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510080632.GB21949@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Hmm, this will get messy.
> > > 
> > > I only see two alternatives:
> > > 
> > > - place the bitmask in the pernet structure.
> > > - add struct nft_expr_ctx as a container structure, which has
> > >   nft_ctx as first member and the bitmask as second member, to
> > >   be used for NEWRULE and NEWSETELEM instead of nft_ctx.
> > 
> > Can the 'level' field be moved to this nft_expr_ctx structure? This
> > field is only used from the preparation phase (not in the commit
> > phase).
> > 
> > Probably we need to rename nft_ctx to nft_trans_ctx, so it contains
> > the fields that are needed from the commit phase. Then, re-add a
> > nft_ctx again which contains nft_trans_ctx at the beginning, then the
> > register bitmap and the level field. Thus, any future fields only
> > required by preparation phase only will go in nft_ctx, and fields that
> > are specifically are set up from preparation phase and consumed from
> > commit step go in nft_trans_ctx.
> > 
> > It is a bit of churn, but it is probably good to tidy up this for
> > future extensions?
> 
> Yes, its a lot of churn, I can have a look at how intrusive this will
> be.  Problem is that we have a bunch of helpers that take
> 'struct nft_ctx *', which are fed via '&trans->ctx'.
> 
> I'd like to avoid 'union nf_ctx_any *' tricks...

I would prefer not to do this.

I would have to change ->init for expressions and objects, and ->validate
too.

I would have to change ->walk() api in sets to get a
ctx-that-has-level/reg_inited fields.

But ->walk() is used in dumps too.

Compared to before this series, size increase of ctx is 48 -> 56 bytes.
This is rounded to 64 byte slab anyway, or 96 or 128 for transaction
structs that contain more data.  So this change doesn't buy anything
now.

In case we get further fields that are only relevant at
->validate/->init time and size indeed becomes a problem I'd propose to
instead add

struct nft_ctx_scratch {
	u8 level;
	DECLARE_BITMAP(reg_inited, NFT_REG32_COUNT);

	/* more temporay foo here */
;

and a 'struct nft_ctx_scratch *' member to existing nft_ctx struct.

But an even better argument to keep things as is:

If we need to adopt a lazy implicit-register-clearing in the future,
then we'd need the 'reg_inited' member in the transaction phase, so
that when the data rule blob is generated we can make sure the blob
generator can add the required 'reg := 0' store at the start of the
chain.

The only alternative that I can investigate if you like is to
add

'struct nft_trans_ctx' and then add some kind of
'nft_trans_ctx to nft_ctx' converter function, i.e. no longer
allow to do things like:

nf_tables_flowtable_notify(&trans->ctx, ..

but require sometung like

struct nft_ctx ctx;

nft_make_ctx_from_trans(&ctx, trans->saved_ctx);
nf_tables_flowtable_notify(&ctx, ..);

Downside is that we'd have silent information loss because
the 'additional late fields' would always be 0.
