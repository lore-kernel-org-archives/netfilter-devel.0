Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3182BC4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 15:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AB8960F93
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 15:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhHIPS5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 11:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbhHIPS5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 11:18:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6288C0613D3
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 08:18:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mD72v-0000yM-Ui; Mon, 09 Aug 2021 17:18:33 +0200
Date:   Mon, 9 Aug 2021 17:18:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC] scanner: nat: Move to own scope
Message-ID: <20210809151833.GM607@breakpoint.cc>
References: <20210809140141.18976-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809140141.18976-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Unify nat, masquerade and redirect statements, they widely share their
> syntax.
> This seemingly valid change breaks the parser with this rule:
> 
> | snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 }

Yes.

> Problem is that 'prefix' is not in SC_IP and close_scope_ip called from
> parser_bison.y:5067 is not sufficient. I assumed explicit scope closing
> would eliminate this lookahead problem. Did I find a proof against the
> concept or is there a bug in my patch?

You have to keep 'prefix' in the global scope.
What should work as well is to permit 'prefix' from SCANSTATE_IP(6).

The problem is that the parser can't close the new 'IP' scope until
it has enough tokens available to match a complete bison rule.

So, it is in IP scope, sees 'prefix' (which will be STRING as the
PREFIX scan rule is off) and that ends up in a parser error due to lack
of a 'IP STRING' rule.
