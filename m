Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B8AC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Dec 2022 14:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiLMODK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Dec 2022 09:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235690AbiLMODJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Dec 2022 09:03:09 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0770A63B2
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2022 06:03:07 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p55s9-00068P-IV; Tue, 13 Dec 2022 15:03:05 +0100
Date:   Tue, 13 Dec 2022 15:03:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 0/4] xt: Rewrite unsupported compat expression dumping
Message-ID: <Y5iGGXUWWaDSkfFz@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20221124165641.26921-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124165641.26921-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 24, 2022 at 05:56:37PM +0100, Phil Sutter wrote:
> Alternative approach to my previous dump and restore support of xt
> compat expressions:
> 
> If translation is not available or not successful, fall back to a
> format which allows to be parsed easily.
> 
> When parsing, reject these expressions explicitly with a meaningful
> error message.
> 
> Phil Sutter (4):
>   xt: Delay libxtables access until translation
>   xt: Purify enum nft_xt_type
>   xt: Rewrite unsupported compat expression dumping
>   xt: Fall back to generic printing from translation

Series applied.
