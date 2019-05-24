Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC89AC282E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 21:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C75A4217D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 21:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404259AbfEXVke (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 17:40:34 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57566 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404176AbfEXVke (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 17:40:34 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hUHvU-0001sl-9w; Fri, 24 May 2019 23:40:32 +0200
Date:   Fri, 24 May 2019 23:40:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: kill anon sets with one element
Message-ID: <20190524214032.ht4hbtv3ut5jfgpo@breakpoint.cc>
References: <20190519171838.3811-1-fw@strlen.de>
 <20190524192146.phnh4cqwelnpxdrp@salvia>
 <20190524210634.64txxzs2kivhlwre@breakpoint.cc>
 <20190524212506.vkpqe74fjojq7e6c@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524212506.vkpqe74fjojq7e6c@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, May 24, 2019 at 11:06:34PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Sun, May 19, 2019 at 07:18:38PM +0200, Florian Westphal wrote:
> > > > convert "ip saddr { 1.1.1.1 }" to "ip saddr 1.1.1.1".
> > > > Both do the same, but second form is faster since no single-element
> > > > anon set is created.
> > > > 
> > > > Fix up the remaining test cases to expect transformations of the form
> > > > "meta l4proto { 33-55}" to "meta l4proto 33-55".
> > > 
> > > Last time we discussed this I think we agreed to spew a warning for
> > > this to educate people on this.
> > 
> > I decided against it.
> > Why adding a warning?  We do not change what the rule does, and we do
> > not collapse different rules into one.
> 
> Yes, there is no semantic change.
> 
> Should we also do transparent transformation for
> 
>         ct state { established,new }
> 
> I have seen rulesets like this too.

Hmm, to what should this be transformed?
ct state established,new ?

We can do it for this one, established and new can never be set at the
same time (or any other state for that matter).

[..]

> > Full ruleset optimization should, IMO, be done transparently as
> > well if we're confident such transformations are done correctly.
> > 
> > I would however only do it for nft -f, not for "nft add rule ..."
> 
> Why only for nft -f and not for "nft add rule" ?

I think if you do a 'nft add rule' then you expect to add a rule and
not to modify an existing one.

There is also the performance aspect, for 'nft add' you can just
build the rule object and pass that to kernel, but for optimizing
you need to fetch what is there and perform analysis on it.

I should have be more specific, with "nft -f" i meant a full rule
file, not a partial one (esp. one that has a 'flush ruleset'), or
something that at least contains a complete subset, e.g. a new
chain with n rules.

We could add a command line switch for this and allow optimizing in
any case, or add a new 'nft compact' or 'nft optimize' command that
would fetch the ruleset and print the 'optimized' version what nft
thinks can be coalesced/omitted etc.

What do you think?

> We can add a new parameter to optimize rulesets, we can start with
> something simple, ie.
> 
> * collapse consecutive several rules that come with the same
>   selectors, only values change.
> 
> * turn { 22 } into 22.
> 
> * turn ct state {new, established } into ct new,established.
> 
> > I think a trivial one such as s/{ 22 }/22/ should just be done automatically.
> 
> We could, yes. But I would prefer if we place all optimizations under
> some new option and we document them.
> 
> I was expecting to have a discussion on this during the NFWS :-).

Sure, lets do that.
