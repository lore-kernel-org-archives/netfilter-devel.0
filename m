Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F57FC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 06:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31FDC61108
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 06:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347868AbhIHGyA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Sep 2021 02:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347867AbhIHGx6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 02:53:58 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF5FC061575;
        Tue,  7 Sep 2021 23:52:50 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 18D675871A455; Wed,  8 Sep 2021 08:52:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 14AE660DD5B27;
        Wed,  8 Sep 2021 08:52:49 +0200 (CEST)
Date:   Wed, 8 Sep 2021 08:52:49 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
cc:     Florian Westphal <fw@strlen.de>,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH net v2] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
In-Reply-To: <YTgedODOPAQboQlm@slk1.local.net>
Message-ID: <4o2rqroo-orpr-1so2-4s5n-o1pn8no16553@vanv.qr>
References: <20210907021415.962-1-Cole.Dishington@alliedtelesis.co.nz> <20210907135458.GF23554@breakpoint.cc> <r46nn4-n993-rs28-84sr-o1qop429rr9@vanv.qr> <YTgedODOPAQboQlm@slk1.local.net>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2021-09-08 04:22, Duncan Roe wrote:
>> >Either use if (nat->range_info.min_proto.all || ...
>> >
>> >or use ntohs().  I will leave it up to you if you prefer
>> >ntohs(nat->range_info.min_proto.all) == 0 or
>> >nat->range_info.min_proto.all == ntohs(0).
>>
>> If one has the option, one should always prefer to put htons/htonl on
>> the side with the constant literal;
>> Propagation of constants and compile-time evaluation is the target.
>>
>> That works for some other functions as well (e.g.
>> strlen("fixedstring")).
>
>When comparing against constant zero, why use htons/htonl at all?

Logical correctness.
Remember, it was the sparse tool that complained in the first place.
