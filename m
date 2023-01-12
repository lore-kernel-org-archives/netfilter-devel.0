Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0240BC677F1
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 14:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbjALO2Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbjALO1y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 09:27:54 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8EA574EB
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 06:18:43 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pFyPi-0006YJ-6G
        for netfilter-devel@vger.kernel.org; Thu, 12 Jan 2023 15:18:42 +0100
Date:   Thu, 12 Jan 2023 15:18:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] extensions: NAT: Fix for -Werror=format-security
Message-ID: <Y8AWwpyCAut9tXMM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230112140303.17986-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112140303.17986-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 12, 2023 at 03:03:03PM +0100, Phil Sutter wrote:
> Have to pass either a string literal or format string to xt_xlate_add().
> 
> Fixes: f30c5edce0413 ("extensions: Merge SNAT, DNAT, REDIRECT and MASQUERADE")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
