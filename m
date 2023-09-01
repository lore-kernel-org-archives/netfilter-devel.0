Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108FFCA0FE1
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Sep 2023 11:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349303AbjIAL62 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Sep 2023 07:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349289AbjIAL62 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2023 07:58:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776AAE7F
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 04:58:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qc2n5-0006gH-2d; Fri, 01 Sep 2023 13:58:19 +0200
Date:   Fri, 1 Sep 2023 13:58:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC] tests: add feature probing
Message-ID: <20230901115819.GJ15759@breakpoint.cc>
References: <20230831135112.30306-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831135112.30306-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> +check_features()
> +{
> +	for ffilename in features/*.nft; do
> +		feature=${ffilename#*/}
> +		feature=${feature%*.nft}
> +		eval NFT_HAVE_${feature}=0
> +		$NFT -f "$ffilename" 2>/dev/null

This is broken if run-tests.sh is not invoked inside
tests/shell, I've fixed this up.

Meanwhile I added probe for netdev-chains-without-device and SKIPPED
support:

I: [OK]         ././testcases/chains/0044chain_destroy_0
I: [SKIPPED]    ././testcases/chains/netdev_chain_0
I: [OK]         ././testcases/comments/comments_0

My plan is to keep adding more probe files locally until ./run-tests.sh
passes on 5.14-patched-kernel and then send the batch.

I've also changed the probe files to contain the upstream patch
and its upstream kernel version as a comment.
