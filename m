Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C727CC43613
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 01:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A66022084A
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 01:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfFUB7x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 21:59:53 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40554 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfFUB7x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 21:59:53 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1he8PT-0004Yj-0M; Fri, 21 Jun 2019 03:32:11 +0200
Date:   Fri, 21 Jun 2019 03:32:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Simon Kirby <sim@hostway.ca>,
        netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nft ct original oddity
Message-ID: <20190621013210.vzdclexjaxxqephp@breakpoint.cc>
References: <20190618220508.twxiuzaxvtc7ya6u@hostway.ca>
 <20190619051010.aae7tvgptmgldawp@breakpoint.cc>
 <20190619084542.p6myk7tpm7fozxoi@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619084542.p6myk7tpm7fozxoi@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jun 19, 2019 at 07:10:10AM +0200, Florian Westphal wrote:
> > Simon Kirby <sim@hostway.ca> wrote:
> > 
> > [ moving to nf-devel ]
> > 
> > > I accidentally wrote "ct original" instead of "ct direction original",
> > > and this broke "nft list ruleset":
> > > 
> > > # nft add set filter myset '{ type ipv4_addr; }'
> > > # nft insert rule filter input ct original ip daddr @myset
> > > # nft list ruleset
> > > nft: netlink_delinearize.c:124: netlink_parse_concat_expr: Assertion `consumed > 0' failed.
> > > Abort
> > 
> > Indeed.
> > 
> > This will fix the immediate problem:
> > 
> > diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> > --- a/src/netlink_delinearize.c
> > +++ b/src/netlink_delinearize.c
> > @@ -329,7 +329,7 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
> >                 return netlink_error(ctx, loc,
> >                                      "Lookup expression has no left hand side");
> >  
> > -       if (left->len < set->key->len) {
> > +       if (left->len && left->len < set->key->len) {
> >                 expr_free(left);
> >                 left = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
> >                 if (left == NULL)
> > 
> > Pablo, the problem is that ct->key is NFT_CT_SRC, so expr->len is 0, so
> > we try to parse a concat expression.  Its not until the evaluation step
> > before we will figure out from context that SRC is asking for an ipv4
> > address and update the type and expression length.
> > 
> > AFAICS the plan was to stop using NFT_CT_SRC and use NFT_CT_SRC_IP(6)
> > instead so we have type and length info available directly.
> > 
> > Was there a problem with it (inet family)?
> 
> Right. In general, we need keys with fixed lengths, the NFT_CT_SRC
> approach where key is variable length is a problem for the set
> infrastructure, as you're describing.
> 
> There's a fix for this here:
> 
> https://patchwork.ozlabs.org/patch/883575/
> 
> It requires kernel >= 4.17.
> 
> I wanted to have netlink descriptions to deal with this case, but so
> far only probing is possible, and I would like not to open up for that
> path.
> 
> I can just rebase, resubmit and merge it if you are fine with it.

I'm fine with this, it follows the same approach we use in other similar
cases, i.e. use of "ip" and "ip6" in grammar to figure out the desired
ip protocol version.

I would still push the above left->len fix, ok?
