Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FEAC001DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Aug 2023 13:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjHDN4P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 09:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjHDN4K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 09:56:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862E73A96
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Aug 2023 06:56:06 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qRvHf-0008BB-OV; Fri, 04 Aug 2023 15:56:03 +0200
Date:   Fri, 4 Aug 2023 15:56:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org, Amelia Downs <adowns@vmware.com>
Subject: Re: [iptables PATCH 1/3] extensions: libipt_icmp: Fix confusion
 between 255/255 and any
Message-ID: <ZM0Dc9WttcsfPhI3@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
        Amelia Downs <adowns@vmware.com>
References: <20230802020547.28886-1-phil@nwl.cc>
 <s4402816-ros7-qqoq-73r0-147po5s5862p@vanv.qr>
 <ZMukQr8GYFVLyAGa@orbyte.nwl.cc>
 <p6460n00-n577-2173-sosp-11q275538n0s@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p6460n00-n577-2173-sosp-11q275538n0s@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 03, 2023 at 09:38:47PM +0200, Jan Engelhardt wrote:
> 
> On Thursday 2023-08-03 14:57, Phil Sutter wrote:
> >> >
> >> >It is not entirely clear what the fixed commit was trying to establish,
> >> >but the save output is certainly not correct (especially since print
> >> >callback gets things right).
> >> 
> >> v1.2.7a-35-gfc9237da missed touching *libip6t_icmp6.c*, so
> >> it was never updated with the same "bug".[...]
> >
> >One could extend icmp6 match (in kernel and user space) to support this
> >"any" type, though it seems not guaranteed the value 255 won't be used
> >for a real message at some point. So a proper solution was to support type
> >ranges like ebtables does. Then "any" type is 0:255/0:255.
> >
> >Apart from the above, the three patches of this series should be fine,
> >right?
> 
> Yeah.

I have applied the series apart from patch 2: The wrong XTOPT_MAND flag
is present since v1.4.11, if anyone actually depends on the behaviour,
they would have complained. So leaving things as they are is fine, and
instead one should go into another direction:

- Drop XTOPT_MAND and instead provide a better error message in
  x6_fcheck callback, pointing out that '-p icmp -m icmp' is equivalent
  to plain '-p icmp'.

- Same for '--icmp-type any'? In theory, it's pointless.

A nicer option would be to turn '-m icmp [--icmp-type any]' into a NOP.
Using '-p icmp' is mandatory anyway. There's no support for matches to
remove themselves, though. I guess this could be done by extending
xtables_option_mfcall().

Cheers, Phil
