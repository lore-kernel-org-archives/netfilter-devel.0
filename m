Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E36BCDB47E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 13:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjJRNDt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 09:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjJRNDs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 09:03:48 -0400
Received: from mail.mutluit.com (mail.mutluit.com [195.201.130.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DB31A3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2023 06:03:46 -0700 (PDT)
Received: from [127.0.0.1] (mail.mutluit.com [195.201.130.20]:43612)
        by mail.mutluit.com (mail.mutluit.com [195.201.130.20]:50025) with ESMTP ([XMail 1.27 ESMTP Server])
        id <S1723131> for <netfilter-devel@vger.kernel.org> from <um@mutluit.com>;
        Wed, 18 Oct 2023 15:03:45 +0200
Subject: Re: [nftables/nft] nft equivalent of "ipset test"
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     imnozi@gmail.com, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
References: <652EC034.7090501@mutluit.com>
 <20231017213507.GD5770@breakpoint.cc> <652F02EC.2050807@mutluit.com>
 <20231017220539.GE5770@breakpoint.cc> <652F0C75.8010006@mutluit.com>
 <20231017200057.57cfce21@playground> <ZS+nJS/4dolCsIk8@calendula>
 <652FAB56.5060200@mutluit.com> <ZS+srsBsJSynJ7Tm@calendula>
 <652FBC5B.5000006@mutluit.com> <ZS/GZxyC4vTx3Ln2@calendula>
From:   "U.Mutlu" <um@mutluit.com>
Organization: mutluit.com
Message-ID: <652FD7B0.7020405@mutluit.com>
Date:   Wed, 18 Oct 2023 15:03:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:40.0) Gecko/20100101
 Firefox/40.0 SeaMonkey/2.37a1
MIME-Version: 1.0
In-Reply-To: <ZS/GZxyC4vTx3Ln2@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso wrote on 10/18/23 13:49:
> On Wed, Oct 18, 2023 at 01:07:07PM +0200, U.Mutlu wrote:
> [...]
>> Lately I've extended this to make it a 2-stage: if blocked IP
>> continues sending more than x packets while in timeout of y minutes,
>> then add this attacker to the second set that has a much higher timeout of z
>> minutes.
>>
>> One additional practical benefit of this approach is that
>> now one sees the hardcore attackers grouped (they are those in set2).
>>
>> The correct managing of these two sets requires the said
>> atomicity by testing of BOTH sets before adding the IP to the first set...
>>
> You should look at nftables concatenations, you do not have to split
> this information accross two sets in nftables. For adding entries from
> packet path, have a look at dynamic sets.
>
> Two sets also means two lookups from packet path.

But as said above, I need a seperate 2nd set anyway,
to be able to see the hardcore attackers.
For example for auto-generating and filing
an Abuse Report to the abuse-address (WHOIS)
of the owning ISP of that attacker/hacker IP.

Your other suggestions make sense, indeed, but ATM
are too advanced for me; I would need some time to
learn these advanced concepts possible in current nftables.
In the meantime iptables with ipset shall suffice for my non-HA needs.  :-)

Thx.


