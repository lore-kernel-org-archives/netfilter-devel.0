Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A74B3C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 21:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhK3VuP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 16:50:15 -0500
Received: from mail.netfilter.org ([217.70.188.207]:51780 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344801AbhK3Vsv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 16:48:51 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A25E2606B0;
        Tue, 30 Nov 2021 22:43:14 +0100 (CET)
Date:   Tue, 30 Nov 2021 22:45:18 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/8] mptcp subtype option match support
Message-ID: <Yaabbty7g8XyeMs/@salvia>
References: <20211119152847.18118-1-fw@strlen.de>
 <YZzpy9bk4AFahSVI@salvia>
 <20211123133742.GN6326@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211123133742.GN6326@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 23, 2021 at 02:37:42PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Nov 19, 2021 at 04:28:39PM +0100, Florian Westphal wrote:
> > > Because the subtype is only 4 bits in size the exthdr
> > > delinearization needs a fixup to remove the binop added by the
> > > evaluation step.
> > 
> > By the bitwise operation to take the 4 bits you can infer this refers to
> > mptcp, but it might be good to store in the rule userdata area that this
> > expression refers to mptcp as a suggestion to userspace when
> > delinearizing the rule.
> 
> Why?  Userspace has all info: its a tcp option, we have the tcp option
> number (mptcp) and a 4 bit field which matches the template field.
> 
> There is no guesswork here.

OK, thanks for explaining.

> Without this patch, we're asked to find a matching 1-byte field
> (which does not exist).
> 
> Whats different vs. payload expressions here to require annotations?
> 
> > > One remaining usablility problem is the lack of mnemonics for the
> > > subtype, i.e. something like:
> > > 
> > > static const struct symbol_table mptcp_subtype_tbl = {
> > >        .base           = BASE_DECIMAL,
> > >        .symbols        = {
> > >                SYMBOL("mp-capable",    0),
> > >                SYMBOL("mp-join",       1),
> > >                SYMBOL("dss",           2),
> > >                SYMBOL("add-addr",      3),
> > >                SYMBOL("remove-addr",   4),
> > >                SYMBOL("mp-prio",       5),
> > >                SYMBOL("mp-fail",       6),
> > >                SYMBOL("mp-fastclose",  7),
> > >                SYMBOL("mp-tcprst",     8),
> > >                SYMBOL_LIST_END
> > >        },
> > > 
> > > ... but this would need addition of yet another data type.
> > >
> > > Use of implicit/context-dependent symbol table would
> > > be preferrable, I will look into this next.
> > 
> > Could you develop your idea?
> 
> No idea, I have not thought about it at all.  I do not want
> to add a new data type for this.
> 
> One way is to just extend the scanner with even more keywords.
> I tought I could annotate the eval context with 'saw mptcp'
> and then use that when trying to resolve the symbol expressions.
> 
> No idea if that works and no idea how much hassle that is.

You can probably use a string in the parser for these types, then
invoke the symbol_table lookup from the parser to fetch the value?
