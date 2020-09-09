Return-Path: <SRS0=paBM=CS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287A3C433E2
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Sep 2020 12:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD49821D81
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Sep 2020 12:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgIIMdp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Sep 2020 08:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730077AbgIIMci (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Sep 2020 08:32:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89326C061573
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2020 05:23:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kFz8k-0002YN-QP; Wed, 09 Sep 2020 14:23:54 +0200
Date:   Wed, 9 Sep 2020 14:23:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Gopal Yadav <gopunop@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nftables] TODO: Replace yy_switch_to_buffer by
 yypop_buffer_state and yypush_buffer_state
Message-ID: <20200909122354.GP7319@breakpoint.cc>
References: <CAAUOv8iRkeAVDn3UK8DHju+-RvWViopGajN_+9y+Rm30pTWa+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAUOv8iRkeAVDn3UK8DHju+-RvWViopGajN_+9y+Rm30pTWa+A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Gopal Yadav <gopunop@gmail.com> wrote:
> Hi Netfilter Team,
> 
> I am looking to resolve a todo task in function yy_switch_to_buffer in
> nftables/src/scanner.c file.
> I am not familiar with lex but searching around I found that scanner.c
> is produced by lex according to the scanner.l file.
> Therefore my guess is, changing the scanner.c file directly is not the
> solution, right?

Right.

> Changes would have to be done in scanner.l, right?

No.

> How should I proceed to complete this todo?

This TODO is coming from flex itself, so, this is not an nftables
task.

> I browsed bugzilla to find some other issues to solve, but I feel
> lost. Are there any beginner friendly issues to solve or any other
> starting point?

This one for example:
https://bugzilla.netfilter.org/show_bug.cgi?id=1305

Its "just" a documentation issue.  You could work from comment 4
and improve the nft documentation to clarify 'accept' behaviour.

For many other bugs it would help if we had testcases that demonstrated
this problem in the nftables.git repo.

So, if you can translate a BZ ticker to e.g. a new test case in
tests/shell that show problem still exists in current nftables.git then
you could submit that test case as a patch, even if the problem is not
yet resolved.

Readily available test reproducers help a lot.
