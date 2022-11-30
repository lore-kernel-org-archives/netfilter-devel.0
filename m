Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D01D3C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 14:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiK3OVA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 09:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiK3OU7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 09:20:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC0B59FD8
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 06:20:57 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p0NxH-00032h-KT; Wed, 30 Nov 2022 15:20:55 +0100
Date:   Wed, 30 Nov 2022 15:20:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ebtables-nft] nft-bridge: work around recent "among"
 decode breakage
Message-ID: <Y4dmx55r32Z5yH0E@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20221130103812.67033-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130103812.67033-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 30, 2022 at 11:38:12AM +0100, Florian Westphal wrote:
> ebtables-nft-save will fail with
> "unknown meta key" when decoding "among" emulation with ipv4 or ipv6
> addresses included.
> 
> This is because "meta protocol ip" is used as a dependency, but
> its never decoded anywhere.
> 
> Skip this for now to restore the "ebtables/0006-flush_0"
> test case.
> 
> Fixes: 25883ce88bfb ("nft: check for unknown meta keys")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Best-effort approach. :)

Acked-by: Phil Sutter <phil@nwl.cc>
