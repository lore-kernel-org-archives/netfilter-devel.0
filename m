Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7750AC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 20:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36AAA64E63
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 20:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbhBQUAX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbhBQUAV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 15:00:21 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64EFC061574;
        Wed, 17 Feb 2021 11:59:40 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lCSz3-0007ca-KK; Wed, 17 Feb 2021 20:59:37 +0100
Date:   Wed, 17 Feb 2021 20:59:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Martin Gignac <martin.gignac@gmail.com>, netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Unable to create a chain called "trace"
Message-ID: <20210217195937.GA22016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Martin Gignac <martin.gignac@gmail.com>, netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <CANf9dFMJN5ZsihtygUnEWB_9T=WLbEHrZY1a5mTqLgN7J39D5w@mail.gmail.com>
 <20210208154915.GF16570@breakpoint.cc>
 <20210208164750.GM3158@orbyte.nwl.cc>
 <20210208171444.GH16570@breakpoint.cc>
 <20210209135625.GN3158@orbyte.nwl.cc>
 <20210212000507.GD2766@breakpoint.cc>
 <20210212114042.GZ3158@orbyte.nwl.cc>
 <20210212122007.GE2766@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212122007.GE2766@breakpoint.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Feb 12, 2021 at 01:20:07PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > I didn't find a better way to conditionally parse two following args as
> > strings instead of just a single one. Basically I miss an explicit end
> > condition from which to call BEGIN(0).
> 
> Yes, thats part of the problem.
> 
> > > Seems we need allow "{" for "*" and then count the {} nests so
> > > we can pop off a scanner state stack once we make it back to the
> > > same } level that we had at the last state switch.
> > 
> > What is the problem?
> 
> Detect when we need to exit the current start condition.

I explored my approach further but ended up in an ugly situation due to
the use of 'set' keyword in rules: My code is not context-aware, so upon
recognizing 'set' keyword it switches to spec-condition. I can't simply
detect preceding command-keywords due to them being implicit in nested
notation.

> We may not even be able to do BEGIN(0) if we have multiple, nested
> start conditionals. flex supports start condition stacks, but that
> still leaves the exit/closure issue.
> 
> Example:
> 
> table chain {
>  chain bla {  /* should start to recognize rules, but
> 		 we did not see 'rule' keyword */

My code worked with this after enabling detection of '{' in all
conditions and making it call BEGIN(0) (regardless of nspec value).

> 	ip saddr { ... } /* can't exit rule start condition on } ... */

Maybe we could track nesting block depth in a simple counter?

> 	ip daddr { ... }
>  }  /* should disable rule keywords again */
> 
>  chain dynamic { /* so 'dynamic' is a string here ... */
>  }
> }
> 
> I don't see a solution, perhaps add dummy bison rule(s)
> to explicitly signal closure of e.g. a rule context?

We can't influence start conditions from within bison (if that's what
you had in mind). All we can do is try make flex aware of the current
input context. For instance, detect 'table' followed by '{' to open
"table definition context" and start tracking braces to detect its end.
Though after all I think your assessment of all this being "fragile" is
appropriate. :/

Cheers, Phil
