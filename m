Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE6BC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Dec 2022 14:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238690AbiLNOss (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Dec 2022 09:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238363AbiLNOsp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Dec 2022 09:48:45 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD4C27904
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2022 06:48:42 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p5T3n-0003xd-Gm; Wed, 14 Dec 2022 15:48:39 +0100
Date:   Wed, 14 Dec 2022 15:48:39 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH v2 00/11] Support 'make dist' and 'make check'
Message-ID: <Y5niR2GubRx14BpX@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
References: <20221208154616.14622-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208154616.14622-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 08, 2022 at 04:46:05PM +0100, Phil Sutter wrote:
> The goal of this series is to replace the custom 'tarball' Makefile
> target by automake's standard 'dist' target. Due to the special
> non-automake extensions/GNUMakefile.in and some other minor details,
> this hasn't been functional.
> 
> Patches 1-6 are preparation work and cleanup of left-overs noticed when
> comparing final tarball contents.
> 
> Patches 7 and 8 then enable 'dist' and 'distcheck' targets.
> 
> Finally, patches 9 and 10 integrate testsuite scripts for use with 'make
> check'. The 'distcheck' target triggers them, too. But since one doesn't
> do that as uid 0, only xlate-test.py actually executes and the others
> are skipped.
> 
> Changes since v1:
> - Replace bashism in patch 3.
> - Generate .tar.xz instead of .tar.bz2 in patch 8.
> 
> Phil Sutter (11):
>   Drop INCOMPATIBILITIES file
>   Drop libiptc/linux_stddef.h
>   Makefile: Generate ip6tables man pages on the fly
>   extensions: Makefile: Merge initext targets
>   iptables/Makefile: Reorg variable assignments
>   iptables/Makefile: Split nft-variant man page list
>   Makefile: Fix for 'make distcheck'
>   Makefile: Generate .tar.xz archive with 'make dist'
>   include/Makefile: xtables-version.h is generated
>   tests: Adjust testsuite return codes to automake guidelines
>   Makefile.am: Integrate testsuites

Series applied.
