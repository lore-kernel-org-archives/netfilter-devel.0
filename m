Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA1AC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 00:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4C6064E4D
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 00:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhBLAFw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 19:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhBLAFv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 19:05:51 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD26C061574;
        Thu, 11 Feb 2021 16:05:11 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lALxL-0006O5-JI; Fri, 12 Feb 2021 01:05:08 +0100
Date:   Fri, 12 Feb 2021 01:05:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Martin Gignac <martin.gignac@gmail.com>,
        netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Unable to create a chain called "trace"
Message-ID: <20210212000507.GD2766@breakpoint.cc>
References: <CANf9dFMJN5ZsihtygUnEWB_9T=WLbEHrZY1a5mTqLgN7J39D5w@mail.gmail.com>
 <20210208154915.GF16570@breakpoint.cc>
 <20210208164750.GM3158@orbyte.nwl.cc>
 <20210208171444.GH16570@breakpoint.cc>
 <20210209135625.GN3158@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209135625.GN3158@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Mon, Feb 08, 2021 at 06:14:44PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > In general, shells eating the quotes is problematic and users may not be
> > > aware of it. This includes scripts that mangle ruleset dumps by
> > > accident, etc. (Not sure if it is really a problem as we quote some
> > > strings already).
> > > 
> > > Using JSON, there are no such limits, BTW. I really wonder if there's
> > > really no fix for bison parser to make it "context aware".
> > 
> > Right.  We can probably make lots of keywords available for table/chain names
> > by only recognizing them while parsing rules, i.e. via 'start conditions'
> > in flex.  But I don't think there is anyone with the time to do the
> > needed scanner changes.
> 
> Oh, I wasn't aware of start conditions at all, thanks for the pointer.
> Instead of reducing most keyword's scope to rule context, I tried a less
> intrusive approach, namely recognizing "only strings plus some extra" in
> certain conditions. See attached patch for reference. With it in place,
> I was at least able to:
> 
> # nft add table inet table
> # nft add chain inet table chain
> # nft add rule inet table chain iifname rule

Thanks.  Another bug report about this problem arrived moments ago,
this time 'add rule filter dynamic'

Whats worse is that 3rd party tool created a chain with that name.

So I fear we can't really release a new nft version without a new
scanner that passes 'string' outside of rule context.

Phils patch makes this work but breaks the test suite.

>  "=="			{ return EQ; }
>  
> -{numberstring}		{
> +<*>{numberstring}	{
> +				if (nspec && !--nspec)
> +					BEGIN(0);
>  				errno = 0;
>  				yylval->val = strtoull(yytext, NULL, 0);
>  				if (errno != 0) {
> @@ -639,7 +645,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  				return ASTERISK_STRING;
>  			}
>  
> -{string}		{
> +<*>{string}		{
> +				if (nspec && !--nspec)
> +					BEGIN(0);

Not sure this is a good way to go, it looks rather fragile.

Seems we need allow "{" for "*" and then count the {} nests so
we can pop off a scanner state stack once we make it back to the
same } level that we had at the last state switch.
