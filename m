Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2146C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 11:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A063364D9A
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 11:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhBLLlf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Feb 2021 06:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhBLLl0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Feb 2021 06:41:26 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D0CC061574;
        Fri, 12 Feb 2021 03:40:45 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lAWoU-0004nM-SY; Fri, 12 Feb 2021 12:40:42 +0100
Date:   Fri, 12 Feb 2021 12:40:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Martin Gignac <martin.gignac@gmail.com>, netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Unable to create a chain called "trace"
Message-ID: <20210212114042.GZ3158@orbyte.nwl.cc>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212000507.GD2766@breakpoint.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 12, 2021 at 01:05:07AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Mon, Feb 08, 2021 at 06:14:44PM +0100, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > In general, shells eating the quotes is problematic and users may not be
> > > > aware of it. This includes scripts that mangle ruleset dumps by
> > > > accident, etc. (Not sure if it is really a problem as we quote some
> > > > strings already).
> > > > 
> > > > Using JSON, there are no such limits, BTW. I really wonder if there's
> > > > really no fix for bison parser to make it "context aware".
> > > 
> > > Right.  We can probably make lots of keywords available for table/chain names
> > > by only recognizing them while parsing rules, i.e. via 'start conditions'
> > > in flex.  But I don't think there is anyone with the time to do the
> > > needed scanner changes.
> > 
> > Oh, I wasn't aware of start conditions at all, thanks for the pointer.
> > Instead of reducing most keyword's scope to rule context, I tried a less
> > intrusive approach, namely recognizing "only strings plus some extra" in
> > certain conditions. See attached patch for reference. With it in place,
> > I was at least able to:
> > 
> > # nft add table inet table
> > # nft add chain inet table chain
> > # nft add rule inet table chain iifname rule
> 
> Thanks.  Another bug report about this problem arrived moments ago,
> this time 'add rule filter dynamic'
> 
> Whats worse is that 3rd party tool created a chain with that name.

This is easily possible using JSON API alone as that doesn't have the
naming limitations. Depending on personal interpretation, this could
mean the problem is far worse than "some exotic tool is able to disturb
nft" or it is actually pretty common and "just another case of 'nft list
ruleset | nft -f -' being broken". I tend towards the latter, but agree
that it is a serious issue.

> So I fear we can't really release a new nft version without a new
> scanner that passes 'string' outside of rule context.
> 
> Phils patch makes this work but breaks the test suite.

It was merely a quick hack. :)

> >  "=="			{ return EQ; }
> >  
> > -{numberstring}		{
> > +<*>{numberstring}	{
> > +				if (nspec && !--nspec)
> > +					BEGIN(0);
> >  				errno = 0;
> >  				yylval->val = strtoull(yytext, NULL, 0);
> >  				if (errno != 0) {
> > @@ -639,7 +645,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
> >  				return ASTERISK_STRING;
> >  			}
> >  
> > -{string}		{
> > +<*>{string}		{
> > +				if (nspec && !--nspec)
> > +					BEGIN(0);
> 
> Not sure this is a good way to go, it looks rather fragile.

I didn't find a better way to conditionally parse two following args as
strings instead of just a single one. Basically I miss an explicit end
condition from which to call BEGIN(0).

> Seems we need allow "{" for "*" and then count the {} nests so
> we can pop off a scanner state stack once we make it back to the
> same } level that we had at the last state switch.

What is the problem?

Thanks, Phil
