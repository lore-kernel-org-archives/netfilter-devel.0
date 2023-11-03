Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4BBC4167B
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 12:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376299AbjKCM0t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 08:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376270AbjKCM0s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 08:26:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874CDCE
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 05:26:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qytG5-0005i0-1d; Fri, 03 Nov 2023 13:26:41 +0100
Date:   Fri, 3 Nov 2023 13:26:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 0/6] add infrastructure for unit tests
Message-ID: <20231103122641.GC8035@breakpoint.cc>
References: <20231103111102.2801624-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103111102.2801624-1-thaller@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:

Thanks for sending an initial empty skeleton.

> There are new new make targets:
> 
>   - "build-all"
>   - "check" (runs "normal" tests, like unit tests and "tools/check-tree.sh").
>   - "check-more" (runs extra tests, like "tests/build")
>   - "check-all" (runs "check" + "check-more")
>   - "check-local" (a subset of "check")
>   - "check-TESTS" (the unit tests)

"check-unit" perhaps?  TESTS isn't very descriptive.  Also,
why CAPS? If this is some pre-established standard, then maybe just
document that in the commit changelog.

Please don't do anything yet and wait for more comments, but
I would prefer 'make check' to run all tests that we have.

I would suggest
- "check" (run all tests)
- "check-unit" (the unit tests only)
- "check-shell" (shell tests only)
- "check-py" (python based tests only)
- "check-json" (python based tests in json mode and json_echo)

...  and so on.
