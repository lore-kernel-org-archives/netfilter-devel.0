Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF93CC3DA66
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Aug 2023 16:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbjHWQxm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Aug 2023 12:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234205AbjHWQxl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2023 12:53:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95521E5C
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2023 09:53:39 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qYr6w-0006z3-1j; Wed, 23 Aug 2023 18:53:38 +0200
Date:   Wed, 23 Aug 2023 18:53:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Stabilize
 sets/0043concatenated_ranges_0 test
Message-ID: <ZOY5kbIMO22TeIQw@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230823163315.4049-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823163315.4049-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 23, 2023 at 06:33:15PM +0200, Phil Sutter wrote:
> On a slow system, one of the 'delete element' commands would
> occasionally fail. Assuming it can only happen if the 2s timeout passes
> "too quickly", work around it by adding elements with a 2m timeout
> instead and when wanting to test the element expiry just drop and add
> the element again with a short timeout.
> 
> Fixes: 6231d3fa4af1e ("tests: shell: Fix for unstable sets/0043concatenated_ranges_0")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
