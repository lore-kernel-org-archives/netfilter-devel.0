Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27335CDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 20:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbjJQUlS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 16:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjJQUlS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 16:41:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3C492
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 13:41:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qsqsM-0002xU-Eg; Tue, 17 Oct 2023 22:41:14 +0200
Date:   Tue, 17 Oct 2023 22:41:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 0/3] add "eval-exit-code" and skip tests based on
 kernel version
Message-ID: <20231017204114.GB5770@breakpoint.cc>
References: <20231017085133.1203402-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231017085133.1203402-1-thaller@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> This is a follow-up and replaces the two patches:
> 
>   [PATCH nft 1/3] tests/shell: skip "table_onoff" test if kernel patch is missing
>   [PATCH nft 2/3] tests/shell: skip "vlan_8021ad_tag" test instead of failing
> 
> Instead, add a helper script "eval-exit-code" which makes it easy(?) to
> conditionally downgrade a test failure to a SKIP (exit 77) based on the
> kernel version.

I think we should leave things as-is.

If this proves to be an issue (esp. if we have crasher-tests...),
we could make a new subdir, e.g. tests/shell/testcases/kernel, place
thse tests there and then have the 'make check' export a new environment
variable, e.g. 'SKIP_KERNEL_TESTS" or whatever.

But for now I think things are fine, Fedora should catch up soon with
the vlan test case (its already in 6.5.y stable) so this will go away.

And for others this hints that they need to complain to their vendor,
or backport a the fix to resolve this bug.

I think SKIP should be reseved only for tests that fail a feature-probe
dependency.
