Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E03C04A6A
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Aug 2023 23:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjHDXnX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 19:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjHDXnW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 19:43:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3483AAF
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Aug 2023 16:43:21 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qS4S0-0000ET-8K
        for netfilter-devel@vger.kernel.org; Sat, 05 Aug 2023 01:43:20 +0200
Date:   Sat, 5 Aug 2023 01:43:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] extensions: libip6t_icmp: Add names for
 mld-listener types
Message-ID: <ZM2NGI0XOxep69I6@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230803150232.30741-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803150232.30741-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 03, 2023 at 05:02:32PM +0200, Phil Sutter wrote:
> Add the three names (plus one alias) just as in nftables.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1250
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
