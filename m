Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43375E82CC8
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 19:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjI0TQq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjI0TQq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 15:16:46 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D328F
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:16:44 -0700 (PDT)
Received: from [78.30.34.192] (port=47382 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qla1Z-00EHIL-1I; Wed, 27 Sep 2023 21:16:43 +0200
Date:   Wed, 27 Sep 2023 21:16:39 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/3] nfnl_osf: rework nf_osf_parse_opt() and avoid
 "-Wstrict-overflow" warning
Message-ID: <ZRR/lx1S3kPdk6Vu@calendula>
References: <20230927122744.3434851-1-thaller@redhat.com>
 <20230927122744.3434851-3-thaller@redhat.com>
 <ZRRbgRny2AHfvV5H@calendula>
 <07bdaa70fcecb26fe6638e10152d41239068571d.camel@redhat.com>
 <ZRRiK70d4FJUJgsP@calendula>
 <c746f59f24efcc610a883795c834728bfb86d651.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c746f59f24efcc610a883795c834728bfb86d651.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 27, 2023 at 07:50:27PM +0200, Thomas Haller wrote:
> On Wed, 2023-09-27 at 19:11 +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 27, 2023 at 07:04:57PM +0200, Thomas Haller wrote:
> > > 
> > > How can pf.os used?
> > 
> > According to code, pf.os file with signatures needs to be placed
> > here:
> > 
> > #define OS_SIGNATURES DEFAULT_INCLUDE_PATH "/nftables/osf/pf.os"
> > 
> > then, you can start matching on OS type, see 'osf' expression in
> > manpage. Note there is a "unknown" OS type when it does not guess the
> > OS.
> 
> Sorry, I don't follow. Testing this seems very cumbersome.

It requires kernel support and the pf.os file in place, yes.

> I suspect, the tests "tests/shell/testcases/sets/typeof_{sets,maps}_0"
> might hit the code. But that test requires kernel support.

This requires kernel support, yes.

> IMO the netfilter projects should require contributors to provide tests
> (as sensible). That is, tests that are simply invoked via `make check`
> and don't require to build special features in the kernel
> (CONFIG_NFT_OSF).

You mean, some way to exercise userspace code without involving the
kernel at all.

> Anyway. Let's hold this patch [2/3] back for now. And patch [1/3] is
> obsolete too.

OK, as you prefer.

> I have patches that would add unit tests to the project (merely as a
> place where more unit tests could be added). I will add a test there.

We have tests/py/ as unit tests, if that might look similar to what
you have in mind? Or are you thinking of more tests/shell/ scripts?

> But that is based on top of "no recursive make", and I'd like to get
> that changed first.

I would like to make a release before such change is applied, build
infrastructure and python support was messy in the previous release.
Then we look into this, OK?
