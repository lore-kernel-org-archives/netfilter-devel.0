Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2633C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Dec 2022 13:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbiLLNjs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Dec 2022 08:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbiLLNj0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Dec 2022 08:39:26 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6F3D14D25
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Dec 2022 05:38:22 -0800 (PST)
Date:   Mon, 12 Dec 2022 14:38:19 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 0/3] fix map update with concatenation and timeouts
Message-ID: <Y5cuyyDLt6SD0QXk@salvia>
References: <20221212100436.84116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221212100436.84116-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 12, 2022 at 11:04:33AM +0100, Florian Westphal wrote:
> When "update" is used with a map, nft will ignore a given timeout.
> Futhermore, listing is broken, only the first data expression
> gets decoded:
> 
> in:
>  meta l4proto tcp update @pinned { ip saddr . ct original proto-src : ip daddr . ct original proto-dst timeout 90s }
> out:
>  meta l4proto tcp update @pinned { ip saddr . ct original proto-src : ip daddr }
> 
> Missing timeout is input bug (never passed to kernel), mussing
> "proto-dst" is output bug.
> 
> Also add a test case.

Series LGTM, thanks.

I might follow up to restrict the timeout to the key side unless you
would like to look into this.
