Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB6AEDE99C
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 10:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbjINKg4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 06:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbjINKgz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 06:36:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CE11BF0
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 03:36:51 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qgjiM-00037s-65
        for netfilter-devel@vger.kernel.org; Thu, 14 Sep 2023 12:36:50 +0200
Date:   Thu, 14 Sep 2023 12:36:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] include: linux: Update kernel.h
Message-ID: <ZQLiQmtGoihFOYaM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230906170807.23100-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230906170807.23100-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 06, 2023 at 07:08:07PM +0200, Phil Sutter wrote:
> Its contents were moved into const.h and sysinfo.h, apply these changes
> to the cached copies. Fixes for the following warning when compiling
> xtables-monitor.c with new kernel headers in /usr/include:
> 
> | In file included from ../include/linux/netfilter/x_tables.h:3,
> |                  from ../include/xtables.h:19,
> |                  from xtables-monitor.c:36:
> | ../include/linux/kernel.h:7: warning: "__ALIGN_KERNEL" redefined
> |     7 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
> |       |
> | In file included from /usr/include/linux/netlink.h:5,
> |                  from /home/n0-1/git/libmnl/install/include/libmnl/libmnl.h:9,
> |                  from xtables-monitor.c:30:
> | /usr/include/linux/const.h:31: note: this is the location of the previous definition
> |    31 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
> |       |
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
