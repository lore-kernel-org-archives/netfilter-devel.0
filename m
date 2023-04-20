Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E72C7618E
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Apr 2023 21:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjDTVPO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Apr 2023 17:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDTVPN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2023 17:15:13 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A0044AF
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2023 14:15:11 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ppbcS-0004fE-Te; Thu, 20 Apr 2023 23:15:08 +0200
Date:   Thu, 20 Apr 2023 23:15:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [nft PATCH] tests: shell: Fix for unstable
 sets/0043concatenated_ranges_0
Message-ID: <ZEGrXBExRk7hwdyJ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>
References: <20230420154723.27089-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420154723.27089-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 20, 2023 at 05:47:23PM +0200, Phil Sutter wrote:
> On my (slow?) testing VM, The test tends to fail when doing a full run
> (i.e., calling run-test.sh without arguments) and tends to pass when run
> individually.
> 
> The problem seems to be the 1s element timeout which in some cases may
> pass before element deletion occurs. Simply fix this by doubling the
> timeout. It has to pass just once, so shouldn't hurt too much.
> 
> Fixes: 618393c6b3f25 ("tests: Introduce test for set with concatenated ranges")
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
