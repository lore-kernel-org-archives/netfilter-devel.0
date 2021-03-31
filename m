Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C066C433C1
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 10:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAE526198F
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 10:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbhCaK7C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 06:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235078AbhCaK6z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 06:58:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B91EC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Mar 2021 03:58:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lRYYn-0002Q2-08; Wed, 31 Mar 2021 12:58:53 +0200
Date:   Wed, 31 Mar 2021 12:58:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Subject: Re: [iptables PATCH v3 2/2] extensions: libxt_conntrack: print xlate
 status as set
Message-ID: <20210331105852.GD17285@breakpoint.cc>
References: <20210331102934.848126-1-alexander.mikhalitsyn@virtuozzo.com>
 <20210331102934.848126-2-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331102934.848126-2-alexander.mikhalitsyn@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> At the moment, status_xlate_print function prints statusmask as comma-separated
> sequence of enabled statusmask flags. But if we have inverted conntrack ctstatus
> condition then we have to use more complex expression (if more than one flag enabled)
> because nft not supports syntax like "ct status != expected,assured".
> 
> Examples:
> ! --ctstatus CONFIRMED,ASSURED
> should be translated as
> ct status & (assured|confirmed) == 0
> 
> ! --ctstatus CONFIRMED
> can be translated as
> ct status != confirmed

"! --ctstatus CONFIRMED" means 'true if CONFIRMED bit is not set'
But "ct status != confirmed" means 'true if ct status contains any value
except confirmed.

Example: ct->status has confirmed and assured bits set.
Then:
"! --ctstatus CONFIRMED" won't match (the bit is set).
ct status != confirmed returns true (3 != 1)
ct (status & confirmed) == 0 won't match (the bit is set).

