Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E16EC10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 101EF2084B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbfDOXIc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 19:08:32 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54056 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726751AbfDOXIc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 19:08:32 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hGAiE-0006C2-7B; Tue, 16 Apr 2019 01:08:30 +0200
Date:   Tue, 16 Apr 2019 01:08:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Brett Mastbergen <bmastbergen@untangle.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        dmorris@untangle.com
Subject: Re: dict: A netfilter expression for dictionary lookups
Message-ID: <20190415230830.jsmatvfyn3fjrtec@breakpoint.cc>
References: <20190328195857.GA24011@pinebook>
 <20190411192248.7harez523hlkhh3e@breakpoint.cc>
 <20190412141834.GA25271@pinebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412141834.GA25271@pinebook>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Brett Mastbergen <bmastbergen@untangle.com> wrote:
> This patch looks great.  That would greatly improve the usefulness of keying
> off of the conntrack id.  If it gets accepted I can send a kernel patch and
> an nft patch to support the ct id key.

That would be really nice to have.

> > > For a more in depth description of how things work I suggest reading the doc 
> > > in the first link I posted, but below are a few simple examples of what is 
> > > possible using dict expressions:
> > > 
> > > nft add rule ip filter forward dict sessions ct id application long_string 
> > > NETFLIX reject 
> > > 
> > > If I were to describe that rule in plain English it would be:
> > > 
> > > For traffic passing through the ip filter table forward hook, use the 
> > > conntrack id as a key to lookup an entry in the sessions table.  For that
> > > entry check if it has an application field set to a string value of NETFLIX,
> > > if so, reject the traffic.
> > > 
> > > How did that field get set to NETFLIX?  That is up to some other entity.  In 
> > 
> > Why isn't it possible to use the existing nftables set infrastructure
> > for this?
> > 
> > The nft sets store arbitrary octets/bytes as keys, so we could at least
> > from kernel side store arbitrary identifiers (strings, integers etc).
> > 
> 
> I wanted to use the existing set infrastructure, but I ran into two issues
> wrt to what we were trying to acheive:
> 
> 1.  As far as I can tell the current sets are only set up to hold elements
> of a particular data type, where as we are storing elements of many different
> types in a particular dictionary.

Yes, a set is only one data type (They support combining types though).

> 2.  sets are associated with a particular table and therefore can only be
> accessed by rules in that table.  If you want to associate some piece of
> information with a particular connection and use it from rules in multiple
> different tables, you'd have to populate it in a set in each of those tables.

Yes, but thats intentional, a table forms a namespace; so
crossing it is not desireable.

The idea is that different entities each can manage their own tables
without clashing with chain or set names of another table.

Still looking at dicts code, I am trying to understand where normal nft
set infra can't be used (or is too cumbersome) to best understand how we
can fit dicts ideas into nftables' architecture.
