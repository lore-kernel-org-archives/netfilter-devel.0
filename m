Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29040C48BC2
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 17:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C515611AC
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 17:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhFWR2m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 13:28:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33682 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWR2m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 13:28:42 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D6A5064252;
        Wed, 23 Jun 2021 19:24:58 +0200 (CEST)
Date:   Wed, 23 Jun 2021 19:26:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl 1/1] build: doc: "make" builds & installs a full
 set of man pages
Message-ID: <20210623172621.GA25266@salvia>
References: <20210622041933.25654-1-duncan_roe@optusnet.com.au>
 <20210622041933.25654-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210622041933.25654-2-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 22, 2021 at 02:19:33PM +1000, Duncan Roe wrote:
> Repeat what we did for libnetfilter_queue:
>  - New makefile in doxygen directory. Rebuilds documentation if any sources
>    change that contain doxygen comments:
>    - Renames each group man page to the first function listed therein
>    - Creates symlinks for subsequently listed functions
>    - Deletes _* temp files and moves sctruct-describing man pages to man7
>  - Update top-level makefile to visit new subdir doxygen
>  - Update top-level configure to only build documentation if doxygen installed
>  - Add --with/without-doxygen switch
>  - Check whether dot is available when configuring doxygen
>  - Reduce size of doxygen.cfg and doxygen build o/p
>  - `make distcheck` passes with doxygen enabled
> Aditionally, exclude opaque structs mnl_nlmsg_batch & mnl_socket

Applied, thanks.

One thing that needs a fix (both libnetfilter_queue and libmnl).

If doxygen is not installed...

configure: WARNING: Doxygen not found - continuing without Doxygen support

it warns that it is missing...

checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating Makefile
config.status: creating src/Makefile
config.status: creating include/Makefile
config.status: creating include/libmnl/Makefile
config.status: creating include/linux/Makefile
config.status: creating include/linux/netfilter/Makefile
config.status: creating examples/Makefile
config.status: creating examples/genl/Makefile
config.status: creating examples/kobject/Makefile
config.status: creating examples/netfilter/Makefile
config.status: creating examples/rtnl/Makefile
config.status: creating libmnl.pc
config.status: creating doxygen.cfg
config.status: creating doxygen/Makefile
config.status: creating config.h
config.status: config.h is unchanged
config.status: executing depfiles commands
config.status: executing libtool commands

libmnl configuration:
  doxygen:          yes

but it says yes here.

I'd prefer if documentation is not enabled by default, ie. users have
to explicitly specify --with-doxygen=yes to build documentation, so
users explicitly picks what they needs.

Please, follow up with a few patches, thanks.
