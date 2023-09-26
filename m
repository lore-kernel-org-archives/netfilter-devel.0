Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AE8E7E644
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 15:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbjIZP6o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 11:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjIZP6o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 11:58:44 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F168AEB
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 08:58:35 -0700 (PDT)
Received: from [78.30.34.192] (port=60282 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlASG-006Oj2-8t; Tue, 26 Sep 2023 17:58:34 +0200
Date:   Tue, 26 Sep 2023 17:58:31 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3] netlink_linearize: skip set element expression
 in map statement key
Message-ID: <ZRL/p+d/rIGhLCLh@calendula>
References: <20230926152500.30571-1-pablo@netfilter.org>
 <20230926152500.30571-3-pablo@netfilter.org>
 <ZRL9dlPZbt9pVir5@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZRL9dlPZbt9pVir5@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 26, 2023 at 05:49:10PM +0200, Phil Sutter wrote:
> On Tue, Sep 26, 2023 at 05:25:00PM +0200, Pablo Neira Ayuso wrote:
> > This fix is similar to 22d201010919 ("netlink_linearize: skip set element
> > expression in set statement key") to fix map statement.
> > 
> > netlink_gen_map_stmt() relies on the map key, that is expressed as a set
> > element. Use the set element key instead to skip the set element wrap,
> > otherwise get_register() abort execution:
> > 
> >   nft: netlink_linearize.c:650: netlink_gen_expr: Assertion `dreg < ctx->reg_low' failed.
> > 
> > Reported-by: Luci Stanescu <luci@cnix.ro>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patch adds map stmt printing and parsing support to JSON, but not a
> word about that in the commit message. Did this slip in by accident
> (e.g.  'git commit -a')? Anyway, I think it should go into a separate
> patch.

Not accidental.

I just added complete JSON, it has been time consuming, I initially
thought about fixing this issue only and leave JSON alone unfixed, but
looking at recent stuff, that will backfire sooner or later.

I took the existing set statement support and extend it to have a
"data" field to store the data mapping.

> [...]
> > diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> > index 53a318aa2e62..99ed9f387a81 100644
> > --- a/src/netlink_linearize.c
> > +++ b/src/netlink_linearize.c
> > @@ -1585,13 +1585,13 @@ static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
> >  	int num_stmts = 0;
> >  	struct stmt *this;
> >  
> > -	sreg_key = get_register(ctx, stmt->map.key);
> > -	netlink_gen_expr(ctx, stmt->map.key, sreg_key);
> > +	sreg_key = get_register(ctx, stmt->set.key->key);
> > +	netlink_gen_expr(ctx, stmt->set.key->key, sreg_key);
> >  
> >  	sreg_data = get_register(ctx, stmt->map.data);
> >  	netlink_gen_expr(ctx, stmt->map.data, sreg_data);
> >  
> > -	release_register(ctx, stmt->map.key);
> > +	release_register(ctx, stmt->set.key->key);
> >  	release_register(ctx, stmt->map.data);
> >  
> >  	nle = alloc_nft_expr("dynset");
> 
> Any particular reason why this doesn't just use stmt->map.key->key? The

It should use map.key->key, yes.

> first two fields in structs set_stmt and map_stmt are identical, so the
> above works "by accident".

Exactly.

I will fix and send a v2.
