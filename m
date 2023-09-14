Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CCDEDE99C
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 10:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237318AbjINKfn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 06:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbjINKfm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 06:35:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC581BEB
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 03:35:38 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qgjhB-00036X-5F
        for netfilter-devel@vger.kernel.org; Thu, 14 Sep 2023 12:35:37 +0200
Date:   Thu, 14 Sep 2023 12:35:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Fix for useless meta expressions in rule
Message-ID: <ZQLh+edSOua2amkP@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230906170751.23040-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230906170751.23040-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 06, 2023 at 07:07:51PM +0200, Phil Sutter wrote:
> A relict of legacy iptables' mandatory matching on interfaces and IP
> addresses is support for the '-i +' notation, basically a "match any
> input interface". Trying to make things better than its predecessor,
> iptables-nft boldly optimizes that nop away - not entirely though, the
> meta expression loading the interface name was left in place. While not
> a problem (apart from pointless overhead) in current HEAD, v1.8.7 would
> trip over this as a following cmp expression (for another match) was
> incorrectly linked to that stale meta expression, loading strange values
> into the respective interface name field.
> 
> While being at it, merge and generalize the functions into a common one
> for use with ebtables' NFT_META_BRI_(I|O)IFNAME matches, too.
> 
> Fixes: 0a8635183edd0 ("xtables-compat: ignore '+' interface name")
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1702
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
