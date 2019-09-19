Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86E2C4CECE
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 14:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80981208C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 14:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390322AbfISOXG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:23:06 -0400
Received: from correo.us.es ([193.147.175.20]:58820 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389303AbfISOXG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 10:23:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DA13815C102
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 16:23:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C75F7DA72F
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 16:23:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BCFCAB7FFB; Thu, 19 Sep 2019 16:23:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 267D8DA72F;
        Thu, 19 Sep 2019 16:22:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Sep 2019 16:22:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C59F642EE38F;
        Thu, 19 Sep 2019 16:22:58 +0200 (CEST)
Date:   Thu, 19 Sep 2019 16:22:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Laura Garcia <nevola@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190919142258.oxv2kzdbl7vj5sqk@salvia>
References: <20190918115325.GM6961@breakpoint.cc>
 <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
 <20190918144235.GN6961@breakpoint.cc>
 <20190919084321.2g2hzrcrtz4r6nex@salvia>
 <20190919092442.GO6961@breakpoint.cc>
 <20190919094055.4b2nd6aarjxi2bt6@salvia>
 <20190919100329.GP6961@breakpoint.cc>
 <20190919115636.GQ6961@breakpoint.cc>
 <20190919132828.nydpzdt3qqupgtg5@salvia>
 <20190919140144.GS6961@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919140144.GS6961@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 19, 2019 at 04:01:44PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >  		/* Only one of these operations is supported */
> > > -		if ((flags & (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT)) ==
> > > -			     (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT))
> > > +		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==
> > > +			     (NFT_SET_MAP | NFT_SET_OBJECT))
> > 
> > That's fine by now. But look, combining map and objects should be fine
> > in the future. A user might want to combine this by specifying an IP
> > address as the right hand side of a mapping and a stateful counter
> > (with a name) to be updated when matching on that element. This is not
> > supported yet though.
> > 
> > > +			return -EOPNOTSUPP;
> > > +		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
> > > +			     (NFT_SET_EVAL | NFT_SET_OBJECT))
> > 
> > This looks fine.
> 
> I'll submit a patch then.

Thanks.

> > > 2. avoid depreaction of 'meter', since thats what is documented everywhere
> > >    and appears to work fine
> > 
> > OK, but only for anonymous meters.
> 
> Meters are always anonymous afaiu, they are bound to the rule that
> creates them.  Delete the rule -- meter is gone.

OK. sorry, NFT_SET_ANONYMOUS is misleading, this anonymous flag means
'set is bound to rule', it was wrong to choose this flag name,
probably NFT_SET_BOUND would be better. Anyway, I was referring to
meter with no name.

> > > 3. patch nft to hide normal sets from 'nft list meters' output
> > 
> > This makes no sense for anonymous meters. Since the kernel picks the
> > name, I don't think nft should expose them to the user.
> 
> See
> commit 24a912eea21f9d18909c53a865cf623839616281
> parser_bison: dismiss anonymous meters
> 
> nft frontend only allows to create meter with a name.

Oh, we already deprecated meters with no name :-)

And meters with a name should not be used, there's a better syntax
now for this rather than this sloppy way to create an object from the
rule itself without an explicit definition.

> > > What to do with dynamic, I fear we have to remove it, i.e. just ignore
> > > the "dynamic" flag when talking to the kernel.  Otherwise sets using dynamic flag
> > > will only work on future/very recent kernels.
> > 
> > I would not go that path.
> > 
> > You are just hitting a limitation on the existing implementation.
> > People cannot make lookups on a dynamic set on existing kernels,
> > that's all.
> 
> I guess thats one way to put it.
>
> > There is no NFT_SET_EXPR support for nft_lookup either, is this a bug?
> 
> Do you mean NFT_SET_EVAL?

No, I mean there is no NFT_SET_EXT_EXPR handling yet, sorry I forgot
the _EXT_ infix.

nft_lookup should invoke the expression that is attached. Control
plane code is also missing, there is no way to create the
NFT_SET_EXT_EXPR from newsetelem() in nf_tables_api.c.

If NFT_SET_EVAL is set or not from nft_lookup is completely
irrelevant, nft_lookup should not care about this flag.

> If so, NFT_SET_EVAL is handled by nft_dynset.c (this is what gets used
> when you use the 'meter' syntax).
> 
> > There is no way to combine NFT_SET_MAP with NFT_SET_OBJ, but that is
> > also artificial, this is just happening again because the code is
> > incomplete and needs an extension.
> 
> Ok.  We can drop the checks once that is done.

Agreed.
