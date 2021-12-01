Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3BEC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 11:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239426AbhLALdr convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 06:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbhLALdf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 06:33:35 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D40BC061574
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 03:30:12 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1msNoQ-000569-Tc; Wed, 01 Dec 2021 12:30:10 +0100
Date:   Wed, 1 Dec 2021 12:30:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/8] mptcp subtype option match support
Message-ID: <20211201113010.GC2315@breakpoint.cc>
References: <20211119152847.18118-1-fw@strlen.de>
 <YZzpy9bk4AFahSVI@salvia>
 <20211123133742.GN6326@breakpoint.cc>
 <Yaabbty7g8XyeMs/@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <Yaabbty7g8XyeMs/@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Nov 23, 2021 at 02:37:42PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Fri, Nov 19, 2021 at 04:28:39PM +0100, Florian Westphal wrote:
> > > > Because the subtype is only 4 bits in size the exthdr
> > > > delinearization needs a fixup to remove the binop added by the
> > > > evaluation step.
> > > 
> > > By the bitwise operation to take the 4 bits you can infer this refers to
> > > mptcp, but it might be good to store in the rule userdata area that this
> > > expression refers to mptcp as a suggestion to userspace when
> > > delinearizing the rule.
> > 
> > Why?  Userspace has all info: its a tcp option, we have the tcp option
> > number (mptcp) and a 4 bit field which matches the template field.
> > 
> > There is no guesswork here.
> 
> OK, thanks for explaining.

I can add a commet before pushing this out.

All mptcp suboptions have this 4bit identifier at the same location,
so

'tcp option == mptcp' always allows to take those 4 bit to identify
the next subheader.

The only caveat is that some suboptions have different sizes depending
on the option length field, this will get more complicated once matching
on those is added (we will need to take moer dependencies into account).

> > > > One remaining usablility problem is the lack of mnemonics for the
> > > > subtype, i.e. something like:
> > > > 
> > > > static const struct symbol_table mptcp_subtype_tbl = {
> > > >        .base           = BASE_DECIMAL,
> > > >        .symbols        = {
> > > >                SYMBOL("mp-capable",    0),
> > > >                SYMBOL("mp-join",       1),
> > > >                SYMBOL("dss",           2),
> > > >                SYMBOL("add-addr",      3),
> > > >                SYMBOL("remove-addr",   4),
> > > >                SYMBOL("mp-prio",       5),
> > > >                SYMBOL("mp-fail",       6),
> > > >                SYMBOL("mp-fastclose",  7),
> > > >                SYMBOL("mp-tcprst",     8),
> > > >                SYMBOL_LIST_END
> > > >        },
> > > > 
> > > > ... but this would need addition of yet another data type.
> > > >
> > > > Use of implicit/context-dependent symbol table would
> > > > be preferrable, I will look into this next.
> > > 
> > > Could you develop your idea?
> > 
> > No idea, I have not thought about it at all.  I do not want
> > to add a new data type for this.
> > 
> > One way is to just extend the scanner with even more keywords.
> > I tought I could annotate the eval context with 'saw mptcp'
> > and then use that when trying to resolve the symbol expressions.
> > 
> > No idea if that works and no idea how much hassle that is.
> 
> You can probably use a string in the parser for these types, then
> invoke the symbol_table lookup from the parser to fetch the value?

Current solution I'm working on adds a phony integer type, similar
to the 'hex output' one.

Delinearization needs to do some extra steps to override the integer
again though.

I will share some draft patches soon.
