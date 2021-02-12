Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.6 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358C4C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 17:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D090164E9C
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 17:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhBLRzL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Feb 2021 12:55:11 -0500
Received: from correo.us.es ([193.147.175.20]:58198 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhBLRzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Feb 2021 12:55:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2492CE8E9F
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Feb 2021 18:54:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCD05DA78B
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Feb 2021 18:54:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D1AF0DA730; Fri, 12 Feb 2021 18:54:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DE6DDA73F;
        Fri, 12 Feb 2021 18:54:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 12 Feb 2021 18:54:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 709EC42DC700;
        Fri, 12 Feb 2021 18:54:23 +0100 (CET)
Date:   Fri, 12 Feb 2021 18:54:23 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Martin Gignac <martin.gignac@gmail.com>,
        netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Unable to create a chain called "trace"
Message-ID: <20210212175423.GA3033@salvia>
References: <CANf9dFMJN5ZsihtygUnEWB_9T=WLbEHrZY1a5mTqLgN7J39D5w@mail.gmail.com>
 <20210208154915.GF16570@breakpoint.cc>
 <20210208164750.GM3158@orbyte.nwl.cc>
 <20210208171444.GH16570@breakpoint.cc>
 <20210209135625.GN3158@orbyte.nwl.cc>
 <20210212000507.GD2766@breakpoint.cc>
 <20210212114042.GZ3158@orbyte.nwl.cc>
 <20210212122007.GE2766@breakpoint.cc>
 <20210212170921.GA1119@salvia>
 <20210212173201.GD3158@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210212173201.GD3158@orbyte.nwl.cc>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 12, 2021 at 06:32:01PM +0100, Phil Sutter wrote:
> Hi,
> 
> On Fri, Feb 12, 2021 at 06:09:21PM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Feb 12, 2021 at 01:20:07PM +0100, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > I didn't find a better way to conditionally parse two following args as
> > > > strings instead of just a single one. Basically I miss an explicit end
> > > > condition from which to call BEGIN(0).
> > > 
> > > Yes, thats part of the problem.
> > > 
> > > > > Seems we need allow "{" for "*" and then count the {} nests so
> > > > > we can pop off a scanner state stack once we make it back to the
> > > > > same } level that we had at the last state switch.
> > > > 
> > > > What is the problem?
> > > 
> > > Detect when we need to exit the current start condition.
> > > 
> > > We may not even be able to do BEGIN(0) if we have multiple, nested
> > > start conditionals. flex supports start condition stacks, but that
> > > still leaves the exit/closure issue.
> > > 
> > > Example:
> > > 
> > > table chain {
> > >  chain bla {  /* should start to recognize rules, but
> > > 		 we did not see 'rule' keyword */
> > > 	ip saddr { ... } /* can't exit rule start condition on } ... */
> > > 	ip daddr { ... }
> > >  }  /* should disable rule keywords again */
> > > 
> > >  chain dynamic { /* so 'dynamic' is a string here ... */
> > >  }
> > > }
> > > 
> > > I don't see a solution, perhaps add dummy bison rule(s)
> > > to explicitly signal closure of e.g. a rule context?
> > 
> > It should also be possible to add an explicit rule to allow for
> > keywords to be used as table/chain/... identifier.
> 
> Which means we have to collect and maintain a list of all known keywords
> which is at least error-prone.

You mean, someone might forget to update the list of keywords.

That's right.

> > It should be possible to add a test script in the infrastructure to
> > create table/chain/... using keywords, to make sure this does not
> > break.
> 
> You mean something that auto-generates the list of keywords to try?

Autogenerating this list would be good, I didn't good that far in
exploring this.

Or just making a shell script that extracts the %token lines to try to
create table with a keyword as a name.

The shell script would just have a "list of unallowed keyword" to
filter out the %tokens that are not allowed, for those tokens that are
really reserved keywords.

> > It's not nice, but it's simple and we don't mingle with flex.
> > 
> > I have attached an example patchset (see patch 2/2), it's incomplete.
> > I could also have a look at adding such regression test.
> 
> Ah, I tried that path but always ended with shift/reduce conflicts. They
> appear when replacing DYNAMIC with e.g. TABLE, CHAIN or RULE in your
> patch.

Probably we have to set some explicit restrictions, like table, chain,
rule, set, map and flowtable are reserved keywords. For example, not
allowing to call a table '>'. That was not possible since the
beginning anyway.

The concern is to add a new token and break backward as it happened
with 'dynamic' as Florian reported I think.

> Of course we may declare that none of those is a sane name for a
> table, but I wonder if we'll discover less obvious cases later.

BTW, Florian mentioned your patch makes unhappy the tests infra?
What's the issue?
