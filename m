Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0B4C4707F
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 19:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 507F3613E5
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 19:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbhE0TcS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 15:32:18 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39382 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbhE0TcH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 15:32:07 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2EE2564504;
        Thu, 27 May 2021 21:29:31 +0200 (CEST)
Date:   Thu, 27 May 2021 21:30:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas De Schampheleire <patrickdepinguin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, thomas.de_schampheleire@nokia.com
Subject: Re: [ebtables PATCH 2/2] configure.ac: add option
 --enable-kernel-64-userland-32
Message-ID: <20210527193030.GA6314@salvia>
References: <20210518181730.13436-1-patrickdepinguin@gmail.com>
 <20210518181730.13436-2-patrickdepinguin@gmail.com>
 <20210524152621.GA21404@salvia>
 <CAAXf6LUhuPYksianL75_7n_OrkAhKXGojd2NGg8zNWnJrtEQJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAXf6LUhuPYksianL75_7n_OrkAhKXGojd2NGg8zNWnJrtEQJQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 25, 2021 at 01:52:27PM +0200, Thomas De Schampheleire wrote:
> Hello,
> 
> El lun, 24 may 2021 a las 17:26, Pablo Neira Ayuso
> (<pablo@netfilter.org>) escribió:
> >
> > On Tue, May 18, 2021 at 08:17:30PM +0200, Thomas De Schampheleire wrote:
> > > From: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
> > >
> > > The ebtables build system seems to assume that 'sparc64' is the
> > > only case where KERNEL_64_USERSPACE_32 is relevant, but this is not true.
> > > This situation can happen on many architectures, especially in embedded
> > > systems. For example, an Aarch64 processor with kernel in 64-bit but
> > > userland built for 32-bit Arm. Or a 64-bit MIPS Octeon III processor, with
> > > userland running in the 'n32' ABI.
> > >
> > > While it is possible to set CFLAGS in the environment when calling the
> > > configure script, the caller would need to know to not only specify
> > > KERNEL_64_USERSPACE_32 but also the EBT_MIN_ALIGN value.
> > >
> > > Instead, add a configure option. All internal details can then be handled by
> > > the configure script.
> >
> > Are you enabling
> >
> > CONFIG_NETFILTER_XTABLES_COMPAT
> >
> > in your kernel build?
> >
> > KERNEL_64_USERSPACE_32 was deprecated long time ago in favour of
> > CONFIG_NETFILTER_XTABLES_COMPAT.
> 
> The option you refer to (CONFIG_NETFILTER_XTABLES_COMPAT) was
> introduced with commit 47a6959fa331fe892a4fc3b48ca08e92045c6bda
> (5.13-rc1). Before that point, it seems CONFIG_COMPAT was the relevant
> flag.

Sorry, I got confused by this recent commit, it's indeed CONFIG_COMPAT
the right toggle in old kernels.

> The checks on CONFIG_COMPAT were already introduced with commit
> 81e675c227ec60a0bdcbb547dc530ebee23ff931 in 2.6.34.x.
> 
> I have seen this problem on Linux 4.1 and 4.9, on an Aarch64 CPU with
> 64-bit kernel and userspace compiled as 32-bit ARM. In both kernels,
> CONFIG_COMPAT was set.

Hm, then ebtables compat is buggy.

> So I am a bit surprised that I bump into this issue after upgrading
> ebtables from 2.0.10-4 to 2.0.11 where the padding was removed.
> According to your mail and the commits mentioned, it is supposed to
> work without ebtables making specific provisions for the 32/64 bit
> type difference.
> 
> When I apply the patches I submitted to this list, I get correct
> behavior. Without them, the kernel complains and ebtables fails.

I understand. If this old userspace infrastructure is restored, then
ebtables compat kernel might not ever be fixed.
