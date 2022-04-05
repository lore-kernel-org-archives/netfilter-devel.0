Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F76DC35295
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 11:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242156AbiDEL02 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 07:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354210AbiDEKMP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 06:12:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7947F5548E;
        Tue,  5 Apr 2022 02:58:52 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7C5DF6303B;
        Tue,  5 Apr 2022 11:55:13 +0200 (CEST)
Date:   Tue, 5 Apr 2022 11:58:48 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vasily Averin <vasily.averin@linux.dev>
Cc:     Florian Westphal <fw@strlen.de>, kernel@openvz.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2] nft: memcg accounting for dynamically allocated
 objects
Message-ID: <YkwS2F0ZrE73KONJ@salvia>
References: <935e4270-9e0e-4cd0-ffb4-9c1eb3d9c56e@linux.dev>
 <121a6930-9ebd-e488-e109-273a403a93cb@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <121a6930-9ebd-e488-e109-273a403a93cb@linux.dev>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 02, 2022 at 12:50:37PM +0300, Vasily Averin wrote:
> nft_*.c files whose NFT_EXPR_STATEFUL flag is set on need to
> use __GFP_ACCOUNT flag for objects that are dynamically
> allocated from the packet path.
> 
> Such objects are allocated inside nft_expr_ops->init() callbacks
> executed in task context while processing netlink messages.
> 
> In addition, this patch adds accounting to nft_set_elem_expr_clone()
> used for the same purposes.

Applied to nf, thanks
