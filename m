Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C516C282E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 21:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62BF62175B
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 21:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404126AbfEXVGh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 17:06:37 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57442 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391752AbfEXVGg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 17:06:36 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hUHOc-0001gJ-OS; Fri, 24 May 2019 23:06:34 +0200
Date:   Fri, 24 May 2019 23:06:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: kill anon sets with one element
Message-ID: <20190524210634.64txxzs2kivhlwre@breakpoint.cc>
References: <20190519171838.3811-1-fw@strlen.de>
 <20190524192146.phnh4cqwelnpxdrp@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524192146.phnh4cqwelnpxdrp@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, May 19, 2019 at 07:18:38PM +0200, Florian Westphal wrote:
> > convert "ip saddr { 1.1.1.1 }" to "ip saddr 1.1.1.1".
> > Both do the same, but second form is faster since no single-element
> > anon set is created.
> > 
> > Fix up the remaining test cases to expect transformations of the form
> > "meta l4proto { 33-55}" to "meta l4proto 33-55".
> 
> Last time we discussed this I think we agreed to spew a warning for
> this to educate people on this.

I decided against it.
Why adding a warning?  We do not change what the rule does, and we do
not collapse different rules into one.

> My concern is: This is an optimization, are we going to do transparent
> optimizations of the ruleset? I would like to explore at some point
> automatic transformations for rulesets, also spot shadowed rules,
> overlaps, and other sort of inconsistencies.
> 
> Are we going to do all that transparently?

I think it could be done on a case-by-case basis.

> Asking this because this is an optimization after all, and I'm not
> sure I want to step in into making optimizations transparently. Even
> if this one is fairly trivial.
> 
> I also don't like this path because we introduce one more assymmetry
> between what the user adds a what the user fetches from the kernel.

nft add rule ip filter input ip protocol tcp tcp dport 22
-> tcp dport 22

nft add rule inet filter input tcp dport 22 tcp sport 55
-> tcp sport 55 tcp dport 22

I don't think there is any point in warning about this, so
why warn about tcp dport { 22 } ?

A warning should, IMO, be reserved for something where we
detect a actual problem, e.g.

tcp dport 22 tcp dport 55

and then we could print a 'will never match' warning for nft -f,
and maybe even refuse it for "nft add rule .."

Full ruleset optimization should, IMO, be done transparently as
well if we're confident such transformations are done correctly.

I would however only do it for nft -f, not for "nft add rule ..."

I see rulesets appearing that are very iptables like, e.g.

tcp dport 22 accept
tcp dport 80 accept

and so on, and I think it makes sense to allow nft to compact this.
We could  add optimization level support to nft, i.e.  only do basic
per-rule and do cross-rule optimizations only with a command line parameter.

I think a trivial one such as s/{ 22 }/22/ should just be done automatically.
