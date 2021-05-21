Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA51C433B4
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 08:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 576836135B
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 08:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhEUIDw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 May 2021 04:03:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:51876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233517AbhEUICe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 May 2021 04:02:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621584060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bwcz9Nqr8X25ySpTdVKajdrwsi73OCWjpPXard/wqOA=;
        b=bGHNWqMb2hjN0ify4qbhUxo+6K9/yNt8GLaJYTIGAYanLWGbaAxfWwvwoRRqjU3CgeNzgJ
        SamfdH/sO+j+7oNKHSmdWzLyLPc11aobsz8XO4Q7U8lqHHJlCtilUOQYc4w4eHR7xAzhT6
        gh/m7k7JF3xM2bdNKLawdSUrUzTamSM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 58FDAAB64;
        Fri, 21 May 2021 08:01:00 +0000 (UTC)
Date:   Fri, 21 May 2021 10:00:59 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Avoid potentially erroneos RST drop.
Message-ID: <20210521080059.bxck6smka7yehjbm@Fryzen495>
References: <20210430093601.zibczc4cjnwx3qwn@Fryzen495>
 <YJL30q7mCUezag48@strlen.de>
 <20210519120749.gd32rnaaz6q2kggr@Fryzen495>
 <20210519122332.GD8317@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210519122332.GD8317@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 19.05.2021 14:23, Florian Westphal wrote:
> > Hi Florian, I tested your patch and it solved the issue, no more NFS
> > hangs due to dropped RSTs. Please include it, together with the
> > following two patches I previously sent:
> > 
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210428130911.cteglt52r5if7ynp@Fryzen495/
> 
> Do we still need this one after this revised patch?
> If we do, the help text has to be fixed, after your patch, be-liberal
> turns off all sequence number/window checks.  The revised text implies
> it only has to do with RSTs.
> 
> Alternative would be to add another sysctl, or turn the existing sysctl
> into integer (0, off, 1 current behaviour (sequence check on for rst
> only, 2 off for everything).

I would still like to make the RST sequence number check optional.  I
think it is a good idea to use 0, 1 and > 1 off for everything, keeping
this way the current behaviour when tcp_be_liberal is set to 1.

I will send another patch with also revised text.

Many thanks.
Ali
