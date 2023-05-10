Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B48C77B7D
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 07:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbjEJH5p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 03:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236188AbjEJH5o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 03:57:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF1A82685
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2023 00:57:28 -0700 (PDT)
Date:   Wed, 10 May 2023 09:56:48 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: nf_tables: reject loads from
 uninitialized registers
Message-ID: <ZFtOQEZmKEZ2VHPE@calendula>
References: <20230505111656.32238-1-fw@strlen.de>
 <ZFUTfE/u4q34TTDY@calendula>
 <20230505145113.GD6126@breakpoint.cc>
 <ZFUh6r8BrMefU7G6@calendula>
 <20230507112254.GA18570@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230507112254.GA18570@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 07, 2023 at 01:22:54PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, May 05, 2023 at 04:51:13PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > On Fri, May 05, 2023 at 01:16:53PM +0200, Florian Westphal wrote:
> > > > > Keep a per-rule bitmask that tracks registers that have seen a store,
> > > > > then reject loads when the accessed registers haven't been flagged.
> > > > > 
> > > > > This changes uabi contract, because we previously allowed this.
> > > > > Neither nftables nor iptables-nft create such rules.
> > > > > 
> > > > > In case there is breakage, we could insert an 'store 0 to x'
> > > > > immediate expression into the ruleset automatically, but this
> > > > > isn't done here.
> > > > > 
> > > > > Let me know if you think the "refuse" approach is too risky.
> > > > 
> > > > Might the NFT_BREAK case defeat this approach? Sequence is:
> > > > 
> > > > 1) expression that writes on register hits NFT_BREAK (nothing is written)
> > > > 2) expression that read from register, it reads uninitialized data.
> > > >
> > > > From ruleset load step, we cannot know if the write fails, because it
> > > > is subject to NFT_BREAK.
> > > 
> > > Yes, but its irrelevant: If 1) issues NFT_BREAK, 2) won't execute.
> > 
> > And register tracking is done per rule, given context is per rule too,
> > good.
> > 
> > I wonder if it is worth to move the bitmask away from nft_ctx, given
> > this structure is stored in the struct nft_trans, hence increasing the
> > size of this object which is not required at a later state, maybe
> > there is a need for a new container structure that store data useful
> > for the initial preparation step of the commit protocol.
> 
> Hmm, this will get messy.
> 
> I only see two alternatives:
> 
> - place the bitmask in the pernet structure.
> - add struct nft_expr_ctx as a container structure, which has
>   nft_ctx as first member and the bitmask as second member, to
>   be used for NEWRULE and NEWSETELEM instead of nft_ctx.

Can the 'level' field be moved to this nft_expr_ctx structure? This
field is only used from the preparation phase (not in the commit
phase).

Probably we need to rename nft_ctx to nft_trans_ctx, so it contains
the fields that are needed from the commit phase. Then, re-add a
nft_ctx again which contains nft_trans_ctx at the beginning, then the
register bitmap and the level field. Thus, any future fields only
required by preparation phase only will go in nft_ctx, and fields that
are specifically are set up from preparation phase and consumed from
commit step go in nft_trans_ctx.

It is a bit of churn, but it is probably good to tidy up this for
future extensions?

Let me know, thanks.
