Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB06C00528
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 19:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjHCTix (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 15:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjHCTiw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 15:38:52 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754083C3D
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 12:38:50 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 0D8EF5872A169; Thu,  3 Aug 2023 21:38:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 05A9760BEC94A;
        Thu,  3 Aug 2023 21:38:48 +0200 (CEST)
Date:   Thu, 3 Aug 2023 21:38:47 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org, Amelia Downs <adowns@vmware.com>
Subject: Re: [iptables PATCH 1/3] extensions: libipt_icmp: Fix confusion
 between 255/255 and any
In-Reply-To: <ZMukQr8GYFVLyAGa@orbyte.nwl.cc>
Message-ID: <p6460n00-n577-2173-sosp-11q275538n0s@vanv.qr>
References: <20230802020547.28886-1-phil@nwl.cc> <s4402816-ros7-qqoq-73r0-147po5s5862p@vanv.qr> <ZMukQr8GYFVLyAGa@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2023-08-03 14:57, Phil Sutter wrote:
>> >
>> >It is not entirely clear what the fixed commit was trying to establish,
>> >but the save output is certainly not correct (especially since print
>> >callback gets things right).
>> 
>> v1.2.7a-35-gfc9237da missed touching *libip6t_icmp6.c*, so
>> it was never updated with the same "bug".[...]
>
>One could extend icmp6 match (in kernel and user space) to support this
>"any" type, though it seems not guaranteed the value 255 won't be used
>for a real message at some point. So a proper solution was to support type
>ranges like ebtables does. Then "any" type is 0:255/0:255.
>
>Apart from the above, the three patches of this series should be fine,
>right?

Yeah.
