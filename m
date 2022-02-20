Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CDAC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Feb 2022 00:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243289AbiBTAq3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 19:46:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241636AbiBTAq2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 19:46:28 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC835621D
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 16:46:09 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nLaMZ-0000TY-Nf; Sun, 20 Feb 2022 01:46:07 +0100
Date:   Sun, 20 Feb 2022 01:46:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/26] scanner: Some fixes, many new scopes
Message-ID: <YhGPT+Nbz9vZuKQO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220219132814.30823-1-phil@nwl.cc>
 <YhGMiKReUjPCyAai@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhGMiKReUjPCyAai@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Feb 20, 2022 at 01:34:16AM +0100, Pablo Neira Ayuso wrote:
> On Sat, Feb 19, 2022 at 02:27:48PM +0100, Phil Sutter wrote:
> > Patch 1 adds a test for 'ct count' statement, patches 2 and 3 fix some
> > keywords' scope, bulk scope introduction in the remaining ones.
> 
> Could you just push out the fixes in this batch?

Sure!

> My proposal is to release 1.0.2 with accumulated changes in master,
> then we follow up with more updates after the release.
> 
> I'd also like to push my automerge after the release too.

OK, cool. I'll push the fixes now and keep the scope bulk add for later.

Thanks, Phil
