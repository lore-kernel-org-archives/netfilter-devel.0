Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F33EDE9A0
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 10:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbjINKfR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 06:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbjINKfQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 06:35:16 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84411BFB
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 03:35:12 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qgjgl-00036N-5F
        for netfilter-devel@vger.kernel.org; Thu, 14 Sep 2023 12:35:11 +0200
Date:   Thu, 14 Sep 2023 12:35:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: shell: Fix for ineffective
 0007-mid-restore-flush_0
Message-ID: <ZQLh3+6eWML8waDc@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230914073116.29450-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914073116.29450-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 14, 2023 at 09:31:16AM +0200, Phil Sutter wrote:
> The test did not catch non-zero exit status of the spawned coprocess. To
> make it happen, Drop the line killing it (it will exit anyway) and pass
> its PID to 'wait'.
> 
> While being at it, put the sleep into the correct spot (otherwise the
> check for chain 'foo' existence fails as it runs too early) and make
> said chain existence check effective.
> 
> Fixes: 4e3c11a6f5a94 ("nft: Fix for ruleset flush while restoring")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
