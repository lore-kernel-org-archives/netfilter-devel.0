Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95909C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Dec 2022 00:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiLBAqN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 19:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiLBAqM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 19:46:12 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4859A1A07
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 16:46:10 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p0uBs-0007EW-NX; Fri, 02 Dec 2022 01:46:08 +0100
Date:   Fri, 2 Dec 2022 01:46:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 0/7] tests: xlate: generic.txlate to pass replay
 test
Message-ID: <Y4lK0Ni7yqwJWzfI@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20221201163916.30808-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201163916.30808-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 01, 2022 at 05:39:09PM +0100, Phil Sutter wrote:
> Instead of dumping the ruleset with xtables-save and creating yet
> another string comparison mess by searching the output, use --check
> command to leverage iptables' internal rule comparison functionality
> when checking that the nftables-created rule parses correctly as the
> source of the translation (patch 2).
> 
> There was a rub with the above, namely ebtables not supporting --check
> in the first place. Gladly the implementation is pretty simple (patch
> 1) with one caveat: '-C' itself is not available so add the long option
> only.
> 
> The remaining patches deal with translation details (mostly around
> wildcard interface names) until generic.txlate finally passes the replay
> test.
> 
> Phil Sutter (7):
>   ebtables: Implement --check command
>   tests: xlate: Use --check to verify replay
>   nft: Fix for comparing ifname matches against nft-generated ones
>   nft: Fix match generator for '! -i +'
>   nft: Recognize INVAL/D interface name
>   xtables-translate: Fix for interfaces with asterisk mid-string
>   ebtables: Fix MAC address match translation

Series applied.
