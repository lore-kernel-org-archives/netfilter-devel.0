Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A91C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 17:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiAORJD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 12:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiAORJD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 12:09:03 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E2AC061574
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 09:09:02 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n8mY1-0006eW-Ed; Sat, 15 Jan 2022 18:09:01 +0100
Date:   Sat, 15 Jan 2022 18:09:01 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH 08/11] src: add a helper that returns a payload
 dependency for a particular base
Message-ID: <20220115170901.GA25474@breakpoint.cc>
References: <20211221193657.430866-1-jeremy@azazel.net>
 <20211221193657.430866-9-jeremy@azazel.net>
 <YeL62HGr/mHp37pe@strlen.de>
 <YeL84lhx/hxfGAg3@azazel.net>
 <YeL/NJzFHxsUqAas@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeL/NJzFHxsUqAas@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> On 2022-01-15, at 16:57:07 +0000, Jeremy Sowden wrote:
> > On 2022-01-15, at 17:48:24 +0100, Florian Westphal wrote:
> > > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > > Currently, with only one base and dependency stored this is
> > > > superfluous, but it will become more useful when the next commit
> > > > adds support for storing a payload for every base.
> > >
> > > > +	dep = payload_dependency_get(ctx, PROTO_BASE_NETWORK_HDR)->expr;
> > >
> > > This new helper can return NULL, would you mind reworking this to
> > > add error checks here?
> >
> > Yup.
> 
> Actually, let me provide a bit more context:
> 
>   @@ -2060,11 +2060,13 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
>                                        const struct expr *expr)
>    {
>           uint8_t l4proto, nfproto = NFPROTO_UNSPEC;
>   -       struct expr *dep = ctx->pdep->expr;
>   +       struct expr *dep;
> 
>           if (ctx->pbase != PROTO_BASE_NETWORK_HDR)
>                   return true;
> 
>   +       dep = payload_dependency_get(ctx, PROTO_BASE_NETWORK_HDR)->expr;
>   +
> 
> We check that there is a PROTO_BASE_NETWORK_HDR dependency immediately
> before calling the helper.

Perhaps remove the check?

bla()->foo looks weird, esp. given bla() last line is "return NULL".
