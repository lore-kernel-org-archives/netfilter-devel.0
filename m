Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A74E2C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Apr 2022 14:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348220AbiD1OSi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 10:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiD1OSh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 10:18:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E021985673
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2022 07:15:22 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:15:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH v2 nf] netfilter: nft_socket: only do sk lookups when
 indev is available
Message-ID: <YmqhdQjqndZXVee8@salvia>
References: <20220428073921.14483-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220428073921.14483-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 28, 2022 at 09:39:21AM +0200, Florian Westphal wrote:
> Check if the incoming interface is available and NFT_BREAK
> in case neither skb->sk nor input device are set.
> 
> Because nf_sk_lookup_slow*() assume packet headers are in the
> 'in' direction, use in postrouting is not going to yield a meaningful
> result.  Same is true for the forward chain, so restrict the use
> to prerouting, input and output.
> 
> Use in output work if a socket is already attached to the skb.

Applied to nf.git, thanks
