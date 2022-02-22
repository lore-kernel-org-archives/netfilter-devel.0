Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859FEC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 10:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiBVKKp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 05:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiBVKKX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 05:10:23 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C4A128DC5
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 02:09:39 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nMS6z-0000p6-6U; Tue, 22 Feb 2022 11:09:37 +0100
Date:   Tue, 22 Feb 2022 11:09:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [iptables PATCH 2/4] tests: add `NOMATCH` test result
Message-ID: <YhS2YfX3LduDhIFS@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20220212165832.2452695-1-jeremy@azazel.net>
 <20220212165832.2452695-3-jeremy@azazel.net>
 <YgooaU4M6ju9++Cy@orbyte.nwl.cc>
 <YhI9xcXbHhjkc+ya@ulthar.dreamlands>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhI9xcXbHhjkc+ya@ulthar.dreamlands>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

On Sun, Feb 20, 2022 at 01:10:29PM +0000, Jeremy Sowden wrote:
> On 2022-02-14, at 11:01:13 +0100, Phil Sutter wrote:
> > On Sat, Feb 12, 2022 at 04:58:30PM +0000, Jeremy Sowden wrote:
> > > Currently, there are two supported test results: `OK` and `FAIL`.
> > > It is expected that either the iptables command fails, or it
> > > succeeds and dumping the rule has the correct output.  However, it
> > > is possible that the command may succeed but the output may not be
> > > correct.  Add a `NOMATCH` result to cover this outcome.
> >
> > Hmm. Wouldn't it make sense to extend the scope of LEGACY/NFT keywords
> > to output checks as well instead of introducing a new one? I think we
> > could cover expected output that way by duplicating the test case with
> > different expected output instead of marking it as unspecific "may
> > produce garbage".
> 
> Something like the following?  One reason why I went with the `NOMATCH`
> result is that in the two divergent test-cases, there is no -nft output
> to match.  We can make that work by just using the empty string as the
> alternative output since that will match anything.  I don't think it's
> ideal, but it's simpler than overhauling the matching code for what is a
> rare corner case.

Thanks for compiling the patch. What I had in mind was to merge result
checks of failing rule with output mismatch, but I realize this would
likely turn into a mess.

[...]
> In the case of tests which have no output to match, we leave the last
> field empty:
> 
>   -j EXAMPLE-TARGET --example-option;=;OK;LEGACY;

A non-empty rule leading to empty output is a bug, IMHO.

[...]
> --- a/extensions/libxt_NFLOG.t
> +++ b/extensions/libxt_NFLOG.t
> @@ -5,8 +5,8 @@
>  -j NFLOG --nflog-group 0;-j NFLOG;OK
>  # `--nflog-range` is broken and only supported by xtables-legacy.
>  # It has been superseded by `--nflog--group`.
> --j NFLOG --nflog-range 1;=;OK;LEGACY;NOMATCH
> --j NFLOG --nflog-range 4294967295;=;OK;LEGACY;NOMATCH
> +-j NFLOG --nflog-range 1;=;OK;LEGACY;
> +-j NFLOG --nflog-range 4294967295;=;OK;LEGACY;

The crucial detail here is that an expected output of "-j NFLOG" is
trivial and str::find() won't complain about extra output.

Given that we're discussing corner cases and what I had in mind has its
own downsides, I guess the status quo is fine at least for now. Sorry
for the fuss!

Cheers, Phil

