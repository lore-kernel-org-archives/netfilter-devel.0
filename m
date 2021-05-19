Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71987C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 12:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39BB161353
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 12:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241424AbhESMY5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 May 2021 08:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347770AbhESMYz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 May 2021 08:24:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465F6C06175F
        for <netfilter-devel@vger.kernel.org>; Wed, 19 May 2021 05:23:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ljLEa-0006ZP-Fa; Wed, 19 May 2021 14:23:32 +0200
Date:   Wed, 19 May 2021 14:23:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ali Abdallah <ali.abdallah@suse.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Avoid potentially erroneos RST drop.
Message-ID: <20210519122332.GD8317@breakpoint.cc>
References: <20210430093601.zibczc4cjnwx3qwn@Fryzen495>
 <YJL30q7mCUezag48@strlen.de>
 <20210519120749.gd32rnaaz6q2kggr@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519120749.gd32rnaaz6q2kggr@Fryzen495>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ali Abdallah <ali.abdallah@suse.com> wrote:
> On 05.05.2021 21:53, Florian Westphal wrote:
> > Ali, sorry for coming back to this again and again.
> > 
> > What do you think of this change?
> 
> Hi Florian, I tested your patch and it solved the issue, no more NFS
> hangs due to dropped RSTs. Please include it, together with the
> following two patches I previously sent:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210428130911.cteglt52r5if7ynp@Fryzen495/

Do we still need this one after this revised patch?
If we do, the help text has to be fixed, after your patch, be-liberal
turns off all sequence number/window checks.  The revised text implies
it only has to do with RSTs.

Alternative would be to add another sysctl, or turn the existing sysctl
into integer (0, off, 1 current behaviour (sequence check on for rst
only, 2 off for everything).

> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210430093601.zibczc4cjnwx3qwn@Fryzen495/

I will send this patch for inclusion tomorrow or later today.

Pablo, please mark both patches as "Changes Requested".

I will deal with the 2nd patch and will resend it, with the more liberal
handing of RST when conntrack entry is closing.

Ali, if you still think the first patch is required please submit a new
version with at least a revised help text.
