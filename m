Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E72C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 17:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90F9E64DA5
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 17:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhBLRcv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Feb 2021 12:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhBLRcs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Feb 2021 12:32:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603C7C061574;
        Fri, 12 Feb 2021 09:32:08 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lAcIT-00009T-QK; Fri, 12 Feb 2021 18:32:01 +0100
Date:   Fri, 12 Feb 2021 18:32:01 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Martin Gignac <martin.gignac@gmail.com>,
        netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Unable to create a chain called "trace"
Message-ID: <20210212173201.GD3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
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
 <20210212170921.GA1119@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212170921.GA1119@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Feb 12, 2021 at 06:09:21PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Feb 12, 2021 at 01:20:07PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > I didn't find a better way to conditionally parse two following args as
> > > strings instead of just a single one. Basically I miss an explicit end
> > > condition from which to call BEGIN(0).
> > 
> > Yes, thats part of the problem.
> > 
> > > > Seems we need allow "{" for "*" and then count the {} nests so
> > > > we can pop off a scanner state stack once we make it back to the
> > > > same } level that we had at the last state switch.
> > > 
> > > What is the problem?
> > 
> > Detect when we need to exit the current start condition.
> > 
> > We may not even be able to do BEGIN(0) if we have multiple, nested
> > start conditionals. flex supports start condition stacks, but that
> > still leaves the exit/closure issue.
> > 
> > Example:
> > 
> > table chain {
> >  chain bla {  /* should start to recognize rules, but
> > 		 we did not see 'rule' keyword */
> > 	ip saddr { ... } /* can't exit rule start condition on } ... */
> > 	ip daddr { ... }
> >  }  /* should disable rule keywords again */
> > 
> >  chain dynamic { /* so 'dynamic' is a string here ... */
> >  }
> > }
> > 
> > I don't see a solution, perhaps add dummy bison rule(s)
> > to explicitly signal closure of e.g. a rule context?
> 
> It should also be possible to add an explicit rule to allow for
> keywords to be used as table/chain/... identifier.

Which means we have to collect and maintain a list of all known keywords
which is at least error-prone.

> It should be possible to add a test script in the infrastructure to
> create table/chain/... using keywords, to make sure this does not
> break.

You mean something that auto-generates the list of keywords to try?

> It's not nice, but it's simple and we don't mingle with flex.
> 
> I have attached an example patchset (see patch 2/2), it's incomplete.
> I could also have a look at adding such regression test.

Ah, I tried that path but always ended with shift/reduce conflicts. They
appear when replacing DYNAMIC with e.g. TABLE, CHAIN or RULE in your
patch. Of course we may declare that none of those is a sane name for a
table, but I wonder if we'll discover less obvious cases later.

Cheers, Phil
