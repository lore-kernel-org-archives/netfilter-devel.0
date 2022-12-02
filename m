Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1564DC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Dec 2022 00:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiLBAqg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 19:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiLBAqf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 19:46:35 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0ECA1A07
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 16:46:35 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p0uCH-0007Ew-L9
        for netfilter-devel@vger.kernel.org; Fri, 02 Dec 2022 01:46:33 +0100
Date:   Fri, 2 Dec 2022 01:46:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/9] Fix for shell testsuite '-V' option
Message-ID: <Y4lK6bZcR8vNQlXk@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20221130191345.14543-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130191345.14543-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 30, 2022 at 08:13:36PM +0100, Phil Sutter wrote:
> When running the testsuite in "valgrind mode", numerous cases of lost
> memory and still reachable at program exit are reported. Address them
> all plus libiptc's access of uninitialized memory.
> 
> Phil Sutter (9):
>   tests: shell: Fix valgrind mode for 0008-unprivileged_0
>   iptables-restore: Free handle with --test also
>   iptables-xml: Free allocated chain strings
>   nft: Plug memleak in nft_rule_zero_counters()
>   iptables: Plug memleaks in print_firewall()
>   xtables: Introduce xtables_clear_iptables_command_state()
>   iptables: Properly clear iptables_command_state object
>   xshared: Free data after printing help
>   libiptc: Eliminate garbage access

Series applied.
