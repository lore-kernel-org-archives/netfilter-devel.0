Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25F6E82CD1
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 20:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjI0UV0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 16:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjI0UVY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 16:21:24 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040E41B9
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:21:20 -0700 (PDT)
Received: from [78.30.34.192] (port=43640 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlb24-00EZwb-Je; Wed, 27 Sep 2023 22:21:18 +0200
Date:   Wed, 27 Sep 2023 22:21:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/3] nfnl_osf: rework nf_osf_parse_opt() and avoid
 "-Wstrict-overflow" warning
Message-ID: <ZRSOu3sXh34APRDU@calendula>
References: <20230927122744.3434851-1-thaller@redhat.com>
 <20230927122744.3434851-3-thaller@redhat.com>
 <ZRRbgRny2AHfvV5H@calendula>
 <07bdaa70fcecb26fe6638e10152d41239068571d.camel@redhat.com>
 <ZRRiK70d4FJUJgsP@calendula>
 <c746f59f24efcc610a883795c834728bfb86d651.camel@redhat.com>
 <ZRR/lx1S3kPdk6Vu@calendula>
 <c234813727e4cd5bf5fc4a5b4d4d80b0863c47f0.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c234813727e4cd5bf5fc4a5b4d4d80b0863c47f0.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 27, 2023 at 10:11:15PM +0200, Thomas Haller wrote:
> On Wed, 2023-09-27 at 21:16 +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 27, 2023 at 07:50:27PM +0200, Thomas Haller wrote:
> > 
> > 
> > > IMO the netfilter projects should require contributors to provide
> > > tests
> > > (as sensible). That is, tests that are simply invoked via `make
> > > check`
> > > and don't require to build special features in the kernel
> > > (CONFIG_NFT_OSF).
> > 
> > You mean, some way to exercise userspace code without involving the
> > kernel at all.
> 
> Yes, the relevant part is parsing some strings. That should be tested
> in isolation. Or just to validate the pf.os file...

I understand, that would also require some sort of dump of the
parsing, to validate this is correct. I think I understand what you
mean by unit test here: You could make a program that imports this
.c file, the parse pf.os and dump an output that you could validate in
some automated fashion.

This osf support from iptables, and tests/py (which was the automated
test infrastructure it had) was only added 2012, more than 10 years
after iptables was in place.

> > > I have patches that would add unit tests to the project (merely as
> > > a
> > > place where more unit tests could be added). I will add a test
> > > there.
> > 
> > We have tests/py/ as unit tests, if that might look similar to what
> > you have in mind? Or are you thinking of more tests/shell/ scripts?
> 
> Those only use the public API of libnftables.so. What would be also
> useful, is to statically link against the code and have more immediate
> access.

I see, some internal tests for private API then it is your idea, I am
all in for more test coverage.

> Also, currently they don't unshare and cannot run rootless. That should
> be fixed by extending tests/shell/run-tests.sh script. Well, you
> already hack that via `./tests/shell/run-tests.sh ./tests/py/nft-
> test.py`, but this should integrate better.

Yes, unshare and rootless for tests/py would be good to have if I
understood this correctly.

> It's waiting on the WIP branch:
> https://gitlab.freedesktop.org/thaller/nftables/-/commits/th/no-recursive-make
> https://gitlab.freedesktop.org/thaller/nftables/-/blob/545f40babb90584fd188ebe80a1103b93ba49707/tests/unit/test-libnftables-static.c#L177
> 
> > 
> 
> > > But that is based on top of "no recursive make", and I'd like to
> > > get
> > > that changed first.
> > 
> > I would like to make a release before such change is applied, build
> > infrastructure and python support was messy in the previous release.
> > Then we look into this, OK?
> 
> Sounds great. Thank you.

OK, let's prepare for release then.
