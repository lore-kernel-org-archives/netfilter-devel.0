Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C12C77B7C
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 May 2023 11:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjEGLW7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 May 2023 07:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjEGLW7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 May 2023 07:22:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362CD12EAC
        for <netfilter-devel@vger.kernel.org>; Sun,  7 May 2023 04:22:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pvcTe-0005Dr-1S; Sun, 07 May 2023 13:22:54 +0200
Date:   Sun, 7 May 2023 13:22:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: nf_tables: reject loads from
 uninitialized registers
Message-ID: <20230507112254.GA18570@breakpoint.cc>
References: <20230505111656.32238-1-fw@strlen.de>
 <ZFUTfE/u4q34TTDY@calendula>
 <20230505145113.GD6126@breakpoint.cc>
 <ZFUh6r8BrMefU7G6@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFUh6r8BrMefU7G6@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, May 05, 2023 at 04:51:13PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Fri, May 05, 2023 at 01:16:53PM +0200, Florian Westphal wrote:
> > > > Keep a per-rule bitmask that tracks registers that have seen a store,
> > > > then reject loads when the accessed registers haven't been flagged.
> > > > 
> > > > This changes uabi contract, because we previously allowed this.
> > > > Neither nftables nor iptables-nft create such rules.
> > > > 
> > > > In case there is breakage, we could insert an 'store 0 to x'
> > > > immediate expression into the ruleset automatically, but this
> > > > isn't done here.
> > > > 
> > > > Let me know if you think the "refuse" approach is too risky.
> > > 
> > > Might the NFT_BREAK case defeat this approach? Sequence is:
> > > 
> > > 1) expression that writes on register hits NFT_BREAK (nothing is written)
> > > 2) expression that read from register, it reads uninitialized data.
> > >
> > > From ruleset load step, we cannot know if the write fails, because it
> > > is subject to NFT_BREAK.
> > 
> > Yes, but its irrelevant: If 1) issues NFT_BREAK, 2) won't execute.
> 
> And register tracking is done per rule, given context is per rule too,
> good.
> 
> I wonder if it is worth to move the bitmask away from nft_ctx, given
> this structure is stored in the struct nft_trans, hence increasing the
> size of this object which is not required at a later state, maybe
> there is a need for a new container structure that store data useful
> for the initial preparation step of the commit protocol.

Hmm, this will get messy.

I only see two alternatives:

- place the bitmask in the pernet structure.
- add struct nft_expr_ctx as a container structure, which has
  nft_ctx as first member and the bitmask as second member, to
  be used for NEWRULE and NEWSETELEM instead of nft_ctx.

Any better idea?
