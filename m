Return-Path: <SRS0=yEJZ=DP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA129C433E7
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 16:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8926D221F1
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 16:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgJHQUw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Oct 2020 12:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgJHQUw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 12:20:52 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E329C061755
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 09:20:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kQYew-0002BU-LR; Thu, 08 Oct 2020 18:20:50 +0200
Date:   Thu, 8 Oct 2020 18:20:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] selftests: netfilter: extend nfqueue test case
Message-ID: <20201008162050.GA5723@breakpoint.cc>
References: <20201008154459.17410-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008154459.17410-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> +static void sleep_ms(uint32_t delay)
> +{
> +	struct timespec ts = { .tv_nsec = delay * 1000llu * 1000llu };
> +
> +	nanosleep(&ts, NULL);

This doesn't work if delay is larger than 1s.
Not triggered by current test case, but better to avoid this.

I will send a v2 later.
