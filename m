Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12760C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 May 2022 17:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbiENREw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 May 2022 13:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiENREv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 May 2022 13:04:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6672D18E00
        for <netfilter-devel@vger.kernel.org>; Sat, 14 May 2022 10:04:50 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1npvCC-0007sK-KN; Sat, 14 May 2022 19:04:48 +0200
Date:   Sat, 14 May 2022 19:04:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Nick Hainke <vincent@systemli.org>
Cc:     netfilter-devel@vger.kernel.org,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Subject: Re: [PATCH iptables 1/2] xtables: fix compilation with musl
Message-ID: <Yn/hMODAkEEbzQno@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Nick Hainke <vincent@systemli.org>, netfilter-devel@vger.kernel.org,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
References: <20220514163325.54266-1-vincent@systemli.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220514163325.54266-1-vincent@systemli.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sat, May 14, 2022 at 06:33:24PM +0200, Nick Hainke wrote:
> Only include <linux/if_ether.h> if glibc is used.

This looks like a bug in musl? OTOH explicit include of linux/if_ether.h
was added in commit c5d9a723b5159 ("fix build for missing ETH_ALEN
definition"), despite netinet/ether.h being included in line 2248 of
libxtables/xtables.c. So maybe *also* a bug in bionic?!

Cheers, Phil
