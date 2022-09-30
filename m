Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996CFC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Sep 2022 14:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiI3OEv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 10:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiI3OEX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 10:04:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6730F15C1C4
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Sep 2022 07:04:09 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oeGcY-0001bB-6b; Fri, 30 Sep 2022 16:04:06 +0200
Date:   Fri, 30 Sep 2022 16:04:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] monitor: Sanitize startup race condition
Message-ID: <Yzb3Vj7/GpyL7hRf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220928223248.25933-1-phil@nwl.cc>
 <Yzbr2l+oH6ilq2l0@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yzbr2l+oH6ilq2l0@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Sep 30, 2022 at 03:15:06PM +0200, Pablo Neira Ayuso wrote:
[...]
> Fine to apply this meanwhile.

Thanks. I tried to find a better solution, but failed. IMO it should be
enough to just refresh cache from scratch once the first event is
received, but it seems the reproducer script is too aggressive even for
that.

> I wanted to fix this, but I found a few kernel bugs at that time, such as:
> 
> commit 6fb721cf781808ee2ca5e737fb0592cc68de3381
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Sun Sep 26 09:59:35 2021 +0200
> 
>     netfilter: nf_tables: honor NLM_F_CREATE and NLM_F_EXCL in event notification
> 
> which were not allowing me to infer the location accordingly, for
> incrementally updating the cache.
> 
> So I stopped for a while until these fixes propagate to the kernel.
> 
> It's been 1 year even since, times flies...

Same here. My backlog just keeps growing and with it the number of
side-projects "to get back to later".

Cheers, Phil
