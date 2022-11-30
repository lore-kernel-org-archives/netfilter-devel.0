Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D4CC47088
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 08:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbiK3IAx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 03:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiK3IAw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 03:00:52 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEA13AC03
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 00:00:51 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1p0I1S-0002Ls-2G; Wed, 30 Nov 2022 09:00:50 +0100
Date:   Wed, 30 Nov 2022 09:00:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 iptables-nft 2/3] extensions: change expected output
 for new format
Message-ID: <20221130080050.GB17072@breakpoint.cc>
References: <20221129140542.28311-1-fw@strlen.de>
 <20221129140542.28311-3-fw@strlen.de>
 <Y4Ypce59j6HbKl0k@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4Ypce59j6HbKl0k@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Tue, Nov 29, 2022 at 03:05:41PM +0100, Florian Westphal wrote:
> > Now that xtables-translate encloses the entire command line in ', update
> > the test cases accordingly.
> 
> We could also do something like this (untested) and leave the test cases
> as-is:
> 
> diff --git a/xlate-test.py b/xlate-test.py
> index f3fcd797af908..82999beadb2d6 100755
> --- a/xlate-test.py
> +++ b/xlate-test.py
> @@ -158,9 +158,14 @@ xtables_nft_multi = 'xtables-nft-multi'
>              sourceline = line.split(';')[0]
>  
>          expected = payload.readline().rstrip(" \n")
> -        next_expected = payload.readline()
> +        if expected.startswith("nft ") and expected[5] != "'":
> +                expected = "nft '" + expected.removeprefix("nft ") + "'"
> +        next_expected = payload.readline().rstrip(" \n")
>          if next_expected.startswith("nft"):
> -            expected += "\n" + next_expected.rstrip(" \n")
> +            if next_expected[5] != "'":
> +                expected += "\nnft '" + next_expected.removeprefix("nft ") + "'"
> +            else:
> +                expected += "\n" + next_expected

Thats not enough, because the test cases escape ", but the new output
doesn't do this anymore.
