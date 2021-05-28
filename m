Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D06FC2B9F7
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 17:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 660CF61278
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 17:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhE1RMR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 May 2021 13:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbhE1RMR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 May 2021 13:12:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863CFC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 28 May 2021 10:10:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lmg0O-0002Ch-2i; Fri, 28 May 2021 19:10:40 +0200
Date:   Fri, 28 May 2021 19:10:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        netfilter-devel@vger.kernel.org, thomas.de_schampheleire@nokia.com
Subject: Re: [ebtables PATCH 2/2] configure.ac: add option
 --enable-kernel-64-userland-32
Message-ID: <20210528171040.GB30879@breakpoint.cc>
References: <20210518181730.13436-1-patrickdepinguin@gmail.com>
 <20210518181730.13436-2-patrickdepinguin@gmail.com>
 <20210524152621.GA21404@salvia>
 <CAAXf6LUhuPYksianL75_7n_OrkAhKXGojd2NGg8zNWnJrtEQJQ@mail.gmail.com>
 <20210527193030.GA6314@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527193030.GA6314@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > introduced with commit 47a6959fa331fe892a4fc3b48ca08e92045c6bda
> > (5.13-rc1). Before that point, it seems CONFIG_COMPAT was the relevant
> > flag.
> 
> Sorry, I got confused by this recent commit, it's indeed CONFIG_COMPAT
> the right toggle in old kernels.
> 
> > The checks on CONFIG_COMPAT were already introduced with commit
> > 81e675c227ec60a0bdcbb547dc530ebee23ff931 in 2.6.34.x.
> > 
> > I have seen this problem on Linux 4.1 and 4.9, on an Aarch64 CPU with
> > 64-bit kernel and userspace compiled as 32-bit ARM. In both kernels,
> > CONFIG_COMPAT was set.
> 
> Hm, then ebtables compat is buggy.

It was only ever tested with i686 binary on amd64 arch.

Thomas, does unmodified 32bit iptables work on those arch/kernel
combinations?

> > So I am a bit surprised that I bump into this issue after upgrading
> > ebtables from 2.0.10-4 to 2.0.11 where the padding was removed.
> > According to your mail and the commits mentioned, it is supposed to
> > work without ebtables making specific provisions for the 32/64 bit
> > type difference.

ebtables-userspace compat fixups predate the ebtables kernel side
support, it was autoenabled on sparc64 in the old makefile:

ifeq ($(shell uname -m),sparc64)
CFLAGS+=-DEBT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32
endif

I don't even know if the ebtables compat support is compiled in on
non-amd64.
