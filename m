Return-Path: <SRS0=BgG3=ZQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14772C432C0
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Nov 2019 23:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCE0D2075E
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Nov 2019 23:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfKXXw6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Nov 2019 18:52:58 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35657 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbfKXXw6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Nov 2019 18:52:58 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 17BCC3A0D96
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Nov 2019 10:52:41 +1100 (AEDT)
Received: (qmail 25966 invoked by uid 501); 24 Nov 2019 23:52:40 -0000
Date:   Mon, 25 Nov 2019 10:52:40 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 1/1] src: Comment-out code not needed
 since Linux 3.8 in examples/nf-queue.c
Message-ID: <20191124235240.GA19638@dimstar.local.net>
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191123051657.18308-1-duncan_roe@optusnet.com.au>
 <20191123051657.18308-2-duncan_roe@optusnet.com.au>
 <20191124144547.GB21689@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191124144547.GB21689@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8 a=xtERp6CFAAAA:8
        a=xthKl3bsZpgWqYLaS4AA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Floerian,

On Sun, Nov 24, 2019 at 03:45:47PM +0100, Florian Westphal wrote:
> Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > This makes it clear which lines are no longer required.
> > It also obviates the need to document NFQNL_CFG_CMD_PF_(UN)BIND.
>
> Why not simply #if 0 this code?

Simple reason: I think it's important to have an indicator on each commented-out
line that it is,in fact, commented-out.
>
> Or just delete it, v3.8 was released almost 7 years ago.

I could do that. But, I'm uneasy about it. There are systems around with very
old Linuxes - in May last year there was that Tomato Firmware non-issue and the
embedded environment was at 2.6!

Your call (or Pablo's) - I'm happy either way.

Cheers ... Duncan.

On Sun, 27 May 2018 01:02:46 -0400, Edriss Mirzadeh wrote:
> Hi there,
>
> I???m actually cross compiling Tomato Firmware using 64 bit Debian 9.
>
> The build instructions are good at the below URL, except for the repo name
> which recently changed but hasn???t yet been updated in the readme
> instructions.
>
> https://bitbucket.org/kille72/freshtomato-arm/src
>
> This could well be due to either the cross-compilation or the very old tool
> chain, or ancient kernel 2.6 (with many back ports), but I do agree that
> local headers should be double quoted, so your thought on patch rings true
> in terms of portability.
>
> Cheers!
