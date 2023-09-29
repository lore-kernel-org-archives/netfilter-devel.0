Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C60DE728CF
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 18:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbjI2SHQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 14:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjI2SHP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 14:07:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF961B6
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 11:07:13 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qmHtP-0004Pk-I2; Fri, 29 Sep 2023 20:07:11 +0200
Date:   Fri, 29 Sep 2023 20:07:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: sets/reset_command_0: Fix
 drop_seconds()
Message-ID: <ZRcST0xX9LuQbsNU@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230929180345.19037-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929180345.19037-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 29, 2023 at 08:03:44PM +0200, Phil Sutter wrote:
> The function print_times() skips any time elements which are zero, so
> output may lack the ms part. Adjust the sed call dropping anything but
> the minutes value to not fail in that case.
> 
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Fixes: 255ec36a11525 ("tests: shell: Stabilize sets/reset_command_0 test")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
