Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D787C001B0
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jul 2023 13:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbjGSNGb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jul 2023 09:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjGSNGa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2023 09:06:30 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B351A6
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2023 06:06:29 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qM6st-0007BE-Tm
        for netfilter-devel@vger.kernel.org; Wed, 19 Jul 2023 15:06:27 +0200
Date:   Wed, 19 Jul 2023 15:06:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: shell: Sanitize
 nft-only/0009-needless-bitwise_0
Message-ID: <ZLff0+8Qoe2uPSIn@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230719130432.1306-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719130432.1306-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 19, 2023 at 03:04:32PM +0200, Phil Sutter wrote:
> Some versions of awk (gawk-4.2.1-4.el8 in particular) also print the
> non-debug ruleset listing's empty lines, causing the diff to fail. Catch
> this by exiting upon seeing the first table heading. For the sake of
> comparing bytecode, the actual ruleset listing is not interesting,
> anyway.
> 
> Fixes: 0f7ea0390b336 ("tests/shell: Fix nft-only/0009-needless-bitwise_0")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
