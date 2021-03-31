Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD08C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 11:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA866198F
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 11:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbhCaLCP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 07:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbhCaLBz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 07:01:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB4BC06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Mar 2021 04:01:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lRYbh-0002Sm-5z; Wed, 31 Mar 2021 13:01:53 +0200
Date:   Wed, 31 Mar 2021 13:01:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Subject: Re: [iptables PATCH v3 1/2] extensions: libxt_conntrack: print xlate
 state as set
Message-ID: <20210331110153.GE17285@breakpoint.cc>
References: <20210331102934.848126-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331102934.848126-1-alexander.mikhalitsyn@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> Currently, state_xlate_print function prints statemask
> without { ... } around. But if ctstate condition is
> negative, then we have to use { ... } after "!=" operator
> 
> Reproducer:
> $ iptables -A INPUT -d 127.0.0.1/32 -p tcp -m conntrack ! --ctstate RELATED,ESTABLISHED -j DROP
> $ nft list ruleset
> ...
> meta l4proto tcp ip daddr 127.0.0.1 ct state != related,established counter packets 0 bytes 0 drop
> ...
> 
> it will fail if we try to load this rule:
> $ nft -f nft_test
> ../nft_test:6:97-97: Error: syntax error, unexpected comma, expecting newline or semicolon

I'd suggest to use the 'foo & 1' notation just like for patch 2, it
avoids the set lookup.
