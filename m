Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF848C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 11:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2A3360EC0
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 11:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238022AbhHJLTs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 07:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbhHJLTr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 07:19:47 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757F4C0613D3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Aug 2021 04:19:25 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mDPn0-00029e-Pc; Tue, 10 Aug 2021 13:19:22 +0200
Date:   Tue, 10 Aug 2021 13:19:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC] scanner: nat: Move to own scope
Message-ID: <20210810111922.GD3673@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210809140141.18976-1-phil@nwl.cc>
 <20210809151833.GM607@breakpoint.cc>
 <20210809162514.GA3673@orbyte.nwl.cc>
 <20210809184559.GO607@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809184559.GO607@breakpoint.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 09, 2021 at 08:45:59PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > So, it is in IP scope, sees 'prefix' (which will be STRING as the
> > > PREFIX scan rule is off) and that ends up in a parser error due to lack
> > > of a 'IP STRING' rule.
> > 
> > OK, thanks. So does this mean we won't ever be able to move keywords
> > opening a statement or expression out of INIT scope or is my case a
> > special one?
> 
> We can move them out of INIT scope, but only if they remain within
> the same scope.
> 
> For example, you could create a 'rule scope' or 'expression scope'
> that contains all tokens (ip, tcp, etc.) that start a new expression.

Ah, OK!

> I did not do this because there are too many cases where expressions are
> permitted outside of rule scope, e.g. in set definitions (key, elements
> ...)
> 
> > To clarify, what I have in mind is a sample rule 'ip id 1 tcp dport 1'
> > where 'tcp' must either be in INIT scope or part of SC_IP. 
> 
> IP and TCP need to be in the same scope (e.g. INIT).
> 
> In the given example I suspect that TCP doesn't have to be in SC_IP
> scope since 'ip id 1' is a full expression and scope closure happens
> before next token gets scanned.

Now I got it: The problem with nat_stmt is that 'snat ip' may either be
'SNAT nf_key_proto' or 'SNAT stmt_expr' and bison carries on until it's
clear. I missed the fact that stmt_expr is allowed in nat_stmt_args.

Thanks for the clarification! Maybe one day I'll finally understand how
bison really works. %)

Cheers, Phil
