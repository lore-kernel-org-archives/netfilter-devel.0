Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9E3C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Nov 2021 13:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbhKWNkw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 08:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbhKWNkw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 08:40:52 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661B2C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Nov 2021 05:37:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mpVzS-0007u5-Ka; Tue, 23 Nov 2021 14:37:42 +0100
Date:   Tue, 23 Nov 2021 14:37:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/8] mptcp subtype option match support
Message-ID: <20211123133742.GN6326@breakpoint.cc>
References: <20211119152847.18118-1-fw@strlen.de>
 <YZzpy9bk4AFahSVI@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZzpy9bk4AFahSVI@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Nov 19, 2021 at 04:28:39PM +0100, Florian Westphal wrote:
> > Because the subtype is only 4 bits in size the exthdr
> > delinearization needs a fixup to remove the binop added by the
> > evaluation step.
> 
> By the bitwise operation to take the 4 bits you can infer this refers to
> mptcp, but it might be good to store in the rule userdata area that this
> expression refers to mptcp as a suggestion to userspace when
> delinearizing the rule.

Why?  Userspace has all info: its a tcp option, we have the tcp option
number (mptcp) and a 4 bit field which matches the template field.

There is no guesswork here.

Without this patch, we're asked to find a matching 1-byte field
(which does not exist).

Whats different vs. payload expressions here to require annotations?

> > One remaining usablility problem is the lack of mnemonics for the
> > subtype, i.e. something like:
> > 
> > static const struct symbol_table mptcp_subtype_tbl = {
> >        .base           = BASE_DECIMAL,
> >        .symbols        = {
> >                SYMBOL("mp-capable",    0),
> >                SYMBOL("mp-join",       1),
> >                SYMBOL("dss",           2),
> >                SYMBOL("add-addr",      3),
> >                SYMBOL("remove-addr",   4),
> >                SYMBOL("mp-prio",       5),
> >                SYMBOL("mp-fail",       6),
> >                SYMBOL("mp-fastclose",  7),
> >                SYMBOL("mp-tcprst",     8),
> >                SYMBOL_LIST_END
> >        },
> > 
> > ... but this would need addition of yet another data type.
> >
> > Use of implicit/context-dependent symbol table would
> > be preferrable, I will look into this next.
> 
> Could you develop your idea?

No idea, I have not thought about it at all.  I do not want
to add a new data type for this.

One way is to just extend the scanner with even more keywords.
I tought I could annotate the eval context with 'saw mptcp'
and then use that when trying to resolve the symbol expressions.

No idea if that works and no idea how much hassle that is.

