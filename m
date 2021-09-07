Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB44C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Sep 2021 15:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD51460E76
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Sep 2021 15:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344937AbhIGPMu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Sep 2021 11:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbhIGPMu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Sep 2021 11:12:50 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13685C061575;
        Tue,  7 Sep 2021 08:11:44 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 2B9DF59F6BDB2; Tue,  7 Sep 2021 17:11:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 288A36168CF3D;
        Tue,  7 Sep 2021 17:11:42 +0200 (CEST)
Date:   Tue, 7 Sep 2021 17:11:42 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Florian Westphal <fw@strlen.de>
cc:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH net v2] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
In-Reply-To: <20210907135458.GF23554@breakpoint.cc>
Message-ID: <r46nn4-n993-rs28-84sr-o1qop429rr9@vanv.qr>
References: <20210907021415.962-1-Cole.Dishington@alliedtelesis.co.nz> <20210907135458.GF23554@breakpoint.cc>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2021-09-07 15:54, Florian Westphal wrote:
>> -	/* Try to get same port: if not, try to change it. */
>> -	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
>> -		int ret;
>> +	if (htons(nat->range_info.min_proto.all) == 0 ||
>> +	    htons(nat->range_info.max_proto.all) == 0) {
>
>Either use if (nat->range_info.min_proto.all || ...
>
>or use ntohs().  I will leave it up to you if you prefer
>ntohs(nat->range_info.min_proto.all) == 0 or
>nat->range_info.min_proto.all == ntohs(0).

If one has the option, one should always prefer to put htons/htonl on 
the side with the constant literal;
Propagation of constants and compile-time evaluation is the target.

That works for some other functions as well (e.g. 
strlen("fixedstring")).
