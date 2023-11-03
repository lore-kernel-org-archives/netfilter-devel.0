Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D997DC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 20:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjKCUzZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 16:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjKCUzY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 16:55:24 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529BCDB
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 13:55:22 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qz1CK-0003K6-PA; Fri, 03 Nov 2023 21:55:20 +0100
Date:   Fri, 3 Nov 2023 21:55:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables 3/4] nft-arp: add arptables-translate
Message-ID: <ZUVeOE28MCz66MQJ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231103102330.27578-1-fw@strlen.de>
 <20231103102330.27578-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103102330.27578-4-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 11:23:25AM +0100, Florian Westphal wrote:
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  extensions/libarpt_mangle.c  |  47 +++++++++++
>  iptables/nft-arp.c           | 153 +++++++++++++++++++++++++++++++++++
>  iptables/xtables-multi.h     |   1 +
>  iptables/xtables-nft-multi.c |   1 +
>  iptables/xtables-translate.c |  35 +++++++-
>  5 files changed, 236 insertions(+), 1 deletion(-)

This misses an update to libxt_MARK.c: The contained arptables target
does not have an xlate callback (though I guess the existing
mark_tg_xlate should serve as-is).

Cheers, Phil
