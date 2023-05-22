Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82345C77B75
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 May 2023 17:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbjEVRuw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 May 2023 13:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjEVRuv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 May 2023 13:50:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD63FA;
        Mon, 22 May 2023 10:50:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20E98622B0;
        Mon, 22 May 2023 17:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57494C433EF;
        Mon, 22 May 2023 17:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684777847;
        bh=9q4AZFNIos4l/XUurkzGQgAQjQCdSUI92QqPuypIlUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aM3JsaOKj/Rc+y0ez/fZOJKeI/nXgbLiDA+z1pGooZA6y98xek1buEUGqgY1DHF4r
         5pVPP0C/niBTU4OTHFIxhaflNRC+OHiPpORcHmLY21CxHAUenpKKIB4ZNuSQcvZJZ3
         ZBvJVRSxvS811vvGGuU1K0V9Kx9TD9wTHImicBsmggi2cegCxzlmb/K3VLScVIHL2g
         bk2pEngUKlzcxaPJmoKbOkMLiTBdqXhEcR0SpiM+QAEyZX7EQFThdJRH7CsGXweF52
         66Xf3AuLW6ftbP7HuSmuEsYvrfdhFDc5EsyJ2GwvJcqXvAF+Q+zUVlcPuxrzlZD6AW
         T7W0PGXaqE2vw==
Date:   Mon, 22 May 2023 13:50:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: Patch for -stable, 6.3.x
Message-ID: <ZGurdlwawzvZYkBS@sashalap>
References: <ZGL/S2D68bm29hC4@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZGL/S2D68bm29hC4@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 16, 2023 at 05:58:03AM +0200, Pablo Neira Ayuso wrote:
>Hi Greg, Sasha,
>
>Could you cherry-pick the follow patch into 6.3.x? Thanks.
>
>commit f057b63bc11d86a98176de31b437e46789f44d8f
>Author: Florian Westphal <fw@strlen.de>
>Date:   Wed May 3 12:00:18 2023 +0200
>
>    netfilter: nf_tables: fix ct untracked match breakage
>
>    "ct untracked" no longer works properly due to erroneous NFT_BREAK.
>    We have to check ctinfo enum first.
>
>    Fixes: d9e789147605 ("netfilter: nf_tables: avoid retpoline overhead for some ct expression calls")
>    Reported-by: Rvfg <i@rvf6.com>
>    Link: https://marc.info/?l=netfilter&m=168294996212038&w=2
>    Signed-off-by: Florian Westphal <fw@strlen.de>
>    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Looks like it's been picked up, thanks!

-- 
Thanks,
Sasha
