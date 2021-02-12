Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38240C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 21:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06B4864DEC
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 21:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhBLVIB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Feb 2021 16:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhBLVH4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Feb 2021 16:07:56 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64108C061756;
        Fri, 12 Feb 2021 13:07:16 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lAfei-00073z-9B; Fri, 12 Feb 2021 22:07:12 +0100
Date:   Fri, 12 Feb 2021 22:07:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Martin Gignac <martin.gignac@gmail.com>,
        netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Unable to create a chain called "trace"
Message-ID: <20210212210712.GE3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Martin Gignac <martin.gignac@gmail.com>, netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20210208154915.GF16570@breakpoint.cc>
 <20210208164750.GM3158@orbyte.nwl.cc>
 <20210208171444.GH16570@breakpoint.cc>
 <20210209135625.GN3158@orbyte.nwl.cc>
 <20210212000507.GD2766@breakpoint.cc>
 <20210212114042.GZ3158@orbyte.nwl.cc>
 <20210212122007.GE2766@breakpoint.cc>
 <20210212170921.GA1119@salvia>
 <20210212173201.GD3158@orbyte.nwl.cc>
 <20210212175423.GA3033@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212175423.GA3033@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 12, 2021 at 06:54:23PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Feb 12, 2021 at 06:32:01PM +0100, Phil Sutter wrote:
> > On Fri, Feb 12, 2021 at 06:09:21PM +0100, Pablo Neira Ayuso wrote:
> > > On Fri, Feb 12, 2021 at 01:20:07PM +0100, Florian Westphal wrote:
> > > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > I didn't find a better way to conditionally parse two following args as
> > > > > strings instead of just a single one. Basically I miss an explicit end
> > > > > condition from which to call BEGIN(0).
> > > > 
> > > > Yes, thats part of the problem.
> > > > 
> > > > > > Seems we need allow "{" for "*" and then count the {} nests so
> > > > > > we can pop off a scanner state stack once we make it back to the
> > > > > > same } level that we had at the last state switch.
> > > > > 
> > > > > What is the problem?
> > > > 
> > > > Detect when we need to exit the current start condition.
> > > > 
> > > > We may not even be able to do BEGIN(0) if we have multiple, nested
> > > > start conditionals. flex supports start condition stacks, but that
> > > > still leaves the exit/closure issue.
> > > > 
> > > > Example:
> > > > 
> > > > table chain {
> > > >  chain bla {  /* should start to recognize rules, but
> > > > 		 we did not see 'rule' keyword */
> > > > 	ip saddr { ... } /* can't exit rule start condition on } ... */
> > > > 	ip daddr { ... }
> > > >  }  /* should disable rule keywords again */
> > > > 
> > > >  chain dynamic { /* so 'dynamic' is a string here ... */
> > > >  }
> > > > }
> > > > 
> > > > I don't see a solution, perhaps add dummy bison rule(s)
> > > > to explicitly signal closure of e.g. a rule context?
> > > 
> > > It should also be possible to add an explicit rule to allow for
> > > keywords to be used as table/chain/... identifier.
> > 
> > Which means we have to collect and maintain a list of all known keywords
> > which is at least error-prone.
> 
> You mean, someone might forget to update the list of keywords.

Yes, every time a new keyword is introduced that list has to be updated.
Right now each introduced keyword may break someone's ruleset. This is
only avoided if that keyword list you propose is constantly kept up to
date.

This is the reason why I prefer to have a more intelligent parser which
just knows where something user-defined is supposed to be and not even
tries to parse it as something it knows.

> That's right.
> 
> > > It should be possible to add a test script in the infrastructure to
> > > create table/chain/... using keywords, to make sure this does not
> > > break.
> > 
> > You mean something that auto-generates the list of keywords to try?
> 
> Autogenerating this list would be good, I didn't good that far in
> exploring this.

Ah, I thought that's implied by your mention of a script. If it is
possible, it would at least help keep that list from above up to date.

> Or just making a shell script that extracts the %token lines to try to
> create table with a keyword as a name.
> 
> The shell script would just have a "list of unallowed keyword" to
> filter out the %tokens that are not allowed, for those tokens that are
> really reserved keywords.

sed -n 's/^"\([^"]*\)".*/\1/p' src/scanner.l | exclude_unwanted

> > > It's not nice, but it's simple and we don't mingle with flex.
> > > 
> > > I have attached an example patchset (see patch 2/2), it's incomplete.
> > > I could also have a look at adding such regression test.
> > 
> > Ah, I tried that path but always ended with shift/reduce conflicts. They
> > appear when replacing DYNAMIC with e.g. TABLE, CHAIN or RULE in your
> > patch.
> 
> Probably we have to set some explicit restrictions, like table, chain,
> rule, set, map and flowtable are reserved keywords. For example, not
> allowing to call a table '>'. That was not possible since the
> beginning anyway.

This topic constantly reminds me of C objects named like their type
'struct foo foo'. That's my personal proof that it must be possible! :)

> The concern is to add a new token and break backward as it happened
> with 'dynamic' as Florian reported I think.
> 
> > Of course we may declare that none of those is a sane name for a
> > table, but I wonder if we'll discover less obvious cases later.
> 
> BTW, Florian mentioned your patch makes unhappy the tests infra?
> What's the issue?

I didn't check. But I guess the nested syntax (chain within table) is a
problem with my simple "parse two strings now" approach. I would like to
play a bit more with that start condition approach. IMO teaching flex
how to interpret tokens based on earlier ones is a smart way of fixing
it.

Cheers, Phil
