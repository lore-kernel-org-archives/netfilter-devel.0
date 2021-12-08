Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA509C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 12:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbhLHMWO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 07:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhLHMWN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 07:22:13 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD59DC061746
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Dec 2021 04:18:40 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1muvu9-0006Lc-LW; Wed, 08 Dec 2021 13:18:37 +0100
Date:   Wed, 8 Dec 2021 13:18:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: better parameters for the interval
 stack overflow test
Message-ID: <20211208121837.GO6180@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20211201111200.424375-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211201111200.424375-1-snemec@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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

Applied, thanks!
