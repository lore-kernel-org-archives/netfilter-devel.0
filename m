Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A33C3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 14:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA89D20882
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 14:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732200AbfISOBr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:01:47 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47476 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732085AbfISOBr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 10:01:47 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iAx0C-0005M8-Tg; Thu, 19 Sep 2019 16:01:44 +0200
Date:   Thu, 19 Sep 2019 16:01:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Laura Garcia <nevola@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190919140144.GS6961@breakpoint.cc>
References: <20190918115325.GM6961@breakpoint.cc>
 <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
 <20190918144235.GN6961@breakpoint.cc>
 <20190919084321.2g2hzrcrtz4r6nex@salvia>
 <20190919092442.GO6961@breakpoint.cc>
 <20190919094055.4b2nd6aarjxi2bt6@salvia>
 <20190919100329.GP6961@breakpoint.cc>
 <20190919115636.GQ6961@breakpoint.cc>
 <20190919132828.nydpzdt3qqupgtg5@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919132828.nydpzdt3qqupgtg5@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  		/* Only one of these operations is supported */
> > -		if ((flags & (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT)) ==
> > -			     (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT))
> > +		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==
> > +			     (NFT_SET_MAP | NFT_SET_OBJECT))
> 
> That's fine by now. But look, combining map and objects should be fine
> in the future. A user might want to combine this by specifying an IP
> address as the right hand side of a mapping and a stateful counter
> (with a name) to be updated when matching on that element. This is not
> supported yet though.
> 
> > +			return -EOPNOTSUPP;
> > +		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
> > +			     (NFT_SET_EVAL | NFT_SET_OBJECT))
> 
> This looks fine.

I'll submit a patch then.

> > 2. avoid depreaction of 'meter', since thats what is documented everywhere
> >    and appears to work fine
> 
> OK, but only for anonymous meters.

Meters are always anonymous afaiu, they are bound to the rule that
creates them.  Delete the rule -- meter is gone.

> > 3. patch nft to hide normal sets from 'nft list meters' output
> 
> This makes no sense for anonymous meters. Since the kernel picks the
> name, I don't think nft should expose them to the user.

See
commit 24a912eea21f9d18909c53a865cf623839616281
parser_bison: dismiss anonymous meters

nft frontend only allows to create meter with a name.

> > What to do with dynamic, I fear we have to remove it, i.e. just ignore
> > the "dynamic" flag when talking to the kernel.  Otherwise sets using dynamic flag
> > will only work on future/very recent kernels.
> 
> I would not go that path.
> 
> You are just hitting a limitation on the existing implementation.
> People cannot make lookups on a dynamic set on existing kernels,
> that's all.

I guess thats one way to put it.

> There is no NFT_SET_EXPR support for nft_lookup either, is this a bug?

Do you mean NFT_SET_EVAL?
If so, NFT_SET_EVAL is handled by nft_dynset.c (this is what gets used
when you use the 'meter' syntax).

> There is no way to combine NFT_SET_MAP with NFT_SET_OBJ, but that is
> also artificial, this is just happening again because the code is
> incomplete and needs an extension.

Ok.  We can drop the checks once that is done.
