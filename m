Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F180EB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 16:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjGJQWO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 12:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjGJQWN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 12:22:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9069094
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 09:22:11 -0700 (PDT)
Date:   Mon, 10 Jul 2023 18:22:08 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH 0/4] libnftables: minor cleanups initalizing nf_sock
 instance of nft_ctx
Message-ID: <ZKwwMCk1AsIYr3Mz@calendula>
References: <20230710084926.172198-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230710084926.172198-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 10, 2023 at 10:45:15AM +0200, Thomas Haller wrote:
> There is some unnecessary or redundant code in "src/libnftables.c".
> Clean up.
> 
> This was motivated by an attempt to add a new flag for nft_ctx_new(),
> beside NFT_CTX_DEFAULT. The current "if (flags == NFT_CTX_DEFAULT)"
> check is an odd usage for flags (because we would want that behavior for
> all flags).

Series applied, thanks
