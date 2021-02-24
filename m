Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADEBC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Feb 2021 10:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44AA564ED3
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Feb 2021 10:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhBXKgE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 05:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbhBXKgD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 05:36:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3925CC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Feb 2021 02:35:22 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lErVm-0006Tp-0A; Wed, 24 Feb 2021 11:35:18 +0100
Date:   Wed, 24 Feb 2021 11:35:17 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft] iptables-nft: fix -Z option
Message-ID: <20210224103517.GN22016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20210224100802.2352-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224100802.2352-1-fw@strlen.de>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 24, 2021 at 11:08:02AM +0100, Florian Westphal wrote:
> it zeroes the rule counters, so it needs fully populated cache.
> Add a test case to cover this.
> 
> Fixes: 9d07514ac5c7a ("nft: calculate cache requirements from list of commands")
> Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
