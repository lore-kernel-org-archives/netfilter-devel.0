Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5DCEDE99C
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 10:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbjINKeG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 06:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbjINKeG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 06:34:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7721BF0
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 03:34:02 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qgjfc-00034V-BF; Thu, 14 Sep 2023 12:34:00 +0200
Date:   Thu, 14 Sep 2023 12:34:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Quentin Armitage <quentin@armitage.org.uk>
Subject: Re: [iptables PATCH] extensions: Fix checking of conntrack --ctproto
 0
Message-ID: <ZQLhmJ0DlrMw+yg4@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org,
        Quentin Armitage <quentin@armitage.org.uk>
References: <20230914072936.29097-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914072936.29097-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 14, 2023 at 09:29:36AM +0200, Phil Sutter wrote:
> From: Quentin Armitage <quentin@armitage.org.uk>
> 
> There are three issues in the code:
> 1) the check (sinfo->invflags & XT_INV_PROTO) is using the wrong mask
> 2) in conntrack_mt_parse it is testing (info->invert_flags &
>    XT_INV_PROTO) before the invert bit has been set.
> 3) the sense of the error message is the wrong way round
> 
> 1) To get the error, ! -ctstatus XXX has to be specified, since
>    XT_INV_PROTO == XT_CONNTRACK_STATUS e.g.
>    | iptables -I CHAIN -m conntrack ! --ctstatus ASSURED --ctproto 0 ...
> 
> 3) Unlike --proto 0 (where 0 means all protocols), in the conntrack
>    match --ctproto 0 appears to mean protocol 0, which can never be.
>    Therefore --ctproto 0 could never match and ! --ctproto 0 will always
>    match. Both of these should be rejected, since the user clearly
>    cannot be intending what was specified.
> 
> The attached patch resolves the issue, and also produces an error
> message if --ctproto 0 is specified (as well as ! --ctproto 0 ), since
> --ctproto 0 will never match, and ! --ctproto 0 will always match.
> 
> [Phil: - Added Fixes: tag - it's a day 1 bug
>        - Copied patch description from Bugzilla
>        - Reorganized changes to reduce diff
>        - Added test cases]
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=874
> Fixes: 5054e85be3068 ("general conntrack match module userspace support files")
> Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
