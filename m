Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F884C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Dec 2021 14:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhLGOIu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 09:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbhLGOIu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 09:08:50 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE82C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Dec 2021 06:05:19 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mub5k-00020Z-5A; Tue, 07 Dec 2021 15:05:12 +0100
Date:   Tue, 7 Dec 2021 15:05:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: better parameters for the interval
 stack overflow test
Message-ID: <20211207140512.GK6180@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211201112614.GB2315@breakpoint.cc>
 <20211201111200.424375-1-snemec@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Dec 01, 2021 at 12:12:00PM +0100, Štěpán Němec wrote:
> Wider testing has shown that 128 kB stack is too low (e.g. for systems
> with 64 kB page size), leading to false failures in some environments.
> 
> Based on results from a matrix of RHEL 8 and RHEL 9 systems across
> x86_64, aarch64, ppc64le and s390x architectures as well as some
> anecdotal testing of other Linux distros on x86_64 machines, 400 kB
> seems safe: the normal nft stack (which should stay constant during
> this test) on all tested systems doesn't exceed 200 kB (stays around
> 100 kB on typical systems with 4 kB page size), while always growing
> beyond 500 kB in the failing case (nftables before baecd1cf2685) with
> the increased set size.
> 
> Fixes: d8ccad2a2b73 ("tests: cover baecd1cf2685 ("segtree: Fix segfault when restoring a huge interval set")")
> Signed-off-by: Štěpán Němec <snemec@redhat.com>
> ---
> I haven't been able to find an answer to the question of how much
> stack size can vary across different systems (particularly those
> nftables is likely to run on), so more testing might be useful,
> especially on systems not listed above.

Given that both the old and your new version of the test case reliably
trigger on x86_64, I guess it's good enough - I suppose almost all
testsuite runs happen on that architecture and if the test detects a
regression there, it's sufficient for upstream.

In theory, downstream is fine with the test producing false-negatives in
all but one (mandatory) tested arch, but if your patch improves that I
don't see any downsides to it.

On Wed, Dec 01, 2021 at 12:26:14PM +0100, Florian Westphal wrote:
> We could try to get rid of large on-stack allocations and always malloc
> instead.

I quickly played around with reduced stack size and listing a large
ruleset. Really just a quick test, but I got a segfault in
parser_bison.c. I bet this will be the limiting factor in all attempts
at reducing stack size, bugs aside. :)

Cheers, Phil
