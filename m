Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06659EB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jul 2023 11:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjGSLbf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jul 2023 07:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjGSLbe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2023 07:31:34 -0400
X-Greylist: delayed 59362 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Jul 2023 04:31:31 PDT
Received: from smtp01.easynet.dev (smtp01.easynet.dev [IPv6:2a00:ece1:2:10::1:110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E387E10D4
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2023 04:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=easynet.dev; s=mail;
        t=1689766288; bh=OxH8GWjJVSfobM7s2S+TvSBVleb6bPlFnhQXkhYRMbI=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=uDPWnW7K0372kIlIOF2yGNRb4PTuCLv37ffVouoWZKENls06IQVbZJ35ItEFZnSZv
         zUjGS6AW2ktKwA7SW2jV35u6y6kb79i9KikJhQSKf70cI3zBZIXordezp8JWQssOzk
         W3+HK2juBd+sYx6pPo/D58aA5DhYyt5vi19C99rtUD6WegKePBN36+jM+tqhEzl9f4
         PRy9J2Ycj4GZHiH06LuurggOFxn8qzBc9W2Xj2BFV7xHoFdjbinl5CiIYwtFGGdbzY
         ZLCbCg9v4ORuXAgoyM4TOStIyNZdZxajk4zFSdm5jkb159dlCAd1BduXvUeKmT0D90
         F3jibxHyGqGBw==
Received: from [192.168.55.102] (unknown [89.38.58.13])
        (Authenticated sender: adrian@easynet.dev)
        by smtp1.easynet.dev (Postfix) with ESMTPSA id 6C18160035;
        Wed, 19 Jul 2023 14:31:28 +0300 (EEST)
Message-ID: <f0138f3a-ac95-a0fc-206b-f3f3ba5977e1@easynet.dev>
Date:   Wed, 19 Jul 2023 13:31:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: libnftnl adding element to a set of type ipv4_addr or ipv6_addr
Content-Language: en-US
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
References: <ff54bc23-95f3-8300-c9d4-e5d74581a0e7@easynet.dev>
 <ZLfAshHpX+Zqp6Mh@orbyte.nwl.cc>
From:   Easynet <devel@easynet.dev>
Organization: EasyNet Consulting SRL
In-Reply-To: <ZLfAshHpX+Zqp6Mh@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

Thanks for the answer. That's a very good idea. Today I saw the example 
sources of nftables using nft_run_cmd_from_buffer and I was wondering 
perhaps if I can use this function somehow.
I will simplify my code a lot. It will not be necessary to build all 
code for my mini-firewall tool and I think the foot print will be reduced.

Thanks for the idea!

Cheers.

On 7/19/2023 12:53 PM, Phil Sutter wrote:
> Hi,
>
> On Tue, Jul 18, 2023 at 09:02:02PM +0200, Easynet wrote:
>> I'm building a small firewall daemon that it receives if an user is
>> authenticated and then is adding his IP in a set to be allowed for 24h.
>> I'm new in nftnl library and I started to read the documentation and
>> also the examples.
>>
>> Until now I was able to add in my daemon these tools based on libnftnl:
>>
>> - create / delete / get tables
>> - create / delete chains
>> - create / delete sets.
>>
>> Right now I'm facing an issue that I can't understand how to build the
>> nftnl packet for adding an element to my set, which has interval and
>> timeout flags.
> With libnftnl, source is documentation. Go check nftables code on how to
> use it. If you need a simpler interface to nftables, I highly recommend
> using libnftables instead. You'll either have to pass strings or use a
> JSON library for structured in- and output. For simple things such as
> adding an element to a set, it more or less boils down to:
>
> | struct nft_ctx *ctx = nft_ctx_new(NFT_CTX_DEFAULT);
> | nft_run_cmd_from_buffer(ctx, "add element mytable myset { 123 }");
> | nft_ctx_free(ctx);
>
> Cheers, Phil

