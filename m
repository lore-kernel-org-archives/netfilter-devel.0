Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E370C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Dec 2022 21:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiLTVYK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 16:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLTVYK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 16:24:10 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7463F7F
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2022 13:24:08 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p7k5m-0001Gk-W5; Tue, 20 Dec 2022 22:24:07 +0100
Date:   Tue, 20 Dec 2022 22:24:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH 0/4] Make rule parsing strict
Message-ID: <Y6In9sWc/qCV4vpZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20221215161756.3463-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215161756.3463-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 15, 2022 at 05:17:52PM +0100, Phil Sutter wrote:
> Abort the program when encountering rules with unsupported matches.
> 
> While nft_is_table_compatible() tries to catch this situation, it boils
> down to merely accepting or rejecting expressions based on type. Yet
> these may still be used in incompatible ways.
> 
> Patch 1 fixes for payload matches on ICMP(v6) headers and is almost
> independent of the rest.
> 
> Patch 2 prepares arptables rule parsing for the error message added by
> patch 3.
> 
> Patch 3 makes various situations complain by emitting error messages. It
> was compiled after reviewing all callees of rule_to_cs callback for
> unhandled unexpected input.
> 
> Patch 5 then finally does it's thing.
> 
> Phil Sutter (4):
>   nft: Parse icmp header matches
>   arptables: Check the mandatory ar_pln match
>   nft: Increase rule parser strictness
>   nft: Make rule parsing errors fatal

Series applied.
