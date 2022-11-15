Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48FBC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Nov 2022 16:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiKOQhh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 11:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiKOQhg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 11:37:36 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36317BE25
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2022 08:37:36 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ouywI-0001bE-KY
        for netfilter-devel@vger.kernel.org; Tue, 15 Nov 2022 17:37:34 +0100
Date:   Tue, 15 Nov 2022 17:37:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] Drop extra newline from xtables_error() calls
Message-ID: <Y3PATta+GI1dOe6b@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20221112005710.5778-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112005710.5778-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 12, 2022 at 01:57:10AM +0100, Phil Sutter wrote:
> Since basic_exit_err() appends a newline to the message itself, drop
> explicit ones.
> 
> While being at it, fix indentation and join texts split over multiple
> lines.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Applied after dropping changes to libipt_icmp.c and libip6t_icmp6.c
since the relevant code was removed by commit be8c605604084
("extensions: Unify ICMP parser into libxt_icmp.h").
