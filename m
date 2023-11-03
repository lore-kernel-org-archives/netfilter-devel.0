Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29268C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 15:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbjKCPd7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 11:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbjKCPd7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 11:33:59 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421C7112
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 08:33:53 -0700 (PDT)
Received: from [78.30.35.151] (port=42010 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qywB7-00FcCy-IX; Fri, 03 Nov 2023 16:33:51 +0100
Date:   Fri, 3 Nov 2023 16:33:44 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 0/6] add infrastructure for unit tests
Message-ID: <ZUUS2CuHJAVxc7Ih@calendula>
References: <20231103111102.2801624-1-thaller@redhat.com>
 <20231103122641.GC8035@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231103122641.GC8035@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 01:26:41PM +0100, Florian Westphal wrote:
> Thomas Haller <thaller@redhat.com> wrote:
> 
> Thanks for sending an initial empty skeleton.
> 
> > There are new new make targets:
> > 
> >   - "build-all"
> >   - "check" (runs "normal" tests, like unit tests and "tools/check-tree.sh").
> >   - "check-more" (runs extra tests, like "tests/build")
> >   - "check-all" (runs "check" + "check-more")
> >   - "check-local" (a subset of "check")
> >   - "check-TESTS" (the unit tests)
> 
> "check-unit" perhaps?  TESTS isn't very descriptive.  Also,
> why CAPS? If this is some pre-established standard, then maybe just
> document that in the commit changelog.
> 
> Please don't do anything yet and wait for more comments, but
> I would prefer 'make check' to run all tests that we have.

We had a few tests that have been shown to be unstable.

I just would like that I don't hit this when making the release and
hold back a release because a test fails occasionally.

If we go for `make check' then all test runs must be reliable.
