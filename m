Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E12C001DF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 12:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbjHCM5q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 08:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235447AbjHCM5p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 08:57:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717441BFA
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 05:57:40 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qRXta-0004TL-FH; Thu, 03 Aug 2023 14:57:38 +0200
Date:   Thu, 3 Aug 2023 14:57:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org, Amelia Downs <adowns@vmware.com>
Subject: Re: [iptables PATCH 1/3] extensions: libipt_icmp: Fix confusion
 between 255/255 and any
Message-ID: <ZMukQr8GYFVLyAGa@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
        Amelia Downs <adowns@vmware.com>
References: <20230802020547.28886-1-phil@nwl.cc>
 <s4402816-ros7-qqoq-73r0-147po5s5862p@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s4402816-ros7-qqoq-73r0-147po5s5862p@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 02, 2023 at 10:31:16AM +0200, Jan Engelhardt wrote:
> On Wednesday 2023-08-02 04:05, Phil Sutter wrote:
> >
> >It is not entirely clear what the fixed commit was trying to establish,
> >but the save output is certainly not correct (especially since print
> >callback gets things right).
> >
> >Fixes: fc9237da4e845 ("Fix '-p icmp -m icmp' issue (Closes: #37)")
> 
> """(libipt_icmp.c):
>  * Up to kernel <=2.4.20 the problem was:
>  * '-p icmp ' matches all icmp packets
>  * '-p icmp -m icmp' matches _only_ ICMP type 0 :(
>  * This is now fixed by initializing the field * to icmp type 0xFF
> """
> 
> But also:
> 
> v1.2.7a-35-gfc9237da missed touching *libip6t_icmp6.c*, so
> it was never updated with the same "bug".
> 
> In icmp6, --icmpv6-type was (and still is to this date) mandatory, which means
> `-p icmp6 -m icmp6` would *not* implicitly go match ICMP(v6) type 0 like its
> IPv4 counterpart.
> 
> Then, in v1.4.10-115-g1b8db4f4, libipt_icmp.c more or less accidentally gained
> XTOPT_MAND (possible spill from IPv6 code), therefore `-p icmp -m icmp` would
> also stop implicitly doing ICMP type "any".

Thanks for the forensics.

One could extend icmp6 match (in kernel and user space) to support this
"any" type, though it seems not guaranteed the value 255 won't be used
for a real message at some point. So a proper solution was to support type
ranges like ebtables does. Then "any" type is 0:255/0:255.

Apart from the above, the three patches of this series should be fine,
right?

Thanks, Phil
