Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E397C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Nov 2022 18:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbiKKSQj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 13:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbiKKSQi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 13:16:38 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21726532D8
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 10:16:37 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1otYZv-0006gy-FZ
        for netfilter-devel@vger.kernel.org; Fri, 11 Nov 2022 19:16:35 +0100
Date:   Fri, 11 Nov 2022 19:16:35 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/3] Extend xlate-test to replay results
Message-ID: <Y26Rg7zhXGFggWHr@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20221107130843.8024-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107130843.8024-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 07, 2022 at 02:08:40PM +0100, Phil Sutter wrote:
> If nftables has libxtables support, it will utilize the .xlate callbacks
> to print compat expressions in native nftables syntax. Users may miss
> the fact that what they're seeing is not the reality and assume they may
> manipulate (including store and reload) the ruleset using nftables. This
> wasn't a big deal if iptables-nft understood all the translations
> libxtables offers.
> 
> To start catching up on this, add an optional replay mode to
> xlate-test.py checking if what was translated is correctly parsed back
> into the original input (or at least a semantical equivalent).
> 
> Patches 1 and 2 are prep work, patch 3 has the gory details.
> 
> Phil Sutter (3):
>   tests: xlate-test: Cleanup file reading loop
>   tests: xlate-test.py: Introduce run_proc()
>   tests: xlate-test: Replay results for reverse direction testing

Series applied.
