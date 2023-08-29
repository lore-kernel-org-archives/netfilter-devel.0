Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F78C83F12
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 16:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbjH2QKr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 12:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjH2QKS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 12:10:18 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A885D1A6
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 09:10:14 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qb1IC-0002je-TQ
        for netfilter-devel@vger.kernel.org; Tue, 29 Aug 2023 18:10:12 +0200
Date:   Tue, 29 Aug 2023 18:10:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/4] tests: monitor: Fix monitor JSON output for
 insert command
Message-ID: <ZO4YZLjCaFl2IXki@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230829134812.31863-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230829134812.31863-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 29, 2023 at 03:48:09PM +0200, Phil Sutter wrote:
> Looks like commit ba786ac758fba ("tests: monitor: update insert and
> replace commands") missed to also fix expected JSON output.
> 
> Fixes: 48d20b8cf162e ("monitor: honor NLM_F_APPEND flag for rules")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
