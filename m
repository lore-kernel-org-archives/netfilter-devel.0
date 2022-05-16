Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C00C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 06:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240459AbiEPGxF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 02:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbiEPGxD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 02:53:03 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a11:7980:3::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F55418E10
        for <netfilter-devel@vger.kernel.org>; Sun, 15 May 2022 23:53:03 -0700 (PDT)
Message-ID: <1c529232-3219-2571-77df-84047f594178@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1652683981;
        bh=1ANfxXlJc2stMYYb3vlLxbssmyJm90gC1eVNggFGGzk=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=yekTbZ6zUWoaVAj8eSR5nyHkdRgwZIo6vL5v+LU7kuY7rt8090bPiQvTmWGTzHv8r
         p6v0weRqwZsNgaFICyL8LvbfxAVhxC6NvtU+a4Ogg3D/YSKDHNliKEXfQUTSFHke9+
         0xzHZ8zDWn1ZXEH/5YVWZwWzlHAcFrBVi1hrH3HtbR0chmmlBKL5wwigUdQpz1/caZ
         OhOOVL5Xu711DTu0WNS3dox6j4kCQyeeH0IUeOK9KcZoSEjsbzr22iMvCxdq9xq3k0
         xqqasD/rNBD2zUe1tD3Bzb+mjQg03crNN5139f/eQSnx824zQrvXd068TMS972n1rl
         Djs/qFdgevGJA==
Date:   Mon, 16 May 2022 08:52:59 +0200
MIME-Version: 1.0
Subject: Re: [PATCH iptables 1/2] xtables: fix compilation with musl
Content-Language: en-US
To:     Phil Sutter <phil@nwl.cc>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>
References: <20220514163325.54266-1-vincent@systemli.org>
 <Yn/hMODAkEEbzQno@orbyte.nwl.cc>
 <CANP3RGfP4Et8PCviNLLUJNHBCbo-B53UkaZfZJyqHBu_Ccs3Ow@mail.gmail.com>
 <YoDsbC/hwY9mPLR+@orbyte.nwl.cc>
From:   Nick <vincent@systemli.org>
In-Reply-To: <YoDsbC/hwY9mPLR+@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


>> Ultimately I find
>> https://android.git.corp.google.com/platform/external/iptables/+/7608e136bd495fe734ad18a6897dd4425e1a633b%5E%21/
>>
>> +#ifdef __BIONIC__
>> +#include <linux/if_ether.h> /* ETH_ALEN */
>> +#endif
> While I think musl not catching the "double" include is a bug, I'd
> prefer the ifdef __BIONIC__ solution since it started the "but my libc
> needs this" game.
>
> Nick, if the above change fixes musl builds for you, would you mind
> submitting it formally along with a move of the netinet/ether.h include
> from mid-file to top?
I will test again. :) However, I can not open the 
"android.git.corp.google.com"? Can you maybe link (also for reference) 
to a freely available source?

Bests
Nick
