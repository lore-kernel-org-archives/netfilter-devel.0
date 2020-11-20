Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F39C63777
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 10:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C02D2240C
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 10:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgKTKUi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 05:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgKTKUi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 05:20:38 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8C7C0613CF
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2020 02:20:37 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kg3Wq-00086a-5j; Fri, 20 Nov 2020 11:20:32 +0100
Date:   Fri, 20 Nov 2020 11:20:32 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     subashab@codeaurora.org, Florian Westphal <fw@strlen.de>,
        Will Deacon <will@kernel.org>, pablo@netfilter.org,
        Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
Message-ID: <20201120102032.GO15137@breakpoint.cc>
References: <20201116182028.GE22792@breakpoint.cc>
 <20201118121322.GA1821@willie-the-truck>
 <20201118124228.GJ22792@breakpoint.cc>
 <20201118125406.GA2029@willie-the-truck>
 <20201118131419.GK22792@breakpoint.cc>
 <7d52f54a7e3ebc794f0b775e793ab142@codeaurora.org>
 <20201118211007.GA15137@breakpoint.cc>
 <7d8bc917b7a6790fa789085ba8324b08@codeaurora.org>
 <20201120094413.GA3040@hirez.programming.kicks-ass.net>
 <20201120095301.GB3092@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120095301.GB3092@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Nov 20, 2020 at 10:44:13AM +0100, Peter Zijlstra wrote:
> > On Thu, Nov 19, 2020 at 10:53:13PM -0700, subashab@codeaurora.org wrote:
> > > +struct xt_table_info
> > > +*xt_table_get_private_protected(const struct xt_table *table)
> > > +{
> > > +	return rcu_dereference_protected(table->private,
> > > +					 mutex_is_locked(&xt[table->af].mutex));
> > > +}
> > > +EXPORT_SYMBOL(xt_table_get_private_protected);
> > 
> > In all debug builds this function compiles to a single memory
> 
> ! went missing... :/

? Not sure about "!".

> > dereference. Do you really want that out-of-line?

Its the lesser of two evils, the other solution would be to export
xt[] from x_tables.c; its static right now.

Or we just use a rcu primitive that does no checking but I'd prefer
avoid that.
