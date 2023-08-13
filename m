Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0DAC41513
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Aug 2023 16:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjHMQdi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Aug 2023 12:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbjHMQdd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Aug 2023 12:33:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA39E4B;
        Sun, 13 Aug 2023 09:33:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0954660C7D;
        Sun, 13 Aug 2023 16:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19698C433C7;
        Sun, 13 Aug 2023 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1691944413;
        bh=144iv3Vtni+8xIetQrxR2SbjUNKQr1hRvSHwIJPjJ0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IpQW+VW22omOKCKZjR9u55LV1Vmm/nLbEme8PN8Jcd62Z/dQ8O5Oab6b+HxB4/vqW
         C5SFrGF8MJ9RyqVclCC7iV4X6o4MWLk4dgzQoucofhlaCXjd934MQop478Yp5LcE0G
         ptTEHTMdyhrd39K7bULurqIoC0t7S7Fs6WrgohIc=
Date:   Sun, 13 Aug 2023 18:33:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: Re: [PATCH -stable,4.14 0/1] netfilter stable fix for 4.14
Message-ID: <2023081320-nacho-proofread-fb69@gregkh>
References: <20230812220941.56747-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230812220941.56747-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 13, 2023 at 12:09:40AM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This is a backport of:
> 
>   1689f25924ad ("netfilter: nf_tables: report use refcount overflow")
> 
> for -stable 4.14.
> 
> Please, apply.
> 
> Thanks.
> 
> Pablo Neira Ayuso (1):
>   netfilter: nf_tables: report use refcount overflow
> 
>  include/net/netfilter/nf_tables.h |  27 +++++-
>  net/netfilter/nf_tables_api.c     | 143 +++++++++++++++++++-----------
>  net/netfilter/nft_objref.c        |   8 +-
>  3 files changed, 119 insertions(+), 59 deletions(-)
> 
> --
> 2.30.2

All now queued up, thanks!

greg k-h
