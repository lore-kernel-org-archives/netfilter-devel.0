Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A173C41513
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 08:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjHBIb0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 04:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjHBIb0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 04:31:26 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1D2171D
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 01:31:23 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 4D8F45872FA13; Wed,  2 Aug 2023 10:31:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 4CE2460C29143;
        Wed,  2 Aug 2023 10:31:16 +0200 (CEST)
Date:   Wed, 2 Aug 2023 10:31:16 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org, Amelia Downs <adowns@vmware.com>
Subject: Re: [iptables PATCH 1/3] extensions: libipt_icmp: Fix confusion
 between 255/255 and any
In-Reply-To: <20230802020547.28886-1-phil@nwl.cc>
Message-ID: <s4402816-ros7-qqoq-73r0-147po5s5862p@vanv.qr>
References: <20230802020547.28886-1-phil@nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2023-08-02 04:05, Phil Sutter wrote:
>
>It is not entirely clear what the fixed commit was trying to establish,
>but the save output is certainly not correct (especially since print
>callback gets things right).
>
>Fixes: fc9237da4e845 ("Fix '-p icmp -m icmp' issue (Closes: #37)")

"""(libipt_icmp.c):
 * Up to kernel <=2.4.20 the problem was:
 * '-p icmp ' matches all icmp packets
 * '-p icmp -m icmp' matches _only_ ICMP type 0 :(
 * This is now fixed by initializing the field * to icmp type 0xFF
"""

But also:

v1.2.7a-35-gfc9237da missed touching *libip6t_icmp6.c*, so
it was never updated with the same "bug".

In icmp6, --icmpv6-type was (and still is to this date) mandatory, which means
`-p icmp6 -m icmp6` would *not* implicitly go match ICMP(v6) type 0 like its
IPv4 counterpart.

Then, in v1.4.10-115-g1b8db4f4, libipt_icmp.c more or less accidentally gained
XTOPT_MAND (possible spill from IPv6 code), therefore `-p icmp -m icmp` would
also stop implicitly doing ICMP type "any".
