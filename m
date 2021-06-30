Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF6FC11F65
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Jun 2021 15:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D14E161463
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Jun 2021 15:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhF3Pg5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 11:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbhF3Pg5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 11:36:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A789C061756
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Jun 2021 08:34:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lycEL-0001cR-IO; Wed, 30 Jun 2021 17:34:25 +0200
Date:   Wed, 30 Jun 2021 17:34:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Garver <e@erig.me>
Subject: Re: [PATCH nft v2 1/3] netlink_delinearize: add missing icmp
 id/sequence support
Message-ID: <20210630153425.GD18022@breakpoint.cc>
References: <20210615160151.10594-1-fw@strlen.de>
 <20210615160151.10594-2-fw@strlen.de>
 <20210630151319.GZ3673@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630151319.GZ3673@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> > will be listed as "icmpv6 id 1" (which is not correct either, since the
> > input only matches on echo-request).
> > 
> > with this patch, output of 'icmpv6 id 1' is
> > icmpv6 type { echo-request, echo-reply } icmpv6 id 1
> > 
> > The second problem, the removal of a single check (request OR reply),
> > is resolved in the followup patch.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Eric reported a testcase in which this patch seems to cause a segfault
> (bisected). The test is as simple as:
> 
> | nft -f - <<EOF
> | add table inet firewalld_check_rule_index
> | add chain inet firewalld_check_rule_index foobar { type filter hook input priority 0 ; }
> | add rule inet firewalld_check_rule_index foobar tcp dport 1234 accept
> | add rule inet firewalld_check_rule_index foobar accept
> | insert rule inet firewalld_check_rule_index foobar index 1 udp dport 4321 accept
> | EOF
> 
> But a ruleset is in place at this time. Also, I can't reproduce it on my
> own machine but only on Eric's VM for testing.

You need to add a ruleset with
icmp id 42

then it will crash.  adding 'list ruleset' before EOF avoids it,
because cache gets populated.

> I am not familiar with recent changes in cache code, maybe there's the
> actual culprit: Debug printf in cache_init_objects() states flags
> variable is 0x4000005f, i.e. NFT_CACHE_SETELEM_BIT is not set.
> 
> I am not sure if caching is incomplete and we need that bit or if the
> above code should expect sets with missing elements and therefore check
> 'set->init != NULL' before accessing expressions field.

I think correct fix is to check set->init, we don't need to do
postprocessing if its not going to be printed.

