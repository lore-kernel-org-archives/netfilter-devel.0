Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70234EB64DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jul 2023 10:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbjGNKQs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jul 2023 06:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbjGNKQk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jul 2023 06:16:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9071B3A9D
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jul 2023 03:16:11 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qKFqK-0008M8-Kf; Fri, 14 Jul 2023 12:16:08 +0200
Date:   Fri, 14 Jul 2023 12:16:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft v2 PATCH 1/3] nftables: add input flags for nft_ctx
Message-ID: <ZLEgaNIH/ZD4hnf3@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <ZKxG23yJzlRRPpsO@calendula>
 <20230714084943.1080757-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714084943.1080757-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 14, 2023 at 10:48:51AM +0200, Thomas Haller wrote:
[...]
> +=== nft_ctx_input_get_flags() and nft_ctx_input_set_flags()
> +The flags setting controls the input format.

Note how we turn on JSON input parsing if JSON output is enabled.

I think we could tidy things up by introducing NFT_CTX_INPUT_JSON and
flip it from nft_ctx_output_set_flags() to match NFT_CTX_OUTPUT_JSON for
compatibility?

Cheers, Phil
