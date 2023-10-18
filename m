Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FCBCDB47E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 10:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjJRKCu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 06:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjJRKCu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 06:02:50 -0400
X-Greylist: delayed 496 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 Oct 2023 03:02:48 PDT
Received: from mail.mutluit.com (mail.mutluit.com [195.201.130.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6993AF7
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2023 03:02:48 -0700 (PDT)
Received: from [127.0.0.1] (mail.mutluit.com [195.201.130.20]:56780)
        by mail.mutluit.com (mail.mutluit.com [195.201.130.20]:50025) with ESMTP ([XMail 1.27 ESMTP Server])
        id <S172311E> for <netfilter-devel@vger.kernel.org> from <um@mutluit.com>;
        Wed, 18 Oct 2023 11:54:31 +0200
Subject: Re: [nftables/nft] nft equivalent of "ipset test"
To:     Pablo Neira Ayuso <pablo@netfilter.org>, imnozi@gmail.com
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
References: <652EC034.7090501@mutluit.com>
 <20231017213507.GD5770@breakpoint.cc> <652F02EC.2050807@mutluit.com>
 <20231017220539.GE5770@breakpoint.cc> <652F0C75.8010006@mutluit.com>
 <20231017200057.57cfce21@playground> <ZS+nJS/4dolCsIk8@calendula>
From:   "U.Mutlu" <um@mutluit.com>
Organization: mutluit.com
Message-ID: <652FAB56.5060200@mutluit.com>
Date:   Wed, 18 Oct 2023 11:54:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:40.0) Gecko/20100101
 Firefox/40.0 SeaMonkey/2.37a1
MIME-Version: 1.0
In-Reply-To: <ZS+nJS/4dolCsIk8@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso wrote on 10/18/23 11:36:
> On Tue, Oct 17, 2023 at 08:00:57PM -0400, imnozi@gmail.com wrote:
>> On Wed, 18 Oct 2023 00:36:37 +0200
>> "U.Mutlu" <um@mutluit.com> wrote:
>>
>>> ...
>>> Actualy I need to do this monster:   :-)
>>>
>>> IP="1.2.3.4"
>>> ! nft "get element inet mytable myset  { $IP }" > /dev/null 2>&1 && \
>>> ! nft "get element inet mytable myset2 { $IP }" > /dev/null 2>&1 && \
>>>     nft "add element inet mytable myset  { $IP }"
>>
>> Try using '||', akin to:
>
> Please, use 'nft create' for this, no need for an explicit test and
> then add from command line.
>
> The idiom above is an antipattern, because it is not atomic, the
> 'create' command provides a way to first test if the element exists
> (if so it fails) then add it.

Pablo, unfortunately your solution with 'create' cannot be used
in my above said special use-case of testing first in BOTH sets...

I just don't understand why the author cannot simply add a real 'test' 
function to the nft tool...
The logic is already in 'get element' and also in your 'create' method.

PS: I'm not yet subscribed to netfilter-dev, so CC may fail...

