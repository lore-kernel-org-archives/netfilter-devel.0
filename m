Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760D6CDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 09:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbjJQJdu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 05:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbjJQJdb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 05:33:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9EE199A
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 02:32:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qsgRA-0007Dy-Ew; Tue, 17 Oct 2023 11:32:28 +0200
Date:   Tue, 17 Oct 2023 11:32:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/3] tests/shell: skip "table_onoff" test if kernel
 patch is missing
Message-ID: <20231017093228.GB10901@breakpoint.cc>
References: <20231016131209.1127298-1-thaller@redhat.com>
 <ZS2bKZVAN5d5dax-@strlen.de>
 <a64bccda9ab11f18f13d0512001985d1bf9f04ff.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a64bccda9ab11f18f13d0512001985d1bf9f04ff.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> As you probably run a self-built kernel, wouldn't you just `export
> NFT_TEST_FAIL_ON_SKIP=y` and reject all skips as failures? What's the
> problem with that? That exists exactly for your use case.

No, its not my use case.

The use case is to make sure that the frankenkernels that I am in charge
of do not miss any important bug fixes.

This is the reason for the feature probing, "skip" should tell me that
I can safely ignore it because the feature is not present.

I could built a list of "expected failures", but that will mask real
actual regressions.

> > This is a bug, and it tells me that I might have to do something
> > about it.
> 
> OK, do you intend to fix this bug in a very timely manner on Fedora 38
> (and other popular kernels)? Then maybe hold back the test until that
> happend? (or let it skip for now, and in a few weeks, upgrade to hard
> failure -- the only problem is not to forget about that).

I did keep the test back until I saw that -stable had picked it up.

I can wait longer, sure.

> Ah right. "tests/shell/testcases/transactions/table_onoff" is fixed on
> 6.5.6-200.fc38.x86_64. There still is a general problem. For example
> what about tests/shell/testcases/packetpath/vlan_8021ad_tag ?

Its also a bug that needs to be fixed in the kernel.
I applied it after stable had picked it up for 6.5.7.

> 1) the test would exit 78 instead of 77. And run-test.sh would treat 78
> either as failure or as skip, based on NFT_TEST_FAIL_ON_SKIP
> 
> 2) the test itself could look at NFT_TEST_FAIL_ON_SKIP and decide
> whether to exit with 77 or 1.
> 
> 
> Or how about adding a mechanism, that compares the kernel version and
> decides whether to skip? For example

I don't think that kernel versions work or are something that we can
realistically handle.  Even just RHEL would be a nightmare if one
considers all the different release streams.

I think even just handling upstream -stable is too much work.

That said, I hope that these kinds of tests will happen less frequently
over time.
