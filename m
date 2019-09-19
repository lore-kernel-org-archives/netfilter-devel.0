Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8956BC3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 13:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65E3C2196F
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 13:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389819AbfISN2i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 09:28:38 -0400
Received: from correo.us.es ([193.147.175.20]:40408 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388551AbfISN2h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 09:28:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BAAE6DA711
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 15:28:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC08DA594
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 15:28:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A1A2EDA4CA; Thu, 19 Sep 2019 15:28:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78991B7FF6;
        Thu, 19 Sep 2019 15:28:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Sep 2019 15:28:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 20E854265A5A;
        Thu, 19 Sep 2019 15:28:30 +0200 (CEST)
Date:   Thu, 19 Sep 2019 15:28:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Laura Garcia <nevola@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190919132828.nydpzdt3qqupgtg5@salvia>
References: <20190918115325.GM6961@breakpoint.cc>
 <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
 <20190918144235.GN6961@breakpoint.cc>
 <20190919084321.2g2hzrcrtz4r6nex@salvia>
 <20190919092442.GO6961@breakpoint.cc>
 <20190919094055.4b2nd6aarjxi2bt6@salvia>
 <20190919100329.GP6961@breakpoint.cc>
 <20190919115636.GQ6961@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919115636.GQ6961@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 19, 2019 at 01:56:36PM +0200, Florian Westphal wrote:
[...]
> My conclusion is that meters are anon sets with expressions attached to them.
> So, I don't think they should be deprecated.

At least, meters with names should be I think. There is now a way to
represent them 

> I would propose to:
> 
> 1. add this kernel patch:
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3562,8 +3562,11 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
>  			      NFT_SET_OBJECT))
>  			return -EINVAL;
>  		/* Only one of these operations is supported */
> -		if ((flags & (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT)) ==
> -			     (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT))
> +		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==
> +			     (NFT_SET_MAP | NFT_SET_OBJECT))

That's fine by now. But look, combining map and objects should be fine
in the future. A user might want to combine this by specifying an IP
address as the right hand side of a mapping and a stateful counter
(with a name) to be updated when matching on that element. This is not
supported yet though.

> +			return -EOPNOTSUPP;
> +		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
> +			     (NFT_SET_EVAL | NFT_SET_OBJECT))

This looks fine.

>  			return -EOPNOTSUPP;
>  	}
>  
> diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
> --- a/net/netfilter/nft_lookup.c
> +++ b/net/netfilter/nft_lookup.c
> @@ -73,9 +73,6 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
>  	if (IS_ERR(set))
>  		return PTR_ERR(set);
>  
> -	if (set->flags & NFT_SET_EVAL)
> -		return -EOPNOTSUPP;
> -
>  	priv->sreg = nft_parse_register(tb[NFTA_LOOKUP_SREG]);
>  	err = nft_validate_register_load(priv->sreg, set->klen);
>  	if (err < 0)
> 
> 2. avoid depreaction of 'meter', since thats what is documented everywhere
>    and appears to work fine

OK, but only for anonymous meters.

We have a better way, more aligned to set/map definitions, to represent
updates to dynamic named sets from the packet path now.

We can probably introduce a syntax more aligned to the existing
set/map syntax for the _anonymous_ dynamic set/map case, so we don't
need this 'meter' keyword syntactic sugar.

> 3. patch nft to hide normal sets from 'nft list meters' output

This makes no sense for anonymous meters. Since the kernel picks the
name, I don't think nft should expose them to the user.

> What to do with dynamic, I fear we have to remove it, i.e. just ignore
> the "dynamic" flag when talking to the kernel.  Otherwise sets using dynamic flag
> will only work on future/very recent kernels.

I would not go that path.

You are just hitting a limitation on the existing implementation.
People cannot make lookups on a dynamic set on existing kernels,
that's all.

There is no NFT_SET_EXPR support for nft_lookup either, is this a bug?
This infrastructure is just incomplete and just need to be finished.

There is no way to combine NFT_SET_MAP with NFT_SET_OBJ, but that is
also artificial, this is just happening again because the code is
incomplete and needs an extension.
