Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29DDEB64DA
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jul 2023 11:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjGDLEn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jul 2023 07:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjGDLEm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jul 2023 07:04:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2754FDA
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Jul 2023 04:04:40 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qGdpm-0004uR-Fj; Tue, 04 Jul 2023 13:04:38 +0200
Date:   Tue, 4 Jul 2023 13:04:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/4] cli: Make valgrind (kind of) happy
Message-ID: <ZKP8xo8S1eyd9QrE@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230622154634.25862-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230622154634.25862-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 22, 2023 at 05:46:30PM +0200, Phil Sutter wrote:
> The following series is more or less a v2 of my previous single patch
> adding nft_ctx_free() calls to cli.c, following a different path:
> Eliminate any program exit points from cli.c so nft context deinit at
> end of main() happens. This is nicer design as said function allocates
> the context in the first place.
> 
> Patch 1 is minor cleanup, patch 2 updates main() to free the context in
> all cases, too and patch 3 then changes CLI code as described above.
> Patch 4 extends shell testsuite by a '-V' (valgrind) mode as present in
> iptables' shell testsuite already which wraps all calls to $NFT by
> valgrind and collects non-empty logs.
> 
> Sadly, I could not eliminate all valgrind complaints because each of the
> three CLI backends leaves allocated memory in place at exit. None seem
> to have sufficient deinit functions, except linenoise - but that code
> runs only for terminals put in raw mode.
> 
> Phil Sutter (4):
>   main: Make 'buf' variable branch-local
>   main: Call nft_ctx_free() before exiting
>   cli: Make cli_init() return to caller
>   tests: shell: Introduce valgrind mode

Series applied.
