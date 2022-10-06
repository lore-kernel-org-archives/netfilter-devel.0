Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D8FC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 19:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJFTDK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 15:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiJFTCj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 15:02:39 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887E4C894C
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Oct 2022 12:01:40 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 1CBF0586B5F5C; Thu,  6 Oct 2022 21:01:38 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 1A34B60DBC0D7;
        Thu,  6 Oct 2022 21:01:38 +0200 (CEST)
Date:   Thu, 6 Oct 2022 21:01:38 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 11/12] extensions: Do not print all-one's
 netmasks
In-Reply-To: <Yz7B9DZ2IC6V+bjQ@orbyte.nwl.cc>
Message-ID: <o05060p9-8133-2q2q-69o7-41s9qn62636@vanv.qr>
References: <20221006002802.4917-1-phil@nwl.cc> <20221006002802.4917-12-phil@nwl.cc> <65q0r47-p696-s4p1-25nq-o2q60snqr42@vanv.qr> <Yz7B9DZ2IC6V+bjQ@orbyte.nwl.cc>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2022-10-06 13:54, Phil Sutter wrote:

>> >-	else
>> >+	else if (bits < sizeof(a) * 8)
>> > 		printf("/%d", bits);
>> 
>> I would rather see it stay.
>> - iproute2 also always prints the /128 suffix
>> - test parsers need not special case the absence of /128
>>   [as in, when something reads e.g. iptables-save output]
>
>[...] OTOH we're a bit inconsistent: xtables_ip(6)mask_to_numeric() explicitly
>omits output if it would print "/32" or "/128".

We could consider just changing those two functions.
Any third-party program that interprets our output already has to deal
with a "/N" suffix in the same spot anyway.
