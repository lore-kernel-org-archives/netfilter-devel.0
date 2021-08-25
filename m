Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095CDC4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 06:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3AF0613A7
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 06:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238160AbhHYGJ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 02:09:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49972 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbhHYGJ3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 02:09:29 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 06A0F60031
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 08:07:47 +0200 (CEST)
Date:   Wed, 25 Aug 2021 08:08:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v4 4/4] build: doc: split off shell
 script from within doxygen/Makefile.am
Message-ID: <20210825060838.GA818@salvia>
References: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
 <20210822041442.8394-4-duncan_roe@optusnet.com.au>
 <20210824103052.GC30322@salvia>
 <YSXDyR2RIKf675l6@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YSXDyR2RIKf675l6@slk1.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 25, 2021 at 02:15:05PM +1000, Duncan Roe wrote:
> On Tue, Aug 24, 2021 at 12:30:52PM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Aug 22, 2021 at 02:14:42PM +1000, Duncan Roe wrote:
> > > This time, Makefile obeys the script via its absolute source pathname rather
> > > than trying to force a copy into the build dir as we did previously.
> >
> > Could you make this in first place? As coming 1/x coming in this
> > series.
> >
> > Thanks.
> 
> Time to wrap up the whole lot in a single patch.
> 
> v5 was going to remove the make distcheck cruft in doxygen/Makefile.am, which is
> adjacent to the now-removed embedded script. So now there is juat 1 big block of
> red.
> 
> I reverted some non-essential changes in configure.ac to reduce the diff.
> 
> The new patch will be titled "Fix man pages".

At least two patches would be the best way to go for traceability:

#1 Move code to script.
#2 Your updates

The problem with code updates and moving code is that the diff patch
format is not very good at catching those together, since it makes it
look like code deleted plus new code.

Thanks!
