Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFE4C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Nov 2023 02:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjKHCvh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 21:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjKHCvg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 21:51:36 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4769CD79
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 18:51:34 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1r0YfE-0001yu-9L; Wed, 08 Nov 2023 03:51:32 +0100
Date:   Wed, 8 Nov 2023 03:51:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 iptables 0/4] xtables-nft: add arptranslate support
Message-ID: <ZUr3tPmC0SyBmVx7@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231107111544.17166-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231107111544.17166-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 07, 2023 at 12:15:36PM +0100, Florian Westphal wrote:
> This series adds support for arptranslate to xtables-nft.
> First patch adds missing value/mask support, second patch
> adds arptranslate.
> 
> Patch 3 adds test cases.  Finally, patch 4 fixes -j MARK and adds
> test cases for it.
> 
> Florian Westphal (4):
>   nft-arp: add missing mask support
>   nft-arp: add arptables-translate
>   arptables-txlate: add test cases
>   extensions: MARK: fix arptables support

Series applied, thanks!
