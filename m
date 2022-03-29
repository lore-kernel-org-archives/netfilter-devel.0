Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C427BC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Mar 2022 21:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbiC2ViR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Mar 2022 17:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiC2ViQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Mar 2022 17:38:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 767E4122225
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2022 14:36:33 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8CE476019D;
        Tue, 29 Mar 2022 23:33:19 +0200 (CEST)
Date:   Tue, 29 Mar 2022 23:36:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf PATCH v2] netfilter: bitwise: fix reduce comparisons
Message-ID: <YkN73i59zcEJjaOi@salvia>
References: <20220327215223.73014-1-jeremy@azazel.net>
 <20220327223625.134198-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220327223625.134198-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Mar 27, 2022 at 11:36:25PM +0100, Jeremy Sowden wrote:
> The `nft_bitwise_reduce` and `nft_bitwise_fast_reduce` functions should
> compare the bitwise operation in `expr` with the tracked operation
> associated with the destination register of `expr`.  However, instead of
> being called on `expr` and `track->regs[priv->dreg].selector`,
> `nft_expr_priv` is called on `expr` twice, so both reduce functions
> return true even when the operations differ.

Good catch, applied thanks
