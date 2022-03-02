Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41F5C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 13:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242448AbiCBNwP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 08:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242611AbiCBNwA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 08:52:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB45C5DB9
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 05:50:59 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nPPNZ-0002GK-Vi; Wed, 02 Mar 2022 14:50:58 +0100
Date:   Wed, 2 Mar 2022 14:50:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/26] scanner: Some fixes, many new scopes
Message-ID: <Yh92QZs8Fiwzcq3h@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220219132814.30823-1-phil@nwl.cc>
 <YhGMiKReUjPCyAai@salvia>
 <Yh1BMz9cW/yb6CR7@salvia>
 <Yh5W42dNE1YxTi2s@orbyte.nwl.cc>
 <Yh6LGYMboF8/b65Q@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh6LGYMboF8/b65Q@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Mar 01, 2022 at 10:07:37PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 01, 2022 at 06:24:51PM +0100, Phil Sutter wrote:
> > On Mon, Feb 28, 2022 at 10:40:03PM +0100, Pablo Neira Ayuso wrote:
> > > On Sun, Feb 20, 2022 at 01:34:20AM +0100, Pablo Neira Ayuso wrote:
> > > > On Sat, Feb 19, 2022 at 02:27:48PM +0100, Phil Sutter wrote:
> > > > > Patch 1 adds a test for 'ct count' statement, patches 2 and 3 fix some
> > > > > keywords' scope, bulk scope introduction in the remaining ones.
> > > > 
> > > > Could you just push out the fixes in this batch?
> > > > 
> > > > My proposal is to release 1.0.2 with accumulated changes in master,
> > > > then we follow up with more updates after the release.
> > > 
> > > I think it's fine to merge this to master now that 1.0.2 has been
> > > released.
> > 
> > Pushed the series after a rebase and successful py testsuite run for
> > sanity. Thanks for the heads-up!
> 
> shell testsuite reports problems:
> 
> results: [OK] 298 [FAILED] 3 [TOTAL] 301

Ah, sorry. I falsely assumed py testsuite would cover anything
syntax-related. I just sent a fix.

> These test breaks with syntax errors.
> 
> Please, also run monitor and json_echo tests.

Luckily, both passed.

Sorry, Phil
