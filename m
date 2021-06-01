Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3335C47080
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 14:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93E52611CB
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 14:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhFAOwB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Jun 2021 10:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbhFAOwB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Jun 2021 10:52:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405E2C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Jun 2021 07:50:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lo5ii-0001OO-V1; Tue, 01 Jun 2021 16:50:17 +0200
Date:   Tue, 1 Jun 2021 16:50:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas De Schampheleire <patrickdepinguin@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, thomas.de_schampheleire@nokia.com
Subject: Re: [ebtables PATCH 2/2] configure.ac: add option
 --enable-kernel-64-userland-32
Message-ID: <20210601145016.GA5183@breakpoint.cc>
References: <20210518181730.13436-1-patrickdepinguin@gmail.com>
 <20210518181730.13436-2-patrickdepinguin@gmail.com>
 <20210524152621.GA21404@salvia>
 <CAAXf6LUhuPYksianL75_7n_OrkAhKXGojd2NGg8zNWnJrtEQJQ@mail.gmail.com>
 <20210527193030.GA6314@salvia>
 <20210528171040.GB30879@breakpoint.cc>
 <CAAXf6LXNjUpE8_f2t8a+18ovWM67JXxt=JAxskkERoRaX+664g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAXf6LXNjUpE8_f2t8a+18ovWM67JXxt=JAxskkERoRaX+664g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas De Schampheleire <patrickdepinguin@gmail.com> wrote:
> 1.  x86_64 kernel 5.4.x + i686 userspace: ebtables works correctly
> 
> 2.  aarch64 kernel 4.1.x + 32-bit ARM userspace: ebtables fails as described
> 
> As mentioned before, in both cases CONFIG_COMPAT=y .
> >
> > Thomas, does unmodified 32bit iptables work on those arch/kernel
> > combinations?
> 
> Yes, iptables 1.8.6 is used successfully without special provisioning
> for bitness. We are using Buildroot 2021.02 to compile.

Ok, so this is 'just' a bug in the ebtables translation layer.

Its likely that there are alignment differences on aarch that the
ebtables i686 fixups are not aware of.

> > ebtables-userspace compat fixups predate the ebtables kernel side
> > support, it was autoenabled on sparc64 in the old makefile:
> >
> > ifeq ($(shell uname -m),sparc64)
> > CFLAGS+=-DEBT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32
> > endif
> 
> Yes, in the proposed changes to ebtables userspace, this kind of logic
> is restored, but not based on the machine type but with an autoconf
> flag.
> 
> >
> > I don't even know if the ebtables compat support is compiled in on
> > non-amd64.
> 
> Can you be more specific what you are referring to here?

I meant I wasn't sure if the ebtables compat stuff is compiled in on
non-amd64 platforms.  But I guess they are because iptables works for
you.

> So at this moment it seems to me that the kernel compat support is
> effectively compiled in, and supports x86(_64) but does not support
> the Aarch64/ARM combination (and perhaps others).
> 
> How to proceed now?

The proper solution is to make the existing translation work on aarch64.

It will take me some time to get a crosscompiler+qemu setup going
though.
