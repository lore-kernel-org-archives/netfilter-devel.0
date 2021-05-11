Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67491C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 15:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28EA461182
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 15:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhEKPcl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 May 2021 11:32:41 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56904 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbhEKPcj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 May 2021 11:32:39 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8B18E64167;
        Tue, 11 May 2021 17:30:42 +0200 (CEST)
Date:   Tue, 11 May 2021 17:31:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        arturo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH nftables,v2 2/2] src: add set element catch-all support
Message-ID: <20210511153128.GA21329@salvia>
References: <20210511130538.63450-1-pablo@netfilter.org>
 <20210511133213.GT12403@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210511133213.GT12403@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 11, 2021 at 03:32:13PM +0200, Phil Sutter wrote:
> On Tue, May 11, 2021 at 03:05:38PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > diff --git a/src/expression.c b/src/expression.c
> > index 9fdf23d98446..4d80e37a5bb6 100644
> > --- a/src/expression.c
> > +++ b/src/expression.c
> > @@ -1270,7 +1270,11 @@ static void set_elem_expr_print(const struct expr *expr,
> >  {
> >  	struct stmt *stmt;
> >  
> > -	expr_print(expr->key, octx);
> > +	if (expr->key->etype == EXPR_SET_ELEM_CATCHALL)
> > +		nft_print(octx, "*");
> > +	else
> > +		expr_print(expr->key, octx);
> > +
> >  	list_for_each_entry(stmt, &expr->stmt_list, list) {
> >  		nft_print(octx, " ");
> >  		stmt_print(stmt, octx);
> > @@ -1299,7 +1303,9 @@ static void set_elem_expr_destroy(struct expr *expr)
> [...]
> > @@ -1328,6 +1334,24 @@ struct expr *set_elem_expr_alloc(const struct location *loc, struct expr *key)
> >  	return expr;
> >  }
> >  
> > +static void set_elem_catchall_expr_print(const struct expr *expr,
> > +					 struct output_ctx *octx)
> > +{
> > +	nft_print(octx, "_");
> > +}
> 
> This is a leftover from v1. Since this went unnoticed, maybe you could
> drop the special casing in set_elem_expr_print() and rely on
> expr_print(expr->key, octx) to call the above? Or am I (probably)
> confusing things?

It's a leftover indeed.

I have removed this and I have just sent a v3:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210511152752.123885-1-pablo@netfilter.org/

I forgot to Cc you, BTW.
