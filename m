Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065D3C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Mar 2022 17:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiCARZg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Mar 2022 12:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiCARZg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Mar 2022 12:25:36 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7560753706
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2022 09:24:54 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nP6F1-0007mP-7u; Tue, 01 Mar 2022 18:24:51 +0100
Date:   Tue, 1 Mar 2022 18:24:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/26] scanner: Some fixes, many new scopes
Message-ID: <Yh5W42dNE1YxTi2s@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220219132814.30823-1-phil@nwl.cc>
 <YhGMiKReUjPCyAai@salvia>
 <Yh1BMz9cW/yb6CR7@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh1BMz9cW/yb6CR7@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 28, 2022 at 10:40:03PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Feb 20, 2022 at 01:34:20AM +0100, Pablo Neira Ayuso wrote:
> > On Sat, Feb 19, 2022 at 02:27:48PM +0100, Phil Sutter wrote:
> > > Patch 1 adds a test for 'ct count' statement, patches 2 and 3 fix some
> > > keywords' scope, bulk scope introduction in the remaining ones.
> > 
> > Could you just push out the fixes in this batch?
> > 
> > My proposal is to release 1.0.2 with accumulated changes in master,
> > then we follow up with more updates after the release.
> 
> I think it's fine to merge this to master now that 1.0.2 has been
> released.

Pushed the series after a rebase and successful py testsuite run for
sanity. Thanks for the heads-up!

Cheers, Phil
