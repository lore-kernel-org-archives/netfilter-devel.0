Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABBEC4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 16:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A6960041
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 16:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhHIQZw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 12:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhHIQZq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 12:25:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B84C0613D3
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 09:25:17 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mD85S-00005Q-2C; Mon, 09 Aug 2021 18:25:14 +0200
Date:   Mon, 9 Aug 2021 18:25:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC] scanner: nat: Move to own scope
Message-ID: <20210809162514.GA3673@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210809140141.18976-1-phil@nwl.cc>
 <20210809151833.GM607@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809151833.GM607@breakpoint.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 09, 2021 at 05:18:33PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Unify nat, masquerade and redirect statements, they widely share their
> > syntax.
> > This seemingly valid change breaks the parser with this rule:
> > 
> > | snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 }
> 
> Yes.
> 
> > Problem is that 'prefix' is not in SC_IP and close_scope_ip called from
> > parser_bison.y:5067 is not sufficient. I assumed explicit scope closing
> > would eliminate this lookahead problem. Did I find a proof against the
> > concept or is there a bug in my patch?
> 
> You have to keep 'prefix' in the global scope.
> What should work as well is to permit 'prefix' from SCANSTATE_IP(6).
> 
> The problem is that the parser can't close the new 'IP' scope until
> it has enough tokens available to match a complete bison rule.
> 
> So, it is in IP scope, sees 'prefix' (which will be STRING as the
> PREFIX scan rule is off) and that ends up in a parser error due to lack
> of a 'IP STRING' rule.

OK, thanks. So does this mean we won't ever be able to move keywords
opening a statement or expression out of INIT scope or is my case a
special one?

To clarify, what I have in mind is a sample rule 'ip id 1 tcp dport 1'
where 'tcp' must either be in INIT scope or part of SC_IP. 

Cheers, Phil
