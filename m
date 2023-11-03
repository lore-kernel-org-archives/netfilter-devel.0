Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049BBC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 11:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjKCLnR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 07:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjKCLnR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 07:43:17 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE421BF
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 04:43:10 -0700 (PDT)
Received: from [78.30.35.151] (port=33248 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qysZq-00EfCF-MP; Fri, 03 Nov 2023 12:43:08 +0100
Date:   Fri, 3 Nov 2023 12:43:01 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 0/6] add infrastructure for unit tests
Message-ID: <ZUTcxSxaa5nwglAw@calendula>
References: <20231103111102.2801624-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231103111102.2801624-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 12:05:42PM +0100, Thomas Haller wrote:
> There are new new make targets:
> 
>   - "build-all"
>   - "check" (runs "normal" tests, like unit tests and "tools/check-tree.sh").
>   - "check-more" (runs extra tests, like "tests/build")
>   - "check-all" (runs "check" + "check-more")
>   - "check-local" (a subset of "check")
>   - "check-TESTS" (the unit tests)
> 
> The unit tests have a test runner "tools/test-runner.sh". See
> `tools/test-runner.sh -h` for options, like valgrind, GDB, or make.
> It also runs the test in a separate namespace (rootless).
> 
> To run unit tests only, `make check-TESTS` or `tools/test-runner.sh
> tests/unit/test-libnftables-static -m`.
> 
> The unit tests are of course still empty. "tests/unit" is the place
> where tests shall be added.

Thanks a lot for improving tests infrastructure.
