Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC71AC07E96
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 22:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C83FE61C91
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 22:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhGFWzN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 18:55:13 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52814 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhGFWzN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 18:55:13 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B708B6164E;
        Wed,  7 Jul 2021 00:52:22 +0200 (CEST)
Date:   Wed, 7 Jul 2021 00:52:31 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v2] src: examples: Use
 libnetfilter_queue cached linux headers throughout
Message-ID: <20210706225231.GB12859@salvia>
References: <20210706042713.11002-1-duncan_roe@optusnet.com.au>
 <20210706053648.11109-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210706053648.11109-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 06, 2021 at 03:36:48PM +1000, Duncan Roe wrote:
> A user will typically copy nf-queue.c, make changes and compile: picking up
> /usr/include/linux/nfnetlink_queue.h rather than
> /usr/include/libnetfilter_queue/linux_nfnetlink_queue.h as is recommended.
> 
> libnetfilter_queue.h already includes linux_nfnetlink_queue.h so we only need
> to delete the errant line.
> 
> (Running `make nf-queue` from within libnetfilter_queue/examples will get
> the private cached version of nfnetlink_queue.h which is not distributed).
> 
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
> v2: Don't insert a new #include
>     Doesn't clash with other nearby patch
>  examples/nf-queue.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> index 3da2c24..e4b33b5 100644
> --- a/examples/nf-queue.c
> +++ b/examples/nf-queue.c
> @@ -11,7 +11,6 @@
>  #include <linux/netfilter/nfnetlink.h>
>  
>  #include <linux/types.h>
> -#include <linux/netfilter/nfnetlink_queue.h>

I remember now what the intention was.

This include is fine as is: new applications should cache a copy of
nfnetlink_queue.h in their own tree, that's the recommended way to go.
This is the approach that we follow in other existing userspace
netfilter codebase (ie. the userspace program caches the kernel UAPI
header in the tree). The linux_nfnetlink_queue.h header is a legacy
file only for backward compatibility, it should not be used for new
software. This is not documented, the use of this include in
examples/nf-queue.c was intentional.

This approach also allows to fall back to the UAPI kernel headers that
are installed in your system.

Thanks.
