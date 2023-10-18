Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56554CDB47E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 11:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjJRLHQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 07:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjJRLHP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 07:07:15 -0400
Received: from mail.mutluit.com (mail.mutluit.com [195.201.130.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E62110E
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2023 04:07:08 -0700 (PDT)
Received: from [127.0.0.1] (mail.mutluit.com [195.201.130.20]:44680)
        by mail.mutluit.com (mail.mutluit.com [195.201.130.20]:50025) with ESMTP ([XMail 1.27 ESMTP Server])
        id <S1723126> for <netfilter-devel@vger.kernel.org> from <um@mutluit.com>;
        Wed, 18 Oct 2023 13:07:07 +0200
Subject: Re: [nftables/nft] nft equivalent of "ipset test"
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     imnozi@gmail.com, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
References: <652EC034.7090501@mutluit.com>
 <20231017213507.GD5770@breakpoint.cc> <652F02EC.2050807@mutluit.com>
 <20231017220539.GE5770@breakpoint.cc> <652F0C75.8010006@mutluit.com>
 <20231017200057.57cfce21@playground> <ZS+nJS/4dolCsIk8@calendula>
 <652FAB56.5060200@mutluit.com> <ZS+srsBsJSynJ7Tm@calendula>
From:   "U.Mutlu" <um@mutluit.com>
Organization: mutluit.com
Message-ID: <652FBC5B.5000006@mutluit.com>
Date:   Wed, 18 Oct 2023 13:07:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:40.0) Gecko/20100101
 Firefox/40.0 SeaMonkey/2.37a1
MIME-Version: 1.0
In-Reply-To: <ZS+srsBsJSynJ7Tm@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso wrote on 10/18/23 12:00:
> On Wed, Oct 18, 2023 at 11:54:30AM +0200, U.Mutlu wrote:
>> Pablo Neira Ayuso wrote on 10/18/23 11:36:
>>> On Tue, Oct 17, 2023 at 08:00:57PM -0400, imnozi@gmail.com wrote:
>>>> On Wed, 18 Oct 2023 00:36:37 +0200
>>>> "U.Mutlu" <um@mutluit.com> wrote:
>>>>
>>>>> ...
>>>>> Actualy I need to do this monster:   :-)
>>>>>
>>>>> IP="1.2.3.4"
>>>>> ! nft "get element inet mytable myset  { $IP }" > /dev/null 2>&1 && \
>>>>> ! nft "get element inet mytable myset2 { $IP }" > /dev/null 2>&1 && \
>>>>>      nft "add element inet mytable myset  { $IP }"
>>>>
>>>> Try using '||', akin to:
>>>
>>> Please, use 'nft create' for this, no need for an explicit test and
>>> then add from command line.
>>>
>>> The idiom above is an antipattern, because it is not atomic, the
>>> 'create' command provides a way to first test if the element exists
>>> (if so it fails) then add it.
>>
>> Pablo, unfortunately your solution with 'create' cannot be used
>> in my above said special use-case of testing first in BOTH sets...
>
> 'ipset test' also requires a set to be specified.

Of course, what else! :-) And I haven't said anything different.

>> I just don't understand why the author cannot simply add a real 'test'
>> function to the nft tool...
>
> I just don't understand your usecase :-), why do you need this atomic
> check on two different sets?
>
> Could you explain your ruleset in more detail?

It's maybe complicated: I've a restrictive firewall where
the default is to block all ports for traffic from INPUT,
except those explicitly allowed.

Then, at the end of the firewall rules I can _auto-add_ all
the unhandled IPs to such a set for blocking. The blocking
happens at top by testing whether the IP is in that set.

But another feature of this solution is that not only
the firewall can (auto-) add IPs to the set for blocking,
but also the external handlers after ACCEPT can do it,
ie. say a mailserver. It too has to be able to add an IP
to the same set for  blocking. The blockign itself happens
centrally in the firewall script at the next attempt of the attacker.

Lately I've extended this to make it a 2-stage: if blocked IP
continues sending more than x packets while in timeout of y minutes,
then add this attacker to the second set that has a much higher timeout of z 
minutes.
One additional practical benefit of this approach is that
now one sees the hardcore attackers grouped (they are those in set2).

The correct managing of these two sets requires the said
atomicity by testing of BOTH sets before adding the IP to the first set...

If you have got a better solution for this use-case,
so let me/us know please. As said I'm new even to ipset
but which I find very effective & useful in practice.
As said I'm still continuing using iptables with ipset,
just evaluating whether it would make sense to switch to nftables/nft,
though the learning-curve seems not that small, IMO.


