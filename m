Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABF1CD98C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 22:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjJJWV2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 18:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjJJWV1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 18:21:27 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60D98F
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 15:21:24 -0700 (PDT)
Received: from [78.30.34.192] (port=55874 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qqL6L-007DDQ-G4; Wed, 11 Oct 2023 00:21:19 +0200
Date:   Wed, 11 Oct 2023 00:21:16 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Arturo Borrero Gonzalez <arturo@debian.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [RFC] nftables 0.9.8 -stable backports
Message-ID: <ZSXOXM0kmZay+HcB@calendula>
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSPltyxV10hYvsr+@calendula>
 <ZSUPsdpvPNDOl8TY@calendula>
 <20231010200838.GA1438255@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231010200838.GA1438255@celephais.dreamlands>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 10, 2023 at 09:08:38PM +0100, Jeremy Sowden wrote:
> On 2023-10-10, at 10:54:51 +0200, Pablo Neira Ayuso wrote:
> > On Mon, Oct 09, 2023 at 01:36:29PM +0200, Pablo Neira Ayuso wrote:
> > > This is a small batch offering fixes for nftables 0.9.8. It only
> > > includes the fixes for the implicit chain regression in recent
> > > kernels.
> > > 
> > > This is a few dependency patches that are missing in 0.9.8 are
> > > required:
> > > 
> > >         3542e49cf539 ("evaluate: init cmd pointer for new on-stack context")
> > >         a3ac2527724d ("src: split chain list in table")
> > >         4e718641397c ("cache: rename chain_htable to cache_chain_ht")
> > > 
> > > a3ac2527724d is fixing an issue with the cache that is required by the
> > > fixes. Then, the backport fixes for the implicit chain regression with
> > > Linux -stable:
> > > 
> > >         3975430b12d9 ("src: expand table command before evaluation")
> > >         27c753e4a8d4 ("rule: expand standalone chain that contains rules")
> > >         784597a4ed63 ("rule: add helper function to expand chain rules into commands")
> > > 
> > > I tested with tests/shell at the time of the nftables 0.9.8 release
> > > (*I did not use git HEAD tests/shell as I did for 1.0.6*).
> > > 
> > > I have kept back the backport of this patch intentionally:
> > > 
> > >         56c90a2dd2eb ("evaluate: expand sets and maps before evaluation")
> > > 
> > > this depends on the new src/interval.c code, in 0.9.8 overlap and
> > > automerge come a later stage and cache is not updated incrementally,
> > > I tried the tests coming in this patch and it works fine.
> > > 
> > > I did run a few more tests with rulesets that I have been collecting
> > > from people that occasionally send them to me for my personal ruleset
> > > repo.
> > > 
> > > I: results: [OK] 266 [FAILED] 0 [TOTAL] 266
> > > 
> > > This has been tested with latest Linux kernel 5.10 -stable.
> > 
> > Amendment:
> > 
> > I: results: [OK] 264 [FAILED] 2 [TOTAL] 266
> > 
> > But this is because stateful expression in sets are not available in 5.10.
> > 
> > W: [FAILED]     ././testcases/sets/0059set_update_multistmt_0
> > W: [FAILED]     ././testcases/sets/0060set_multistmt_0
> >
> > and tests/shell in 0.9.8 has not feature detection support.
> 
> This is very helpful.  Thanks.
> 
> My immediate interest is getting the implicit chain regression fixes
> into Debian 11, so for that I'm going to cherry-pick:
> 
>   4e718641397c ("cache: rename chain_htable to cache_chain_ht")
>   a3ac2527724d ("src: split chain list in table")
>   784597a4ed63 ("rule: add helper function to expand chain rules into commands")
>   27c753e4a8d4 ("rule: expand standalone chain that contains rules")
>   3975430b12d9 ("src: expand table command before evaluation")

This is also needed:

    3542e49cf539 ("evaluate: init cmd pointer for new on-stack context")

otherwise the test with implicit chain in 0.9.8 crashes, it is a
dependency patch.
