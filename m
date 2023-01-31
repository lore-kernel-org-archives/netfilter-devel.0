Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1752AC38142
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Jan 2023 15:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjAaPaq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Jan 2023 10:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjAaPao (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Jan 2023 10:30:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FE2EC4B
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Jan 2023 07:30:43 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pMsan-0006gk-3g
        for netfilter-devel@vger.kernel.org; Tue, 31 Jan 2023 16:30:41 +0100
Date:   Tue, 31 Jan 2023 16:30:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/7] Small ebtables-translate review + extras
Message-ID: <Y9k0IaovCRoYIGl1@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230126122406.23288-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126122406.23288-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 26, 2023 at 01:23:59PM +0100, Phil Sutter wrote:
> The initial goal was to fix the apparent problem of ebtables-translate
> printing 'counter' statement in wrong position, namely after the
> verdict. Turns out this happened when targets were used "implicitly",
> i.e. without requesting them via '-j'. Since ebtables-nft loaded all
> extensions (including targets) upfront, a syntax like:
> 
> | # ebtables-nft -A FORWARD --mark-set 1
> 
> was accepted and valid. The 'mark' target in this case was added to
> iptables_command_state's 'match_list' as if it was a watcher.
> 
> Legacy ebtables does not allow this syntax, also it becomes hard for
> users to realize why two targets can't be used in the same rule. So
> reject this (in patch 2) and implicitly fix the case of 'counter'
> statement in wrong position.
> 
> Fixing the above caused some fallout: Patch 1 fixes error reporting of
> unknown arguments (or missing mandatory parameters) in all tools, patch
> 7 extends xlate-test.py to conveniently run for all libebt_*.txlate
> files (for instance).
> 
> The remaining patches 3 to 6 contain cleanups of xtables-eb-translate.c
> in comparison to xtables-eb.c, also kind of preparing for a merge of the
> two largely identical parsers (at least).
> 
> Phil Sutter (7):
>   Proper fix for "unknown argument" error message
>   ebtables: Refuse unselected targets' options
>   ebtables-translate: Drop exec_style
>   ebtables-translate: Use OPT_* from xshared.h
>   ebtables-translate: Ignore '-j CONTINUE'
>   ebtables-translate: Print flush command after parsing is finished
>   tests: xlate: Support testing multiple individual files

Series applied.
