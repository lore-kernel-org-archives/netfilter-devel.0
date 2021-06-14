Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045E1C48BE6
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 11:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF09B611BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 11:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhFNMBB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 08:01:01 -0400
Received: from mail.netfilter.org ([217.70.188.207]:41210 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbhFNMBA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 08:01:00 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 295BC641D0;
        Mon, 14 Jun 2021 13:57:40 +0200 (CEST)
Date:   Mon, 14 Jun 2021 13:58:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] evaluate: restore interval + concatenation in
 anonymous set
Message-ID: <20210614115855.GA27287@salvia>
References: <20210611171538.14049-1-pablo@netfilter.org>
 <20210614113403.GP22614@orbyte.nwl.cc>
 <20210614115644.GA27182@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210614115644.GA27182@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 14, 2021 at 01:56:44PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jun 14, 2021 at 01:34:03PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Fri, Jun 11, 2021 at 07:15:38PM +0200, Pablo Neira Ayuso wrote:
> > > Perform the table and set lookup only for non-anonymous sets, where the
> > > incremental cache update is required.
> > > 
> > > The problem fixed by 7aa08d45031e ("evaluate: Perform set evaluation on
> > > implicitly declared (anonymous) sets") resurrected after the cache
> > > rework.
> > > 
> > >  # nft add rule x y tcp sport . tcp dport vmap { ssh . 0-65535 : accept, 0-65535 . ssh : accept }
> > >  BUG: invalid range expression type concat
> > >  nft: expression.c:1422: range_expr_value_low: Assertion `0' failed.
> > >  Abort
> > > 
> > > Add a test case to make sure this does not happen again.
> > > 
> > > Fixes: 5ec5c706d993 ("cache: add hashtable cache for table")
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > This triggers a warning:
> > 
> > evaluate.c: In function 'set_evaluate':
> > evaluate.c:3870:13: warning: 'table' may be used uninitialized in this function [-Wmaybe-uninitialized]
> >  3870 |         if (set_cache_find(table, set->handle.set.name) == NULL)
> >       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Hm, this needs to be restricted to anonymous sets, attaching patch.

It's a false positive though, there is a check for anonymous set a few
lines before. I'll apply this patch if this makes gcc happy on your side.

> diff --git a/src/evaluate.c b/src/evaluate.c
> index 5311963a20c5..7cd90e2c1840 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3867,7 +3867,8 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>  	}
>  	ctx->set = NULL;
>  
> -	if (set_cache_find(table, set->handle.set.name) == NULL)
> +	if (!(set->flags & NFT_SET_ANONYMOUS) &&
> +	    !set_cache_find(table, set->handle.set.name))
>  		set_cache_add(set_get(set), table);
>  
>  	return 0;

