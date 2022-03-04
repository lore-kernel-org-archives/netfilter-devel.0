Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E31C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Mar 2022 12:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbiCDMQu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 07:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiCDMQu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 07:16:50 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A493EB88
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 04:16:01 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nQ6ql-0003s3-SB; Fri, 04 Mar 2022 13:15:59 +0100
Date:   Fri, 4 Mar 2022 13:15:59 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] misspell: Avoid segfault with anonymous chains
Message-ID: <YiIC/zbFfMTcsuNb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220304103711.23355-1-phil@nwl.cc>
 <YiHz+bNsLvFjkPit@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiHz+bNsLvFjkPit@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 04, 2022 at 12:11:53PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Fri, Mar 04, 2022 at 11:37:11AM +0100, Phil Sutter wrote:
> > When trying to add a rule which contains an anonymous chain to a
> > non-existent chain, string_misspell_update() is called with a NULL
> > string because the anonymous chain has no name. Avoid this by making the
> > function NULL-pointer tolerant.
> > 
> > c330152b7f777 ("src: support for implicit chain bindings")
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/misspell.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/src/misspell.c b/src/misspell.c
> > index 6536d7557a445..f213a240005e6 100644
> > --- a/src/misspell.c
> > +++ b/src/misspell.c
> > @@ -80,8 +80,8 @@ int string_misspell_update(const char *a, const char *b,
> >  {
> >  	unsigned int len_a, len_b, max_len, min_len, distance, threshold;
> >  
> > -	len_a = strlen(a);
> > -	len_b = strlen(b);
> > +	len_a = a ? strlen(a) : 0;
> > +	len_b = b ? strlen(b) : 0;
> 
> string_distance() assumes non-NULL too.

Which is called from string_misspell_update() only which with my patch
returns early due to 'max_len <= 1'.

> probably shortcircuit chain_lookup_fuzzy() earlier since h->chain.name
> is always NULL, to avoid the useless loop.

Fine with me, too! What about allocating a name for the anonymous chain
instead? I guess similar treatment as with sets would make sense. Might
also help with netlink debug output:

| # nft --debug=netlink insert rule inet x y 'goto { accept; }'
| inet (null) (null) use 0
| inet x
|   [ immediate reg 0 accept ]
| 
|   inet x y
|     [ immediate reg 0 goto ]
| [...]

Thanks, Phil
