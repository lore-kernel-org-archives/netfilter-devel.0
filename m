Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE9BCD13D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 12:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbjIRM3e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 08:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241970AbjIRM3H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 08:29:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B983B5;
        Mon, 18 Sep 2023 05:28:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01981C433C8;
        Mon, 18 Sep 2023 12:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1695040137;
        bh=/zHWfRhhpSRxTBXH3tr4O5+a7KoRhJVWXPMMdPu8//s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pElYJfPpuHfl24j4ZRw6ZTvuejQelCFomSPBlJV/210KYH4EPSTIinDSTz1ew0twS
         TGlG+BW+2UqSRkxR9obicO9V0MKY+1leG85W+WpQOSuZuw5O+Lt2wk4kHKokIsVdcR
         Y7Kct5yo+Do9MN4KuHjW1Y9yiNzXQi6Yb4nHq6t0=
Date:   Mon, 18 Sep 2023 14:28:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: Re: [PATCH -stable,4.19 0/2] netfilter stable fixes for 4.19
Message-ID: <2023091843-luncheon-football-41be@gregkh>
References: <20230918120656.218135-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918120656.218135-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 18, 2023 at 02:06:54PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains a fixes for 4.19:
> 
> 1) Missing fix in 4.19, you can cherry-pick it from
>    8ca79606cdfd ("netfilter: nft_flow_offload: fix underflow in flowtable reference counter")
> 
> 2) Oneliner that includes missing chunk in 4.19 backport.
>    Fixes: 1df28fde1270 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain") in 4.19
>    This patch you have to manually apply it.

All now queued up, thanks.

greg k-h
