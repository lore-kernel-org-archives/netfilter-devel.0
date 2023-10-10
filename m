Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFC0CD690C
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 08:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjJJIzD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 04:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjJJIzC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 04:55:02 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679F0A7
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 01:54:57 -0700 (PDT)
Received: from [78.30.34.192] (port=47798 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qq8Vv-002vL6-RW; Tue, 10 Oct 2023 10:54:53 +0200
Date:   Tue, 10 Oct 2023 10:54:51 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@debian.org>
Cc:     Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org,
        fw@strlen.de, phil@nwl.cc
Subject: Re: [RFC] nftables 0.9.8 -stable backports
Message-ID: <ZSUPsdpvPNDOl8TY@calendula>
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSPltyxV10hYvsr+@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZSPltyxV10hYvsr+@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 09, 2023 at 01:36:29PM +0200, Pablo Neira Ayuso wrote:
> Hi Arturo, Jeremy,
> 
> This is a small batch offering fixes for nftables 0.9.8. It only
> includes the fixes for the implicit chain regression in recent
> kernels.
> 
> This is a few dependency patches that are missing in 0.9.8 are
> required:
> 
>         3542e49cf539 ("evaluate: init cmd pointer for new on-stack context")
>         a3ac2527724d ("src: split chain list in table")
>         4e718641397c ("cache: rename chain_htable to cache_chain_ht")
> 
> a3ac2527724d is fixing an issue with the cache that is required by the
> fixes. Then, the backport fixes for the implicit chain regression with
> Linux -stable:
> 
>         3975430b12d9 ("src: expand table command before evaluation")
>         27c753e4a8d4 ("rule: expand standalone chain that contains rules")
>         784597a4ed63 ("rule: add helper function to expand chain rules into commands")
> 
> I tested with tests/shell at the time of the nftables 0.9.8 release
> (*I did not use git HEAD tests/shell as I did for 1.0.6*).
> 
> I have kept back the backport of this patch intentionally:
> 
>         56c90a2dd2eb ("evaluate: expand sets and maps before evaluation")
> 
> this depends on the new src/interval.c code, in 0.9.8 overlap and
> automerge come a later stage and cache is not updated incrementally,
> I tried the tests coming in this patch and it works fine.
> 
> I did run a few more tests with rulesets that I have been collecting
> from people that occasionally send them to me for my personal ruleset
> repo.
> 
> I: results: [OK] 266 [FAILED] 0 [TOTAL] 266
> 
> This has been tested with latest Linux kernel 5.10 -stable.

Amendment:

I: results: [OK] 264 [FAILED] 2 [TOTAL] 266

But this is because stateful expression in sets are not available in 5.10.

W: [FAILED]     ././testcases/sets/0059set_update_multistmt_0
W: [FAILED]     ././testcases/sets/0060set_multistmt_0

and tests/shell in 0.9.8 has not feature detection support.
